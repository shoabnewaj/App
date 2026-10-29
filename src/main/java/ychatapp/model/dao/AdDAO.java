package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import ychatapp.model.beans.AdBeans;

public class AdDAO {
    private Connection getConnection() throws Exception {
        return DBConnection.getConnection();
    }

    public List<AdBeans> getAllAds() {
        List<AdBeans> list = new ArrayList<>();
        String sql = "SELECT * FROM ads ORDER BY id DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                AdBeans ad = new AdBeans();
                ad.setId(rs.getInt("id"));
                ad.setTitle(rs.getString("title"));
                ad.setDescription(rs.getString("description"));
                ad.setImageUrl(rs.getString("image_url"));
                ad.setLinkUrl(rs.getString("link_url"));
                ad.setCreatorId(rs.getInt("creator_id"));
                ad.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(ad);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addAd(String title, String description, String imageUrl, String linkUrl, int creatorId) {
        String sql = "INSERT INTO ads (title, description, image_url, link_url, creator_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, imageUrl);
            ps.setString(4, linkUrl);
            ps.setInt(5, creatorId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public AdBeans getRandomAd() {
        String sql = "SELECT * FROM ads ORDER BY RAND() LIMIT 1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                AdBeans ad = new AdBeans();
                ad.setId(rs.getInt("id"));
                ad.setTitle(rs.getString("title"));
                ad.setDescription(rs.getString("description"));
                ad.setImageUrl(rs.getString("image_url"));
                ad.setLinkUrl(rs.getString("link_url"));
                ad.setCreatorId(rs.getInt("creator_id"));
                ad.setCreatedAt(rs.getTimestamp("created_at"));
                return ad;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Fallback default ad if none exists in database
        AdBeans fallback = new AdBeans();
        fallback.setId(0);
        fallback.setTitle("Y-Ads Manager");
        fallback.setDescription("Grow your business today with ychat ads!");
        fallback.setImageUrl("https://images.unsplash.com/photo-1611162617474-5b21e879e113?q=80&w=1000&auto=format&fit=crop");
        fallback.setLinkUrl("yads");
        fallback.setCreatorId(1);
        return fallback;
    }
}
