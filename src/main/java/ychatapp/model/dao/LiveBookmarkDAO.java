package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import ychatapp.model.beans.LiveBookmarkBeans;

public class LiveBookmarkDAO {
    private static volatile boolean tableReady;

    private Connection getConnection() throws Exception { return DBConnection.getConnection(); }

    private void ensureTable() throws Exception {
        if (tableReady) return;
        synchronized (LiveBookmarkDAO.class) {
            if (tableReady) return;
            try (Connection connection = getConnection(); java.sql.Statement statement = connection.createStatement()) {
                statement.executeUpdate("CREATE TABLE IF NOT EXISTS live_bookmarks (" +
                    "user_id INT NOT NULL, streamer_id INT NOT NULL, streamer_name VARCHAR(100) NOT NULL, " +
                    "title VARCHAR(255) NOT NULL, saved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "PRIMARY KEY (user_id, streamer_id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");
                tableReady = true;
            }
        }
    }

    public boolean save(int userId, int streamerId, String streamerName, String title) {
        try {
            ensureTable();
            String sql = "INSERT INTO live_bookmarks(user_id, streamer_id, streamer_name, title) VALUES(?,?,?,?) " +
                         "ON DUPLICATE KEY UPDATE streamer_name=VALUES(streamer_name), title=VALUES(title)";
            try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setInt(1, userId);
                statement.setInt(2, streamerId);
                statement.setString(3, streamerName);
                statement.setString(4, title);
                statement.executeUpdate();
                return true;
            }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean remove(int userId, int streamerId) {
        try {
            ensureTable();
            try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(
                    "DELETE FROM live_bookmarks WHERE user_id=? AND streamer_id=?")) {
                statement.setInt(1, userId);
                statement.setInt(2, streamerId);
                return statement.executeUpdate() > 0;
            }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean isSaved(int userId, int streamerId) {
        try {
            ensureTable();
            try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(
                    "SELECT 1 FROM live_bookmarks WHERE user_id=? AND streamer_id=?")) {
                statement.setInt(1, userId);
                statement.setInt(2, streamerId);
                try (ResultSet result = statement.executeQuery()) { return result.next(); }
            }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public List<LiveBookmarkBeans> getSaved(int userId) {
        List<LiveBookmarkBeans> saved = new ArrayList<>();
        try {
            ensureTable();
            try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(
                    "SELECT streamer_id, streamer_name, title, saved_at FROM live_bookmarks WHERE user_id=? ORDER BY saved_at DESC")) {
                statement.setInt(1, userId);
                try (ResultSet result = statement.executeQuery()) {
                    while (result.next()) {
                        LiveBookmarkBeans bookmark = new LiveBookmarkBeans();
                        bookmark.setStreamerId(result.getInt("streamer_id"));
                        bookmark.setStreamerName(result.getString("streamer_name"));
                        bookmark.setTitle(result.getString("title"));
                        bookmark.setSavedAt(result.getString("saved_at"));
                        saved.add(bookmark);
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return saved;
    }
}
