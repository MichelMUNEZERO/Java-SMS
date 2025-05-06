package com.sms.controller.doctor;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.dao.AppointmentDAO;
import com.sms.dao.DoctorDAO;
import com.sms.dao.StudentDAO;
import com.sms.model.Doctor;
import com.sms.model.Student;
import com.sms.model.User;

/**
 * Servlet to handle doctor's appointments management
 */
@WebServlet("/doctor/appointments")
public class DoctorAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentDAO appointmentDAO;
    private DoctorDAO doctorDAO;
    private StudentDAO studentDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        appointmentDAO = new AppointmentDAO();
        doctorDAO = new DoctorDAO();
        studentDAO = new StudentDAO();
    }
    
    /**
     * Handle GET requests - show appointments page
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"doctor".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get doctor ID from user
            int userId = user.getUserId();
            Doctor doctor = doctorDAO.getDoctorByUserId(userId);
            
            if (doctor == null) {
                request.setAttribute("error", "Doctor profile not found");
                request.getRequestDispatcher("/doctor/appointments.jsp").forward(request, response);
                return;
            }
            
            // Get today's appointments
            int todayAppointments = appointmentDAO.countTodayAppointments();
            request.setAttribute("todayAppointments", todayAppointments);
            
            // Get all students for the dropdown
            List<Student> students = studentDAO.getAllStudents();
            request.setAttribute("studentsList", students);
            
            // Get doctor's appointments from the database
            List<Map<String, Object>> appointments = appointmentDAO.getDoctorAppointments(doctor.getDoctorId());
            request.setAttribute("appointments", appointments);
            
            // Forward to the appointments page
            request.getRequestDispatcher("/doctor/appointments.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading appointments: " + e.getMessage());
            request.getRequestDispatcher("/doctor/appointments.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle POST requests - update appointment status or create new appointment
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"doctor".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            // Get doctor ID from user
            int userId = user.getUserId();
            Doctor doctor = doctorDAO.getDoctorByUserId(userId);
            
            if (doctor == null) {
                session.setAttribute("error", "Doctor profile not found");
                response.sendRedirect(request.getContextPath() + "/doctor/appointments");
                return;
            }
            
            if ("updateStatus".equals(action)) {
                // Update appointment status logic
                int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
                String status = request.getParameter("status");
                
                // Call the DAO to update status
                // appointmentDAO.updateAppointmentStatus(appointmentId, status);
                
                session.setAttribute("message", "Appointment status updated successfully");
            } 
            else if ("create".equals(action)) {
                // Create new appointment logic
                int studentId = Integer.parseInt(request.getParameter("studentId"));
                String appointmentDateStr = request.getParameter("appointmentDate");
                String appointmentTimeStr = request.getParameter("appointmentTime");
                String appointmentType = request.getParameter("appointmentType");
                String notes = request.getParameter("notes");
                
                // Convert the date and time strings to SQL objects
                java.sql.Date appointmentDate = java.sql.Date.valueOf(appointmentDateStr);
                java.sql.Time appointmentTime = java.sql.Time.valueOf(appointmentTimeStr + ":00");
                
                // Create the appointment
                boolean success = appointmentDAO.createDoctorAppointment(
                    doctor.getDoctorId(), 
                    studentId, 
                    appointmentDate, 
                    appointmentTime, 
                    appointmentType, 
                    notes
                );
                
                if (success) {
                    session.setAttribute("message", "Appointment created successfully");
                } else {
                    session.setAttribute("error", "Failed to create appointment");
                }
            }
            
            // Redirect back to appointments page
            response.sendRedirect(request.getContextPath() + "/doctor/appointments");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error processing appointment: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/doctor/appointments");
        }
    }
} 