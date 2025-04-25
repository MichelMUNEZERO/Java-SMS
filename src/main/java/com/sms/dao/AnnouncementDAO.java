package com.sms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
            String sql = "SELECT * FROM Announcement ORDER BY date DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Announcement announcement = new Announcement();
                announcement.setAnnouncementId(rs.getInt("announcement_id"));
                announcement.setTitle(rs.getString("title"));
                announcement.setMessage(rs.getString("message"));
                announcement.setDate(rs.getTimestamp("date"));
                announcement.setPostedBy(rs.getString("posted_by"));
                announcement.setTargetGroup(rs.getString("target_group"));
                
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
            String sql = "SELECT * FROM Announcement ORDER BY date DESC LIMIT ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Announcement announcement = new Announcement();
                announcement.setAnnouncementId(rs.getInt("announcement_id"));
                announcement.setTitle(rs.getString("title"));
                announcement.setMessage(rs.getString("message"));
                announcement.setDate(rs.getTimestamp("date"));
                announcement.setPostedBy(rs.getString("posted_by"));
                announcement.setTargetGroup(rs.getString("target_group"));
                
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
            String sql = "SELECT * FROM Announcement WHERE target_group = ? ORDER BY date DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, targetGroup);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Announcement announcement = new Announcement();
                announcement.setAnnouncementId(rs.getInt("announcement_id"));
                announcement.setTitle(rs.getString("title"));
                announcement.setMessage(rs.getString("message"));
                announcement.setDate(rs.getTimestamp("date"));
                announcement.setPostedBy(rs.getString("posted_by"));
                announcement.setTargetGroup(rs.getString("target_group"));
                
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
            String sql = "SELECT * FROM Announcement WHERE announcement_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, announcementId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                announcement = new Announcement();
                announcement.setAnnouncementId(rs.getInt("announcement_id"));
                announcement.setTitle(rs.getString("title"));
                announcement.setMessage(rs.getString("message"));
                announcement.setDate(rs.getTimestamp("date"));
                announcement.setPostedBy(rs.getString("posted_by"));
                announcement.setTargetGroup(rs.getString("target_group"));
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
            String sql = "INSERT INTO Announcement (title, message, date, posted_by, target_group) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, announcement.getTitle());
            pstmt.setString(2, announcement.getMessage());
            pstmt.setTimestamp(3, announcement.getDate());
            pstmt.setString(4, announcement.getPostedBy());
            pstmt.setString(5, announcement.getTargetGroup());
            
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
            String sql = "UPDATE Announcement SET title = ?, message = ?, target_group = ? WHERE announcement_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, announcement.getTitle());
            pstmt.setString(2, announcement.getMessage());
            pstmt.setString(3, announcement.getTargetGroup());
            pstmt.setInt(4, announcement.getAnnouncementId());
            
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
            String sql = "DELETE FROM Announcement WHERE announcement_id = ?";
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
} 