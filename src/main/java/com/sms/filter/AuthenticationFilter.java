package com.sms.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.model.User;

/**
 * Authentication filter to restrict access to protected resources
 */
@WebFilter(urlPatterns = { "/admin/*", "/teacher/*", "/student/*", "/parent/*" })
public class AuthenticationFilter implements Filter {

    /**
     * @see Filter#init(FilterConfig)
     */
    public void init(FilterConfig fConfig) throws ServletException {
    }

    /**
     * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
     */
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        
        // Get current session
        HttpSession session = req.getSession(false);
        
        // Check if user is authenticated
        boolean isAuthenticated = (session != null && session.getAttribute("user") != null);
        
        if (!isAuthenticated) {
            // User is not authenticated, redirect to login page
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        // Get the requested URL and user type
        String requestURI = req.getRequestURI();
        User user = (User) session.getAttribute("user");
        String userType = user.getRole().toLowerCase().trim();
        
        // Check if user has the appropriate role for the requested resource
        boolean hasPermission = false;
        
        if (requestURI.contains("/admin/") && userType.equalsIgnoreCase("admin")) {
            hasPermission = true;
        } else if (requestURI.contains("/teacher/") && userType.equalsIgnoreCase("teacher")) {
            hasPermission = true;
        } else if (requestURI.contains("/student/") && userType.equalsIgnoreCase("student")) {
            hasPermission = true;
        } else if (requestURI.contains("/parent/") && userType.equalsIgnoreCase("parent")) {
            hasPermission = true;
        }
        
        if (hasPermission) {
            // User has permission, continue with the request
            chain.doFilter(request, response);
        } else {
            // User does not have permission, redirect to appropriate dashboard
            switch (userType.toLowerCase()) {
                case "admin":
                    res.sendRedirect(req.getContextPath() + "/admin/dashboard.jsp");
                    break;
                case "teacher":
                    res.sendRedirect(req.getContextPath() + "/teacher/dashboard.jsp");
                    break;
                case "student":
                    res.sendRedirect(req.getContextPath() + "/student/dashboard.jsp");
                    break;
                case "parent":
                    res.sendRedirect(req.getContextPath() + "/parent/dashboard.jsp");
                    break;
                default:
                    res.sendRedirect(req.getContextPath() + "/login");
                    break;
            }
        }
    }

    /**
     * @see Filter#destroy()
     */
    public void destroy() {
    }
} 