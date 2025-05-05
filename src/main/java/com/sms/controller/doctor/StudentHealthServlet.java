package com.sms.controller.doctor;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.dao.StudentDAO;
import com.sms.dao.HealthRecordDAO;
import com.sms.model.Student;
import com.sms.model.User;

/**
 * Servlet to handle doctor's student health records
 */
@WebServlet("/doctor/students")
public class StudentHealthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StudentDAO studentDAO;
    private HealthRecordDAO healthRecordDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        studentDAO = new StudentDAO();
        healthRecordDAO = new HealthRecordDAO();
    }
    
    /**
     * Handle GET requests - show list of students for health records
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"doctor".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get student ID parameter if viewing a specific student
            String studentIdParam = request.getParameter("id");
            
            if (studentIdParam != null && !studentIdParam.isEmpty()) {
                // View a specific student's health record
                int studentId = Integer.parseInt(studentIdParam);
                Student student = studentDAO.getStudentById(studentId);
                
                if (student != null) {
                    request.setAttribute("student", student);
                    request.setAttribute("healthRecords", healthRecordDAO.getHealthRecordsByStudentId(studentId));
                    request.getRequestDispatcher("/doctor/student_health_record.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Student not found");
                    request.getRequestDispatcher("/error.jsp").forward(request, response);
                }
            } else {
                // List all students
                List<Student> students = studentDAO.getAllStudents();
                request.setAttribute("students", students);
                request.getRequestDispatcher("/doctor/students.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid student ID");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading student health records: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle POST requests - add or update health records
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"doctor".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Handle form submissions for adding/updating health records
        // This would be implemented based on the specific requirements
        // For now, just redirect back to the student list
        response.sendRedirect(request.getContextPath() + "/doctor/students");
    }
} 