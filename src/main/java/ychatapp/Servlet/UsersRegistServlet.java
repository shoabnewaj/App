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
import jakarta.servlet.http.Part;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.bo.UsersLogic;

@WebServlet("/UsersRegistServlet")
@MultipartConfig
public class UsersRegistServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/jsp/regist.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        String pass = req.getParameter("pass");
        String name = req.getParameter("name");
        String country = req.getParameter("country");
        String city = req.getParameter("city");
        String gender = req.getParameter("gender");
        String birthday = req.getParameter("birthday");

        // image upload
        Part part = req.getPart("profile_pic"); // JSP input name
        String user_img = null;

        if (part != null) {
            String submittedFileName = part.getSubmittedFileName();
            if (submittedFileName != null && !submittedFileName.trim().isEmpty()) {
                String fileName = Paths.get(submittedFileName).getFileName().toString();
                if (!fileName.isEmpty()) {
                    String uploadPath = getServletContext().getRealPath("/img");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdir();

                    user_img = System.currentTimeMillis() + "_" + fileName;
                    part.write(uploadPath + File.separator + user_img);
                }
            }
        }

        UsersBeans ub = new UsersBeans();
        ub.setEmail(email);
        ub.setPass(pass);
        ub.setName(name);
        ub.setProfile_pic(user_img);
        ub.setCountry(country);
        ub.setCity(city);
        ub.setGender(gender);
        ub.setBirthday(birthday); 

        if (UsersLogic.userRegist(req, ub)) {
            final String recipientEmail = email;
            final String userName = name;
            ychatapp.model.bo.GeminiService.runAsync(() -> {
                ychatapp.model.bo.EmailService.sendRegistrationConfirmationEmail(recipientEmail, userName);
            });
            req.getRequestDispatcher("/WEB-INF/jsp/registDone.jsp").forward(req, res);
        } else {
            req.setAttribute("error", "Registration Failed");
            req.getRequestDispatcher("/WEB-INF/jsp/regist.jsp").forward(req, res);
        }
    }
}