package com.sms.controller.nurse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.dao.AppointmentDAO;
import com.sms.dao.NurseDAO;
import com.sms.model.Nurse;
import com.sms.model.User;

/**
 * Servlet to handle nurse appointments
 */
@WebServlet("/nurse/appointments")
public class AppointmentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AppointmentDAO appointmentDAO;
    private NurseDAO nurseDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        appointmentDAO = new AppointmentDAO();
        nurseDAO = new NurseDAO();
    }
    
    /**
     * Handle GET requests - show nurse appointments
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"nurse".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get nurse ID from user ID
            Nurse nurse = nurseDAO.getNurseByUserId(user.getUserId());
            
            if (nurse == null) {
                throw new Exception("Nurse profile not found for current user");
            }
            
            // Get nurse appointments (we need to add this method to AppointmentDAO)
            List<Map<String, Object>> nurseAppointments = appointmentDAO.getNurseAppointments(nurse.getNurseId());
            request.setAttribute("appointments", nurseAppointments);
            
            // Get today's appointments
            List<Map<String, Object>> todayAppointments = appointmentDAO.getTodayAppointmentsForNurse(nurse.getNurseId());
            request.setAttribute("todayAppointments", todayAppointments);
            
            // Forward to appointments page
            request.getRequestDispatcher("/nurse/appointments.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading appointments: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 