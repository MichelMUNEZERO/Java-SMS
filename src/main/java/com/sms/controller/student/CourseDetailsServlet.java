package com.sms.controller.student;

import java.io.IOException;
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

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.model.Course;
import com.sms.model.Student;
import com.sms.model.User;
import com.sms.util.DBConnection;

/**
 * Servlet to handle student course details
 */
@WebServlet("/student/course-details")
public class CourseDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(CourseDetailsServlet.class.getName());
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in and has student role
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"student".equals(user.getRole().toLowerCase())) {
            response.sendRedirect(request.getContextPath() + "/" + user.getRole().toLowerCase() + "/dashboard");
            return;
        }
        
        // Get course ID from request
        String courseIdStr = request.getParameter("id");
        if (courseIdStr == null || courseIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student/courses");
            return;
        }
        
        try {
            int courseId = Integer.parseInt(courseIdStr);
            
            // Get student ID from session
            Student student = (Student) session.getAttribute("student");
            int studentId = student != null ? student.getId() : 0;
            
            if (studentId == 0) {
                // Get student ID from user ID
                studentId = getStudentIdFromUserId(user.getUserId());
            }
            
            // Get course details
            Map<String, Object> courseDetails = getCourseDetails(courseId, studentId);
            
            if (courseDetails == null || courseDetails.isEmpty()) {
                request.setAttribute("errorMessage", "Course not found or you are not enrolled in this course.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // Get assignments for this course
            List<Map<String, Object>> assignments = getCourseAssignments(courseId);
            
            // Get student's marks for this course
            Map<String, Object> marks = getStudentMarks(courseId, studentId);
            
            // Set attributes for the JSP
            request.setAttribute("courseDetails", courseDetails);
            request.setAttribute("assignments", assignments);
            request.setAttribute("marks", marks);
            
            // Forward to course details page
            request.getRequestDispatcher("/WEB-INF/views/student/course-details.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid course ID format: " + courseIdStr);
            request.setAttribute("errorMessage", "Invalid course ID format.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error loading course details", e);
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    private int getStudentIdFromUserId(int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT student_id FROM students WHERE user_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("student_id");
            }
            return 0;
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
    }
    
    private Map<String, Object> getCourseDetails(int courseId, int studentId) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT c.*, t.first_name as teacher_first_name, t.last_name as teacher_last_name " +
                        "FROM courses c " +
                        "JOIN student_courses sc ON c.course_id = sc.course_id " +
                        "JOIN teachers t ON c.teacher_id = t.teacher_id " +
                        "WHERE c.course_id = ? AND sc.student_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, courseId);
            pstmt.setInt(2, studentId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Map<String, Object> courseDetails = new HashMap<>();
                courseDetails.put("courseId", rs.getInt("course_id"));
                courseDetails.put("courseCode", rs.getString("course_code"));
                courseDetails.put("courseName", rs.getString("course_name"));
                courseDetails.put("description", rs.getString("description"));
                courseDetails.put("credits", rs.getInt("credits"));
                courseDetails.put("teacherName", rs.getString("teacher_first_name") + " " + rs.getString("teacher_last_name"));
                return courseDetails;
            }
            return null;
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
    }
    
    private List<Map<String, Object>> getCourseAssignments(int courseId) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Map<String, Object>> assignments = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM assignments WHERE course_id = ? ORDER BY due_date ASC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, courseId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> assignment = new HashMap<>();
                assignment.put("id", rs.getInt("assignment_id"));
                assignment.put("title", rs.getString("title"));
                assignment.put("description", rs.getString("description"));
                assignment.put("dueDate", rs.getTimestamp("due_date"));
                assignment.put("maxScore", rs.getDouble("max_score"));
                assignments.add(assignment);
            }
            return assignments;
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
    }
    
    private Map<String, Object> getStudentMarks(int courseId, int studentId) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM marks WHERE course_id = ? AND student_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, courseId);
            pstmt.setInt(2, studentId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Map<String, Object> marks = new HashMap<>();
                marks.put("midterm", rs.getDouble("midterm"));
                marks.put("final", rs.getDouble("final"));
                marks.put("assignments", rs.getDouble("assignments"));
                marks.put("total", rs.getDouble("total"));
                marks.put("grade", rs.getString("grade"));
                return marks;
            }
            return new HashMap<>();
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
    }
} 