package ychatapp.Servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.google.gson.JsonObject;
import ychatapp.model.beans.UsersBeans;
import ychatapp.model.bo.EmailService;

@WebServlet("/OTPVerificationServlet")
public class OTPVerificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonRes = new JsonObject();

        String action = request.getParameter("action");
        HttpSession session = request.getSession(true);

        if ("sendOTP".equalsIgnoreCase(action)) {
            UsersBeans user = (UsersBeans) session.getAttribute("ub");
            String email = request.getParameter("email");
            
            if (email == null || email.trim().isEmpty()) {
                if (user != null) email = user.getEmail();
            }

            if (email == null || email.trim().isEmpty()) {
                jsonRes.addProperty("status", "error");
                jsonRes.addProperty("message", "Email address is required.");
                out.print(jsonRes.toString());
                return;
            }

            String otpCode = String.format("%06d", new Random().nextInt(900000) + 100000);
            session.setAttribute("2fa_otp_code", otpCode);
            session.setAttribute("2fa_otp_expiry", System.currentTimeMillis() + (5 * 60 * 1000)); // 5 mins

            String userName = (user != null) ? user.getName() : "User";
            boolean sent = EmailService.sendVerificationEmail(email.trim(), userName, otpCode);

            jsonRes.addProperty("status", "success");
            jsonRes.addProperty("message", sent ? "Verification code sent to your email!" : "Verification code generated: " + otpCode + " (Console Log)");
            jsonRes.addProperty("otpCode", otpCode); // Included for development/demo ease
        } else if ("verifyOTP".equalsIgnoreCase(action)) {
            String inputCode = request.getParameter("otpCode");
            String sessionCode = (String) session.getAttribute("2fa_otp_code");
            Long expiry = (Long) session.getAttribute("2fa_otp_expiry");

            if (inputCode == null || sessionCode == null || expiry == null) {
                jsonRes.addProperty("status", "error");
                jsonRes.addProperty("message", "No OTP request found. Please request a new code.");
            } else if (System.currentTimeMillis() > expiry) {
                jsonRes.addProperty("status", "error");
                jsonRes.addProperty("message", "OTP has expired. Please request a new code.");
            } else if (inputCode.trim().equals(sessionCode.trim())) {
                session.setAttribute("2fa_verified", true);
                jsonRes.addProperty("status", "success");
                jsonRes.addProperty("message", "2FA Verification successful!");
            } else {
                jsonRes.addProperty("status", "error");
                jsonRes.addProperty("message", "Invalid OTP verification code.");
            }
        } else {
            jsonRes.addProperty("status", "error");
            jsonRes.addProperty("message", "Unknown action");
        }

        out.print(jsonRes.toString());
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
