package ychatapp.model.beans;

import java.io.Serializable;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class CreatorTipBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int senderId;
    private String senderName;
    private String senderPic;
    private int receiverId;
    private String receiverName;
    private Integer postId;
    private double amount;
    private String paymentMethod;
    private String transactionId;
    private String note;
    private String status;
    private Timestamp createdAt;

    public CreatorTipBean() {}

    public CreatorTipBean(int id, int senderId, String senderName, String senderPic,
                          int receiverId, String receiverName, Integer postId,
                          double amount, String paymentMethod, String transactionId,
                          String note, String status, Timestamp createdAt) {
        this.id = id;
        this.senderId = senderId;
        this.senderName = senderName;
        this.senderPic = senderPic;
        this.receiverId = receiverId;
        this.receiverName = receiverName;
        this.postId = postId;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.transactionId = transactionId;
        this.note = note;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getSenderId() { return senderId; }
    public void setSenderId(int senderId) { this.senderId = senderId; }

    public String getSenderName() { return senderName; }
    public void setSenderName(String senderName) { this.senderName = senderName; }

    public String getSenderPic() { return senderPic; }
    public void setSenderPic(String senderPic) { this.senderPic = senderPic; }

    public int getReceiverId() { return receiverId; }
    public void setReceiverId(int receiverId) { this.receiverId = receiverId; }

    public String getReceiverName() { return receiverName; }
    public void setReceiverName(String receiverName) { this.receiverName = receiverName; }

    public Integer getPostId() { return postId; }
    public void setPostId(Integer postId) { this.postId = postId; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getFormattedTime() {
        if (createdAt == null) return "";
        try {
            return new SimpleDateFormat("MMM dd, yyyy hh:mm a").format(createdAt);
        } catch (Exception e) {
            return createdAt.toString();
        }
    }
}
