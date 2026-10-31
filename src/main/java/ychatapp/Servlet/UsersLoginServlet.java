package ychatapp.Servlet;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.bo.UsersLogic;
import ychatapp.model.dao.UsersDAO;

@WebServlet("/UsersLoginServlet")
public class UsersLoginServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;

    public static String generateRememberToken(UsersBeans user) {
        if (user == null || user.getEmail() == null) return null;
        try {
            String data = user.getId() + ":" + user.getEmail().toLowerCase().trim() + ":YChatAppSecret2026TokenKey";
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder hex = new StringBuilder();
            for (byte b : hash) {
                String h = Integer.toHexString(0xff & b);
                if (h.length() == 1) hex.append('0');
                hex.append(h);
            }
            return user.getId() + "_" + hex.toString();
        } catch (Exception e) {
            return null;
        }
    }

    public static UsersBeans validateRememberToken(String token) {
        if (token == null || !token.contains("_")) return null;
        try {
            String[] parts = token.split("_", 2);
            int userId = Integer.parseInt(parts[0]);
            UsersDAO dao = new UsersDAO();
            UsersBeans user = dao.getUserById(userId);
            if (user == null) return null;
            String expected = generateRememberToken(user);
            if (expected != null && expected.equals(token)) {
                return user;
            }
        } catch (Exception e) {
            // invalid token format
        }
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");

        // 1. If active session already exists, skip login and redirect to feed
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("ub") != null) {
            res.sendRedirect("UsersPostServlet");
            return;
        }

        // 2. Check Remember Me cookies
        Cookie[] cookies = req.getCookies();
        String remToken = null;
        String savedEmail = null;
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("rem_token".equals(c.getName())) {
                    remToken = c.getValue();
                } else if ("rem_email".equals(c.getName())) {
                    savedEmail = c.getValue();
                }
            }
        }

        // 3. Auto-login if valid remember token is present
        if (remToken != null && !remToken.isEmpty()) {
            UsersBeans rememberedUser = validateRememberToken(remToken);
            if (rememberedUser != null && !rememberedUser.isBanned()) {
                HttpSession newSession = req.getSession(true);
                newSession.setAttribute("ub", rememberedUser);
                newSession.setAttribute("userId", rememberedUser.getId());
                newSession.setAttribute("isAdmin", rememberedUser.isAdmin());

                // Record active session
                try {
                    new ychatapp.model.dao.SessionDAO().createSession(rememberedUser.getId(), newSession.getId(), req.getRemoteAddr(), req.getHeader("User-Agent"));
                } catch (Exception ignored) {}

                res.sendRedirect("UsersPostServlet");
                return;
            }
        }

        if (savedEmail != null) {
            req.setAttribute("savedEmail", savedEmail);
        }
        
        req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        if ("verify2FA".equalsIgnoreCase(action)) {
            HttpSession session = req.getSession(false);
            UsersBeans tempUb = (session != null) ? (UsersBeans) session.getAttribute("temp_2fa_user") : null;
            String sessionCode = (session != null) ? (String) session.getAttribute("2fa_otp_code") : null;
            Long expiry = (session != null) ? (Long) session.getAttribute("2fa_otp_expiry") : null;
            String inputCode = req.getParameter("otpCode");
            if (inputCode == null || inputCode.isEmpty()) {
                inputCode = req.getParameter("otp");
            }

            res.setContentType("application/json;charset=UTF-8");
            if (tempUb == null || sessionCode == null || expiry == null) {
                res.getWriter().write("{\"success\":false,\"message\":\"No 2FA session found. Please log in again.\"}");
                return;
            }
            if (System.currentTimeMillis() > expiry) {
                res.getWriter().write("{\"success\":false,\"message\":\"Verification code has expired. Please log in again.\"}");
                return;
            }
            if (inputCode != null && inputCode.trim().equals(sessionCode.trim())) {
                String tempRemember = (String) session.getAttribute("temp_remember");

                session.removeAttribute("temp_2fa_user");
                session.removeAttribute("2fa_otp_code");
                session.removeAttribute("2fa_otp_expiry");
                session.removeAttribute("temp_remember");

                session.setAttribute("ub", tempUb);
                session.setAttribute("userId", tempUb.getId());
                session.setAttribute("isAdmin", tempUb.isAdmin());

                // Record active session in SessionDAO
                new ychatapp.model.dao.SessionDAO().createSession(tempUb.getId(), session.getId(), req.getRemoteAddr(), req.getHeader("User-Agent"));

                if ("true".equals(tempRemember)) {
                    String token = generateRememberToken(tempUb);
                    if (token != null) {
                        Cookie cToken = new Cookie("rem_token", token);
                        cToken.setPath("/");
                        cToken.setMaxAge(60 * 60 * 24 * 30);
                        cToken.setHttpOnly(true);
                        res.addCookie(cToken);
                    }
                    Cookie cEmail = new Cookie("rem_email", tempUb.getEmail());
                    cEmail.setPath("/");
                    cEmail.setMaxAge(60 * 60 * 24 * 30);
                    res.addCookie(cEmail);
                }

                res.getWriter().write("{\"success\":true,\"redirect\":\"UsersPostServlet\"}");
            } else {
                res.getWriter().write("{\"success\":false,\"message\":\"Invalid verification code. Please try again.\"}");
            }
            return;
        }

        String email = req.getParameter("email");
        String pass = req.getParameter("pass");

        String isAjax = req.getParameter("ajax");

        if (email == null || email.trim().isEmpty() || pass == null || pass.trim().isEmpty()) {
            if ("true".equals(isAjax)) {
                res.setContentType("application/json;charset=UTF-8");
                res.getWriter().write("{\"success\":false,\"message\":\"Email and Password cannot be empty\"}");
            } else {
                req.setAttribute("errorMsg", "Email and Password cannot be empty");
                req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, res);
            }
            return;
        }

        UsersBeans input = new UsersBeans();
        input.setEmail(email.trim());
        input.setPass(pass);

        UsersBeans ub = UsersLogic.login(input);

        if (ub != null) {
            // Ban check - blocked banned users
            if (ub.isBanned()) {
                if ("true".equals(isAjax)) {
                    res.setContentType("application/json;charset=UTF-8");
                    res.getWriter().write("{\"success\":false,\"message\":\"Your account has been banned. Please contact support.\"}");
                } else {
                    req.setAttribute("errorMsg", "Your account has been banned. Please contact support.");
                    req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, res);
                }
                return;
            }

            String remember = req.getParameter("remember");

            // Check Two-Factor Authentication (2FA)
            if (ub.isTwoFactorEnabled()) {
                HttpSession session = req.getSession(false);
                if (session != null) session.invalidate();
                HttpSession tempSession = req.getSession(true);

                String otp = String.format("%06d", new java.util.Random().nextInt(900000) + 100000);
                tempSession.setAttribute("temp_2fa_user", ub);
                tempSession.setAttribute("2fa_otp_code", otp);
                tempSession.setAttribute("2fa_otp_expiry", System.currentTimeMillis() + (5 * 60 * 1000)); // 5 mins
                if (remember != null) {
                    tempSession.setAttribute("temp_remember", "true");
                }

                // Send email
                boolean sent = ychatapp.model.bo.EmailService.sendVerificationEmail(ub.getEmail(), ub.getName(), otp);

                if ("true".equals(isAjax)) {
                    res.setContentType("application/json;charset=UTF-8");
                    res.getWriter().write("{\"success\":true,\"requires2FA\":true,\"email\":\"" + maskEmail(ub.getEmail()) + "\",\"otpDev\":\"" + otp + "\"}");
                } else {
                    req.setAttribute("requires2FA", true);
                    req.setAttribute("maskedEmail", maskEmail(ub.getEmail()));
                    req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, res);
                }
                return;
            }

            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate(); 
            }
            
            HttpSession newSession = req.getSession(true);
            newSession.setAttribute("ub", ub);
            newSession.setAttribute("userId", ub.getId());
            newSession.setAttribute("isAdmin", ub.isAdmin());

            // Record active session
            new ychatapp.model.dao.SessionDAO().createSession(ub.getId(), newSession.getId(), req.getRemoteAddr(), req.getHeader("User-Agent"));

            // Remember Me (saves both token for auto-login and email for autofill)
            if (remember != null) {
                String token = generateRememberToken(ub);
                if (token != null) {
                    Cookie cToken = new Cookie("rem_token", token);
                    cToken.setPath("/");
                    cToken.setMaxAge(60 * 60 * 24 * 30); // 30 days
                    cToken.setHttpOnly(true);
                    res.addCookie(cToken);
                }

                Cookie cEmail = new Cookie("rem_email", email.trim());
                cEmail.setPath("/");
                cEmail.setMaxAge(60 * 60 * 24 * 30); // 30 days
                res.addCookie(cEmail);
            } else {
                Cookie cToken = new Cookie("rem_token", "");
                cToken.setPath("/");
                cToken.setMaxAge(0);
                res.addCookie(cToken);

                Cookie cEmail = new Cookie("rem_email", "");
                cEmail.setPath("/");
                cEmail.setMaxAge(0);
                res.addCookie(cEmail);

                Cookie cPass = new Cookie("rem_pass", "");
                cPass.setPath("/");
                cPass.setMaxAge(0);
                res.addCookie(cPass);
            }
            
            if ("true".equals(isAjax)) {
                res.setContentType("application/json;charset=UTF-8");
                res.getWriter().write("{\"success\":true,\"redirect\":\"UsersPostServlet\"}");
            } else {
                res.sendRedirect("UsersPostServlet");
            }
        } else {
            if ("true".equals(isAjax)) {
                res.setContentType("application/json;charset=UTF-8");
                res.getWriter().write("{\"success\":false,\"message\":\"Invalid email or password\"}");
            } else {
                req.setAttribute("errorMsg", "Invalid email or password");
                req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, res);
            }
        }
    }

    private String maskEmail(String email) {
        if (email == null || !email.contains("@")) return email;
        String[] parts = email.split("@", 2);
        String name = parts[0];
        if (name.length() <= 2) return name.charAt(0) + "***@" + parts[1];
        return name.substring(0, 2) + "***@" + parts[1];
    }
}
