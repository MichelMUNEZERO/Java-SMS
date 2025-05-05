package com.sms.controller.student;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.model.Student;
import com.sms.model.User;
import com.sms.util.DBConnection;

/**
 * Servlet to handle student profile viewing and editing
 */
@WebServlet("/student/profile")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ProfileServlet.class.getName());
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in and has student role
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"student".equals(user.getRole().toLowerCase())) {
            response.sendRedirect(request.getContextPath() + "/" + user.getRole().toLowerCase() + "/dashboard");
            return;
        }
        
        // Get student ID from session
        Student student = (Student) session.getAttribute("student");
        int studentId = student != null ? student.getId() : 0;
        
        if (studentId == 0) {
            // Get student ID from user ID
            try {
                studentId = getStudentIdFromUserId(user.getUserId());
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error getting student ID", e);
                request.setAttribute("error", "Error loading profile: " + e.getMessage());
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
        }
        
        try {
            // Get student profile information
            Map<String, Object> profile = getStudentProfile(studentId);
            request.setAttribute("profile", profile);
            
            // Forward to profile JSP
            request.getRequestDispatcher("/WEB-INF/views/student/profile.jsp").forward(request, response);
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error loading student profile", e);
            request.setAttribute("error", "Error loading profile: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in and has student role
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"student".equals(user.getRole().toLowerCase())) {
            response.sendRedirect(request.getContextPath() + "/" + user.getRole().toLowerCase() + "/dashboard");
            return;
        }
        
        // Get student ID from session
        Student student = (Student) session.getAttribute("student");
        int studentId = student != null ? student.getId() : 0;
        
        if (studentId == 0) {
            // Get student ID from user ID
            try {
                studentId = getStudentIdFromUserId(user.getUserId());
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error getting student ID", e);
                request.setAttribute("error", "Error updating profile: " + e.getMessage());
                doGet(request, response);
                return;
            }
        }
        
        // Get form parameters
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        try {
            // Update basic information
            if (email != null && phone != null && address != null) {
                updateStudentInfo(studentId, email, phone, address);
                request.setAttribute("message", "Profile information updated successfully.");
            }
            
            // Update password if provided
            if (currentPassword != null && !currentPassword.isEmpty() &&
                newPassword != null && !newPassword.isEmpty() &&
                confirmPassword != null && !confirmPassword.isEmpty()) {
                
                if (!newPassword.equals(confirmPassword)) {
                    request.setAttribute("error", "New password and confirm password do not match.");
                } else if (!verifyCurrentPassword(user.getUserId(), currentPassword)) {
                    request.setAttribute("error", "Current password is incorrect.");
                } else {
                    updatePassword(user.getUserId(), newPassword);
                    request.setAttribute("message", "Password updated successfully.");
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating student profile", e);
            request.setAttribute("error", "Error updating profile: " + e.getMessage());
        }
        
        // Redirect back to profile page
        doGet(request, response);
    }
    
    private int getStudentIdFromUserId(int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT student_id FROM students WHERE user_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("student_id");
            }
            return 0;
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
    }
    
    private Map<String, Object> getStudentProfile(int studentId) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT s.*, u.username, u.email as user_email " +
                        "FROM students s " +
                        "JOIN users u ON s.user_id = u.user_id " +
                        "WHERE s.student_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Map<String, Object> profile = new HashMap<>();
                profile.put("studentId", rs.getInt("student_id"));
                profile.put("firstName", rs.getString("first_name"));
                profile.put("lastName", rs.getString("last_name"));
                profile.put("username", rs.getString("username"));
                profile.put("email", rs.getString("user_email"));
                profile.put("phone", rs.getString("phone"));
                profile.put("address", rs.getString("address"));
                profile.put("dateOfBirth", rs.getDate("date_of_birth"));
                profile.put("admissionDate", rs.getDate("admission_date"));
                profile.put("regNumber", rs.getString("reg_number"));
                return profile;
            }
            return null;
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
    }
    
    private void updateStudentInfo(int studentId, String email, String phone, String address) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE students s " +
                        "JOIN users u ON s.user_id = u.user_id " +
                        "SET u.email = ?, s.phone = ?, s.address = ? " +
                        "WHERE s.student_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            pstmt.setString(2, phone);
            pstmt.setString(3, address);
            pstmt.setInt(4, studentId);
            pstmt.executeUpdate();
        } finally {
            DBConnection.closeAll(conn, pstmt, null);
        }
    }
    
    private boolean verifyCurrentPassword(int userId, String currentPassword) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT password FROM users WHERE user_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String storedPassword = rs.getString("password");
                return currentPassword.equals(storedPassword);
            }
            return false;
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
    }
    
    private void updatePassword(int userId, String newPassword) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE users SET password = ? WHERE user_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newPassword);
            pstmt.setInt(2, userId);
            pstmt.executeUpdate();
        } finally {
            DBConnection.closeAll(conn, pstmt, null);
        }
    }
} 