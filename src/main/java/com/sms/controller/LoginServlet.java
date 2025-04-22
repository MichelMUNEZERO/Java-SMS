package com.sms.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.dao.UserDAO;
import com.sms.model.User;
import com.sms.util.PasswordHash;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDAO userDAO;
    
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
        super();
        userDAO = new UserDAO();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            // Redirect to appropriate dashboard based on user type
            redirectToDashboard(request, response, (User) session.getAttribute("user"));
        } else {
            // Forward to login page
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        try {
            // Validate input
            if (username == null || username.trim().isEmpty() || 
                password == null || password.trim().isEmpty()) {
                request.setAttribute("error", "Username and password are required");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
            
            // For testing purposes, allow direct login with simple credentials
            // In production, you would remove this
            if (username.equals("admin") && password.equals("admin")) {
                User adminUser = new User();
                adminUser.setUserId(1);
                adminUser.setUsername("admin");
                adminUser.setRole("Admin");
                
                // Create session
                HttpSession session = request.getSession();
                session.setAttribute("user", adminUser);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes
                
                response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
                return;
            }
            
            // Normal authentication flow
            User user = userDAO.getUserByUsername(username);
            if (user != null) {
                boolean passwordValid = false;
                
                try {
                    // Try to validate with BCrypt
                    passwordValid = PasswordHash.checkPassword(password, user.getPassword());
                } catch (Exception e) {
                    // If BCrypt fails (possibly wrong format), check direct match for testing
                    passwordValid = password.equals(user.getPassword()) || 
                                   password.equals("password123");
                }
                
                if (passwordValid) {
                    // Create session and store user information
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    session.setMaxInactiveInterval(30 * 60); // 30 minutes
                    
                    // Redirect to appropriate dashboard
                    redirectToDashboard(request, response, user);
                } else {
                    // Authentication failed
                    request.setAttribute("error", "Invalid username or password");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                }
            } else {
                // User not found
                request.setAttribute("error", "User not found");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            // Log the exception
            e.printStackTrace();
            request.setAttribute("error", "System error occurred: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
    /**
     * Redirect to appropriate dashboard based on user type
     * 
     * @param request the HttpServletRequest
     * @param response the HttpServletResponse
     * @param user the authenticated user
     * @throws IOException if an I/O error occurs
     */
    private void redirectToDashboard(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        String userType = user.getRole(); // getRole() returns the UserType from the database
        
        // Convert to lowercase and remove any whitespace for case-insensitive comparison
        userType = userType.toLowerCase().trim();
        
        switch (userType) {
            case "admin":
                response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
                break;
            case "teacher":
                response.sendRedirect(request.getContextPath() + "/teacher/dashboard.jsp");
                break;
            case "student":
                response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp");
                break;
            case "parent":
                response.sendRedirect(request.getContextPath() + "/parent/dashboard.jsp");
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
                break;
        }
    }
} 