package com.sms.controller.admin;

import java.io.IOException;
import java.sql.Timestamp;
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
 * Servlet for managing announcements in the admin section
 */
@WebServlet(urlPatterns = { 
    "/admin/announcements", 
    "/admin/announcements/new",
    "/admin/announcements/edit/*",
    "/admin/announcements/delete/*",
    "/admin/announcements/view/*"
})
public class AnnouncementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AnnouncementDAO announcementDAO;
    
    @Override
    public void init() throws ServletException {
        announcementDAO = new AnnouncementDAO();
    }
    
    /**
     * Handle GET requests - show announcement listings, forms, or details
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getServletPath();
        
        if (action.equals("/admin/announcements")) {
            // Show all announcements
            listAnnouncements(request, response);
        } else if (action.equals("/admin/announcements/new")) {
            // Show form to add a new announcement
            showNewForm(request, response);
        } else if (action.startsWith("/admin/announcements/edit/")) {
            // Show form to edit an existing announcement
            showEditForm(request, response);
        } else if (action.startsWith("/admin/announcements/delete/")) {
            // Delete an announcement
            deleteAnnouncement(request, response);
        } else if (action.startsWith("/admin/announcements/view/")) {
            // View announcement details
            viewAnnouncement(request, response);
        } else {
            // Default to announcement listing
            response.sendRedirect(request.getContextPath() + "/admin/announcements");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check authentication similar to doGet
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getServletPath();
        
        if (action.equals("/admin/announcements/new")) {
            // Process new announcement form
            addAnnouncement(request, response);
        } else if (action.startsWith("/admin/announcements/edit/")) {
            // Process edit announcement form
            updateAnnouncement(request, response);
        } else {
            // Default redirect to listing
            response.sendRedirect(request.getContextPath() + "/admin/announcements");
        }
    }
    
    /**
     * List all announcements
     */
    private void listAnnouncements(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Announcement> announcements = announcementDAO.getAllAnnouncements();
        request.setAttribute("announcements", announcements);
        request.getRequestDispatcher("/admin/announcements.jsp").forward(request, response);
    }
    
    /**
     * Show form to add a new announcement
     */
    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/announcement_form.jsp").forward(request, response);
    }
    
    /**
     * Show form to edit an existing announcement
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        int announcementId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
        
        Announcement announcement = announcementDAO.getAnnouncementById(announcementId);
        request.setAttribute("announcement", announcement);
        request.getRequestDispatcher("/admin/announcement_form.jsp").forward(request, response);
    }
    
    /**
     * Add a new announcement
     */
    private void addAnnouncement(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Collect form data
        String title = request.getParameter("title");
        String message = request.getParameter("message");
        String targetGroup = request.getParameter("targetGroup");
        
        // Get current user as the poster
        User user = (User) request.getSession().getAttribute("user");
        String postedBy = user.getUsername();
        
        // Create announcement object
        Announcement announcement = new Announcement();
        announcement.setTitle(title);
        announcement.setMessage(message);
        announcement.setTargetGroup(targetGroup);
        announcement.setPostedBy(postedBy);
        announcement.setDate(new Timestamp(System.currentTimeMillis()));
        
        // Save to database
        boolean success = announcementDAO.addAnnouncement(announcement);
        
        if (success) {
            // Redirect to announcement list with success message
            response.sendRedirect(request.getContextPath() + "/admin/announcements?message=Announcement added successfully");
        } else {
            // Redirect back to form with error message
            request.setAttribute("error", "Failed to add announcement. Please try again.");
            request.setAttribute("announcement", announcement);
            request.getRequestDispatcher("/admin/announcement_form.jsp").forward(request, response);
        }
    }
    
    /**
     * Update an existing announcement
     */
    private void updateAnnouncement(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get announcement ID from path
        String pathInfo = request.getPathInfo();
        int announcementId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
        
        // Collect form data
        String title = request.getParameter("title");
        String message = request.getParameter("message");
        String targetGroup = request.getParameter("targetGroup");
        
        // Get original announcement to preserve some fields
        Announcement originalAnnouncement = announcementDAO.getAnnouncementById(announcementId);
        
        // Create announcement object
        Announcement announcement = new Announcement();
        announcement.setAnnouncementId(announcementId);
        announcement.setTitle(title);
        announcement.setMessage(message);
        announcement.setTargetGroup(targetGroup);
        announcement.setPostedBy(originalAnnouncement.getPostedBy());
        announcement.setDate(originalAnnouncement.getDate());
        
        // Update in database
        boolean success = announcementDAO.updateAnnouncement(announcement);
        
        if (success) {
            // Redirect to announcement list with success message
            response.sendRedirect(request.getContextPath() + "/admin/announcements?message=Announcement updated successfully");
        } else {
            // Redirect back to form with error message
            request.setAttribute("error", "Failed to update announcement. Please try again.");
            request.setAttribute("announcement", announcement);
            request.getRequestDispatcher("/admin/announcement_form.jsp").forward(request, response);
        }
    }
    
    /**
     * Delete an announcement
     */
    private void deleteAnnouncement(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        int announcementId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
        
        boolean success = announcementDAO.deleteAnnouncement(announcementId);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/announcements?message=Announcement deleted successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/announcements?error=Failed to delete announcement");
        }
    }
    
    /**
     * View announcement details
     */
    private void viewAnnouncement(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        int announcementId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
        
        Announcement announcement = announcementDAO.getAnnouncementById(announcementId);
        request.setAttribute("announcement", announcement);
        request.getRequestDispatcher("/admin/announcement_details.jsp").forward(request, response);
    }
} 