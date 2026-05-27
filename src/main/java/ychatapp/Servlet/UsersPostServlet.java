package ychatapp.Servlet;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Paths;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.beans.UsersPost;
import ychatapp.model.dao.PostDAO;
import ychatapp.model.dao.StoryDAO;

@WebServlet("/UsersPostServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,   // 2MB
        maxFileSize       = 1024 * 1024 * 200,  // 200MB (reel videos)
        maxRequestSize    = 1024 * 1024 * 210   // 210MB
)
public class UsersPostServlet extends HttpServlet {

    // ======= Helper: read a text field from multipart form =======
    private String readPart(HttpServletRequest req, String fieldName) {
        try {
            Part p = req.getPart(fieldName);
            if (p != null && p.getSize() > 0) {
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(p.getInputStream(), "UTF-8"))) {
                
                    String line;
                    while ((line = br.readLine()) != null) sb.append(line);
                    return sb.toString().trim();
                }
            }
        } catch (Exception ignored) {}
        // fallback for application/x-www-form-urlencoded
        try { return req.getParameter(fieldName); } catch (Exception ignored2) {}
        return null;
    }

    // ================= GET (Feed Display) =================
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        PostDAO dao = new PostDAO();
        req.setAttribute("postList",  dao.getAllposts());
        req.setAttribute("reelsList", dao.getAllReels());
        req.setAttribute("storyList", new StoryDAO().getActiveStories());

        HttpSession session = req.getSession(false);
        if (session != null) {
            UsersBeans ub = (UsersBeans) session.getAttribute("ub");
            if (ub != null) {
                req.setAttribute("friendList",
                    new ychatapp.model.dao.UsersDAO().getFriends(ub.getId()));
            }
        }
        req.getRequestDispatcher("/WEB-INF/jsp/main.jsp").forward(req, res);
    }

    // ================= POST (Create / Share / Delete Post) =================
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        UsersBeans ub = (session != null) ? (UsersBeans) session.getAttribute("ub") : null;

        if (ub == null) {
            res.sendRedirect("UsersLoginServlet");
            return;
        }

        PostDAO dao = new PostDAO();

        // Read action field (multipart-safe)
        String action = readPart(req, "action");

        // ─────────── SHARE ───────────
        if ("SHARE".equalsIgnoreCase(action)) {
            String postIdStr = readPart(req, "postId");
            if (postIdStr != null && !postIdStr.isEmpty()) {
                int postId = Integer.parseInt(postIdStr);
                UsersPost orig = dao.getPostById(postId);
                if (orig != null) {
                    dao.sharePost(ub.getId(), orig.getContent(),
                            orig.getName(), orig.getFile_name(), "shared", postId);
                }
            }

        // ─────────── DELETE ───────────
        } else if ("DELETE".equalsIgnoreCase(action)) {
            String postIdStr = readPart(req, "postId");
            boolean success = false;
            if (postIdStr != null && !postIdStr.isEmpty()) {
                int postId = Integer.parseInt(postIdStr);
                UsersPost existing = dao.getPostById(postId);
                if (existing != null && existing.getUserId() == ub.getId()) {
                    success = dao.deletePost(postId);
              
                UsersPost orig = dao.getPostById(postId);
                if (orig != null) {
                    dao.sharePost(ub.getId(), orig.getContent(),
                            orig.getName(), orig.getFile_name(), "shared", postId);
                }
            }

        // ─────────── DELETE ───────────
        } else if ("DELETE".equalsIgnoreCase(action)) {
            String postIdStr = readPart(req, "postId");
            boolean success = false;
            if (postIdStr != null && !postIdStr.isEmpty()) {
                int postId = Integer.parseInt(postIdStr);
                UsersPost existing = dao.getPostById(postId);
                if (existing != null && existing.getUserId() == ub.getId()) {
                    success = dao.deletePost(postId);
                }
                    String submitted = Paths.get(media.getSubmittedFileName()).getFileName().toString();
                    if (submitted != null && !submitted.isEmpty()) {
                        fileName = System.currentTimeMillis() + "_" + submitted;

                        String uploadPath = getServletContext().getRealPath("/img");
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) uploadDir.mkdirs();

                        media.write(uploadPath + File.separator + fileName);

                        String ct = media.getContentType();
                        boolean isVideo = (ct != null && ct.startsWith("video/")) ||
                                submitted.toLowerCase().matches(".*\\.(mp4|webm|mov|ogg|avi|mkv)");

                        if ("REEL".equalsIgnoreCase(postType)) {
                            // keep REEL
                        } else if (isVideo) {
                            postType = "video";
                        } else {
                            postType = "image";
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            boolean success = dao.addPost(ub.getId(), content, fileName, postType, feeling);

            // AJAX response (used by JS fetch)
            String ajaxFlag = readPart(req, "ajax");
            if ("true".equals(ajaxFlag)) {
                res.setContentType("application/json");
                res.getWriter().write("{\"success\": " + success + "}");
                return;
            }
        }

        res.sendRedirect("UsersPostServlet");
    }
}
                e.printStackTrace();
            }

            boolean success = dao.addPost(ub.getId(), content, fileName, postType, feeling);

            // AJAX response (used by JS fetch)
            String ajaxFlag = readPart(req, "ajax");
            if ("true".equals(ajaxFlag)) {
                res.setContentType("application/json");
                res.getWriter().write("{\"success\": " + success + "}");
                return;
            }
        }

        res.sendRedirect("UsersPostServlet");
    }
}