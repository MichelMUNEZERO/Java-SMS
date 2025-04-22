package com.sms.controller.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.model.User;
import com.sms.util.DBConnection;

/**
 * Servlet for managing teachers - Admin can only view teachers (not add/edit them)
 */
@WebServlet(urlPatterns = { 
    "/admin/teachers", 
    "/admin/teachers/view/*"
})
public class TeacherServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in and is an admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String pathInfo = request.getServletPath();
        
        if (pathInfo.equals("/admin/teachers")) {
            // List all teachers
            List<Map<String, Object>> teachers = getAllTeachers();
            request.setAttribute("teachers", teachers);
            request.getRequestDispatcher("/admin/teachers.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/admin/teachers/view/")) {
            // View teacher details
            String idStr = pathInfo.substring("/admin/teachers/view/".length());
            try {
                int id = Integer.parseInt(idStr);
                Map<String, Object> teacher = getTeacherById(id);
                
                if (teacher != null) {
                    request.setAttribute("teacher", teacher);
                    
                    // Get teacher's courses
                    List<Map<String, Object>> teacherCourses = getTeacherCourses(id);
                    request.setAttribute("teacherCourses", teacherCourses);
                    
                    // Get teacher statistics (optional)
                    Map<String, Object> teacherStats = getTeacherStats(id);
                    request.setAttribute("teacherStats", teacherStats);
                    
                    request.getRequestDispatcher("/admin/teacher-view.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/teachers");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/teachers");
            }
        } else {
            // Redirect to teachers list for any invalid URL
            response.sendRedirect(request.getContextPath() + "/admin/teachers");
        }
    }
    
    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in and is an admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // No POST operations allowed for teachers as per new requirements
        response.sendRedirect(request.getContextPath() + "/admin/teachers?message=Operation+not+permitted.+Admins+cannot+modify+teachers.");
    }
    
    /**
     * Get all teachers
     * @return list of teacher data
     */
    private List<Map<String, Object>> getAllTeachers() {
        List<Map<String, Object>> teachers = new ArrayList<>();
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Teachers ORDER BY LastName, FirstName";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                
                while (rs.next()) {
                    Map<String, Object> teacher = new HashMap<>();
                    teacher.put("id", rs.getInt("TeacherId"));
                    teacher.put("firstName", rs.getString("FirstName"));
                    teacher.put("lastName", rs.getString("LastName"));
                    teacher.put("email", rs.getString("Email"));
                    teacher.put("telephone", rs.getString("Telephone"));
                    teacher.put("qualification", rs.getString("Qualification"));
                    teacher.put("experience", rs.getInt("Experience"));
                    
                    teachers.add(teacher);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        
        return teachers;
    }
    
    /**
     * Get teacher by ID
     * @param id teacher ID
     * @return teacher data
     */
    private Map<String, Object> getTeacherById(int id) {
        Map<String, Object> teacher = null;
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Teachers WHERE TeacherId = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        teacher = new HashMap<>();
                        teacher.put("id", rs.getInt("TeacherId"));
                        teacher.put("firstName", rs.getString("FirstName"));
                        teacher.put("lastName", rs.getString("LastName"));
                        teacher.put("email", rs.getString("Email"));
                        teacher.put("telephone", rs.getString("Telephone"));
                        teacher.put("qualification", rs.getString("Qualification"));
                        teacher.put("experience", rs.getInt("Experience"));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        
        return teacher;
    }
    
    /**
     * Get courses assigned to a teacher
     * @param teacherId teacher ID
     * @return list of courses
     */
    private List<Map<String, Object>> getTeacherCourses(int teacherId) {
        List<Map<String, Object>> courses = new ArrayList<>();
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT c.* FROM Courses c WHERE c.TeacherId = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, teacherId);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> course = new HashMap<>();
                        course.put("id", rs.getInt("CourseId"));
                        course.put("courseName", rs.getString("CourseName"));
                        course.put("description", rs.getString("Description"));
                        
                        courses.add(course);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        
        return courses;
    }
    
    /**
     * Get all courses
     * @return list of all courses
     */
    private List<Map<String, Object>> getAllCourses() {
        List<Map<String, Object>> courses = new ArrayList<>();
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Courses ORDER BY CourseName";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                
                while (rs.next()) {
                    Map<String, Object> course = new HashMap<>();
                    course.put("id", rs.getInt("CourseId"));
                    course.put("courseName", rs.getString("CourseName"));
                    course.put("description", rs.getString("Description"));
                    course.put("teacherId", rs.getInt("TeacherId"));
                    
                    courses.add(course);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        
        return courses;
    }
    
    /**
     * Get teacher statistics
     * @param teacherId teacher ID
     * @return teacher statistics
     */
    private Map<String, Object> getTeacherStats(int teacherId) {
        Map<String, Object> stats = new HashMap<>();
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Count students enrolled in teacher's courses
            String sql = "SELECT COUNT(DISTINCT sc.student_id) AS total_students " +
                         "FROM student_courses sc " +
                         "JOIN Courses c ON sc.course_id = c.CourseId " +
                         "WHERE c.TeacherId = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, teacherId);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        stats.put("totalStudents", rs.getInt("total_students"));
                    }
                }
            }
            
            // Get average student performance in teacher's courses
            sql = "SELECT AVG(m.Marks) AS avg_performance " +
                  "FROM Marks m " +
                  "JOIN Courses c ON m.CourseId = c.CourseId " +
                  "WHERE c.TeacherId = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, teacherId);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        double avgPerformance = rs.getDouble("avg_performance");
                        if (!rs.wasNull()) {
                            stats.put("avgPerformance", String.format("%.1f%%", avgPerformance));
                        }
                    }
                }
            }
            
            // For simplicity, we'll use a placeholder for classes per week
            stats.put("classesPerWeek", "N/A");
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        
        return stats;
    }
} 