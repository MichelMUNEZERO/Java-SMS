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
            redirectToDashboard(response, (User) session.getAttribute("user"));
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
        
        // Validate input
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        // Check user credentials
        User user = userDAO.getUserByUsername(username);
        if (user != null && PasswordHash.checkPassword(password, user.getPassword())) {
            // Create session and store user information
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes
            
            // Redirect to appropriate dashboard
            redirectToDashboard(response, user);
        } else {
            // Authentication failed
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
    /**
     * Redirect to appropriate dashboard based on user type
     * 
     * @param response the HttpServletResponse
     * @param user the authenticated user
     * @throws IOException if an I/O error occurs
     */
    private void redirectToDashboard(HttpServletResponse response, User user) throws IOException {
        String userType = user.getRole(); // getRole() returns the UserType from the database
        
        // Convert to lowercase and remove any whitespace for case-insensitive comparison
        userType = userType.toLowerCase().trim();
        
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