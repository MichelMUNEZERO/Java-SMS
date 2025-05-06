package com.sms.controller.admin;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.dao.CourseDAO;
import com.sms.dao.impl.CourseDAOImpl;
import com.sms.model.User;

/**
 * Servlet to handle admin course delete functionality
 */
@WebServlet("/admin/courses/delete/*")
public class AdminCourseDeleteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminCourseDeleteServlet.class.getName());
    private CourseDAO courseDAO;
    
    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAOImpl();
    }
    
    @Override
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
            response.sendRedirect(request.getContextPath() + "/" + user.getRole().toLowerCase() + "_dashboard.jsp");
            return;
        }
        
        try {
            // Extract course ID from path
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                // No course ID provided
                LOGGER.warning("No course ID provided for deletion");
                response.sendRedirect(request.getContextPath() + "/admin/courses?error=no_id");
                return;
            }
            
            // Parse course ID from path
            int courseId;
            try {
                courseId = Integer.parseInt(pathInfo.substring(1));
                LOGGER.info("Deleting course with ID: " + courseId);
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid course ID format for deletion: " + pathInfo.substring(1));
                response.sendRedirect(request.getContextPath() + "/admin/courses?error=invalid_id");
                return;
            }
            
            // Delete the course
            boolean deleted = courseDAO.deleteCourse(courseId);
            
            if (deleted) {
                LOGGER.info("Course deleted successfully with ID: " + courseId);
                response.sendRedirect(request.getContextPath() + "/admin/courses?success=deleted");
            } else {
                LOGGER.warning("Failed to delete course with ID: " + courseId);
                response.sendRedirect(request.getContextPath() + "/admin/courses?error=delete_failed");
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting course", e);
            response.sendRedirect(request.getContextPath() + "/admin/courses?error=delete_error");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // For simplicity, we'll just call doGet since delete operations are identical
        doGet(request, response);
    }
} 