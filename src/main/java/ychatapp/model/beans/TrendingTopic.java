package ychatapp.model.beans;

public class TrendingTopic {
    private String tag;
    private int count;

    public TrendingTopic() {}

    public TrendingTopic(String tag, int count) {
        this.tag = tag;
        this.count = count;
    }

    public String getTag() {
        return tag;
    }

    public String getTagName() {
        return tag;
    }

    public void setTag(String tag) {
        this.tag = tag;
    }

    public int getCount() {
        return count;
    }

    public int getPostCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }
}
