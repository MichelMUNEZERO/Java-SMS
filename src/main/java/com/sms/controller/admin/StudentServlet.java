package com.sms.controller.admin;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.dao.StudentDAO;
import com.sms.model.Student;
import com.sms.model.User;

/**
 * Servlet for managing students in the admin section
 */
@WebServlet(urlPatterns = { 
    "/admin/students", 
    "/admin/students/new",
    "/admin/students/edit/*",
    "/admin/students/delete/*",
    "/admin/students/view/*"
})
public class StudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StudentDAO studentDAO;
    private static final Logger LOGGER = Logger.getLogger(StudentServlet.class.getName());
    
    @Override
    public void init() throws ServletException {
        studentDAO = new StudentDAO();
    }
    
    /**
     * Handle GET requests - show student listings, forms, or details
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Debug information
        LOGGER.info("Servlet Path: " + request.getServletPath());
        LOGGER.info("Path Info: " + request.getPathInfo());
        LOGGER.info("Request URI: " + request.getRequestURI());
        
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
        
        if (action.equals("/admin/students")) {
            // Show all students
            listStudents(request, response);
        } else if (action.equals("/admin/students/new")) {
            // Show form to add a new student
            showNewForm(request, response);
        } else if (action.startsWith("/admin/students/edit")) {
            // Show form to edit an existing student
            showEditForm(request, response);
        } else if (action.startsWith("/admin/students/delete")) {
            // Delete a student
            deleteStudent(request, response);
        } else if (action.startsWith("/admin/students/view")) {
            // View student details
            viewStudent(request, response);
        } else {
            // Default to student listing
            LOGGER.warning("Unrecognized action: " + action + ", pathInfo: " + request.getPathInfo());
            response.sendRedirect(request.getContextPath() + "/admin/students");
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
        
        if (action.equals("/admin/students/new")) {
            // Process new student form
            addStudent(request, response);
        } else if (action.startsWith("/admin/students/edit/")) {
            // Process edit student form
            updateStudent(request, response);
        } else {
            // Default redirect to listing
            response.sendRedirect(request.getContextPath() + "/admin/students");
        }
    }
    
    /**
     * List all students
     */
    private void listStudents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Student> students = studentDAO.getAllStudents();
        request.setAttribute("students", students);
        request.getRequestDispatcher("/admin/students.jsp").forward(request, response);
    }
    
    /**
     * Show form to add a new student
     */
    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/student_form.jsp").forward(request, response);
    }
    
    /**
     * Show form to edit an existing student
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        LOGGER.info("Edit Form - Path Info: " + pathInfo);
        
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/admin/students?error=Invalid+student+ID");
            return;
        }
        
        try {
            int studentId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
            LOGGER.info("Edit Form - Student ID: " + studentId);
            
            Student student = studentDAO.getStudentById(studentId);
            if (student == null) {
                response.sendRedirect(request.getContextPath() + "/admin/students?error=Student+not+found");
                return;
            }
            
            request.setAttribute("student", student);
            
            try {
                request.getRequestDispatcher("/admin/student_form.jsp").forward(request, response);
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Error forwarding to JSP", e);
                response.sendRedirect(request.getContextPath() + "/admin/students?error=Error+loading+edit+form");
            }
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid student ID format: " + pathInfo);
            response.sendRedirect(request.getContextPath() + "/admin/students?error=Invalid+student+ID+format");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting student for edit form", e);
            response.sendRedirect(request.getContextPath() + "/admin/students?error=Error+processing+request");
        }
    }
    
    /**
     * Add a new student
     */
    private void addStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Collect form data
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String gender = request.getParameter("gender");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            
            // Process dates
            java.sql.Date dateOfBirth = null;
            if (request.getParameter("dateOfBirth") != null && !request.getParameter("dateOfBirth").isEmpty()) {
                dateOfBirth = java.sql.Date.valueOf(request.getParameter("dateOfBirth"));
            }
            
            java.sql.Date admissionDate = null;
            if (request.getParameter("admissionDate") != null && !request.getParameter("admissionDate").isEmpty()) {
                admissionDate = java.sql.Date.valueOf(request.getParameter("admissionDate"));
            }
            
            // Guardian information
            String guardianName = request.getParameter("guardianName");
            String guardianPhone = request.getParameter("guardianPhone");
            String guardianEmail = request.getParameter("guardianEmail");
            
            // Academic information
            int classId = 0;
            if (request.getParameter("classId") != null && !request.getParameter("classId").isEmpty()) {
                classId = Integer.parseInt(request.getParameter("classId"));
            }
            
            String status = request.getParameter("status");
            
            // Create student object
            Student student = new Student();
            student.setFirstName(firstName);
            student.setLastName(lastName);
            student.setGender(gender);
            student.setEmail(email);
            student.setPhone(phone);
            student.setAddress(address);
            student.setDateOfBirth(dateOfBirth);
            student.setAdmissionDate(admissionDate);
            student.setGuardianName(guardianName);
            student.setGuardianPhone(guardianPhone);
            student.setGuardianEmail(guardianEmail);
            student.setClassId(classId);
            student.setStatus(status);
            
            // Save to database
            boolean success = studentDAO.addStudent(student);
            
            if (success) {
                // Redirect to student list with success message
                response.sendRedirect(request.getContextPath() + "/admin/students?message=Student+added+successfully");
            } else {
                // Show form again with error message
                request.setAttribute("error", "Failed to add student. Please try again.");
                request.setAttribute("student", student);
                request.getRequestDispatcher("/admin/student_form.jsp").forward(request, response);
            }
        } catch (Exception e) {
            // Log the error
            LOGGER.log(Level.SEVERE, "Error adding student", e);
            
            // Show form with error message
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/admin/student_form.jsp").forward(request, response);
        }
    }
    
    /**
     * Update an existing student
     */
    private void updateStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        LOGGER.info("Update Student - Path Info: " + pathInfo);
        
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/admin/students?error=Invalid+student+ID");
            return;
        }
        
        try {
            int studentId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
            LOGGER.info("Update Student - Student ID: " + studentId);
            
            // Collect form data
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String gender = request.getParameter("gender");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            
            // Process dates
            java.sql.Date dateOfBirth = null;
            if (request.getParameter("dateOfBirth") != null && !request.getParameter("dateOfBirth").isEmpty()) {
                dateOfBirth = java.sql.Date.valueOf(request.getParameter("dateOfBirth"));
            }
            
            java.sql.Date admissionDate = null;
            if (request.getParameter("admissionDate") != null && !request.getParameter("admissionDate").isEmpty()) {
                admissionDate = java.sql.Date.valueOf(request.getParameter("admissionDate"));
            }
            
            // Guardian information
            String guardianName = request.getParameter("guardianName");
            String guardianPhone = request.getParameter("guardianPhone");
            String guardianEmail = request.getParameter("guardianEmail");
            
            // Academic information
            int classId = 0;
            if (request.getParameter("classId") != null && !request.getParameter("classId").isEmpty()) {
                classId = Integer.parseInt(request.getParameter("classId"));
            }
            
            String status = request.getParameter("status");
            
            // Create student object
            Student student = new Student();
            student.setId(studentId);
            student.setFirstName(firstName);
            student.setLastName(lastName);
            student.setGender(gender);
            student.setEmail(email);
            student.setPhone(phone);
            student.setAddress(address);
            student.setDateOfBirth(dateOfBirth);
            student.setAdmissionDate(admissionDate);
            student.setGuardianName(guardianName);
            student.setGuardianPhone(guardianPhone);
            student.setGuardianEmail(guardianEmail);
            student.setClassId(classId);
            student.setStatus(status);
            
            // Update in database
            boolean success = studentDAO.updateStudent(student);
            
            if (success) {
                // Redirect to student list with success message
                response.sendRedirect(request.getContextPath() + "/admin/students?message=Student+updated+successfully");
            } else {
                // Show form again with error message
                request.setAttribute("error", "Failed to update student. Please try again.");
                request.setAttribute("student", student);
                request.getRequestDispatcher("/admin/student_form.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid student ID format: " + pathInfo);
            response.sendRedirect(request.getContextPath() + "/admin/students?error=Invalid+student+ID+format");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating student", e);
            response.sendRedirect(request.getContextPath() + "/admin/students?error=Error+updating+student");
        }
    }
    
    /**
     * Delete a student
     */
    private void deleteStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        LOGGER.info("Delete Student - Path Info: " + pathInfo);
        
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/admin/students?error=Invalid+student+ID");
            return;
        }
        
        try {
            int studentId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
            LOGGER.info("Delete Student - Student ID: " + studentId);
            
            boolean success = studentDAO.deleteStudent(studentId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/students?message=Student+deleted+successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/students?error=Failed+to+delete+student");
            }
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid student ID format: " + pathInfo);
            response.sendRedirect(request.getContextPath() + "/admin/students?error=Invalid+student+ID+format");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting student", e);
            response.sendRedirect(request.getContextPath() + "/admin/students?error=Error+deleting+student");
        }
    }
    
    /**
     * View student details
     */
    private void viewStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        LOGGER.info("View Student - Path Info: " + pathInfo);
        
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/admin/students?error=Invalid+student+ID");
            return;
        }
        
        try {
            int studentId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
            LOGGER.info("View Student - Student ID: " + studentId);
            
            Student student = studentDAO.getStudentById(studentId);
            if (student == null) {
                response.sendRedirect(request.getContextPath() + "/admin/students?error=Student+not+found");
                return;
            }
            
            request.setAttribute("student", student);
            
            try {
                request.getRequestDispatcher("/admin/student_details.jsp").forward(request, response);
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Error forwarding to JSP", e);
                response.sendRedirect(request.getContextPath() + "/admin/students?error=Error+loading+student+details");
            }
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid student ID format: " + pathInfo);
            response.sendRedirect(request.getContextPath() + "/admin/students?error=Invalid+student+ID+format");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting student details", e);
            response.sendRedirect(request.getContextPath() + "/admin/students?error=Error+processing+request");
        }
    }
} 