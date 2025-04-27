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
import java.util.TreeMap;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.model.Student;
import com.sms.model.User;
import com.sms.util.DBConnection;

/**
 * Servlet to handle student schedule display
 */
@WebServlet("/student/schedule")
public class ScheduleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ScheduleServlet.class.getName());
    
    // Days of the week array for organizing schedule
    private static final String[] DAYS_OF_WEEK = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday"};
    
    /**
     * GET method to display student schedule
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
        
        // Get weekly schedule for this student
        Map<String, List<Map<String, Object>>> weeklySchedule = getStudentSchedule(studentId);
        request.setAttribute("schedule", weeklySchedule);
        request.setAttribute("daysOfWeek", DAYS_OF_WEEK);
        
        // Forward to the schedule JSP
        request.getRequestDispatcher("/WEB-INF/views/student/schedule.jsp").forward(request, response);
    }
    
    /**
     * Retrieves weekly schedule for a given student ID
     */
    private Map<String, List<Map<String, Object>>> getStudentSchedule(int studentId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        // Use TreeMap to maintain the order of days
        Map<String, List<Map<String, Object>>> weeklySchedule = new HashMap<>();
        
        // Initialize the map with empty lists for each day
        for (String day : DAYS_OF_WEEK) {
            weeklySchedule.put(day, new ArrayList<>());
        }
        
        try {
            conn = DBConnection.getConnection();
            
            // Query to get the student's schedule
            String sql = "SELECT c.course_id, c.course_code, c.course_name, c.credits, " +
                         "s.day_of_week, s.start_time, s.end_time, s.room_number, " +
                         "t.first_name AS teacher_first_name, t.last_name AS teacher_last_name " +
                         "FROM Schedule s " +
                         "JOIN Courses c ON s.course_id = c.course_id " +
                         "JOIN Student_Courses sc ON c.course_id = sc.course_id " +
                         "JOIN Teachers t ON c.teacher_id = t.teacher_id " +
                         "WHERE sc.student_id = ? " +
                         "ORDER BY s.day_of_week, s.start_time";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                String dayOfWeek = rs.getString("day_of_week");
                
                // Skip if the day is not in our days of week array
                if (!weeklySchedule.containsKey(dayOfWeek)) {
                    continue;
                }
                
                Map<String, Object> classInfo = new HashMap<>();
                classInfo.put("courseId", rs.getInt("course_id"));
                classInfo.put("courseCode", rs.getString("course_code"));
                classInfo.put("courseName", rs.getString("course_name"));
                classInfo.put("credits", rs.getInt("credits"));
                classInfo.put("startTime", rs.getTime("start_time"));
                classInfo.put("endTime", rs.getTime("end_time"));
                classInfo.put("roomNumber", rs.getString("room_number"));
                classInfo.put("teacherName", rs.getString("teacher_first_name") + " " + rs.getString("teacher_last_name"));
                
                // Add class to the appropriate day
                weeklySchedule.get(dayOfWeek).add(classInfo);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving student schedule", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return weeklySchedule;
    }
} 