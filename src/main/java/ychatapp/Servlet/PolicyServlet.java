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

@WebServlet("/PolicyServlet")
public class PolicyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/jsp/policy.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UsersBeans ub = (UsersBeans) session.getAttribute("ub");
        
        Integer userId = null;
        if (ub != null) {
            userId = ub.getId();
        }

        String email = request.getParameter("email");
        String claimType = request.getParameter("claimType");
        String description = request.getParameter("description");

        if (email == null || email.trim().isEmpty() || 
            claimType == null || claimType.trim().isEmpty() || 
            description == null || description.trim().isEmpty()) {
            response.sendRedirect("PolicyServlet?error=missing_fields");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO user_claims (user_id, email, claim_type, description) VALUES (?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                if (userId != null) {
                    ps.setInt(1, userId);
                } else {
                    ps.setNull(1, java.sql.Types.INTEGER);
                }
                ps.setString(2, email);
                ps.setString(3, claimType);
                ps.setString(4, description);
                ps.executeUpdate();
            }
            response.sendRedirect("PolicyServlet?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("PolicyServlet?error=database_error");
        }
    }
}
