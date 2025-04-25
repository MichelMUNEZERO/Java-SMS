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
            String sql = "SELECT * FROM Announcements ORDER BY created_at DESC";
            pstmt = conn.prepareStatement(sql);
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
            String sql = "SELECT * FROM Announcements WHERE announcement_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, announcementId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                announcement = new Announcement();
                announcement.setAnnouncementId(rs.getInt("announcement_id"));
                announcement.setTitle(rs.getString("content"));
                announcement.setMessage(rs.getString("content"));
                announcement.setDate(rs.getTimestamp("created_at"));
                announcement.setPostedBy(rs.getString("created_by"));
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
            pstmt.setString(1, announcement.getMessage());
            pstmt.setTimestamp(2, announcement.getDate());
            pstmt.setString(3, announcement.getTargetGroup());
            pstmt.setString(4, announcement.getPostedBy());
            
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
            pstmt.setString(1, announcement.getMessage());
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
} 