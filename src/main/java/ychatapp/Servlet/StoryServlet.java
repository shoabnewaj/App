package ychatapp.Servlet;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.StoryDAO;

@WebServlet("/StoryServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class StoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final StoryDAO storyDAO = new StoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) 
            throws ServletException, IOException {
        
        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        UsersBeans ub = (session != null) ? (UsersBeans) session.getAttribute("ub") : null;

        if (ub == null) {
            res.getWriter().write("{\"error\": \"not_logged_in\"}");
            return;
        }

        String action = req.getParameter("action");
        String storyIdStr = req.getParameter("storyId");

        if (storyIdStr == null || storyIdStr.isEmpty()) {
            res.getWriter().write("{\"error\": \"missing_story_id\"}");
            return;
        }

        try {
            int storyId = Integer.parseInt(storyIdStr);

            if ("recordView".equalsIgnoreCase(action)) {
                if (!storyDAO.canViewStory(storyId, ub.getId())) { res.setStatus(403); res.getWriter().write("{\"success\":false}"); return; }
                boolean recorded = storyDAO.recordStoryView(storyId, ub.getId());
                res.getWriter().write("{\"success\": " + recorded + "}");
                return;
            } else if ("getViewers".equalsIgnoreCase(action)) {
                if (!storyDAO.isStoryOwner(storyId, ub.getId())) { res.setStatus(403); res.getWriter().write("[]"); return; }
                java.util.List<ychatapp.model.beans.StoryViewerBean> viewers = storyDAO.getStoryViewers(storyId);
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < viewers.size(); i++) {
                    ychatapp.model.beans.StoryViewerBean v = viewers.get(i);
                    if (i > 0) json.append(",");
                    json.append("{")
                        .append("\"userId\":").append(v.getUserId()).append(",")
                        .append("\"name\":\"").append(v.getName() != null ? v.getName().replace("\"", "\\\"") : "").append("\",")
                        .append("\"profilePic\":\"").append(v.getProfilePic() != null ? v.getProfilePic() : "default.png").append("\",")
                        .append("\"viewedAt\":\"").append(v.getViewedAt() != null ? v.getViewedAt() : "").append("\"")
                        .append("}");
                }
                json.append("]");
                res.getWriter().write(json.toString());
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        res.getWriter().write("{\"error\": \"unknown_action\"}");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) 
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        UsersBeans ub = (session != null) ? (UsersBeans) session.getAttribute("ub") : null;

        if (ub == null) {
            res.sendRedirect("UsersLoginServlet");
            return;
        }

        String text = req.getParameter("text");
        String audience = req.getParameter("audience");
        String fileName = null;

        try {
            Part part = req.getPart("media");
            if (part != null && part.getSize() > 0) {
                String submittedFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                if (submittedFileName != null && !submittedFileName.isEmpty()) {
                    fileName = System.currentTimeMillis() + "_" + submittedFileName;
                    String uploadPath = getServletContext().getRealPath("/img");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    part.write(uploadPath + File.separator + fileName);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        storyDAO.addStory(ub.getId(), fileName, text, audience);
        res.sendRedirect("UsersPostServlet");
    }
}