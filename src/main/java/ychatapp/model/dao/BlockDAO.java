package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import ychatapp.model.beans.UsersBeans;

public class BlockDAO {

    public BlockDAO() {
        createTableIfNotExists();
    }

    private Connection getConnection() throws Exception {
        return DBConnection.getConnection();
    }

    private void createTableIfNotExists() {
        String sql = "CREATE TABLE IF NOT EXISTS blocked_users (" +
                     "id INT AUTO_INCREMENT PRIMARY KEY," +
                     "blocker_id INT NOT NULL," +
                     "blocked_id INT NOT NULL," +
                     "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                     "UNIQUE KEY unique_block (blocker_id, blocked_id)," +
                     "FOREIGN KEY (blocker_id) REFERENCES users(id) ON DELETE CASCADE," +
                     "FOREIGN KEY (blocked_id) REFERENCES users(id) ON DELETE CASCADE" +
                     ")";
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
        } catch (Exception e) {
            System.err.println("Error creating blocked_users table: " + e.getMessage());
        }
    }

    // ================= BLOCK USER =================
    public boolean blockUser(int blockerId, int blockedId) {
        if (blockerId == blockedId) return false;
        String blockSql = "INSERT IGNORE INTO blocked_users (blocker_id, blocked_id) VALUES (?, ?)";
        String unfriendSql = "DELETE FROM friendships WHERE (user_id1 = ? AND user_id2 = ?) OR (user_id1 = ? AND user_id2 = ?)";
        String unfollowSql = "DELETE FROM followers WHERE (follower_id = ? AND following_id = ?) OR (follower_id = ? AND following_id = ?)";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psBlock = conn.prepareStatement(blockSql);
                 PreparedStatement psUnfriend = conn.prepareStatement(unfriendSql);
                 PreparedStatement psUnfollow = conn.prepareStatement(unfollowSql)) {

                // 1. Insert block record
                psBlock.setInt(1, blockerId);
                psBlock.setInt(2, blockedId);
                psBlock.executeUpdate();

                // 2. Remove friendship both ways
                psUnfriend.setInt(1, blockerId);
                psUnfriend.setInt(2, blockedId);
                psUnfriend.setInt(3, blockedId);
                psUnfriend.setInt(4, blockerId);
                psUnfriend.executeUpdate();

                // 3. Remove follow relationships both ways
                try {
                    psUnfollow.setInt(1, blockerId);
                    psUnfollow.setInt(2, blockedId);
                    psUnfollow.setInt(3, blockedId);
                    psUnfollow.setInt(4, blockerId);
                    psUnfollow.executeUpdate();
                } catch (Exception ignore) {}

                conn.commit();
                return true;
            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ================= UNBLOCK USER =================
    public boolean unblockUser(int blockerId, int blockedId) {
        String sql = "DELETE FROM blocked_users WHERE blocker_id = ? AND blocked_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, blockerId);
            ps.setInt(2, blockedId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ================= CHECK IF EITHER USER IS BLOCKED =================
    public boolean isBlocked(int userA, int userB) {
        if (userA <= 0 || userB <= 0 || userA == userB) return false;
        String sql = "SELECT 1 FROM blocked_users WHERE (blocker_id = ? AND blocked_id = ?) OR (blocker_id = ? AND blocked_id = ?) LIMIT 1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userA);
            ps.setInt(2, userB);
            ps.setInt(3, userB);
            ps.setInt(4, userA);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ================= GET USERS BLOCKED BY THIS USER =================
    public List<UsersBeans> getBlockedUsers(int blockerId) {
        List<UsersBeans> list = new ArrayList<>();
        String sql = "SELECT u.id, u.name, u.email, u.profile_pic, u.bio, u.city, u.country " +
                     "FROM blocked_users b " +
                     "JOIN users u ON b.blocked_id = u.id " +
                     "WHERE b.blocker_id = ? " +
                     "ORDER BY b.id DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, blockerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UsersBeans user = new UsersBeans();
                    user.setId(rs.getInt("id"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setProfile_pic(rs.getString("profile_pic"));
                    user.setBio(rs.getString("bio"));
                    user.setCity(rs.getString("city"));
                    user.setCountry(rs.getString("country"));
                    list.add(user);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ================= GET ALL BLOCKED USER IDS (BOTH SIDES) =================
    public Set<Integer> getBlockedUserIds(int userId) {
        Set<Integer> set = new HashSet<>();
        String sql = "SELECT blocked_id AS uid FROM blocked_users WHERE blocker_id = ? " +
                     "UNION " +
                     "SELECT blocker_id AS uid FROM blocked_users WHERE blocked_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    set.add(rs.getInt("uid"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return set;
    }
}
