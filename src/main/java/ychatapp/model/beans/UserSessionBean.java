package ychatapp.model.beans;

import java.io.Serializable;

public class UserSessionBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int userId;
    private String sessionId;
    private String ipAddress;
    private String userAgent;
    private String deviceType;
    private String browser;
    private String operatingSystem;
    private String location;
    private String lastActive;
    private String createdAt;
    private boolean isCurrent;

    public UserSessionBean() {}

    public UserSessionBean(int id, int userId, String sessionId, String ipAddress, String deviceType,
                           String browser, String operatingSystem, String location, String lastActive, boolean isCurrent) {
        this.id = id;
        this.userId = userId;
        this.sessionId = sessionId;
        this.ipAddress = ipAddress;
        this.deviceType = deviceType;
        this.browser = browser;
        this.operatingSystem = operatingSystem;
        this.location = location;
        this.lastActive = lastActive;
        this.isCurrent = isCurrent;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }

    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }

    public String getUserAgent() { return userAgent; }
    public void setUserAgent(String userAgent) { this.userAgent = userAgent; }

    public String getDeviceType() { return deviceType; }
    public void setDeviceType(String deviceType) { this.deviceType = deviceType; }

    public String getBrowser() { return browser; }
    public void setBrowser(String browser) { this.browser = browser; }

    public String getOperatingSystem() { return operatingSystem; }
    public void setOperatingSystem(String operatingSystem) { this.operatingSystem = operatingSystem; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getLastActive() { return lastActive; }
    public void setLastActive(String lastActive) { this.lastActive = lastActive; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    public boolean isCurrent() { return isCurrent; }
    public void setCurrent(boolean current) { isCurrent = current; }
}
