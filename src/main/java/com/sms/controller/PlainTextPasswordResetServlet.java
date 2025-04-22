package com.sms.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sms.util.DBConnection;

/**
 * Servlet for resetting admin password to plain text
 */
@WebServlet("/reset-plain-password")
public class PlainTextPasswordResetServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html");
        
        boolean success = resetAdminPassword();
        
        if (success) {
            response.getWriter().append("<html><body>");
            response.getWriter().append("<h1>Admin Password Reset</h1>");
            response.getWriter().append("<p style='color:green;font-weight:bold;'>Admin password successfully reset to plain text 'admin123'</p>");
            response.getWriter().append("<p><a href='login.jsp'>Go to Login Page</a></p>");
            response.getWriter().append("</body></html>");
        } else {
            response.getWriter().append("<html><body>");
            response.getWriter().append("<h1>Admin Password Reset</h1>");
            response.getWriter().append("<p style='color:red;font-weight:bold;'>Failed to reset admin password</p>");
            response.getWriter().append("<p><a href='debug.jsp'>Go to Debug Page</a></p>");
            response.getWriter().append("</body></html>");
        }
    }
    
    /**
     * Reset the admin password to a plain text value
     * @return true if successful, false otherwise
     */
    private boolean resetAdminPassword() {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement("UPDATE Users SET Password = 'admin123' WHERE Username = 'admin'");
            int result = stmt.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
} 