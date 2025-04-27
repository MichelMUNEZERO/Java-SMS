package com.sms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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

    /**
     * Get marks for a student by courses
     * @param studentId The ID of the student
     * @return List of maps containing course marks
     */
    public List<Map<String, Object>> getStudentMarksByCourses(int studentId) {
        List<Map<String, Object>> courseMarks = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT m.*, c.course_name, c.course_code, e.exam_name, " +
                         "t.first_name as teacher_first_name, t.last_name as teacher_last_name " +
                         "FROM Marks m " +
                         "JOIN Courses c ON m.course_id = c.course_id " +
                         "JOIN Exams e ON m.exam_id = e.exam_id " +
                         "JOIN Teachers t ON c.teacher_id = t.teacher_id " +
                         "WHERE m.student_id = ? " +
                         "ORDER BY c.course_name, e.exam_date DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            
            Map<Integer, Map<String, Object>> courseSummary = new HashMap<>();
            
            while (rs.next()) {
                int courseId = rs.getInt("course_id");
                
                // Create course summary if it doesn't exist
                if (!courseSummary.containsKey(courseId)) {
                    Map<String, Object> course = new HashMap<>();
                    course.put("courseId", courseId);
                    course.put("courseName", rs.getString("course_name"));
                    course.put("courseCode", rs.getString("course_code"));
                    course.put("teacherName", rs.getString("teacher_first_name") + " " + rs.getString("teacher_last_name"));
                    course.put("marks", new ArrayList<Map<String, Object>>());
                    course.put("totalMarks", 0);
                    course.put("examCount", 0);
                    courseSummary.put(courseId, course);
                }
                
                // Add mark to course
                Map<String, Object> course = courseSummary.get(courseId);
                List<Map<String, Object>> marks = (List<Map<String, Object>>) course.get("marks");
                
                Map<String, Object> mark = new HashMap<>();
                mark.put("examId", rs.getInt("exam_id"));
                mark.put("examName", rs.getString("exam_name"));
                mark.put("marks", rs.getDouble("marks"));
                mark.put("grade", rs.getString("grade"));
                mark.put("comments", rs.getString("comments"));
                
                marks.add(mark);
                
                // Update totals
                course.put("totalMarks", (double) course.get("totalMarks") + rs.getDouble("marks"));
                course.put("examCount", (int) course.get("examCount") + 1);
            }
            
            // Calculate averages and add to result list
            for (Map<String, Object> course : courseSummary.values()) {
                double totalMarks = (double) course.get("totalMarks");
                int examCount = (int) course.get("examCount");
                
                if (examCount > 0) {
                    double average = totalMarks / examCount;
                    course.put("average", average);
                    
                    // Determine grade based on average
                    String grade = "F";
                    if (average >= 90) grade = "A";
                    else if (average >= 80) grade = "B";
                    else if (average >= 70) grade = "C";
                    else if (average >= 60) grade = "D";
                    
                    course.put("grade", grade);
                }
                
                courseMarks.add(course);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting marks for student ID: " + studentId, e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return courseMarks;
    }
} 