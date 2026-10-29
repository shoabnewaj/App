package ychatapp.Servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Timestamp;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.beans.UserSessionBean;
import ychatapp.model.dao.BlockDAO;
import ychatapp.model.dao.SessionDAO;
import ychatapp.model.dao.UsersDAO;
import ychatapp.model.dao.ProfilePrivacyDAO;

@WebServlet("/SecurityServlet")
public class SecurityServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final BlockDAO blockDAO = new BlockDAO();
    private final SessionDAO sessionDAO = new SessionDAO();
    private final UsersDAO usersDAO = new UsersDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        handleRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        handleRequest(request, response);
    }

    private void handleRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        UsersBeans currentUser = (session != null) ? (UsersBeans) session.getAttribute("ub") : null;

        if (currentUser == null) {
            out.write("{\"success\":false,\"message\":\"Unauthorized. Please log in.\"}");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            out.write("{\"success\":false,\"message\":\"Action parameter is required.\"}");
            return;
        }

        try {
            switch (action) {
                case "exportMyData": {
                    response.setContentType("application/json;charset=UTF-8");
                    response.setHeader("Content-Disposition", "attachment; filename=\"ychat-my-data.json\"");
                    out.write(buildDataExport(currentUser));
                    break;
                }
                case "requestAccountClosure": {
                    if (!"POST".equalsIgnoreCase(request.getMethod())) {
                        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
                        out.write("{\"success\":false,\"message\":\"Use POST to submit this request.\"}");
                        break;
                    }
                    String closureType = request.getParameter("type");
                    if (!"DEACTIVATION".equals(closureType) && !"DELETION".equals(closureType)) {
                        out.write("{\"success\":false,\"message\":\"Choose deactivation or deletion.\"}");
                        break;
                    }
                    String sql = "CREATE TABLE IF NOT EXISTS account_closure_requests (id INT AUTO_INCREMENT PRIMARY KEY, user_id INT NOT NULL, request_type VARCHAR(20) NOT NULL, request_status VARCHAR(20) NOT NULL DEFAULT 'PENDING', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, UNIQUE KEY uq_open_closure_request(user_id, request_type, request_status), FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE) ENGINE=InnoDB";
                    try (Connection conn = ychatapp.model.dao.DBConnection.getConnection(); java.sql.Statement st = conn.createStatement()) { st.executeUpdate(sql); }
                    try (Connection conn = ychatapp.model.dao.DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement("INSERT IGNORE INTO account_closure_requests(user_id,request_type) VALUES(?,?)")) {
                        ps.setInt(1, currentUser.getId()); ps.setString(2, closureType);
                        ps.executeUpdate();
                        out.write("{\"success\":true,\"message\":\"Your request was recorded for account support review.\"}");
                    }
                    break;
                }
                case "block": {
                    int targetUserId = Integer.parseInt(request.getParameter("userId"));
                    if (targetUserId == currentUser.getId()) {
                        out.write("{\"success\":false,\"message\":\"You cannot block yourself.\"}");
                        return;
                    }
                    boolean ok = blockDAO.blockUser(currentUser.getId(), targetUserId);
                    if (ok) {
                        out.write("{\"success\":true,\"message\":\"User blocked successfully.\"}");
                    } else {
                        out.write("{\"success\":false,\"message\":\"Failed to block user.\"}");
                    }
                    break;
                }
                case "unblock": {
                    int targetUserId = Integer.parseInt(request.getParameter("userId"));
                    boolean ok = blockDAO.unblockUser(currentUser.getId(), targetUserId);
                    if (ok) {
                        out.write("{\"success\":true,\"message\":\"User unblocked successfully.\"}");
                    } else {
                        out.write("{\"success\":false,\"message\":\"Failed to unblock user.\"}");
                    }
                    break;
                }
                case "getBlockedUsers": {
                    List<UsersBeans> blockedList = blockDAO.getBlockedUsers(currentUser.getId());
                    StringBuilder sb = new StringBuilder();
                    sb.append("{\"success\":true,\"users\":[");
                    for (int i = 0; i < blockedList.size(); i++) {
                        UsersBeans u = blockedList.get(i);
                        if (i > 0) sb.append(",");
                        sb.append("{");
                        sb.append("\"id\":").append(u.getId()).append(",");
                        sb.append("\"name\":\"").append(escapeJson(u.getName())).append("\",");
                        sb.append("\"email\":\"").append(escapeJson(u.getEmail())).append("\",");
                        sb.append("\"profile_pic\":\"").append(escapeJson(u.getProfile_pic() != null ? u.getProfile_pic() : "")).append("\"");
                        sb.append("}");
                    }
                    sb.append("]}");
                    out.write(sb.toString());
                    break;
                }
                case "getProfileVisibility": {
                    String visibility = new ProfilePrivacyDAO().getVisibility(currentUser.getId());
                    out.write("{\"success\":true,\"visibility\":\"" + visibility + "\"}");
                    break;
                }
                case "setProfileVisibility": {
                    String visibility = request.getParameter("visibility");
                    boolean ok = new ProfilePrivacyDAO().setVisibility(currentUser.getId(), visibility);
                    out.write("{\"success\":" + ok + ",\"visibility\":\"" + (ok ? visibility : "") + "\"}");
                    break;
                }
                case "toggle2FA": {
                    boolean enabled = Boolean.parseBoolean(request.getParameter("enabled"));
                    boolean ok = usersDAO.setTwoFactorEnabled(currentUser.getId(), enabled);
                    if (ok) {
                        currentUser.setTwoFactorEnabled(enabled);
                        session.setAttribute("ub", currentUser);
                        out.write("{\"success\":true,\"enabled\":" + enabled + ",\"message\":\"2FA settings updated.\"}");
                    } else {
                        out.write("{\"success\":false,\"message\":\"Failed to update 2FA settings.\"}");
                    }
                    break;
                }
                case "getActiveSessions": {
                    List<UserSessionBean> sessions = sessionDAO.getActiveSessions(currentUser.getId(), session.getId());
                    StringBuilder sb = new StringBuilder();
                    sb.append("{\"success\":true,\"sessions\":[");
                    for (int i = 0; i < sessions.size(); i++) {
                        UserSessionBean s = sessions.get(i);
                        if (i > 0) sb.append(",");
                        sb.append("{");
                        sb.append("\"id\":").append(s.getId()).append(",");
                        sb.append("\"ipAddress\":\"").append(escapeJson(s.getIpAddress())).append("\",");
                        sb.append("\"deviceType\":\"").append(escapeJson(s.getDeviceType())).append("\",");
                        sb.append("\"browser\":\"").append(escapeJson(s.getBrowser())).append("\",");
                        sb.append("\"operatingSystem\":\"").append(escapeJson(s.getOperatingSystem())).append("\",");
                        sb.append("\"location\":\"").append(escapeJson(s.getLocation())).append("\",");
                        sb.append("\"lastActive\":\"").append(escapeJson(s.getLastActive())).append("\",");
                        sb.append("\"isCurrent\":").append(s.isCurrent());
                        sb.append("}");
                    }
                    sb.append("]}");
                    out.write(sb.toString());
                    break;
                }
                case "terminateSession": {
                    int sessionRowId = Integer.parseInt(request.getParameter("sessionId"));
                    boolean ok = sessionDAO.terminateSession(currentUser.getId(), sessionRowId);
                    if (ok) {
                        out.write("{\"success\":true,\"message\":\"Session terminated.\"}");
                    } else {
                        out.write("{\"success\":false,\"message\":\"Failed to terminate session.\"}");
                    }
                    break;
                }
                case "terminateOtherSessions": {
                    boolean ok = sessionDAO.terminateAllOtherSessions(currentUser.getId(), session.getId());
                    if (ok) {
                        out.write("{\"success\":true,\"message\":\"All other sessions have been logged out.\"}");
                    } else {
                        out.write("{\"success\":false,\"message\":\"Failed to log out other sessions.\"}");
                    }
                    break;
                }
                default:
                    out.write("{\"success\":false,\"message\":\"Unknown action: " + escapeJson(action) + "\"}");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.write("{\"success\":false,\"message\":\"Server error: " + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    private String buildDataExport(UsersBeans user) {
        StringBuilder json = new StringBuilder("{\"exportedAt\":\"").append(escapeJson(new java.util.Date().toString())).append("\"");
        try (Connection conn = ychatapp.model.dao.DBConnection.getConnection()) {
            appendExportRows(conn, json, "profile", "SELECT id,name,email,profile_pic,cover_pic,bio,country,city,gender,birthday,created_at FROM users WHERE id=?", user.getId());
            appendExportRows(conn, json, "posts", "SELECT id,user_id,content,file_name,post_type,feeling,original_post_id,created_at FROM posts WHERE user_id=?", user.getId());
            appendExportRows(conn, json, "comments", "SELECT id,post_id,user_id,comment_text,file_name,created_at FROM comments WHERE user_id=?", user.getId());
            appendExportRows(conn, json, "replies", "SELECT r.id,r.comment_id,r.user_id,r.text,r.file_name,r.created_at FROM replies r WHERE r.user_id=?", user.getId());
            appendExportRows(conn, json, "messages", "SELECT id,sender_id,receiver_id,message_text,is_read,is_edited,is_deleted,reaction,reply_to_id,reply_to_text,created_at FROM messages WHERE sender_id=? OR receiver_id=?", user.getName());
            // Messages use usernames for sender and receiver; bind the same account name twice.
        } catch (Exception e) {
            e.printStackTrace();
            return "{\"success\":false,\"message\":\"Could not create your data export.\"}";
        }
        return json.append("}").toString();
    }

    private void appendExportRows(Connection conn, StringBuilder json, String key, String sql, Object value) throws Exception {
        json.append(",\"").append(key).append("\":[");
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, value);
            if (sql.contains("OR receiver_id=?")) ps.setObject(2, value);
            try (ResultSet rs = ps.executeQuery()) {
                ResultSetMetaData md = rs.getMetaData();
                boolean firstRow = true;
                while (rs.next()) {
                    if (!firstRow) json.append(',');
                    firstRow = false;
                    json.append('{');
                    for (int col = 1; col <= md.getColumnCount(); col++) {
                        if (col > 1) json.append(',');
                        String name = md.getColumnLabel(col);
                        json.append('"').append(escapeJson(name)).append("\":");
                        Object v = rs.getObject(col);
                        if (v == null) json.append("null");
                        else if (v instanceof Number || v instanceof Boolean) json.append(v);
                        else if (v instanceof Timestamp) json.append('"').append(escapeJson(v.toString())).append('"');
                        else json.append('"').append(escapeJson(String.valueOf(v))).append('"');
                    }
                    json.append('}');
                }
            }
        }
        json.append(']');
    }
}
