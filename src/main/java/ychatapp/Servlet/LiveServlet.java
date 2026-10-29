package ychatapp.Servlet;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ychatapp.model.LiveManager;
import ychatapp.model.LiveManager.LiveStreamInfo;
import ychatapp.model.beans.LiveBookmarkBeans;
import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.LiveBookmarkDAO;
import ychatapp.model.dao.NotificationDAO;
import ychatapp.model.dao.UsersDAO;

@WebServlet("/LiveServlet")
public class LiveServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final LiveBookmarkDAO bookmarks = new LiveBookmarkDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        doPost(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");
        res.setContentType("application/json;charset=UTF-8");
        HttpSession session = req.getSession(false);
        UsersBeans user = session == null ? null : (UsersBeans) session.getAttribute("ub");
        if (user == null) {
            write(res, error("Unauthorized"));
            return;
        }

        String action = req.getParameter("action");
        if (action == null) {
            write(res, error("Missing action"));
            return;
        }

        switch (action.toLowerCase()) {
            case "start": startStream(req, res, user); break;
            case "end": endStream(res, user); break;
            case "list":
            case "status": listStreams(res, user); break;
            case "save": saveStream(req, res, user); break;
            case "unsave": unsaveStream(req, res, user); break;
            case "saved": listSaved(res, user); break;
            case "join":
                LiveManager.addViewer(req.getParameter("streamer"), user.getName());
                write(res, success());
                break;
            case "leave":
                LiveManager.removeViewer(req.getParameter("streamer"), user.getName());
                write(res, success());
                break;
            default: write(res, error("Unknown action"));
        }
    }

    private void startStream(HttpServletRequest req, HttpServletResponse res, UsersBeans user) throws IOException {
        String title = req.getParameter("title");
        title = title == null || title.trim().isEmpty() ? "Live Broadcast" : title.trim();
        if (title.length() > 250) title = title.substring(0, 250);
        LiveStreamInfo existing = LiveManager.getStream(user.getName());
        if (existing == null) LiveManager.startStream(user.getId(), user.getName(), title);

        try {
            List<UsersBeans> friends = new UsersDAO().getFriends(user.getId());
            NotificationDAO notifications = new NotificationDAO();
            String message = user.getName() + " is live now: " + title;
            for (UsersBeans friend : friends) {
                notifications.addNotification(friend.getId(), user.getId(), "LIVE", message);
            }
        } catch (Exception e) {
            getServletContext().log("Could not notify friends about live stream", e);
        }
        write(res, success());
    }

    private void endStream(HttpServletResponse res, UsersBeans user) throws IOException {
        LiveStreamInfo ending = LiveManager.getStream(user.getName());
        if (ending != null) {
            for (String viewer : ending.getViewers()) {
                ychatapp.websocket.UserWebSocket.sendToUser(viewer, "LIVE_ENDED|" + user.getName() + "|{}");
            }
        }
        LiveManager.endStream(user.getName());
        write(res, success());
    }

    private void listStreams(HttpServletResponse res, UsersBeans user) throws IOException {
        com.google.gson.JsonArray streams = new com.google.gson.JsonArray();
        for (LiveStreamInfo stream : LiveManager.getActiveStreams()) {
            com.google.gson.JsonObject item = new com.google.gson.JsonObject();
            item.addProperty("streamer", stream.getStreamerUsername());
            item.addProperty("streamerId", stream.getStreamerId());
            item.addProperty("title", stream.getTitle());
            item.addProperty("viewersCount", stream.getViewers().size());
            item.addProperty("startTime", stream.getStartTime());
            item.addProperty("saved", bookmarks.isSaved(user.getId(), stream.getStreamerId()));
            streams.add(item);
        }
        com.google.gson.JsonObject result = new com.google.gson.JsonObject();
        result.addProperty("success", true);
        result.add("streams", streams);
        write(res, result);
    }

    private void saveStream(HttpServletRequest req, HttpServletResponse res, UsersBeans user) throws IOException {
        int streamerId = parseId(req.getParameter("streamerId"));
        LiveStreamInfo stream = null;
        for (LiveStreamInfo active : LiveManager.getActiveStreams()) {
            if (active.getStreamerId() == streamerId) { stream = active; break; }
        }
        if (streamerId <= 0 || stream == null || streamerId == user.getId()) {
            write(res, error("This live broadcast is no longer available"));
            return;
        }
        boolean saved = bookmarks.save(user.getId(), stream.getStreamerId(), stream.getStreamerUsername(), stream.getTitle());
        write(res, state(saved, saved));
    }

    private void unsaveStream(HttpServletRequest req, HttpServletResponse res, UsersBeans user) throws IOException {
        int streamerId = parseId(req.getParameter("streamerId"));
        boolean removed = streamerId > 0 && bookmarks.remove(user.getId(), streamerId);
        write(res, state(removed, false));
    }

    private void listSaved(HttpServletResponse res, UsersBeans user) throws IOException {
        com.google.gson.JsonArray items = new com.google.gson.JsonArray();
        for (LiveBookmarkBeans saved : bookmarks.getSaved(user.getId())) {
            com.google.gson.JsonObject item = new com.google.gson.JsonObject();
            item.addProperty("streamerId", saved.getStreamerId());
            item.addProperty("streamer", saved.getStreamerName());
            item.addProperty("title", saved.getTitle());
            item.addProperty("savedAt", saved.getSavedAt());
            LiveStreamInfo active = LiveManager.getStream(saved.getStreamerName());
            item.addProperty("isLive", active != null && active.getStreamerId() == saved.getStreamerId());
            items.add(item);
        }
        com.google.gson.JsonObject result = new com.google.gson.JsonObject();
        result.addProperty("success", true);
        result.add("savedLives", items);
        write(res, result);
    }

    private int parseId(String value) {
        try { return Integer.parseInt(value); } catch (Exception ignored) { return -1; }
    }

    private com.google.gson.JsonObject success() {
        com.google.gson.JsonObject result = new com.google.gson.JsonObject();
        result.addProperty("success", true);
        return result;
    }

    private com.google.gson.JsonObject error(String message) {
        com.google.gson.JsonObject result = new com.google.gson.JsonObject();
        result.addProperty("success", false);
        result.addProperty("error", message);
        return result;
    }

    private com.google.gson.JsonObject state(boolean success, boolean saved) {
        com.google.gson.JsonObject result = new com.google.gson.JsonObject();
        result.addProperty("success", success);
        result.addProperty("saved", saved);
        return result;
    }

    private void write(HttpServletResponse res, com.google.gson.JsonObject json) throws IOException {
        res.getWriter().write(json.toString());
    }
}
