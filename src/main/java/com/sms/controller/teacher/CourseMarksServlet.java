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

import com.sms.dao.MarksDAO;
import com.sms.dao.TeacherDAO;
import com.sms.model.User;

/**
 * Servlet implementation class CourseMarksServlet
 * Handles marks management for students in a specific course
 */
public class CourseMarksServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(CourseMarksServlet.class.getName());
    
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
            LOGGER.info("Loading marks for teacher ID: " + teacherId + ", course ID: " + courseId);
            
            // Initialize DAOs
            TeacherDAO teacherDAO = new TeacherDAO();
            MarksDAO marksDAO = new MarksDAO();
            
            // Verify if the course belongs to this teacher
            Map<String, Object> courseDetails = teacherDAO.getCourseDetailsById(courseId, teacherId);
            if (courseDetails == null || courseDetails.isEmpty()) {
                // Course not found or not taught by this teacher
                LOGGER.warning("Course not found or not authorized for teacher ID: " + teacherId + ", course ID: " + courseId);
                request.setAttribute("errorMessage", "Course not found or you are not authorized to manage its marks.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // Get students with marks for this course
            List<Map<String, Object>> studentsWithMarks = teacherDAO.getStudentsWithMarksByCourseId(courseId);
            
            // Set attributes for the JSP
            request.setAttribute("courseDetails", courseDetails);
            request.setAttribute("studentsWithMarks", studentsWithMarks);
            
            // Forward to course marks management page
            request.getRequestDispatcher("/WEB-INF/views/teacher/course-marks.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading course marks", e);
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
            MarksDAO marksDAO = new MarksDAO();
            
            // Verify if the course belongs to this teacher
            Map<String, Object> courseDetails = teacherDAO.getCourseDetailsById(courseId, teacherId);
            if (courseDetails == null || courseDetails.isEmpty()) {
                // Course not found or not taught by this teacher
                LOGGER.warning("Course not found or not authorized for teacher ID: " + teacherId + ", course ID: " + courseId);
                request.setAttribute("errorMessage", "Course not found or you are not authorized to manage its marks.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // Process the action based on the form submission
            String action = request.getParameter("action");
            
            if ("updateMarks".equals(action)) {
                // Get the student IDs and their corresponding marks
                String[] studentIds = request.getParameterValues("studentId");
                String[] marks = request.getParameterValues("mark");
                String[] grades = request.getParameterValues("grade");
                
                if (studentIds != null && marks != null && grades != null && 
                    studentIds.length == marks.length && marks.length == grades.length) {
                    
                    for (int i = 0; i < studentIds.length; i++) {
                        try {
                            int studentId = Integer.parseInt(studentIds[i]);
                            float mark = 0;
                            try {
                                mark = Float.parseFloat(marks[i]);
                            } catch (NumberFormatException e) {
                                // Invalid mark, use 0
                                LOGGER.warning("Invalid mark format: " + marks[i] + " for student ID: " + studentId);
                            }
                            
                            String grade = grades[i];
                            
                            // Update or insert the mark
                            marksDAO.updateOrInsertMark(studentId, courseId, mark, grade);
                        } catch (NumberFormatException e) {
                            LOGGER.warning("Invalid student ID format: " + studentIds[i]);
                        }
                    }
                }
            }
            
            // Redirect back to the course marks page
            response.sendRedirect(request.getContextPath() + "/teacher/course-marks?id=" + courseId);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing course marks action", e);
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 