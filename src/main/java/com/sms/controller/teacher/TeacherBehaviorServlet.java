package com.sms.controller.teacher;

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

import com.sms.dao.BehaviorDAO;
import com.sms.dao.TeacherDAO;
import com.sms.model.User;

/**
 * Servlet implementation class TeacherBehaviorServlet
 * Handles student behavior management for teachers
 */
@WebServlet("/teacher/behavior")
public class TeacherBehaviorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(TeacherBehaviorServlet.class.getName());
    private TeacherDAO teacherDAO;
    private BehaviorDAO behaviorDAO;
    
    @Override
    public void init() throws ServletException {
        teacherDAO = new TeacherDAO();
        behaviorDAO = new BehaviorDAO();
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
            LOGGER.info("Loading behavior records for teacher ID: " + teacherId);
            
            // Get all courses taught by this teacher
            List<Map<String, Object>> teacherCourses = teacherDAO.getCoursesByTeacherId(teacherId);
            request.setAttribute("teacherCourses", teacherCourses);
            
            // Get student behavior records
            List<Map<String, Object>> behaviorRecords = teacherDAO.getStudentBehaviorByTeacherId(teacherId);
            request.setAttribute("behaviorRecords", behaviorRecords);
            
            // Get behavior types for dropdown
            List<String> behaviorTypes = behaviorDAO.getAllBehaviorTypes();
            request.setAttribute("behaviorTypes", behaviorTypes);
            
            // Forward to behavior management page
            request.getRequestDispatcher("/WEB-INF/views/teacher/behavior.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading behavior records", e);
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
            
            // Get teacher ID from the user object
            int teacherId = user.getUserId();
            
            // Process the form submission based on the action
            String action = request.getParameter("action");
            
            if ("addBehavior".equals(action)) {
                // Get form parameters
                int studentId = Integer.parseInt(request.getParameter("studentId"));
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                String behaviorType = request.getParameter("behaviorType");
                String description = request.getParameter("description");
                String actionTaken = request.getParameter("actionTaken");
                
                // Add the behavior record
                boolean success = behaviorDAO.addBehaviorRecord(studentId, teacherId, behaviorType, description, actionTaken);
                
                if (success) {
                    request.setAttribute("successMessage", "Behavior record added successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to add behavior record");
                }
            } else if ("updateBehavior".equals(action)) {
                // Get form parameters
                int behaviorId = Integer.parseInt(request.getParameter("behaviorId"));
                String behaviorType = request.getParameter("behaviorType");
                String description = request.getParameter("description");
                String actionTaken = request.getParameter("actionTaken");
                
                // Update the behavior record
                boolean success = behaviorDAO.updateBehaviorRecord(behaviorId, behaviorType, description, actionTaken);
                
                if (success) {
                    request.setAttribute("successMessage", "Behavior record updated successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to update behavior record");
                }
            } else if ("deleteBehavior".equals(action)) {
                // Get behavior ID
                int behaviorId = Integer.parseInt(request.getParameter("behaviorId"));
                
                // Delete the behavior record
                boolean success = behaviorDAO.deleteBehaviorRecord(behaviorId);
                
                if (success) {
                    request.setAttribute("successMessage", "Behavior record deleted successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to delete behavior record");
                }
            }
            
            // Redirect back to the behavior page
            response.sendRedirect(request.getContextPath() + "/teacher/behavior");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing behavior action", e);
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 