package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
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
        String 

















































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
    public List<String> getNotifications(int userId) {
        List<String> list = new ArrayList<>();
        String sql = "SELECT message FROM notifications WHERE user_id=? ORDER BY id DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("message"));
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
}