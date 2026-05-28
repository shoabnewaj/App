package ychatapp.model.dao;
 
import java.sql.Connection;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
 
public class DBConnection {
    private static HikariDataSource dataSource;
 
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Railway MySQL environment variables
            String host = System.getenv("MYSQLHOST");
            String port = System.getenv("MYSQLPORT");
            String database = System.getenv("MYSQLDATABASE");
            String user = System.getenv("MYSQLUSER");
            String password = System.getenv("MYSQLPASSWORD");
 
            String url;
            if (host != null && !host.trim().isEmpty()) {
                url = "jdbc:mysql://" + host + ":" + (port != null ? port : "3306") + "/" + (database != null ? database : "ychatapp") + "?useSSL=false&allowPublicKeyRetrieval=true&characterEncoding=UTF-8&useUnicode=true";
            } else {
                // Local fallback
                url = "jdbc:mysql://127.0.0.1:3306/ychatapp?useSSL=false&allowPublicKeyRetrieval=true&characterEncoding=UTF-8&useUnicode=true";
                user = "root";
                password = "1234";
            }
 
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(url);
            config.setUsername(user);
            config.setPassword(password);
            config.setDriverClassName("com.mysql.cj.jdbc.Driver");
            
            // Pool configuration
            config.setMaximumPoolSize(20);
            config.setMinimumIdle(5);
            config.setIdleTimeout(30000);
            config.setMaxLifetime(1800000);
            config.setConnectionTimeout(10000);
            
            // Optimizations for MySQL
            config.addDataSourceProperty("cachePrepStmts", "true");
            config.addDataSourceProperty("prepStmtCacheSize", "250");
            config.addDataSourceProperty("prepStmtCacheLimit", "2048");
            config.addDataSourceProperty("useServerPrepStmts", "true");
            config.addDataSourceProperty("useLocalSessionState", "true");
            config.addDataSourceProperty("rewriteBatchedStatements", "true");
            config.addDataSourceProperty("cacheResultSetMetadata", "true");
            config.addDataSourceProperty("cacheServerConfiguration", "true");
            config.addDataSourceProperty("elideSetAutoCommits", "true");
            config.addDataSourceProperty("maintainTimeStats", "false");
            
            dataSource = new HikariDataSource(config);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
 
    public static Connection getConnection() throws java.sql.SQLException {
        if (dataSource == null) {
            throw new java.sql.SQLException("HikariDataSource is not initialized");
        }
        return dataSource.getConnection();
    }
}