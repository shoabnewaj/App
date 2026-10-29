package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import ychatapp.model.beans.CreatorTipBean;

public class CreatorTipDAO {

    public CreatorTipDAO() {
        createTableIfNotExists();
    }

    private Connection getConnection() throws Exception {
        return DBConnection.getConnection();
    }

    private void createTableIfNotExists() {
        String sql = "CREATE TABLE IF NOT EXISTS creator_tips (" +
                     "id INT AUTO_INCREMENT PRIMARY KEY," +
                     "sender_id INT NOT NULL," +
                     "receiver_id INT NOT NULL," +
                     "post_id INT DEFAULT NULL," +
                     "amount DOUBLE NOT NULL," +
                     "payment_method VARCHAR(50) NOT NULL," +
                     "transaction_id VARCHAR(100) NOT NULL," +
                     "note TEXT DEFAULT NULL," +
                     "status VARCHAR(30) DEFAULT 'COMPLETED'," +
                     "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                     "FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE," +
                     "FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE" +
                     ") ENGINE=InnoDB;";
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
        } catch (Exception e) {
            System.err.println("CreatorTipDAO table warning: " + e.getMessage());
        }
    }

    public boolean sendTip(int senderId, int receiverId, Integer postId, double amount, String method, String trxId, String note) throws Exception {
        if (!"WALLET".equalsIgnoreCase(method)) throw new IllegalArgumentException("Direct bKash/Nagad/card tips are not configured. Add funds through secure checkout, then pay from wallet.");
        if (senderId == receiverId) {
            throw new IllegalArgumentException("You cannot send a tip to yourself.");
        }
        if (amount <= 0) {
            throw new IllegalArgumentException("Tip amount must be greater than zero.");
        }
        if (trxId == null || trxId.trim().isEmpty()) {
            trxId = "TIP" + System.currentTimeMillis();
        }

        String senderName = "A supporter";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Get sender name for notification
                String nameSql = "SELECT name, balance FROM users WHERE id = ? FOR UPDATE";
                double senderBalance = 0.0;
                try (PreparedStatement psName = conn.prepareStatement(nameSql)) {
                    psName.setInt(1, senderId);
                    try (ResultSet rs = psName.executeQuery()) {
                        if (rs.next()) {
                            senderName = rs.getString("name");
                            senderBalance = rs.getDouble("balance");
                        }
                    }
                }

                // If paying with Wallet Balance, ensure sufficient funds and deduct
                if ("WALLET".equalsIgnoreCase(method)) {
                    if (senderBalance < amount) {
                        conn.rollback();
                        throw new IllegalStateException("Insufficient wallet balance. You have $" + String.format("%.2f", senderBalance) + " available.");
                    }
                    String deductSql = "UPDATE users SET balance = balance - ? WHERE id = ?";
                    try (PreparedStatement psDeduct = conn.prepareStatement(deductSql)) {
                        psDeduct.setDouble(1, amount);
                        psDeduct.setInt(2, senderId);
                        psDeduct.executeUpdate();
                    }
                }

                // Credit receiver's balance
                String creditSql = "UPDATE users SET balance = balance + ? WHERE id = ?";
                try (PreparedStatement psCredit = conn.prepareStatement(creditSql)) {
                    psCredit.setDouble(1, amount);
                    psCredit.setInt(2, receiverId);
                    psCredit.executeUpdate();
                }

                // Record into creator_tips
                String tipSql = "INSERT INTO creator_tips (sender_id, receiver_id, post_id, amount, payment_method, transaction_id, note, status) " +
                                "VALUES (?, ?, ?, ?, ?, ?, ?, 'COMPLETED')";
                try (PreparedStatement psTip = conn.prepareStatement(tipSql)) {
                    psTip.setInt(1, senderId);
                    psTip.setInt(2, receiverId);
                    if (postId != null && postId > 0) {
                        psTip.setInt(3, postId);
                    } else {
                        psTip.setNull(3, java.sql.Types.INTEGER);
                    }
                    psTip.setDouble(4, amount);
                    psTip.setString(5, method != null ? method.toUpperCase() : "WALLET");
                    psTip.setString(6, trxId);
                    psTip.setString(7, note);
                    psTip.executeUpdate();
                }

                // Also record into payments table for financial audit
                try {
                    String paySql = "INSERT INTO payments (user_id, amount, payment_method, transaction_id, status, purpose) " +
                                   "VALUES (?, ?, ?, ?, 'COMPLETED', ?)";
                    try (PreparedStatement psPay = conn.prepareStatement(paySql)) {
                        psPay.setInt(1, senderId);
                        psPay.setDouble(2, amount);
                        psPay.setString(3, method);
                        psPay.setString(4, trxId);
                        psPay.setString(5, "CREATOR_TIP_TO_" + receiverId);
                        psPay.executeUpdate();
                    }
                } catch (Exception ignore) {}

                conn.commit();
            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            }
        }

        // Send real-time notification to the creator
        try {
            String notifMsg = "🎉 " + senderName + " sent you a tip of $" + String.format("%.2f", amount) +
                    (note != null && !note.trim().isEmpty() ? ": \"" + note.trim() + "\"" : "!");
            new NotificationDAO().addNotification(receiverId, notifMsg);
        } catch (Exception ignore) {}

        return true;
    }

    public List<CreatorTipBean> getTipsReceived(int userId) {
        List<CreatorTipBean> list = new ArrayList<>();
        String sql = "SELECT t.*, u.name as sender_name, u.profile_pic as sender_pic, r.name as receiver_name " +
                     "FROM creator_tips t " +
                     "JOIN users u ON t.sender_id = u.id " +
                     "JOIN users r ON t.receiver_id = r.id " +
                     "WHERE t.receiver_id = ? " +
                     "ORDER BY t.id DESC LIMIT 50";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CreatorTipBean tip = new CreatorTipBean(
                        rs.getInt("id"),
                        rs.getInt("sender_id"),
                        rs.getString("sender_name"),
                        rs.getString("sender_pic"),
                        rs.getInt("receiver_id"),
                        rs.getString("receiver_name"),
                        (Integer) rs.getObject("post_id"),
                        rs.getDouble("amount"),
                        rs.getString("payment_method"),
                        rs.getString("transaction_id"),
                        rs.getString("note"),
                        rs.getString("status"),
                        rs.getTimestamp("created_at")
                    );
                    list.add(tip);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public double getTotalTipsReceived(int userId) {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM creator_tips WHERE receiver_id = ? AND status = 'COMPLETED'";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }
}
