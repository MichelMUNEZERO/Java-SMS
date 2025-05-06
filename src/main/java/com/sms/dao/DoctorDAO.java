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
     * Get a doctor by user ID
     * 
     * @param userId The user ID
     * @return Doctor object if found, null otherwise
     */
    public Doctor getDoctorByUserId(int userId) {
        Doctor doctor = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM doctors WHERE user_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                doctor = mapResultSetToDoctor(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting doctor by user ID: " + userId, e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return doctor;
    }
    
    /**
     * Add a new doctor to the database with a user account
     * 
     * @param doctor The doctor to add
     * @param username Username for the new user account
     * @param password Password for the new user account
     * @param role Role for the new user account (usually "doctor")
     * @return true if successful, false otherwise
     */
    public boolean addDoctorWithUserAccount(Doctor doctor, String username, String password, String role) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // Step 1: Create user account
            String createUserSql = "INSERT INTO users (username, password, role, email, active, created_at) " +
                                 "VALUES (?, ?, ?, ?, ?, NOW())";
            
            pstmt = conn.prepareStatement(createUserSql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            pstmt.setString(3, role);
            pstmt.setString(4, doctor.getEmail());
            pstmt.setBoolean(5, true); // Set account as active
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating user account failed, no rows affected.");
            }
            
            // Get the generated user ID
            rs = pstmt.getGeneratedKeys();
            int userId = -1;
            if (rs.next()) {
                userId = rs.getInt(1);
            } else {
                throw new SQLException("Creating user account failed, no ID obtained.");
            }
            
            // Clean up resources
            rs.close();
            pstmt.close();
            
            // Step 2: Create doctor with reference to user ID
            doctor.setUserId(userId);
            String createDoctorSql = "INSERT INTO doctors (first_name, last_name, email, phone, specialization, hospital, user_id) " +
                                  "VALUES (?, ?, ?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(createDoctorSql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, doctor.getFirstName());
            pstmt.setString(2, doctor.getLastName());
            pstmt.setString(3, doctor.getEmail());
            pstmt.setString(4, doctor.getPhone());
            pstmt.setString(5, doctor.getSpecialization());
            pstmt.setString(6, doctor.getHospital());
            pstmt.setInt(7, userId);
            
            affectedRows = pstmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating doctor record failed, no rows affected.");
            }
            
            // Get the generated doctor ID
            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                doctor.setDoctorId(rs.getInt(1));
            } else {
                throw new SQLException("Creating doctor record failed, no ID obtained.");
            }
            
            // Commit transaction
            conn.commit();
            success = true;
            LOGGER.info("Successfully added doctor with ID: " + doctor.getDoctorId() + " and user account with ID: " + userId);
            
        } catch (SQLException e) {
            // Roll back the transaction if something goes wrong
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error rolling back transaction", ex);
            }
            
            LOGGER.log(Level.SEVERE, "Error adding doctor with user account: " + e.getMessage(), e);
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true); // Reset auto-commit mode
                }
                
                DBConnection.closeAll(conn, pstmt, rs);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error resetting auto-commit", e);
            }
        }
        
        return success;
    }
    
    /**
     * Update doctor information and user credentials
     * 
     * @param doctor The doctor to update
     * @param username New username (if not empty)
     * @param password New password (if not empty)
     * @return true if successful, false otherwise
     */
    public boolean updateDoctorWithCredentials(Doctor doctor, String username, String password) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // First update the doctor information
            String sql = "UPDATE doctors SET first_name = ?, last_name = ?, email = ?, " +
                        "phone = ?, specialization = ?, hospital = ? " +
                        "WHERE doctor_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, doctor.getFirstName());
            pstmt.setString(2, doctor.getLastName());
            pstmt.setString(3, doctor.getEmail());
            pstmt.setString(4, doctor.getPhone());
            pstmt.setString(5, doctor.getSpecialization());
            pstmt.setString(6, doctor.getHospital());
            pstmt.setInt(7, doctor.getDoctorId());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Updating doctor failed, no rows affected.");
            }
            
            // Close the statement before reusing
            pstmt.close();
            
            // Now update the user credentials if user_id exists
            if (doctor.getUserId() != null) {
                StringBuilder userSql = new StringBuilder("UPDATE users SET email = ?");
                
                // Add username update if provided
                if (username != null && !username.trim().isEmpty()) {
                    userSql.append(", username = ?");
                }
                
                // Add password update if provided
                if (password != null && !password.trim().isEmpty()) {
                    userSql.append(", password = ?");
                }
                
                userSql.append(" WHERE user_id = ?");
                
                pstmt = conn.prepareStatement(userSql.toString());
                
                int paramIndex = 1;
                pstmt.setString(paramIndex++, doctor.getEmail());
                
                if (username != null && !username.trim().isEmpty()) {
                    pstmt.setString(paramIndex++, username);
                }
                
                if (password != null && !password.trim().isEmpty()) {
                    pstmt.setString(paramIndex++, password);
                }
                
                pstmt.setInt(paramIndex, doctor.getUserId());
                
                affectedRows = pstmt.executeUpdate();
                
                if (affectedRows == 0) {
                    throw new SQLException("Updating user failed, no rows affected.");
                }
            }
            
            // Commit the transaction
            conn.commit();
            success = true;
            LOGGER.info("Successfully updated doctor with ID: " + doctor.getDoctorId());
            
        } catch (SQLException e) {
            // Roll back the transaction if something goes wrong
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error rolling back transaction", ex);
            }
            
            LOGGER.log(Level.SEVERE, "Error updating doctor with credentials: " + e.getMessage(), e);
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true); // Reset auto-commit mode
                }
                
                DBConnection.closeStatement(pstmt);
                DBConnection.closeConnection(conn);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
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