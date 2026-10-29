package ychatapp.model.beans;

public class StoryViewerBean {
    private int userId;
    private String name;
    private String profilePic;
    private String viewedAt;

    public StoryViewerBean() {}

    public StoryViewerBean(int userId, String name, String profilePic, String viewedAt) {
        this.userId = userId;
        this.name = name;
        this.profilePic = profilePic;
        this.viewedAt = viewedAt;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getProfilePic() {
        return profilePic;
    }

    public void setProfilePic(String profilePic) {
        this.profilePic = profilePic;
    }

    public String getViewedAt() {
        return viewedAt;
    }

    public void setViewedAt(String viewedAt) {
        this.viewedAt = viewedAt;
    }
}
