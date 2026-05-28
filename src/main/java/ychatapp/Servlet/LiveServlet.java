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
import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.NotificationDAO;
import ychatapp.model.dao.UsersDAO;

@WebServlet("/LiveServlet")
public class LiveServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        doPost(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");
        res.setContentType("application/json");

        HttpSession session = req.getSession(false);
        UsersBeans ub = (session != null) ? (UsersBeans) session.getAttribute("ub") : null;

        if (ub == null) {
            res.getWriter().write("{\"success\": false, \"error\": \"Unauthorized\"}");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) {
            res.getWriter().write("{\"success\": false, \"error\": \"Missing action\"}");
            return;
        }

        UsersDAO usersDao = new UsersDAO();
        NotificationDAO notifDao = new NotificationDAO();

        if ("start".equalsIgnoreCase(action)) {
            String title = req.getParameter("title");
            if (title == null || title.trim().isEmpty()) {
                title = "Live Broadcast";
            }
            title = title.trim();

            LiveManager.startStream(ub.getName(), title);

            // Notify followers
            try {
                List<Integer> followers = usersDao.getFollowingUserIds(ub.getId());
                if (followers != null) {
                    for (int followerId : followers) {
                        notifDao.addNotification(followerId, ub.getId(), "LIVE", ub.getName() + " is live now: " + title);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            res.getWriter().write("{\"success\": true}");
        } else if ("end".equalsIgnoreCase(action)) {
            LiveManager.endStream(ub.getName());
            res.getWriter().write("{\"success\": true}");
        } else if ("join".equalsIgnoreCase(action)) {
            String streamer = req.getParameter("streamer");
            if (streamer != null && !streamer.trim().isEmpty()) {
                LiveManager.addViewer(streamer.trim(), ub.getName());
                res.getWriter().write("{\"success\": true}");
            } else {
                res.getWriter().write("{\"success\": false, \"error\": \"Missing streamer\"}");
            }
        } else if ("leave".equalsIgnoreCase(action)) {
            String streamer = req.getParameter("streamer");
            if (streamer != null && !streamer.trim().isEmpty()) {
                LiveManager.removeViewer(streamer.trim(), ub.getName());
                res.getWriter().write("{\"success\": true}");
            } else {
                res.getWriter().write("{\"success\": false, \"error\": \"Missing streamer\"}");
            }
        } else if ("list".equalsIgnoreCase(action) || "status".equalsIgnoreCase(action)) {
            List<LiveManager.LiveStreamInfo> streams = LiveManager.getActiveStreams();
            StringBuilder sb = new StringBuilder();
            sb.append("[");
            for (int i = 0; i < streams.size(); i++) {
                LiveManager.LiveStreamInfo info = streams.get(i);
                sb.append("{");
                sb.append("\"streamer\":\"").append(escapeJson(info.getStreamerUsername())).append("\",");
                sb.append("\"title\":\"").append(escapeJson(info.getTitle())).append("\",");
                sb.append("\"viewersCount\":").append(info.getViewers().size()).append(",");
                sb.append("\"startTime\":").append(info.getStartTime());
                sb.append("}");
                if (i < streams.size() - 1) {
                    sb.append(",");
                }
            }
            sb.append("]");
            res.getWriter().write("{\"success\": true, \"streams\": " + sb.toString() + "}");
        } else {
            res.getWriter().write("{\"success\": false, \"error\": \"Unknown action\"}");
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}