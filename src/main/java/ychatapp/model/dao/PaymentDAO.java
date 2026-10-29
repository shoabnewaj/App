package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import ychatapp.model.beans.PaymentBean;

public class PaymentDAO {

    private Connection getConnection() throws Exception {
        return DBConnection.getConnection();
    }

    public PaymentDAO() {
        ensurePaymentTablesExist();
    }

    public void ensurePaymentTablesExist() {
        String createTableSql = "CREATE TABLE IF NOT EXISTS payments (" +
                "id INT AUTO_INCREMENT PRIMARY KEY, " +
                "user_id INT NOT NULL, " +
                "amount DOUBLE NOT NULL, " +
                "payment_method VARCHAR(50) NOT NULL, " +
                "transaction_id VARCHAR(100) NOT NULL UNIQUE, " +
                "status VARCHAR(30) DEFAULT 'COMPLETED', " +
                "purpose VARCHAR(100) DEFAULT 'BLUE_TICK', " +
                "currency VARCHAR(3) NOT NULL DEFAULT 'USD', " +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE" +
                ") ENGINE=InnoDB;";

        String alterUsersSql = "ALTER TABLE users ADD COLUMN IF NOT EXISTS is_verified TINYINT(1) DEFAULT 0, " +
                "ADD COLUMN IF NOT EXISTS otp_code VARCHAR(10) DEFAULT NULL, " +
                "ADD COLUMN IF NOT EXISTS is_banned TINYINT(1) DEFAULT 0;";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(createTableSql);
            try (ResultSet columns = conn.getMetaData().getColumns(conn.getCatalog(), null, "payments", "currency")) {
                if (!columns.next()) stmt.executeUpdate("ALTER TABLE payments ADD COLUMN currency VARCHAR(3) NOT NULL DEFAULT 'USD'");
            } catch (Exception ignored) { }
            try {
                stmt.executeUpdate(alterUsersSql);
            } catch (Exception ex) {
                // Column might already exist, ignore MySQL duplicate column error
            }
        } catch (Exception e) {
            System.err.println("PaymentDAO setup warning: " + e.getMessage());
        }
    }

    public boolean recordStripePayment(int userId, String sessionId, String purpose, long amountMinor, String currency) {
        return recordProviderPayment(userId, sessionId, "STRIPE", purpose, amountMinor, currency);
    }

    public boolean recordProviderPayment(int userId, String sessionId, String provider, String purpose, long amountMinor, String currency) {
        ensurePaymentTablesExist();
        if (userId <= 0 || sessionId == null || provider == null || !provider.matches("[A-Z_]{2,20}") || amountMinor <= 0 || currency == null) return false;
        if ("BLUE_TICK".equals(purpose) && (!"usd".equalsIgnoreCase(currency) || amountMinor != 499L)) return false;
        if ("WALLET_TOPUP".equals(purpose) && (!"usd".equalsIgnoreCase(currency) || amountMinor < 500L || amountMinor > 50000L)) return false;
        if (!"BLUE_TICK".equals(purpose) && !"WALLET_TOPUP".equals(purpose)) return false;
        String normalizedCurrency = currency.toUpperCase(java.util.Locale.ROOT);
        java.math.BigDecimal amount = java.math.BigDecimal.valueOf(amountMinor, 2);
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement check = conn.prepareStatement("SELECT id FROM payments WHERE transaction_id=? FOR UPDATE")) {
                check.setString(1, sessionId);
                try (ResultSet rs = check.executeQuery()) { if (rs.next()) { conn.commit(); return true; } }
            }
            try (PreparedStatement insert = conn.prepareStatement("INSERT INTO payments(user_id,amount,payment_method,transaction_id,status,purpose,currency) VALUES(?,?,?,? ,'COMPLETED',?,?)")) {
                insert.setInt(1,userId); insert.setBigDecimal(2,amount); insert.setString(3,provider); insert.setString(4,sessionId); insert.setString(5,purpose); insert.setString(6,normalizedCurrency); insert.executeUpdate();
            }
            if ("BLUE_TICK".equals(purpose)) {
                try (PreparedStatement update = conn.prepareStatement("UPDATE users SET is_verified=1 WHERE id=?")) { update.setInt(1,userId); if (update.executeUpdate()!=1) throw new java.sql.SQLException("Payment user not found"); }
            } else if ("WALLET_TOPUP".equals(purpose)) {
                try (PreparedStatement update = conn.prepareStatement("UPDATE users SET balance=balance+? WHERE id=?")) { update.setBigDecimal(1,amount); update.setInt(2,userId); if (update.executeUpdate()!=1) throw new java.sql.SQLException("Payment user not found"); }
            } else { throw new java.sql.SQLException("Unsupported settled purpose"); }
            conn.commit(); return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean isUserVerified(int userId) {
        String sql = "SELECT is_verified FROM users WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("is_verified") == 1;
                }
            }
        } catch (Exception e) {
            // Non-critical, fallback to false
        }
        return false;
    }

    public List<PaymentBean> getAllPayments() {
        ensurePaymentTablesExist();
        List<PaymentBean> list = new ArrayList<>();
        String sql = "SELECT p.*, u.name as user_name FROM payments p JOIN users u ON p.user_id = u.id ORDER BY p.id DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                PaymentBean pb = new PaymentBean();
                pb.setId(rs.getInt("id"));
                pb.setUserId(rs.getInt("user_id"));
                pb.setUserName(rs.getString("user_name"));
                pb.setAmount(rs.getDouble("amount"));
                pb.setPaymentMethod(rs.getString("payment_method"));
                pb.setTransactionId(rs.getString("transaction_id"));
                pb.setStatus(rs.getString("status"));
                pb.setPurpose(rs.getString("purpose"));
                pb.setCurrency(rs.getString("currency"));
                pb.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(pb);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
