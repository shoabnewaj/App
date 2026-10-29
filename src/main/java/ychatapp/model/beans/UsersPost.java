package ychatapp.model.beans;

import java.util.List;
import ychatapp.model.beans.PollOption;

public class UsersPost {

    private int id;
    private String name;
    private int userId;
    private String content;
    private String file_name;
    private String post_type;
    private String profile_pic;
    private String time;
    private String feeling;
    private int commentCount;
    private int shareCount;
    private int viewCount;

    // Reactions
    private int likeCount, loveCount, hahaCount, wowCount, sadCount, angryCount, Care, dislikes;

    // Comments list
    private List<CommentBeans> comments;

    // Poll options list
    private List<PollOption> pollOptions;
    private String pollQuestion;

    // Repost / Quote Post fields
    private int originalPostId;
    private UsersPost originalPost;

    public UsersPost() {}

    public UsersPost(int id, String name, int userId, String content, String file_name, String post_type, String feeling) {
        this.id = id;
        this.name = name;
        this.userId = userId;
        this.content = content;
        this.file_name = file_name;
        this.post_type = post_type;
        this.feeling = feeling;
    }

    // ===== Getters =====
    public int getId() { return id; }
    public String getName() { return name; }
    public String getUser_name() { return name; }
    public String getUserName() { return name; }
    public int getUserId() { return userId; }
    public String getContent() { return content; }
    public String getFile_name() { return file_name; }
    public String getFileName() { return file_name; }
    public String getPost_type() { return post_type; }
    public String getPostType() { return post_type; }
    public String getProfile_pic() { return profile_pic; }
    public String getProfilePic() { return profile_pic; }
    public String getTime() { return time; }
    public String getCreatedAt() { return time; }
    public String getCreated_at() { return time; }
    public String getFeeling() { return feeling; }
    public int getCommentCount() { return commentCount; }
    public int getShareCount() { return shareCount; }
    public int getViewCount() { return viewCount; }

    public int getLikeCount() { return likeCount; }
    public int getLoveCount() { return loveCount; }
    public int getHahaCount() { return hahaCount; }
    public int getWowCount() { return wowCount; }
    public int getSadCount() { return sadCount; }
    public int getAngryCount() { return angryCount; }
    public int getCareCount() { return Care; }
    public int getDislikes() { return dislikes; }

    public List<CommentBeans> getComments() { return comments; }

    // ===== Setters =====
    public void setId(int id) { this.id = id; }
    public void setName(String name) { this.name = name; }
    public void setUserId(int userId) { this.userId = userId; }
    public void setContent(String content) { this.content = content; }
    public void setFile_name(String file_name) { this.file_name = file_name; }
    public void setPost_type(String post_type) { this.post_type = post_type; }
    public void setProfile_pic(String profile_pic) { this.profile_pic = profile_pic; }
    public void setTime(String time) { this.time = time; }
    public void setFeeling(String feeling) { this.feeling = feeling; }
    public void setCommentCount(int commentCount) { this.commentCount = commentCount; }
    public void setShareCount(int shareCount) { this.shareCount = shareCount; }
    public void setViewCount(int viewCount) { this.viewCount = viewCount; }

    public void setLikeCount(int likeCount) { this.likeCount = likeCount; }
    public void setLoveCount(int loveCount) { this.loveCount = loveCount; }
    public void setHahaCount(int hahaCount) { this.hahaCount = hahaCount; }
    public void setWowCount(int wowCount) { this.wowCount = wowCount; }
    public void setSadCount(int sadCount) { this.sadCount = sadCount; }
    public void setAngryCount(int angryCount) { this.angryCount = angryCount; }
    public void setCareCount(int careCount) { this.Care = careCount; }
    public void setDislikes(int dislikes) { this.dislikes = dislikes; }

    public void setComments(List<CommentBeans> comments) { this.comments = comments; }

    public List<PollOption> getPollOptions() { return pollOptions; }
    public String getPollQuestion() { return pollQuestion; }
    public void setPollQuestion(String pollQuestion) { this.pollQuestion = pollQuestion; }
    public void setPollOptions(List<PollOption> pollOptions) { this.pollOptions = pollOptions; }

    public int getOriginalPostId() { return originalPostId; }
    public void setOriginalPostId(int originalPostId) { this.originalPostId = originalPostId; }

    public UsersPost getOriginalPost() { return originalPost; }
    public void setOriginalPost(UsersPost originalPost) { this.originalPost = originalPost; }

    public String getFormattedContent() {
        if (content == null) return "";
        String escaped = content.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
        return escaped.replaceAll("#([\\p{L}\\p{N}_]+)", "<a href=\"UsersPostServlet?tag=$1\" class=\"text-indigo-600 font-semibold hover:underline\">#$1</a>");
    }

    private boolean is_verified = false;

    public boolean isVerified() {
        return is_verified;
    }

    public boolean getIs_verified() {
        return is_verified;
    }

    public void setIs_verified(boolean is_verified) {
        this.is_verified = is_verified;
    }
}