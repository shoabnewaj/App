package ychatapp.model;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class LiveManager {

    public static class LiveStreamInfo {
        private final String streamerUsername;
        private final String title;
        private final long startTime;
        private final Set<String> viewers = Collections.newSetFromMap(new ConcurrentHashMap<String, Boolean>());

        public LiveStreamInfo(String streamerUsername, String title) {
            this.streamerUsername = streamerUsername;
            this.title = title;
            this.startTime = System.currentTimeMillis();
        }

        public String getStreamerUsername() {
            return streamerUsername;
        }

        public String getTitle() {
            return title;
        }

        public long getStartTime() {
            return startTime;
        }

        public Set<String> getViewers() {
            return viewers;
        }
    }

    private static final ConcurrentHashMap<String, LiveStreamInfo> activeStreams = new ConcurrentHashMap<>();

    public static void startStream(String streamer, String title) {
        if (streamer == null) return;
        activeStreams.put(streamer, new LiveStreamInfo(streamer, title));
    }

    public static void endStream(String streamer) {
        if (streamer == null) return;
        activeStreams.remove(streamer);
    }

    public static LiveStreamInfo getStream(String streamer) {
        if (streamer == null) return null;
        return activeStreams.get(streamer);
    }

    public static List<LiveStreamInfo> getActiveStreams() {
        return new ArrayList<>(activeStreams.values());
    }

    public static void addViewer(String streamer, String viewer) {
        LiveStreamInfo info = getStream(streamer);
        if (info != null && viewer != null) {
            info.getViewers().add(viewer);
        }
    }

    public static void removeViewer(String streamer, String viewer) {
        LiveStreamInfo info = getStream(streamer);
        if (info != null && viewer != null) {
            info.getViewers().remove(viewer);
        }
    }
}