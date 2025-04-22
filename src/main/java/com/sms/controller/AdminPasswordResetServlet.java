package com.sms.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sms.util.AdminPasswordReset;

/**
 * Servlet for resetting admin password
 */
@WebServlet("/reset-admin-password")
public class AdminPasswordResetServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html");
        
        boolean success = AdminPasswordReset.resetAdminPassword();
        
        if (success) {
            response.getWriter().append("<html><body>");
            response.getWriter().append("<h1>Admin Password Reset</h1>");
            response.getWriter().append("<p style='color:green;font-weight:bold;'>Admin password successfully reset to 'admin123'</p>");
            response.getWriter().append("<p><a href='login.jsp'>Go to Login Page</a> | <a href='temp-login.jsp'>Temporary Login</a></p>");
            response.getWriter().append("</body></html>");
        } else {
            response.getWriter().append("<html><body>");
            response.getWriter().append("<h1>Admin Password Reset</h1>");
            response.getWriter().append("<p style='color:red;font-weight:bold;'>Failed to reset admin password</p>");
            response.getWriter().append("<p><a href='debug.jsp'>Go to Debug Page</a></p>");
            response.getWriter().append("</body></html>");
        }
    }
} 