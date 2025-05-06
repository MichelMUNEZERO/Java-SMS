package com.sms.controller.teacher;

import java.io.IOException;
import java.util.HashMap;
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

import com.sms.dao.AnnouncementDAO;
import com.sms.dao.AppointmentDAO;
import com.sms.dao.DashboardDAO;
import com.sms.dao.TeacherDAO;
import com.sms.model.Announcement;
import com.sms.model.User;

/**
 * Servlet to handle teacher dashboard
 */
@WebServlet("/teacher/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(DashboardServlet.class.getName());
    
    /**
     * Handle GET requests - show teacher dashboard
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
            
            // Get teacher ID from the user object or session
            int teacherId = user.getUserId(); // Using getUserId() instead of getId()
            LOGGER.info("Loading dashboard for teacher ID: " + teacherId);
            
            // Initialize DAOs
            TeacherDAO teacherDAO = new TeacherDAO();
            DashboardDAO dashboardDAO = new DashboardDAO();
            AnnouncementDAO announcementDAO = new AnnouncementDAO();
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            
            // Get the teacher ID from the database based on user ID
            int dbTeacherId = teacherDAO.getTeacherIdByUserId(teacherId);
            
            if (dbTeacherId > 0) {
                teacherId = dbTeacherId;
            } else {
                // Fallback to user ID if teacher ID not found
                LOGGER.warning("Could not find teacher ID for user ID: " + teacherId + ". Using user ID as fallback.");
            }
            
            LOGGER.info("Loading dashboard for updated teacher ID: " + teacherId);
            
            // Ensure student-course relationship exists (for debugging)
            teacherDAO.ensureStudentCourseRelationship();
            
            // Fetch teacher dashboard data
            Map<String, Object> dashboardData = new HashMap<>();
            
            // 1. Number of students enrolled in teacher's courses
            int totalStudents = teacherDAO.getStudentCountByTeacherId(teacherId);
            dashboardData.put("totalStudents", totalStudents);
            LOGGER.info("Total students: " + totalStudents);
            
            // 2. Number of courses managed by the teacher
            int totalCourses = teacherDAO.getCourseCountByTeacherId(teacherId);
            dashboardData.put("totalCourses", totalCourses);
            LOGGER.info("Total courses: " + totalCourses);
            
            // 3. Number of appointments for today
            int todayAppointments = teacherDAO.getTodayAppointmentCountByTeacherId(teacherId);
            dashboardData.put("todayAppointments", todayAppointments);
            LOGGER.info("Today's appointments: " + todayAppointments);
            
            // 4. List of courses taught by this teacher
            List<Map<String, Object>> teacherCourses = teacherDAO.getCoursesByTeacherId(teacherId);
            request.setAttribute("teacherCourses", teacherCourses);
            LOGGER.info("Teacher courses count: " + (teacherCourses != null ? teacherCourses.size() : 0));
            
            // 5. Get announcements relevant to the teacher
            List<Announcement> announcements = announcementDAO.getAnnouncementsByTarget("teacher");
            request.setAttribute("announcements", announcements);
            LOGGER.info("Announcements count: " + (announcements != null ? announcements.size() : 0));
            
            // 6. Get profile data for the teacher
            Map<String, Object> profileData = dashboardDAO.getUserProfile(user.getUserId());
            request.setAttribute("profileData", profileData);
            
            // Add all dashboard data to request
            request.setAttribute("dashboardData", dashboardData);
            
            // Forward to teacher dashboard page
            request.getRequestDispatcher("/teacher_dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading teacher dashboard", e);
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle POST requests
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Process any form submissions from the dashboard
        doGet(request, response);
    }
} 