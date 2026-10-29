package ychatapp.Servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ychatapp.model.beans.UsersBeans;

@WebServlet({"/aiDashboard", "/AIDashboardServlet", "/AIDashboard"})
public class AIDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("ub") == null) {
            res.sendRedirect("UsersLoginServlet");
            return;
        }

        UsersBeans ub = (UsersBeans) session.getAttribute("ub");
        req.setAttribute("ub", ub);

        // Check if API Key is configured and starts with standard prefix 'AIzaSy'
        String currentKey = ychatapp.model.bo.GeminiService.getApiKey();
        boolean isConfigured = (currentKey != null && currentKey.trim().startsWith("AIzaSy"));
        req.setAttribute("isApiKeyConfigured", isConfigured);
        req.setAttribute("currentApiKey", isConfigured ? currentKey : "");

        req.getRequestDispatcher("/WEB-INF/jsp/aiDashboard.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("ub") == null) {
            res.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            res.setContentType("application/json");
            res.getWriter().write("{\"success\":false,\"message\":\"Unauthorized\"}");
            return;
        }

        String apiKey = req.getParameter("apiKey");
        if (apiKey == null || apiKey.trim().isEmpty()) {
            res.setContentType("application/json");
            res.getWriter().write("{\"success\":false,\"message\":\"API Key cannot be empty\"}");
            return;
        }
        if (!apiKey.trim().startsWith("AIzaSy")) {
            res.setContentType("application/json");
            res.getWriter().write("{\"success\":false,\"message\":\"Invalid API Key! A valid Gemini API Key must start with 'AIzaSy'.\"}");
            return;
        }

        boolean success = ychatapp.model.bo.GeminiService.saveApiKey(apiKey);
        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");
        if (success) {
            res.getWriter().write("{\"success\":true,\"message\":\"API Key successfully updated!\"}");
        } else {
            res.getWriter().write("{\"success\":false,\"message\":\"Failed to persist API Key.\"}");
        }
    }
}
