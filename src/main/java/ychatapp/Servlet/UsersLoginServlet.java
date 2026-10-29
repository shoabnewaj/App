package ychatapp.Servlet;

import java.io.IOException;

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

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");

        // Populate saved email from Remember Me cookie if present
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("rem_email".equals(c.getName())) {
                    req.setAttribute("savedEmail", c.getValue());
                    break;
                }
            }
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
                session.removeAttribute("temp_2fa_user");
                session.removeAttribute("2fa_otp_code");
                session.removeAttribute("2fa_otp_expiry");

                session.setAttribute("ub", tempUb);
                session.setAttribute("userId", tempUb.getId());
                session.setAttribute("isAdmin", tempUb.isAdmin());

                // Record active session in SessionDAO
                new ychatapp.model.dao.SessionDAO().createSession(tempUb.getId(), session.getId(), req.getRemoteAddr(), req.getHeader("User-Agent"));

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

            // Check Two-Factor Authentication (2FA)
            if (ub.isTwoFactorEnabled()) {
                HttpSession session = req.getSession(false);
                if (session != null) session.invalidate();
                HttpSession tempSession = req.getSession(true);

                String otp = String.format("%06d", new java.util.Random().nextInt(900000) + 100000);
                tempSession.setAttribute("temp_2fa_user", ub);
                tempSession.setAttribute("2fa_otp_code", otp);
                tempSession.setAttribute("2fa_otp_expiry", System.currentTimeMillis() + (5 * 60 * 1000)); // 5 mins

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

            // Remember Me (save email for prefilling)
            String remember = req.getParameter("remember");
            if (remember != null) {
                Cookie cEmail = new Cookie("rem_email", email.trim());
                cEmail.setPath("/");
                cEmail.setMaxAge(60 * 60 * 24 * 30); // 30 days
                res.addCookie(cEmail);
            } else {
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