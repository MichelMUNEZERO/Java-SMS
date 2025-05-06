package com.sms.controller.admin;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.dao.CourseDAO;
import com.sms.dao.TeacherDAO;
import com.sms.dao.impl.CourseDAOImpl;
import com.sms.model.Course;
import com.sms.model.User;

/**
 * Servlet to handle admin course details view
 */
@WebServlet("/admin/courses/view/*")
public class AdminCourseDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminCourseDetailsServlet.class.getName());
    private CourseDAO courseDAO;
    private TeacherDAO teacherDAO;
    
    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAOImpl();
        teacherDAO = new TeacherDAO();
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
                LOGGER.warning("No course ID provided in the URL");
                request.setAttribute("errorMessage", "No course ID provided");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // Parse course ID from path
            int courseId;
            try {
                courseId = Integer.parseInt(pathInfo.substring(1));
                LOGGER.info("Viewing course with ID: " + courseId);
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid course ID format: " + pathInfo.substring(1));
                request.setAttribute("errorMessage", "Invalid course ID format");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // Get course details
            Course course = courseDAO.getCourseById(courseId);
            if (course == null) {
                LOGGER.warning("Course not found with ID: " + courseId);
                request.setAttribute("errorMessage", "Course not found with ID: " + courseId);
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // Get enrolled students count
            int studentCount = teacherDAO.getStudentCountByCourseId(courseId);
            course.setStudentCount(studentCount);
            
            // Get teacher details if assigned
            if (course.getTeacherId() > 0) {
                // Add detailed teacher info if needed
                LOGGER.info("Course is assigned to teacher ID: " + course.getTeacherId());
            } else {
                LOGGER.info("Course is not assigned to any teacher");
            }
            
            // Add course to request attributes
            request.setAttribute("course", course);
            
            // Forward to course details page
            request.getRequestDispatcher("/admin/course_details.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error viewing course details", e);
            request.setAttribute("errorMessage", "Error viewing course details: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 