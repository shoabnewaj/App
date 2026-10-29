package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import ychatapp.model.beans.NotificationBeans;

public class NotificationDAO {

    private Connection getConnection() throws SQLException {
        try {
            return DBConnection.getConnection();
        } catch (SQLException e) {
            throw e;
        } catch (Exception e) {
            throw new SQLException(e);
        }
    }

    /**
     * ১. সাধারণ নোটিফিকেশন কাউন্ট (Red Badge-এর জন্য)
     */
    public int getUnreadCount(int userId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = 0";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * ২. মেসেজ নোটিফিকেশন কাউন্ট (Messages Badge-এর জন্য)
     */
    public int getUnreadMessageCount(int receiverId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM messages WHERE receiver_id=? AND is_read=0";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, receiverId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) count = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error counting messages: " + e.getMessage());
        }
        return count;
    }

    /**
     * ৩. নতুন নোটিফিকেশন অ্যাড করা (যেমন: কেউ কমেন্ট বা ফ্রেন্ড রিকোয়েস্ট দিলে)
     */
    public void addNotification(int userId, String message) {
        if (!new NotificationPreferenceDAO().isEnabled(userId, new NotificationPreferenceDAO().getCategory(null, message))) return;
        String sql = "INSERT INTO notifications(user_id, message, is_read) VALUES (?, ?, 0)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, message);
            ps.executeUpdate();
            
            // Send WebSocket notification if user is online
            try {
                String userSql = "SELECT name FROM users WHERE id = ?";
                try (PreparedStatement userPs = conn.prepareStatement(userSql)) {
                    userPs.setInt(1, userId);
                    try (ResultSet userRs = userPs.executeQuery()) {
                        if (userRs.next()) {
                            String username = userRs.getString("name");
                            ychatapp.websocket.UserWebSocket.sendNotification(username, message);
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * ৩.২. ওভারলোডেড নোটিফিকেশন অ্যাড করা (লাইভ ব্রডকাস্ট এর জন্য)
     */
    public void addNotification(int userId, int senderId, String type, String message) {
        NotificationPreferenceDAO preferences = new NotificationPreferenceDAO();
        if (!preferences.isEnabled(userId, preferences.getCategory(type, message))) return;
        ensureLiveNotificationColumns();
        String sql = "INSERT INTO notifications(user_id, sender_id, type, message, is_read) VALUES (?, ?, ?, ?, 0)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, senderId);
            ps.setString(3, type);
            ps.setString(4, message);
            ps.executeUpdate();
            try (PreparedStatement userPs = conn.prepareStatement("SELECT name FROM users WHERE id = ?")) {
                userPs.setInt(1, userId);
                try (ResultSet userRs = userPs.executeQuery()) {
                    if (userRs.next()) ychatapp.websocket.UserWebSocket.sendNotification(userRs.getString("name"), message);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void ensureLiveNotificationColumns() {
        try (Connection conn = getConnection(); java.sql.Statement stmt = conn.createStatement()) {
            java.sql.DatabaseMetaData metadata = conn.getMetaData();
            try (ResultSet rs = metadata.getColumns(conn.getCatalog(), null, "notifications", "sender_id")) {
                if (!rs.next()) stmt.executeUpdate("ALTER TABLE notifications ADD COLUMN sender_id INT NULL");
            }
            try (ResultSet rs = metadata.getColumns(conn.getCatalog(), null, "notifications", "type")) {
                if (!rs.next()) stmt.executeUpdate("ALTER TABLE notifications ADD COLUMN type VARCHAR(50) NULL");
            }
        } catch (SQLException e) {
            // Older schemas can still keep a readable notification, though without its typed deep link.
            System.err.println("Could not prepare notification metadata columns: " + e.getMessage());
        }
    }

    /**
     * ৩.১. ইউজারনেম দিয়ে নোটিফিকেশন অ্যাড করা (মেসেজ নোটিফিকেশনের জন্য)
     */
    public void addNotificationByUsername(String username, String message) {
        if (!new NotificationPreferenceDAO().isEnabledForUsername(username, "messages")) return;
        String sql = "INSERT INTO notifications(user_id, message, is_read) SELECT id, ?, 0 FROM users WHERE name = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, message);
            ps.setString(2, username);
            ps.executeUpdate();
            
            // Send WebSocket notification
            try {
                ychatapp.websocket.UserWebSocket.sendNotification(username, message);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * ৪. নোটিফিকেশন লিস্ট নিয়ে আসা (লেটেস্টগুলো আগে দেখাবে)
     */
    public List<NotificationBeans> getNotifications(int userId) {
        ensureLiveNotificationColumns();
        List<NotificationBeans> list = new ArrayList<>();
        String sql = "SELECT id, sender_id, type, message, created_at FROM notifications WHERE user_id=? ORDER BY id DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    NotificationBeans notification = new NotificationBeans();
                    notification.setId(rs.getInt("id"));
                    notification.setSenderId(rs.getInt("sender_id"));
                    notification.setType(rs.getString("type"));
                    notification.setMessage(rs.getString("message"));
                    notification.setCreatedAt(rs.getString("created_at"));
                    list.add(notification);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    /**
     * ৫. নোটিফিকেশন পড়া হয়েছে হিসেবে মার্ক করা
     */
    public void markAsRead(int userId) {
        String sql = "UPDATE notifications SET is_read = 1 WHERE user_id = ? AND is_read = 0";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /** Clear only offline message alerts for the opened conversation. */
    public void markMessageNotificationsAsRead(int userId, String senderName) {
        if (userId < 1 || senderName == null || senderName.trim().isEmpty()) return;
        String sql = "UPDATE notifications SET is_read=1 WHERE user_id=? AND is_read=0 AND message LIKE CONCAT(?, ': %')";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, senderName.trim());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
