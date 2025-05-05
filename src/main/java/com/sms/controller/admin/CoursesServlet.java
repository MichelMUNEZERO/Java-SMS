package com.sms.controller.admin;

import java.io.IOException;
import java.util.List;
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
import com.sms.model.Course;
import com.sms.model.User;

/**
 * Servlet to handle admin courses page
 */
@WebServlet("/admin/courses")
public class CoursesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(CoursesServlet.class.getName());
    
    /**
     * Handle GET requests - show all courses
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
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
            
            LOGGER.info("Loading all courses for admin view");
            
            // Initialize DAO
            CourseDAO courseDAO = new CourseDAOImpl();
            
            // Get all courses
            List<Course> courses = courseDAO.getAllCourses();
            request.setAttribute("courses", courses);
            LOGGER.info("Courses retrieved: " + (courses != null ? courses.size() : 0));
            
            // Forward to admin courses page
            request.getRequestDispatcher("/admin/courses.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading courses", e);
            request.setAttribute("errorMessage", "Error loading courses: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle POST requests - disabled for admin users (view-only access)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Admin users have view-only access to courses, redirect to GET method
        LOGGER.warning("Unauthorized attempt to modify courses by admin user");
        response.sendRedirect(request.getContextPath() + "/admin/courses");
    }
} 