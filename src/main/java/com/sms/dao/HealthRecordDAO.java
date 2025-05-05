package com.sms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.sms.model.HealthRecord;
import com.sms.util.DBConnection;

/**
 * Data Access Object for Health Record entities
 */
public class HealthRecordDAO {
    private static final Logger LOGGER = Logger.getLogger(HealthRecordDAO.class.getName());
    
    /**
     * Get health records for a specific student
     * 
     * @param studentId The student ID
     * @return List of health records
     */
    public List<HealthRecord> getHealthRecordsByStudentId(int studentId) {
        List<HealthRecord> healthRecords = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT hr.*, d.first_name AS doctor_first_name, d.last_name AS doctor_last_name, " +
                         "n.first_name AS nurse_first_name, n.last_name AS nurse_last_name " +
                         "FROM health_records hr " +
                         "LEFT JOIN doctors d ON hr.doctor_id = d.doctor_id " +
                         "LEFT JOIN nurses n ON hr.nurse_id = n.nurse_id " +
                         "WHERE hr.student_id = ? " +
                         "ORDER BY hr.record_date DESC";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                HealthRecord record = mapResultSetToHealthRecord(rs);
                healthRecords.add(record);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting health records for student ID: " + studentId, e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return healthRecords;
    }
    
    /**
     * Add a new health record
     * 
     * @param record The health record to add
     * @return true if successful, false otherwise
     */
    public boolean addHealthRecord(HealthRecord record) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO health_records (student_id, record_date, record_type, " +
                         "description, treatment, medication, doctor_id, nurse_id, next_appointment, " +
                         "notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, record.getStudentId());
            pstmt.setDate(2, new java.sql.Date(record.getRecordDate().getTime()));
            pstmt.setString(3, record.getRecordType());
            pstmt.setString(4, record.getDescription());
            pstmt.setString(5, record.getTreatment());
            pstmt.setString(6, record.getMedication());
            
            if (record.getDoctorId() != null) {
                pstmt.setInt(7, record.getDoctorId());
            } else {
                pstmt.setNull(7, java.sql.Types.INTEGER);
            }
            
            if (record.getNurseId() != null) {
                pstmt.setInt(8, record.getNurseId());
            } else {
                pstmt.setNull(8, java.sql.Types.INTEGER);
            }
            
            if (record.getNextAppointment() != null) {
                pstmt.setDate(9, new java.sql.Date(record.getNextAppointment().getTime()));
            } else {
                pstmt.setNull(9, java.sql.Types.DATE);
            }
            
            pstmt.setString(10, record.getNotes());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding health record", e);
            return false;
        } finally {
            DBConnection.closeAll(conn, pstmt, null);
        }
    }
    
    /**
     * Update an existing health record
     * 
     * @param record The health record to update
     * @return true if successful, false otherwise
     */
    public boolean updateHealthRecord(HealthRecord record) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE health_records SET record_date = ?, record_type = ?, " +
                         "description = ?, treatment = ?, medication = ?, doctor_id = ?, " +
                         "nurse_id = ?, next_appointment = ?, notes = ? " +
                         "WHERE record_id = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setDate(1, new java.sql.Date(record.getRecordDate().getTime()));
            pstmt.setString(2, record.getRecordType());
            pstmt.setString(3, record.getDescription());
            pstmt.setString(4, record.getTreatment());
            pstmt.setString(5, record.getMedication());
            
            if (record.getDoctorId() != null) {
                pstmt.setInt(6, record.getDoctorId());
            } else {
                pstmt.setNull(6, java.sql.Types.INTEGER);
            }
            
            if (record.getNurseId() != null) {
                pstmt.setInt(7, record.getNurseId());
            } else {
                pstmt.setNull(7, java.sql.Types.INTEGER);
            }
            
            if (record.getNextAppointment() != null) {
                pstmt.setDate(8, new java.sql.Date(record.getNextAppointment().getTime()));
            } else {
                pstmt.setNull(8, java.sql.Types.DATE);
            }
            
            pstmt.setString(9, record.getNotes());
            pstmt.setInt(10, record.getRecordId());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating health record ID: " + record.getRecordId(), e);
            return false;
        } finally {
            DBConnection.closeAll(conn, pstmt, null);
        }
    }
    
    /**
     * Map ResultSet to HealthRecord object
     * 
     * @param rs The ResultSet
     * @return HealthRecord object
     * @throws SQLException If an SQL error occurs
     */
    private HealthRecord mapResultSetToHealthRecord(ResultSet rs) throws SQLException {
        HealthRecord record = new HealthRecord();
        record.setRecordId(rs.getInt("record_id"));
        record.setStudentId(rs.getInt("student_id"));
        record.setRecordDate(rs.getDate("record_date"));
        record.setRecordType(rs.getString("record_type"));
        record.setDescription(rs.getString("description"));
        record.setTreatment(rs.getString("treatment"));
        record.setMedication(rs.getString("medication"));
        
        Integer doctorId = rs.getInt("doctor_id");
        if (!rs.wasNull()) {
            record.setDoctorId(doctorId);
            record.setDoctorName(rs.getString("doctor_first_name") + " " + rs.getString("doctor_last_name"));
        }
        
        Integer nurseId = rs.getInt("nurse_id");
        if (!rs.wasNull()) {
            record.setNurseId(nurseId);
            record.setNurseName(rs.getString("nurse_first_name") + " " + rs.getString("nurse_last_name"));
        }
        
        java.sql.Date nextAppointment = rs.getDate("next_appointment");
        if (nextAppointment != null) {
            record.setNextAppointment(new Date(nextAppointment.getTime()));
        }
        
        record.setNotes(rs.getString("notes"));
        
        return record;
    }
} 