package com.sms.controller;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.dao.StudentDAO;
import com.sms.dao.UserDAO;
import com.sms.model.Student;
import com.sms.model.User;
import com.sms.util.PasswordHash;

/**
 * Servlet for handling Student operations
 */
@WebServlet("/student")
public class StudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private StudentDAO studentDAO;
    private UserDAO userDAO;
    
    /**
     * Initialize DAOs
     */
    public void init() {
        studentDAO = new StudentDAO();
        userDAO = new UserDAO();
    }
    
    /**
     * Handle GET requests
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteStudent(request, response);
                break;
            case "view":
                viewStudent(request, response);
                break;
            case "search":
                searchStudents(request, response);
                break;
            default:
                listStudents(request, response);
                break;
        }
    }
    
    /**
     * Handle POST requests
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        switch (action) {
            case "create":
                createStudent(request, response);
                break;
            case "update":
                updateStudent(request, response);
                break;
            default:
                listStudents(request, response);
                break;
        }
    }
    
    /**
     * Show form for adding a new student
     */
    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/student-form.jsp").forward(request, response);
    }
    
    /**
     * Show form for editing an existing student
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int studentId = Integer.parseInt(request.getParameter("id"));
        Student student = studentDAO.getStudentById(studentId);
        request.setAttribute("student", student);
        request.getRequestDispatcher("/admin/student-form.jsp").forward(request, response);
    }
    
    /**
     * View student details
     */
    private void viewStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int studentId = Integer.parseInt(request.getParameter("id"));
        Student student = studentDAO.getStudentById(studentId);
        request.setAttribute("student", student);
        request.getRequestDispatcher("/admin/student-view.jsp").forward(request, response);
    }
    
    /**
     * Create a new student
     */
    private void createStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Create user account first
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String hashedPassword = PasswordHash.hashPassword(password);
        
        User user = new User(username, hashedPassword, "Student");
        int userId = userDAO.addUser(user);
        
        if (userId > 0) {
            // Now create the student record
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String regNumber = request.getParameter("regNumber");
            String email = request.getParameter("email");
            String gender = request.getParameter("gender");
            String gradeClass = request.getParameter("gradeClass");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String medicalInfo = request.getParameter("medicalInfo");
            
            // Handle date parsing
            Date dateOfBirth = null;
            try {
                if (request.getParameter("dateOfBirth") != null && !request.getParameter("dateOfBirth").isEmpty()) {
                    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
                    dateOfBirth = format.parse(request.getParameter("dateOfBirth"));
                }
            } catch (ParseException e) {
                e.printStackTrace();
            }
            
            // Get parent ID if provided
            int parentId = 0;
            if (request.getParameter("parentId") != null && !request.getParameter("parentId").isEmpty()) {
                parentId = Integer.parseInt(request.getParameter("parentId"));
            }
            
            Student student = new Student(userId, firstName, lastName, regNumber, email, gender, 
                    dateOfBirth, gradeClass, parentId, phone, address, medicalInfo, "ACTIVE");
            
            boolean success = studentDAO.addStudent(student);
            
            if (success) {
                request.setAttribute("message", "Student created successfully");
            } else {
                request.setAttribute("error", "Failed to create student");
            }
        } else {
            request.setAttribute("error", "Failed to create user account");
        }
        
        listStudents(request, response);
    }
    
    /**
     * Update an existing student
     */
    private void updateStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        int userId = Integer.parseInt(request.getParameter("userId"));
        
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String regNumber = request.getParameter("regNumber");
        String email = request.getParameter("email");
        String gender = request.getParameter("gender");
        String gradeClass = request.getParameter("gradeClass");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String medicalInfo = request.getParameter("medicalInfo");
        String status = request.getParameter("status");
        
        // Handle date parsing
        Date dateOfBirth = null;
        try {
            if (request.getParameter("dateOfBirth") != null && !request.getParameter("dateOfBirth").isEmpty()) {
                SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
                dateOfBirth = format.parse(request.getParameter("dateOfBirth"));
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
        
        // Get parent ID if provided
        int parentId = 0;
        if (request.getParameter("parentId") != null && !request.getParameter("parentId").isEmpty()) {
            parentId = Integer.parseInt(request.getParameter("parentId"));
        }
        
        Student student = new Student(studentId, userId, firstName, lastName, regNumber, email, gender, 
                dateOfBirth, gradeClass, parentId, phone, address, medicalInfo, status);
        
        boolean success = studentDAO.updateStudent(student);
        
        if (success) {
            request.setAttribute("message", "Student updated successfully");
        } else {
            request.setAttribute("error", "Failed to update student");
        }
        
        listStudents(request, response);
    }
    
    /**
     * Delete a student
     */
    private void deleteStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int studentId = Integer.parseInt(request.getParameter("id"));
        
        boolean success = studentDAO.deleteStudent(studentId);
        
        if (success) {
            request.setAttribute("message", "Student deleted successfully");
        } else {
            request.setAttribute("error", "Failed to delete student");
        }
        
        listStudents(request, response);
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
     * Search for students
     */
    private void searchStudents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String searchTerm = request.getParameter("searchTerm");
        List<Student> students = studentDAO.searchStudents(searchTerm);
        request.setAttribute("students", students);
        request.setAttribute("searchTerm", searchTerm);
        request.getRequestDispatcher("/admin/students.jsp").forward(request, response);
    }
} 