package com.sms.controller.parent;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.dao.ParentDAO;
import com.sms.dao.StudentDAO;
import com.sms.model.Parent;
import com.sms.model.Student;
import com.sms.model.User;

/**
 * Servlet implementation class ParentServlet for handling parent dashboard functions
 */
@WebServlet("/parent/*")
public class ParentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private ParentDAO parentDAO;
    private StudentDAO studentDAO;
    
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ParentServlet() {
        super();
        parentDAO = new ParentDAO();
        studentDAO = new StudentDAO();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Default - show dashboard
            loadDashboard(request, response);
        } else if (pathInfo.equals("/children")) {
            // Show children list
            loadChildren(request, response);
        } else if (pathInfo.equals("/grades")) {
            // Show grades
            loadGrades(request, response);
        } else if (pathInfo.equals("/attendance")) {
            // Show attendance
            loadAttendance(request, response);
        } else if (pathInfo.equals("/student-details")) {
            // Show student details
            loadStudentDetails(request, response);
        } else if (pathInfo.equals("/appointments")) {
            // Show appointments
            loadAppointments(request, response);
        } else {
            // Handle 404
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Default action
            response.sendRedirect(request.getContextPath() + "/parent");
        } else if (pathInfo.equals("/appointment")) {
            // Book an appointment
            bookAppointment(request, response);
        } else if (pathInfo.equals("/message")) {
            // Send a message
            sendMessage(request, response);
        } else {
            // Handle 404
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    /**
     * Load the parent dashboard
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    private void loadDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get parent information
        Parent parent = parentDAO.getParentByUserId(currentUser.getUserId());
        if (parent == null) {
            request.setAttribute("errorMessage", "Parent profile not found");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        // Get children information
        List<Student> children = studentDAO.getStudentsByParentId(parent.getParentId());
        request.setAttribute("parent", parent);
        request.setAttribute("children", children);
        
        // Forward to dashboard
        request.getRequestDispatcher("/parent/dashboard.jsp").forward(request, response);
    }
    
    /**
     * Load children list for a parent
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    private void loadChildren(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get parent information
        Parent parent = parentDAO.getParentByUserId(currentUser.getUserId());
        if (parent == null) {
            request.setAttribute("errorMessage", "Parent profile not found");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        // Get children information
        List<Student> children = studentDAO.getStudentsByParentId(parent.getParentId());
        request.setAttribute("parent", parent);
        request.setAttribute("children", children);
        
        // Forward to children list
        request.getRequestDispatcher("/parent/children.jsp").forward(request, response);
    }
    
    /**
     * Load grades for a parent's children
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    private void loadGrades(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get parent information
        Parent parent = parentDAO.getParentByUserId(currentUser.getUserId());
        if (parent == null) {
            request.setAttribute("errorMessage", "Parent profile not found");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        // Get children information
        List<Student> children = studentDAO.getStudentsByParentId(parent.getParentId());
        request.setAttribute("parent", parent);
        request.setAttribute("children", children);
        
        // TODO: Get grades for each child
        
        // Forward to grades page
        request.getRequestDispatcher("/parent/grades.jsp").forward(request, response);
    }
    
    /**
     * Load attendance for a parent's children
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    private void loadAttendance(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get parent information
        Parent parent = parentDAO.getParentByUserId(currentUser.getUserId());
        if (parent == null) {
            request.setAttribute("errorMessage", "Parent profile not found");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        // Get children information
        List<Student> children = studentDAO.getStudentsByParentId(parent.getParentId());
        request.setAttribute("parent", parent);
        request.setAttribute("children", children);
        
        // TODO: Get attendance for each child
        
        // Forward to attendance page
        request.getRequestDispatcher("/parent/attendance.jsp").forward(request, response);
    }
    
    /**
     * Load details for a specific student
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    private void loadStudentDetails(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get parent information
        Parent parent = parentDAO.getParentByUserId(currentUser.getUserId());
        if (parent == null) {
            request.setAttribute("errorMessage", "Parent profile not found");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        // Get student ID from request
        String studentIdStr = request.getParameter("id");
        if (studentIdStr == null || studentIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/parent/children");
            return;
        }
        
        try {
            int studentId = Integer.parseInt(studentIdStr);
            
            // Get student information
            Student student = studentDAO.getStudentById(studentId);
            if (student == null) {
                request.setAttribute("errorMessage", "Student not found");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // Verify that the student belongs to this parent
            if (student.getParentId() != parent.getParentId()) {
                request.setAttribute("errorMessage", "Unauthorized access to student information");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("student", student);
            
            // Forward to student details page
            request.getRequestDispatcher("/parent/student-details.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/parent/children");
        }
    }
    
    /**
     * Load appointments for a parent
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    private void loadAppointments(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get parent information
        Parent parent = parentDAO.getParentByUserId(currentUser.getUserId());
        if (parent == null) {
            request.setAttribute("errorMessage", "Parent profile not found");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        // TODO: Get appointments for the parent
        
        // Forward to appointments page
        request.getRequestDispatcher("/parent/appointments.jsp").forward(request, response);
    }
    
    /**
     * Book an appointment
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    private void bookAppointment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get parent information
        Parent parent = parentDAO.getParentByUserId(currentUser.getUserId());
        if (parent == null) {
            request.setAttribute("errorMessage", "Parent profile not found");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        // Get appointment details from form
        String teacherId = request.getParameter("teacherId");
        String appointmentDate = request.getParameter("appointmentDate");
        String appointmentTime = request.getParameter("appointmentTime");
        String purpose = request.getParameter("purpose");
        
        // TODO: Validate and save appointment
        
        // Redirect to appointments page
        response.sendRedirect(request.getContextPath() + "/parent/appointments");
    }
    
    /**
     * Send a message
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    private void sendMessage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get parent information
        Parent parent = parentDAO.getParentByUserId(currentUser.getUserId());
        if (parent == null) {
            request.setAttribute("errorMessage", "Parent profile not found");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        // Get message details from form
        String recipientId = request.getParameter("recipientId");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");
        
        // TODO: Validate and save message
        
        // Redirect to messages page
        response.sendRedirect(request.getContextPath() + "/parent/messages");
    }
} 