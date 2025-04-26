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

import com.sms.dao.TeacherDAO;
import com.sms.model.User;

/**
 * Servlet implementation class TeacherMarksServlet
 * Handles overall marks management for all courses taught by a teacher
 */
public class TeacherMarksServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(TeacherMarksServlet.class.getName());
    private TeacherDAO teacherDAO;
    
    @Override
    public void init() throws ServletException {
        teacherDAO = new TeacherDAO();
    }
    
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
            
            // Get teacher ID from the user object
            int teacherId = user.getUserId();
            LOGGER.info("Loading marks overview for teacher ID: " + teacherId);
            
            // Get all courses taught by this teacher
            List<Map<String, Object>> teacherCourses = teacherDAO.getCoursesByTeacherId(teacherId);
            
            // Get student count and mark statistics for each course
            for (Map<String, Object> course : teacherCourses) {
                int courseId = (int) course.get("courseId");
                
                // Get student count
                int studentCount = teacherDAO.getStudentCountByCourseId(courseId);
                course.put("studentCount", studentCount);
                
                // Get mark statistics (average, highest, lowest)
                Map<String, Object> markStats = teacherDAO.getMarkStatisticsByCourseId(courseId);
                if (markStats != null) {
                    course.put("markStats", markStats);
                }
            }
            
            // Set attributes for the JSP
            request.setAttribute("teacherCourses", teacherCourses);
            
            // Forward to teacher marks overview page
            request.getRequestDispatcher("/WEB-INF/views/teacher/marks.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading marks overview", e);
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // For now, we don't need to handle POST requests directly here
        doGet(request, response);
    }
} 