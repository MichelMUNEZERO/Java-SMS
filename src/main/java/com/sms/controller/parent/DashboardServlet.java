package com.sms.controller.parent;

import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.dao.AnnouncementDAO;
import com.sms.dao.ParentDAO;
import com.sms.dao.StudentDAO;
import com.sms.model.Announcement;
import com.sms.model.Parent;
import com.sms.model.Student;
import com.sms.model.User;

/**
 * Servlet to handle parent dashboard
 */
@WebServlet("/parent/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private StudentDAO studentDAO;
    private ParentDAO parentDAO;
    private AnnouncementDAO announcementDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        studentDAO = new StudentDAO();
        parentDAO = new ParentDAO();
        announcementDAO = new AnnouncementDAO();
    }
    
    /**
     * Handle GET requests - show parent dashboard
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
            
            // Get children of this parent
            List<Student> children = studentDAO.getStudentsByParent(parent.getId());
            request.setAttribute("children", children);
            
            // Get recent announcements (limit to 3)
            List<Announcement> recentAnnouncements = announcementDAO.getRecentAnnouncements(3);
            request.setAttribute("recentAnnouncements", recentAnnouncements);
            
            // If a child is selected, get their details
            String selectedChildId = request.getParameter("childId");
            if (selectedChildId != null && !selectedChildId.isEmpty()) {
                int childId = Integer.parseInt(selectedChildId);
                // Validate child belongs to parent
                boolean isValidChild = false;
                for (Student child : children) {
                    if (child.getId() == childId) {
                        isValidChild = true;
                        request.setAttribute("selectedChild", child);
                        
                        // Get academic progress summary
                        Map<String, Object> academicSummary = studentDAO.getStudentAcademicSummary(childId);
                        request.setAttribute("academicSummary", academicSummary);
                        
                        // Get attendance summary
                        Map<String, Object> attendanceSummary = studentDAO.getAttendanceByStudent(childId);
                        request.setAttribute("attendanceSummary", attendanceSummary);
                        
                        break;
                    }
                }
            } else if (!children.isEmpty()) {
                // Default to first child if none selected
                Student firstChild = children.get(0);
                request.setAttribute("selectedChild", firstChild);
                
                // Get academic progress summary
                Map<String, Object> academicSummary = studentDAO.getStudentAcademicSummary(firstChild.getId());
                request.setAttribute("academicSummary", academicSummary);
                
                // Get attendance summary
                Map<String, Object> attendanceSummary = studentDAO.getAttendanceByStudent(firstChild.getId());
                request.setAttribute("attendanceSummary", attendanceSummary);
            }
            
            // Store current date and one month later for appointment booking form
            Calendar cal = Calendar.getInstance();
            request.setAttribute("now", cal.getTime());
            cal.add(Calendar.MONTH, 1);
            request.setAttribute("oneMonthLater", cal.getTime());
            
            // Forward to parent dashboard page
            request.getRequestDispatcher("/parent_dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Log the error and show error page
            getServletContext().log("Error in ParentDashboardServlet", e);
            request.setAttribute("errorMessage", "Error retrieving dashboard information");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle POST requests
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Process any form submissions from the dashboard
        doGet(request, response);
    }
} 