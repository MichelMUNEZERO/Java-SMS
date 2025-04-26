package com.sms.controller.teacher;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
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
 * Servlet to handle teacher courses page
 */
public class CoursesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(CoursesServlet.class.getName());
    
    /**
     * Handle GET requests - show teacher courses
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
            
            // Get teacher ID from the user object
            int teacherId = user.getUserId();
            LOGGER.info("Loading courses for teacher ID: " + teacherId);
            
            // Initialize DAOs
            TeacherDAO teacherDAO = new TeacherDAO();
            
            // Get courses taught by this teacher
            List<Map<String, Object>> teacherCourses = teacherDAO.getCoursesByTeacherId(teacherId);
            request.setAttribute("teacherCourses", teacherCourses);
            LOGGER.info("Courses retrieved: " + (teacherCourses != null ? teacherCourses.size() : 0));
            
            // Forward to teacher courses page
            request.getRequestDispatcher("/WEB-INF/views/teacher/courses.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading teacher courses", e);
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle POST requests - add or update course
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
        
        // Get teacher ID from the user object
        int teacherId = user.getUserId();
        
        // Get form parameters
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            // Add new course
            try {
                String courseCode = request.getParameter("courseCode");
                String courseName = request.getParameter("courseName");
                String description = request.getParameter("description");
                
                LOGGER.info("Adding new course: " + courseName + " (" + courseCode + ") for teacher ID: " + teacherId);
                
                // Create Course object
                Course course = new Course();
                course.setCourseCode(courseCode);
                course.setCourseName(courseName);
                course.setDescription(description);
                course.setTeacherId(teacherId);
                course.setCredits(3); // Default value
                
                // Add the course to the database
                CourseDAO courseDAO = new CourseDAOImpl();
                int courseId = courseDAO.createCourse(course);
                
                if (courseId > 0) {
                    // Course added successfully
                    LOGGER.info("Course added successfully with ID: " + courseId);
                    response.sendRedirect(request.getContextPath() + "/teacher/courses?success=added");
                } else {
                    // Error adding course
                    LOGGER.warning("Error adding course: " + courseName);
                    response.sendRedirect(request.getContextPath() + "/teacher/courses?error=add_failed");
                }
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Error adding course", e);
                response.sendRedirect(request.getContextPath() + "/teacher/courses?error=add_failed&message=" + e.getMessage());
            }
        } else {
            // No recognized action, just show the courses page
            doGet(request, response);
        }
    }
} 