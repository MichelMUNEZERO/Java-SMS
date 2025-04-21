package com.sms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.sms.model.Parent;
import com.sms.util.DBConnection;

/**
 * Data Access Object for Parent entity
 */
public class ParentDAO {
    
    /**
     * Get a parent by ID
     * @param parentId The parent ID
     * @return Parent object if found, null otherwise
     */
    public Parent getParentById(int parentId) {
        String sql = "SELECT * FROM parents WHERE parent_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, parentId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractParentFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get a parent by user ID
     * @param userId The user ID
     * @return Parent object if found, null otherwise
     */
    public Parent getParentByUserId(int userId) {
        String sql = "SELECT * FROM parents WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractParentFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get a parent by email
     * @param email The email address
     * @return Parent object if found, null otherwise
     */
    public Parent getParentByEmail(String email) {
        String sql = "SELECT * FROM parents WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractParentFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all parents
     * @return List of all parents
     */
    public List<Parent> getAllParents() {
        List<Parent> parents = new ArrayList<>();
        String sql = "SELECT * FROM parents";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                parents.add(extractParentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return parents;
    }
    
    /**
     * Add a new parent
     * @param parent The parent to add
     * @return The ID of the added parent, or -1 if failed
     */
    public int addParent(Parent parent) {
        String sql = "INSERT INTO parents (user_id, first_name, last_name, email, phone, address, emergency_contact) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, parent.getUserId());
            stmt.setString(2, parent.getFirstName());
            stmt.setString(3, parent.getLastName());
            stmt.setString(4, parent.getEmail());
            stmt.setString(5, parent.getPhone());
            stmt.setString(6, parent.getAddress());
            stmt.setString(7, parent.getEmergencyContact());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return -1;
    }
    
    /**
     * Update a parent
     * @param parent The parent to update
     * @return true if successful, false otherwise
     */
    public boolean updateParent(Parent parent) {
        String sql = "UPDATE parents SET user_id = ?, first_name = ?, last_name = ?, email = ?, " +
                     "phone = ?, address = ?, emergency_contact = ? WHERE parent_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, parent.getUserId());
            stmt.setString(2, parent.getFirstName());
            stmt.setString(3, parent.getLastName());
            stmt.setString(4, parent.getEmail());
            stmt.setString(5, parent.getPhone());
            stmt.setString(6, parent.getAddress());
            stmt.setString(7, parent.getEmergencyContact());
            stmt.setInt(8, parent.getParentId());
            
            int affectedRows = stmt.executeUpdate();
            
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Delete a parent
     * @param parentId The ID of the parent to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteParent(int parentId) {
        String sql = "DELETE FROM parents WHERE parent_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, parentId);
            
            int affectedRows = stmt.executeUpdate();
            
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Helper method to extract a Parent from a ResultSet
     * @param rs The ResultSet to extract from
     * @return A Parent object
     * @throws SQLException If a database access error occurs
     */
    private Parent extractParentFromResultSet(ResultSet rs) throws SQLException {
        Parent parent = new Parent();
        parent.setParentId(rs.getInt("parent_id"));
        parent.setUserId(rs.getInt("user_id"));
        parent.setFirstName(rs.getString("first_name"));
        parent.setLastName(rs.getString("last_name"));
        parent.setEmail(rs.getString("email"));
        parent.setPhone(rs.getString("phone"));
        parent.setAddress(rs.getString("address"));
        parent.setEmergencyContact(rs.getString("emergency_contact"));
        return parent;
    }
} 