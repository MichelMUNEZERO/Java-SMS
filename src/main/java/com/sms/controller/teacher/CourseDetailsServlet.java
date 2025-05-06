package com.sms.controller.teacher;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.dao.TeacherDAO;
import com.sms.model.User;

/**
 * Servlet implementation class CourseDetailsServlet
 * Handles displaying detailed information about a specific course
 */
public class CourseDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(CourseDetailsServlet.class.getName());
    
    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Check if user is logged in and has teacher role
            HttpSession session = request.getSession(false);
            
            if (session == null || session.getAttribute("user") == null) {
                // Not logged in, redirect to login page
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            User user = (User) session.getAttribute("user");
            if (!"teacher".equals(user.getRole().toLowerCase())) {
                // Not a teacher, redirect to appropriate dashboard
                response.sendRedirect(request.getContextPath() + "/" + user.getRole().toLowerCase() + "/dashboard");
                return;
            }
            
            // Get course ID from request
            String courseIdStr = request.getParameter("id");
            if (courseIdStr == null || courseIdStr.isEmpty()) {
                // No course ID provided, redirect back to courses page
                response.sendRedirect(request.getContextPath() + "/teacher/courses");
                return;
            }
            
            int courseId;
            try {
                courseId = Integer.parseInt(courseIdStr);
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid course ID format: " + courseIdStr);
                request.setAttribute("errorMessage", "Invalid course ID format.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // Get user ID from the user object
            int userId = user.getUserId();
            
            // Initialize DAOs
            TeacherDAO teacherDAO = new TeacherDAO();
            
            // Get the teacher ID from the database based on user ID
            int teacherId = teacherDAO.getTeacherIdByUserId(userId);
            
            if (teacherId <= 0) {
                // Fallback to user ID if teacher ID not found
                teacherId = userId;
                LOGGER.warning("Could not find teacher ID for user ID: " + userId + ". Using user ID as fallback.");
            }
            
            LOGGER.info("Loading course details for teacher ID: " + teacherId + ", course ID: " + courseId);
            
            // Get course details
            Map<String, Object> courseDetails = teacherDAO.getCourseDetailsById(courseId, teacherId);
            if (courseDetails == null || courseDetails.isEmpty()) {
                // Course not found or not taught by this teacher
                LOGGER.warning("Course not found or not authorized for teacher ID: " + teacherId + ", course ID: " + courseId);
                request.setAttribute("errorMessage", "Course not found or you are not authorized to view it.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // Get student list for this course
            List<Map<String, Object>> courseStudents = teacherDAO.getStudentsWithMarksByCourseId(courseId);
            
            // Set attributes for the JSP
            request.setAttribute("courseDetails", courseDetails);
            request.setAttribute("courseStudents", courseStudents);
            
            // Forward to course details page
            request.getRequestDispatcher("/WEB-INF/views/teacher/course-details.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading course details", e);
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle any form submissions for course details
        doGet(request, response);
    }

} 