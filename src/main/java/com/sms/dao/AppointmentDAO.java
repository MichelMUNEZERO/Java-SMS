package com.sms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.sql.Time;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.sms.util.DBConnection;

/**
 * Data Access Object for Appointment-related database operations
 */
public class AppointmentDAO {
    private static final Logger LOGGER = Logger.getLogger(AppointmentDAO.class.getName());
    
    /**
     * Count appointments scheduled for today
     * @return Number of appointments today
     */
    public int countTodayAppointments() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) FROM Appointment WHERE Date = CURDATE()";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting today's appointments", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return count;
    }
    
    /**
     * Count upcoming appointments within a date range
     * @param startDate Start date for range
     * @param endDate End date for range
     * @return Number of appointments in range
     */
    public int countAppointmentsInRange(Date startDate, Date endDate) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) FROM Appointment WHERE Date BETWEEN ? AND ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setDate(1, startDate);
            pstmt.setDate(2, endDate);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting appointments in range", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return count;
    }
    
    /**
     * Count total appointments in the system
     * @return Total number of appointments
     */
    public int countTotalAppointments() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) FROM Appointment";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting total appointments", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return count;
    }
    
    /**
     * Gets the count of appointments for a teacher on a specific date
     * 
     * @param teacherId The teacher ID
     * @param dateFilter The date filter (e.g., "CURDATE()" for today)
     * @return Count of appointments
     */
    public int getAppointmentCountByTeacherIdAndDate(int teacherId, String dateFilter) {
        int count = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) FROM appointments WHERE teacher_id = ? AND DATE(appointment_date) = " + dateFilter;
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, teacherId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting appointment count for teacher ID: " + teacherId, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return count;
    }
    
    /**
     * Get all appointments for a specific parent
     * @param parentId The ID of the parent
     * @return List of appointments as maps
     */
    public List<Map<String, Object>> getAppointmentsByParentId(int parentId) {
        List<Map<String, Object>> appointments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT a.*, s.first_name as student_first_name, s.last_name as student_last_name, " +
                         "CASE " +
                         "  WHEN a.staff_type = 'teacher' THEN (SELECT CONCAT(first_name, ' ', last_name) FROM Teachers WHERE teacher_id = a.staff_id) " +
                         "  WHEN a.staff_type = 'admin' THEN (SELECT CONCAT(first_name, ' ', last_name) FROM Admins WHERE admin_id = a.staff_id) " +
                         "END as staff_name, " +
                         "CASE " +
                         "  WHEN a.staff_type = 'teacher' THEN 'Teacher' " +
                         "  WHEN a.staff_type = 'admin' THEN 'Administrator' " +
                         "END as staff_role " +
                         "FROM Appointments a " +
                         "JOIN Students s ON a.student_id = s.student_id " +
                         "WHERE a.parent_id = ? " +
                         "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, parentId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> appointment = new HashMap<>();
                appointment.put("appointmentId", rs.getInt("appointment_id"));
                appointment.put("parentId", rs.getInt("parent_id"));
                appointment.put("staffId", rs.getInt("staff_id"));
                appointment.put("staffType", rs.getString("staff_type"));
                appointment.put("staffName", rs.getString("staff_name"));
                appointment.put("staffRole", rs.getString("staff_role"));
                appointment.put("studentId", rs.getInt("student_id"));
                appointment.put("studentName", rs.getString("student_first_name") + " " + rs.getString("student_last_name"));
                appointment.put("appointmentDate", rs.getDate("appointment_date"));
                appointment.put("appointmentTime", rs.getTime("appointment_time"));
                appointment.put("purpose", rs.getString("purpose"));
                appointment.put("status", rs.getString("status"));
                appointment.put("notes", rs.getString("notes"));
                appointment.put("createdAt", rs.getTimestamp("created_at"));
                
                appointments.add(appointment);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting appointments for parent ID: " + parentId, e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return appointments;
    }
    
    /**
     * Create a new appointment
     * @param parentId The parent ID
     * @param staffId The staff ID (teacher or admin)
     * @param staffType The type of staff ("teacher" or "admin")
     * @param studentId The student ID
     * @param appointmentDate The date of the appointment
     * @param appointmentTime The time of the appointment
     * @param purpose The purpose of the appointment
     * @return true if successful, false otherwise
     */
    public boolean createAppointment(int parentId, int staffId, String staffType, int studentId, 
                                   Date appointmentDate, Time appointmentTime, String purpose) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO Appointments (parent_id, staff_id, staff_type, student_id, " +
                         "appointment_date, appointment_time, purpose, status, created_at) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, 'pending', NOW())";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, parentId);
            pstmt.setInt(2, staffId);
            pstmt.setString(3, staffType);
            pstmt.setInt(4, studentId);
            pstmt.setDate(5, appointmentDate);
            pstmt.setTime(6, appointmentTime);
            pstmt.setString(7, purpose);
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating appointment", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, null);
        }
        
        return success;
    }
    
    /**
     * Get all appointments from the database
     * @return List of all appointments as maps
     */
    public List<Map<String, Object>> getAllAppointments() {
        List<Map<String, Object>> appointments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT a.*, " +
                         "s.first_name as student_first_name, s.last_name as student_last_name, " +
                         "p.first_name as parent_first_name, p.last_name as parent_last_name, " +
                         "CASE " +
                         "  WHEN a.teacher_id IS NOT NULL THEN (SELECT CONCAT(first_name, ' ', last_name) FROM teachers WHERE teacher_id = a.teacher_id) " +
                         "END as teacher_name " +
                         "FROM appointments a " +
                         "LEFT JOIN students s ON a.student_id = s.student_id " +
                         "LEFT JOIN parents p ON a.parent_id = p.parent_id " +
                         "ORDER BY a.appointment_date DESC, a.appointment_date DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> appointment = new HashMap<>();
                appointment.put("appointmentId", rs.getInt("appointment_id"));
                appointment.put("title", rs.getString("title"));
                appointment.put("description", rs.getString("description"));
                appointment.put("appointmentDate", rs.getTimestamp("appointment_date"));
                appointment.put("status", rs.getString("status"));
                
                // Parent info
                Integer parentId = rs.getInt("parent_id");
                if (!rs.wasNull()) {
                    appointment.put("parentId", parentId);
                    appointment.put("parentName", rs.getString("parent_first_name") + " " + rs.getString("parent_last_name"));
                }
                
                // Student info
                Integer studentId = rs.getInt("student_id");
                if (!rs.wasNull()) {
                    appointment.put("studentId", studentId);
                    appointment.put("studentName", rs.getString("student_first_name") + " " + rs.getString("student_last_name"));
                }
                
                // Teacher info
                Integer teacherId = rs.getInt("teacher_id");
                if (!rs.wasNull()) {
                    appointment.put("teacherId", teacherId);
                    appointment.put("teacherName", rs.getString("teacher_name"));
                }
                
                // Created by info
                Integer createdBy = rs.getInt("created_by");
                if (!rs.wasNull()) {
                    appointment.put("createdBy", createdBy);
                }
                
                appointments.add(appointment);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all appointments", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return appointments;
    }
    
    /**
     * Update appointment status and notes
     * @param appointmentId The appointment ID
     * @param status The new status
     * @param notes Additional notes
     * @return true if successful, false otherwise
     */
    public boolean updateAppointmentStatus(int appointmentId, String status, String notes) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE appointments SET status = ?, description = ? WHERE appointment_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setString(2, notes);
            pstmt.setInt(3, appointmentId);
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating appointment status for ID: " + appointmentId, e);
        } finally {
            DBConnection.closeAll(conn, pstmt, null);
        }
        
        return success;
    }
    
    /**
     * Get appointments for a specific nurse
     * 
     * @param nurseId The nurse ID
     * @return List of appointments as maps
     */
    public List<Map<String, Object>> getNurseAppointments(int nurseId) {
        List<Map<String, Object>> appointments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT a.*, s.first_name AS student_first_name, s.last_name AS student_last_name, " +
                         "d.first_name AS doctor_first_name, d.last_name AS doctor_last_name, " +
                         "n.first_name AS nurse_first_name, n.last_name AS nurse_last_name " +
                         "FROM appointments a " +
                         "JOIN students s ON a.student_id = s.student_id " +
                         "LEFT JOIN doctors d ON a.doctor_id = d.doctor_id " +
                         "LEFT JOIN nurses n ON a.nurse_id = n.nurse_id " +
                         "WHERE a.nurse_id = ? " +
                         "ORDER BY a.appointment_date DESC, a.appointment_time ASC";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, nurseId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> appointment = new HashMap<>();
                appointment.put("appointmentId", rs.getInt("appointment_id"));
                appointment.put("studentId", rs.getInt("student_id"));
                appointment.put("studentName", rs.getString("student_first_name") + " " + rs.getString("student_last_name"));
                appointment.put("appointmentDate", rs.getDate("appointment_date"));
                appointment.put("appointmentTime", rs.getTime("appointment_time"));
                appointment.put("purpose", rs.getString("purpose"));
                appointment.put("status", rs.getString("status"));
                
                Integer doctorId = rs.getInt("doctor_id");
                if (!rs.wasNull()) {
                    appointment.put("doctorId", doctorId);
                    appointment.put("doctorName", rs.getString("doctor_first_name") + " " + rs.getString("doctor_last_name"));
                }
                
                appointments.add(appointment);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting nurse appointments for nurse ID: " + nurseId, e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return appointments;
    }
    
    /**
     * Get today's appointments for a specific nurse
     * 
     * @param nurseId The nurse ID
     * @return List of today's appointments as maps
     */
    public List<Map<String, Object>> getTodayAppointmentsForNurse(int nurseId) {
        List<Map<String, Object>> appointments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT a.*, s.first_name AS student_first_name, s.last_name AS student_last_name, " +
                         "d.first_name AS doctor_first_name, d.last_name AS doctor_last_name " +
                         "FROM appointments a " +
                         "JOIN students s ON a.student_id = s.student_id " +
                         "LEFT JOIN doctors d ON a.doctor_id = d.doctor_id " +
                         "WHERE a.nurse_id = ? AND a.appointment_date = CURRENT_DATE " +
                         "ORDER BY a.appointment_time ASC";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, nurseId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> appointment = new HashMap<>();
                appointment.put("appointmentId", rs.getInt("appointment_id"));
                appointment.put("studentId", rs.getInt("student_id"));
                appointment.put("studentName", rs.getString("student_first_name") + " " + rs.getString("student_last_name"));
                appointment.put("appointmentTime", rs.getTime("appointment_time"));
                appointment.put("purpose", rs.getString("purpose"));
                appointment.put("status", rs.getString("status"));
                
                Integer doctorId = rs.getInt("doctor_id");
                if (!rs.wasNull()) {
                    appointment.put("doctorId", doctorId);
                    appointment.put("doctorName", rs.getString("doctor_first_name") + " " + rs.getString("doctor_last_name"));
                }
                
                appointments.add(appointment);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting today's appointments for nurse ID: " + nurseId, e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return appointments;
    }
    
    /**
     * Get appointments for a specific doctor
     * 
     * @param doctorId The doctor ID
     * @return List of appointments for the doctor
     */
    public List<Map<String, Object>> getDoctorAppointments(int doctorId) {
        List<Map<String, Object>> appointments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT a.*, s.first_name AS student_first_name, s.last_name AS student_last_name " +
                         "FROM appointments a " +
                         "JOIN students s ON a.student_id = s.student_id " +
                         "WHERE a.teacher_id = ? " +  // Changed from doctor_id to teacher_id since doctor uses the teacher table
                         "ORDER BY a.appointment_date DESC";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, doctorId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> appointment = new HashMap<>();
                appointment.put("id", rs.getInt("appointment_id"));
                appointment.put("studentId", rs.getInt("student_id"));
                appointment.put("studentName", rs.getString("student_first_name") + " " + rs.getString("student_last_name"));
                appointment.put("date", rs.getTimestamp("appointment_date"));
                // The time is now part of the datetime field
                appointment.put("time", rs.getTimestamp("appointment_date"));
                appointment.put("purpose", rs.getString("title"));  // Use title as purpose
                appointment.put("status", rs.getString("status"));
                appointment.put("notes", rs.getString("description")); // Use description as notes
                
                appointments.add(appointment);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting doctor appointments for doctor ID: " + doctorId, e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return appointments;
    }
    
    /**
     * Create a new doctor appointment
     * 
     * @param doctorId The doctor ID
     * @param studentId The student ID
     * @param appointmentDate The date of the appointment
     * @param appointmentTime The time of the appointment
     * @param appointmentType The type/purpose of the appointment
     * @param notes Additional notes for the appointment
     * @return true if successful, false otherwise
     */
    public boolean createDoctorAppointment(int doctorId, int studentId, Date appointmentDate, 
                                         Time appointmentTime, String appointmentType, String notes) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            
            // Convert separate date and time to a timestamp
            String dateTimeStr = appointmentDate.toString() + " " + appointmentTime.toString();
            java.sql.Timestamp appointmentDateTime = java.sql.Timestamp.valueOf(dateTimeStr);
            
            String sql = "INSERT INTO appointments (teacher_id, student_id, appointment_date, " +
                        "title, description, status, created_by) " +
                        "VALUES (?, ?, ?, ?, ?, 'Scheduled', ?)";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, doctorId);  // Use teacher_id field for doctor
            pstmt.setInt(2, studentId);
            pstmt.setTimestamp(3, appointmentDateTime);
            pstmt.setString(4, appointmentType);  // Use appointmentType as title
            pstmt.setString(5, notes);  // Use notes as description
            pstmt.setInt(6, doctorId);  // Set the doctor as the creator
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating doctor appointment", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, null);
        }
        
        return success;
    }
} 