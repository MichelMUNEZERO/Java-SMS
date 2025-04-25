package com.sms.controller.admin;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.dao.TeacherDAO;
import com.sms.model.Teacher;
import com.sms.model.User;

/**
 * Servlet for managing teachers
 */
@WebServlet(urlPatterns = { 
    "/admin/teachers", 
    "/admin/teachers/new",
    "/admin/teachers/edit/*",
    "/admin/teachers/delete/*",
    "/admin/teachers/view/*"
})
public class TeacherServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TeacherDAO teacherDAO;
    
    @Override
    public void init() throws ServletException {
        teacherDAO = new TeacherDAO();
    }
    
    /**
     * Handle GET requests - show teacher listings, forms, or details
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in and is an admin
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
        
        String pathInfo = request.getServletPath();
        String action = request.getRequestURI().substring(request.getContextPath().length());
        
        if (action.equals("/admin/teachers")) {
            // List all teachers
            listTeachers(request, response);
        } else if (action.equals("/admin/teachers/new")) {
            // Show form to add a new teacher
            showNewForm(request, response);
        } else if (action.startsWith("/admin/teachers/edit/")) {
            // Show form to edit an existing teacher
            showEditForm(request, response);
        } else if (action.startsWith("/admin/teachers/delete/")) {
            // Delete a teacher
            deleteTeacher(request, response);
        } else if (action.startsWith("/admin/teachers/view/")) {
            // View teacher details
            viewTeacher(request, response);
        } else {
            // Default to listing
            listTeachers(request, response);
        }
    }
    
    /**
     * Handle POST requests - process form submissions
     */
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
        
        if (action.equals("/admin/teachers/new")) {
            // Process new teacher form
            addTeacher(request, response);
        } else if (action.startsWith("/admin/teachers/edit/")) {
            // Process edit teacher form
            updateTeacher(request, response);
        } else {
            // Default redirect to listing
            response.sendRedirect(request.getContextPath() + "/admin/teachers");
        }
    }
    
    /**
     * List all teachers
     */
    private void listTeachers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get search parameter if any
        String searchQuery = request.getParameter("search");
        List<Teacher> teachers;
        
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            // Search for teachers matching the query
            teachers = teacherDAO.searchTeachers(searchQuery);
            request.setAttribute("searchQuery", searchQuery);
        } else {
            // Get all teachers
            teachers = teacherDAO.getAllTeachers();
        }
        
        request.setAttribute("teachers", teachers);
        request.getRequestDispatcher("/admin/teachers/list_teachers.jsp").forward(request, response);
    }
    
    /**
     * Show form to add a new teacher
     */
    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/teachers/add_teacher.jsp").forward(request, response);
    }
    
    /**
     * Show form to edit an existing teacher
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idStr = request.getPathInfo().substring(1); // Remove leading slash
        try {
            int id = Integer.parseInt(idStr);
            Teacher teacher = teacherDAO.getTeacherById(id);
            
            if (teacher != null) {
                request.setAttribute("teacher", teacher);
                request.getRequestDispatcher("/admin/teachers/edit_teacher.jsp").forward(request, response);
            } else {
                // Teacher not found
                request.setAttribute("errorMessage", "Teacher not found with ID: " + id);
                request.getRequestDispatcher("/admin/teachers").forward(request, response);
            }
        } catch (NumberFormatException e) {
            // Invalid ID format
            response.sendRedirect(request.getContextPath() + "/admin/teachers");
        }
    }
    
    /**
     * View teacher details
     */
    private void viewTeacher(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idStr = request.getPathInfo().substring(1); // Remove leading slash
        try {
            int id = Integer.parseInt(idStr);
            Teacher teacher = teacherDAO.getTeacherById(id);
            
            if (teacher != null) {
                request.setAttribute("teacher", teacher);
                request.getRequestDispatcher("/admin/teachers/view_teacher.jsp").forward(request, response);
            } else {
                // Teacher not found
                request.setAttribute("errorMessage", "Teacher not found with ID: " + id);
                request.getRequestDispatcher("/admin/teachers").forward(request, response);
            }
        } catch (NumberFormatException e) {
            // Invalid ID format
            response.sendRedirect(request.getContextPath() + "/admin/teachers");
        }
    }
    
    /**
     * Process new teacher form submission
     */
    private void addTeacher(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get form parameters
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String qualification = request.getParameter("qualification");
        String address = request.getParameter("address");
        String specialization = request.getParameter("specialization");
        
        // Validate required fields
        if (firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "First name, last name, and email are required");
            request.getRequestDispatcher("/admin/teachers/add_teacher.jsp").forward(request, response);
            return;
        }
        
        // Parse experience
        int experience = 0;
        try {
            String expStr = request.getParameter("experience");
            if (expStr != null && !expStr.trim().isEmpty()) {
                experience = Integer.parseInt(expStr);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Experience must be a valid number");
            request.getRequestDispatcher("/admin/teachers/add_teacher.jsp").forward(request, response);
            return;
        }
        
        // Create Teacher object
        Teacher teacher = new Teacher();
        teacher.setFirstName(firstName);
        teacher.setLastName(lastName);
        teacher.setEmail(email);
        teacher.setPhone(phone);
        teacher.setQualification(qualification);
        teacher.setExperience(experience);
        teacher.setSpecialization(specialization);
        teacher.setAddress(address);
        teacher.setStatus("Active");
        teacher.setJoinDate(new Date(System.currentTimeMillis()));
        
        // For now, we're not handling user account creation or image upload
        // These would typically be handled in a more complex implementation
        
        // Add teacher to database
        int teacherId = teacherDAO.addTeacher(teacher);
        
        if (teacherId > 0) {
            // Success - redirect to teacher list with success message
            request.getSession().setAttribute("successMessage", "Teacher added successfully!");
            response.sendRedirect(request.getContextPath() + "/admin/teachers");
        } else {
            // Error - show form again with error message
            request.setAttribute("errorMessage", "Failed to add teacher. Please try again.");
            request.setAttribute("teacher", teacher); // Keep form values
            request.getRequestDispatcher("/admin/teachers/add_teacher.jsp").forward(request, response);
        }
    }
    
    /**
     * Process edit teacher form submission
     */
    private void updateTeacher(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get teacher ID from path
        String idStr = request.getPathInfo().substring(1); // Remove leading slash
        
        try {
            int id = Integer.parseInt(idStr);
            
            // Get form parameters
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String qualification = request.getParameter("qualification");
            String address = request.getParameter("address");
            String specialization = request.getParameter("specialization");
            String status = request.getParameter("status");
            
            // Validate required fields
            if (firstName == null || firstName.trim().isEmpty() ||
                lastName == null || lastName.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {
                
                Teacher teacher = teacherDAO.getTeacherById(id);
                request.setAttribute("teacher", teacher);
                request.setAttribute("errorMessage", "First name, last name, and email are required");
                request.getRequestDispatcher("/admin/teachers/edit_teacher.jsp").forward(request, response);
                return;
            }
            
            // Parse experience
            int experience = 0;
            try {
                String expStr = request.getParameter("experience");
                if (expStr != null && !expStr.trim().isEmpty()) {
                    experience = Integer.parseInt(expStr);
                }
            } catch (NumberFormatException e) {
                Teacher teacher = teacherDAO.getTeacherById(id);
                request.setAttribute("teacher", teacher);
                request.setAttribute("errorMessage", "Experience must be a valid number");
                request.getRequestDispatcher("/admin/teachers/edit_teacher.jsp").forward(request, response);
                return;
            }
            
            // Get existing teacher to preserve data not in form
            Teacher existingTeacher = teacherDAO.getTeacherById(id);
            
            if (existingTeacher == null) {
                request.setAttribute("errorMessage", "Teacher not found with ID: " + id);
                response.sendRedirect(request.getContextPath() + "/admin/teachers");
                return;
            }
            
            // Update fields
            existingTeacher.setFirstName(firstName);
            existingTeacher.setLastName(lastName);
            existingTeacher.setEmail(email);
            existingTeacher.setPhone(phone);
            existingTeacher.setQualification(qualification);
            existingTeacher.setExperience(experience);
            existingTeacher.setSpecialization(specialization);
            existingTeacher.setAddress(address);
            
            if (status != null && !status.trim().isEmpty()) {
                existingTeacher.setStatus(status);
            }
            
            // Update teacher in database
            boolean success = teacherDAO.updateTeacher(existingTeacher);
            
            if (success) {
                // Success - redirect to teacher list with success message
                request.getSession().setAttribute("successMessage", "Teacher updated successfully!");
                response.sendRedirect(request.getContextPath() + "/admin/teachers");
            } else {
                // Error - show form again with error message
                request.setAttribute("errorMessage", "Failed to update teacher. Please try again.");
                request.setAttribute("teacher", existingTeacher); // Keep form values
                request.getRequestDispatcher("/admin/teachers/edit_teacher.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            // Invalid ID format
            response.sendRedirect(request.getContextPath() + "/admin/teachers");
        }
    }
    
    /**
     * Delete a teacher
     */
    private void deleteTeacher(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idStr = request.getPathInfo().substring(1); // Remove leading slash
        
        try {
            int id = Integer.parseInt(idStr);
            boolean success = teacherDAO.deleteTeacher(id);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Teacher deleted successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to delete teacher.");
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/teachers");
            
        } catch (NumberFormatException e) {
            // Invalid ID format
            response.sendRedirect(request.getContextPath() + "/admin/teachers");
        }
    }
} 