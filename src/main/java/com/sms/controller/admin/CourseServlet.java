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
 * Servlet for managing courses
 */
@WebServlet(urlPatterns = { 
    "/admin/courses", 
    "/admin/courses/new", 
    "/admin/courses/edit/*", 
    "/admin/courses/delete/*",
    "/admin/courses/view/*"
})
public class CourseServlet extends HttpServlet {
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
        
        if (pathInfo.equals("/admin/courses")) {
            // List all courses
            List<Map<String, Object>> courses = getAllCourses();
            request.setAttribute("courses", courses);
            request.getRequestDispatcher("/admin/courses.jsp").forward(request, response);
        } else if (pathInfo.equals("/admin/courses/new")) {
            // Show form to create a new course
            request.getRequestDispatcher("/admin/course-form.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/admin/courses/edit/")) {
            // Show form to edit an existing course
            String idStr = pathInfo.substring("/admin/courses/edit/".length());
            try {
                int id = Integer.parseInt(idStr);
                Map<String, Object> course = getCourseById(id);
                
                if (course != null) {
                    request.setAttribute("course", course);
                    request.getRequestDispatcher("/admin/course-form.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/courses");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/courses");
            }
        } else if (pathInfo.startsWith("/admin/courses/view/")) {
            // View course details
            String idStr = pathInfo.substring("/admin/courses/view/".length());
            try {
                int id = Integer.parseInt(idStr);
                Map<String, Object> course = getCourseById(id);
                
                if (course != null) {
                    request.setAttribute("course", course);
                    
                    // Get teachers assigned to this course
                    List<Map<String, Object>> teachers = getCourseTeachers(id);
                    request.setAttribute("teachers", teachers);
                    
                    // Get students enrolled in this course
                    List<Map<String, Object>> students = getCourseStudents(id);
                    request.setAttribute("students", students);
                    
                    request.getRequestDispatcher("/admin/course-view.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/courses");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/courses");
            }
        } else if (pathInfo.startsWith("/admin/courses/delete/")) {
            // Delete a course
            String idStr = pathInfo.substring("/admin/courses/delete/".length());
            try {
                int id = Integer.parseInt(idStr);
                deleteCourse(id);
                
                response.sendRedirect(request.getContextPath() + "/admin/courses");
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/courses");
            }
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
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            // Create a new course
            String courseName = request.getParameter("courseName");
            String courseCode = request.getParameter("courseCode");
            String description = request.getParameter("description");
            String credits = request.getParameter("credits");
            
            if (courseName != null && !courseName.trim().isEmpty() && 
                courseCode != null && !courseCode.trim().isEmpty()) {
                
                // Create course
                createCourse(courseName, courseCode, description, credits);
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/courses");
        } else if ("update".equals(action)) {
            // Update an existing course
            String idStr = request.getParameter("id");
            String courseName = request.getParameter("courseName");
            String courseCode = request.getParameter("courseCode");
            String description = request.getParameter("description");
            String credits = request.getParameter("credits");
            
            if (idStr != null && !idStr.trim().isEmpty() && 
                courseName != null && !courseName.trim().isEmpty() && 
                courseCode != null && !courseCode.trim().isEmpty()) {
                
                try {
                    int id = Integer.parseInt(idStr);
                    
                    // Update course
                    updateCourse(id, courseName, courseCode, description, credits);
                } catch (NumberFormatException e) {
                    // Ignore invalid ID
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/courses");
        }
    }
    
    /**
     * Get all courses
     * @return list of course data
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
                    course.put("courseCode", rs.getString("CourseCode"));
                    course.put("description", rs.getString("Description"));
                    course.put("credits", rs.getString("Credits"));
                    
                    // Get teacher count for this course
                    String teacherSql = "SELECT COUNT(*) AS teacherCount FROM Teacher_Courses WHERE CourseId = ?";
                    try (PreparedStatement teacherStmt = conn.prepareStatement(teacherSql)) {
                        teacherStmt.setInt(1, rs.getInt("CourseId"));
                        try (ResultSet teacherRs = teacherStmt.executeQuery()) {
                            if (teacherRs.next()) {
                                course.put("teacherCount", teacherRs.getInt("teacherCount"));
                            } else {
                                course.put("teacherCount", 0);
                            }
                        }
                    }
                    
                    // Get student count for this course
                    String studentSql = "SELECT COUNT(*) AS studentCount FROM Student_Courses WHERE CourseId = ?";
                    try (PreparedStatement studentStmt = conn.prepareStatement(studentSql)) {
                        studentStmt.setInt(1, rs.getInt("CourseId"));
                        try (ResultSet studentRs = studentStmt.executeQuery()) {
                            if (studentRs.next()) {
                                course.put("studentCount", studentRs.getInt("studentCount"));
                            } else {
                                course.put("studentCount", 0);
                            }
                        }
                    }
                    
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
     * Get course by ID
     * @param id the course ID
     * @return map containing course details
     */
    private Map<String, Object> getCourseById(int id) {
        Map<String, Object> course = null;
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Courses WHERE CourseId = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        course = new HashMap<>();
                        course.put("id", rs.getInt("CourseId"));
                        course.put("courseName", rs.getString("CourseName"));
                        course.put("courseCode", rs.getString("CourseCode"));
                        course.put("description", rs.getString("Description"));
                        course.put("credits", rs.getString("Credits"));
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
        
        return course;
    }
    
    /**
     * Get teachers assigned to a course
     * @param courseId the course ID
     * @return list of teacher details
     */
    private List<Map<String, Object>> getCourseTeachers(int courseId) {
        List<Map<String, Object>> teachers = new ArrayList<>();
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT t.* FROM Teachers t " +
                         "JOIN Teacher_Courses tc ON t.TeacherId = tc.TeacherId " +
                         "WHERE tc.CourseId = ? " +
                         "ORDER BY t.LastName, t.FirstName";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, courseId);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> teacher = new HashMap<>();
                        teacher.put("id", rs.getInt("TeacherId"));
                        teacher.put("firstName", rs.getString("FirstName"));
                        teacher.put("lastName", rs.getString("LastName"));
                        teacher.put("email", rs.getString("Email"));
                        teacher.put("qualification", rs.getString("Qualification"));
                        
                        teachers.add(teacher);
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
        
        return teachers;
    }
    
    /**
     * Get students enrolled in a course
     * @param courseId the course ID
     * @return list of student details
     */
    private List<Map<String, Object>> getCourseStudents(int courseId) {
        List<Map<String, Object>> students = new ArrayList<>();
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT s.* FROM Students s " +
                         "JOIN Student_Courses sc ON s.StudentId = sc.StudentId " +
                         "WHERE sc.CourseId = ? " +
                         "ORDER BY s.LastName, s.FirstName";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, courseId);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> student = new HashMap<>();
                        student.put("id", rs.getInt("StudentId"));
                        student.put("firstName", rs.getString("FirstName"));
                        student.put("lastName", rs.getString("LastName"));
                        student.put("email", rs.getString("Email"));
                        student.put("rollNumber", rs.getString("RollNumber"));
                        
                        students.add(student);
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
        
        return students;
    }
    
    /**
     * Create a new course
     * @param courseName the course name
     * @param courseCode the course code
     * @param description the course description
     * @param credits the course credits
     * @return the new course ID, or -1 if creation failed
     */
    private int createCourse(String courseName, String courseCode, String description, String credits) {
        Connection conn = null;
        int courseId = -1;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO Courses (CourseName, CourseCode, Description, Credits) VALUES (?, ?, ?, ?)";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, courseName);
                stmt.setString(2, courseCode);
                stmt.setString(3, description);
                stmt.setString(4, credits);
                
                int rowsAffected = stmt.executeUpdate();
                
                if (rowsAffected > 0) {
                    try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            courseId = generatedKeys.getInt(1);
                        }
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
        
        return courseId;
    }
    
    /**
     * Update an existing course
     * @param id the course ID
     * @param courseName the course name
     * @param courseCode the course code
     * @param description the course description
     * @param credits the course credits
     * @return true if update successful, false otherwise
     */
    private boolean updateCourse(int id, String courseName, String courseCode, String description, String credits) {
        Connection conn = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE Courses SET CourseName = ?, CourseCode = ?, Description = ?, Credits = ? WHERE CourseId = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, courseName);
                stmt.setString(2, courseCode);
                stmt.setString(3, description);
                stmt.setString(4, credits);
                stmt.setInt(5, id);
                
                int rowsAffected = stmt.executeUpdate();
                success = rowsAffected > 0;
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
        
        return success;
    }
    
    /**
     * Delete a course
     * @param id the ID of the course to delete
     * @return true if deletion successful, false otherwise
     */
    private boolean deleteCourse(int id) {
        Connection conn = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            try {
                // First delete teacher assignments
                String sqlTeachers = "DELETE FROM Teacher_Courses WHERE CourseId = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sqlTeachers)) {
                    stmt.setInt(1, id);
                    stmt.executeUpdate();
                }
                
                // Delete student enrollments
                String sqlStudents = "DELETE FROM Student_Courses WHERE CourseId = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sqlStudents)) {
                    stmt.setInt(1, id);
                    stmt.executeUpdate();
                }
                
                // Finally delete the course
                String sqlCourse = "DELETE FROM Courses WHERE CourseId = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sqlCourse)) {
                    stmt.setInt(1, id);
                    int rowsAffected = stmt.executeUpdate();
                    success = rowsAffected > 0;
                }
                
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
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
        
        return success;
    }
} 