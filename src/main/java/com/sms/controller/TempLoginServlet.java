package com.sms.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.util.DBConnection;
import com.sms.util.PasswordHash;
import com.sms.model.User;

/**
 * Temporary Login Servlet for troubleshooting
 */
@WebServlet("/temp-login")
public class TempLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Validate input
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            
            // Direct database query for authentication
            String sql = "SELECT * FROM Users WHERE Username = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                String storedPassword = rs.getString("Password");
                if (PasswordHash.checkPassword(password, storedPassword)) {
                    // Create user object and session
                    User user = new User();
                    user.setUserId(rs.getInt("UserID"));
                    user.setUsername(rs.getString("Username"));
                    user.setRole(rs.getString("UserType"));
                    
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    session.setMaxInactiveInterval(30 * 60); // 30 minutes
                    
                    // Redirect based on user type
                    redirectToDashboard(response, user);
                } else {
                    request.setAttribute("error", "Invalid password");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "User not found");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    /**
     * Redirect to appropriate dashboard based on user type
     */
    private void redirectToDashboard(HttpServletResponse response, User user) throws IOException {
        String userType = user.getRole().toLowerCase().trim();
        
        switch (userType) {
            case "admin":
                response.sendRedirect(response.encodeRedirectURL("admin/dashboard.jsp"));
                break;
            case "teacher":
                response.sendRedirect(response.encodeRedirectURL("teacher/dashboard.jsp"));
                break;
            case "student":
                response.sendRedirect(response.encodeRedirectURL("student/dashboard.jsp"));
                break;
            case "parent":
                response.sendRedirect(response.encodeRedirectURL("parent/dashboard.jsp"));
                break;
            default:
                response.sendRedirect(response.encodeRedirectURL("dashboard.jsp"));
                break;
        }
    }
} 