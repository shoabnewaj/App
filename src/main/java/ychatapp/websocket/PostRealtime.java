package ychatapp.websocket;

import java.util.LinkedHashSet;
import java.util.Set;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.UsersDAO;

/** Publishes feed changes to the author and their accepted friends. */
public final class PostRealtime {
    private PostRealtime() {}

    public static void publish(int authorId, int postId, String activity, String actor) {
        try {
            UsersDAO users = new UsersDAO();
            Set<String> recipients = new LinkedHashSet<>();
            UsersBeans author = users.getUserById(authorId);
            if (author != null && author.getName() != null) recipients.add(author.getName());
            for (UsersBeans friend : users.getFriends(authorId)) {
                if (friend.getName() != null) recipients.add(friend.getName());
            }
            String payload = "POST_ACTIVITY|" + postId + "|" + activity + "|" + actor;
            for (String recipient : recipients) {
                if (!recipient.equalsIgnoreCase(actor)) UserWebSocket.sendToUser(recipient, payload);
            }
        } catch (Exception e) {
            org.slf4j.LoggerFactory.getLogger(PostRealtime.class).warn("Could not publish post activity: {}", e.getMessage());
        }
    }
}
