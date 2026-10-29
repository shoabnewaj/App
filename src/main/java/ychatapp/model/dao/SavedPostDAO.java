package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SavedPostDAO {

    private Connection getConnection() throws Exception {
        return DBConnection.getConnection();
    }

    public boolean toggleSavePost(int userId, int postId) {
        if (isPostSaved(userId, postId)) {
            // Remove bookmark
            String sql = "DELETE FROM saved_posts WHERE user_id = ? AND post_id = ?";
            try (Connection conn = getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, postId);
                ps.executeUpdate();
                return false; // now unsaved
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            // Save bookmark
            String sql = "INSERT IGNORE INTO saved_posts (user_id, post_id) VALUES (?, ?)";
            try (Connection conn = getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, postId);
                ps.executeUpdate();
                return true; // now saved
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public boolean isPostSaved(int userId, int postId) {
        String sql = "SELECT 1 FROM saved_posts WHERE user_id = ? AND post_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, postId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Integer> getSavedPostIds(int userId) {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT post_id FROM saved_posts WHERE user_id = ? ORDER BY saved_at DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getInt("post_id"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ids;
    }
}
