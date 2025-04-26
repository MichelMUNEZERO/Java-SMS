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

import com.sms.dao.StudentDAO;
import com.sms.dao.TeacherDAO;
import com.sms.model.User;

/**
 * Servlet implementation class CourseStudentsServlet
 * Handles student management for a specific course
 */
public class CourseStudentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(CourseStudentsServlet.class.getName());
    
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
            
            // Get teacher ID from the user object
            int teacherId = user.getUserId();
            LOGGER.info("Loading students for teacher ID: " + teacherId + ", course ID: " + courseId);
            
            // Initialize DAOs
            TeacherDAO teacherDAO = new TeacherDAO();
            StudentDAO studentDAO = new StudentDAO();
            
            // Verify if the course belongs to this teacher
            Map<String, Object> courseDetails = teacherDAO.getCourseDetailsById(courseId, teacherId);
            if (courseDetails == null || courseDetails.isEmpty()) {
                // Course not found or not taught by this teacher
                LOGGER.warning("Course not found or not authorized for teacher ID: " + teacherId + ", course ID: " + courseId);
                request.setAttribute("errorMessage", "Course not found or you are not authorized to manage its students.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // Get students enrolled in this course
            List<Map<String, Object>> enrolledStudents = teacherDAO.getStudentsWithMarksByCourseId(courseId);
            
            // Get all students for potential enrollment
            List<Map<String, Object>> allStudents = studentDAO.getAllStudentsForEnrollment();
            
            // Set attributes for the JSP
            request.setAttribute("courseDetails", courseDetails);
            request.setAttribute("enrolledStudents", enrolledStudents);
            request.setAttribute("allStudents", allStudents);
            
            // Forward to course students management page
            request.getRequestDispatcher("/WEB-INF/views/teacher/course-students.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading course students", e);
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
            String courseIdStr = request.getParameter("courseId");
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
            
            // Get teacher ID from the user object
            int teacherId = user.getUserId();
            
            // Initialize DAOs
            TeacherDAO teacherDAO = new TeacherDAO();
            
            // Verify if the course belongs to this teacher
            Map<String, Object> courseDetails = teacherDAO.getCourseDetailsById(courseId, teacherId);
            if (courseDetails == null || courseDetails.isEmpty()) {
                // Course not found or not taught by this teacher
                LOGGER.warning("Course not found or not authorized for teacher ID: " + teacherId + ", course ID: " + courseId);
                request.setAttribute("errorMessage", "Course not found or you are not authorized to manage its students.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // Process the action based on the form submission
            String action = request.getParameter("action");
            
            if ("enroll".equals(action)) {
                // Enroll students
                String[] studentIds = request.getParameterValues("studentId");
                if (studentIds != null && studentIds.length > 0) {
                    for (String studentIdStr : studentIds) {
                        try {
                            int studentId = Integer.parseInt(studentIdStr);
                            teacherDAO.enrollStudentInCourse(studentId, courseId);
                        } catch (NumberFormatException e) {
                            LOGGER.warning("Invalid student ID format: " + studentIdStr);
                        }
                    }
                }
            } else if ("unenroll".equals(action)) {
                // Unenroll a student
                String studentIdStr = request.getParameter("studentId");
                if (studentIdStr != null && !studentIdStr.isEmpty()) {
                    try {
                        int studentId = Integer.parseInt(studentIdStr);
                        teacherDAO.removeStudentFromCourse(studentId, courseId);
                    } catch (NumberFormatException e) {
                        LOGGER.warning("Invalid student ID format: " + studentIdStr);
                    }
                }
            }
            
            // Redirect back to the course students page
            response.sendRedirect(request.getContextPath() + "/teacher/course-students?id=" + courseId);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing course students action", e);
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 