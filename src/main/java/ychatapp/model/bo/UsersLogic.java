package ychatapp.model.bo;

import java.security.MessageDigest;
import java.util.Base64;

import jakarta.servlet.http.HttpServletRequest;

import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.UsersDAO;

public class UsersLogic {

    // ১. রেজিস্ট্রেশন লজিক
    public static boolean userRegist(HttpServletRequest request, UsersBeans ub) {
        ub.setHashedPass(hashValue(ub.getPass()));
        if (ub.getProfile_pic() == null || ub.getProfile_pic().isEmpty()) {
            ub.setProfile_pic("default.png");
        }
        return new UsersDAO().registerUser(ub);
    }

    // ২. লগইন লজিক
    public static UsersBeans login(UsersBeans ub) {
        if (ub == null || ub.getEmail() == null || ub.getPass() == null) return null;
        String rawPass = ub.getPass();
        String hashed = hashValue(rawPass);
        ub.setHashedPass(hashed);
        return new UsersDAO().loginCheck(ub.getEmail(), rawPass, hashed);
    }

    // ৩. প্রোফাইল আপডেট লজিক
    public static boolean updateProfile(UsersBeans ub) {
        if (ub.getPass() != null && !ub.getPass().isEmpty()) {
            ub.setHashedPass(hashValue(ub.getPass()));
        }
        return new UsersDAO().updateUser(ub); 
    }

    public static boolean resetPasswordByEmail(String email, String newPass) {
        return new UsersDAO().updatePasswordByEmail(email, hashValue(newPass));
    }

    // SHA-256 Hashing Method
    public static String hashValue(String pass) {
        if (pass == null || pass.isEmpty()) return null;
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            return Base64.getEncoder().encodeToString(md.digest(pass.getBytes()));
        } catch (Exception e) { 
            return null; 
        }
    }
}