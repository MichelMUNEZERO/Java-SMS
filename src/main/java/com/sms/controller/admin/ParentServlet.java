package com.sms.controller.admin;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.dao.ParentDAO;
import com.sms.model.Parent;
import com.sms.model.User;

/**
 * Servlet for managing parents in the admin section
 */
@WebServlet(urlPatterns = { 
    "/admin/parents", 
    "/admin/parents/new",
    "/admin/parents/edit/*",
    "/admin/parents/delete/*",
    "/admin/parents/view/*"
})
public class ParentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ParentDAO parentDAO;
    
    @Override
    public void init() throws ServletException {
        parentDAO = new ParentDAO();
    }
    
    /**
     * Handle GET requests - show parent listings, forms, or details
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getServletPath();
        
        if (action.equals("/admin/parents")) {
            // Show all parents
            listParents(request, response);
        } else if (action.equals("/admin/parents/new")) {
            // Show form to add a new parent
            showNewForm(request, response);
        } else if (action.startsWith("/admin/parents/edit/")) {
            // Show form to edit an existing parent
            showEditForm(request, response);
        } else if (action.startsWith("/admin/parents/delete/")) {
            // Delete a parent
            deleteParent(request, response);
        } else if (action.startsWith("/admin/parents/view/")) {
            // View parent details
            viewParent(request, response);
        } else {
            // Default to parent listing
            response.sendRedirect(request.getContextPath() + "/admin/parents");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check authentication similar to doGet
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getServletPath();
        
        if (action.equals("/admin/parents/new")) {
            // Process new parent form
            addParent(request, response);
        } else if (action.startsWith("/admin/parents/edit/")) {
            // Process edit parent form
            updateParent(request, response);
        } else {
            // Default redirect to listing
            response.sendRedirect(request.getContextPath() + "/admin/parents");
        }
    }
    
    /**
     * List all parents
     */
    private void listParents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Parent> parents = parentDAO.getAllParents();
        request.setAttribute("parents", parents);
        request.getRequestDispatcher("/admin/parents.jsp").forward(request, response);
    }
    
    /**
     * Show form to add a new parent
     */
    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/parent_form.jsp").forward(request, response);
    }
    
    /**
     * Show form to edit an existing parent
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        int parentId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
        
        Parent parent = parentDAO.getParentById(parentId);
        request.setAttribute("parent", parent);
        request.getRequestDispatcher("/admin/parent_form.jsp").forward(request, response);
    }
    
    /**
     * Add a new parent
     */
    private void addParent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Collect form data
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String occupation = request.getParameter("occupation");
        
        // Create parent object
        Parent parent = new Parent();
        parent.setFirstName(firstName);
        parent.setLastName(lastName);
        parent.setEmail(email);
        parent.setPhone(phone);
        parent.setAddress(address);
        parent.setOccupation(occupation);
        
        // Save to database
        boolean success = parentDAO.addParent(parent);
        
        if (success) {
            // Redirect to parent list with success message
            response.sendRedirect(request.getContextPath() + "/admin/parents?message=Parent added successfully");
        } else {
            // Redirect back to form with error message
            request.setAttribute("error", "Failed to add parent. Please try again.");
            request.setAttribute("parent", parent);
            request.getRequestDispatcher("/admin/parent_form.jsp").forward(request, response);
        }
    }
    
    /**
     * Update an existing parent
     */
    private void updateParent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get parent ID from path
        String pathInfo = request.getPathInfo();
        int parentId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
        
        // Collect form data
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String occupation = request.getParameter("occupation");
        
        // Create parent object
        Parent parent = new Parent();
        parent.setId(parentId);
        parent.setFirstName(firstName);
        parent.setLastName(lastName);
        parent.setEmail(email);
        parent.setPhone(phone);
        parent.setAddress(address);
        parent.setOccupation(occupation);
        
        // Update in database
        boolean success = parentDAO.updateParent(parent);
        
        if (success) {
            // Redirect to parent list with success message
            response.sendRedirect(request.getContextPath() + "/admin/parents?message=Parent updated successfully");
        } else {
            // Redirect back to form with error message
            request.setAttribute("error", "Failed to update parent. Please try again.");
            request.setAttribute("parent", parent);
            request.getRequestDispatcher("/admin/parent_form.jsp").forward(request, response);
        }
    }
    
    /**
     * Delete a parent
     */
    private void deleteParent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        int parentId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
        
        boolean success = parentDAO.deleteParent(parentId);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/parents?message=Parent deleted successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/parents?error=Failed to delete parent");
        }
    }
    
    /**
     * View parent details
     */
    private void viewParent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        int parentId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
        
        Parent parent = parentDAO.getParentById(parentId);
        request.setAttribute("parent", parent);
        request.getRequestDispatcher("/admin/parent_details.jsp").forward(request, response);
    }
} 