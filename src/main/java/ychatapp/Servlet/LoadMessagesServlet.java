package ychatapp.Servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import com.google.gson.Gson;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ychatapp.model.beans.UsersBeans;

import ychatapp.model.Message;
import ychatapp.model.dao.MessageDAO;
import ychatapp.model.dao.NotificationDAO;

@WebServlet("/loadMessages")
public class LoadMessagesServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {

        HttpSession session = req.getSession(false);
        UsersBeans current = session == null ? null : (UsersBeans) session.getAttribute("ub");
        String u1 = req.getParameter("user1"); // currently logged-in user
        if (current == null || u1 == null || !current.getName().equalsIgnoreCase(u1)) { res.sendError(HttpServletResponse.SC_UNAUTHORIZED); return; }
        String u2 = req.getParameter("user2"); // target friend

        MessageDAO dao = new MessageDAO();
        if (u1 != null && u2 != null) {
            // When u1 opens the chat with u2, mark all incoming messages from u2 to u1 as read
            dao.markAsRead(u2, u1);
            new NotificationDAO().markMessageNotificationsAsRead(current.getId(), u2);
        }

        List<Message> list = dao.getChat(u1, u2);

        res.setContentType("application/json;charset=UTF-8");
        PrintWriter out = res.getWriter();
        out.print(new Gson().toJson(list));
    }
}
