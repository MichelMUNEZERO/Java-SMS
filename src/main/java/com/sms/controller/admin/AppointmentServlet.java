package com.sms.controller.admin;

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

import com.sms.dao.AppointmentDAO;
import com.sms.dao.ParentDAO;
import com.sms.dao.StudentDAO;
import com.sms.dao.TeacherDAO;
import com.sms.model.User;

/**
 * Servlet to handle appointments management for admins
 */
@WebServlet("/admin/appointments")
public class AppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AppointmentServlet.class.getName());
    
    private AppointmentDAO appointmentDAO;
    private TeacherDAO teacherDAO;
    private ParentDAO parentDAO;
    private StudentDAO studentDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        appointmentDAO = new AppointmentDAO();
        teacherDAO = new TeacherDAO();
        parentDAO = new ParentDAO();
        studentDAO = new StudentDAO();
    }
    
    /**
     * Handle GET requests - show all appointments
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is logged in and is an admin
        if (user == null || !user.getRole().equals("admin")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get all appointments
            List<Map<String, Object>> appointments = getAllAppointments();
            request.setAttribute("appointments", appointments);
            
            // Forward to the appointments page
            request.getRequestDispatcher("/WEB-INF/views/admin/appointments.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Log the error and show error page
            LOGGER.log(Level.SEVERE, "Error in AdminAppointmentServlet", e);
            request.setAttribute("errorMessage", "Error retrieving appointment information");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle POST requests - update appointment status
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is logged in and is an admin
        if (user == null || !user.getRole().equals("admin")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get form parameters
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            String status = request.getParameter("status");
            String notes = request.getParameter("notes");
            
            // Update appointment
            boolean success = updateAppointmentStatus(appointmentId, status, notes);
            
            if (success) {
                // Set success message
                session.setAttribute("successMessage", "Appointment updated successfully");
            } else {
                // Set error message
                session.setAttribute("errorMessage", "Failed to update appointment. Please try again.");
            }
            
            // Redirect back to appointments page
            response.sendRedirect(request.getContextPath() + "/admin/appointments");
            
        } catch (Exception e) {
            // Log the error and show error page
            LOGGER.log(Level.SEVERE, "Error in AdminAppointmentServlet (POST)", e);
            request.setAttribute("errorMessage", "Error updating appointment");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Get all appointments from the database
     */
    private List<Map<String, Object>> getAllAppointments() {
        // This method should be implemented in AppointmentDAO
        // For now, we'll use a temporary placeholder
        return appointmentDAO.getAllAppointments();
    }
    
    /**
     * Update appointment status and notes
     */
    private boolean updateAppointmentStatus(int appointmentId, String status, String notes) {
        // This method should be implemented in AppointmentDAO
        // For now, we'll use a temporary placeholder
        return appointmentDAO.updateAppointmentStatus(appointmentId, status, notes);
    }
} 