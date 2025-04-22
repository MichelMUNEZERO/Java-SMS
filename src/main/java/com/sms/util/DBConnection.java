package com.sms.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database connection utility class for the School Management System
 */
public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/SMS";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "Dedecedric@1"; // Make sure to use the correct password for your MySQL
    
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            System.err.println("MySQL JDBC Driver not found!");
        }
    }
    
    /**
     * Get database connection
     * @return Connection object
     */
    public static Connection getConnection() {
        try {
            // Create a new connection for each request to prevent connection pooling issues
            return DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Failed to connect to the database! Error: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Close database connection
     * @param connection The connection to close
     */
    public static void closeConnection(Connection connection) {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
} 