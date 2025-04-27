package com.sms.controller.parent;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.dao.BehaviorDAO;
import com.sms.dao.MarksDAO;
import com.sms.dao.ParentDAO;
import com.sms.dao.StudentDAO;
import com.sms.model.Parent;
import com.sms.model.Student;
import com.sms.model.User;

/**
 * Servlet to handle student progress viewing for parents
 */
@WebServlet("/parent/student-progress")
public class StudentProgressServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private StudentDAO studentDAO;
    private BehaviorDAO behaviorDAO;
    private MarksDAO marksDAO;
    private ParentDAO parentDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        studentDAO = new StudentDAO();
        behaviorDAO = new BehaviorDAO();
        marksDAO = new MarksDAO();
        parentDAO = new ParentDAO();
    }
    
    /**
     * Handle GET requests - show student progress
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and has parent role
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            // Not logged in, redirect to login page
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"parent".equals(user.getRole().toLowerCase())) {
            // Not a parent, redirect to appropriate dashboard
            response.sendRedirect(request.getContextPath() + "/" + user.getRole().toLowerCase() + "/dashboard");
            return;
        }
        
        try {
            // Get parent by user ID
            int userId = user.getUserId();
            Parent parent = parentDAO.getParentByUserId(userId);
            
            // Get list of children for this parent
            List<Student> children = studentDAO.getStudentsByParent(parent.getId());
            request.setAttribute("children", children);
            
            // Check if a specific student is selected
            String studentIdParam = request.getParameter("studentId");
            if (studentIdParam != null && !studentIdParam.isEmpty()) {
                int studentId = Integer.parseInt(studentIdParam);
                
                // Verify the student belongs to this parent
                boolean isValidChild = false;
                for (Student child : children) {
                    if (child.getId() == studentId) {
                        isValidChild = true;
                        break;
                    }
                }
                
                if (isValidChild) {
                    // Get student details
                    Student student = studentDAO.getStudentById(studentId);
                    request.setAttribute("selectedStudent", student);
                    
                    // Get academic progress (marks)
                    List<Map<String, Object>> academicProgress = marksDAO.getStudentMarksByCourses(studentId);
                    request.setAttribute("academicProgress", academicProgress);
                    
                    // Get behavior records
                    List<Map<String, Object>> behaviorRecords = behaviorDAO.getBehaviorRecordsByStudentId(studentId);
                    request.setAttribute("behaviorRecords", behaviorRecords);
                    
                    // Get attendance information
                    Map<String, Object> attendanceInfo = studentDAO.getAttendanceByStudent(studentId);
                    request.setAttribute("attendanceInfo", attendanceInfo);
                }
            }
            
            // Forward to the student progress page
            request.getRequestDispatcher("/WEB-INF/views/parent/student_progress.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Log the error and show error page
            getServletContext().log("Error in StudentProgressServlet", e);
            request.setAttribute("errorMessage", "Error retrieving student progress information");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 