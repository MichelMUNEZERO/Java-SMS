package com.sms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.sms.model.Parent;
import com.sms.util.DBConnection;

/**
 * Data Access Object for Parent-related database operations
 */
public class ParentDAO {
    private static final Logger LOGGER = Logger.getLogger(ParentDAO.class.getName());
    
    /**
     * Get all parents from the database
     * @return List of Parent objects
     */
    public List<Parent> getAllParents() {
        List<Parent> parents = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT p.*, COUNT(s.student_id) as children_count FROM Parents p " +
                         "LEFT JOIN Students s ON p.parent_id = s.parent_id " +
                         "GROUP BY p.parent_id ORDER BY p.last_name, p.first_name";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Parent parent = new Parent();
                parent.setId(rs.getInt("parent_id"));
                parent.setFirstName(rs.getString("first_name"));
                parent.setLastName(rs.getString("last_name"));
                parent.setEmail(rs.getString("email"));
                parent.setPhone(rs.getString("phone"));
                parent.setAddress(rs.getString("address"));
                parent.setOccupation(rs.getString("occupation"));
                parent.setStatus(rs.getBoolean("user_id") != false ? "active" : "inactive");
                parent.setChildrenCount(rs.getInt("children_count"));
                
                parents.add(parent);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all parents", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return parents;
    }
    
    /**
     * Get a parent by their ID
     * @param parentId The ID of the parent to retrieve
     * @return Parent object if found, null otherwise
     */
    public Parent getParentById(int parentId) {
        Parent parent = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT p.*, COUNT(s.student_id) as children_count FROM Parents p " +
                         "LEFT JOIN Students s ON p.parent_id = s.parent_id " +
                         "WHERE p.parent_id = ? " +
                         "GROUP BY p.parent_id";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, parentId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                parent = new Parent();
                parent.setId(rs.getInt("parent_id"));
                parent.setFirstName(rs.getString("first_name"));
                parent.setLastName(rs.getString("last_name"));
                parent.setEmail(rs.getString("email"));
                parent.setPhone(rs.getString("phone"));
                parent.setAddress(rs.getString("address"));
                parent.setOccupation(rs.getString("occupation"));
                parent.setStatus(rs.getBoolean("user_id") != false ? "active" : "inactive");
                parent.setChildrenCount(rs.getInt("children_count"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting parent with ID: " + parentId, e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return parent;
    }
    
    /**
     * Add a new parent
     * @param parent The parent to add
     * @return true if successful, false otherwise
     */
    public boolean addParent(Parent parent) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO Parents (first_name, last_name, email, phone, address, occupation) " +
                         "VALUES (?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, parent.getFirstName());
            pstmt.setString(2, parent.getLastName());
            pstmt.setString(3, parent.getEmail());
            pstmt.setString(4, parent.getPhone());
            pstmt.setString(5, parent.getAddress());
            pstmt.setString(6, parent.getOccupation());
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding parent", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, null);
        }
        
        return success;
    }
    
    /**
     * Update an existing parent
     * @param parent The parent with updated information
     * @return true if successful, false otherwise
     */
    public boolean updateParent(Parent parent) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE Parents SET first_name = ?, last_name = ?, email = ?, " +
                         "phone = ?, address = ?, occupation = ? " +
                         "WHERE parent_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, parent.getFirstName());
            pstmt.setString(2, parent.getLastName());
            pstmt.setString(3, parent.getEmail());
            pstmt.setString(4, parent.getPhone());
            pstmt.setString(5, parent.getAddress());
            pstmt.setString(6, parent.getOccupation());
            pstmt.setInt(7, parent.getId());
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating parent with ID: " + parent.getId(), e);
        } finally {
            DBConnection.closeAll(conn, pstmt, null);
        }
        
        return success;
    }
    
    /**
     * Delete a parent
     * @param parentId The ID of the parent to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteParent(int parentId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            // First update any students that reference this parent
            String updateStudentsSql = "UPDATE Students SET parent_id = NULL WHERE parent_id = ?";
            pstmt = conn.prepareStatement(updateStudentsSql);
            pstmt.setInt(1, parentId);
            pstmt.executeUpdate();
            
            // Then delete the parent
            String deleteParentSql = "DELETE FROM Parents WHERE parent_id = ?";
            pstmt = conn.prepareStatement(deleteParentSql);
            pstmt.setInt(1, parentId);
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting parent with ID: " + parentId, e);
        } finally {
            DBConnection.closeAll(conn, pstmt, null);
        }
        
        return success;
    }
    
    /**
     * Get parents by search criteria
     * @param searchTerm The search term to filter by (name or email)
     * @return List of Parent objects matching the search criteria
     */
    public List<Parent> searchParents(String searchTerm) {
        List<Parent> parents = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT p.*, COUNT(s.student_id) as children_count FROM Parents p " +
                         "LEFT JOIN Students s ON p.parent_id = s.parent_id " +
                         "WHERE p.first_name LIKE ? OR p.last_name LIKE ? OR p.email LIKE ? " +
                         "GROUP BY p.parent_id ORDER BY p.last_name, p.first_name";
            pstmt = conn.prepareStatement(sql);
            
            String searchPattern = "%" + searchTerm + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Parent parent = new Parent();
                parent.setId(rs.getInt("parent_id"));
                parent.setFirstName(rs.getString("first_name"));
                parent.setLastName(rs.getString("last_name"));
                parent.setEmail(rs.getString("email"));
                parent.setPhone(rs.getString("phone"));
                parent.setAddress(rs.getString("address"));
                parent.setOccupation(rs.getString("occupation"));
                parent.setStatus(rs.getBoolean("user_id") != false ? "active" : "inactive");
                parent.setChildrenCount(rs.getInt("children_count"));
                
                parents.add(parent);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error searching parents with term: " + searchTerm, e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return parents;
    }
    
    /**
     * Get a parent by their user ID
     * @param userId The ID of the user associated with the parent
     * @return Parent object if found, null otherwise
     */
    public Parent getParentByUserId(int userId) {
        Parent parent = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT p.*, COUNT(s.student_id) as children_count FROM Parents p " +
                         "LEFT JOIN Students s ON p.parent_id = s.parent_id " +
                         "WHERE p.user_id = ? " +
                         "GROUP BY p.parent_id";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                parent = new Parent();
                parent.setId(rs.getInt("parent_id"));
                parent.setFirstName(rs.getString("first_name"));
                parent.setLastName(rs.getString("last_name"));
                parent.setEmail(rs.getString("email"));
                parent.setPhone(rs.getString("phone"));
                parent.setAddress(rs.getString("address"));
                parent.setOccupation(rs.getString("occupation"));
                parent.setUserId(rs.getInt("user_id"));
                parent.setStatus(rs.getString("status"));
                parent.setChildrenCount(rs.getInt("children_count"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting parent with user ID: " + userId, e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return parent;
    }
} 