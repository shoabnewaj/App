package ychatapp.model.dao;
 
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
 
import ychatapp.model.beans.UsersBeans;
 
public class UsersDAO {
 
    public UsersDAO() {
        ensureSecurityColumns();
    }

    private void ensureSecurityColumns() {
        try (Connection conn = getConnection(); java.sql.Statement stmt = conn.createStatement()) {
            java.sql.DatabaseMetaData md = conn.getMetaData();
            try (ResultSet rs = md.getColumns(null, null, "users", "two_factor_enabled")) {
                if (!rs.next()) {
                    stmt.execute("ALTER TABLE users ADD COLUMN two_factor_enabled TINYINT(1) DEFAULT 0");
                }
            }
            try (ResultSet rs = md.getColumns(null, null, "users", "is_verified")) {
                if (!rs.next()) {
                    stmt.execute("ALTER TABLE users ADD COLUMN is_verified TINYINT(1) DEFAULT 0");
                }
            }
            try (ResultSet rs = md.getColumns(null, null, "users", "balance")) {
                if (!rs.next()) {
                    stmt.execute("ALTER TABLE users ADD COLUMN balance DOUBLE NOT NULL DEFAULT 0.00");
                }
            }
            try (ResultSet rs = md.getColumns(null, null, "users", "country")) {
                if (!rs.next()) {
                    stmt.execute("ALTER TABLE users ADD COLUMN country VARCHAR(100) DEFAULT NULL");
                }
            }
            try (ResultSet rs = md.getColumns(null, null, "users", "city")) {
                if (!rs.next()) {
                    stmt.execute("ALTER TABLE users ADD COLUMN city VARCHAR(100) DEFAULT NULL");
                }
            }
            try (ResultSet rs = md.getColumns(null, null, "users", "gender")) {
                if (!rs.next()) {
                    stmt.execute("ALTER TABLE users ADD COLUMN gender VARCHAR(20) DEFAULT NULL");
                }
            }
            try (ResultSet rs = md.getColumns(null, null, "users", "birthday")) {
                if (!rs.next()) {
                    stmt.execute("ALTER TABLE users ADD COLUMN birthday DATE DEFAULT NULL");
                }
            }
        } catch (Exception ignored) {}
    }

    private Connection getConnection() throws Exception {
        return DBConnection.getConnection();
    }
 
    // 📊 Profile Count
    public int getProfileCount(int userId, String type) {
        int count = 0;
        String sql = (type.equalsIgnoreCase("FRIENDS")) ? 
            "SELECT COUNT(*) FROM friendships WHERE (user_id1=? OR user_id2=?) AND status='ACCEPTED'" :
            (type.equalsIgnoreCase("FOLLOWERS") ? "SELECT COUNT(*) FROM followers WHERE following_id=?" : "SELECT COUNT(*) FROM followers WHERE follower_id=?");
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if (type.equalsIgnoreCase("FRIENDS")) ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }
 
    // 櫨 User Registration
    public boolean registerUser(UsersBeans ub) {
        String sql = "INSERT INTO users (name, email, password, profile_pic, country, city, gender, birthday) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, ub.getName());
            ps.setString(2, ub.getEmail());
            String bcryptHash = org.mindrot.jbcrypt.BCrypt.hashpw(ub.getHashedPass(), org.mindrot.jbcrypt.BCrypt.gensalt());
            ps.setString(3, bcryptHash); 
            ps.setString(4, ub.getProfile_pic());
            ps.setString(5, ub.getCountry());
            ps.setString(6, ub.getCity());
            ps.setString(7, ub.getGender());
            if (ub.getBirthday() != null && !ub.getBirthday().trim().isEmpty()) {
                try {
                    ps.setDate(8, java.sql.Date.valueOf(ub.getBirthday().trim()));
                } catch (Exception e) {
                    ps.setString(8, ub.getBirthday().trim());
                }
            } else {
                ps.setNull(8, java.sql.Types.DATE);
            }
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            // Fallback if country/city/gender/birthday columns do not exist in older table schema
            try (Connection conn = getConnection();
                 PreparedStatement ps = conn.prepareStatement("INSERT INTO users (name, email, password, profile_pic) VALUES (?, ?, ?, ?)")) {
                ps.setString(1, ub.getName());
                ps.setString(2, ub.getEmail());
                String bcryptHash = org.mindrot.jbcrypt.BCrypt.hashpw(ub.getHashedPass(), org.mindrot.jbcrypt.BCrypt.gensalt());
                ps.setString(3, bcryptHash);
                ps.setString(4, ub.getProfile_pic());
                return ps.executeUpdate() > 0;
            } catch (Exception ex) {
                ex.printStackTrace();
                return false;
            }
        }
    }
 
    // 櫨 Login Check with BCrypt Verification and Legacy SHA-256/Plain Fallback
    public UsersBeans loginCheck(String email, String pass) {
        if (email == null || pass == null) return null;
        String hashed = ychatapp.model.bo.UsersLogic.hashValue(pass);
        UsersBeans ub = loginCheck(email, pass, hashed);
        if (ub == null) {
            ub = loginCheck(email, pass, pass);
        }
        return ub;
    }

    public UsersBeans loginCheck(String email, String rawPass, String hashedPass) {
        if (email == null || email.trim().isEmpty()) return null;
        UsersBeans ub = null;
        String sql = "SELECT * FROM users WHERE LOWER(email)=LOWER(?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String dbPass = rs.getString("password");
                    boolean matches = false;
                    boolean isLegacy = false;
                    
                    if (dbPass != null && (dbPass.startsWith("$2a$") || dbPass.startsWith("$2b$") || dbPass.startsWith("$2y$"))) {
                        // 1. Check BCrypt with SHA-256 hashed password (standard)
                        try {
                            if (hashedPass != null && org.mindrot.jbcrypt.BCrypt.checkpw(hashedPass, dbPass)) {
                                matches = true;
                            }
                        } catch (Exception e) {}
                        
                        // 2. Check BCrypt with raw password (direct bcrypt)
                        if (!matches && rawPass != null) {
                            try {
                                if (org.mindrot.jbcrypt.BCrypt.checkpw(rawPass, dbPass)) {
                                    matches = true;
                                    isLegacy = true;
                                }
                            } catch (Exception e) {}
                        }
                    } else if (dbPass != null) {
                        // 3. Check plain SHA-256 hash equality
                        if (hashedPass != null && dbPass.equals(hashedPass)) {
                            matches = true;
                            isLegacy = true;
                        }
                        // 4. Check plain text password equality
                        else if (rawPass != null && dbPass.equals(rawPass)) {
                            matches = true;
                            isLegacy = true;
                        }
                    }
                    
                    if (matches) {
                        ub = new UsersBeans();
                        populateUserFields(rs, ub);
                        
                        // Auto-migrate legacy accounts to standard BCrypt(SHA256)
                        if (isLegacy && hashedPass != null) {
                            try {
                                String bcryptHash = org.mindrot.jbcrypt.BCrypt.hashpw(hashedPass, org.mindrot.jbcrypt.BCrypt.gensalt());
                                String updateSql = "UPDATE users SET password=? WHERE id=?";
                                try (PreparedStatement ups = conn.prepareStatement(updateSql)) {
                                    ups.setString(1, bcryptHash);
                                    ups.setInt(2, ub.getId());
                                    ups.executeUpdate();
                                    System.out.println("Migrated user " + email + " password to standard BCrypt hashing.");
                                }
                            } catch (Exception ex) {
                                ex.printStackTrace();
                            }
                        }
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return ub;
    }
 
    public boolean updatePasswordByEmail(String email, String hashedPass) {
        String sql = "UPDATE users SET password=? WHERE email=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            String bcryptHash = org.mindrot.jbcrypt.BCrypt.hashpw(hashedPass, org.mindrot.jbcrypt.BCrypt.gensalt());
            ps.setString(1, bcryptHash);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
 
    private void populateUserFields(ResultSet rs, UsersBeans ub) {
        try { ub.setId(rs.getInt("id")); } catch (Exception ignored) {}
        try { ub.setName(rs.getString("name")); } catch (Exception ignored) {}
        try { ub.setEmail(rs.getString("email")); } catch (Exception ignored) {}
        try { ub.setProfile_pic(rs.getString("profile_pic")); } catch (Exception ignored) {}
        try { ub.setCover_pic(rs.getString("cover_pic")); } catch (Exception ignored) {}
        try { ub.setBio(rs.getString("bio")); } catch (Exception ignored) {}
        try { ub.setCountry(rs.getString("country")); } catch (Exception ignored) {}
        try { ub.setCity(rs.getString("city")); } catch (Exception ignored) {}
        try { ub.setGender(rs.getString("gender")); } catch (Exception ignored) {}
        try {
            java.sql.Date bdate = rs.getDate("birthday");
            ub.setBirthday(bdate != null ? bdate.toString() : rs.getString("birthday"));
        } catch (Exception ignored) {}
        try { ub.setRole(rs.getString("role")); } catch (Exception ignored) {}
        try { ub.setIs_banned(rs.getBoolean("is_banned")); } catch (Exception ignored) {}
        try { ub.setTwoFactorEnabled(rs.getBoolean("two_factor_enabled")); } catch (Exception ignored) {}
        try { ub.setIs_verified(rs.getBoolean("is_verified")); } catch (Exception ignored) {}
        try { ub.setBalance(rs.getDouble("balance")); } catch (Exception ignored) {}
    }

    public boolean setTwoFactorEnabled(int userId, boolean enabled) {
        String sql = "UPDATE users SET two_factor_enabled=? WHERE id=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, enabled);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean setVerified(int userId, boolean verified) {
        String sql = "UPDATE users SET is_verified=? WHERE id=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, verified);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateBalance(int userId, double delta) {
        String sql = "UPDATE users SET balance = balance + ? WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, delta);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public double getBalance(int userId) {
        String sql = "SELECT balance FROM users WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble("balance");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    // 屏・・Update User
    public boolean updateUser(UsersBeans ub) {
        String pass = ub.getHashedPass();
        String sql;
        boolean updatePass = (pass != null && !pass.isEmpty());
        if (updatePass) {
            sql = "UPDATE users SET name=?, email=?, password=?, profile_pic=?, country=?, city=?, gender=?, birthday=? WHERE id=?";
        } else {
            sql = "UPDATE users SET name=?, email=?, profile_pic=?, country=?, city=?, gender=?, birthday=? WHERE id=?";
        }
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, ub.getName());
            ps.setString(2, ub.getEmail());
            int idx = 3;
            if (updatePass) {
                if (!pass.startsWith("$2a$")) {
                    pass = org.mindrot.jbcrypt.BCrypt.hashpw(pass, org.mindrot.jbcrypt.BCrypt.gensalt());
                }
                ps.setString(idx++, pass);
            }
            ps.setString(idx++, ub.getProfile_pic());
            ps.setString(idx++, ub.getCountry());
            ps.setString(idx++, ub.getCity());
            ps.setString(idx++, ub.getGender());
            if (ub.getBirthday() != null && !ub.getBirthday().trim().isEmpty()) {
                try {
                    ps.setDate(idx++, java.sql.Date.valueOf(ub.getBirthday().trim()));
                } catch (Exception e) {
                    ps.setString(idx++, ub.getBirthday().trim());
                }
            } else {
                ps.setNull(idx++, java.sql.Types.DATE);
            }
            ps.setInt(idx, ub.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
 
    // 📸 Update Profile Pic
    public boolean updateProfilePic(int userId, String fileName) {
        String sql = "UPDATE users SET profile_pic = ? WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fileName);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
 
    // 🆔 Get User by ID
    public UsersBeans getUserById(int id) {
        UsersBeans ub = null;
        String sql = "SELECT * FROM users WHERE id=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ub = new UsersBeans();
                populateUserFields(rs, ub);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return ub;
    }

    // 🆔 Get User by Email
    public UsersBeans getUserByEmail(String email) {
        UsersBeans ub = null;
        String sql = "SELECT * FROM users WHERE email=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ub = new UsersBeans();
                populateUserFields(rs, ub);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return ub;
    }

    // 🆔 Get User by Name
    public UsersBeans getUserByName(String name) {
        UsersBeans ub = null;
        String sql = "SELECT * FROM users WHERE name=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ub = new UsersBeans();
                populateUserFields(rs, ub);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return ub;
    }

    // 🔗 Get Following User IDs
    public List<Integer> getFollowingUserIds(int followerId) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT following_id FROM followers WHERE follower_id=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, followerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getInt("following_id"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
 
    // 🤝 Friends logic
    public String getFriendshipStatus(int myId, int targetId) {
        String status = "NONE";
        String sql = "SELECT user_id1, status FROM friendships WHERE (user_id1=? AND user_id2=?) OR (user_id1=? AND user_id2=?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, myId); ps.setInt(2, targetId);
            ps.setInt(3, targetId); ps.setInt(4, myId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int senderId = rs.getInt("user_id1");
                    String dbStatus = rs.getString("status");
                    if ("ACCEPTED".equalsIgnoreCase(dbStatus)) {
                        status = "ACCEPTED";
                    } else if ("PENDING".equalsIgnoreCase(dbStatus)) {
                        if (senderId == myId) {
                            status = "SENT";
                        } else {
                            status = "INCOMING";
                        }
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return status;
    }

    public boolean updateCoverPic(int userId, String fileName) {
        boolean flag = false;
        String sql = "UPDATE users SET cover_pic=? WHERE id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fileName);
            ps.setInt(2, userId);
            flag = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return flag;
    }
 
    public List<UsersBeans> getPendingRequests(int userId) {
        List<UsersBeans> list = new ArrayList<>();
        String sql = "SELECT u.* FROM users u JOIN friendships f ON u.id = f.user_id1 WHERE f.user_id2 = ? AND f.status = 'PENDING'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UsersBeans ub = new UsersBeans();
                ub.setId(rs.getInt("id"));
                ub.setName(rs.getString("name"));
                ub.setEmail(rs.getString("email"));
                ub.setProfile_pic(rs.getString("profile_pic"));
                list.add(ub);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
 
    public List<UsersBeans> getSentRequests(int userId) {
        List<UsersBeans> list = new ArrayList<>();
        String sql = "SELECT u.* FROM users u JOIN friendships f ON u.id = f.user_id2 WHERE f.user_id1 = ? AND f.status = 'PENDING'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UsersBeans ub = new UsersBeans();
                ub.setId(rs.getInt("id"));
                ub.setName(rs.getString("name"));
                ub.setEmail(rs.getString("email"));
                ub.setProfile_pic(rs.getString("profile_pic"));
                list.add(ub);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
 
    public List<UsersBeans> getFriends(int userId) {
        List<UsersBeans> list = new ArrayList<>();
        String sql = "SELECT u.* FROM users u JOIN friendships f ON (u.id = f.user_id1 OR u.id = f.user_id2) WHERE (f.user_id1 = ? OR f.user_id2 = ?) AND f.status = 'ACCEPTED' AND u.id != ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UsersBeans ub = new UsersBeans();
                ub.setId(rs.getInt("id"));
                ub.setName(rs.getString("name"));
                ub.setEmail(rs.getString("email"));
                ub.setProfile_pic(rs.getString("profile_pic"));
                list.add(ub);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<UsersBeans> getSuggestedUsers(int userId, int limit) {
        List<UsersBeans> list = new ArrayList<>();
        String sql = "SELECT u.* FROM users u WHERE u.id != ? " +
                     "AND u.id NOT IN (" +
                     "  SELECT CASE WHEN user_id1 = ? THEN user_id2 ELSE user_id1 END " +
                     "  FROM friendships WHERE user_id1 = ? OR user_id2 = ?" +
                     ") ORDER BY RAND() LIMIT ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, userId);
            ps.setInt(4, userId);
            ps.setInt(5, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UsersBeans ub = new UsersBeans();
                ub.setId(rs.getInt("id"));
                ub.setName(rs.getString("name"));
                ub.setEmail(rs.getString("email"));
                ub.setProfile_pic(rs.getString("profile_pic"));
                try { ub.setCountry(rs.getString("country")); } catch (Exception ignored) {}
                try { ub.setCity(rs.getString("city")); } catch (Exception ignored) {}
                list.add(ub);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
 
    private String lastError = "";
    public String getLastError() { return lastError; }
 
    public boolean handleFriendAction(int myId, int targetId, String action) {
        System.out.println(">>> DAO Action: " + action + " | From: " + myId + " | To: " + targetId);
        try (Connection conn = getConnection()) {
            if ("ADD".equalsIgnoreCase(action)) {
                String delSql = "DELETE FROM friendships WHERE (user_id1=? AND user_id2=?) OR (user_id1=? AND user_id2=?)";
                try (PreparedStatement ps = conn.prepareStatement(delSql)) {
                    ps.setInt(1, myId); ps.setInt(2, targetId);
                    ps.setInt(3, targetId); ps.setInt(4, myId);
                    ps.executeUpdate();
                }
                String insSql = "INSERT IGNORE INTO friendships (user_id1, user_id2, status) VALUES (?, ?, 'PENDING')";
                try (PreparedStatement ps = conn.prepareStatement(insSql)) {
                    ps.setInt(1, myId);
                    ps.setInt(2, targetId);
                    int res = ps.executeUpdate();
                    if (res == 0) {
                        String upSql = "UPDATE friendships SET status='PENDING' WHERE user_id1=? AND user_id2=?";
                        try(PreparedStatement ps2 = conn.prepareStatement(upSql)) {
                            ps2.setInt(1, myId); ps2.setInt(2, targetId);
                            return ps2.executeUpdate() > 0;
                        }
                    }
                    return res > 0;
                }
            } else if ("ACCEPT".equalsIgnoreCase(action)) {
                String sql = "UPDATE friendships SET status = 'ACCEPTED' WHERE user_id1 = ? AND user_id2 = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, targetId);
                    ps.setInt(2, myId);
                    return ps.executeUpdate() > 0;
                }
            } else {
                String sql = "DELETE FROM friendships WHERE (user_id1 = ? AND user_id2 = ?) OR (user_id1 = ? AND user_id2 = ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, myId); ps.setInt(2, targetId);
                    ps.setInt(3, targetId); ps.setInt(4, myId);
                    return ps.executeUpdate() > 0;
                }
            }
        } catch (Exception e) { 
            this.lastError = e.getMessage();
            System.err.println(">>> DAO ERROR: " + e.getMessage());
            e.printStackTrace(); 
        }
        return false;
    }
 
    public boolean isFollowing(int followerId, int followingId) {
        String sql = "SELECT * FROM followers WHERE follower_id = ? AND following_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, followerId);
            ps.setInt(2, followingId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
 
    public boolean handleFollowAction(int followerId, int followingId, String action) {
        String sql = "";
        try (Connection conn = getConnection()) {
            if ("FOLLOW".equalsIgnoreCase(action)) {
                sql = "INSERT IGNORE INTO followers (follower_id, following_id) VALUES (?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, followerId);
                    ps.setInt(2, followingId);
                    return ps.executeUpdate() > 0;
                }
            } else if ("UNFOLLOW".equalsIgnoreCase(action)) {
                sql = "DELETE FROM followers WHERE follower_id = ? AND following_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, followerId);
                    ps.setInt(2, followingId);
                    return ps.executeUpdate() > 0;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
 
    public List<UsersBeans> searchUsers(String query) {
        List<UsersBeans> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE name LIKE ? OR email LIKE ? LIMIT 20";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchTerm = "%" + query + "%";
            ps.setString(1, searchTerm);
            ps.setString(2, searchTerm);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UsersBeans ub = new UsersBeans();
                ub.setId(rs.getInt("id"));
                ub.setName(rs.getString("name"));
                ub.setEmail(rs.getString("email"));
                ub.setProfile_pic(rs.getString("profile_pic"));
                list.add(ub);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<UsersBeans> getAllUsers() {
        List<UsersBeans> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY id DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                UsersBeans ub = new UsersBeans();
                ub.setId(rs.getInt("id"));
                ub.setName(rs.getString("name"));
                ub.setEmail(rs.getString("email"));
                ub.setProfile_pic(rs.getString("profile_pic"));
                ub.setCover_pic(rs.getString("cover_pic"));
                ub.setBio(rs.getString("bio"));
                try { ub.setRole(rs.getString("role")); } catch (Exception ignored) {}
                list.add(ub);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean deleteUser(int userId) {
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM messages WHERE sender = ? OR receiver = ?")) {
                    UsersBeans ub = getUserById(userId);
                    if (ub != null) {
                        ps.setString(1, ub.getName());
                        ps.setString(2, ub.getName());
                        ps.executeUpdate();
                    }
                }
                
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM friendships WHERE user_id1 = ? OR user_id2 = ?")) {
                    ps.setInt(1, userId);
                    ps.setInt(2, userId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM followers WHERE follower_id = ? OR following_id = ?")) {
                    ps.setInt(1, userId);
                    ps.setInt(2, userId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM group_members WHERE user_id = ?")) {
                    ps.setInt(1, userId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM user_claims WHERE user_id = ?")) {
                    ps.setInt(1, userId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM hidden_content WHERE user_id = ?")) {
                    ps.setInt(1, userId);
                    ps.executeUpdate();
                }
                
                List<Integer> postIds = new ArrayList<>();
                try (PreparedStatement ps = conn.prepareStatement("SELECT id FROM posts WHERE user_id = ?")) {
                    ps.setInt(1, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) postIds.add(rs.getInt("id"));
                    }
                }
                
                for (int pid : postIds) {
                    try (PreparedStatement ps = conn.prepareStatement("DELETE FROM comments WHERE post_id = ?")) {
                        ps.setInt(1, pid);
                        ps.executeUpdate();
                    }
                    try (PreparedStatement ps = conn.prepareStatement("DELETE FROM post_interactions WHERE post_id = ?")) {
                        ps.setInt(1, pid);
                        ps.executeUpdate();
                    }
                    try (PreparedStatement ps = conn.prepareStatement("DELETE FROM saved_posts WHERE post_id = ?")) {
                        ps.setInt(1, pid);
                        ps.executeUpdate();
                    }
                }
                
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM posts WHERE user_id = ?")) {
                    ps.setInt(1, userId);
                    ps.executeUpdate();
                }
                
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM users WHERE id = ?")) {
                    ps.setInt(1, userId);
                    int deleted = ps.executeUpdate();
                    conn.commit();
                    return deleted > 0;
                }
            } catch (Exception e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}