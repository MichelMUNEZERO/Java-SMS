package com.sms.controller.admin;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.sms.dao.UserDAO;
import com.sms.model.User;
import com.sms.util.FileUpload;
import com.sms.util.PasswordHash;

/**
 * Servlet implementation class UserServlet for handling user management
 */
@WebServlet("/admin/UserServlet")
@MultipartConfig
public class UserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDAO userDAO;
    
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UserServlet() {
        super();
        userDAO = new UserDAO();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get all users
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        
        // Forward to users.jsp
        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get the action parameter
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/UserServlet");
            return;
        }
        
        // Perform action based on parameter
        switch (action) {
            case "add":
                addUser(request, response);
                break;
            case "update":
                updateUser(request, response);
                break;
            case "delete":
                deleteUser(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/UserServlet");
                break;
        }
    }
    
    /**
     * Handle add user request
     * @param request the HttpServletRequest
     * @param response the HttpServletResponse
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private void addUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String userType = request.getParameter("userType");
        
        // Validate input
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty() || 
            userType == null || userType.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required");
            request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
            return;
        }
        
        // Check if username already exists
        User existingUser = userDAO.getUserByUsername(username);
        if (existingUser != null) {
            request.setAttribute("errorMessage", "Username already exists");
            request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
            return;
        }
        
        // Hash the password
        String hashedPassword = PasswordHash.hashPassword(password);
        
        // Upload profile image if provided
        String imageLink = null;
        Part filePart = request.getPart("profileImage");
        if (filePart != null && filePart.getSize() > 0) {
            imageLink = FileUpload.uploadFile(request, "profileImage");
        }
        
        // Create new user
        User user = new User();
        user.setUsername(username);
        user.setPassword(hashedPassword);
        user.setUserType(userType);
        user.setImageLink(imageLink);
        
        // Add user to database
        int userId = userDAO.addUser(user);
        
        // Check if user was added successfully
        if (userId > 0) {
            request.setAttribute("successMessage", "User added successfully");
        } else {
            request.setAttribute("errorMessage", "Failed to add user");
        }
        
        // Redirect to user list
        response.sendRedirect(request.getContextPath() + "/admin/UserServlet");
    }
    
    /**
     * Handle update user request
     * @param request the HttpServletRequest
     * @param response the HttpServletResponse
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private void updateUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get form parameters
        String userId = request.getParameter("userId");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String userType = request.getParameter("userType");
        
        // Validate input
        if (userId == null || userId.trim().isEmpty() || 
            username == null || username.trim().isEmpty() || 
            userType == null || userType.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Invalid input");
            request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
            return;
        }
        
        // Get existing user
        User user = userDAO.getUserByUsername(username);
        if (user == null || user.getUserId() != Integer.parseInt(userId)) {
            // Check if new username already exists for a different user
            User existingUser = userDAO.getUserByUsername(username);
            if (existingUser != null && existingUser.getUserId() != Integer.parseInt(userId)) {
                request.setAttribute("errorMessage", "Username already exists");
                request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
                return;
            }
            
            // Get user by ID if different username
            user = new User();
            user.setUserId(Integer.parseInt(userId));
        }
        
        // Update user data
        user.setUsername(username);
        user.setUserType(userType);
        
        // Update password if provided
        if (password != null && !password.trim().isEmpty()) {
            String hashedPassword = PasswordHash.hashPassword(password);
            user.setPassword(hashedPassword);
        }
        
        // Upload new profile image if provided
        Part filePart = request.getPart("profileImage");
        if (filePart != null && filePart.getSize() > 0) {
            String imageLink = FileUpload.uploadFile(request, "profileImage");
            user.setImageLink(imageLink);
        }
        
        // Update user in database
        boolean success = userDAO.updateUser(user);
        
        // Check if user was updated successfully
        if (success) {
            request.setAttribute("successMessage", "User updated successfully");
        } else {
            request.setAttribute("errorMessage", "Failed to update user");
        }
        
        // Redirect to user list
        response.sendRedirect(request.getContextPath() + "/admin/UserServlet");
    }
    
    /**
     * Handle delete user request
     * @param request the HttpServletRequest
     * @param response the HttpServletResponse
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private void deleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get user ID
        String userId = request.getParameter("userId");
        
        // Validate input
        if (userId == null || userId.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Invalid user ID");
            request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
            return;
        }
        
        // Delete user from database
        boolean success = userDAO.deleteUser(Integer.parseInt(userId));
        
        // Check if user was deleted successfully
        if (success) {
            request.setAttribute("successMessage", "User deleted successfully");
        } else {
            request.setAttribute("errorMessage", "Failed to delete user");
        }
        
        // Redirect to user list
        response.sendRedirect(request.getContextPath() + "/admin/UserServlet");
    }
} 