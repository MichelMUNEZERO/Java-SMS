package com.sms.controller.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

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
 * Servlet for managing announcements
 */
@WebServlet(urlPatterns = { 
    "/admin/announcements", 
    "/admin/announcements/new", 
    "/admin/announcements/edit/*", 
    "/admin/announcements/delete/*" 
})
public class AnnouncementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in and is an admin
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
        
        String pathInfo = request.getServletPath();
        
        if (pathInfo.equals("/admin/announcements")) {
            // List all announcements
            List<Announcement> announcements = getAllAnnouncements();
            request.setAttribute("announcements", announcements);
            request.getRequestDispatcher("/admin/announcements.jsp").forward(request, response);
        } else if (pathInfo.equals("/admin/announcements/new")) {
            // Show form to create a new announcement
            request.getRequestDispatcher("/admin/announcement-form.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/admin/announcements/edit/")) {
            // Show form to edit an existing announcement
            String idStr = pathInfo.substring("/admin/announcements/edit/".length());
            try {
                int id = Integer.parseInt(idStr);
                Announcement announcement = getAnnouncementById(id);
                
                if (announcement != null) {
                    request.setAttribute("announcement", announcement);
                    request.getRequestDispatcher("/admin/announcement-form.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/announcements");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/announcements");
            }
        } else if (pathInfo.startsWith("/admin/announcements/delete/")) {
            // Delete an announcement
            String idStr = pathInfo.substring("/admin/announcements/delete/".length());
            try {
                int id = Integer.parseInt(idStr);
                deleteAnnouncement(id);
                
                response.sendRedirect(request.getContextPath() + "/admin/announcements");
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/announcements");
            }
        }
    }
    
    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in and is an admin
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
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            // Create a new announcement
            String message = request.getParameter("message");
            String targetGroup = request.getParameter("targetGroup");
            
            if (message != null && !message.trim().isEmpty() && 
                targetGroup != null && !targetGroup.trim().isEmpty()) {
                
                Announcement announcement = new Announcement();
                announcement.setMessage(message);
                announcement.setDate(new Date());
                announcement.setTargetGroup(targetGroup);
                
                createAnnouncement(announcement);
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/announcements");
        } else if ("update".equals(action)) {
            // Update an existing announcement
            String idStr = request.getParameter("id");
            String message = request.getParameter("message");
            String targetGroup = request.getParameter("targetGroup");
            
            if (idStr != null && !idStr.trim().isEmpty() && 
                message != null && !message.trim().isEmpty() && 
                targetGroup != null && !targetGroup.trim().isEmpty()) {
                
                try {
                    int id = Integer.parseInt(idStr);
                    
                    Announcement announcement = new Announcement();
                    announcement.setAnnouncementId(id);
                    announcement.setMessage(message);
                    announcement.setDate(new Date());
                    announcement.setTargetGroup(targetGroup);
                    
                    updateAnnouncement(announcement);
                } catch (NumberFormatException e) {
                    // Ignore invalid ID
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/announcements");
        }
    }
    
    /**
     * Get all announcements
     * @return list of announcements
     */
    private List<Announcement> getAllAnnouncements() {
        List<Announcement> announcements = new ArrayList<>();
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Announcement ORDER BY Date DESC";
            
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
    
    /**
     * Get announcement by ID
     * @param id the announcement ID
     * @return the announcement object
     */
    private Announcement getAnnouncementById(int id) {
        Announcement announcement = null;
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Announcement WHERE AnnouncementId = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        announcement = new Announcement();
                        announcement.setAnnouncementId(rs.getInt("AnnouncementId"));
                        announcement.setMessage(rs.getString("Message"));
                        announcement.setDate(rs.getTimestamp("Date"));
                        announcement.setTargetGroup(rs.getString("TargetGroup"));
                    }
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
        
        return announcement;
    }
    
    /**
     * Create a new announcement
     * @param announcement the announcement to create
     * @return true if creation successful, false otherwise
     */
    private boolean createAnnouncement(Announcement announcement) {
        Connection conn = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO Announcement (Message, Date, TargetGroup) VALUES (?, ?, ?)";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, announcement.getMessage());
                stmt.setTimestamp(2, new Timestamp(announcement.getDate().getTime()));
                stmt.setString(3, announcement.getTargetGroup());
                
                int rowsAffected = stmt.executeUpdate();
                success = rowsAffected > 0;
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
        
        return success;
    }
    
    /**
     * Update an existing announcement
     * @param announcement the announcement to update
     * @return true if update successful, false otherwise
     */
    private boolean updateAnnouncement(Announcement announcement) {
        Connection conn = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE Announcement SET Message = ?, Date = ?, TargetGroup = ? WHERE AnnouncementId = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, announcement.getMessage());
                stmt.setTimestamp(2, new Timestamp(announcement.getDate().getTime()));
                stmt.setString(3, announcement.getTargetGroup());
                stmt.setInt(4, announcement.getAnnouncementId());
                
                int rowsAffected = stmt.executeUpdate();
                success = rowsAffected > 0;
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
        
        return success;
    }
    
    /**
     * Delete an announcement
     * @param id the ID of the announcement to delete
     * @return true if deletion successful, false otherwise
     */
    private boolean deleteAnnouncement(int id) {
        Connection conn = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM Announcement WHERE AnnouncementId = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id);
                
                int rowsAffected = stmt.executeUpdate();
                success = rowsAffected > 0;
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
        
        return success;
    }
} 