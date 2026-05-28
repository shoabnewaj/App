package ychatapp.model.beans;

public class EventBeans {
    private int id;
    private int userId;
    private String userName;
    private String userProfilePic;
    private String title;
    private String description;
    private String eventDate;
    private String location;
    private String createdAt;
    private int rsvpCountGoing;
    private int rsvpCountInterested;
    private String currentUserRsvp; // 'GOING', 'INTERESTED', or null

    public EventBeans() {}

    public EventBeans(int id, int userId, String userName, String userProfilePic, String title, String description, String eventDate, String location, String createdAt) {
        this.id = id;
        this.userId = userId;
        this.userName = userName;
        this.userProfilePic = userProfilePic;
        this.title = title;
        this.description = description;
        this.eventDate = eventDate;
        this.location = location;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserProfilePic() { return userProfilePic; }
    public void setUserProfilePic(String userProfilePic) { this.userProfilePic = userProfilePic; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getEventDate() { return eventDate; }
    public void setEventDate(String eventDate) { this.eventDate = eventDate; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    public int getRsvpCountGoing() { return rsvpCountGoing; }
    public void setRsvpCountGoing(int rsvpCountGoing) { this.rsvpCountGoing = rsvpCountGoing; }

    public int getRsvpCountInterested() { return rsvpCountInterested; }
    public void setRsvpCountInterested(int rsvpCountInterested) { this.rsvpCountInterested = rsvpCountInterested; }

    public String getCurrentUserRsvp() { return currentUserRsvp; }
    public void setCurrentUserRsvp(String currentUserRsvp) { this.currentUserRsvp = currentUserRsvp; }
}