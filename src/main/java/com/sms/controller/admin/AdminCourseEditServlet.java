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
import com.sms.dao.TeacherDAO;
import com.sms.dao.impl.CourseDAOImpl;
import com.sms.model.Course;
import com.sms.model.Teacher;
import com.sms.model.User;

/**
 * Servlet to handle admin course edit functionality
 */
@WebServlet("/admin/courses/edit/*")
public class AdminCourseEditServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminCourseEditServlet.class.getName());
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
                // No course ID provided, show form for new course
                request.setAttribute("course", new Course());
                request.setAttribute("isNew", true);
                
                // Get teachers for dropdown
                List<Teacher> teachers = teacherDAO.getAllTeachers();
                request.setAttribute("teachers", teachers);
                
                request.getRequestDispatcher("/admin/course_form.jsp").forward(request, response);
                return;
            }
            
            // Parse course ID from path
            int courseId;
            try {
                courseId = Integer.parseInt(pathInfo.substring(1));
                LOGGER.info("Editing course with ID: " + courseId);
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid course ID format: " + pathInfo.substring(1));
                response.sendRedirect(request.getContextPath() + "/admin/courses?error=invalid_id");
                return;
            }
            
            // Get course details
            Course course = courseDAO.getCourseById(courseId);
            if (course == null) {
                LOGGER.warning("Course not found with ID: " + courseId);
                response.sendRedirect(request.getContextPath() + "/admin/courses?error=not_found");
                return;
            }
            
            // Get teachers for dropdown
            List<Teacher> teachers = teacherDAO.getAllTeachers();
            
            // Add course and teachers to request attributes
            request.setAttribute("course", course);
            request.setAttribute("teachers", teachers);
            request.setAttribute("isNew", false);
            
            // Forward to course form page
            request.getRequestDispatcher("/admin/course_form.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error editing course", e);
            response.sendRedirect(request.getContextPath() + "/admin/courses?error=edit_error");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
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
            // Get form data
            String courseName = request.getParameter("courseName");
            String courseCode = request.getParameter("courseCode");
            String description = request.getParameter("description");
            String teacherIdStr = request.getParameter("teacherId");
            String creditsStr = request.getParameter("credits");
            String status = request.getParameter("status");
            String courseIdStr = request.getParameter("courseId");
            
            // Validate required fields
            if (courseName == null || courseName.trim().isEmpty() || 
                courseCode == null || courseCode.trim().isEmpty() ||
                creditsStr == null || creditsStr.trim().isEmpty()) {
                
                // Prepare course object with provided data
                Course course = new Course();
                if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                    try {
                        course.setId(Integer.parseInt(courseIdStr));
                    } catch (NumberFormatException e) {
                        // Invalid ID, will be treated as new course
                    }
                }
                course.setCourseName(courseName != null ? courseName : "");
                course.setCourseCode(courseCode != null ? courseCode : "");
                course.setDescription(description != null ? description : "");
                course.setTeacherId(teacherIdStr != null && !teacherIdStr.trim().isEmpty() ? 
                                 Integer.parseInt(teacherIdStr) : 0);
                course.setCredits(creditsStr != null && !creditsStr.trim().isEmpty() ? 
                               Integer.parseInt(creditsStr) : 0);
                course.setStatus(status != null ? status : "active");
                
                // Get teachers for dropdown
                List<Teacher> teachers = teacherDAO.getAllTeachers();
                
                // Add course and error to request attributes
                request.setAttribute("course", course);
                request.setAttribute("teachers", teachers);
                request.setAttribute("isNew", courseIdStr == null || courseIdStr.trim().isEmpty());
                request.setAttribute("errorMessage", "Course name, code, and credits are required");
                
                // Forward back to form
                request.getRequestDispatcher("/admin/course_form.jsp").forward(request, response);
                return;
            }
            
            // Parse numeric values
            int teacherId = 0;
            if (teacherIdStr != null && !teacherIdStr.trim().isEmpty()) {
                try {
                    teacherId = Integer.parseInt(teacherIdStr);
                } catch (NumberFormatException e) {
                    // Invalid teacher ID, use default (0)
                }
            }
            
            int credits = 0;
            try {
                credits = Integer.parseInt(creditsStr);
            } catch (NumberFormatException e) {
                // Invalid credits, use default (0)
            }
            
            // Check if updating existing course or creating new one
            boolean isNew = (courseIdStr == null || courseIdStr.trim().isEmpty());
            
            if (isNew) {
                // Create new course
                Course newCourse = new Course();
                newCourse.setCourseName(courseName);
                newCourse.setCourseCode(courseCode);
                newCourse.setDescription(description != null ? description : "");
                newCourse.setTeacherId(teacherId);
                newCourse.setCredits(credits);
                newCourse.setStatus(status != null ? status : "active");
                
                int courseId = courseDAO.createCourse(newCourse);
                
                if (courseId > 0) {
                    LOGGER.info("Course created successfully with ID: " + courseId);
                    response.sendRedirect(request.getContextPath() + "/admin/courses?success=added");
                } else {
                    LOGGER.warning("Failed to create course");
                    response.sendRedirect(request.getContextPath() + "/admin/courses?error=add_failed");
                }
            } else {
                // Update existing course
                int courseId = Integer.parseInt(courseIdStr);
                Course existingCourse = courseDAO.getCourseById(courseId);
                
                if (existingCourse == null) {
                    LOGGER.warning("Course not found with ID: " + courseId);
                    response.sendRedirect(request.getContextPath() + "/admin/courses?error=not_found");
                    return;
                }
                
                existingCourse.setCourseName(courseName);
                existingCourse.setCourseCode(courseCode);
                existingCourse.setDescription(description != null ? description : "");
                existingCourse.setTeacherId(teacherId);
                existingCourse.setCredits(credits);
                existingCourse.setStatus(status != null ? status : "active");
                
                boolean updated = courseDAO.updateCourse(existingCourse);
                
                if (updated) {
                    LOGGER.info("Course updated successfully with ID: " + courseId);
                    response.sendRedirect(request.getContextPath() + "/admin/courses?success=updated");
                } else {
                    LOGGER.warning("Failed to update course with ID: " + courseId);
                    response.sendRedirect(request.getContextPath() + "/admin/courses?error=update_failed");
                }
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing course form", e);
            response.sendRedirect(request.getContextPath() + "/admin/courses?error=process_error");
        }
    }
} 