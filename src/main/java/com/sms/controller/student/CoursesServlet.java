package com.sms.controller.student;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
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
 * Servlet to handle student course listing and information
 */
@WebServlet("/student/courses")
public class CoursesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(CoursesServlet.class.getName());
    
    /**
     * GET method to display student courses
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
        
        // Get courses for this student
        List<Course> courses = getStudentCourses(studentId);
        request.setAttribute("courses", courses);
        
        // Forward to the courses JSP
        request.getRequestDispatcher("/WEB-INF/views/student/courses.jsp").forward(request, response);
    }
    
    /**
     * Retrieves courses for a given student ID
     */
    private List<Course> getStudentCourses(int studentId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Course> courses = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT c.* FROM Courses c " +
                         "JOIN Student_Courses sc ON c.course_id = sc.course_id " +
                         "WHERE sc.student_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Course course = new Course();
                course.setId(rs.getInt("course_id"));
                course.setCourseCode(rs.getString("course_code"));
                course.setCourseName(rs.getString("course_name"));
                course.setDescription(rs.getString("description"));
                course.setCredits(rs.getInt("credits"));
                course.setTeacherId(rs.getInt("teacher_id"));
                courses.add(course);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving student courses", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return courses;
    }
} 