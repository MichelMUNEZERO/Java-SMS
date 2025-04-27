package com.sms.controller.parent;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.List;
import java.util.Map;

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
import com.sms.model.Parent;
import com.sms.model.User;

/**
 * Servlet to handle appointment booking for parents
 */
@WebServlet("/parent/appointments")
public class AppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
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
     * Handle GET requests - show appointment booking form and existing appointments
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and has parent role
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            // Not logged in, redirect to login page
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"parent".equals(user.getRole().toLowerCase())) {
            // Not a parent, redirect to appropriate dashboard
            response.sendRedirect(request.getContextPath() + "/" + user.getRole().toLowerCase() + "/dashboard");
            return;
        }
        
        try {
            // Get parent by user ID
            int userId = user.getUserId();
            Parent parent = parentDAO.getParentByUserId(userId);
            
            // Get list of teachers for the appointment selection
            List<Map<String, Object>> teachers = teacherDAO.getAllTeachersWithBasicInfo();
            request.setAttribute("teachers", teachers);
            
            // Get list of admin staff for the appointment selection
            List<Map<String, Object>> adminStaff = teacherDAO.getAdminStaff();
            request.setAttribute("adminStaff", adminStaff);
            
            // Get children of this parent
            List<Map<String, Object>> children = studentDAO.getStudentsByParentAsMap(parent.getId());
            request.setAttribute("children", children);
            
            // Get existing appointments for this parent
            List<Map<String, Object>> appointments = appointmentDAO.getAppointmentsByParentId(parent.getId());
            request.setAttribute("appointments", appointments);
            
            // Forward to the appointments page
            request.getRequestDispatcher("/WEB-INF/views/parent/appointments.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Log the error and show error page
            getServletContext().log("Error in AppointmentServlet", e);
            request.setAttribute("errorMessage", "Error retrieving appointment information");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle POST requests - book a new appointment
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and has parent role
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            // Not logged in, redirect to login page
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"parent".equals(user.getRole().toLowerCase())) {
            // Not a parent, redirect to appropriate dashboard
            response.sendRedirect(request.getContextPath() + "/" + user.getRole().toLowerCase() + "/dashboard");
            return;
        }
        
        try {
            // Get parent by user ID
            int userId = user.getUserId();
            Parent parent = parentDAO.getParentByUserId(userId);
            
            // Get form parameters
            String staffType = request.getParameter("staffType"); // "teacher" or "admin"
            int staffId = Integer.parseInt(request.getParameter("staffId"));
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            String appointmentDate = request.getParameter("appointmentDate");
            String appointmentTime = request.getParameter("appointmentTime");
            String purpose = request.getParameter("purpose");
            
            // Create appointment
            boolean success = appointmentDAO.createAppointment(
                parent.getId(), 
                staffId, 
                staffType,
                studentId, 
                Date.valueOf(appointmentDate), 
                Time.valueOf(appointmentTime + ":00"), 
                purpose
            );
            
            if (success) {
                // Set success message and redirect
                session.setAttribute("successMessage", "Appointment booked successfully");
            } else {
                // Set error message
                session.setAttribute("errorMessage", "Failed to book appointment. Please try again.");
            }
            
            // Redirect back to appointments page
            response.sendRedirect(request.getContextPath() + "/parent/appointments");
            
        } catch (Exception e) {
            // Log the error and show error page
            getServletContext().log("Error in AppointmentServlet (POST)", e);
            request.setAttribute("errorMessage", "Error booking appointment");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 