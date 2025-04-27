package com.sms.controller.student;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.model.Course;
import com.sms.model.Student;
import com.sms.model.User;
import com.sms.util.DBConnection;

/**
 * Servlet to handle student grades display
 */
@WebServlet("/student/grades")
public class GradesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(GradesServlet.class.getName());
    
    /**
     * GET method to display student grades
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in and has student role
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"student".equals(user.getRole().toLowerCase())) {
            response.sendRedirect(request.getContextPath() + "/" + user.getRole().toLowerCase() + "/dashboard");
            return;
        }
        
        // Get student ID from session
        Student student = (Student) session.getAttribute("student");
        int studentId = student != null ? student.getId() : 0;
        
        if (studentId == 0) {
            // For development/testing, could use a default ID
            studentId = 1;
        }
        
        // Get courses and grades for this student
        List<Map<String, Object>> gradesList = getStudentGrades(studentId);
        request.setAttribute("gradesList", gradesList);
        
        // Calculate GPA
        double gpa = calculateGPA(gradesList);
        request.setAttribute("gpa", gpa);
        
        // Forward to the grades JSP
        request.getRequestDispatcher("/WEB-INF/views/student/grades.jsp").forward(request, response);
    }
    
    /**
     * Retrieves grades for a given student ID
     */
    private List<Map<String, Object>> getStudentGrades(int studentId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Map<String, Object>> gradesList = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT c.course_code, c.course_name, c.credits, m.assignment_name, " +
                         "m.marks_obtained, m.total_marks, m.grade, m.feedback " +
                         "FROM Marks m " +
                         "JOIN Courses c ON m.course_id = c.course_id " +
                         "WHERE m.student_id = ? " +
                         "ORDER BY c.course_name, m.assignment_name";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> gradeInfo = new HashMap<>();
                gradeInfo.put("courseCode", rs.getString("course_code"));
                gradeInfo.put("courseName", rs.getString("course_name"));
                gradeInfo.put("credits", rs.getInt("credits"));
                gradeInfo.put("assignmentName", rs.getString("assignment_name"));
                gradeInfo.put("marksObtained", rs.getDouble("marks_obtained"));
                gradeInfo.put("totalMarks", rs.getDouble("total_marks"));
                gradeInfo.put("grade", rs.getString("grade"));
                gradeInfo.put("feedback", rs.getString("feedback"));
                
                // Calculate percentage
                double percentage = (rs.getDouble("marks_obtained") / rs.getDouble("total_marks")) * 100;
                gradeInfo.put("percentage", Math.round(percentage * 10.0) / 10.0); // Round to 1 decimal place
                
                gradesList.add(gradeInfo);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving student grades", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return gradesList;
    }
    
    /**
     * Calculate GPA from grades
     */
    private double calculateGPA(List<Map<String, Object>> gradesList) {
        if (gradesList.isEmpty()) {
            return 0.0;
        }
        
        // This is a simplified GPA calculation
        // In a real application, you would use a more complex algorithm based on your grading system
        double totalPoints = 0.0;
        int totalCredits = 0;
        
        Map<String, Double> courseGrades = new HashMap<>();
        Map<String, Integer> courseCredits = new HashMap<>();
        
        // Aggregate grades by course
        for (Map<String, Object> grade : gradesList) {
            String courseCode = (String) grade.get("courseCode");
            double percentage = (double) grade.get("percentage");
            int credits = (int) grade.get("credits");
            
            if (courseGrades.containsKey(courseCode)) {
                // Average with existing grade
                double existingPercentage = courseGrades.get(courseCode);
                courseGrades.put(courseCode, (existingPercentage + percentage) / 2);
            } else {
                courseGrades.put(courseCode, percentage);
                courseCredits.put(courseCode, credits);
            }
        }
        
        // Calculate GPA
        for (String courseCode : courseGrades.keySet()) {
            double percentage = courseGrades.get(courseCode);
            int credits = courseCredits.get(courseCode);
            
            // Convert percentage to GPA points (simplified 4.0 scale)
            double gpaPoints = 0.0;
            if (percentage >= 90) gpaPoints = 4.0;
            else if (percentage >= 80) gpaPoints = 3.0;
            else if (percentage >= 70) gpaPoints = 2.0;
            else if (percentage >= 60) gpaPoints = 1.0;
            
            totalPoints += gpaPoints * credits;
            totalCredits += credits;
        }
        
        return totalCredits > 0 ? Math.round((totalPoints / totalCredits) * 100.0) / 100.0 : 0.0;
    }
} 