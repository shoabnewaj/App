package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import ychatapp.model.beans.UsersPost;
import ychatapp.model.beans.CommentBeans;
import ychatapp.model.beans.Reply;

public class HiddenContentDAO {

    private Connection getConnection() throws Exception {
        return DBConnection.getConnection();
    }

    public boolean hideItem(int userId, String itemType, int itemId) {
        String sql = "INSERT IGNORE INTO hidden_content(user_id, item_type, item_id) VALUES (?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, itemType.toUpperCase());
            ps.setInt(3, itemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Set<Integer> getHiddenItemIds(int userId, String itemType) {
        Set<Integer> set = new HashSet<>();
        String sql = "SELECT item_id FROM hidden_content WHERE user_id = ? AND item_type = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, itemType.toUpperCase());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    set.add(rs.getInt("item_id"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return set;
    }

    public void filterHiddenContent(List<UsersPost> posts, int userId) {
        if (posts == null || posts.isEmpty() || userId <= 0) {
            return;
        }

        Set<Integer> hiddenPosts = getHiddenItemIds(userId, "POST");
        Set<Integer> hiddenComments = getHiddenItemIds(userId, "COMMENT");
        Set<Integer> hiddenReplies = getHiddenItemIds(userId, "REPLY");

        Set<Integer> blockedUsers = new BlockDAO().getBlockedUserIds(userId);
        posts.removeIf(post -> hiddenPosts.contains(post.getId()) || blockedUsers.contains(post.getUserId()));

        for (UsersPost post : posts) {
            List<CommentBeans> comments = post.getComments();
            if (comments != null) {
                comments.removeIf(cmt -> hiddenComments.contains(cmt.getId()) || blockedUsers.contains(cmt.getUserId()));
                for (CommentBeans cmt : comments) {
                    List<Reply> replies = cmt.getReplies();
                    if (replies != null) {
                        replies.removeIf(reply -> hiddenReplies.contains(reply.getId()) || blockedUsers.contains(reply.getUserId()));
                    }
                }
            }
        }
    }
}