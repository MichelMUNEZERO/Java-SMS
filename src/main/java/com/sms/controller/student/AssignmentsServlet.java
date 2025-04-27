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

import com.sms.model.Student;
import com.sms.model.User;
import com.sms.util.DBConnection;

/**
 * Servlet to handle student assignments display
 */
@WebServlet("/student/assignments")
public class AssignmentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AssignmentsServlet.class.getName());
    
    /**
     * GET method to display student assignments
     */
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
        
        // Get student ID from session
        Student student = (Student) session.getAttribute("student");
        int studentId = student != null ? student.getId() : 0;
        
        if (studentId == 0) {
            // For development/testing, could use a default ID
            studentId = 1;
        }
        
        // Get pending, completed, and upcoming assignments for this student
        List<Map<String, Object>> pendingAssignments = getAssignments(studentId, "pending");
        List<Map<String, Object>> completedAssignments = getAssignments(studentId, "completed");
        List<Map<String, Object>> upcomingAssignments = getAssignments(studentId, "upcoming");
        
        request.setAttribute("pendingAssignments", pendingAssignments);
        request.setAttribute("completedAssignments", completedAssignments);
        request.setAttribute("upcomingAssignments", upcomingAssignments);
        
        // Forward to the assignments JSP
        request.getRequestDispatcher("/WEB-INF/views/student/assignments.jsp").forward(request, response);
    }
    
    /**
     * Retrieves assignments for a given student ID and status
     */
    private List<Map<String, Object>> getAssignments(int studentId, String status) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Map<String, Object>> assignmentsList = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            
            // Different queries based on assignment status
            String sql;
            if ("pending".equals(status)) {
                // Assignments that are due soon and not completed
                sql = "SELECT a.assignment_id, a.title, a.description, a.due_date, a.max_score, " +
                      "c.course_id, c.course_code, c.course_name " +
                      "FROM Assignments a " +
                      "JOIN Courses c ON a.course_id = c.course_id " +
                      "JOIN Student_Courses sc ON c.course_id = sc.course_id " +
                      "LEFT JOIN Submission s ON a.assignment_id = s.assignment_id AND s.student_id = ? " +
                      "WHERE sc.student_id = ? " +
                      "AND a.due_date > NOW() " +
                      "AND (s.status IS NULL OR s.status <> 'completed') " +
                      "ORDER BY a.due_date ASC";
            } else if ("completed".equals(status)) {
                // Assignments that the student has submitted
                sql = "SELECT a.assignment_id, a.title, a.description, a.due_date, a.max_score, " +
                      "c.course_id, c.course_code, c.course_name, s.submission_date, s.score " +
                      "FROM Assignments a " +
                      "JOIN Courses c ON a.course_id = c.course_id " +
                      "JOIN Student_Courses sc ON c.course_id = sc.course_id " +
                      "JOIN Submission s ON a.assignment_id = s.assignment_id AND s.student_id = ? " +
                      "WHERE sc.student_id = ? " +
                      "AND s.status = 'completed' " +
                      "ORDER BY s.submission_date DESC";
            } else { // upcoming
                // Assignments that are due in the future
                sql = "SELECT a.assignment_id, a.title, a.description, a.due_date, a.max_score, " +
                      "c.course_id, c.course_code, c.course_name " +
                      "FROM Assignments a " +
                      "JOIN Courses c ON a.course_id = c.course_id " +
                      "JOIN Student_Courses sc ON c.course_id = sc.course_id " +
                      "LEFT JOIN Submission s ON a.assignment_id = s.assignment_id AND s.student_id = ? " +
                      "WHERE sc.student_id = ? " +
                      "AND a.due_date > DATE_ADD(NOW(), INTERVAL 7 DAY) " +
                      "AND (s.status IS NULL OR s.status <> 'completed') " +
                      "ORDER BY a.due_date ASC";
            }
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            pstmt.setInt(2, studentId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> assignment = new HashMap<>();
                assignment.put("id", rs.getInt("assignment_id"));
                assignment.put("title", rs.getString("title"));
                assignment.put("description", rs.getString("description"));
                assignment.put("dueDate", rs.getTimestamp("due_date"));
                assignment.put("maxScore", rs.getDouble("max_score"));
                assignment.put("courseId", rs.getInt("course_id"));
                assignment.put("courseCode", rs.getString("course_code"));
                assignment.put("courseName", rs.getString("course_name"));
                
                // For completed assignments, include submission details
                if ("completed".equals(status)) {
                    assignment.put("submissionDate", rs.getTimestamp("submission_date"));
                    assignment.put("score", rs.getDouble("score"));
                    
                    // Calculate percentage score
                    double maxScore = rs.getDouble("max_score");
                    double score = rs.getDouble("score");
                    double percentage = maxScore > 0 ? (score / maxScore) * 100 : 0;
                    assignment.put("percentage", Math.round(percentage * 10.0) / 10.0); // Round to 1 decimal place
                }
                
                assignmentsList.add(assignment);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving student assignments", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return assignmentsList;
    }
} 