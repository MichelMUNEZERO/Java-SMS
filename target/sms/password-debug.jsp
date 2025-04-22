<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.sms.util.DBConnection"%>
<%@ page import="com.sms.util.PasswordHash"%>
<%@ page import="org.mindrot.jbcrypt.BCrypt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Password Debug Page</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1, h2 { color: #0066cc; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
        pre { background-color: #f5f5f5; padding: 10px; border-radius: 5px; }
        .container { max-width: 800px; margin: 0 auto; }
        .section { margin-bottom: 30px; border: 1px solid #ddd; padding: 15px; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Password Verification Debug</h1>
        
        <div class="section">
            <h2>Password Test</h2>
            <%
            String plainPassword = "admin123";
            String storedHash = "$2a$10$D5H/P1ZjuDDwvt3jXXCrIehQFkX0PJux9rDk7ukLAT/MYnKE8n9/2";
            
            out.println("<p>Plain password: <strong>" + plainPassword + "</strong></p>");
            out.println("<p>Stored hash from database: <strong>" + storedHash + "</strong></p>");
            
            // Test using PasswordHash utility
            boolean matchesUsingUtility = PasswordHash.checkPassword(plainPassword, storedHash);
            out.println("<p>Verification using PasswordHash.checkPassword(): <span class='" + 
                (matchesUsingUtility ? "success'>Successful" : "error'>Failed") + "</span></p>");
            
            // Direct test using BCrypt
            boolean matchesUsingBCrypt = BCrypt.checkpw(plainPassword, storedHash);
            out.println("<p>Verification using BCrypt.checkpw() directly: <span class='" + 
                (matchesUsingBCrypt ? "success'>Successful" : "error'>Failed") + "</span></p>");
            
            // Generate a new hash for comparison
            String newHash = BCrypt.hashpw(plainPassword, BCrypt.gensalt(10));
            out.println("<p>Newly generated hash for same password: <strong>" + newHash + "</strong></p>");
            
            // Verify the new hash
            boolean matchesWithNewHash = BCrypt.checkpw(plainPassword, newHash);
            out.println("<p>Verification with newly generated hash: <span class='" + 
                (matchesWithNewHash ? "success'>Successful" : "error'>Failed") + "</span></p>");
            %>
        </div>
        
        <div class="section">
            <h2>Database Password Value</h2>
            <%
            Connection conn = null;
            try {
                conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement("SELECT Password FROM Users WHERE Username = 'admin'");
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    String dbPassword = rs.getString("Password");
                    out.println("<p>Password from database: <strong>" + dbPassword + "</strong></p>");
                    
                    // Try to verify with the value directly from DB
                    boolean matchesDbPassword = BCrypt.checkpw(plainPassword, dbPassword);
                    out.println("<p>Verification with actual DB value: <span class='" + 
                        (matchesDbPassword ? "success'>Successful" : "error'>Failed") + "</span></p>");
                    
                    // Generate a SQL update statement
                    String newUpdateHash = BCrypt.hashpw(plainPassword, BCrypt.gensalt(10));
                    out.println("<h3>SQL to update password:</h3>");
                    out.println("<pre>UPDATE Users SET Password='" + newUpdateHash + "' WHERE Username='admin';</pre>");
                } else {
                    out.println("<p class='error'>Admin user not found in database</p>");
                }
            } catch (Exception e) {
                out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
                e.printStackTrace(new java.io.PrintWriter(out));
            } finally {
                if (conn != null) try { conn.close(); } catch (Exception e) {}
            }
            %>
        </div>
        
        <p><a href="temp-login.jsp">Try Temporary Login</a> | <a href="debug.jsp">Back to Main Debug</a></p>
    </div>
</body>
</html> 