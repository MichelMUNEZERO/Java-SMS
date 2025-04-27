package com.sms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.sms.model.Doctor;
import com.sms.util.DBConnection;

/**
 * Data Access Object for Doctor entities
 */
public class DoctorDAO {
    private static final Logger LOGGER = Logger.getLogger(DoctorDAO.class.getName());
    
    /**
     * Get all doctors from the database
     * 
     * @return List of all doctors
     */
    public List<Doctor> getAllDoctors() {
        List<Doctor> doctors = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM doctors ORDER BY first_name, last_name";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Doctor doctor = mapResultSetToDoctor(rs);
                doctors.add(doctor);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all doctors", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return doctors;
    }
    
    /**
     * Get a doctor by ID
     * 
     * @param doctorId The doctor ID
     * @return Doctor object if found, null otherwise
     */
    public Doctor getDoctorById(int doctorId) {
        Doctor doctor = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM doctors WHERE doctor_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, doctorId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                doctor = mapResultSetToDoctor(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting doctor by ID: " + doctorId, e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return doctor;
    }
    
    /**
     * Add a new doctor to the database
     * 
     * @param doctor The doctor to add
     * @return true if successful, false otherwise
     */
    public boolean addDoctor(Doctor doctor) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO doctors (first_name, last_name, email, phone, specialization, hospital, user_id) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, doctor.getFirstName());
            pstmt.setString(2, doctor.getLastName());
            pstmt.setString(3, doctor.getEmail());
            pstmt.setString(4, doctor.getPhone());
            pstmt.setString(5, doctor.getSpecialization());
            pstmt.setString(6, doctor.getHospital());
            
            if (doctor.getUserId() != null) {
                pstmt.setInt(7, doctor.getUserId());
            } else {
                pstmt.setNull(7, java.sql.Types.INTEGER);
            }
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    doctor.setDoctorId(rs.getInt(1));
                }
                success = true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding doctor", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return success;
    }
    
    /**
     * Update an existing doctor in the database
     * 
     * @param doctor The doctor to update
     * @return true if successful, false otherwise
     */
    public boolean updateDoctor(Doctor doctor) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE doctors SET first_name = ?, last_name = ?, email = ?, " +
                        "phone = ?, specialization = ?, hospital = ?, user_id = ? " +
                        "WHERE doctor_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, doctor.getFirstName());
            pstmt.setString(2, doctor.getLastName());
            pstmt.setString(3, doctor.getEmail());
            pstmt.setString(4, doctor.getPhone());
            pstmt.setString(5, doctor.getSpecialization());
            pstmt.setString(6, doctor.getHospital());
            
            if (doctor.getUserId() != null) {
                pstmt.setInt(7, doctor.getUserId());
            } else {
                pstmt.setNull(7, java.sql.Types.INTEGER);
            }
            
            pstmt.setInt(8, doctor.getDoctorId());
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating doctor", e);
        } finally {
            DBConnection.closeStatement(pstmt);
            DBConnection.closeConnection(conn);
        }
        
        return success;
    }
    
    /**
     * Delete a doctor from the database
     * 
     * @param doctorId The ID of the doctor to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteDoctor(int doctorId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM doctors WHERE doctor_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, doctorId);
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting doctor", e);
        } finally {
            DBConnection.closeStatement(pstmt);
            DBConnection.closeConnection(conn);
        }
        
        return success;
    }
    
    /**
     * Helper method to map a ResultSet row to a Doctor object
     * 
     * @param rs The ResultSet containing doctor data
     * @return A Doctor object
     * @throws SQLException If there's an error reading from the ResultSet
     */
    private Doctor mapResultSetToDoctor(ResultSet rs) throws SQLException {
        Doctor doctor = new Doctor();
        doctor.setDoctorId(rs.getInt("doctor_id"));
        doctor.setFirstName(rs.getString("first_name"));
        doctor.setLastName(rs.getString("last_name"));
        doctor.setEmail(rs.getString("email"));
        doctor.setPhone(rs.getString("phone"));
        doctor.setSpecialization(rs.getString("specialization"));
        doctor.setHospital(rs.getString("hospital"));
        
        int userId = rs.getInt("user_id");
        if (!rs.wasNull()) {
            doctor.setUserId(userId);
        }
        
        return doctor;
    }
} 