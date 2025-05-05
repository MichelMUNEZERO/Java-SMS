package com.sms.controller.teacher;

import com.school.dao.AppointmentDAO;
import com.school.model.Appointment;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet(name = "AppointmentsServlet", value = "/teacher/appointments")
public class AppointmentsServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        // Get database connection from context
        Connection connection = (Connection) getServletContext().getAttribute("dbConnection");
        appointmentDAO = new AppointmentDAO(connection);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Integer teacherId = (Integer) session.getAttribute("teacherId");
            
            if (teacherId == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            List<Appointment> appointments = appointmentDAO.getTeacherAppointments(teacherId);
            request.setAttribute("appointments", appointments);
            request.getRequestDispatcher("/WEB-INF/views/teacher/appointments.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Error loading appointments: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/teacher/appointments.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            createAppointment(request, response);
        } else if ("updateStatus".equals(action)) {
            updateAppointmentStatus(request, response);
        }
    }

    private void createAppointment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Integer teacherId = (Integer) session.getAttribute("teacherId");
            
            if (teacherId == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            Appointment appointment = new Appointment();
            appointment.setTitle(request.getParameter("title"));
            appointment.setDescription(request.getParameter("description"));
            
            String dateTimeStr = request.getParameter("appointmentDate");
            LocalDateTime appointmentDate = LocalDateTime.parse(dateTimeStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            appointment.setAppointmentDate(appointmentDate);
            
            appointment.setStatus("Scheduled");
            appointment.setCreatedBy(teacherId);
            appointment.setStudentId(Integer.parseInt(request.getParameter("studentId")));
            appointment.setParentId(Integer.parseInt(request.getParameter("parentId")));
            appointment.setTeacherId(teacherId);

            appointmentDAO.createAppointment(appointment);
            response.sendRedirect(request.getContextPath() + "/teacher/appointments");
        } catch (SQLException e) {
            request.setAttribute("error", "Error creating appointment: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/teacher/appointments.jsp").forward(request, response);
        }
    }

    private void updateAppointmentStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            String status = request.getParameter("status");
            
            appointmentDAO.updateAppointmentStatus(appointmentId, status);
            response.sendRedirect(request.getContextPath() + "/teacher/appointments");
        } catch (SQLException e) {
            request.setAttribute("error", "Error updating appointment status: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/teacher/appointments.jsp").forward(request, response);
        }
    }
} 