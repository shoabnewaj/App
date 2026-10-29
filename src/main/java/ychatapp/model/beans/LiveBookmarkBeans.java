package ychatapp.model.beans;

public class LiveBookmarkBeans {
    private int streamerId;
    private String streamerName;
    private String title;
    private String savedAt;

    public int getStreamerId() { return streamerId; }
    public void setStreamerId(int streamerId) { this.streamerId = streamerId; }
    public String getStreamerName() { return streamerName; }
    public void setStreamerName(String streamerName) { this.streamerName = streamerName; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getSavedAt() { return savedAt; }
    public void setSavedAt(String savedAt) { this.savedAt = savedAt; }
}
