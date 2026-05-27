package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import ychatapp.model.beans.UsersPost;

public class PostDAO {

    private Connection getConnection() throws Exception {
        return DBConnection.getConnection();
    }

    // ================= ADD POST (Feeling সহ আপডেট করা হয়েছে) =================
    public boolean addPost(int userId, String content, String fileName, String postType, String feeling) {
        String sql = "INSERT INTO posts(user_id, content, file_name, post_type, feeling) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, content);
            ps.setString(3, fileName);
            ps.setString(4, postType);
            ps.setString(5, feeling);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ================= GET ALL POSTS (Optimized - Single Connection, No N+1) =================
        public List<UsersPost> getAllposts() {
        List<UsersPost> list = new ArrayList<>();

        String sql =
            
            "       u.profile_pic, p.created_at, p.share_count, " +
            "       SUM(CASE WHEN pi.type='LIKE'     THEN 1 ELSE 0 END) AS like_count, " +
            "       SUM(CASE WHEN pi.type='LOVE'     THEN 1 ELSE 0 END) AS love_count, " +
            "       SUM(CASE WHEN pi.type='CARE'     THEN 1 ELSE 0 END) AS care_count, " +
            "       SUM(CASE WHEN pi.type='HAHA'     THEN 1 ELSE 0 END) AS haha_count, " +
            "       SUM(CASE WHEN pi.type='WOW'      THEN 1 ELSE 0 END) AS wow_count, " +
            "       SUM(CASE WHEN pi.type='SAD'      THEN 1 ELSE 0 END) AS sad_count, " +
            "       SUM(CASE WHEN pi.type='ANGRY'    THEN 1 ELSE 0 END) AS angry_count, " +
            "       SUM(CASE WHEN pi.type='DISLIKES' THEN 1 ELSE 0 END) AS dislike_count, " +
            "       COUNT(DISTINCT c.id) AS comment_count " +
            "FROM posts p " +
            "JOIN users u ON p.user_id = u.id " +
            "LEFT JOIN post_interactions pi ON pi.post_id = p.id " +
            "LEFT JOIN comments c ON c.post_id = p.id " +
            "WHERE p.post_type IS NULL OR p.post_typ

            "ORDER BY p.id DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            CommentDAO commentDAO = new CommentDAO();
            while (rs.next()) {
                UsersPost post = new UsersPost(
                        rs.getInt("posts_id"),
                        rs.getString("name"),
                        rs.getInt("users_id"),
                        rs.getString("content"),
                        rs.getString("file_name"),
                        rs.getString("post_type"),
                        rs.getString("feeling")
                );
                post.setProfile_pic(rs.getString("profile_pic"));

                post.setTime(rs.getString("created_at"));

                post.setLikeCount(rs.getInt("like_count"));
                post.setLoveCount(rs.getInt("love_count"));
                post.setCareCount(rs.getInt("care_count"));
                post.setHahaCount(rs.getInt("haha_count"));
                post.setWowCount(rs.getInt("wow_count"));
                post.setSadCount(rs.getInt("sad_count"));
                post.setAngryCount(rs.getInt("angry_count"));
                post.setDislikes(rs.getInt("dislike_count"));
                post.setCommentCount(rs.getInt("comment_count"));
                post.setShareCount(rs.getInt("share_count"));

                post.setComments(commentDAO.getCommentsByPostIdInternal(conn, post.getId()));

                list.add(post);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ================= GET ALL REELS =================
    public List<UsersPost> getAllReels() {
        List<UsersPost> list = new ArrayList<>();

        String sql =
            "SELECT p.id AS posts_id, u.name, p.user_id AS users_id, p.content, p.file_name, p.post_type, p.feeling, " +
            "       u.profile_pic, p.created_at, p.share_count, " +
            "       SUM(CASE WHEN pi.type='LIKE'     THEN 1 ELSE 0 END) AS like_count, " +
            "       SUM(CASE WHEN pi.type='LOVE'     THEN 1 ELSE 0 END) AS love_count, " +
            "       SUM(CASE WHEN pi.type='CARE'     THEN 1 ELSE 0 END) AS care_count, " +
            "       SUM(CASE WHEN pi.type='HAHA'     THEN 1 ELSE 0 END) AS haha_count, " +
            "       SUM(CASE WHEN pi.type='WOW'      THEN 1 ELSE 0 END) AS wow_count, " +
            "       SUM(CASE WHEN pi.type='SAD'      THEN 1 ELSE 0 END) AS sad_count, " +
            "       SUM(CASE WHEN pi.type='ANGRY'    THEN 1 ELSE 0 END) AS angry_count, " +
            "       SUM(CASE WHEN pi.type='DISLIKES' THEN 1 ELSE 0 END) AS dislike_count, " +
            "       COUNT(DISTINCT c.id) AS comment_count " +
            "FROM posts p " +
            "JOIN users u ON p.user_id = u.id " +
            "LEFT JOIN post_interactions pi ON pi.post_id = p.id " +
            "LEFT JOIN comments c ON c.post_id = p.id " +
            "WHERE p.post_type = 'REEL' " +
            "GROUP BY p.id, u.name, p.user_id, p.content, p.file_name, p.post_type, p.f
           
            "ORDER BY p.id DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            CommentDAO commentDAO = new CommentDAO();
            while (rs.next()) {
                UsersPost post = new UsersPost(
                        rs.getInt("posts_id"),
                        rs.getString("name"),
                        rs.getInt("users_id"),
                        rs.getString("content"),
                        rs.getString("file_name"),
                        rs.getString("post_type"),
                        rs.getString("feeling")
                );
                post.setProfile_pic(rs.getString("profile_pic"));
                post.setTime(rs.getString("created_at"));

                post.setLikeCount(rs.getInt("like_count"));
                post.setLoveCount(rs.getInt("love_count"));
                post.setCareCount(rs.getInt("care_count"));
                post.setHahaCount(rs.getInt("haha_count"));
                post.setWowCount(rs.getInt("wow_count"));
                post.setSadCount(rs.getInt("sad_count"));
                post.setAngryCount(rs.getInt("angry_count"));
                post.setDislikes(rs.getInt("dislike_count"));
                post.setCommentCount(rs.getInt("comment_count"));
                post.setShareCount(rs.getInt("share_count"));

                post.setComments(commentDAO.getCommentsByPostIdInternal(conn, post.getId()));

                list.add(post);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ================= GET VIDEO POSTS =================
        List<UsersPost> list = new ArrayList<>();

        String sql =
            "SELECT p.id AS posts_id, u.name, p.user_id AS users_id, p.content, p.file_name, p.post_type, p.feeling, " +
            "       u.profile_pic, p.created_at, p.share_count, " +
            "       SUM(CASE WHEN pi.type='LIKE'     THEN 1 ELSE 0 END) AS like_count, " +
            "       SUM(CASE WHEN pi.type='LOVE'     THEN 1 ELSE 0 END) AS love_count, " +
            "       SUM(CASE WHEN pi.type='CARE'     THEN 1 ELSE 0 END) AS care_count, " +
            "       SUM(CASE WHEN pi.type='HAHA'     THEN 1 ELSE 0 END) AS haha_count, " +
            "       SUM(CASE WHEN pi.type='WOW'      THEN 1 ELSE 0 END) AS wow_count, " +
            "       SUM(CASE WHEN pi.type='SAD'      THEN 1 ELSE 0 END) AS sad_count, " +
            "       SUM(CASE WHEN pi.type='ANGRY'    THEN 1 ELSE 0 END) AS angry_count, " +
            "       SUM(CASE WHEN pi.type='DISLIKES' THEN 1 ELSE 0 END) AS dislike_count, " +
            "       COUNT(DISTINCT c.id) AS comment_count " +
            "FROM posts p " +
            "JOIN users u ON p.user_id = u.id " +
            "LEFT JOIN post_interactions pi ON pi.post_id = p.id " +
            "LEFT JOIN comments c ON c.post_id = p.id " +
            "WHERE p.post_type = 'video' " +
            "GROUP BY p.id, u.name, p.user_id, p.content, p.file_name, p.post_type, p.feeling, u.profile_pic, p.created_at, p.share_count " +
            "ORDER BY p.id DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            CommentDAO commentDAO = new CommentDAO();





























            e.printStackTrace();
        }
        return list;
    }

        // ================= GET POSTS BY USER =================
    public List<UsersPost> getPostsByUserId(int userId) {
        List<UsersPost> list = new ArrayList<>();
        // প্রোফাইল পেজে ইউজারের নিজের সব পোস্ট (অরিজিনাল এবং শেয়ার করা) পাওয়ার জন্য ডিরেক্ট টেবিল কুয়েরি করা হচ্ছে
        String sql = "SELECT p.id as posts_id, u.name, p.user_id, p.content, p.file_name, p.post_type, p.feeling, u.profile_pic, p.created_at, p.share_count " +
                     "FROM posts p " +
                     "JOIN users u ON p.user_id = u.id " +
                     "WHERE p.user_id = ? AND (p.post_type IS NULL OR p.post_type != 'REEL') " +
                     "ORDER BY p.id DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                CommentDAO commentDAO = new CommentDAO();
                while (rs.next()) {
                    UsersPost post = new UsersPost(
                            rs.getInt("posts_id"),
                            rs.getString("name"),
                            rs.get
                            rs.getString("name"),
                            rs.getInt("user_id"),
                            rs.getString("content"),

                            rs.getString("post_type"),
                            rs.getString("feeling")
                    );
                    post.setProfile_pic(rs.getString("profile_pic"));
                    post.setTime(rs.getString("created_at"));
                    post.setLikeCount(getInteractionCountInternal(conn, post.getId(), "LIKE"));
                    post.setLoveCount(getInteractionCountInternal(conn, post.getId(), "LOVE"));
                    post.setHahaCount(getInteractionCountInternal(conn, post.getId(), "HAHA"));
                    post.setAngryCount(getInteractionCountInternal(conn, post.getId(), "ANGRY"));
                    post.setCareCount(getInteractionCountInternal(conn, post.getId(), "CARE"));
                    post.setWowCount(getInteractionCountInternal(conn, post.getId(), "WOW"));
                    post.setSadCount(getInteractionCountInternal(conn, post.getId(), "SAD"));
                    post.setDislikes(getInteractionCountInternal(conn, post.getId(), "DISLIKES"));

                    post.setCommentCount(commentDAO.getCommentCountInternal(conn, post.getId()));
                    post.setShareCount(rs.getInt("share_count"));
                    
                    // 📝 Fetch comments for this post using the same connection
                    post.setComments(commentDAO.getCommentsByPostIdInternal(conn, post.getId()));

                    list.add(post);
                }
            }
        } catch (Exception e) {
            System.err.println("Error in getPostsByUserId: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // কানেকশন পাস করে কাউন্ট আনার জন্য ইন্টারনাল মেথড (পারফরম্যান্স ফিক্স)
    private int getInteractionCountInternal(Connection conn, int postId, String type) {









































































































































































































































































































































                    up.setLikeCount(rs.getInt("like_count"));
                    up.setLoveCount(rs.getInt("love_count"));
                    up.setCareCount(rs.getInt("care_count"));
                    up.setHahaCount(rs.getInt("haha_count"));
                    up.setWowCount(rs.getInt("wow_count"));
                    up.setSadCount(rs.getInt("sad_count"));
                    up.setAngryCount(rs.getInt("angry_count"));
                    up.setDislikes(rs.getInt("dislike_count"));

                    list.add(up);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ================= GET MEMORIES POSTS =================
    public List<UsersPost> getMemoriesPosts(int userId) {
        List<UsersPost> list = new ArrayList<>();
        String sql =
            "SELECT p.id AS posts_id, u.name, p.user_id AS users_id, p.content, p.file_name, p.post_type, p.feeling, " +
            "       u.profile_pic, p.created_at, p.share_count, " +
            "       SUM(CASE WHEN pi.type='LIKE'     THEN 1 ELSE 0 END) AS like_count, " +
            "       SUM(CASE WHEN pi.type='LOVE'     THEN 1 ELSE 0 END) AS love_count, " +
            "       SUM(CASE WHEN pi.type='CARE'     THEN 1 ELSE 0 END) AS care_count, " +
            "       SUM(CASE WHEN pi.type='HAHA'     THEN 1 ELSE 0 END) AS haha_count, " +
            "       SUM(CASE WHEN pi.type='WOW'      THEN 1 ELSE 0 END) AS wow_count, " +
            "       SUM(CASE WHEN pi.type='SAD'      THEN 1 ELSE 0 END) AS sad_count, " +
            "       SUM(CASE WHEN pi.type='ANGRY'    THEN 1 ELSE 0 END) AS angry_count, " +
            "       SUM(CASE WHEN pi.type='DISLIKES'  THEN 1 ELSE 0 END) AS dislike_count " +
            "FROM posts p " +
            "JOIN users u ON p.user_id = u.id " +
            "LEFT JOIN post_interactions pi ON p.id = pi.post_id " +
            "WHERE p.user_id = ? " +
            "GROUP BY p.id, u.name, p.user_id, p.content, p.file_name, p.post_type, p.feeling, u.profile_pic, p.created_at, p.share_count " +
            "ORDER BY p.created_at ASC " +
            "LIMIT 10";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UsersPost up = new UsersPost();
                    up.setId(rs.getInt("posts_id"));
                    up.setName(rs.getString("name"));
                    up.setUserId(rs.getInt("users_id"));
                    up.setContent(rs.getString("content"));
                    up.setFile_name(rs.getString("file_name"));
                    up.setPost_type(rs.getString("post_type"));
                    up.setFeeling(rs.getString("feeling"));
                    up.setProfile_pic(rs.getString("profile_pic"));
                    up.setTime(rs.getString("created_at"));
                    up.setShareCount(rs.getInt("share_count"));

                    up.setLikeCount(rs.getInt("like_count"));
                    up.setLoveCount(rs.getInt("love_count"));
                    up.setCareCount(rs.getInt("care_count"));
                    up.setHahaCount(rs.getInt("haha_count"));
                    up.setWowCount(rs.getInt("wow_count"));
                    up.setSadCount(rs.getInt("sad_count"));
                    up.setAngryCount(rs.getInt("angry_count"));
                    up.setDislikes(rs.getInt("dislike_count"));

                    list.add(up);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

    }
}