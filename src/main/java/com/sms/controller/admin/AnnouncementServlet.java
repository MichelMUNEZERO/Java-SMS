package com.sms.controller.admin;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

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
    private static final Logger LOGGER = Logger.getLogger(AnnouncementServlet.class.getName());
    
    @Override
    public void init() throws ServletException {
        announcementDAO = new AnnouncementDAO();
    }
    
    /**
     * Handle GET requests - show announcement listings, forms, or details
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Debug information
        LOGGER.info("Servlet Path: " + request.getServletPath());
        LOGGER.info("Path Info: " + request.getPathInfo());
        LOGGER.info("Request URI: " + request.getRequestURI());
        
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
        String pathInfo = request.getPathInfo();
        
        // For URLs with path parameters (like /view/1, /edit/1, /delete/1)
        if (pathInfo != null) {
            action = action + pathInfo.substring(0, pathInfo.lastIndexOf('/') + 1);
            LOGGER.info("Modified action for path parameter URL: " + action);
        }
        
        LOGGER.info("Processing action: " + action);
        
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
            LOGGER.warning("Unrecognized action: " + action);
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
        LOGGER.info("Edit Form - Path Info: " + pathInfo);
        
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/admin/announcements?error=Invalid announcement ID");
            return;
        }
        
        try {
            int announcementId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
            LOGGER.info("Edit Form - Announcement ID: " + announcementId);
            
            Announcement announcement = announcementDAO.getAnnouncementById(announcementId);
            if (announcement == null) {
                response.sendRedirect(request.getContextPath() + "/admin/announcements?error=Announcement not found");
                return;
            }
            
            request.setAttribute("announcement", announcement);
            request.getRequestDispatcher("/admin/announcement_form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid announcement ID format: " + pathInfo);
            response.sendRedirect(request.getContextPath() + "/admin/announcements?error=Invalid announcement ID format");
        }
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
        // Use user ID instead of username
        String postedBy = String.valueOf(user.getUserId());
        
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
        LOGGER.info("Update Announcement - Path Info: " + pathInfo);
        
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/admin/announcements?error=Invalid announcement ID");
            return;
        }
        
        try {
            int announcementId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
            LOGGER.info("Update Announcement - Announcement ID: " + announcementId);
            
            // Collect form data
            String title = request.getParameter("title");
            String message = request.getParameter("message");
            String targetGroup = request.getParameter("targetGroup");
            
            // Get original announcement to preserve some fields
            Announcement originalAnnouncement = announcementDAO.getAnnouncementById(announcementId);
            
            if (originalAnnouncement == null) {
                response.sendRedirect(request.getContextPath() + "/admin/announcements?error=Announcement not found");
                return;
            }
            
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
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid announcement ID format: " + pathInfo);
            response.sendRedirect(request.getContextPath() + "/admin/announcements?error=Invalid announcement ID format");
        }
    }
    
    /**
     * Delete an announcement
     */
    private void deleteAnnouncement(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        LOGGER.info("Delete Announcement - Path Info: " + pathInfo);
        
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/admin/announcements?error=Invalid announcement ID");
            return;
        }
        
        try {
            int announcementId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
            LOGGER.info("Delete Announcement - Announcement ID: " + announcementId);
            
            boolean success = announcementDAO.deleteAnnouncement(announcementId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/announcements?message=Announcement deleted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/announcements?error=Failed to delete announcement");
            }
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid announcement ID format: " + pathInfo);
            response.sendRedirect(request.getContextPath() + "/admin/announcements?error=Invalid announcement ID format");
        }
    }
    
    /**
     * View announcement details
     */
    private void viewAnnouncement(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        LOGGER.info("View Announcement - Path Info: " + pathInfo);
        
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/admin/announcements?error=Invalid announcement ID");
            return;
        }
        
        try {
            int announcementId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
            LOGGER.info("View Announcement - Announcement ID: " + announcementId);
            
            Announcement announcement = announcementDAO.getAnnouncementById(announcementId);
            if (announcement == null) {
                response.sendRedirect(request.getContextPath() + "/admin/announcements?error=Announcement not found");
                return;
            }
            
            request.setAttribute("announcement", announcement);
            request.getRequestDispatcher("/admin/announcement_details.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid announcement ID format: " + pathInfo);
            response.sendRedirect(request.getContextPath() + "/admin/announcements?error=Invalid announcement ID format");
        }
    }
} 