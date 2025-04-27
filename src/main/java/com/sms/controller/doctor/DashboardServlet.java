package com.sms.controller.doctor;

import java.io.IOException;
import java.util.ArrayList;
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
 * Servlet to handle doctor dashboard
 */
@WebServlet("/doctor/dashboard")
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
     * Handle GET requests - show doctor dashboard
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"doctor".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get recent announcements
            List<Announcement> announcements = announcementDAO.getRecentAnnouncements(5);
            request.setAttribute("announcements", announcements);
            
            // Get today's appointment count (instead of specific doctor appointments)
            int todayAppointments = appointmentDAO.countTodayAppointments();
            request.setAttribute("todayAppointments", todayAppointments);
            
            // Forward to doctor dashboard page
            request.getRequestDispatcher("/doctor_dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading doctor dashboard: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 