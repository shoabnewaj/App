package ychatapp.Servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.DBConnection;
import ychatapp.model.dao.HiddenContentDAO;

@WebServlet("/ReportHideServlet")
public class ReportHideServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final HiddenContentDAO hiddenContentDAO = new HiddenContentDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        handleRequest(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        handleRequest(request, response);
    }

    private void handleRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        UsersBeans ub = (UsersBeans) session.getAttribute("ub");
        if (ub == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"Not logged in\"}");
            return;
        }

        int userId = ub.getId();
        String action = request.getParameter("action");
        String type = request.getParameter("type"); // POST, COMMENT, REPLY
        String idStr = request.getParameter("id");

        if (action == null || type == null || idStr == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"Missing parameters\"}");
            return;
        }

        int itemId;
        try {
            itemId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\":false,\"message\":\"Invalid ID\"}");
            return;
        }

        if ("hide".equalsIgnoreCase(action)) {
            boolean success = hiddenContentDAO.hideItem(userId, type, itemId);
            response.getWriter().write("{\"success\":" + success + "}");
        } else if ("report".equalsIgnoreCase(action)) {
            String reason = request.getParameter("reason");
            String details = request.getParameter("details");
            if (reason == null) reason = "Not specified";
            if (details == null) details = "";

            String claimType = type.toUpperCase() + "_REPORT"; // e.g. POST_REPORT, COMMENT_REPORT, REPLY_REPORT
            String description = "Reported Item ID: " + itemId + "\nReason: " + reason + "\nDetails: " + details;

            try (Connection conn = DBConnection.getConnection()) {
                String sql = "INSERT INTO user_claims (user_id, email, claim_type, description) VALUES (?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, userId);
                    ps.setString(2, ub.getEmail() != null ? ub.getEmail() : "anonymous@y-chat.com");
                    ps.setString(3, claimType);
                    ps.setString(4, description);
                    ps.executeUpdate();
                }
                response.getWriter().write("{\"success\":true}");
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().write("{\"success\":false,\"message\":\"Database error\"}");
            }
        } else {
            response.getWriter().write("{\"success\":false,\"message\":\"Unknown action\"}");
        }
    }
}
