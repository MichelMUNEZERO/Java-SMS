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

import com.sms.dao.DashboardDAO;
import com.sms.dao.TeacherDAO;
import com.sms.model.User;

/**
 * Servlet implementation class TeacherReportsServlet
 * Handles report generation for teachers
 */
public class TeacherReportsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(TeacherReportsServlet.class.getName());
    private TeacherDAO teacherDAO;
    private DashboardDAO dashboardDAO;
    
    @Override
    public void init() throws ServletException {
        teacherDAO = new TeacherDAO();
        dashboardDAO = new DashboardDAO();
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
            LOGGER.info("Loading reports for teacher ID: " + teacherId);
            
            // Get all courses taught by this teacher for filter dropdowns
            List<Map<String, Object>> teacherCourses = teacherDAO.getCoursesByTeacherId(teacherId);
            request.setAttribute("teacherCourses", teacherCourses);
            
            // Get profile data
            Map<String, Object> profileData = dashboardDAO.getUserProfile(user.getUserId());
            request.setAttribute("profileData", profileData);
            
            // Check if a report generation request was made
            String reportType = request.getParameter("reportType");
            if (reportType != null && !reportType.isEmpty()) {
                // Get filter parameters
                Map<String, Object> filterParams = new HashMap<>();
                
                // Add teacher ID to filter
                filterParams.put("teacherId", teacherId);
                
                // Process other filter parameters
                String courseId = request.getParameter("courseId");
                if (courseId != null && !courseId.isEmpty()) {
                    filterParams.put("courseId", Integer.parseInt(courseId));
                }
                
                String studentId = request.getParameter("studentId");
                if (studentId != null && !studentId.isEmpty()) {
                    filterParams.put("studentId", Integer.parseInt(studentId));
                }
                
                String startDate = request.getParameter("startDate");
                if (startDate != null && !startDate.isEmpty()) {
                    filterParams.put("startDate", startDate);
                }
                
                String endDate = request.getParameter("endDate");
                if (endDate != null && !endDate.isEmpty()) {
                    filterParams.put("endDate", endDate);
                }
                
                // For marks report
                String gradeThreshold = request.getParameter("gradeThreshold");
                if (gradeThreshold != null && !gradeThreshold.isEmpty()) {
                    filterParams.put("gradeThreshold", Double.parseDouble(gradeThreshold));
                }
                
                // For behavior report
                String behaviorType = request.getParameter("behaviorType");
                if (behaviorType != null && !behaviorType.isEmpty()) {
                    filterParams.put("behaviorType", behaviorType);
                }
                
                // For attendance report
                String status = request.getParameter("status");
                if (status != null && !status.isEmpty()) {
                    filterParams.put("status", status);
                }
                
                // Get report data
                Map<String, Object> reportData = dashboardDAO.getReportData(reportType, filterParams);
                request.setAttribute("reportData", reportData);
            }
            
            // Forward to teacher reports page
            request.getRequestDispatcher("/WEB-INF/views/teacher/reports.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading teacher reports", e);
            request.setAttribute("errorMessage", "An error occurred while generating reports: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Process report generation form submission
        doGet(request, response);
    }
} 