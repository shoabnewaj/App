package ychatapp.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class ProfilePrivacyDAO {
    private Connection connection() throws Exception { return DBConnection.getConnection(); }
    private void ensure(Connection c) throws Exception { try(Statement s=c.createStatement()){s.executeUpdate("CREATE TABLE IF NOT EXISTS profile_privacy(user_id INT PRIMARY KEY, visibility VARCHAR(16) NOT NULL DEFAULT 'PUBLIC', updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE) ENGINE=InnoDB");} }
    public String getVisibility(int userId) { try(Connection c=connection()){ensure(c);try(PreparedStatement p=c.prepareStatement("SELECT visibility FROM profile_privacy WHERE user_id=?")){p.setInt(1,userId);try(ResultSet r=p.executeQuery()){return r.next()?r.getString(1):"PUBLIC";}}}catch(Exception e){return "PUBLIC";} }
    public boolean setVisibility(int userId,String visibility) { if(userId<=0||visibility==null||!visibility.matches("PUBLIC|FRIENDS|PRIVATE"))return false;try(Connection c=connection()){ensure(c);try(PreparedStatement p=c.prepareStatement("INSERT INTO profile_privacy(user_id,visibility) VALUES(?,?) ON DUPLICATE KEY UPDATE visibility=VALUES(visibility)")){p.setInt(1,userId);p.setString(2,visibility);return p.executeUpdate()>0;}}catch(Exception e){e.printStackTrace();return false;} }
    public boolean canViewProfile(int ownerId,int viewerId) { if(ownerId==viewerId)return true;String visibility=getVisibility(ownerId);if("PUBLIC".equals(visibility))return true;if(!"FRIENDS".equals(visibility))return false;try(Connection c=connection();PreparedStatement p=c.prepareStatement("SELECT 1 FROM friendships WHERE status='ACCEPTED' AND ((user_id1=? AND user_id2=?) OR (user_id1=? AND user_id2=?)) LIMIT 1")){p.setInt(1,ownerId);p.setInt(2,viewerId);p.setInt(3,viewerId);p.setInt(4,ownerId);try(ResultSet r=p.executeQuery()){return r.next();}}catch(Exception e){return false;} }
}
