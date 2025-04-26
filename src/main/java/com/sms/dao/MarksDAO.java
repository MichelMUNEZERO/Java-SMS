package com.sms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.sms.util.DBConnection;

/**
 * Data Access Object for Mark-related database operations
 */
public class MarksDAO {
    private static final Logger LOGGER = Logger.getLogger(MarksDAO.class.getName());
    
    /**
     * Updates an existing mark or inserts a new one if it doesn't exist
     * 
     * @param studentId The student ID
     * @param courseId The course ID
     * @param mark The mark value
     * @param grade The grade (e.g., A, B, C, etc.)
     * @return true if operation was successful, false otherwise
     */
    public boolean updateOrInsertMark(int studentId, int courseId, float mark, String grade) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean success = false;
        
        try {
            LOGGER.info("Updating mark for student ID: " + studentId + ", course ID: " + courseId);
            conn = DBConnection.getConnection();
            
            // First check if the mark already exists
            String checkSql = "SELECT COUNT(*) FROM marks WHERE student_id = ? AND course_id = ?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setInt(1, studentId);
            pstmt.setInt(2, courseId);
            rs = pstmt.executeQuery();
            
            boolean exists = false;
            if (rs.next()) {
                exists = rs.getInt(1) > 0;
            }
            
            // Close the previous resources
            rs.close();
            pstmt.close();
            
            // Update or insert the mark
            String sql;
            if (exists) {
                sql = "UPDATE marks SET mark = ?, grade = ? WHERE student_id = ? AND course_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setFloat(1, mark);
                pstmt.setString(2, grade);
                pstmt.setInt(3, studentId);
                pstmt.setInt(4, courseId);
            } else {
                sql = "INSERT INTO marks (student_id, course_id, mark, grade) VALUES (?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, studentId);
                pstmt.setInt(2, courseId);
                pstmt.setFloat(3, mark);
                pstmt.setString(4, grade);
            }
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
            
            LOGGER.info("Mark " + (exists ? "update" : "insert") + " " + (success ? "successful" : "failed") + 
                       " for student ID: " + studentId + ", course ID: " + courseId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating mark for student ID: " + studentId + ", course ID: " + courseId, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return success;
    }
} 