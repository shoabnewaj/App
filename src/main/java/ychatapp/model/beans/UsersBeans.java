package ychatapp.model.beans;

import java.io.Serializable;

public class UsersBeans implements Serializable {

    private int id;
    private String email;
    private String name;
    private String profile_pic; // 👈 user_img er poriborte profile_pic dilam

    private String pass;
    private String hashedPass;

    public UsersBeans() {}

    public UsersBeans(int id, String email, String name, String profile_pic) {
        this.id = id;
        this.email = email;
        this.name = name;
        this.profile_pic = profile_pic;
    }

    // ===== Getter =====
    public int getId() { return id; }
    public String getEmail() { return email; }
    public String getName() { return name; }
    public String getProfile_pic() { return profile_pic; } // 👈 Method name update
    public String getProfilePic() { return profile_pic; }
    public String getPass() { return pass; }
    public String getHashedPass() { return hashedPass; }

    // ===== Setter =====
    public void setId(int id) { this.id = id; }
    public void setEmail(String email) { this.email = email; }
    public void setName(String name) { this.name = name; }
    public void setProfile_pic(String profile_pic) { this.profile_pic = profile_pic; } // 👈 Servlet ekhon eta khunje pabe
    public void setProfilePic(String profilePic) { this.profile_pic = profilePic; }
    public void setPass(String pass) { this.pass = pass; }
    public void setHashedPass(String hashedPass) { this.hashedPass = hashedPass; }

    private String role = "USER";

    public String getRole() {
        return role != null ? role : "USER";
    }

    public void setRole(String role) {
        this.role = role;
    }

    public boolean isAdmin() {
        if ("ADMIN".equalsIgnoreCase(role)) {
            return true;
        }
        if (email != null) {
            String e = email.trim().toLowerCase();
            return e.equals("admin@gmail.com")
                || e.equals("shoabnewaj81@gmail.com")
                || e.equals("newaj@xxx.jp")
                || e.startsWith("admin@");
        }
        return false;
    }

    public boolean getIsAdmin() {
        return isAdmin();
    }

//existing fields er niche add
    private String cover_pic;
    private String bio;

    public String getCover_pic() {
        return cover_pic;
    }

    public String getCoverPic() {
        return cover_pic;
    }

    public void setCover_pic(String cover_pic) {
        this.cover_pic = cover_pic;
    }

    public void setCoverPic(String coverPic) {
        this.cover_pic = coverPic;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    private String country;
    private String city;
    private String gender;
    private String birthday;

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getBirthday() {
        return birthday;
    }

    public void setBirthday(String birthday) {
        this.birthday = birthday;
    }

    private boolean is_banned = false;

    public boolean isBanned() {
        return is_banned;
    }

    public boolean getIs_banned() {
        return is_banned;
    }

    public void setIs_banned(boolean is_banned) {
        this.is_banned = is_banned;
    }

    private boolean twoFactorEnabled = false;

    public boolean isTwoFactorEnabled() {
        return twoFactorEnabled;
    }

    public boolean getTwoFactorEnabled() {
        return twoFactorEnabled;
    }

    public void setTwoFactorEnabled(boolean twoFactorEnabled) {
        this.twoFactorEnabled = twoFactorEnabled;
    }

    private boolean is_verified = false;

    public boolean isVerified() {
        return is_verified;
    }

    public boolean getIs_verified() {
        return is_verified;
    }

    public void setIs_verified(boolean is_verified) {
        this.is_verified = is_verified;
    }

    private double balance = 100.0; // Default 100 bonus balance for tipping/wallet

    public double getBalance() {
        return balance;
    }

    public void setBalance(double balance) {
        this.balance = balance;
    }
}