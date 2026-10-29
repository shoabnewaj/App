package ychatapp.model;

public class Message {
    private int id;
    private String sender;
    private String receiver;
    private String message;
    private boolean isRead;
    private boolean isEdited;
    private boolean isDeleted;
    private String reaction;
    private Integer replyToId;
    private String replyToText;
    private String timestamp;

    public Message(String sender, String receiver, String message) {
        this(0, sender, receiver, message, false, false, false, null, null, null, null);
    }

    public Message(String sender, String receiver, String message, boolean isRead) {
        this(0, sender, receiver, message, isRead, false, false, null, null, null, null);
    }

    public Message(int id, String sender, String receiver, String message, boolean isRead,
                   boolean isEdited, boolean isDeleted, String reaction,
                   Integer replyToId, String replyToText, String timestamp) {
        this.id = id;
        this.sender = sender;
        this.receiver = receiver;
        this.message = message;
        this.isRead = isRead;
        this.isEdited = isEdited;
        this.isDeleted = isDeleted;
        this.reaction = reaction;
        this.replyToId = replyToId;
        this.replyToText = replyToText;
        this.timestamp = timestamp;
    }

    public int getId() { return id; }
    public String getSender() { return sender; }
    public String getReceiver() { return receiver; }
    public String getMessage() { return message; }
    public boolean isRead() { return isRead; }
    public boolean isEdited() { return isEdited; }
    public boolean isDeleted() { return isDeleted; }
    public String getReaction() { return reaction; }
    public Integer getReplyToId() { return replyToId; }
    public String getReplyToText() { return replyToText; }
    public String getTimestamp() { return timestamp; }
}