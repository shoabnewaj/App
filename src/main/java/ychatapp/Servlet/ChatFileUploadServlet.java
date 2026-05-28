package ychatapp.Servlet;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import ychatapp.model.beans.UsersBeans;

@WebServlet("/ChatFileUploadServlet")
@MultipartConfig
public class ChatFileUploadServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        HttpSession session = req.getSession();
        UsersBeans ub = (UsersBeans) session.getAttribute("ub");

        if (ub == null) {
            out.print("{\"success\": false, \"message\": \"Not authenticated\"}");
            return;
        }

        try {
            Part filePart = req.getPart("chatFile");

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

                String relativePath = "img/" + fileName;
                out.print("{\"success\": true, \"filePath\": \"" + relativePath + "\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"No file uploaded\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
        }
    }
}