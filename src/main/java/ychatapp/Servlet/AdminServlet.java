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
import ychatapp.model.beans.UserClaimBeans;
import ychatapp.model.dao.UsersDAO;
import ychatapp.model.dao.DBConnection;

@WebServlet({"/AdminServlet", "/admin"})
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

        // 白 admin authorization check
        boolean isAdmin = ub.isAdmin();
        if (!isAdmin) {
            String email = ub.getEmail();
            if (email != null) {
                isAdmin = "admin@gmail.com".equalsIgnoreCase(email) 
                       || "shoabnewaj81@gmail.com".equalsIgnoreCase(email)
                       || "newaj@xxx.jp".equalsIgnoreCase(email);
            }
        }
        
        if (!isAdmin) {
            request.setAttribute("userEmail", ub.getEmail());
            request.getRequestDispatcher("/WEB-INF/jsp/admin_access_denied.jsp").forward(request, response);
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
            response.sendRedirect("AdminServlet?msg=error");
            return;
        } else if ("resolve_claim".equalsIgnoreCase(action)) {
            String claimIdParam = request.getParameter("claimId");
            if (claimIdParam != null && !claimIdParam.isEmpty()) {
                try (Connection conn = DBConnection.getConnection()) {
                    int claimId = Integer.parseInt(claimIdParam);
                    try (PreparedStatement ps = conn.prepareStatement("UPDATE user_claims SET status = 'RESOLVED' WHERE id = ?")) {
                        ps.setInt(1, claimId);
                        ps.executeUpdate();
                    }
                    response.sendRedirect("AdminServlet?msg=claim_resolved");
                    return;
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect("AdminServlet?msg=error");
            return;
        } else if ("delete_claim".equalsIgnoreCase(action)) {
            String claimIdParam = request.getParameter("claimId");
            if (claimIdParam != null && !claimIdParam.isEmpty()) {
                try (Connection conn = DBConnection.getConnection()) {
                    int claimId = Integer.parseInt(claimIdParam);
                    try (PreparedStatement ps = conn.prepareStatement("DELETE FROM user_claims WHERE id = ?")) {
                        ps.setInt(1, claimId);
                        ps.executeUpdate();
                    }
                    response.sendRedirect("AdminServlet?msg=claim_deleted");
                    return;
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect("AdminServlet?msg=error");
            return;
        } else if ("ban_user".equalsIgnoreCase(action)) {
            String userIdParam = request.getParameter("userId");
            if (userIdParam != null && !userIdParam.isEmpty()) {
                try (Connection conn = DBConnection.getConnection()) {
                    int userId = Integer.parseInt(userIdParam);
                    try (PreparedStatement ps = conn.prepareStatement("UPDATE users SET is_banned = 1 WHERE id = ?")) {
                        ps.setInt(1, userId);
                        ps.executeUpdate();
                    }
                    response.sendRedirect("AdminServlet?msg=user_banned");
                    return;
                } catch (Exception e) { e.printStackTrace(); }
            }
            response.sendRedirect("AdminServlet?msg=error");
            return;
        } else if ("unban_user".equalsIgnoreCase(action)) {
            String userIdParam = request.getParameter("userId");
            if (userIdParam != null && !userIdParam.isEmpty()) {
                try (Connection conn = DBConnection.getConnection()) {
                    int userId = Integer.parseInt(userIdParam);
                    try (PreparedStatement ps = conn.prepareStatement("UPDATE users SET is_banned = 0 WHERE id = ?")) {
                        ps.setInt(1, userId);
                        ps.executeUpdate();
                    }
                    response.sendRedirect("AdminServlet?msg=user_unbanned");
                    return;
                } catch (Exception e) { e.printStackTrace(); }
            }
            response.sendRedirect("AdminServlet?msg=error");
            return;
        } else if ("verify_user".equalsIgnoreCase(action)) {
            String userIdParam = request.getParameter("userId");
            if (userIdParam != null && !userIdParam.isEmpty()) {
                try (Connection conn = DBConnection.getConnection()) {
                    int userId = Integer.parseInt(userIdParam);
                    try (PreparedStatement ps = conn.prepareStatement("UPDATE users SET is_verified = 1 WHERE id = ?")) {
                        ps.setInt(1, userId);
                        ps.executeUpdate();
                    }
                    response.sendRedirect("AdminServlet?msg=user_verified");
                    return;
                } catch (Exception e) { e.printStackTrace(); }
            }
            response.sendRedirect("AdminServlet?msg=error");
            return;
        } else if ("unverify_user".equalsIgnoreCase(action)) {
            String userIdParam = request.getParameter("userId");
            if (userIdParam != null && !userIdParam.isEmpty()) {
                try (Connection conn = DBConnection.getConnection()) {
                    int userId = Integer.parseInt(userIdParam);
                    try (PreparedStatement ps = conn.prepareStatement("UPDATE users SET is_verified = 0 WHERE id = ?")) {
                        ps.setInt(1, userId);
                        ps.executeUpdate();
                    }
                    response.sendRedirect("AdminServlet?msg=user_unverified");
                    return;
                } catch (Exception e) { e.printStackTrace(); }
            }
            response.sendRedirect("AdminServlet?msg=error");
            return;
        } else if ("make_admin".equalsIgnoreCase(action)) {
            String userIdParam = request.getParameter("userId");
            if (userIdParam != null && !userIdParam.isEmpty()) {
                try (Connection conn = DBConnection.getConnection()) {
                    int userId = Integer.parseInt(userIdParam);
                    try (PreparedStatement ps = conn.prepareStatement("UPDATE users SET role = 'ADMIN' WHERE id = ?")) {
                        ps.setInt(1, userId);
                        ps.executeUpdate();
                    }
                    response.sendRedirect("AdminServlet?msg=role_updated");
                    return;
                } catch (Exception e) { e.printStackTrace(); }
            }
            response.sendRedirect("AdminServlet?msg=error");
            return;
        } else if ("remove_admin".equalsIgnoreCase(action)) {
            String userIdParam = request.getParameter("userId");
            if (userIdParam != null && !userIdParam.isEmpty()) {
                try (Connection conn = DBConnection.getConnection()) {
                    int userId = Integer.parseInt(userIdParam);
                    // Protect: cannot demote yourself
                    if (userId == ub.getId()) {
                        response.sendRedirect("AdminServlet?msg=error");
                        return;
                    }
                    try (PreparedStatement ps = conn.prepareStatement("UPDATE users SET role = 'USER' WHERE id = ?")) {
                        ps.setInt(1, userId);
                        ps.executeUpdate();
                    }
                    response.sendRedirect("AdminServlet?msg=role_updated");
                    return;
                } catch (Exception e) { e.printStackTrace(); }
            }
            response.sendRedirect("AdminServlet?msg=error");
            return;
        } else if ("delete_post".equalsIgnoreCase(action)) {
            String postIdParam = request.getParameter("postId");
            if (postIdParam != null && !postIdParam.isEmpty()) {
                try (Connection conn = DBConnection.getConnection()) {
                    int postId = Integer.parseInt(postIdParam);
                    // Delete related data first
                    try (PreparedStatement ps = conn.prepareStatement("DELETE FROM comments WHERE post_id = ?")) { ps.setInt(1, postId); ps.executeUpdate(); }
                    try (PreparedStatement ps = conn.prepareStatement("DELETE FROM post_interactions WHERE post_id = ?")) { ps.setInt(1, postId); ps.executeUpdate(); }
                    try (PreparedStatement ps = conn.prepareStatement("DELETE FROM saved_posts WHERE post_id = ?")) { ps.setInt(1, postId); ps.executeUpdate(); }
                    try (PreparedStatement ps = conn.prepareStatement("DELETE FROM posts WHERE id = ?")) { ps.setInt(1, postId); ps.executeUpdate(); }
                    response.sendRedirect("AdminServlet?msg=post_deleted");
                    return;
                } catch (Exception e) { e.printStackTrace(); }
            }
            response.sendRedirect("AdminServlet?msg=error");
            return;
        } else if ("ban_user".equalsIgnoreCase(action)) {
            String userIdParam = request.getParameter("userId");
            if (userIdParam != null && !userIdParam.isEmpty()) {
                try (Connection conn = DBConnection.getConnection()) {
                    int userId = Integer.parseInt(userIdParam);
                    try (PreparedStatement ps = conn.prepareStatement("UPDATE users SET is_banned = 1 WHERE id = ?")) {
                        ps.setInt(1, userId);
                        ps.executeUpdate();
                    }
                    response.sendRedirect("AdminServlet?msg=user_banned");
                    return;
                } catch (Exception e) { e.printStackTrace(); }
            }
            response.sendRedirect("AdminServlet?msg=error");
            return;
        } else if ("unban_user".equalsIgnoreCase(action)) {
            String userIdParam = request.getParameter("userId");
            if (userIdParam != null && !userIdParam.isEmpty()) {
                try (Connection conn = DBConnection.getConnection()) {
                    int userId = Integer.parseInt(userIdParam);
                    try (PreparedStatement ps = conn.prepareStatement("UPDATE users SET is_banned = 0 WHERE id = ?")) {
                        ps.setInt(1, userId);
                        ps.executeUpdate();
                    }
                    response.sendRedirect("AdminServlet?msg=user_unbanned");
                    return;
                } catch (Exception e) { e.printStackTrace(); }
            }
            response.sendRedirect("AdminServlet?msg=error");
            return;
        } else if ("verify_user".equalsIgnoreCase(action)) {
            String userIdParam = request.getParameter("userId");
            if (userIdParam != null && !userIdParam.isEmpty()) {
                try (Connection conn = DBConnection.getConnection()) {
                    int userId = Integer.parseInt(userIdParam);
                    try (PreparedStatement ps = conn.prepareStatement("UPDATE users SET is_verified = 1 WHERE id = ?")) {
                        ps.setInt(1, userId);
                        ps.executeUpdate();
                    }
                    response.sendRedirect("AdminServlet?msg=user_verified");
                    return;
                } catch (Exception e) { e.printStackTrace(); }
            }
            response.sendRedirect("AdminServlet?msg=error");
            return;
        } else if ("unverify_user".equalsIgnoreCase(action)) {
            String userIdParam = request.getParameter("userId");
            if (userIdParam != null && !userIdParam.isEmpty()) {
                try (Connection conn = DBConnection.getConnection()) {
                    int userId = Integer.parseInt(userIdParam);
                    try (PreparedStatement ps = conn.prepareStatement("UPDATE users SET is_verified = 0 WHERE id = ?")) {
                        ps.setInt(1, userId);
                        ps.executeUpdate();
                    }
                    response.sendRedirect("AdminServlet?msg=user_unverified");
                    return;
                } catch (Exception e) { e.printStackTrace(); }
            }
            response.sendRedirect("AdminServlet?msg=error");
            return;
        } else if ("make_admin".equalsIgnoreCase(action)) {
            String userIdParam = request.getParameter("userId");
            if (userIdParam != null && !userIdParam.isEmpty()) {
                try (Connection conn = DBConnection.getConnection()) {
                    int userId = Integer.parseInt(userIdParam);
                    try (PreparedStatement ps = conn.prepareStatement("UPDATE users SET role = 'ADMIN' WHERE id = ?")) {
                        ps.setInt(1, userId);
                        ps.executeUpdate();
                    }
                    response.sendRedirect("AdminServlet?msg=role_updated");
                    return;
                } catch (Exception e) { e.printStackTrace(); }
            }
            response.sendRedirect("AdminServlet?msg=error");
            return;
        } else if ("remove_admin".equalsIgnoreCase(action)) {
            String userIdParam = request.getParameter("userId");
            if (userIdParam != null && !userIdParam.isEmpty()) {
                try (Connection conn = DBConnection.getConnection()) {
                    int userId = Integer.parseInt(userIdParam);
                    // Protect: cannot demote yourself
                    if (userId == ub.getId()) {
                        response.sendRedirect("AdminServlet?msg=error");
                        return;
                    }
                    try (PreparedStatement ps = conn.prepareStatement("UPDATE users SET role = 'USER' WHERE id = ?")) {
                        ps.setInt(1, userId);
                        ps.executeUpdate();
                    }
                    response.sendRedirect("AdminServlet?msg=role_updated");
                    return;
                } catch (Exception e) { e.printStackTrace(); }
            }
            response.sendRedirect("AdminServlet?msg=error");
            return;
        } else if ("delete_post".equalsIgnoreCase(action)) {
            String postIdParam = request.getParameter("postId");
            if (postIdParam != null && !postIdParam.isEmpty()) {
                try (Connection conn = DBConnection.getConnection()) {
                    int postId = Integer.parseInt(postIdParam);
                    // Delete related data first
                    try (PreparedStatement ps = conn.prepareStatement("DELETE FROM comments WHERE post_id = ?")) { ps.setInt(1, postId); ps.executeUpdate(); }
                    try (PreparedStatement ps = conn.prepareStatement("DELETE FROM post_interactions WHERE post_id = ?")) { ps.setInt(1, postId); ps.executeUpdate(); }
                    try (PreparedStatement ps = conn.prepareStatement("DELETE FROM saved_posts WHERE post_id = ?")) { ps.setInt(1, postId); ps.executeUpdate(); }
                    try (PreparedStatement ps = conn.prepareStatement("DELETE FROM posts WHERE id = ?")) { ps.setInt(1, postId); ps.executeUpdate(); }
                    response.sendRedirect("AdminServlet?msg=post_deleted");
                    return;
                } catch (Exception e) { e.printStackTrace(); }
            }
            response.sendRedirect("AdminServlet?msg=error");
            return;
        }

        // Load data for dashboard
        UsersDAO usersDAO = new UsersDAO();
        List<UsersBeans> allUsers = usersDAO.getAllUsers();
        List<UserClaimBeans> allClaims = new java.util.ArrayList<>();

        // Fetch counts for dashboard stats
        int totalUsers = allUsers.size();
        int totalPosts = 0;
        int totalReels = 0;
        int totalGroups = 0;
        int totalMarketItems = 0;

        try (Connection conn = DBConnection.getConnection()) {
            // Count posts (excluding reels)
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM posts WHERE post_type IS NULL OR post_type != 'REEL'")) {
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalPosts = rs.getInt(1);
                }
            }
            // Count reels
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM posts WHERE post_type = 'REEL'")) {
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalReels = rs.getInt(1);
                }
            }
            // Count groups
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM groups")) {
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalGroups = rs.getInt(1);
                }
            }
            // Count market items
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM marketplace_items")) {
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalMarketItems = rs.getInt(1);
                }
            }
            // Fetch User Claims
            String sql = "SELECT c.*, u.name AS user_name FROM user_claims c LEFT JOIN users u ON c.user_id = u.id ORDER BY c.created_at DESC";
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UserClaimBeans claim = new UserClaimBeans();
                    claim.setId(rs.getInt("id"));
                    int uid = rs.getInt("user_id");
                    claim.setUserId(rs.wasNull() ? null : uid);
                    claim.setEmail(rs.getString("email"));
                    claim.setClaimType(rs.getString("claim_type"));
                    claim.setDescription(rs.getString("description"));
                    claim.setStatus(rs.getString("status"));
                    claim.setCreatedAt(rs.getTimestamp("created_at"));
                    claim.setUserName(rs.getString("user_name"));
                    allClaims.add(claim);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Fetch recent posts for admin management (latest 50)
        List<java.util.Map<String, Object>> recentPosts = new java.util.ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String postSql = "SELECT p.id, p.content, p.created_at, p.post_type, u.name AS user_name, u.id AS user_id " +
                             "FROM posts p LEFT JOIN users u ON p.user_id = u.id " +
                             "ORDER BY p.created_at DESC LIMIT 50";
            try (PreparedStatement ps = conn.prepareStatement(postSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    java.util.Map<String, Object> postMap = new java.util.LinkedHashMap<>();
                    postMap.put("id", rs.getInt("id"));
                    postMap.put("content", rs.getString("content"));
                    postMap.put("created_at", rs.getTimestamp("created_at"));
                    postMap.put("post_type", rs.getString("post_type"));
                    postMap.put("user_name", rs.getString("user_name"));
                    postMap.put("user_id", rs.getInt("user_id"));
                    recentPosts.add(postMap);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("allUsers", allUsers);
        request.setAttribute("allClaims", allClaims);
        request.setAttribute("recentPosts", recentPosts);
        request.setAttribute("allPayments", new ychatapp.model.dao.PaymentDAO().getAllPayments());
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalPosts", totalPosts);
        request.setAttribute("totalReels", totalReels);
        request.setAttribute("totalGroups", totalGroups);
        request.setAttribute("totalMarketItems", totalMarketItems);

        request.getRequestDispatcher("/WEB-INF/jsp/admin.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}