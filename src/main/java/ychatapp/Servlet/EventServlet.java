package ychatapp.Servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.beans.EventBeans;
import ychatapp.model.dao.EventDAO;

@WebServlet("/EventServlet")
public class EventServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final EventDAO eventDAO = new EventDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.setContentType("application/json; charset=UTF-8");
        PrintWriter out = res.getWriter();

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("ub") == null) {
            out.print("{\"success\": false, \"message\": \"Not authenticated\"}");
            return;
        }

        UsersBeans ub = (UsersBeans) session.getAttribute("ub");
        List<EventBeans> list = eventDAO.getAllEvents(ub.getId());
        out.print("{\"success\": true, \"events\": " + toJsonString(list) + "}");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        res.setContentType("application/json; charset=UTF-8");
        PrintWriter out = res.getWriter();

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("ub") == null) {
            out.print("{\"success\": false, \"message\": \"Not authenticated\"}");
            return;
        }

        UsersBeans ub = (UsersBeans) session.getAttribute("ub");
        String action = req.getParameter("action");

        if ("CREATE".equalsIgnoreCase(action)) {
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String eventDate = req.getParameter("eventDate");
            String location = req.getParameter("location");

            if (title == null || title.trim().isEmpty() || eventDate == null || eventDate.trim().isEmpty() || location == null || location.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"Missing parameters\"}");
                return;
            }

            boolean ok = eventDAO.addEvent(ub.getId(), title.trim(), description != null ? description.trim() : "", eventDate.trim(), location.trim());
            out.print("{\"success\": " + ok + "}");
        } else if ("DELETE".equalsIgnoreCase(action)) {
            String eventIdStr = req.getParameter("eventId");
            if (eventIdStr == null) {
                out.print("{\"success\": false, \"message\": \"Missing eventId\"}");
                return;
            }

            try {
                int eventId = Integer.parseInt(eventIdStr);
                boolean ok = eventDAO.deleteEvent(eventId, ub.getId());
                out.print("{\"success\": " + ok + "}");
            } catch (NumberFormatException e) {
                out.print("{\"success\": false, \"message\": \"Invalid eventId\"}");
            }
        } else if ("RSVP".equalsIgnoreCase(action)) {
            String eventIdStr = req.getParameter("eventId");
            String status = req.getParameter("status"); // GOING, INTERESTED, NONE
            if (eventIdStr == null || status == null) {
                out.print("{\"success\": false, \"message\": \"Missing parameters\"}");
                return;
            }

            try {
                int eventId = Integer.parseInt(eventIdStr);
                boolean ok = eventDAO.setRsvp(eventId, ub.getId(), status.trim());
                out.print("{\"success\": " + ok + "}");
            } catch (NumberFormatException e) {
                out.print("{\"success\": false, \"message\": \"Invalid eventId\"}");
            }
        } else {
            out.print("{\"success\": false, \"message\": \"Unknown action\"}");
        }
    }

    private String toJsonString(List<EventBeans> list) {
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        for (int i = 0; i < list.size(); i++) {
            EventBeans eb = list.get(i);
            sb.append("{");
            sb.append("\"id\":").append(eb.getId()).append(",");
            sb.append("\"userId\":").append(eb.getUserId()).append(",");
            sb.append("\"userName\":\"").append(escapeJson(eb.getUserName())).append("\",");
            sb.append("\"userProfilePic\":\"").append(escapeJson(eb.getUserProfilePic())).append("\",");
            sb.append("\"title\":\"").append(escapeJson(eb.getTitle())).append("\",");
            sb.append("\"description\":\"").append(escapeJson(eb.getDescription())).append("\",");
            sb.append("\"eventDate\":\"").append(escapeJson(eb.getEventDate())).append("\",");
            sb.append("\"location\":\"").append(escapeJson(eb.getLocation())).append("\",");
            sb.append("\"createdAt\":\"").append(escapeJson(eb.getCreatedAt())).append("\",");
            sb.append("\"rsvpCountGoing\":").append(eb.getRsvpCountGoing()).append(",");
            sb.append("\"rsvpCountInterested\":").append(eb.getRsvpCountInterested()).append(",");
            sb.append("\"currentUserRsvp\":").append(eb.getCurrentUserRsvp() != null ? "\"" + eb.getCurrentUserRsvp() + "\"" : "null");
            sb.append("}");
            if (i < list.size() - 1) {
                sb.append(",");
            }
        }
        sb.append("]");
        return sb.toString();
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