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
 * Servlet for managing students
 */
@WebServlet(urlPatterns = { 
    "/admin/students", 
    "/admin/students/new", 
    "/admin/students/edit/*", 
    "/admin/students/delete/*",
    "/admin/students/view/*"
})
public class StudentServlet extends HttpServlet {
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
        
        if (pathInfo.equals("/admin/students")) {
            // List all students
            List<Map<String, Object>> students = getAllStudents();
            request.setAttribute("students", students);
            request.getRequestDispatcher("/admin/students.jsp").forward(request, response);
        } else if (pathInfo.equals("/admin/students/new")) {
            // Show form to create a new student
            // Get available courses for enrollment
            List<Map<String, Object>> courses = getAllCourses();
            request.setAttribute("courses", courses);
            request.getRequestDispatcher("/admin/student-form.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/admin/students/edit/")) {
            // Show form to edit an existing student
            String idStr = pathInfo.substring("/admin/students/edit/".length());
            try {
                int id = Integer.parseInt(idStr);
                Map<String, Object> student = getStudentById(id);
                
                if (student != null) {
                    request.setAttribute("student", student);
                    
                    // Get student's courses
                    List<Map<String, Object>> studentCourses = getStudentCourses(id);
                    request.setAttribute("studentCourses", studentCourses);
                    
                    // Get all courses for enrollment
                    List<Map<String, Object>> courses = getAllCourses();
                    request.setAttribute("courses", courses);
                    
                    request.getRequestDispatcher("/admin/student-form.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/students");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/students");
            }
        } else if (pathInfo.startsWith("/admin/students/view/")) {
            // View student details
            String idStr = pathInfo.substring("/admin/students/view/".length());
            try {
                int id = Integer.parseInt(idStr);
                Map<String, Object> student = getStudentById(id);
                
                if (student != null) {
                    request.setAttribute("student", student);
                    
                    // Get student's courses
                    List<Map<String, Object>> studentCourses = getStudentCourses(id);
                    request.setAttribute("studentCourses", studentCourses);
                    
                    request.getRequestDispatcher("/admin/student-view.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/students");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/students");
            }
        } else if (pathInfo.startsWith("/admin/students/delete/")) {
            // Delete a student
            String idStr = pathInfo.substring("/admin/students/delete/".length());
            try {
                int id = Integer.parseInt(idStr);
                deleteStudent(id);
                
                response.sendRedirect(request.getContextPath() + "/admin/students");
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/students");
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
            // Create a new student
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String rollNumber = request.getParameter("rollNumber");
            String password = request.getParameter("password");
            
            if (firstName != null && !firstName.trim().isEmpty() && 
                lastName != null && !lastName.trim().isEmpty() && 
                email != null && !email.trim().isEmpty() &&
                rollNumber != null && !rollNumber.trim().isEmpty()) {
                
                // Create student
                int studentId = createStudent(firstName, lastName, email, phone, address, rollNumber);
                
                if (studentId > 0) {
                    // Create user account for student
                    createUserAccount(email, password, "student", studentId);
                    
                    // Handle course enrollments
                    String[] courseIds = request.getParameterValues("courses");
                    if (courseIds != null) {
                        for (String courseId : courseIds) {
                            try {
                                int cId = Integer.parseInt(courseId);
                                enrollStudentInCourse(studentId, cId);
                            } catch (NumberFormatException e) {
                                // Skip invalid course ID
                            }
                        }
                    }
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/students");
        } else if ("update".equals(action)) {
            // Update an existing student
            String idStr = request.getParameter("id");
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String rollNumber = request.getParameter("rollNumber");
            
            if (idStr != null && !idStr.trim().isEmpty() && 
                firstName != null && !firstName.trim().isEmpty() && 
                lastName != null && !lastName.trim().isEmpty() && 
                email != null && !email.trim().isEmpty()) {
                
                try {
                    int id = Integer.parseInt(idStr);
                    
                    // Update student
                    updateStudent(id, firstName, lastName, email, phone, address, rollNumber);
                    
                    // Update user account email
                    updateUserEmail(id, email);
                    
                    // Handle course enrollments
                    // First, remove all existing enrollments
                    removeStudentCourses(id);
                    
                    // Then add new enrollments
                    String[] courseIds = request.getParameterValues("courses");
                    if (courseIds != null) {
                        for (String courseId : courseIds) {
                            try {
                                int cId = Integer.parseInt(courseId);
                                enrollStudentInCourse(id, cId);
                            } catch (NumberFormatException e) {
                                // Skip invalid course ID
                            }
                        }
                    }
                } catch (NumberFormatException e) {
                    // Ignore invalid ID
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/students");
        }
    }
    
    /**
     * Get all students
     * @return list of student data
     */
    private List<Map<String, Object>> getAllStudents() {
        List<Map<String, Object>> students = new ArrayList<>();
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Students ORDER BY LastName, FirstName";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                
                while (rs.next()) {
                    Map<String, Object> student = new HashMap<>();
                    student.put("id", rs.getInt("StudentId"));
                    student.put("firstName", rs.getString("FirstName"));
                    student.put("lastName", rs.getString("LastName"));
                    student.put("email", rs.getString("Email"));
                    student.put("phone", rs.getString("Phone"));
                    student.put("rollNumber", rs.getString("RollNumber"));
                    
                    // Get course count for each student
                    String courseSql = "SELECT COUNT(*) AS courseCount FROM Student_Courses WHERE StudentId = ?";
                    try (PreparedStatement courseStmt = conn.prepareStatement(courseSql)) {
                        courseStmt.setInt(1, rs.getInt("StudentId"));
                        try (ResultSet courseRs = courseStmt.executeQuery()) {
                            if (courseRs.next()) {
                                student.put("courseCount", courseRs.getInt("courseCount"));
                            } else {
                                student.put("courseCount", 0);
                            }
                        }
                    }
                    
                    students.add(student);
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
     * Get student by ID
     * @param id the student ID
     * @return map containing student details
     */
    private Map<String, Object> getStudentById(int id) {
        Map<String, Object> student = null;
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Students WHERE StudentId = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        student = new HashMap<>();
                        student.put("id", rs.getInt("StudentId"));
                        student.put("firstName", rs.getString("FirstName"));
                        student.put("lastName", rs.getString("LastName"));
                        student.put("email", rs.getString("Email"));
                        student.put("phone", rs.getString("Phone"));
                        student.put("address", rs.getString("Address"));
                        student.put("rollNumber", rs.getString("RollNumber"));
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
        
        return student;
    }
    
    /**
     * Get courses enrolled by a student
     * @param studentId the student ID
     * @return list of course details
     */
    private List<Map<String, Object>> getStudentCourses(int studentId) {
        List<Map<String, Object>> courses = new ArrayList<>();
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT c.* FROM Courses c " +
                         "JOIN Student_Courses sc ON c.CourseId = sc.CourseId " +
                         "WHERE sc.StudentId = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, studentId);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> course = new HashMap<>();
                        course.put("id", rs.getInt("CourseId"));
                        course.put("name", rs.getString("CourseName"));
                        course.put("code", rs.getString("CourseCode"));
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
     * Get all available courses
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
                    course.put("name", rs.getString("CourseName"));
                    course.put("code", rs.getString("CourseCode"));
                    course.put("description", rs.getString("Description"));
                    
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
     * Create a new student
     * @param firstName the student's first name
     * @param lastName the student's last name
     * @param email the student's email
     * @param phone the student's phone number
     * @param address the student's address
     * @param rollNumber the student's roll number
     * @return the new student ID, or -1 if creation failed
     */
    private int createStudent(String firstName, String lastName, String email, String phone, String address, String rollNumber) {
        Connection conn = null;
        int studentId = -1;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO Students (FirstName, LastName, Email, Phone, Address, RollNumber) " +
                         "VALUES (?, ?, ?, ?, ?, ?)";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, firstName);
                stmt.setString(2, lastName);
                stmt.setString(3, email);
                stmt.setString(4, phone);
                stmt.setString(5, address);
                stmt.setString(6, rollNumber);
                
                int rowsAffected = stmt.executeUpdate();
                
                if (rowsAffected > 0) {
                    try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            studentId = generatedKeys.getInt(1);
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
        
        return studentId;
    }
    
    /**
     * Update an existing student
     * @param id the student ID
     * @param firstName the student's first name
     * @param lastName the student's last name
     * @param email the student's email
     * @param phone the student's phone number
     * @param address the student's address
     * @param rollNumber the student's roll number
     * @return true if update successful, false otherwise
     */
    private boolean updateStudent(int id, String firstName, String lastName, String email, String phone, String address, String rollNumber) {
        Connection conn = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE Students SET FirstName = ?, LastName = ?, Email = ?, " +
                         "Phone = ?, Address = ?, RollNumber = ? WHERE StudentId = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, firstName);
                stmt.setString(2, lastName);
                stmt.setString(3, email);
                stmt.setString(4, phone);
                stmt.setString(5, address);
                stmt.setString(6, rollNumber);
                stmt.setInt(7, id);
                
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
     * Delete a student
     * @param id the ID of the student to delete
     * @return true if deletion successful, false otherwise
     */
    private boolean deleteStudent(int id) {
        Connection conn = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            try {
                // First delete student's course enrollments
                String sqlCourses = "DELETE FROM Student_Courses WHERE StudentId = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sqlCourses)) {
                    stmt.setInt(1, id);
                    stmt.executeUpdate();
                }
                
                // Delete associated user account
                String sqlUser = "DELETE FROM users WHERE userType = 'student' AND associatedId = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sqlUser)) {
                    stmt.setInt(1, id);
                    stmt.executeUpdate();
                }
                
                // Finally delete the student
                String sqlStudent = "DELETE FROM Students WHERE StudentId = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sqlStudent)) {
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
    
    /**
     * Create a user account for a student
     * @param username the username (email)
     * @param password the password
     * @param userType the user type (student)
     * @param associatedId the student ID
     * @return true if creation successful, false otherwise
     */
    private boolean createUserAccount(String username, String password, String userType, int associatedId) {
        Connection conn = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO users (username, password, role, userType, associatedId) VALUES (?, ?, ?, ?, ?)";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                stmt.setString(2, password); // In a real app, password should be hashed
                stmt.setString(3, userType);
                stmt.setString(4, userType);
                stmt.setInt(5, associatedId);
                
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
     * Update user account email for a student
     * @param studentId the student ID
     * @param email the new email
     * @return true if update successful, false otherwise
     */
    private boolean updateUserEmail(int studentId, String email) {
        Connection conn = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE users SET username = ? WHERE userType = 'student' AND associatedId = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, email);
                stmt.setInt(2, studentId);
                
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
     * Enroll a student in a course
     * @param studentId the student ID
     * @param courseId the course ID
     * @return true if enrollment successful, false otherwise
     */
    private boolean enrollStudentInCourse(int studentId, int courseId) {
        Connection conn = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO Student_Courses (StudentId, CourseId) VALUES (?, ?)";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, studentId);
                stmt.setInt(2, courseId);
                
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
     * Remove all course enrollments for a student
     * @param studentId the student ID
     * @return true if removal successful, false otherwise
     */
    private boolean removeStudentCourses(int studentId) {
        Connection conn = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM Student_Courses WHERE StudentId = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, studentId);
                
                stmt.executeUpdate();
                success = true; // Consider successful even if no rows were deleted
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