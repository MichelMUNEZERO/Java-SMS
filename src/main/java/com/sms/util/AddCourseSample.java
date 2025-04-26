package com.sms.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Utility class to add sample courses to the database
 */
public class AddCourseSample {
    
    public static void main(String[] args) {
        // Add sample courses to the database
        addSampleCourses();
    }
    
    /**
     * Add sample courses to the database
     */
    private static void addSampleCourses() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // First, make sure we're using transactions
            conn.setAutoCommit(false);
            
            // Define sample courses
            String[] courseNames = {
                "Introduction to Programming", 
                "Advanced Mathematics", 
                "Physics I", 
                "English Literature"
            };
            
            String[] courseCodes = {
                "CS101", 
                "MATH202", 
                "PHYS101", 
                "ENG110"
            };
            
            String[] courseDescriptions = {
                "Learn basic programming concepts and algorithms using Java",
                "Advanced calculus, differential equations and linear algebra",
                "Introduction to classical mechanics and thermodynamics",
                "Study of classic literature and modern writing techniques"
            };
            
            int[] credits = {3, 4, 3, 3};
            
            // Use user ID 1 as the teacher for these courses
            // Make sure this user exists and has teacher role
            int teacherId = 1;
            
            // SQL for inserting courses
            String sql = "INSERT INTO courses (course_name, course_code, description, credits, teacher_id) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            
            // Insert each course
            for (int i = 0; i < courseNames.length; i++) {
                pstmt.setString(1, courseNames[i]);
                pstmt.setString(2, courseCodes[i]);
                pstmt.setString(3, courseDescriptions[i]);
                pstmt.setInt(4, credits[i]);
                pstmt.setInt(5, teacherId);
                
                pstmt.executeUpdate();
                System.out.println("Added course: " + courseNames[i]);
            }
            
            // Commit the transaction
            conn.commit();
            System.out.println("All courses added successfully");
            
        } catch (SQLException e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                System.err.println("Error rolling back transaction: " + ex.getMessage());
            }
            System.err.println("Error adding sample courses: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
    }
} 