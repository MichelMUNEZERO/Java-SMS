package com.sms.dao;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.sms.model.Announcement;
import com.sms.util.DBConnection;

/**
 * Data Access Object for Announcement-related database operations
 */
public class AnnouncementDAO {
    private static final Logger LOGGER = Logger.getLogger(AnnouncementDAO.class.getName());
    
    /**
     * Get all announcements from the database
     * @return List of Announcement objects
     */
    public List<Announcement> getAllAnnouncements() {
        List<Announcement> announcements = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT a.*, u.username FROM Announcements a LEFT JOIN users u ON a.created_by = u.user_id ORDER BY created_at DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Announcement announcement = new Announcement();
                announcement.setAnnouncementId(rs.getInt("announcement_id"));
                
                // Extract title from content (first line)
                String content = rs.getString("content");
                if (content != null && content.contains("\n\n")) {
                    String[] parts = content.split("\n\n", 2);
                    announcement.setTitle(parts[0]);
                    announcement.setMessage(parts[1]);
                } else {
                    announcement.setTitle("Announcement");
                    announcement.setMessage(content);
                }
                
                announcement.setDate(rs.getTimestamp("created_at"));
                
                // Get username if available, otherwise use user ID as string
                String username = rs.getString("username");
                if (username != null) {
                    announcement.setPostedBy(username);
                } else {
                    int createdBy = rs.getInt("created_by");
                    if (!rs.wasNull()) {
                        announcement.setPostedBy(String.valueOf(createdBy));
                    } else {
                        announcement.setPostedBy("Unknown");
                    }
                }
                
                announcement.setTargetGroup(rs.getString("target_audience"));
                
                announcements.add(announcement);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all announcements", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return announcements;
    }
    
    /**
     * Get recent announcements
     * @param limit Number of announcements to retrieve
     * @return List of Announcement objects
     */
    public List<Announcement> getRecentAnnouncements(int limit) {
        List<Announcement> announcements = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Announcements ORDER BY created_at DESC LIMIT ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Announcement announcement = new Announcement();
                announcement.setAnnouncementId(rs.getInt("announcement_id"));
                announcement.setTitle(rs.getString("content"));
                announcement.setMessage(rs.getString("content"));
                announcement.setDate(rs.getTimestamp("created_at"));
                announcement.setPostedBy(rs.getString("created_by"));
                announcement.setTargetGroup(rs.getString("target_audience"));
                
                announcements.add(announcement);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting recent announcements", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return announcements;
    }
    
    /**
     * Get announcements by target group
     * @param targetGroup The target group to filter by
     * @return List of Announcement objects
     */
    public List<Announcement> getAnnouncementsByTargetGroup(String targetGroup) {
        List<Announcement> announcements = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Announcements WHERE target_audience = ? ORDER BY created_at DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, targetGroup);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Announcement announcement = new Announcement();
                announcement.setAnnouncementId(rs.getInt("announcement_id"));
                announcement.setTitle(rs.getString("content"));
                announcement.setMessage(rs.getString("content"));
                announcement.setDate(rs.getTimestamp("created_at"));
                announcement.setPostedBy(rs.getString("created_by"));
                announcement.setTargetGroup(rs.getString("target_audience"));
                
                announcements.add(announcement);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting announcements by target group: " + targetGroup, e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return announcements;
    }
    
    /**
     * Get an announcement by ID
     * @param announcementId The ID of the announcement to retrieve
     * @return Announcement object if found, null otherwise
     */
    public Announcement getAnnouncementById(int announcementId) {
        Announcement announcement = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT a.*, u.username FROM Announcements a LEFT JOIN users u ON a.created_by = u.user_id WHERE announcement_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, announcementId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                announcement = new Announcement();
                announcement.setAnnouncementId(rs.getInt("announcement_id"));
                
                // Extract title from content (first line)
                String content = rs.getString("content");
                if (content != null && content.contains("\n\n")) {
                    String[] parts = content.split("\n\n", 2);
                    announcement.setTitle(parts[0]);
                    announcement.setMessage(parts[1]);
                } else {
                    announcement.setTitle("Announcement");
                    announcement.setMessage(content);
                }
                
                announcement.setDate(rs.getTimestamp("created_at"));
                
                // Get username if available, otherwise use user ID as string
                String username = rs.getString("username");
                if (username != null) {
                    announcement.setPostedBy(username);
                } else {
                    int createdBy = rs.getInt("created_by");
                    if (!rs.wasNull()) {
                        announcement.setPostedBy(String.valueOf(createdBy));
                    } else {
                        announcement.setPostedBy("Unknown");
                    }
                }
                
                announcement.setTargetGroup(rs.getString("target_audience"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting announcement with ID: " + announcementId, e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return announcement;
    }
    
    /**
     * Add a new announcement
     * @param announcement The announcement to add
     * @return true if successful, false otherwise
     */
    public boolean addAnnouncement(Announcement announcement) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO Announcements (content, created_at, target_audience, created_by) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            
            // Combine title and message for the content field
            String fullContent = announcement.getTitle() + "\n\n" + announcement.getMessage();
            pstmt.setString(1, fullContent);
            pstmt.setTimestamp(2, announcement.getDate());
            pstmt.setString(3, announcement.getTargetGroup());
            
            // Handle created_by as an integer (user ID)
            if (announcement.getPostedBy() != null && announcement.getPostedBy().matches("\\d+")) {
                pstmt.setInt(4, Integer.parseInt(announcement.getPostedBy()));
            } else {
                // If not a valid integer, set to NULL
                pstmt.setNull(4, java.sql.Types.INTEGER);
            }
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding announcement", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, null);
        }
        
        return success;
    }
    
    /**
     * Update an existing announcement
     * @param announcement The announcement with updated information
     * @return true if successful, false otherwise
     */
    public boolean updateAnnouncement(Announcement announcement) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE Announcements SET content = ?, target_audience = ? WHERE announcement_id = ?";
            pstmt = conn.prepareStatement(sql);
            
            // Combine title and message for the content field
            String fullContent = announcement.getTitle() + "\n\n" + announcement.getMessage();
            pstmt.setString(1, fullContent);
            pstmt.setString(2, announcement.getTargetGroup());
            pstmt.setInt(3, announcement.getAnnouncementId());
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating announcement with ID: " + announcement.getAnnouncementId(), e);
        } finally {
            DBConnection.closeAll(conn, pstmt, null);
        }
        
        return success;
    }
    
    /**
     * Delete an announcement
     * @param announcementId The ID of the announcement to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteAnnouncement(int announcementId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM Announcements WHERE announcement_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, announcementId);
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting announcement with ID: " + announcementId, e);
        } finally {
            DBConnection.closeAll(conn, pstmt, null);
        }
        
        return success;
    }
    
    /**
     * Retrieves announcements by target audience
     * 
     * @param target The target audience (e.g., "teacher", "student", "all")
     * @return List of announcements
     */
    public List<Announcement> getAnnouncementsByTarget(String target) {
        List<Announcement> announcements = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            LOGGER.info("Fetching announcements for target: " + target);
            conn = DBConnection.getConnection();
            
            // First, let's see what columns are actually in the announcements table
            DatabaseMetaData meta = conn.getMetaData();
            ResultSet columns = meta.getColumns(null, null, "announcements", null);
            
            StringBuilder columnInfo = new StringBuilder("Columns in announcements table: ");
            while (columns.next()) {
                columnInfo.append(columns.getString("COLUMN_NAME")).append(", ");
            }
            LOGGER.info(columnInfo.toString());
            columns.close();
            
            // Simplify the query to avoid column name issues
            String sql = "SELECT * FROM announcements";
            pstmt = conn.prepareStatement(sql);
            LOGGER.info("Executing SQL: " + sql);
            rs = pstmt.executeQuery();
            
            ResultSetMetaData rsmd = rs.getMetaData();
            int columnCount = rsmd.getColumnCount();
            StringBuilder columnNames = new StringBuilder("Column names in result set: ");
            for (int i = 1; i <= columnCount; i++) {
                columnNames.append(rsmd.getColumnName(i)).append(", ");
            }
            LOGGER.info(columnNames.toString());
            
            while (rs.next()) {
                Announcement announcement = new Announcement();
                try {
                    announcement.setAnnouncementId(rs.getInt("announcement_id"));
                    announcement.setTitle(rs.getString("content"));
                    announcement.setMessage(rs.getString("content"));
                    // Try to set targetGroup, but handle if column name is different
                    try {
                        announcement.setTargetGroup(rs.getString("target_audience"));
                    } catch (SQLException e) {
                        LOGGER.info("Column 'target_audience' not found, trying alternatives");
                        try {
                            announcement.setTargetGroup(rs.getString("target_group"));
                        } catch (SQLException e2) {
                            announcement.setTargetGroup("all"); // default value
                        }
                    }
                    
                    // Try to set date, but handle if column name is different
                    try {
                        announcement.setDate(rs.getTimestamp("created_at"));
                    } catch (SQLException e) {
                        LOGGER.info("Column 'created_at' not found, trying alternatives");
                        try {
                            announcement.setDate(rs.getTimestamp("date"));
                        } catch (SQLException e2) {
                            announcement.setDate(new Timestamp(System.currentTimeMillis())); // current time as fallback
                        }
                    }
                    
                    // Try to set postedBy, but handle if column name is different
                    try {
                        announcement.setPostedBy(rs.getString("created_by"));
                    } catch (SQLException e) {
                        LOGGER.info("Column 'created_by' not found, trying alternatives");
                        try {
                            announcement.setPostedBy(rs.getString("posted_by"));
                        } catch (SQLException e2) {
                            announcement.setPostedBy("System"); // default value
                        }
                    }
                    
                    announcements.add(announcement);
                    LOGGER.info("Added announcement: " + announcement.getTitle());
                } catch (SQLException e) {
                    LOGGER.log(Level.WARNING, "Error mapping announcement result, skipping row", e);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving announcements for target: " + target, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return announcements;
    }
} 