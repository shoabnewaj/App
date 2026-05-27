package ychatapp.Servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.UsersDAO;
import ychatapp.model.dao.DBConnection;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UsersBeans ub = (UsersBeans) session.getAttribute("ub");

        // 🔒 login check
        if (ub == null) {
            response.sendRedirect("UsersLoginServlet");
            return;
        }

        // 🔒 admin authorization check
        String email = ub.getEmail();
        boolean isAdmin = "admin@gmail.com".equalsIgnoreCase(email) 
                       || "shoabnewaj81@gmail.com".equalsIgnoreCase(email)
                       || "newaj@xxx.jp".equalsIgnoreCase(email);
        




























































        // 🔒 login check
        if (ub == null) {
            response.sendRedirect("UsersLoginServlet");
            return;
        }

        // 🔒 admin authorization check
        String email = ub.getEmail();
        boolean isAdmin = "admin@gmail.com".equalsIgnoreCase(email) 
                       || "shoabnewaj81@gmail.com".equalsIgnoreCase(email)
                       || "newaj@xxx.jp".equalsIgnoreCase(email);
        
        if (!isAdmin) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: You do not have admin privileges.");
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equalsIgnoreCase(action)) {
            String userIdParam = request.getParameter("userId");
            if (userIdParam != null && !userIdParam.isEmpty()) {
                try {
                    int userId = Integer.parseInt(userIdParam);
                    UsersDAO usersDAO = new UsersDAO();
                    boolean success = usersDAO.deleteUser(userId);
                    if (success) {
                        // If deleting oneself, logout
                        if (userId == ub.getId()) {
                            session.invalidate();
                            response.sendRedirect("UsersLoginServlet");
                            return;
                        }
                        response.sendRedirect("AdminServlet?msg=success");
                        return;
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        }
        response.sendRedirect("AdminServlet?msg=error");
    }
}
