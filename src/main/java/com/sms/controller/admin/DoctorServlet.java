package com.sms.controller.admin;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.dao.DoctorDAO;
import com.sms.model.Doctor;
import com.sms.model.User;

/**
 * Servlet for managing doctors in the admin section
 */
@WebServlet(urlPatterns = { 
    "/admin/doctors", 
    "/admin/doctors/new",
    "/admin/doctors/edit/*",
    "/admin/doctors/delete/*",
    "/admin/doctors/view/*"
})
public class DoctorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DoctorDAO doctorDAO;
    
    @Override
    public void init() throws ServletException {
        doctorDAO = new DoctorDAO();
    }
    
    /**
     * Handle GET requests - show doctor listings, forms, or details
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in and has admin role
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"admin".equals(user.getRole().toLowerCase())) {
            response.sendRedirect(request.getContextPath() + "/" + user.getRole().toLowerCase() + "/dashboard");
            return;
        }
        
        String action = request.getServletPath();
        String pathInfo = request.getPathInfo();
        
        if (action.equals("/admin/doctors")) {
            // Show all doctors
            listDoctors(request, response);
        } else if (action.equals("/admin/doctors/new")) {
            // Show form to add a new doctor
            showNewForm(request, response);
        } else if (action.startsWith("/admin/doctors/edit/") && pathInfo != null) {
            // Show form to edit an existing doctor
            showEditForm(request, response);
        } else if (action.startsWith("/admin/doctors/delete/") && pathInfo != null) {
            // Delete a doctor
            deleteDoctor(request, response);
        } else if (action.startsWith("/admin/doctors/view/") && pathInfo != null) {
            // View doctor details
            viewDoctor(request, response);
        } else {
            // Default to doctor listing
            response.sendRedirect(request.getContextPath() + "/admin/doctors");
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
        if (!"admin".equals(user.getRole().toLowerCase())) {
            response.sendRedirect(request.getContextPath() + "/" + user.getRole().toLowerCase() + "/dashboard");
            return;
        }
        
        String action = request.getServletPath();
        String pathInfo = request.getPathInfo();
        
        if (action.equals("/admin/doctors/new")) {
            // Process new doctor form
            addDoctor(request, response);
        } else if (action.startsWith("/admin/doctors/edit/") && pathInfo != null) {
            // Process edit doctor form
            updateDoctor(request, response);
        } else {
            // Default redirect to listing
            response.sendRedirect(request.getContextPath() + "/admin/doctors");
        }
    }
    
    /**
     * List all doctors
     */
    private void listDoctors(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Doctor> doctors = doctorDAO.getAllDoctors();
        request.setAttribute("doctors", doctors);
        request.getRequestDispatcher("/admin/doctors.jsp").forward(request, response);
    }
    
    /**
     * Show form to add a new doctor
     */
    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/doctor_form.jsp").forward(request, response);
    }
    
    /**
     * Show form to edit an existing doctor
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            int doctorId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
            
            Doctor doctor = doctorDAO.getDoctorById(doctorId);
            if (doctor != null) {
                request.setAttribute("doctor", doctor);
                request.getRequestDispatcher("/admin/doctor_form.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/doctors?error=Doctor not found");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/doctors?error=Invalid doctor ID");
        }
    }
    
    /**
     * Add a new doctor
     */
    private void addDoctor(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Collect form data
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String specialization = request.getParameter("specialization");
        String hospital = request.getParameter("hospital");
        
        // Get username and password for account creation
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Validate required fields
        if (firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            // Return to form with error message
            request.setAttribute("error", "First name, last name, email, username, and password are required fields.");
            request.getRequestDispatcher("/admin/doctor_form.jsp").forward(request, response);
            return;
        }
        
        // Create doctor object
        Doctor doctor = new Doctor();
        doctor.setFirstName(firstName);
        doctor.setLastName(lastName);
        doctor.setEmail(email);
        doctor.setPhone(phone);
        doctor.setSpecialization(specialization);
        doctor.setHospital(hospital);
        
        // Save to database with user account
        boolean success = doctorDAO.addDoctorWithUserAccount(doctor, username, password, "doctor");
        
        if (success) {
            // Redirect to doctor list with success message
            response.sendRedirect(request.getContextPath() + "/admin/doctors?success=Doctor added successfully with login credentials");
        } else {
            // Redirect back to form with error message
            request.setAttribute("error", "Failed to add doctor. Please try again.");
            request.setAttribute("doctor", doctor);
            request.getRequestDispatcher("/admin/doctor_form.jsp").forward(request, response);
        }
    }
    
    /**
     * Update an existing doctor
     */
    private void updateDoctor(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Get doctor ID from path
            String pathInfo = request.getPathInfo();
            int doctorId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
            
            // Collect form data
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String specialization = request.getParameter("specialization");
            String hospital = request.getParameter("hospital");
            
            // Get username and password (might be empty for existing records)
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            
            // Get original doctor to preserve any fields not in the form
            Doctor originalDoctor = doctorDAO.getDoctorById(doctorId);
            
            if (originalDoctor != null) {
                // Create doctor object
                Doctor doctor = new Doctor();
                doctor.setDoctorId(doctorId);
                doctor.setFirstName(firstName);
                doctor.setLastName(lastName);
                doctor.setEmail(email);
                doctor.setPhone(phone);
                doctor.setSpecialization(specialization);
                doctor.setHospital(hospital);
                doctor.setUserId(originalDoctor.getUserId()); // Preserve the user ID
                
                boolean success;
                
                // Check if username and password were provided for updating
                if ((username != null && !username.trim().isEmpty()) || 
                    (password != null && !password.trim().isEmpty())) {
                    // Update doctor and credentials
                    success = doctorDAO.updateDoctorWithCredentials(doctor, username, password);
                } else {
                    // Update only doctor information
                    success = doctorDAO.updateDoctor(doctor);
                }
                
                if (success) {
                    // Redirect to doctor list with success message
                    response.sendRedirect(request.getContextPath() + "/admin/doctors?success=Doctor updated successfully");
                } else {
                    // Redirect back to form with error message
                    request.setAttribute("error", "Failed to update doctor. Please try again.");
                    request.setAttribute("doctor", doctor);
                    request.getRequestDispatcher("/admin/doctor_form.jsp").forward(request, response);
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/doctors?error=Doctor not found");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/doctors?error=Invalid doctor ID");
        }
    }
    
    /**
     * Delete a doctor
     */
    private void deleteDoctor(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            int doctorId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
            
            boolean success = doctorDAO.deleteDoctor(doctorId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/doctors?success=Doctor deleted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/doctors?error=Failed to delete doctor");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/doctors?error=Invalid doctor ID");
        }
    }
    
    /**
     * View doctor details
     */
    private void viewDoctor(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            int doctorId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
            
            Doctor doctor = doctorDAO.getDoctorById(doctorId);
            if (doctor != null) {
                request.setAttribute("doctor", doctor);
                request.getRequestDispatcher("/admin/doctor_details.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Doctor not found with ID: " + doctorId);
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid doctor ID format");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error viewing doctor details: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 