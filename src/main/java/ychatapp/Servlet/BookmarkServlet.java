package ychatapp.Servlet;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.google.gson.JsonObject;
import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.SavedPostDAO;

@WebServlet("/BookmarkServlet")
public class BookmarkServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonRes = new JsonObject();

        HttpSession session = request.getSession(false);
        UsersBeans user = (session != null) ? (UsersBeans) session.getAttribute("users") : null;

        if (user == null) {
            jsonRes.addProperty("status", "error");
            jsonRes.addProperty("message", "User not logged in");
            out.print(jsonRes.toString());
            return;
        }

        String action = request.getParameter("action");
        SavedPostDAO dao = new SavedPostDAO();

        if ("toggle".equalsIgnoreCase(action)) {
            try {
                int postId = Integer.parseInt(request.getParameter("postId"));
                boolean isSaved = dao.toggleSavePost(user.getId(), postId);
                jsonRes.addProperty("status", "success");
                jsonRes.addProperty("isSaved", isSaved);
                jsonRes.addProperty("message", isSaved ? "Post saved to bookmarks" : "Post removed from bookmarks");
            } catch (Exception e) {
                jsonRes.addProperty("status", "error");
                jsonRes.addProperty("message", "Invalid parameters: " + e.getMessage());
            }
        } else {
            jsonRes.addProperty("status", "error");
            jsonRes.addProperty("message", "Unknown action");
        }

        out.print(jsonRes.toString());
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}
