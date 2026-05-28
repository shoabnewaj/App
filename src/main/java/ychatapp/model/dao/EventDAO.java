package ychatapp.model.dao;
 
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import ychatapp.model.beans.EventBeans;
 
public class EventDAO {
 
    public EventDAO() {
        createTablesIfNotExists();
    }
 
    private Connection getConnection() throws Exception {
        return DBConnection.getConnection();
    }
 
    private void createTablesIfNotExists() {
        String eventsSql = "CREATE TABLE IF NOT EXISTS events (" +
                           "id INT AUTO_INCREMENT PRIMARY KEY," +
                           "user_id INT NOT NULL," +
                           "title VARCHAR(255) NOT NULL," +
                           "description TEXT," +
                           "event_date VARCHAR(100) NOT NULL," +
                           "location VARCHAR(255) NOT NULL," +
                           "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                           "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE" +
                           ")";
 
        String rsvpsSql = "CREATE TABLE IF NOT EXISTS event_rsvps (" +
                          "id INT AUTO_INCREMENT PRIMARY KEY," +
                          "event_id INT NOT NULL," +
                          "user_id INT NOT NULL," +
                          "status VARCHAR(20) NOT NULL," +
                          "FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE," +
                          "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE," +
                          "UNIQUE KEY (event_id, user_id)" +
                          ")";
 
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(eventsSql);
            stmt.execute(rsvpsSql);
        } catch (Exception e) {
            System.err.println("Error creating events tables: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public boolean addEvent(int userId, String title, String description, String eventDate, String location) {
        String sql = "INSERT INTO events (user_id, title, description, event_date, location) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, title);
            ps.setString(3, description);
            ps.setString(4, eventDate);
            ps.setString(5, location);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteEvent(int eventId, int userId) {
        String sql = "DELETE FROM events WHERE id = ? AND user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<EventBeans> getAllEvents(int currentUserId) {
        List<EventBeans> list = new ArrayList<>();
        String sql = "SELECT e.*, u.name AS creator_name, u.profile_pic AS creator_pic " +
                     "FROM events e JOIN users u ON e.user_id = u.id " +
                     "ORDER BY e.created_at DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                EventBeans eb = new EventBeans();
                eb.setId(rs.getInt("id"));
                eb.setUserId(rs.getInt("user_id"));
                eb.setUserName(rs.getString("creator_name"));
                eb.setUserProfilePic(rs.getString("creator_pic"));
                eb.setTitle(rs.getString("title"));
                eb.setDescription(rs.getString("description"));
                eb.setEventDate(rs.getString("event_date"));
                eb.setLocation(rs.getString("location"));
                eb.setCreatedAt(rs.getString("created_at"));
                
                loadRsvpDetails(conn, eb, currentUserId);
                
                list.add(eb);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private void loadRsvpDetails(Connection conn, EventBeans eb, int currentUserId) {
        String rsvpCountSql = "SELECT status, COUNT(*) AS cnt FROM event_rsvps WHERE event_id = ? GROUP BY status";
        try (PreparedStatement ps = conn.prepareStatement(rsvpCountSql)) {
            ps.setInt(1, eb.getId());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String status = rs.getString("status");
                    int cnt = rs.getInt("cnt");
                    if ("GOING".equalsIgnoreCase(status)) {
                        eb.setRsvpCountGoing(cnt);
                    } else if ("INTERESTED".equalsIgnoreCase(status)) {
                        eb.setRsvpCountInterested(cnt);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        String userRsvpSql = "SELECT status FROM event_rsvps WHERE event_id = ? AND user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(userRsvpSql)) {
            ps.setInt(1, eb.getId());
            ps.setInt(2, currentUserId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    eb.setCurrentUserRsvp(rs.getString("status").toUpperCase());
                } else {
                    eb.setCurrentUserRsvp(null);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean setRsvp(int eventId, int userId, String status) {
        if (status == null || "NONE".equalsIgnoreCase(status) || status.trim().isEmpty()) {
            String sql = "DELETE FROM event_rsvps WHERE event_id = ? AND user_id = ?";
            try (Connection conn = getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, eventId);
                ps.setInt(2, userId);
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        } else {
            String sql = "INSERT INTO event_rsvps (event_id, user_id, status) VALUES (?, ?, ?) " +
                         "ON DUPLICATE KEY UPDATE status = ?";
            try (Connection conn = getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, eventId);
                ps.setInt(2, userId);
                ps.setString(3, status.toUpperCase());
                ps.setString(4, status.toUpperCase());
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        }
    }
}