package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import ychatapp.model.beans.StoryBeans;

public class StoryDAO {

    public StoryDAO() {
        createTableIfNotExists();
    }

    private Connection getConnection() throws Exception {
        return DBConnection.getConnection();
    }

    private void createTableIfNotExists() {
        String sql = "CREATE TABLE IF NOT EXISTS stories (" +
                     "id INT AUTO_INCREMENT PRIMARY KEY," +
                     "user_id INT NOT NULL," +
                     "media_url VARCHAR(255) DEFAULT NULL," +
                     "text VARCHAR(255) DEFAULT NULL," +
                     "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                     "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE" +
                     ")";
        String viewsTableSql = "CREATE TABLE IF NOT EXISTS story_views (" +
                     "id INT AUTO_INCREMENT PRIMARY KEY," +
                     "story_id INT NOT NULL," +
                     "viewer_id INT NOT NULL," +
                     "viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                     "UNIQUE KEY unique_story_viewer (story_id, viewer_id)," +
                     "FOREIGN KEY (story_id) REFERENCES stories(id) ON DELETE CASCADE," +
                     "FOREIGN KEY (viewer_id) REFERENCES users(id) ON DELETE CASCADE" +
                     ")";
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
            try { stmt.executeUpdate("ALTER TABLE stories ADD COLUMN audience VARCHAR(16) NOT NULL DEFAULT 'PUBLIC'"); } catch (Exception ignored) {}
            stmt.execute(viewsTableSql);
        } catch (Exception e) {
            System.err.println("Error creating stories/story_views table: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public boolean addStory(int userId, String mediaUrl, String text) { return addStory(userId, mediaUrl, text, "PUBLIC"); }

    public boolean addStory(int userId, String mediaUrl, String text, String audience) {
        if (audience == null || !audience.matches("PUBLIC|FRIENDS|PRIVATE")) audience = "PUBLIC";
        String sql = "INSERT INTO stories (user_id, media_url, text, audience) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId); ps.setString(2, mediaUrl); ps.setString(3, text); ps.setString(4, audience);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<StoryBeans> getActiveStories() { return getActiveStories(0); }

    public List<StoryBeans> getActiveStories(int viewerId) {
        List<StoryBeans> list = new ArrayList<>();
        // 1. First attempt to fetch stories from the last 24 hours
        String sql = "SELECT s.id, s.user_id, s.media_url, s.text, s.created_at, " +
                     "       (SELECT COUNT(*) FROM story_views sv WHERE sv.story_id = s.id) AS view_count, " +
                     "       u.name, u.profile_pic " +
                     "FROM stories s " +
                     "JOIN users u ON s.user_id = u.id " +
                     "WHERE s.created_at >= NOW() - INTERVAL 1 DAY AND (s.audience='PUBLIC' OR s.user_id=? OR (s.audience='FRIENDS' AND EXISTS (SELECT 1 FROM friendships f WHERE f.status='ACCEPTED' AND ((f.user_id1=s.user_id AND f.user_id2=?) OR (f.user_id2=s.user_id AND f.user_id1=?))))) " +
                     "ORDER BY s.id DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, viewerId); ps.setInt(2, viewerId); ps.setInt(3, viewerId);
            try (ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                StoryBeans story = new StoryBeans();
                story.setId(rs.getInt("id"));
                story.setUserId(rs.getInt("user_id"));
                story.setMediaUrl(rs.getString("media_url"));
                story.setText(rs.getString("text"));
                story.setCreatedAt(rs.getString("created_at"));
                story.setViewCount(rs.getInt("view_count"));
                story.setName(rs.getString("name"));
                story.setProfilePic(rs.getString("profile_pic"));
                list.add(story);
            }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 2. Fallback: If no stories were posted in the last 24 hours (e.g. testing/demo), show the most recent stories
        if (list.isEmpty()) {
            String fallbackSql = "SELECT s.id, s.user_id, s.media_url, s.text, s.created_at, " +
                                 "       (SELECT COUNT(*) FROM story_views sv WHERE sv.story_id = s.id) AS view_count, " +
                                 "       u.name, u.profile_pic " +
                                 "FROM stories s " +
                                 "JOIN users u ON s.user_id = u.id " +
                                 "WHERE (s.audience='PUBLIC' OR s.user_id=? OR (s.audience='FRIENDS' AND EXISTS (SELECT 1 FROM friendships f WHERE f.status='ACCEPTED' AND ((f.user_id1=s.user_id AND f.user_id2=?) OR (f.user_id2=s.user_id AND f.user_id1=?))))) " +
                                 "ORDER BY s.id DESC LIMIT 15";
            try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(fallbackSql)) {
                ps.setInt(1, viewerId); ps.setInt(2, viewerId); ps.setInt(3, viewerId);
                try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    StoryBeans story = new StoryBeans();
                    story.setId(rs.getInt("id"));
                    story.setUserId(rs.getInt("user_id"));
                    story.setMediaUrl(rs.getString("media_url"));
                    story.setText(rs.getString("text"));
                    story.setCreatedAt(rs.getString("created_at"));
                    story.setViewCount(rs.getInt("view_count"));
                    story.setName(rs.getString("name"));
                    story.setProfilePic(rs.getString("profile_pic"));
                    list.add(story);
                }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return list;
    }

    public boolean canViewStory(int storyId, int viewerId) {
        String sql="SELECT s.user_id,s.audience FROM stories s WHERE s.id=?";
        try(Connection c=getConnection();PreparedStatement p=c.prepareStatement(sql)){p.setInt(1,storyId);try(ResultSet r=p.executeQuery()){if(!r.next())return false;int owner=r.getInt(1);String audience=r.getString(2);if(owner==viewerId||"PUBLIC".equals(audience))return true;if(!"FRIENDS".equals(audience))return false;try(PreparedStatement f=c.prepareStatement("SELECT 1 FROM friendships WHERE status='ACCEPTED' AND ((user_id1=? AND user_id2=?) OR (user_id1=? AND user_id2=?)) LIMIT 1")){f.setInt(1,owner);f.setInt(2,viewerId);f.setInt(3,viewerId);f.setInt(4,owner);try(ResultSet fr=f.executeQuery()){return fr.next();}}}}catch(Exception e){return false;}
    }
    public boolean isStoryOwner(int storyId,int userId){try(Connection c=getConnection();PreparedStatement p=c.prepareStatement("SELECT 1 FROM stories WHERE id=? AND user_id=?")){p.setInt(1,storyId);p.setInt(2,userId);try(ResultSet r=p.executeQuery()){return r.next();}}catch(Exception e){return false;}}

    // ================= RECORD STORY VIEW =================
    public boolean recordStoryView(int storyId, int viewerId) {
        String insertSql = "INSERT IGNORE INTO story_views (story_id, viewer_id) VALUES (?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(insertSql)) {
            ps.setInt(1, storyId);
            ps.setInt(2, viewerId);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (PreparedStatement psUpdate = conn.prepareStatement(
                        "UPDATE stories SET view_count = (SELECT COUNT(*) FROM story_views WHERE story_id = ?) WHERE id = ?")) {
                    psUpdate.setInt(1, storyId);
                    psUpdate.setInt(2, storyId);
                    psUpdate.executeUpdate();
                } catch (Exception e) {
                    // ignore column missing if any
                }
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ================= GET STORY VIEWERS =================
    public List<ychatapp.model.beans.StoryViewerBean> getStoryViewers(int storyId) {
        List<ychatapp.model.beans.StoryViewerBean> list = new ArrayList<>();
        String sql = "SELECT sv.viewer_id, sv.viewed_at, u.name, u.profile_pic " +
                     "FROM story_views sv " +
                     "JOIN users u ON sv.viewer_id = u.id " +
                     "WHERE sv.story_id = ? " +
                     "ORDER BY sv.viewed_at DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, storyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ychatapp.model.beans.StoryViewerBean viewer = new ychatapp.model.beans.StoryViewerBean(
                        rs.getInt("viewer_id"),
                        rs.getString("name"),
                        rs.getString("profile_pic"),
                        rs.getString("viewed_at")
                    );
                    list.add(viewer);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}