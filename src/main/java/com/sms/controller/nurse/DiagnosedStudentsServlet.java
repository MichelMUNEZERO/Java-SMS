package com.sms.controller.nurse;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.dao.HealthRecordDAO;
import com.sms.dao.StudentDAO;
import com.sms.model.HealthRecord;
import com.sms.model.Student;
import com.sms.model.User;

/**
 * Servlet to handle diagnosed students for nurse
 */
@WebServlet("/nurse/diagnosed-students")
public class DiagnosedStudentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private HealthRecordDAO healthRecordDAO;
    private StudentDAO studentDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        healthRecordDAO = new HealthRecordDAO();
        studentDAO = new StudentDAO();
    }
    
    /**
     * Handle GET requests - show diagnosed students
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"nurse".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get all diagnosed students (we'll need to add this method to HealthRecordDAO)
            List<HealthRecord> diagnosedStudents = healthRecordDAO.getDiagnosedStudents();
            request.setAttribute("diagnosedStudents", diagnosedStudents);
            
            // Forward to diagnosed students page
            request.getRequestDispatcher("/nurse/diagnosed_students.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading diagnosed students: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 