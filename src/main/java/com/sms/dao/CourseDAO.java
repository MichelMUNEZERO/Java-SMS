package com.sms.dao;

import com.sms.model.Course;
import com.sms.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Course entity
 */
public class CourseDAO {
    private Connection connection;

    public CourseDAO() {
        this.connection = DBConnection.getConnection();
    }

    /**
     * Extract Course object from ResultSet
     */
    private Course extractCourseFromResultSet(ResultSet rs) throws SQLException {
        Course course = new Course();
        course.setCourseId(rs.getInt("CourseId"));
        course.setCourseName(rs.getString("CourseName"));
        course.setDescription(rs.getString("Description"));
        course.setTeacherId(rs.getInt("TeacherId"));
        return course;
    }

    /**
     * Get course by ID
     */
    public Course getCourseById(int courseId) {
        try (PreparedStatement stmt = connection.prepareStatement(
                "SELECT * FROM Courses WHERE CourseId = ?")) {
            stmt.setInt(1, courseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractCourseFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get course by name
     */
    public Course getCourseByName(String courseName) {
        try (PreparedStatement stmt = connection.prepareStatement(
                "SELECT * FROM Courses WHERE CourseName = ?")) {
            stmt.setString(1, courseName);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractCourseFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all courses
     */
    public List<Course> getAllCourses() {
        List<Course> courses = new ArrayList<>();
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM Courses")) {
            
            while (rs.next()) {
                courses.add(extractCourseFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return courses;
    }

    /**
     * Get courses by teacher ID
     */
    public List<Course> getCoursesByTeacherId(int teacherId) {
        List<Course> courses = new ArrayList<>();
        
        try (PreparedStatement stmt = connection.prepareStatement(
                "SELECT * FROM Courses WHERE TeacherId = ?")) {
            stmt.setInt(1, teacherId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    courses.add(extractCourseFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return courses;
    }

    /**
     * Search courses by name or description
     */
    public List<Course> searchCourses(String searchTerm) {
        List<Course> courses = new ArrayList<>();
        String searchQuery = "%" + searchTerm + "%";
        
        try (PreparedStatement stmt = connection.prepareStatement(
                "SELECT * FROM Courses WHERE CourseName LIKE ? OR Description LIKE ?")) {
            stmt.setString(1, searchQuery);
            stmt.setString(2, searchQuery);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    courses.add(extractCourseFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return courses;
    }

    /**
     * Add a new course
     */
    public int addCourse(Course course) {
        try (PreparedStatement stmt = connection.prepareStatement(
                "INSERT INTO Courses (CourseName, Description, TeacherId) VALUES (?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, course.getCourseName());
            stmt.setString(2, course.getDescription());
            stmt.setInt(3, course.getTeacherId());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                return -1;
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return -1;
    }

    /**
     * Update an existing course
     */
    public boolean updateCourse(Course course) {
        try (PreparedStatement stmt = connection.prepareStatement(
                "UPDATE Courses SET CourseName = ?, Description = ?, TeacherId = ? WHERE CourseId = ?")) {
            
            stmt.setString(1, course.getCourseName());
            stmt.setString(2, course.getDescription());
            stmt.setInt(3, course.getTeacherId());
            stmt.setInt(4, course.getCourseId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete a course
     */
    public boolean deleteCourse(int courseId) {
        try (PreparedStatement stmt = connection.prepareStatement(
                "DELETE FROM Courses WHERE CourseId = ?")) {
            
            stmt.setInt(1, courseId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get number of students enrolled in a course
     */
    public int getStudentsCountByCourseId(int courseId) {
        try (PreparedStatement stmt = connection.prepareStatement(
                "SELECT COUNT(*) as count FROM student_courses WHERE course_id = ?")) {
            stmt.setInt(1, courseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Close the database connection when done
     */
    public void close() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
} 