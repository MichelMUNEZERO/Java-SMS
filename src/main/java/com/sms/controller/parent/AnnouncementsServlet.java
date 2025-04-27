package com.sms.controller.parent;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.dao.AnnouncementDAO;
import com.sms.model.Announcement;
import com.sms.model.User;

/**
 * Servlet to handle announcements for parents
 */
@WebServlet("/parent/announcements")
public class AnnouncementsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private AnnouncementDAO announcementDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        announcementDAO = new AnnouncementDAO();
    }
    
    /**
     * Handle GET requests - show announcements
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and has parent role
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            // Not logged in, redirect to login page
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"parent".equals(user.getRole().toLowerCase())) {
            // Not a parent, redirect to appropriate dashboard
            response.sendRedirect(request.getContextPath() + "/" + user.getRole().toLowerCase() + "/dashboard");
            return;
        }
        
        try {
            // Get all announcements targeted to parents or all
            List<Announcement> announcements = announcementDAO.getAnnouncementsByTargetGroup("parent");
            List<Announcement> generalAnnouncements = announcementDAO.getAnnouncementsByTargetGroup("all");
            
            // Combine lists
            announcements.addAll(generalAnnouncements);
            
            request.setAttribute("announcements", announcements);
            
            // Forward to the announcements page
            request.getRequestDispatcher("/WEB-INF/views/parent/announcements.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Log the error and show error page
            getServletContext().log("Error in AnnouncementsServlet", e);
            request.setAttribute("errorMessage", "Error retrieving announcements");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 