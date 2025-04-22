package com.sms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.sms.model.Student;
import com.sms.util.DBConnection;

/**
 * Data Access Object for student course enrollments
 */
public class EnrollmentDAO {
    private Connection connection;
    private StudentDAO studentDAO;
    
    /**
     * Constructor
     */
    public EnrollmentDAO() {
        try {
            connection = DBConnection.getConnection();
            studentDAO = new StudentDAO();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Enroll a student in a course
     * 
     * @param studentId the student ID
     * @param courseId the course ID
     * @return true if enrollment was successful, false otherwise
     */
    public boolean enrollStudent(int studentId, int courseId) {
        String sql = "INSERT INTO student_courses (student_id, course_id) VALUES (?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, courseId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Unenroll a student from a course
     * 
     * @param studentId the student ID
     * @param courseId the course ID
     * @return true if unenrollment was successful, false otherwise
     */
    public boolean unenrollStudent(int studentId, int courseId) {
        String sql = "DELETE FROM student_courses WHERE student_id = ? AND course_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, courseId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Check if a student is enrolled in a course
     * 
     * @param studentId the student ID
     * @param courseId the course ID
     * @return true if the student is enrolled in the course, false otherwise
     */
    public boolean isStudentEnrolled(int studentId, int courseId) {
        String sql = "SELECT * FROM student_courses WHERE student_id = ? AND course_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, courseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get all students enrolled in a course
     * 
     * @param courseId the course ID
     * @return a list of enrolled students
     */
    public List<Student> getEnrolledStudents(int courseId) {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT student_id FROM student_courses WHERE course_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int studentId = rs.getInt("student_id");
                    Student student = studentDAO.getStudentById(studentId);
                    if (student != null) {
                        students.add(student);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return students;
    }
    
    /**
     * Get all course IDs a student is enrolled in
     * 
     * @param studentId the student ID
     * @return a list of course IDs
     */
    public List<Integer> getEnrolledCourseIds(int studentId) {
        List<Integer> courseIds = new ArrayList<>();
        String sql = "SELECT course_id FROM student_courses WHERE student_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    courseIds.add(rs.getInt("course_id"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return courseIds;
    }
    
    /**
     * Get count of students enrolled in a course
     * 
     * @param courseId the course ID
     * @return the number of enrolled students
     */
    public int getEnrolledStudentCount(int courseId) {
        String sql = "SELECT COUNT(*) AS count FROM student_courses WHERE course_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
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
     * Enroll multiple students in a course
     * 
     * @param studentIds list of student IDs
     * @param courseId the course ID
     * @return the number of successful enrollments
     */
    public int enrollMultipleStudents(List<Integer> studentIds, int courseId) {
        String sql = "INSERT INTO student_courses (student_id, course_id) VALUES (?, ?)";
        int successCount = 0;
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            for (int studentId : studentIds) {
                if (!isStudentEnrolled(studentId, courseId)) {
                    stmt.setInt(1, studentId);
                    stmt.setInt(2, courseId);
                    
                    try {
                        int rowsAffected = stmt.executeUpdate();
                        if (rowsAffected > 0) {
                            successCount++;
                        }
                    } catch (SQLException e) {
                        // Continue with other students even if one fails
                        e.printStackTrace();
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return successCount;
    }
    
    /**
     * Get students not enrolled in a specific course
     * 
     * @param courseId the course ID
     * @return list of students not enrolled in the course
     */
    public List<Student> getNotEnrolledStudents(int courseId) {
        List<Student> allStudents = studentDAO.getAllStudents();
        List<Student> enrolledStudents = getEnrolledStudents(courseId);
        
        // Remove enrolled students from all students
        allStudents.removeAll(enrolledStudents);
        
        return allStudents;
    }
    
    /**
     * Close the connection when done
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