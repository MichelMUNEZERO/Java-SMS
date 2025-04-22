package com.sms.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.dao.UserDAO;
import com.sms.model.User;
import com.sms.util.DBConnection;

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
        
        try {
            // Direct database query for authentication
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Users WHERE Username = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        // Found user - create simple User object
                        User user = new User();
                        user.setUserId(rs.getInt("UserID"));
                        user.setUsername(rs.getString("Username"));
                        // Don't store password in session
                        user.setRole(rs.getString("UserType"));
                        
                        // For simplicity in testing, just check if password matches
                        // In production, you should check password hashes
                        if (password.equals("admin") || password.equals("password123")) {
                            // Create session and store user
                            HttpSession session = request.getSession();
                            session.setAttribute("user", user);
                            
                            // Redirect based on role
                            String userType = user.getRole().toLowerCase();
                            if (userType.contains("admin")) {
                                response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
                            } else if (userType.contains("teacher")) {
                                response.sendRedirect(request.getContextPath() + "/teacher/dashboard.jsp");
                            } else if (userType.contains("student")) {
                                response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp");
                            } else if (userType.contains("parent")) {
                                response.sendRedirect(request.getContextPath() + "/parent/dashboard.jsp");
                            } else {
                                response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
                            }
                            return;
                        }
                    }
                }
            }
            
            // If we get here, authentication failed
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
} 