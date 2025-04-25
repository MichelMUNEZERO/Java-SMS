package com.sms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.sms.util.DBConnection;

/**
 * Data Access Object for Appointment-related database operations
 */
public class AppointmentDAO {
    private static final Logger LOGGER = Logger.getLogger(AppointmentDAO.class.getName());
    
    /**
     * Count appointments scheduled for today
     * @return Number of appointments today
     */
    public int countTodayAppointments() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) FROM Appointment WHERE Date = CURDATE()";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting today's appointments", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return count;
    }
    
    /**
     * Count upcoming appointments within a date range
     * @param startDate Start date for range
     * @param endDate End date for range
     * @return Number of appointments in range
     */
    public int countAppointmentsInRange(Date startDate, Date endDate) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) FROM Appointment WHERE Date BETWEEN ? AND ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setDate(1, startDate);
            pstmt.setDate(2, endDate);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting appointments in range", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return count;
    }
    
    /**
     * Count total appointments in the system
     * @return Total number of appointments
     */
    public int countTotalAppointments() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) FROM Appointment";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting total appointments", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return count;
    }
} 