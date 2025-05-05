package com.sms.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.model.User;
import com.sms.util.DBConnection;

/**
 * Servlet to handle user login
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * Handle GET requests - show login page
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Check if user is already logged in
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            redirectToDashboard(request, response, user);
            return;
        }
        
        // Forward to login page
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    /**
     * Handle POST requests - process login
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Basic validation
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        // Trim the inputs to handle any whitespace
        username = username.trim();
        password = password.trim();
        
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            
            // Query to get user
            String sql = "SELECT * FROM Users WHERE username = ? AND active = true";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                // User found - create User object
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password").trim()); // Trim stored password
                user.setRole(rs.getString("role"));
                user.setEmail(rs.getString("email"));
                user.setImageLink(rs.getString("image_link"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setLastLogin(rs.getTimestamp("last_login"));
                user.setActive(rs.getBoolean("active"));
                
                // Check password (in a real app, you would use BCrypt to check hashed passwords)
                if (password.equals(user.getPassword())) {
                    // Authentication successful - update last login time
                    updateLastLogin(conn, user.getUserId());
                    
                    // Create session and store user
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    
                    // Redirect to appropriate dashboard
                    redirectToDashboard(request, response, user);
                    return;
                } else {
                    // Wrong password
                    request.setAttribute("error", "Invalid username or password");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                }
            } else {
                // User not found
                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            // Database error
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } finally {
            DBConnection.closeConnection(conn);
        }
    }
    
    /**
     * Update user's last login time
     */
    private void updateLastLogin(Connection conn, int userId) throws SQLException {
        String sql = "UPDATE Users SET last_login = ? WHERE user_id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setTimestamp(1, new Timestamp(new Date().getTime()));
        stmt.setInt(2, userId);
        stmt.executeUpdate();
    }
    
    /**
     * Redirect user to appropriate dashboard based on role
     */
    private void redirectToDashboard(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String contextPath = request.getContextPath();
        String role = user.getRole().toLowerCase();
        
        switch (role) {
            case "admin":
                response.sendRedirect(contextPath + "/admin/dashboard");
                break;
            case "teacher":
                response.sendRedirect(contextPath + "/teacher/dashboard");
                break;
            case "student":
                response.sendRedirect(contextPath + "/student/dashboard");
                break;
            case "parent":
                response.sendRedirect(contextPath + "/parent/dashboard");
                break;
            case "nurse":
                response.sendRedirect(contextPath + "/nurse/dashboard");
                break;
            case "doctor":
                response.sendRedirect(contextPath + "/doctor/dashboard");
                break;
            default:
                // Invalid role
                response.sendRedirect(contextPath + "/login");
                break;
        }
    }
} 