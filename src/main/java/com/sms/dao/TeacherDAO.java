package com.sms.dao;

import com.sms.model.Teacher;
import com.sms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Teacher-related database operations
 */
public class TeacherDAO {
    private static final Logger LOGGER = Logger.getLogger(TeacherDAO.class.getName());
    
    /**
     * Retrieves all teachers from the database
     * 
     * @return List of all teachers
     */
    public List<Teacher> getAllTeachers() {
        List<Teacher> teachers = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM teachers ORDER BY last_name, first_name";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Teacher teacher = mapResultSetToTeacher(rs);
                teachers.add(teacher);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving all teachers", e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return teachers;
    }
    
    /**
     * Retrieves a teacher by ID
     * 
     * @param id The teacher ID
     * @return Teacher object if found, null otherwise
     */
    public Teacher getTeacherById(int id) {
        Teacher teacher = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM teachers WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                teacher = mapResultSetToTeacher(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving teacher with ID: " + id, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return teacher;
    }
    
    /**
     * Adds a new teacher to the database
     * 
     * @param teacher The teacher object to add
     * @return The ID of the newly added teacher, or -1 if operation failed
     */
    public int addTeacher(Teacher teacher) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int generatedId = -1;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO teachers (first_name, last_name, email, phone, specialization, " +
                         "qualification, experience, join_date, address, image_link, status) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            setTeacherParameters(pstmt, teacher);
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                    teacher.setId(generatedId);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding new teacher: " + teacher.getFirstName() + " " + teacher.getLastName(), e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return generatedId;
    }
    
    /**
     * Updates an existing teacher in the database
     * 
     * @param teacher The teacher object with updated information
     * @return true if update was successful, false otherwise
     */
    public boolean updateTeacher(Teacher teacher) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE teachers SET first_name = ?, last_name = ?, email = ?, phone = ?, " +
                         "specialization = ?, qualification = ?, experience = ?, join_date = ?, " +
                         "address = ?, image_link = ?, status = ? " +
                         "WHERE id = ?";
            
            pstmt = conn.prepareStatement(sql);
            setTeacherParameters(pstmt, teacher);
            pstmt.setInt(12, teacher.getId());
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating teacher with ID: " + teacher.getId(), e);
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return success;
    }
    
    /**
     * Deletes a teacher from the database
     * 
     * @param id The ID of the teacher to delete
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteTeacher(int id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM teachers WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting teacher with ID: " + id, e);
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return success;
    }
    
    /**
     * Searches for teachers based on a keyword in their name, email, or specialization
     * 
     * @param keyword The search keyword
     * @return List of teachers matching the search criteria
     */
    public List<Teacher> searchTeachers(String keyword) {
        List<Teacher> teachers = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM teachers WHERE " +
                         "LOWER(first_name) LIKE ? OR " +
                         "LOWER(last_name) LIKE ? OR " +
                         "LOWER(email) LIKE ? OR " +
                         "LOWER(specialization) LIKE ? " +
                         "ORDER BY last_name, first_name";
            
            pstmt = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword.toLowerCase() + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);
            pstmt.setString(4, searchPattern);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Teacher teacher = mapResultSetToTeacher(rs);
                teachers.add(teacher);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error searching teachers with keyword: " + keyword, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return teachers;
    }
    
    /**
     * Maps a ResultSet row to a Teacher object
     * 
     * @param rs The ResultSet containing teacher data
     * @return A Teacher object
     * @throws SQLException If there's an error accessing the ResultSet
     */
    private Teacher mapResultSetToTeacher(ResultSet rs) throws SQLException {
        Teacher teacher = new Teacher();
        teacher.setId(rs.getInt("id"));
        teacher.setFirstName(rs.getString("first_name"));
        teacher.setLastName(rs.getString("last_name"));
        teacher.setEmail(rs.getString("email"));
        teacher.setPhone(rs.getString("phone"));
        teacher.setSpecialization(rs.getString("specialization"));
        teacher.setQualification(rs.getString("qualification"));
        teacher.setExperience(rs.getInt("experience"));
        teacher.setJoinDate(rs.getDate("join_date"));
        teacher.setAddress(rs.getString("address"));
        teacher.setImageLink(rs.getString("image_link"));
        teacher.setStatus(rs.getString("status"));
        return teacher;
    }
    
    /**
     * Sets parameters for PreparedStatement from Teacher object
     * 
     * @param pstmt The PreparedStatement to set parameters for
     * @param teacher The Teacher object containing data
     * @throws SQLException If there's an error setting parameters
     */
    private void setTeacherParameters(PreparedStatement pstmt, Teacher teacher) throws SQLException {
        pstmt.setString(1, teacher.getFirstName());
        pstmt.setString(2, teacher.getLastName());
        pstmt.setString(3, teacher.getEmail());
        pstmt.setString(4, teacher.getPhone());
        pstmt.setString(5, teacher.getSpecialization());
        pstmt.setString(6, teacher.getQualification());
        pstmt.setInt(7, teacher.getExperience());
        
        if (teacher.getJoinDate() != null) {
            pstmt.setDate(8, new java.sql.Date(teacher.getJoinDate().getTime()));
        } else {
            pstmt.setNull(8, Types.DATE);
        }
        
        pstmt.setString(9, teacher.getAddress());
        pstmt.setString(10, teacher.getImageLink());
        pstmt.setString(11, teacher.getStatus());
    }
} 