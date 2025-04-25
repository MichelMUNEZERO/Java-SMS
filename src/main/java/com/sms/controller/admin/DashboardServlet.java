package com.sms.controller.admin;

import java.io.IOException;
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

import com.sms.dao.AnnouncementDAO;
import com.sms.dao.AppointmentDAO;
import com.sms.dao.DashboardDAO;
import com.sms.model.Announcement;
import com.sms.model.User;

/**
 * Servlet to handle admin dashboard
 */
@WebServlet("/admin/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DashboardDAO dashboardDAO;
    private AnnouncementDAO announcementDAO;
    private AppointmentDAO appointmentDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        dashboardDAO = new DashboardDAO();
        announcementDAO = new AnnouncementDAO();
        appointmentDAO = new AppointmentDAO();
    }
    
    /**
     * Handle GET requests - show admin dashboard
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and has admin role
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            // Not logged in, redirect to login page
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"admin".equals(user.getRole().toLowerCase())) {
            // Not an admin, redirect to appropriate dashboard
            response.sendRedirect(request.getContextPath() + "/" + user.getRole().toLowerCase() + "/dashboard");
            return;
        }
        
        // Fetch real dashboard statistics from the database
        Map<String, Integer> stats = dashboardDAO.getDashboardStats();
        request.setAttribute("stats", stats);
        
        // Fetch recent activities (This could be a log table in the database)
        // For now we'll use mock data since we don't have a Log table yet
        List<String> recentActivities = new ArrayList<>();
        recentActivities.add("New student registered");
        recentActivities.add("Teacher profile updated");
        recentActivities.add("New course added");
        recentActivities.add("Grades updated for Science class");
        recentActivities.add("New announcement posted");
        
        request.setAttribute("recentActivities", recentActivities);
        
        // Fetch recent announcements
        List<Announcement> announcements = announcementDAO.getRecentAnnouncements(5);
        request.setAttribute("announcements", announcements);
        
        // Get user profile data if needed
        if (user.getUserId() > 0) {
            Map<String, Object> profileData = dashboardDAO.getUserProfile(user.getUserId());
            request.setAttribute("profileData", profileData);
        }
        
        // Forward to admin dashboard page
        request.getRequestDispatcher("/admin_dashboard.jsp").forward(request, response);
    }
    
    /**
     * Handle POST requests
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Process any form submissions from the dashboard
        String action = request.getParameter("action");
        
        if ("generateReport".equals(action)) {
            // Handle report generation
            String reportType = request.getParameter("reportType");
            Map<String, Object> filterParams = new HashMap<>();
            
            // Collect filter parameters based on report type
            if ("marks".equals(reportType)) {
                if (request.getParameter("courseId") != null && !request.getParameter("courseId").isEmpty()) {
                    filterParams.put("courseId", Integer.parseInt(request.getParameter("courseId")));
                }
                if (request.getParameter("studentId") != null && !request.getParameter("studentId").isEmpty()) {
                    filterParams.put("studentId", Integer.parseInt(request.getParameter("studentId")));
                }
                if (request.getParameter("gradeThreshold") != null && !request.getParameter("gradeThreshold").isEmpty()) {
                    filterParams.put("gradeThreshold", Double.parseDouble(request.getParameter("gradeThreshold")));
                }
            } else if ("behavior".equals(reportType)) {
                if (request.getParameter("studentId") != null && !request.getParameter("studentId").isEmpty()) {
                    filterParams.put("studentId", Integer.parseInt(request.getParameter("studentId")));
                }
                if (request.getParameter("behaviorType") != null && !request.getParameter("behaviorType").isEmpty()) {
                    filterParams.put("behaviorType", request.getParameter("behaviorType"));
                }
                if (request.getParameter("startDate") != null && !request.getParameter("startDate").isEmpty()) {
                    filterParams.put("startDate", request.getParameter("startDate"));
                }
                if (request.getParameter("endDate") != null && !request.getParameter("endDate").isEmpty()) {
                    filterParams.put("endDate", request.getParameter("endDate"));
                }
            } else if ("attendance".equals(reportType)) {
                if (request.getParameter("courseId") != null && !request.getParameter("courseId").isEmpty()) {
                    filterParams.put("courseId", Integer.parseInt(request.getParameter("courseId")));
                }
                if (request.getParameter("studentId") != null && !request.getParameter("studentId").isEmpty()) {
                    filterParams.put("studentId", Integer.parseInt(request.getParameter("studentId")));
                }
                if (request.getParameter("status") != null && !request.getParameter("status").isEmpty()) {
                    filterParams.put("status", request.getParameter("status"));
                }
                if (request.getParameter("startDate") != null && !request.getParameter("startDate").isEmpty()) {
                    filterParams.put("startDate", request.getParameter("startDate"));
                }
                if (request.getParameter("endDate") != null && !request.getParameter("endDate").isEmpty()) {
                    filterParams.put("endDate", request.getParameter("endDate"));
                }
            }
            
            // Generate the report
            Map<String, Object> reportData = dashboardDAO.getReportData(reportType, filterParams);
            request.setAttribute("reportData", reportData);
            
            // Reload dashboard with report data
            doGet(request, response);
        } else {
            // Default to GET if no specific action
            doGet(request, response);
        }
    }
} 