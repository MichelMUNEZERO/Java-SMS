package com.sms.controller.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.model.Announcement;
import com.sms.model.User;
import com.sms.util.DBConnection;

/**
 * Servlet to handle admin dashboard
 */
@WebServlet("/admin/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in and is an admin
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get dashboard statistics
        Map<String, Integer> stats = getDashboardStats();
        request.setAttribute("stats", stats);
        
        // Get recent activities
        List<String> recentActivities = getRecentActivities();
        request.setAttribute("recentActivities", recentActivities);
        
        // Get announcements
        List<Announcement> announcements = getRecentAnnouncements();
        request.setAttribute("announcements", announcements);
        
        // Forward to dashboard page
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
    
    /**
     * Get statistics for the dashboard
     * @return Map of statistics
     */
    private Map<String, Integer> getDashboardStats() {
        Map<String, Integer> stats = new HashMap<>();
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Get student count
            String sqlStudents = "SELECT COUNT(*) AS count FROM Students";
            try (PreparedStatement stmt = conn.prepareStatement(sqlStudents);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("students", rs.getInt("count"));
                }
            }
            
            // Get teacher count
            String sqlTeachers = "SELECT COUNT(*) AS count FROM Teachers";
            try (PreparedStatement stmt = conn.prepareStatement(sqlTeachers);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("teachers", rs.getInt("count"));
                }
            }
            
            // Get parent count
            String sqlParents = "SELECT COUNT(*) AS count FROM Parents";
            try (PreparedStatement stmt = conn.prepareStatement(sqlParents);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("parents", rs.getInt("count"));
                }
            }
            
            // Get course count
            String sqlCourses = "SELECT COUNT(*) AS count FROM Courses";
            try (PreparedStatement stmt = conn.prepareStatement(sqlCourses);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("courses", rs.getInt("count"));
                }
            }
            
            // Get appointment count
            String sqlAppointments = "SELECT COUNT(*) AS count FROM Appointment";
            try (PreparedStatement stmt = conn.prepareStatement(sqlAppointments);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("appointments", rs.getInt("count"));
                }
            }
            
            // Get pending appointment count
            String sqlPendingAppointments = "SELECT COUNT(*) AS count FROM Appointment WHERE Status = 'Scheduled'";
            try (PreparedStatement stmt = conn.prepareStatement(sqlPendingAppointments);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("pendingAppointments", rs.getInt("count"));
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        
        return stats;
    }
    
    /**
     * Get recent activities for the dashboard
     * @return List of activity descriptions
     */
    private List<String> getRecentActivities() {
        List<String> activities = new ArrayList<>();
        
        // For now, return dummy data
        // In a real implementation, you would fetch from an activity log table
        activities.add("New student registered");
        activities.add("Teacher profile updated");
        activities.add("New course added");
        activities.add("Grades updated for Science class");
        activities.add("New announcement posted");
        
        return activities;
    }
    
    /**
     * Get recent announcements
     * @return List of Announcement objects
     */
    private List<Announcement> getRecentAnnouncements() {
        List<Announcement> announcements = new ArrayList<>();
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Announcement ORDER BY Date DESC LIMIT 5";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                
                while (rs.next()) {
                    Announcement announcement = new Announcement();
                    announcement.setAnnouncementId(rs.getInt("AnnouncementId"));
                    announcement.setMessage(rs.getString("Message"));
                    announcement.setDate(rs.getTimestamp("Date"));
                    announcement.setTargetGroup(rs.getString("TargetGroup"));
                    
                    announcements.add(announcement);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        
        return announcements;
    }
} 