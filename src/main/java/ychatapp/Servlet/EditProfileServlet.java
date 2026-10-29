package ychatapp.Servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.bo.UsersLogic;



@WebServlet({"/EditProfileServlet", "/editProfile"})
public class EditProfileServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        UsersBeans ub = (UsersBeans) session.getAttribute("ub");

        if (ub == null) {
            res.sendRedirect("UsersLoginServlet");
            return;
        }

        req.getRequestDispatcher("/WEB-INF/jsp/editProfile.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        UsersBeans ub = (UsersBeans) session.getAttribute("ub");

        if (ub == null) {
            res.sendRedirect("UsersLoginServlet");
            return;
        }

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String pass = req.getParameter("pass");
        String country = req.getParameter("country");
        String city = req.getParameter("city");
        String gender = req.getParameter("gender");
        String birthday = req.getParameter("birthday");

        if (name != null && !name.trim().isEmpty()) {
            ub.setName(name);
        }
        if (email != null && !email.trim().isEmpty()) {
            ub.setEmail(email);
        }
        if (country != null) {
            ub.setCountry(country.trim());
        }
        if (city != null) {
            ub.setCity(city.trim());
        }
        if (gender != null && !gender.trim().isEmpty()) {
            ub.setGender(gender.trim());
        }
        if (birthday != null && !birthday.trim().isEmpty()) {
            ub.setBirthday(birthday.trim());
        }
        boolean passChanged = false;
        if (pass != null && !pass.trim().isEmpty()) {
            ub.setPass(pass);
            passChanged = true;
        } else {
            ub.setPass(null); // Keep old password
        }

        if (UsersLogic.updateProfile(ub)) {
            session.setAttribute("ub", ub); // Update session with new bean info
            if (passChanged) {
                final String userEmail = ub.getEmail();
                final String userName = ub.getName();
                ychatapp.model.bo.GeminiService.runAsync(() -> {
                    ychatapp.model.bo.EmailService.sendPasswordChangeConfirmationEmail(userEmail, userName);
                });
            }
            res.sendRedirect("UsersProfileServlet?update=success");
        } else {
            res.sendRedirect("UsersProfileServlet?update=fail");
        }
    }
}