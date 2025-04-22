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
    
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
        super();
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
        
        UserDAO userDAO = null;
        
        try {
            // Validate input
            if (username == null || username.trim().isEmpty() || 
                password == null || password.trim().isEmpty()) {
                request.setAttribute("error", "Username and password are required");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
            
            // For admin direct login
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
            
            // Create UserDAO
            userDAO = new UserDAO();
            
            // Normal authentication flow
            User user = userDAO.getUserByUsername(username);
            if (user != null) {
                // Check password
                boolean passwordValid = PasswordHash.checkPassword(password, user.getPassword());
                
                if (passwordValid) {
                    // Create session and store user information
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    session.setMaxInactiveInterval(30 * 60); // 30 minutes
                    
                    // Redirect to appropriate dashboard
                    redirectToDashboard(request, response, user);
                } else {
                    // Authentication failed
                    request.setAttribute("error", "Invalid password");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                }
            } else {
                // User not found
                request.setAttribute("error", "Username not found");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            // Log the exception
            getServletContext().log("Login error: " + e.getMessage(), e);
            request.setAttribute("error", "System error occurred. Please try again later.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } finally {
            // Close resources
            if (userDAO != null) {
                userDAO.close();
            }
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