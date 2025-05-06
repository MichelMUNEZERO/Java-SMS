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

import com.sms.model.Nurse;
import com.sms.util.DBConnection;

/**
 * Data Access Object for Nurse entities
 */
public class NurseDAO {
    private static final Logger LOGGER = Logger.getLogger(NurseDAO.class.getName());
    
    /**
     * Get all nurses from the database
     * 
     * @return List of all nurses
     */
    public List<Nurse> getAllNurses() {
        List<Nurse> nurses = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM nurses ORDER BY first_name, last_name";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Nurse nurse = mapResultSetToNurse(rs);
                nurses.add(nurse);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all nurses", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return nurses;
    }
    
    /**
     * Get a nurse by ID
     * 
     * @param nurseId The nurse ID
     * @return Nurse object if found, null otherwise
     */
    public Nurse getNurseById(int nurseId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Nurse nurse = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM nurses WHERE nurse_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, nurseId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                nurse = mapResultSetToNurse(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting nurse by ID: " + nurseId, e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return nurse;
    }
    
    /**
     * Create a new nurse in the database
     * 
     * @param nurse The nurse to create
     * @return The created nurse with ID, or null if creation fails
     */
    public Nurse createNurse(Nurse nurse) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO nurses (first_name, last_name, email, phone, qualification, user_id) "
                    + "VALUES (?, ?, ?, ?, ?, ?)";
            
            LOGGER.info("Attempting to create nurse with email: " + nurse.getEmail());
            
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, nurse.getFirstName());
            pstmt.setString(2, nurse.getLastName());
            pstmt.setString(3, nurse.getEmail());
            pstmt.setString(4, nurse.getPhone());
            pstmt.setString(5, nurse.getQualification());
            
            if (nurse.getUserId() != null) {
                pstmt.setInt(6, nurse.getUserId());
            } else {
                pstmt.setNull(6, java.sql.Types.INTEGER);
            }
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    nurse.setNurseId(rs.getInt(1));
                    LOGGER.info("Successfully created nurse with ID: " + nurse.getNurseId());
                    return nurse;
                }
            }
        } catch (SQLException e) {
            // Log the detailed error information
            LOGGER.log(Level.SEVERE, "Error creating nurse. SQL State: " + e.getSQLState() 
                    + ", Error Code: " + e.getErrorCode() 
                    + ", Message: " + e.getMessage(), e);
            
            // Check for duplicate email constraint violation
            if (e.getErrorCode() == 1062) { // MySQL duplicate key error
                LOGGER.warning("Duplicate email address: " + nurse.getEmail());
            }
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return null;
    }
    
    /**
     * Update an existing nurse
     * 
     * @param nurse The nurse to update
     * @return true if successful, false otherwise
     */
    public boolean updateNurse(Nurse nurse) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE nurses SET first_name = ?, last_name = ?, email = ?, "
                    + "phone = ?, qualification = ?, user_id = ? WHERE nurse_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nurse.getFirstName());
            pstmt.setString(2, nurse.getLastName());
            pstmt.setString(3, nurse.getEmail());
            pstmt.setString(4, nurse.getPhone());
            pstmt.setString(5, nurse.getQualification());
            
            if (nurse.getUserId() != null) {
                pstmt.setInt(6, nurse.getUserId());
            } else {
                pstmt.setNull(6, java.sql.Types.INTEGER);
            }
            
            pstmt.setInt(7, nurse.getNurseId());
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating nurse: " + nurse.getNurseId() 
                    + ", SQL State: " + e.getSQLState() 
                    + ", Error Code: " + e.getErrorCode() 
                    + ", Message: " + e.getMessage(), e);
            return false;
        } finally {
            DBConnection.closeStatement(pstmt);
            DBConnection.closeConnection(conn);
        }
    }
    
    /**
     * Delete a nurse from the database
     * 
     * @param nurseId The ID of the nurse to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteNurse(int nurseId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM nurses WHERE nurse_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, nurseId);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting nurse: " + nurseId, e);
            return false;
        } finally {
            DBConnection.closeStatement(pstmt);
            DBConnection.closeConnection(conn);
        }
    }
    
    /**
     * Add a new nurse to the database with a user account
     * 
     * @param nurse The nurse to add
     * @param username Username for the new user account
     * @param password Password for the new user account
     * @param role Role for the new user account (usually "nurse")
     * @return true if successful, false otherwise
     */
    public boolean addNurseWithUserAccount(Nurse nurse, String username, String password, String role) {
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
            pstmt.setString(4, nurse.getEmail());
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
            
            // Step 2: Create nurse with reference to user ID
            nurse.setUserId(userId);
            String createNurseSql = "INSERT INTO nurses (first_name, last_name, email, phone, qualification, user_id) " +
                                  "VALUES (?, ?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(createNurseSql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, nurse.getFirstName());
            pstmt.setString(2, nurse.getLastName());
            pstmt.setString(3, nurse.getEmail());
            pstmt.setString(4, nurse.getPhone());
            pstmt.setString(5, nurse.getQualification());
            pstmt.setInt(6, userId);
            
            affectedRows = pstmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating nurse record failed, no rows affected.");
            }
            
            // Get the generated nurse ID
            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                nurse.setNurseId(rs.getInt(1));
            } else {
                throw new SQLException("Creating nurse record failed, no ID obtained.");
            }
            
            // Commit transaction
            conn.commit();
            success = true;
            LOGGER.info("Successfully added nurse with ID: " + nurse.getNurseId() + " and user account with ID: " + userId);
            
        } catch (SQLException e) {
            // Roll back the transaction if something goes wrong
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error rolling back transaction", ex);
            }
            
            LOGGER.log(Level.SEVERE, "Error adding nurse with user account: " + e.getMessage(), e);
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
     * Map a ResultSet row to a Nurse object
     * 
     * @param rs The ResultSet to map
     * @return Mapped Nurse object
     * @throws SQLException if a database error occurs
     */
    private Nurse mapResultSetToNurse(ResultSet rs) throws SQLException {
        Nurse nurse = new Nurse();
        nurse.setNurseId(rs.getInt("nurse_id"));
        nurse.setFirstName(rs.getString("first_name"));
        nurse.setLastName(rs.getString("last_name"));
        nurse.setEmail(rs.getString("email"));
        nurse.setPhone(rs.getString("phone"));
        nurse.setQualification(rs.getString("qualification"));
        
        int userId = rs.getInt("user_id");
        if (!rs.wasNull()) {
            nurse.setUserId(userId);
        }
        
        return nurse;
    }
    
    /**
     * Update nurse information and user credentials
     * 
     * @param nurse The nurse to update
     * @param username New username (if not empty)
     * @param password New password (if not empty)
     * @return true if successful, false otherwise
     */
    public boolean updateNurseWithCredentials(Nurse nurse, String username, String password) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // First update the nurse information
            String sql = "UPDATE nurses SET first_name = ?, last_name = ?, email = ?, " +
                       "phone = ?, qualification = ? WHERE nurse_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nurse.getFirstName());
            pstmt.setString(2, nurse.getLastName());
            pstmt.setString(3, nurse.getEmail());
            pstmt.setString(4, nurse.getPhone());
            pstmt.setString(5, nurse.getQualification());
            pstmt.setInt(6, nurse.getNurseId());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Updating nurse failed, no rows affected.");
            }
            
            // Close the statement before reusing
            pstmt.close();
            
            // Now update the user credentials if user_id exists
            if (nurse.getUserId() != null) {
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
                pstmt.setString(paramIndex++, nurse.getEmail());
                
                if (username != null && !username.trim().isEmpty()) {
                    pstmt.setString(paramIndex++, username);
                }
                
                if (password != null && !password.trim().isEmpty()) {
                    pstmt.setString(paramIndex++, password);
                }
                
                pstmt.setInt(paramIndex, nurse.getUserId());
                
                affectedRows = pstmt.executeUpdate();
                
                if (affectedRows == 0) {
                    throw new SQLException("Updating user failed, no rows affected.");
                }
            }
            
            // Commit the transaction
            conn.commit();
            success = true;
            LOGGER.info("Successfully updated nurse with ID: " + nurse.getNurseId());
            
        } catch (SQLException e) {
            // Roll back the transaction if something goes wrong
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error rolling back transaction", ex);
            }
            
            LOGGER.log(Level.SEVERE, "Error updating nurse with credentials: " + e.getMessage(), e);
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
     * Get a nurse by user ID
     * 
     * @param userId The user ID
     * @return Nurse object if found, null otherwise
     */
    public Nurse getNurseByUserId(int userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Nurse nurse = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM nurses WHERE user_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                nurse = mapResultSetToNurse(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting nurse by user ID: " + userId, e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return nurse;
    }
} 