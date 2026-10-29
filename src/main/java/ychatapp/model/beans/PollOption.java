package ychatapp.model.beans;

public class PollOption {
    private int id;
    private int postId;
    private String optionText;
    private int voteCount;
    private int percentage;
    private boolean votedByCurrentUser;

    public PollOption() {}

    public PollOption(int id, int postId, String optionText, int voteCount) {
        this.id = id;
        this.postId = postId;
        this.optionText = optionText;
        this.voteCount = voteCount;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPostId() { return postId; }
    public void setPostId(int postId) { this.postId = postId; }

    public String getOptionText() { return optionText; }
    public void setOptionText(String optionText) { this.optionText = optionText; }

    public int getVoteCount() { return voteCount; }
    public void setVoteCount(int voteCount) { this.voteCount = voteCount; }

    public int getPercentage() { return percentage; }
    public void setPercentage(int percentage) { this.percentage = percentage; }

    public boolean isVotedByCurrentUser() { return votedByCurrentUser; }
    public void setVotedByCurrentUser(boolean votedByCurrentUser) { this.votedByCurrentUser = votedByCurrentUser; }
}
