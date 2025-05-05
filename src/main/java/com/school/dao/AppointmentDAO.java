package com.school.dao;

import com.school.model.Appointment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {
    private Connection connection;

    public AppointmentDAO(Connection connection) {
        this.connection = connection;
    }

    public List<Appointment> getTeacherAppointments(int teacherId) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String query = "SELECT * FROM appointments WHERE teacher_id = ? ORDER BY appointment_date DESC";
        
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, teacherId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setAppointmentId(rs.getInt("appointment_id"));
                appointment.setTitle(rs.getString("title"));
                appointment.setDescription(rs.getString("description"));
                appointment.setAppointmentDate(rs.getTimestamp("appointment_date").toLocalDateTime());
                appointment.setStatus(rs.getString("status"));
                appointment.setCreatedBy(rs.getInt("created_by"));
                appointment.setStudentId(rs.getInt("student_id"));
                appointment.setParentId(rs.getInt("parent_id"));
                appointment.setTeacherId(rs.getInt("teacher_id"));
                
                appointments.add(appointment);
            }
        }
        
        return appointments;
    }

    public boolean createAppointment(Appointment appointment) throws SQLException {
        String query = "INSERT INTO appointments (title, description, appointment_date, status, created_by, student_id, parent_id, teacher_id) " +
                      "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement statement = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, appointment.getTitle());
            statement.setString(2, appointment.getDescription());
            statement.setTimestamp(3, Timestamp.valueOf(appointment.getAppointmentDate()));
            statement.setString(4, appointment.getStatus());
            statement.setInt(5, appointment.getCreatedBy());
            statement.setInt(6, appointment.getStudentId());
            statement.setInt(7, appointment.getParentId());
            statement.setInt(8, appointment.getTeacherId());
            
            int affectedRows = statement.executeUpdate();
            if (affectedRows == 0) {
                return false;
            }
            
            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    appointment.setAppointmentId(generatedKeys.getInt(1));
                }
            }
            return true;
        }
    }

    public boolean updateAppointmentStatus(int appointmentId, String status) throws SQLException {
        String query = "UPDATE appointments SET status = ? WHERE appointment_id = ?";
        
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, status);
            statement.setInt(2, appointmentId);
            
            return statement.executeUpdate() > 0;
        }
    }
} 