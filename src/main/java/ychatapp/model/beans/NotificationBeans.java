package ychatapp.model.beans;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public class NotificationBeans {
    private int id;
    private int senderId;
    private String type;
    private String message;
    private String createdAt;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getSenderId() { return senderId; }
    public void setSenderId(int senderId) { this.senderId = senderId; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    public String getTimeAgo() {
        if (createdAt == null || createdAt.isBlank()) return "";
        try {
            LocalDateTime created = LocalDateTime.parse(createdAt.replace(' ', 'T'), DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            Duration elapsed = Duration.between(created, LocalDateTime.now());
            long seconds = Math.max(0, elapsed.getSeconds());
            if (seconds < 60) return "Just now";
            long minutes = seconds / 60;
            if (minutes < 60) return minutes + (minutes == 1 ? " minute ago" : " minutes ago");
            long hours = minutes / 60;
            if (hours < 24) return hours + (hours == 1 ? " hour ago" : " hours ago");
            long days = hours / 24;
            if (days < 7) return days + (days == 1 ? " day ago" : " days ago");
            return created.format(DateTimeFormatter.ofPattern("MMM d, yyyy 'at' h:mm a"));
        } catch (DateTimeParseException | ArithmeticException e) {
            return createdAt;
        }
    }
}
