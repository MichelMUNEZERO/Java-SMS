package com.sms.controller.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.model.Appointment;
import com.sms.model.User;
import com.sms.util.DBConnection;

/**
 * Servlet for handling appointment management by the admin
 */
@WebServlet(urlPatterns = { 
    "/admin/appointments", 
    "/admin/appointments/new", 
    "/admin/appointments/view/*", 
    "/admin/appointments/update/*"
})
public class AppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in and is an admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String pathInfo = request.getServletPath();
        
        if (pathInfo.equals("/admin/appointments")) {
            // List all appointments
            List<Map<String, Object>> appointments = getAllAppointments();
            request.setAttribute("appointments", appointments);
            request.getRequestDispatcher("/admin/appointments.jsp").forward(request, response);
        } else if (pathInfo.equals("/admin/appointments/new")) {
            // Show form to create a new appointment
            request.getRequestDispatcher("/admin/appointment-form.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/admin/appointments/view/")) {
            // View details of an appointment
            String idStr = pathInfo.substring("/admin/appointments/view/".length());
            try {
                int id = Integer.parseInt(idStr);
                Map<String, Object> appointment = getAppointmentById(id);
                
                if (appointment != null) {
                    request.setAttribute("appointment", appointment);
                    request.getRequestDispatcher("/admin/appointment-view.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/appointments");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/appointments");
            }
        } else if (pathInfo.startsWith("/admin/appointments/update/")) {
            // Update appointment status
            String idStr = pathInfo.substring("/admin/appointments/update/".length());
            try {
                int id = Integer.parseInt(idStr);
                String status = request.getParameter("status");
                
                if (status != null && !status.isEmpty()) {
                    updateAppointmentStatus(id, status);
                }
                
                response.sendRedirect(request.getContextPath() + "/admin/appointments");
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/appointments");
            }
        }
    }
    
    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in and is an admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("update_status".equals(action)) {
            // Update appointment status
            String idStr = request.getParameter("id");
            String status = request.getParameter("status");
            String notes = request.getParameter("notes");
            
            if (idStr != null && !idStr.isEmpty() && status != null && !status.isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr);
                    updateAppointmentStatusAndNotes(id, status, notes);
                } catch (NumberFormatException e) {
                    // Ignore invalid ID
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/appointments");
        } else if ("add".equals(action)) {
            // Add a new appointment
            String purpose = request.getParameter("purpose");
            String responsibleStr = request.getParameter("responsible");
            String dateTimeStr = request.getParameter("dateTime");
            String status = request.getParameter("status");
            String notes = request.getParameter("notes");
            
            if (purpose != null && !purpose.isEmpty() && 
                dateTimeStr != null && !dateTimeStr.isEmpty() && 
                status != null && !status.isEmpty()) {
                
                try {
                    // Parse date and time
                    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                    Date dateTime = format.parse(dateTimeStr);
                    
                    // Parse responsible ID (if provided)
                    Integer responsible = null;
                    if (responsibleStr != null && !responsibleStr.isEmpty()) {
                        try {
                            responsible = Integer.parseInt(responsibleStr);
                        } catch (NumberFormatException e) {
                            // Ignore invalid ID
                        }
                    }
                    
                    // Create and save appointment
                    Appointment appointment = new Appointment();
                    appointment.setPurpose(purpose);
                    appointment.setResponsible(responsible);
                    appointment.setDate(dateTime);
                    appointment.setStatus(status);
                    appointment.setNotes(notes);
                    
                    addAppointment(appointment);
                } catch (ParseException e) {
                    // Handle date parsing error
                    request.setAttribute("error", "Invalid date format. Please use the date-time picker.");
                    request.getRequestDispatcher("/admin/appointment-form.jsp").forward(request, response);
                    return;
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/appointments");
        }
    }
    
    /**
     * Get all appointments with user information
     * @return list of appointment maps with additional info
     */
    private List<Map<String, Object>> getAllAppointments() {
        List<Map<String, Object>> appointments = new ArrayList<>();
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT a.*, CONCAT(COALESCE(t.FirstName, ''), ' ', COALESCE(t.LastName, '')) AS TeacherName, " +
                         "CONCAT(COALESCE(s.first_name, ''), ' ', COALESCE(s.last_name, '')) AS StudentName " +
                         "FROM Appointment a " +
                         "LEFT JOIN Teachers t ON a.Responsible = t.TeacherId " +
                         "LEFT JOIN Students s ON a.Responsible = s.student_id " +
                         "ORDER BY a.Date DESC";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                
                while (rs.next()) {
                    Map<String, Object> appointment = new HashMap<>();
                    
                    // Appointment details
                    appointment.put("id", rs.getInt("AppointmentId"));
                    appointment.put("purpose", rs.getString("Purpose"));
                    appointment.put("responsible", rs.getInt("Responsible"));
                    appointment.put("date", rs.getTimestamp("Date"));
                    appointment.put("status", rs.getString("Status"));
                    appointment.put("notes", rs.getString("Notes"));
                    
                    // Responsible person name
                    String teacherName = rs.getString("TeacherName");
                    String studentName = rs.getString("StudentName");
                    
                    if (teacherName != null && !teacherName.trim().isEmpty()) {
                        appointment.put("responsibleName", teacherName + " (Teacher)");
                    } else if (studentName != null && !studentName.trim().isEmpty()) {
                        appointment.put("responsibleName", studentName + " (Student)");
                    } else {
                        appointment.put("responsibleName", "Unknown");
                    }
                    
                    appointments.add(appointment);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        
        return appointments;
    }
    
    /**
     * Get appointment by ID with additional details
     * @param id the appointment ID
     * @return map containing appointment details
     */
    private Map<String, Object> getAppointmentById(int id) {
        Map<String, Object> appointment = null;
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT a.*, CONCAT(COALESCE(t.FirstName, ''), ' ', COALESCE(t.LastName, '')) AS TeacherName, " +
                         "CONCAT(COALESCE(s.first_name, ''), ' ', COALESCE(s.last_name, '')) AS StudentName " +
                         "FROM Appointment a " +
                         "LEFT JOIN Teachers t ON a.Responsible = t.TeacherId " +
                         "LEFT JOIN Students s ON a.Responsible = s.student_id " +
                         "WHERE a.AppointmentId = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        appointment = new HashMap<>();
                        
                        // Appointment details
                        appointment.put("id", rs.getInt("AppointmentId"));
                        appointment.put("purpose", rs.getString("Purpose"));
                        appointment.put("responsible", rs.getInt("Responsible"));
                        appointment.put("date", rs.getTimestamp("Date"));
                        appointment.put("status", rs.getString("Status"));
                        appointment.put("notes", rs.getString("Notes"));
                        
                        // Responsible person name
                        String teacherName = rs.getString("TeacherName");
                        String studentName = rs.getString("StudentName");
                        
                        if (teacherName != null && !teacherName.trim().isEmpty()) {
                            appointment.put("responsibleName", teacherName + " (Teacher)");
                        } else if (studentName != null && !studentName.trim().isEmpty()) {
                            appointment.put("responsibleName", studentName + " (Student)");
                        } else {
                            appointment.put("responsibleName", "Unknown");
                        }
                    }
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        
        return appointment;
    }
    
    /**
     * Update the status of an appointment
     * @param id the appointment ID
     * @param status the new status
     * @return true if update successful, false otherwise
     */
    private boolean updateAppointmentStatus(int id, String status) {
        Connection conn = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE Appointment SET Status = ? WHERE AppointmentId = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, status);
                stmt.setInt(2, id);
                
                int rowsAffected = stmt.executeUpdate();
                success = rowsAffected > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        
        return success;
    }
    
    /**
     * Update the status and notes of an appointment
     * @param id the appointment ID
     * @param status the new status
     * @param notes the new notes
     * @return true if update successful, false otherwise
     */
    private boolean updateAppointmentStatusAndNotes(int id, String status, String notes) {
        Connection conn = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE Appointment SET Status = ?, Notes = ? WHERE AppointmentId = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, status);
                stmt.setString(2, notes);
                stmt.setInt(3, id);
                
                int rowsAffected = stmt.executeUpdate();
                success = rowsAffected > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        
        return success;
    }
    
    /**
     * Add a new appointment
     * @param appointment the appointment to add
     * @return true if addition successful, false otherwise
     */
    private boolean addAppointment(Appointment appointment) {
        Connection conn = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO Appointment (Purpose, Responsible, Date, Status, Notes) VALUES (?, ?, ?, ?, ?)";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, appointment.getPurpose());
                
                if (appointment.getResponsible() != null) {
                    stmt.setInt(2, appointment.getResponsible());
                } else {
                    stmt.setNull(2, java.sql.Types.INTEGER);
                }
                
                stmt.setTimestamp(3, new Timestamp(appointment.getDate().getTime()));
                stmt.setString(4, appointment.getStatus());
                stmt.setString(5, appointment.getNotes());
                
                int rowsAffected = stmt.executeUpdate();
                success = rowsAffected > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        
        return success;
    }
} 