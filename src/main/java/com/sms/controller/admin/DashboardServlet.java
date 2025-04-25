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

import com.sms.model.User;

/**
 * Servlet to handle admin dashboard
 */
@WebServlet("/admin/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
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
        
        // Add mock data for testing
        Map<String, Integer> stats = new HashMap<>();
        stats.put("students", 150);
        stats.put("teachers", 25);
        stats.put("parents", 200);
        stats.put("courses", 45);
        request.setAttribute("stats", stats);
        
        List<String> recentActivities = new ArrayList<>();
        recentActivities.add("New student registered");
        recentActivities.add("Teacher profile updated");
        recentActivities.add("New course added");
        recentActivities.add("Grades updated for Science class");
        recentActivities.add("New announcement posted");
        request.setAttribute("recentActivities", recentActivities);
        
        // Forward to admin dashboard page
        request.getRequestDispatcher("/admin_dashboard.jsp").forward(request, response);
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