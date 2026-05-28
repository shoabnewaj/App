package ychatapp.websocket;
 
import java.io.IOException;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
 
import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;
import ychatapp.model.LiveManager;

@ServerEndpoint("/ws/user/{username}")
public class UserWebSocket {
    private static final org.slf4j.Logger logger = org.slf4j.LoggerFactory.getLogger(UserWebSocket.class);
 
    private static final ConcurrentHashMap<String, Set<Session>> clients = new ConcurrentHashMap<>();
 
    @OnOpen
    public void onOpen(Session session, @PathParam("username") String encodedUsername) {
        String username = decodeUsername(encodedUsername);
        clients.computeIfAbsent(username, k -> ConcurrentHashMap.newKeySet()).add(session);
        System.out.println("User Online: " + username + " (sessions: " + clients.get(username).size() + ")");
        broadcastOnlineUsers();
    }
 
    @OnMessage
    public void onMessage(String message, Session session, @PathParam("username") String encodedSender) {
        String sender = decodeUsername(encodedSender);
        try {
            String[] parts = message.split("\\|", 3);
            if (parts.length < 2) {
                return;
            }
            String type = parts[0];
            String receiver = parts[1];
            String content = parts.length > 2 ? parts[2] : "";

            if ("CHAT".equalsIgnoreCase(type)) {
                sendMessageToUser(receiver, "CHAT|" + sender + "|" + content);
            } else if ("CALL_SDP".equalsIgnoreCase(type) || 
                       "CALL_CANDIDATE".equalsIgnoreCase(type) || 
                       "CALL_BUSY".equalsIgnoreCase(type) || 
                       "CALL_REJECT".equalsIgnoreCase(type) || 
                       "CALL_ACCEPT".equalsIgnoreCase(type) ||
                       "LIVE_SIGNAL".equalsIgnoreCase(type)) {
                sendMessageToUser(receiver, type + "|" + sender + "|" + content);
            } else if ("LIVE_CHAT".equalsIgnoreCase(type)) {
                broadcastToLiveStream(receiver, "LIVE_CHAT|" + sender + "|" + content);
            } else if ("LIVE_REACTION".equalsIgnoreCase(type)) {
                broadcastToLiveStream(receiver, "LIVE_REACTION|" + sender + "|" + content);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
 
    @OnClose
    public void onClose(Session session, @PathParam("username") String encodedUsername) {
        String username = decodeUsername(encodedUsername);
        Set<Session> userSessions = clients.get(username);
        if (userSessions != null) {
            userSessions.remove(session);
            if (userSessions.isEmpty()) {
                clients.remove(username);
                System.out.println("User Offline: " + username);
                
                LiveManager.endStream(username);
                for (LiveManager.LiveStreamInfo info : LiveManager.getActiveStreams()) {
                    LiveManager.removeViewer(info.getStreamerUsername(), username);
                }
                
                broadcastOnlineUsers();
            }
        }
    }

    @OnError
    public void onError(Session session, Throwable throwable, @PathParam("username") String encodedUsername) {
        String username = decodeUsername(encodedUsername);
        System.err.println("WebSocket Error for " + username + ": " + throwable.getMessage());
    }
 
    private String decodeUsername(String encoded) {
        try {
            return URLDecoder.decode(encoded, StandardCharsets.UTF_8.name());
        } catch (Exception e) {
            return encoded;
        }
    }

    public static void sendNotification(String username, String message) {
        Set<Session> userSessions = clients.get(username);
        if (userSessions != null) {
            for (Session s : userSessions) {
                if (s.isOpen()) {
                    try {
                        s.getBasicRemote().sendText("NOTIFICATION|" + message);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }

    private void sendMessageToUser(String username, String message) {
        Set<Session> userSessions = clients.get(username);
        if (userSessions != null) {
            for (Session s : userSessions) {
                if (s.isOpen()) {
                    try {
                        s.getBasicRemote().sendText(message);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }

    private void broadcastToLiveStream(String streamer, String message) {
        LiveManager.LiveStreamInfo stream = LiveManager.getStream(streamer);
        if (stream != null) {
            sendMessageToUser(streamer, message);
            for (String viewer : stream.getViewers()) {
                sendMessageToUser(viewer, message);
            }
        }
    }

    private void broadcastOnlineUsers() {
        StringBuilder sb = new StringBuilder("ONLINE_LIST|");
        int count = 0;
        for (String user : clients.keySet()) {
            if (count > 0) {
                sb.append(",");
            }
            sb.append(user);
            count++;
        }
        String listMsg = sb.toString();
        for (String user : clients.keySet()) {
            sendMessageToUser(user, listMsg);
        }
    }
}