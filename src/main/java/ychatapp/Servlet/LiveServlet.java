package ychatapp.Servlet;

import java.io.IOException;
import java.util.ArrayList;
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
      




















            
            for (UsersBeans friend : friends) {
                try {
                    notifDao.addNotification(friend.getId(), notifMsg);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            res.getWriter().write("{\"success\": true}");

        } else if ("end".equalsIgnoreCase(action)) {
            LiveManager.endStream(ub.getName());
            res.getWriter().write("{\"success\": true}");

        } else if ("getLiveFriends".equalsIgnoreCase(action)) {
            List<UsersBeans> friends = usersDao.getFriends(ub.getId());
            List<String> liveFriendListJson = new ArrayList<>();

            for (UsersBeans friend : friends) {
                LiveManager.LiveStreamInfo info = LiveManager.getStream(friend.getName());
                if (info != null) {
                    String pic = friend.getProfile_pic();
                    if (pic == null || pic.trim().isEmpty()) {
                        pic = "default-avatar.png";
                    }
                    String escapedTitle = info.getTitle().replace("\"", "\\\"");
                    liveFriendListJson.add("{" +
                        "\"username\": \"" + friend.getName() + "\"," +
                        "\"profilePic\": \"" + pic + "\"," +
                        "\"title\": \"" + escapedTitle + "\"" +
                    "}");
                }
            }

            String jsonResponse = "{\"success\": true, \"liveFriends\": [" + String.join(",", liveFriendListJson) + "]}";
            res.getWriter().write(jsonResponse);
        } else {
            res.getWriter().write("{\"success\": false, \"error\": \"Unknown action\"}");
        }
    }
}
