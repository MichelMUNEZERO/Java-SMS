package com.sms.controller.admin;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.dao.NurseDAO;
import com.sms.model.Nurse;
import com.sms.model.User;

/**
 * Servlet for managing nurses in the admin section
 */
@WebServlet(urlPatterns = { 
    "/admin/nurses", 
    "/admin/nurses/new",
    "/admin/nurses/edit/*",
    "/admin/nurses/delete/*",
    "/admin/nurses/view/*"
})
public class NurseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(NurseServlet.class.getName());
    private NurseDAO nurseDAO;
    
    @Override
    public void init() throws ServletException {
        nurseDAO = new NurseDAO();
    }
    
    /**
     * Handle GET requests - show nurse listings, forms, or details
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
        
        try {
            if (action.equals("/admin/nurses") && pathInfo == null) {
                // Show all nurses
                listNurses(request, response);
            } else if (action.equals("/admin/nurses/new")) {
                // Show form to create new nurse
                showNewForm(request, response);
            } else if (pathInfo != null && pathInfo.startsWith("/edit/")) {
                // Show form to edit nurse
                showEditForm(request, response);
            } else if (pathInfo != null && pathInfo.startsWith("/delete/")) {
                // Delete a nurse
                deleteNurse(request, response);
            } else if (pathInfo != null && pathInfo.startsWith("/view/")) {
                // View nurse details
                viewNurse(request, response);
            } else {
                // Default - show all nurses
                listNurses(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing nurse request", e);
            request.setAttribute("errorMessage", "Error processing request: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle POST requests - create or update nurses
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getServletPath();
        
        try {
            if (action.equals("/admin/nurses/new")) {
                // Create new nurse
                createNurse(request, response);
            } else {
                // Update nurse
                updateNurse(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing nurse form submission", e);
            request.setAttribute("errorMessage", "Error processing form: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * List all nurses
     */
    private void listNurses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            List<Nurse> nurses = nurseDAO.getAllNurses();
            request.setAttribute("nurses", nurses);
            request.getRequestDispatcher("/admin/nurses.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error listing nurses", e);
            throw e;
        }
    }
    
    /**
     * Show form to create a new nurse
     */
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/admin/nurse_form.jsp").forward(request, response);
    }
    
    /**
     * Show form to edit an existing nurse
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String pathInfo = request.getPathInfo();
            int nurseId = Integer.parseInt(pathInfo.split("/")[2]);
            
            Nurse nurse = nurseDAO.getNurseById(nurseId);
            
            if (nurse != null) {
                request.setAttribute("nurse", nurse);
                request.getRequestDispatcher("/admin/nurse_form.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Nurse with ID " + nurseId + " not found.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading nurse for edit", e);
            throw e;
        }
    }
    
    /**
     * Delete a nurse
     */
    private void deleteNurse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String pathInfo = request.getPathInfo();
            int nurseId = Integer.parseInt(pathInfo.split("/")[2]);
            
            boolean success = nurseDAO.deleteNurse(nurseId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/nurses");
            } else {
                request.setAttribute("errorMessage", "Failed to delete nurse with ID " + nurseId);
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting nurse", e);
            throw e;
        }
    }
    
    /**
     * View nurse details
     */
    private void viewNurse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String pathInfo = request.getPathInfo();
            int nurseId = Integer.parseInt(pathInfo.split("/")[2]);
            
            Nurse nurse = nurseDAO.getNurseById(nurseId);
            
            if (nurse != null) {
                request.setAttribute("nurse", nurse);
                request.getRequestDispatcher("/admin/nurse_details.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Nurse with ID " + nurseId + " not found.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error viewing nurse details", e);
            throw e;
        }
    }
    
    /**
     * Create a new nurse
     */
    private void createNurse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Collect form data
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String qualification = request.getParameter("qualification");
            
            // Get username and password for account creation
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            
            // Validate required fields
            if (firstName == null || firstName.trim().isEmpty() ||
                lastName == null || lastName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
                
                request.setAttribute("errorMessage", "First name, last name, email, username, and password are required fields.");
                request.getRequestDispatcher("/admin/nurse_form.jsp").forward(request, response);
                return;
            }
            
            // Create nurse object
            Nurse nurse = new Nurse();
            nurse.setFirstName(firstName);
            nurse.setLastName(lastName);
            nurse.setEmail(email);
            nurse.setPhone(phone != null ? phone : "");
            nurse.setQualification(qualification != null ? qualification : "");
            
            // Create user account and add nurse to database
            boolean success = nurseDAO.addNurseWithUserAccount(nurse, username, password, "nurse");
            
            if (success) {
                // Redirect to nurse list with success message
                request.getSession().setAttribute("successMessage", "Nurse added successfully with login credentials!");
                response.sendRedirect(request.getContextPath() + "/admin/nurses");
            } else {
                request.setAttribute("errorMessage", "Failed to create nurse. Please try again.");
                request.setAttribute("nurse", nurse);
                request.getRequestDispatcher("/admin/nurse_form.jsp").forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating nurse", e);
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("/admin/nurse_form.jsp").forward(request, response);
        }
    }
    
    /**
     * Update an existing nurse
     */
    private void updateNurse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int nurseId = Integer.parseInt(request.getParameter("nurseId"));
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String qualification = request.getParameter("qualification");
            
            // Get username and password (might be empty for existing records)
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            
            // Get existing nurse to validate and preserve data
            Nurse existingNurse = nurseDAO.getNurseById(nurseId);
            if (existingNurse == null) {
                request.setAttribute("errorMessage", "Nurse not found with ID: " + nurseId);
                response.sendRedirect(request.getContextPath() + "/admin/nurses");
                return;
            }
            
            // Check if email already exists with different nurse
            List<Nurse> allNurses = nurseDAO.getAllNurses();
            for (Nurse otherNurse : allNurses) {
                if (otherNurse.getEmail().equalsIgnoreCase(email) && otherNurse.getNurseId() != nurseId) {
                    Nurse nurse = new Nurse();
                    nurse.setNurseId(nurseId);
                    nurse.setFirstName(firstName);
                    nurse.setLastName(lastName);
                    nurse.setEmail(email);
                    nurse.setPhone(phone);
                    nurse.setQualification(qualification);
                    nurse.setUserId(existingNurse.getUserId());
                    
                    request.setAttribute("nurse", nurse);
                    request.setAttribute("errorMessage", "A different nurse with this email already exists. Please use a different email.");
                    request.getRequestDispatcher("/admin/nurse_form.jsp").forward(request, response);
                    return;
                }
            }
            
            // Create nurse object with updated data
            Nurse nurse = new Nurse();
            nurse.setNurseId(nurseId);
            nurse.setFirstName(firstName);
            nurse.setLastName(lastName);
            nurse.setEmail(email);
            nurse.setPhone(phone);
            nurse.setQualification(qualification);
            nurse.setUserId(existingNurse.getUserId());
            
            boolean success;
            
            // Check if username and password were provided for updating
            if ((username != null && !username.trim().isEmpty()) || 
                (password != null && !password.trim().isEmpty())) {
                // Update nurse and credentials
                success = nurseDAO.updateNurseWithCredentials(nurse, username, password);
            } else {
                // Update only nurse information
                success = nurseDAO.updateNurse(nurse);
            }
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Nurse updated successfully");
                response.sendRedirect(request.getContextPath() + "/admin/nurses");
            } else {
                request.setAttribute("nurse", nurse);
                request.setAttribute("errorMessage", "Failed to update nurse. Please verify all fields and try again.");
                request.getRequestDispatcher("/admin/nurse_form.jsp").forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Exception updating nurse", e);
            throw new ServletException("Error updating nurse", e);
        }
    }
} 