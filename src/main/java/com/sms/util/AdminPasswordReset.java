package com.sms.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class to reset admin password
 */
public class AdminPasswordReset {
    
    /**
     * Reset the admin password to admin123
     * @return true if successful, false otherwise
     */
    public static boolean resetAdminPassword() {
        String plainPassword = "admin123";
        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt(10));
        
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement("UPDATE Users SET Password = ? WHERE Username = 'admin'");
            stmt.setString(1, hashedPassword);
            int result = stmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Main method for standalone execution
     */
    public static void main(String[] args) {
        boolean success = resetAdminPassword();
        System.out.println("Admin password reset " + (success ? "successful" : "failed"));
    }
} 