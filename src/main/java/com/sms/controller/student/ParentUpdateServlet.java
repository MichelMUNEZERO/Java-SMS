package com.sms.controller.student;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.model.Parent;
import com.sms.model.Student;
import com.sms.model.User;
import com.sms.util.DBConnection;

/**
 * Servlet to handle parent information updates by students
 */
@WebServlet("/student/update-parent")
public class ParentUpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ParentUpdateServlet.class.getName());
    
    /**
     * GET method to display current parent info or parent form
     */
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
            // For development/testing, could use a default ID
            studentId = 1;
        }
        
        // Get current parent information
        Parent parent = getParentInfo(studentId);
        request.setAttribute("parent", parent);
        
        // Forward to the parent update JSP
        request.getRequestDispatcher("/WEB-INF/views/student/update_parent.jsp").forward(request, response);
    }
    
    /**
     * POST method to process parent information updates
     */
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
            // For development/testing, could use a default ID
            studentId = 1;
        }
        
        // Get form parameters
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String occupation = request.getParameter("occupation");
        
        // Validate form data
        if (firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty()) {
            
            request.setAttribute("error", "First name, last name, and phone are required fields.");
            doGet(request, response);
            return;
        }
        
        // Get parent ID if exists
        Parent existingParent = getParentInfo(studentId);
        int parentId = existingParent != null ? existingParent.getId() : 0;
        
        boolean success;
        if (parentId > 0) {
            // Update existing parent
            success = updateParent(parentId, firstName, lastName, email, phone, address, occupation);
        } else {
            // Create new parent and link to student
            success = createParentAndLink(studentId, firstName, lastName, email, phone, address, occupation);
        }
        
        if (success) {
            request.setAttribute("message", "Parent information updated successfully.");
        } else {
            request.setAttribute("error", "Failed to update parent information.");
        }
        
        doGet(request, response);
    }
    
    /**
     * Retrieves parent information for a given student ID
     */
    private Parent getParentInfo(int studentId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Parent parent = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT p.* FROM Parents p " +
                         "JOIN Students s ON s.parent_id = p.parent_id " +
                         "WHERE s.student_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                parent = new Parent();
                parent.setId(rs.getInt("parent_id"));
                parent.setFirstName(rs.getString("first_name"));
                parent.setLastName(rs.getString("last_name"));
                parent.setEmail(rs.getString("email"));
                parent.setPhone(rs.getString("phone"));
                parent.setAddress(rs.getString("address"));
                parent.setOccupation(rs.getString("occupation"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving parent information", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return parent;
    }
    
    /**
     * Updates an existing parent record
     */
    private boolean updateParent(int parentId, String firstName, String lastName, 
                                 String email, String phone, String address, String occupation) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE Parents SET first_name = ?, last_name = ?, email = ?, " +
                         "phone = ?, address = ?, occupation = ? WHERE parent_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, firstName);
            pstmt.setString(2, lastName);
            pstmt.setString(3, email);
            pstmt.setString(4, phone);
            pstmt.setString(5, address);
            pstmt.setString(6, occupation);
            pstmt.setInt(7, parentId);
            
            int rowsAffected = pstmt.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating parent information", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, null);
        }
        
        return success;
    }
    
    /**
     * Creates a new parent record and links it to the student
     */
    private boolean createParentAndLink(int studentId, String firstName, String lastName, 
                                        String email, String phone, String address, String occupation) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // Insert new parent
            String insertSql = "INSERT INTO Parents (first_name, last_name, email, phone, address, occupation) " +
                              "VALUES (?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, firstName);
            pstmt.setString(2, lastName);
            pstmt.setString(3, email);
            pstmt.setString(4, phone);
            pstmt.setString(5, address);
            pstmt.setString(6, occupation);
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    int parentId = rs.getInt(1);
                    
                    // Link parent to student
                    DBConnection.closeStatement(pstmt);
                    String updateSql = "UPDATE Students SET parent_id = ? WHERE student_id = ?";
                    pstmt = conn.prepareStatement(updateSql);
                    pstmt.setInt(1, parentId);
                    pstmt.setInt(2, studentId);
                    
                    rowsAffected = pstmt.executeUpdate();
                    success = rowsAffected > 0;
                }
            }
            
            if (success) {
                conn.commit();
            } else {
                conn.rollback();
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating and linking parent information", e);
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error rolling back transaction", ex);
            }
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error resetting auto-commit", e);
            }
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return success;
    }
} 