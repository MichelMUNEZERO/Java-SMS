package com.sms.util;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

/**
 * Utility class to check database structure and connection
 */
public class DatabaseCheck {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/sms_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    /**
     * Print all tables in the database and their columns
     */
    public static void printAllTables() {
        try (Connection conn = getConnection()) {
            DatabaseMetaData metaData = conn.getMetaData();
            System.out.println("Connected to database: " + metaData.getURL());
            System.out.println("Database product: " + metaData.getDatabaseProductName() + " " + metaData.getDatabaseProductVersion());
            
            ResultSet tables = metaData.getTables(null, null, "%", new String[]{"TABLE"});
            System.out.println("\nTables in database:");
            
            while (tables.next()) {
                String tableName = tables.getString("TABLE_NAME");
                System.out.println("\n- Table: " + tableName);
                printTableColumns(conn, tableName);
            }
            
        } catch (SQLException e) {
            System.out.println("Database connection error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Print columns of a specific table
     */
    public static void printTableColumns(Connection conn, String tableName) throws SQLException {
        DatabaseMetaData metaData = conn.getMetaData();
        ResultSet columns = metaData.getColumns(null, null, tableName, null);
        
        System.out.println("  Columns:");
        while (columns.next()) {
            String columnName = columns.getString("COLUMN_NAME");
            String dataType = columns.getString("TYPE_NAME");
            String nullable = columns.getString("IS_NULLABLE");
            
            System.out.println("    - " + columnName + " (" + dataType + ", nullable: " + nullable + ")");
        }
    }
    
    /**
     * Test query on a specific table
     */
    public static void testQuery(String tableName) {
        try (Connection conn = getConnection()) {
            String query = "SELECT * FROM " + tableName + " LIMIT 5";
            System.out.println("Executing query: " + query);
            
            try (PreparedStatement stmt = conn.prepareStatement(query);
                 ResultSet rs = stmt.executeQuery()) {
                
                ResultSetMetaData rsMetaData = rs.getMetaData();
                int columnCount = rsMetaData.getColumnCount();
                
                // Print column names
                System.out.println("\nQuery results:");
                for (int i = 1; i <= columnCount; i++) {
                    System.out.print(rsMetaData.getColumnName(i) + "\t");
                }
                System.out.println();
                
                // Print separator line
                for (int i = 1; i <= columnCount; i++) {
                    System.out.print("--------\t");
                }
                System.out.println();
                
                // Print data
                while (rs.next()) {
                    for (int i = 1; i <= columnCount; i++) {
                        System.out.print(rs.getString(i) + "\t");
                    }
                    System.out.println();
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Query error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Get database connection
     */
    private static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL JDBC Driver not found");
            throw new SQLException("JDBC Driver not found", e);
        }
        
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
    
    /**
     * Main method for testing
     */
    public static void main(String[] args) {
        printAllTables();
        System.out.println("\nTesting Users table:");
        testQuery("Users");
    }
} 