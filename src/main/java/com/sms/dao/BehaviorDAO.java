package com.sms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.sms.util.DBConnection;

/**
 * Data Access Object for StudentBehavior-related database operations
 */
public class BehaviorDAO {
    private static final Logger LOGGER = Logger.getLogger(BehaviorDAO.class.getName());
    
    /**
     * Get all behavior records for a specific student
     * 
     * @param studentId The student ID
     * @return List of behavior records
     */
    public List<Map<String, Object>> getBehaviorRecordsByStudentId(int studentId) {
        List<Map<String, Object>> records = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT b.*, s.first_name, s.last_name, u.username as reporter_name " +
                         "FROM studentbehavior b " +
                         "JOIN students s ON b.student_id = s.student_id " +
                         "JOIN users u ON b.reported_by = u.user_id " +
                         "WHERE b.student_id = ? " +
                         "ORDER BY b.behavior_date DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> record = new HashMap<>();
                record.put("behaviorId", rs.getInt("behavior_id"));
                record.put("studentId", rs.getInt("student_id"));
                record.put("studentName", rs.getString("first_name") + " " + rs.getString("last_name"));
                record.put("behaviorType", rs.getString("behavior_type"));
                record.put("description", rs.getString("description"));
                record.put("behaviorDate", rs.getDate("behavior_date"));
                record.put("reportedBy", rs.getInt("reported_by"));
                record.put("reporterName", rs.getString("reporter_name"));
                record.put("actionTaken", rs.getString("action_taken"));
                
                records.add(record);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting behavior records for student ID: " + studentId, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return records;
    }
    
    /**
     * Get all students who are enrolled in courses taught by a specific teacher
     * 
     * @param teacherId The teacher ID
     * @return List of students with their details
     */
    public List<Map<String, Object>> getStudentsByTeacherId(int teacherId) {
        List<Map<String, Object>> students = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT DISTINCT s.student_id, s.first_name, s.last_name, s.email, s.grade " +
                         "FROM students s " +
                         "JOIN student_courses sc ON s.student_id = sc.student_id " +
                         "JOIN courses c ON sc.course_id = c.course_id " +
                         "WHERE c.teacher_id = ? " +
                         "ORDER BY s.last_name, s.first_name";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, teacherId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> student = new HashMap<>();
                student.put("studentId", rs.getInt("student_id"));
                student.put("firstName", rs.getString("first_name"));
                student.put("lastName", rs.getString("last_name"));
                student.put("email", rs.getString("email"));
                student.put("grade", rs.getString("grade"));
                student.put("fullName", rs.getString("first_name") + " " + rs.getString("last_name"));
                
                // Get behavior statistics for this student
                Map<String, Integer> stats = getBehaviorStatsByStudentId(rs.getInt("student_id"));
                student.put("positiveCount", stats.get("positive"));
                student.put("negativeCount", stats.get("negative"));
                
                students.add(student);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting students for teacher ID: " + teacherId, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return students;
    }
    
    /**
     * Get all behavior types supported by the system
     * 
     * @return List of behavior types
     */
    public List<String> getAllBehaviorTypes() {
        // For now, return a predefined list. In a real system, this might come from the database.
        return Arrays.asList(
            "Positive - Excellent Participation",
            "Positive - Helping Others",
            "Positive - Improvement in Academics",
            "Positive - Leadership",
            "Negative - Disruptive Behavior",
            "Negative - Late Submission",
            "Negative - Missed Class",
            "Negative - Incomplete Work"
        );
    }
    
    /**
     * Add a new behavior record
     * 
     * @param studentId The student ID
     * @param reportedBy The teacher/staff ID who reported the behavior
     * @param behaviorType The type of behavior
     * @param description Description of the behavior
     * @param actionTaken Action taken (if any)
     * @return true if addition was successful, false otherwise
     */
    public boolean addBehaviorRecord(int studentId, int reportedBy, String behaviorType, 
                                   String description, String actionTaken) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO studentbehavior (student_id, behavior_type, description, " +
                         "behavior_date, reported_by, action_taken) " +
                         "VALUES (?, ?, ?, CURRENT_DATE, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            pstmt.setString(2, behaviorType);
            pstmt.setString(3, description);
            pstmt.setInt(4, reportedBy);
            pstmt.setString(5, actionTaken);
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding behavior record for student ID: " + studentId, e);
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return success;
    }
    
    /**
     * Update an existing behavior record
     * 
     * @param behaviorId The behavior record ID
     * @param behaviorType The updated behavior type
     * @param description The updated description
     * @param actionTaken The updated action taken
     * @return true if update was successful, false otherwise
     */
    public boolean updateBehaviorRecord(int behaviorId, String behaviorType, 
                                      String description, String actionTaken) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE studentbehavior SET behavior_type = ?, description = ?, " +
                         "action_taken = ? WHERE behavior_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, behaviorType);
            pstmt.setString(2, description);
            pstmt.setString(3, actionTaken);
            pstmt.setInt(4, behaviorId);
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating behavior record with ID: " + behaviorId, e);
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return success;
    }
    
    /**
     * Delete a behavior record
     * 
     * @param behaviorId The behavior record ID to delete
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteBehaviorRecord(int behaviorId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM studentbehavior WHERE behavior_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, behaviorId);
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting behavior record with ID: " + behaviorId, e);
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return success;
    }
    
    /**
     * Get summary statistics of behavior records for a student
     * 
     * @param studentId The student ID
     * @return Map containing positive and negative behavior counts
     */
    public Map<String, Integer> getBehaviorStatsByStudentId(int studentId) {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("positive", 0);
        stats.put("negative", 0);
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT behavior_type, COUNT(*) as count FROM studentbehavior " +
                         "WHERE student_id = ? GROUP BY behavior_type";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                String behaviorType = rs.getString("behavior_type");
                int count = rs.getInt("count");
                
                if (behaviorType.startsWith("Positive")) {
                    stats.put("positive", stats.get("positive") + count);
                } else if (behaviorType.startsWith("Negative")) {
                    stats.put("negative", stats.get("negative") + count);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting behavior stats for student ID: " + studentId, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return stats;
    }
} 