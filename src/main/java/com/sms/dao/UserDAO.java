package com.sms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.sms.model.User;
import com.sms.util.DBConnection;

/**
 * Data Access Object for User entity
 */
public class UserDAO {
    
    private Connection connection;
    
    public UserDAO() {
        try {
            connection = DBConnection.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Get a user by ID
     * @param userId the user ID to search for
     * @return the User object if found, null otherwise
     */
    public User getUserById(int userId) {
        User user = null;
        String sql = "SELECT * FROM Users WHERE UserID = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                user = extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return user;
    }
    
    /**
     * Get a user by email
     * @param email the email to search for
     * @return the User object if found, null otherwise
     */
    public User getUserByEmail(String email) {
        User user = null;
        // Since the current schema doesn't have an email column, this method won't work properly
        // This method should be updated or removed after updating the schema
        return user;
    }
    
    /**
     * Get a user by username 
     * @param username the username to search for
     * @return the User object if found, null otherwise
     */
    public User getUserByUsername(String username) {
        User user = null;
        String sql = "SELECT * FROM Users WHERE Username = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                user = extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return user;
    }
    
    /**
     * Get all users from the database
     * @return a list of all users
     */
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return users;
    }
    
    /**
     * Add a new user to the database
     * @param user the user to add
     * @return the generated user ID if successful, -1 otherwise
     */
    public int addUser(User user) {
        String sql = "INSERT INTO Users (Username, Password, UserType) VALUES (?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getRole());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return -1;
    }
    
    /**
     * Update an existing user in the database
     * @param user the user to update
     * @return true if the update was successful, false otherwise
     */
    public boolean updateUser(User user) {
        String sql = "UPDATE Users SET Username = ?, Password = ?, UserType = ? WHERE UserID = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getRole());
            stmt.setInt(4, user.getUserId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete a user from the database
     * @param userId the ID of the user to delete
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM Users WHERE UserID = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Map a User object from a ResultSet
     * @param rs the ResultSet containing user data
     * @return a populated User object
     * @throws SQLException if a database access error occurs
     * Updated to use correct column names from database schema
     */
    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("UserID"));
        user.setUsername(rs.getString("Username"));
        user.setPassword(rs.getString("Password"));
        user.setRole(rs.getString("UserType"));
        user.setStatus("ACTIVE"); // Default since this column doesn't exist in current schema
        return user;
    }
    
    /**
     * Authenticate a user with username and password
     * @param username the username
     * @param hashedPassword the password (already hashed)
     * @return the User object if authentication successful, null otherwise
     */
    public User authenticateUser(String username, String hashedPassword) {
        User user = null;
        String sql = "SELECT * FROM Users WHERE Username = ? AND Password = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, hashedPassword);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                user = extractUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return user;
    }
    
    /**
     * Get users by role
     * @param role the role to search for
     * @return a list of users with the specified role
     */
    public List<User> getUsersByRole(String role) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE UserType = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, role);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return users;
    }
    
    /**
     * Search for users based on a search term
     * @param searchTerm the term to search for
     * @return a list of users matching the search term
     */
    public List<User> searchUsers(String searchTerm) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE Username LIKE ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            String searchPattern = "%" + searchTerm + "%";
            stmt.setString(1, searchPattern);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return users;
    }
} 