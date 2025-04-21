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
    
    private Connection connection;
    
    public ParentDAO() {
        connection = DBConnection.getConnection();
    }
    
    /**
     * Get a parent by ID
     * @param parentId the parent ID to search for
     * @return the Parent object if found, null otherwise
     */
    public Parent getParentById(int parentId) {
        Parent parent = null;
        String sql = "SELECT * FROM parents WHERE parent_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, parentId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                parent = extractParentFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return parent;
    }
    
    /**
     * Get a parent by user ID
     * @param userId the user ID to search for
     * @return the Parent object if found, null otherwise
     */
    public Parent getParentByUserId(int userId) {
        Parent parent = null;
        String sql = "SELECT * FROM parents WHERE user_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                parent = extractParentFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return parent;
    }
    
    /**
     * Get a parent by email
     * @param email the email to search for
     * @return the Parent object if found, null otherwise
     */
    public Parent getParentByEmail(String email) {
        Parent parent = null;
        String sql = "SELECT * FROM parents WHERE email = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                parent = extractParentFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return parent;
    }
    
    /**
     * Get all parents from the database
     * @return a list of all parents
     */
    public List<Parent> getAllParents() {
        List<Parent> parents = new ArrayList<>();
        String sql = "SELECT * FROM parents";
        
        try (Statement stmt = connection.createStatement();
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
     * Add a new parent to the database
     * @param parent the parent to add
     * @return true if the addition was successful, false otherwise
     */
    public boolean addParent(Parent parent) {
        String sql = "INSERT INTO parents (user_id, first_name, last_name, email, phone, address, occupation) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, parent.getUserId());
            stmt.setString(2, parent.getFirstName());
            stmt.setString(3, parent.getLastName());
            stmt.setString(4, parent.getEmail());
            stmt.setString(5, parent.getPhone());
            stmt.setString(6, parent.getAddress());
            stmt.setString(7, parent.getOccupation());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update an existing parent in the database
     * @param parent the parent to update
     * @return true if the update was successful, false otherwise
     */
    public boolean updateParent(Parent parent) {
        String sql = "UPDATE parents SET user_id = ?, first_name = ?, last_name = ?, email = ?, phone = ?, address = ?, occupation = ? WHERE parent_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, parent.getUserId());
            stmt.setString(2, parent.getFirstName());
            stmt.setString(3, parent.getLastName());
            stmt.setString(4, parent.getEmail());
            stmt.setString(5, parent.getPhone());
            stmt.setString(6, parent.getAddress());
            stmt.setString(7, parent.getOccupation());
            stmt.setInt(8, parent.getParentId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete a parent from the database
     * @param parentId the ID of the parent to delete
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteParent(int parentId) {
        String sql = "DELETE FROM parents WHERE parent_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, parentId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Map a Parent object from a ResultSet
     * @param rs the ResultSet containing parent data
     * @return a populated Parent object
     * @throws SQLException if a database access error occurs
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
        parent.setOccupation(rs.getString("occupation"));
        return parent;
    }
    
    /**
     * Search for parents based on a search term
     * @param searchTerm the term to search for
     * @return a list of parents matching the search term
     */
    public List<Parent> searchParents(String searchTerm) {
        List<Parent> parents = new ArrayList<>();
        String sql = "SELECT * FROM parents WHERE first_name LIKE ? OR last_name LIKE ? OR email LIKE ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            String searchPattern = "%" + searchTerm + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                parents.add(extractParentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return parents;
    }
} 