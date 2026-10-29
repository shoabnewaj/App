package ychatapp.Servlet;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Statement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import ychatapp.model.beans.UsersBeans;
import ychatapp.model.beans.AdBeans;
import ychatapp.model.dao.AdDAO;
import ychatapp.model.dao.DBConnection;

@WebServlet({"/yads", "/YAdsServlet", "/YAds", "/ads"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class YAdsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("ub") == null) {
            res.sendRedirect("UsersLoginServlet");
            return;
        }

        // Programmatic safeguard: Ensure 'ads' table exists
        ensureAdsTableExists();

        AdDAO dao = new AdDAO();
        req.setAttribute("allAds", dao.getAllAds());
        req.setAttribute("ub", session.getAttribute("ub"));

        req.getRequestDispatcher("/WEB-INF/jsp/yads.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("ub") == null) {
            res.sendRedirect("UsersLoginServlet");
            return;
        }

        UsersBeans ub = (UsersBeans) session.getAttribute("ub");

        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String linkUrl = req.getParameter("linkUrl");

        if (title == null || title.trim().isEmpty()) {
            res.sendRedirect("yads?msg=empty_title");
            return;
        }

        String imageUrl = "img/default_ad.jpg"; // Fallback default image

        try {
            Part filePart = req.getPart("adFile");
            if (filePart != null && filePart.getSize() > 0) {
                String submittedName = filePart.getSubmittedFileName();
                String safeName = submittedName.replaceAll("[^a-zA-Z0-9\\.\\-_]", "_");
                String fileName = System.currentTimeMillis() + "_" + safeName;

                String uploadPath = getServletContext().getRealPath("/img");
                File dir = new File(uploadPath);
                if (!dir.exists()) {
                    dir.mkdirs();
                }

                filePart.write(uploadPath + File.separator + fileName);
                imageUrl = "img/" + fileName;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        AdDAO dao = new AdDAO();
        boolean success = dao.addAd(title, description, imageUrl, linkUrl, ub.getId());

        if (success) {
            res.sendRedirect("yads?msg=success");
        } else {
            res.sendRedirect("yads?msg=error");
        }
    }

    private void ensureAdsTableExists() {
        String sql = "CREATE TABLE IF NOT EXISTS ads (" +
                     "id INT AUTO_INCREMENT PRIMARY KEY, " +
                     "title VARCHAR(255) NOT NULL, " +
                     "description TEXT, " +
                     "image_url VARCHAR(255), " +
                     "link_url VARCHAR(255), " +
                     "creator_id INT NOT NULL, " +
                     "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                     "FOREIGN KEY (creator_id) REFERENCES users(id) ON DELETE CASCADE" +
                     ") ENGINE=InnoDB;";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(sql);
        } catch (Exception e) {
            System.err.println("Error ensuring ads table exists: " + e.getMessage());
        }
    }
}
