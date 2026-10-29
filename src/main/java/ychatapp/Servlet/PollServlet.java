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

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import ychatapp.model.beans.PollOption;
import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.PollDAO;

@WebServlet("/PollServlet")
public class PollServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonRes = new JsonObject();

        HttpSession session = request.getSession(false);
        UsersBeans user = (session != null) ? (UsersBeans) session.getAttribute("ub") : null;

        if (user == null) {
            jsonRes.addProperty("status", "error");
            jsonRes.addProperty("message", "User not logged in");
            out.print(jsonRes.toString());
            return;
        }

        String action = request.getParameter("action");
        PollDAO pollDAO = new PollDAO();

        if ("vote".equalsIgnoreCase(action)) {
            try {
                int postId = Integer.parseInt(request.getParameter("postId"));
                int optionId = Integer.parseInt(request.getParameter("optionId"));

                boolean success = pollDAO.castVote(postId, optionId, user.getId());
                if (success) {
                    List<PollOption> options = pollDAO.getPollOptions(postId, user.getId());
                    jsonRes.addProperty("status", "success");
                    jsonRes.add("options", new Gson().toJsonTree(options));
                } else {
                    jsonRes.addProperty("status", "error");
                    jsonRes.addProperty("message", "Failed to cast vote");
                }
            } catch (Exception e) {
                jsonRes.addProperty("status", "error");
                jsonRes.addProperty("message", "Invalid parameters: " + e.getMessage());
            }
        } else if ("getOptions".equalsIgnoreCase(action)) {
            try {
                int postId = Integer.parseInt(request.getParameter("postId"));
                List<PollOption> options = pollDAO.getPollOptions(postId, user.getId());
                jsonRes.addProperty("status", "success");
                jsonRes.add("options", new Gson().toJsonTree(options));
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
