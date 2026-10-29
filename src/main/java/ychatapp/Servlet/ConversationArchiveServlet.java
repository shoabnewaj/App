package ychatapp.Servlet;

import java.io.IOException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.MessageDAO;

@WebServlet("/ConversationArchiveServlet")
public class ConversationArchiveServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        UsersBeans user = session == null ? null : (UsersBeans) session.getAttribute("ub");
        res.setContentType("application/json;charset=UTF-8");
        if (user == null) { res.setStatus(401); res.getWriter().write("{\"success\":false,\"message\":\"Sign in again.\"}"); return; }
        String partner = req.getParameter("partner");
        String action = req.getParameter("action");
        boolean archive = "archive".equals(action);
        if (partner == null || partner.isBlank() || user.getName().equalsIgnoreCase(partner) || (!archive && !"restore".equals(action))) {
            res.setStatus(400); res.getWriter().write("{\"success\":false,\"message\":\"Invalid conversation action.\"}"); return;
        }
        boolean success = new MessageDAO().setConversationArchived(user.getName(), partner, archive);
        if (!success) res.setStatus(500);
        res.getWriter().write("{\"success\":" + success + "}");
    }
}