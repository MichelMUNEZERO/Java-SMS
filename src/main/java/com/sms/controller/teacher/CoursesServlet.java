package com.sms.controller.teacher;

import java.io.IOException;
import java.util.ArrayList;
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
            
            // Get user ID from the user object
            int userId = user.getUserId();
            
            // Get the teacher ID from the database based on user ID
            TeacherDAO teacherDAO = new TeacherDAO();
            int teacherId = teacherDAO.getTeacherIdByUserId(userId);
            
            if (teacherId <= 0) {
                // Fallback to user ID if teacher ID not found
                teacherId = userId;
                LOGGER.warning("Could not find teacher ID for user ID: " + userId + ". Using user ID as fallback.");
            }
            
            LOGGER.info("Loading courses for teacher ID: " + teacherId);
            
            // Use CourseDAOImpl to get courses
            CourseDAO courseDAO = new CourseDAOImpl();
            List<Course> coursesList = courseDAO.getCoursesByTeacherId(teacherId);
            
            // Convert the List<Course> to List<Map<String,Object>> format for consistency
            List<Map<String, Object>> teacherCourses = new ArrayList<>();
            for (Course course : coursesList) {
                Map<String, Object> courseMap = new HashMap<>();
                courseMap.put("courseId", course.getId());
                courseMap.put("courseName", course.getCourseName());
                courseMap.put("courseCode", course.getCourseCode());
                courseMap.put("description", course.getDescription());
                courseMap.put("credits", course.getCredits());
                courseMap.put("teacherId", course.getTeacherId());
                courseMap.put("teacherName", course.getTeacherName());
                // Default student count to 0
                courseMap.put("studentCount", 0);
                teacherCourses.add(courseMap);
            }
            
            request.setAttribute("teacherCourses", teacherCourses);
            LOGGER.info("Courses retrieved from CourseDAOImpl: " + (teacherCourses != null ? teacherCourses.size() : 0));
            
            // Check if there's a success message or error message in the request parameters
            String successMsg = request.getParameter("success");
            if (successMsg != null) {
                String message = "";
                if ("added".equals(successMsg)) {
                    message = "Course added successfully.";
                } else if ("updated".equals(successMsg)) {
                    message = "Course updated successfully.";
                } else if ("deleted".equals(successMsg)) {
                    message = "Course deleted successfully.";
                }
                
                if (!message.isEmpty()) {
                    request.setAttribute("successMessage", message);
                }
            }
            
            String errorMsg = request.getParameter("error");
            if (errorMsg != null) {
                String message = "";
                if ("add_failed".equals(errorMsg)) {
                    message = "Failed to add course.";
                } else if ("update_failed".equals(errorMsg)) {
                    message = "Failed to update course.";
                } else if ("delete_failed".equals(errorMsg)) {
                    message = "Failed to delete course.";
                }
                
                if (!message.isEmpty()) {
                    request.setAttribute("errorMessage", message);
                }
            }
            
            // Forward to teacher courses page
            request.getRequestDispatcher("/WEB-INF/views/teacher/courses.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in CoursesServlet.doGet", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred: " + e.getMessage());
        }
    }
    
    /**
     * Handle POST requests - add or update course
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get action parameter
        String action = request.getParameter("action");
        
        // Get user ID from session (teacher ID)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        int teacherId = user.getUserId();
        
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
                    
                    // Explicitly clear any cached data from the session
                    session.removeAttribute("teacherCourses");
                    
                    // Redirect to courses page with success message
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