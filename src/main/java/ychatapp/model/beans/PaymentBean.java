package ychatapp.model.beans;

import java.sql.Timestamp;

public class PaymentBean {
    private int id;
    private int userId;
    private String userName;
    private double amount;
    private String paymentMethod;
    private String transactionId;
    private String status;
    private String purpose;
    private String currency;
    private Timestamp createdAt;

    public PaymentBean() {}

    public PaymentBean(int id, int userId, String userName, double amount, String paymentMethod, String transactionId, String status, String purpose, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.userName = userName;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.transactionId = transactionId;
        this.status = status;
        this.purpose = purpose;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCurrency() { return currency; }
    public void setCurrency(String currency) { this.currency = currency; }

    public String getPurpose() { return purpose; }
    public void setPurpose(String purpose) { this.purpose = purpose; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
