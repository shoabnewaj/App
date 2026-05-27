package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import ychatapp.model.beans.UsersBeans;

public class UsersDAO {

    private Connection getConnection() throws Exception {
        return DBConnection.getConnection();
    }

    // 📊 Profile Count
    public int getProfileCount(int userId, String type) {
        int count = 0;
        String sql = (type.equalsIgnoreCase("FRIENDS")) ? 
            "SELECT COUNT(*) FROM friendships WHERE (user_id1=? OR user_id2=?) AND status='ACCEPTED'" :
            (type.equalsIgnoreCase("FOLLOWERS") ? "SELECT COUNT(*) FROM followers WHERE following_id=?" : "SELECT COUNT(*) FROM followers WHERE follower_id=?");
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if (type.equalsIgnoreCase("FRIENDS")) ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    // 🔥 User Registration
    public boolean registerUser(UsersBeans ub) {
        String sql = "INSERT INTO users (name, email, password, profile_pic) VALUES (?, ?, ?, ?)";
        try (Connection conn = g

































































































































































































































































































































































































                    try (PreparedStatement ps = conn.prepareStatement("DELETE FROM comments WHERE post_id = ?")) {
                        ps.setInt(1, pid);
                        ps.executeUpdate();
                    }
                    // Delete interactions on this post
                    try (PreparedStatement ps = conn.prepareStatement("DELETE FROM post_interactions WHERE post_id = ?")) {
                        ps.setInt(1, pid);
                        ps.executeUpdate();
                    }
                    // Delete saved_posts reference to this post
                    try (PreparedStatement ps = conn.prepareStatement("DELETE FROM saved_posts WHERE post_id = ?")) {
                        ps.setInt(1, pid);
                        ps.executeUpdate();
                    }
                }
                
                // Delete posts owned by this user
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM posts WHERE user_id = ?")) {
                    ps.setInt(1, userId);
                    ps.executeUpdate();
                }
                
                // Finally, delete user
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM users WHERE id = ?")) {
                    ps.setInt(1, userId);
                    int deleted = ps.executeUpdate();
                    conn.commit();
                    return deleted > 0;
                }
            } catch (Exception e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
                }
            } catch (Exception e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}