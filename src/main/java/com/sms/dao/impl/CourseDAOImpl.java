package com.sms.dao.impl;

import com.sms.dao.CourseDAO;
import com.sms.model.Course;
import com.sms.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CourseDAOImpl implements CourseDAO {
    
    private static final Logger LOGGER = Logger.getLogger(CourseDAOImpl.class.getName());
    
    @Override
    public int createCourse(Course course) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int generatedId = -1;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO courses (course_name, course_code, description, teacher_id, credits) " +
                         "VALUES (?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, course.getCourseName());
            pstmt.setString(2, course.getCourseCode());
            pstmt.setString(3, course.getDescription());
            pstmt.setInt(4, course.getTeacherId());
            pstmt.setInt(5, course.getCredits());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating course", e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return generatedId;
    }
    
    @Override
    public Course getCourseById(int id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Course course = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT c.*, t.name as teacher_name " +
                         "FROM courses c " +
                         "LEFT JOIN teachers t ON c.teacher_id = t.teacher_id " +
                         "WHERE c.course_id = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                course = extractCourseFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving course with ID: " + id, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return course;
    }
    
    @Override
    public List<Course> getAllCourses() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Course> courses = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT c.*, t.name as teacher_name " +
                         "FROM courses c " +
                         "LEFT JOIN teachers t ON c.teacher_id = t.teacher_id " +
                         "ORDER BY c.course_name";
            
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                courses.add(extractCourseFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving all courses", e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return courses;
    }
    
    @Override
    public List<Course> getCoursesByTeacherId(int teacherId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Course> courses = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT c.*, t.name as teacher_name " +
                         "FROM courses c " +
                         "LEFT JOIN teachers t ON c.teacher_id = t.teacher_id " +
                         "WHERE c.teacher_id = ? " +
                         "ORDER BY c.course_name";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, teacherId);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                courses.add(extractCourseFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving courses for teacher ID: " + teacherId, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return courses;
    }
    
    @Override
    public boolean updateCourse(Course course) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE courses SET course_name = ?, course_code = ?, description = ?, " +
                         "teacher_id = ?, credits = ? WHERE course_id = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, course.getCourseName());
            pstmt.setString(2, course.getCourseCode());
            pstmt.setString(3, course.getDescription());
            pstmt.setInt(4, course.getTeacherId());
            pstmt.setInt(5, course.getCredits());
            pstmt.setInt(6, course.getId());
            
            int affectedRows = pstmt.executeUpdate();
            success = affectedRows > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating course with ID: " + course.getId(), e);
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
    
    @Override
    public boolean deleteCourse(int courseId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM courses WHERE course_id = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, courseId);
            
            int rowsAffected = pstmt.executeUpdate();
            success = rowsAffected > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting course with ID: " + courseId, e);
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
    
    private Course extractCourseFromResultSet(ResultSet rs) throws SQLException {
        Course course = new Course();
        course.setId(rs.getInt("course_id"));
        course.setCourseName(rs.getString("course_name"));
        course.setCourseCode(rs.getString("course_code"));
        course.setDescription(rs.getString("description"));
        course.setCredits(rs.getInt("credits"));
        course.setTeacherId(rs.getInt("teacher_id"));
        
        // Set teacher name if available (from JOIN)
        try {
            course.setTeacherName(rs.getString("teacher_name"));
        } catch (SQLException e) {
            // Column not available, ignore
        }
        
        return course;
    }
}