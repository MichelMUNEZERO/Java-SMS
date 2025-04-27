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
 * Servlet to handle student dashboard
 */
@WebServlet("/student/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(DashboardServlet.class.getName());
    
    /**
     * Handle GET requests - show student dashboard
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and has student role
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            // Not logged in, redirect to login page
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"student".equals(user.getRole().toLowerCase())) {
            // Not a student, redirect to appropriate dashboard
            response.sendRedirect(request.getContextPath() + "/" + user.getRole().toLowerCase() + "/dashboard");
            return;
        }
        
        // Get student ID from session
        Student student = (Student) session.getAttribute("student");
        int studentId = student != null ? student.getId() : 0;
        
        if (studentId == 0) {
            // For development/testing, could use a default ID
            studentId = 1; // Using a test student ID
        }
        
        // Fetch dashboard data
        try {
            // Get course count
            int courseCount = getStudentCoursesCount(studentId);
            request.setAttribute("courseCount", courseCount);
            
            // Get attendance 
            int attendancePercentage = getStudentAttendancePercentage(studentId);
            request.setAttribute("attendancePercentage", attendancePercentage);
            
            // Get a count of marks entries as a proxy for assignments
            int assignmentsCount = getStudentMarksCount(studentId);
            request.setAttribute("assignmentsCount", assignmentsCount);
            
            // Use a fixed value for today's classes for now
            request.setAttribute("todayClassesCount", 4);
            
            // Get announcements 
            List<Map<String, Object>> announcements = getAnnouncements();
            request.setAttribute("announcements", announcements);
            
            // Set pending assignments and upcoming tests count
            request.setAttribute("pendingAssignmentsCount", 3);
            request.setAttribute("upcomingTestsCount", 2);
            
        } catch (Exception e) {
            request.setAttribute("error", "Error loading dashboard data: " + e.getMessage());
            e.printStackTrace();
        }
        
        // Forward to student dashboard page
        request.getRequestDispatcher("/student_dashboard.jsp").forward(request, response);
    }
    
    /**
     * Get student courses count
     */
    private int getStudentCoursesCount(int studentId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) FROM Student_Courses WHERE student_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting student courses count", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return count;
    }
    
    /**
     * Get student attendance percentage
     */
    private int getStudentAttendancePercentage(int studentId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int attendancePercentage = 0;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) AS total, SUM(CASE WHEN attendance_status = 'Present' THEN 1 ELSE 0 END) AS present " +
                         "FROM StudentTracking WHERE student_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                int total = rs.getInt("total");
                int present = rs.getInt("present");
                
                if (total > 0) {
                    attendancePercentage = (present * 100) / total;
                } else {
                    attendancePercentage = 96; // Default to 96% if no records
                }
            } else {
                attendancePercentage = 96; // Default value
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting student attendance percentage", e);
            attendancePercentage = 96; // Default on error
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return attendancePercentage;
    }
    
    /**
     * Get student marks count as proxy for assignments
     */
    private int getStudentMarksCount(int studentId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) FROM Marks WHERE student_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
            
            if (count == 0) {
                count = 12; // Default value
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting student marks count", e);
            count = 12; // Default value on error
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return count;
    }
    
    /**
     * Get announcements
     */
    private List<Map<String, Object>> getAnnouncements() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Map<String, Object>> announcements = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT announcement_id, content, created_at " +
                         "FROM Announcements " +
                         "WHERE target_audience IN ('All', 'Students') " +
                         "ORDER BY created_at DESC LIMIT 4";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> announcement = new HashMap<>();
                announcement.put("id", rs.getInt("announcement_id"));
                announcement.put("content", rs.getString("content"));
                announcement.put("createdAt", rs.getTimestamp("created_at"));
                announcements.add(announcement);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting announcements", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return announcements;
    }
    
    /**
     * Handle POST requests
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Process any form submissions from the dashboard
        doGet(request, response);
    }
} 