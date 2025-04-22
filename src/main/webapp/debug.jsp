<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.sms.util.DBConnection"%>
<%@ page import="com.sms.dao.UserDAO"%>
<%@ page import="com.sms.model.User"%>
<%@ page import="com.sms.util.PasswordHash"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SMS Debug Page</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1, h2 { color: #0066cc; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
        table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        .section { margin-bottom: 30px; border: 1px solid #ddd; padding: 15px; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>School Management System Debug Page</h1>
    
    <div class="section">
        <h2>Database Connection Test</h2>
        <% 
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            if (conn != null && !conn.isClosed()) {
                out.println("<p class='success'>Database connection successful!</p>");
                
                // Get database metadata
                DatabaseMetaData metaData = conn.getMetaData();
                out.println("<p>Database: " + metaData.getDatabaseProductName() + " " + 
                           metaData.getDatabaseProductVersion() + "</p>");
                out.println("<p>JDBC Driver: " + metaData.getDriverName() + " " + 
                           metaData.getDriverVersion() + "</p>");
            } else {
                out.println("<p class='error'>Failed to connect to database!</p>");
            }
        } catch (Exception e) {
            out.println("<p class='error'>Error connecting to database: " + e.getMessage() + "</p>");
            e.printStackTrace(new java.io.PrintWriter(out));
        }
        %>
    </div>
    
    <div class="section">
        <h2>Users Table Structure</h2>
        <% 
        try {
            if (conn != null && !conn.isClosed()) {
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("DESCRIBE Users");
                
                out.println("<table>");
                out.println("<tr><th>Field</th><th>Type</th><th>Null</th><th>Key</th><th>Default</th><th>Extra</th></tr>");
                
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getString("Field") + "</td>");
                    out.println("<td>" + rs.getString("Type") + "</td>");
                    out.println("<td>" + rs.getString("Null") + "</td>");
                    out.println("<td>" + rs.getString("Key") + "</td>");
                    out.println("<td>" + rs.getString("Default") + "</td>");
                    out.println("<td>" + rs.getString("Extra") + "</td>");
                    out.println("</tr>");
                }
                
                out.println("</table>");
                
                // Show sample data
                rs = stmt.executeQuery("SELECT * FROM Users LIMIT 5");
                ResultSetMetaData rsmd = rs.getMetaData();
                int columnCount = rsmd.getColumnCount();
                
                out.println("<h3>Sample Data</h3>");
                out.println("<table>");
                
                // Print column headers
                out.println("<tr>");
                for (int i = 1; i <= columnCount; i++) {
                    out.println("<th>" + rsmd.getColumnName(i) + "</th>");
                }
                out.println("</tr>");
                
                // Print data
                while (rs.next()) {
                    out.println("<tr>");
                    for (int i = 1; i <= columnCount; i++) {
                        out.println("<td>" + rs.getString(i) + "</td>");
                    }
                    out.println("</tr>");
                }
                
                out.println("</table>");
            }
        } catch (Exception e) {
            out.println("<p class='error'>Error querying Users table: " + e.getMessage() + "</p>");
            e.printStackTrace(new java.io.PrintWriter(out));
        }
        %>
    </div>
    
    <div class="section">
        <h2>Manual Authentication Test</h2>
        <% 
        try {
            // Test with hardcoded values for admin
            String username = "admin";
            String password = "admin123";
            
            out.println("<p>Testing authentication for username: <strong>" + username + "</strong></p>");
            
            // First test direct SQL query
            if (conn != null && !conn.isClosed()) {
                PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM Users WHERE Username = ?");
                pstmt.setString(1, username);
                ResultSet rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    out.println("<p class='success'>User found in database using direct SQL query</p>");
                    
                    // Show all columns for this user
                    ResultSetMetaData rsmd = rs.getMetaData();
                    int columnCount = rsmd.getColumnCount();
                    
                    out.println("<table>");
                    out.println("<tr><th>Column</th><th>Value</th></tr>");
                    
                    for (int i = 1; i <= columnCount; i++) {
                        out.println("<tr>");
                        out.println("<td>" + rsmd.getColumnName(i) + "</td>");
                        out.println("<td>" + rs.getString(i) + "</td>");
                        out.println("</tr>");
                    }
                    
                    out.println("</table>");
                    
                    // Check password
                    String storedPassword = rs.getString("Password");
                    boolean passwordMatches = PasswordHash.checkPassword(password, storedPassword);
                    
                    if (passwordMatches) {
                        out.println("<p class='success'>Password verification successful!</p>");
                    } else {
                        out.println("<p class='error'>Password verification failed!</p>");
                    }
                } else {
                    out.println("<p class='error'>User not found in database using direct SQL query</p>");
                }
            }
            
            // Now test using DAO
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getUserByUsername(username);
            
            if (user != null) {
                out.println("<p class='success'>User found using UserDAO: " + user.toString() + "</p>");
                
                boolean passwordMatches = PasswordHash.checkPassword(password, user.getPassword());
                
                if (passwordMatches) {
                    out.println("<p class='success'>Password verification through DAO successful!</p>");
                } else {
                    out.println("<p class='error'>Password verification through DAO failed!</p>");
                }
            } else {
                out.println("<p class='error'>User not found using UserDAO</p>");
            }
        } catch (Exception e) {
            out.println("<p class='error'>Error during authentication test: " + e.getMessage() + "</p>");
            e.printStackTrace(new java.io.PrintWriter(out));
        } finally {
            // Close the connection
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    out.println("<p class='error'>Error closing connection: " + e.getMessage() + "</p>");
                }
            }
        }
        %>
    </div>
    
    <p><a href="login.jsp">Return to Login Page</a></p>
</body>
</html> 