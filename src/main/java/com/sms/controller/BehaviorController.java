package com.sms.controller;

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
import com.sms.model.User;

/**
 * Controller for managing student behavior records
 */
@WebServlet("/behavior/*")
public class BehaviorController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BehaviorDAO behaviorDAO;
    
    public BehaviorController() {
        behaviorDAO = new BehaviorDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check if user is logged in
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Only teachers and admins can access behavior management
        String role = currentUser.getRole();
        if (!role.equals("TEACHER") && !role.equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Main behavior management page - show list of students for the teacher
            int teacherId = currentUser.getUserId();
            List<Map<String, Object>> students = behaviorDAO.getStudentsByTeacherId(teacherId);
            
            request.setAttribute("students", students);
            request.getRequestDispatcher("/WEB-INF/views/behavior/list.jsp").forward(request, response);
        } else if (pathInfo.equals("/view")) {
            // View behavior records for a specific student
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            List<Map<String, Object>> records = behaviorDAO.getBehaviorRecordsByStudentId(studentId);
            
            request.setAttribute("behaviorRecords", records);
            request.setAttribute("studentId", studentId);
            
            // Get student name from the first record (if available)
            if (!records.isEmpty()) {
                request.setAttribute("studentName", records.get(0).get("studentName"));
            }
            
            request.getRequestDispatcher("/WEB-INF/views/behavior/view.jsp").forward(request, response);
        } else if (pathInfo.equals("/add")) {
            // Show form to add a new behavior record
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            
            // Get behavior types for dropdown
            List<String> behaviorTypes = behaviorDAO.getAllBehaviorTypes();
            
            request.setAttribute("studentId", studentId);
            request.setAttribute("behaviorTypes", behaviorTypes);
            request.getRequestDispatcher("/WEB-INF/views/behavior/add.jsp").forward(request, response);
        } else if (pathInfo.equals("/edit")) {
            // Show form to edit an existing behavior record
            int behaviorId = Integer.parseInt(request.getParameter("behaviorId"));
            
            // In a real application, we would get the behavior record by ID
            // For now, we'll just redirect to the view page
            response.sendRedirect(request.getContextPath() + "/behavior/view?studentId=" 
                    + request.getParameter("studentId"));
        } else {
            // Invalid path
            response.sendRedirect(request.getContextPath() + "/behavior");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check if user is logged in
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Only teachers and admins can manage behavior records
        String role = currentUser.getRole();
        if (!role.equals("TEACHER") && !role.equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        if (pathInfo.equals("/add")) {
            // Process adding a new behavior record
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            int reportedBy = currentUser.getUserId();
            String behaviorType = request.getParameter("behaviorType");
            String description = request.getParameter("description");
            String actionTaken = request.getParameter("actionTaken");
            
            boolean success = behaviorDAO.addBehaviorRecord(studentId, reportedBy, behaviorType, 
                                                          description, actionTaken);
            
            if (success) {
                session.setAttribute("message", "Behavior record added successfully.");
            } else {
                session.setAttribute("error", "Failed to add behavior record.");
            }
            
            response.sendRedirect(request.getContextPath() + "/behavior/view?studentId=" + studentId);
        } else if (pathInfo.equals("/update")) {
            // Process updating an existing behavior record
            int behaviorId = Integer.parseInt(request.getParameter("behaviorId"));
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            String behaviorType = request.getParameter("behaviorType");
            String description = request.getParameter("description");
            String actionTaken = request.getParameter("actionTaken");
            
            boolean success = behaviorDAO.updateBehaviorRecord(behaviorId, behaviorType, 
                                                             description, actionTaken);
            
            if (success) {
                session.setAttribute("message", "Behavior record updated successfully.");
            } else {
                session.setAttribute("error", "Failed to update behavior record.");
            }
            
            response.sendRedirect(request.getContextPath() + "/behavior/view?studentId=" + studentId);
        } else if (pathInfo.equals("/delete")) {
            // Process deleting a behavior record
            int behaviorId = Integer.parseInt(request.getParameter("behaviorId"));
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            
            boolean success = behaviorDAO.deleteBehaviorRecord(behaviorId);
            
            if (success) {
                session.setAttribute("message", "Behavior record deleted successfully.");
            } else {
                session.setAttribute("error", "Failed to delete behavior record.");
            }
            
            response.sendRedirect(request.getContextPath() + "/behavior/view?studentId=" + studentId);
        } else {
            // Invalid path
            response.sendRedirect(request.getContextPath() + "/behavior");
        }
    }
} 