package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import ychatapp.model.beans.UserSessionBean;

public class SessionDAO {

    public SessionDAO() {
        createTableIfNotExists();
    }

    private Connection getConnection() throws Exception {
        return DBConnection.getConnection();
    }

    private void createTableIfNotExists() {
        String sql = "CREATE TABLE IF NOT EXISTS user_sessions (" +
                     "id INT AUTO_INCREMENT PRIMARY KEY," +
                     "user_id INT NOT NULL," +
                     "session_id VARCHAR(100) NOT NULL," +
                     "ip_address VARCHAR(50)," +
                     "user_agent VARCHAR(255)," +
                     "device_type VARCHAR(50)," +
                     "browser VARCHAR(50)," +
                     "operating_system VARCHAR(50)," +
                     "location VARCHAR(100) DEFAULT 'Current Location'," +
                     "last_active TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP," +
                     "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                     "is_active BOOLEAN DEFAULT TRUE," +
                     "INDEX idx_session (session_id)," +
                     "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE" +
                     ")";
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
        } catch (Exception e) {
            System.err.println("Error creating user_sessions table: " + e.getMessage());
        }
    }

    // ================= RECORD NEW LOGIN SESSION =================
    public boolean createSession(int userId, String sessionId, String ip, String userAgent) {
        String[] parsed = parseUserAgent(userAgent);
        String browser = parsed[0];
        String os = parsed[1];
        String device = parsed[2];

        String sql = "INSERT INTO user_sessions (user_id, session_id, ip_address, user_agent, browser, operating_system, device_type, location, is_active) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, 'Active Session', TRUE)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, sessionId);
            ps.setString(3, ip != null ? ip : "127.0.0.1");
            ps.setString(4, userAgent != null && userAgent.length() > 250 ? userAgent.substring(0, 250) : userAgent);
            ps.setString(5, browser);
            ps.setString(6, os);
            ps.setString(7, device);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ================= GET ACTIVE SESSIONS FOR USER =================
    public List<UserSessionBean> getActiveSessions(int userId, String currentSessionId) {
        List<UserSessionBean> list = new ArrayList<>();
        String sql = "SELECT id, user_id, session_id, ip_address, device_type, browser, operating_system, location, " +
                     "       DATE_FORMAT(last_active, '%M %d, %Y %h:%i %p') AS last_active_str " +
                     "FROM user_sessions " +
                     "WHERE user_id = ? AND is_active = TRUE " +
                     "ORDER BY id DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String sId = rs.getString("session_id");
                    boolean isCurr = (currentSessionId != null && currentSessionId.equals(sId));
                    UserSessionBean session = new UserSessionBean(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        sId,
                        rs.getString("ip_address"),
                        rs.getString("device_type"),
                        rs.getString("browser"),
                        rs.getString("operating_system"),
                        rs.getString("location"),
                        rs.getString("last_active_str"),
                        isCurr
                    );
                    list.add(session);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ================= TERMINATE SPECIFIC SESSION =================
    public boolean terminateSession(int userId, int sessionRowId) {
        String sql = "DELETE FROM user_sessions WHERE id = ? AND user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sessionRowId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ================= TERMINATE ALL OTHER SESSIONS =================
    public boolean terminateAllOtherSessions(int userId, String currentSessionId) {
        String sql = "DELETE FROM user_sessions WHERE user_id = ? AND session_id != ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, currentSessionId != null ? currentSessionId : "");
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ================= PARSE USER-AGENT =================
    public static String[] parseUserAgent(String ua) {
        if (ua == null || ua.trim().isEmpty()) {
            return new String[]{"Unknown Browser", "Unknown OS", "Desktop"};
        }

        String browser = "Browser";
        String os = "Operating System";
        String device = "Desktop";

        String lower = ua.toLowerCase();

        // Device
        if (lower.contains("mobile") || lower.contains("android") || lower.contains("iphone")) {
            device = "Mobile";
        } else if (lower.contains("ipad") || lower.contains("tablet")) {
            device = "Tablet";
        } else {
            device = "Desktop / Laptop";
        }

        // OS
        if (lower.contains("windows nt 10.0") || lower.contains("windows nt 11.0") || lower.contains("windows")) {
            os = "Windows";
        } else if (lower.contains("mac os") || lower.contains("macintosh")) {
            os = "macOS";
        } else if (lower.contains("android")) {
            os = "Android";
        } else if (lower.contains("iphone") || lower.contains("ipad") || lower.contains("ios")) {
            os = "iOS";
        } else if (lower.contains("linux")) {
            os = "Linux";
        }

        // Browser
        if (lower.contains("edg/") || lower.contains("edge/")) {
            browser = "Microsoft Edge";
        } else if (lower.contains("chrome/") && !lower.contains("edg/")) {
            browser = "Google Chrome";
        } else if (lower.contains("safari/") && !lower.contains("chrome/")) {
            browser = "Apple Safari";
        } else if (lower.contains("firefox/")) {
            browser = "Mozilla Firefox";
        } else if (lower.contains("opr/") || lower.contains("opera/")) {
            browser = "Opera";
        }

        return new String[]{browser, os, device};
    }
}
