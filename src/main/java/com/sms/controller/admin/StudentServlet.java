package com.sms.controller.admin;

import java.io.IOException;
import java.util.List;

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
    
    @Override
    public void init() throws ServletException {
        studentDAO = new StudentDAO();
    }
    
    /**
     * Handle GET requests - show student listings, forms, or details
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
        
        if (action.equals("/admin/students")) {
            // Show all students
            listStudents(request, response);
        } else if (action.equals("/admin/students/new")) {
            // Show form to add a new student
            showNewForm(request, response);
        } else if (action.startsWith("/admin/students/edit/")) {
            // Show form to edit an existing student
            showEditForm(request, response);
        } else if (action.startsWith("/admin/students/delete/")) {
            // Delete a student
            deleteStudent(request, response);
        } else if (action.startsWith("/admin/students/view/")) {
            // View student details
            viewStudent(request, response);
        } else {
            // Default to student listing
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
        int studentId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
        
        Student student = studentDAO.getStudentById(studentId);
        request.setAttribute("student", student);
        request.getRequestDispatcher("/admin/student_form.jsp").forward(request, response);
    }
    
    /**
     * Add a new student
     */
    private void addStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Collect form data
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        java.sql.Date dateOfBirth = java.sql.Date.valueOf(request.getParameter("dateOfBirth"));
        java.sql.Date admissionDate = java.sql.Date.valueOf(request.getParameter("admissionDate"));
        int classId = Integer.parseInt(request.getParameter("classId"));
        String status = request.getParameter("status");
        
        // Create student object
        Student student = new Student();
        student.setFirstName(firstName);
        student.setLastName(lastName);
        student.setEmail(email);
        student.setPhone(phone);
        student.setAddress(address);
        student.setDateOfBirth(dateOfBirth);
        student.setAdmissionDate(admissionDate);
        student.setClassId(classId);
        student.setStatus(status);
        
        // Save to database
        boolean success = studentDAO.addStudent(student);
        
        if (success) {
            // Redirect to student list with success message
            response.sendRedirect(request.getContextPath() + "/admin/students?message=Student added successfully");
        } else {
            // Redirect back to form with error message
            request.setAttribute("error", "Failed to add student. Please try again.");
            request.setAttribute("student", student);
            request.getRequestDispatcher("/admin/student_form.jsp").forward(request, response);
        }
    }
    
    /**
     * Update an existing student
     */
    private void updateStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get student ID from path
        String pathInfo = request.getPathInfo();
        int studentId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
        
        // Collect form data
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        java.sql.Date dateOfBirth = java.sql.Date.valueOf(request.getParameter("dateOfBirth"));
        java.sql.Date admissionDate = java.sql.Date.valueOf(request.getParameter("admissionDate"));
        int classId = Integer.parseInt(request.getParameter("classId"));
        String status = request.getParameter("status");
        
        // Create student object
        Student student = new Student();
        student.setId(studentId);
        student.setFirstName(firstName);
        student.setLastName(lastName);
        student.setEmail(email);
        student.setPhone(phone);
        student.setAddress(address);
        student.setDateOfBirth(dateOfBirth);
        student.setAdmissionDate(admissionDate);
        student.setClassId(classId);
        student.setStatus(status);
        
        // Update in database
        boolean success = studentDAO.updateStudent(student);
        
        if (success) {
            // Redirect to student list with success message
            response.sendRedirect(request.getContextPath() + "/admin/students?message=Student updated successfully");
        } else {
            // Redirect back to form with error message
            request.setAttribute("error", "Failed to update student. Please try again.");
            request.setAttribute("student", student);
            request.getRequestDispatcher("/admin/student_form.jsp").forward(request, response);
        }
    }
    
    /**
     * Delete a student
     */
    private void deleteStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        int studentId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
        
        boolean success = studentDAO.deleteStudent(studentId);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/students?message=Student deleted successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/students?error=Failed to delete student");
        }
    }
    
    /**
     * View student details
     */
    private void viewStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        int studentId = Integer.parseInt(pathInfo.substring(1)); // Remove the '/' from the path info
        
        Student student = studentDAO.getStudentById(studentId);
        request.setAttribute("student", student);
        request.getRequestDispatcher("/admin/student_details.jsp").forward(request, response);
    }
} 