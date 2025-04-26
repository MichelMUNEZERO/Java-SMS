package com.sms.controller.teacher;

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

import com.sms.dao.CourseDAO;
import com.sms.dao.StudentDAO;
import com.sms.dao.TeacherDAO;
import com.sms.dao.impl.CourseDAOImpl;
import com.sms.model.Course;
import com.sms.model.Parent;
import com.sms.model.Student;
import com.sms.model.User;
import com.sms.util.DBConnection;

/**
 * Servlet that handles teacher student management functionality
 */
@WebServlet(urlPatterns = {
    "/teacher/student",
    "/teacher/student/new",
    "/teacher/student/add",
    "/teacher/student/view",
    "/teacher/student/enroll"
})
public class TeacherStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(TeacherStudentServlet.class.getName());
    
    private StudentDAO studentDAO;
    private CourseDAO courseDAO;
    private TeacherDAO teacherDAO;
    
    @Override
    public void init() throws ServletException {
        studentDAO = new StudentDAO();
        courseDAO = new CourseDAOImpl();
        teacherDAO = new TeacherDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"teacher".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String path = request.getServletPath();
        String action = request.getParameter("action");
        
        try {
            if (path.equals("/teacher/student")) {
                listStudents(request, response, user.getUserId());
            } else if (path.equals("/teacher/student/new")) {
                showNewStudentForm(request, response);
            } else if (path.equals("/teacher/student/view")) {
                viewStudent(request, response, user.getUserId());
            } else if (path.equals("/teacher/student/enroll")) {
                showEnrollStudentForm(request, response, user.getUserId());
            } else {
                listStudents(request, response, user.getUserId());
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing request", e);
            request.setAttribute("errorMessage", "Error processing request: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"teacher".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String path = request.getServletPath();
        
        try {
            if (path.equals("/teacher/student/add")) {
                addStudent(request, response);
            } else if (path.equals("/teacher/student/enroll")) {
                enrollStudent(request, response, user.getUserId());
            } else {
                response.sendRedirect(request.getContextPath() + "/teacher/student");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing request", e);
            request.setAttribute("errorMessage", "Error processing request: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    private void listStudents(HttpServletRequest request, HttpServletResponse response, int teacherId) throws ServletException, IOException {
        List<Student> students = studentDAO.getStudentsByTeacherId(teacherId);
        request.setAttribute("students", students);
        request.getRequestDispatcher("/WEB-INF/views/teacher/student-list.jsp").forward(request, response);
    }
    
    private void showNewStudentForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get all courses taught by this teacher to populate the dropdown
            List<Course> courses = courseDAO.getCoursesByTeacherId(((User)request.getSession().getAttribute("user")).getUserId());
            request.setAttribute("courses", courses);
            
            // Get all parents for the existing parent dropdown
            List<Parent> parents = teacherDAO.getAllParents();
            request.setAttribute("parents", parents);
            
            request.getRequestDispatcher("/WEB-INF/views/teacher/student-form.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error preparing student form", e);
            request.setAttribute("errorMessage", "Error loading student form: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    private void addStudent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get basic student information
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String regNumber = request.getParameter("regNumber");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String dateOfBirth = request.getParameter("dateOfBirth");
        String admissionDate = request.getParameter("admissionDate");
        String grade = request.getParameter("grade");
        String courseId = request.getParameter("courseId");
        
        // Parent information
        String createNewParent = request.getParameter("createNewParent");
        String parentId = request.getParameter("parentId");
        String parentFirstName = request.getParameter("parentFirstName");
        String parentLastName = request.getParameter("parentLastName");
        String parentEmail = request.getParameter("parentEmail");
        String parentPhone = request.getParameter("parentPhone");
        String parentAddress = request.getParameter("parentAddress");
        String parentOccupation = request.getParameter("parentOccupation");
        
        // User account information
        String createUserAccount = request.getParameter("createUserAccount");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Validate required inputs
        if (firstName == null || firstName.trim().isEmpty() || 
            lastName == null || lastName.trim().isEmpty() || 
            regNumber == null || regNumber.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Required fields cannot be empty");
            showNewStudentForm(request, response);
            return;
        }
        
        try {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            int generatedParentId = 0;
            int generatedUserId = 0;
            int generatedStudentId = 0;
            
            try {
                conn = DBConnection.getConnection();
                conn.setAutoCommit(false);  // Start transaction
                
                // Step 1: Create parent if selected
                if ("true".equals(createNewParent) && parentFirstName != null && !parentFirstName.trim().isEmpty() && 
                    parentLastName != null && !parentLastName.trim().isEmpty()) {
                    
                    String parentSql = "INSERT INTO parents (first_name, last_name, email, phone, address, occupation) VALUES (?, ?, ?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(parentSql, PreparedStatement.RETURN_GENERATED_KEYS);
                    pstmt.setString(1, parentFirstName);
                    pstmt.setString(2, parentLastName);
                    pstmt.setString(3, parentEmail);
                    pstmt.setString(4, parentPhone);
                    pstmt.setString(5, parentAddress);
                    pstmt.setString(6, parentOccupation);
                    
                    pstmt.executeUpdate();
                    
                    rs = pstmt.getGeneratedKeys();
                    if (rs.next()) {
                        generatedParentId = rs.getInt(1);
                    }
                    rs.close();
                    pstmt.close();
                } else if (parentId != null && !parentId.trim().isEmpty()) {
                    // Use existing parent
                    generatedParentId = Integer.parseInt(parentId);
                }
                
                // Step 2: Create user account if selected
                if ("true".equals(createUserAccount) && username != null && !username.trim().isEmpty() && 
                    password != null && !password.trim().isEmpty()) {
                    
                    String userSql = "INSERT INTO users (username, password, role, email, active) VALUES (?, ?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(userSql, PreparedStatement.RETURN_GENERATED_KEYS);
                    pstmt.setString(1, username);
                    pstmt.setString(2, password); // In production, this should be hashed
                    pstmt.setString(3, "student");
                    pstmt.setString(4, email);
                    pstmt.setBoolean(5, true);
                    
                    pstmt.executeUpdate();
                    
                    rs = pstmt.getGeneratedKeys();
                    if (rs.next()) {
                        generatedUserId = rs.getInt(1);
                    }
                    rs.close();
                    pstmt.close();
                }
                
                // Step 3: Create student
                String studentSql = "INSERT INTO students (first_name, last_name, email, phone, address, date_of_birth, " +
                                   "reg_number, admission_date, grade, parent_id, user_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                
                pstmt = conn.prepareStatement(studentSql, PreparedStatement.RETURN_GENERATED_KEYS);
                pstmt.setString(1, firstName);
                pstmt.setString(2, lastName);
                pstmt.setString(3, email);
                pstmt.setString(4, phone);
                pstmt.setString(5, address);
                
                // Handle date conversion
                if (dateOfBirth != null && !dateOfBirth.trim().isEmpty()) {
                    java.sql.Date sqlDob = java.sql.Date.valueOf(dateOfBirth);
                    pstmt.setDate(6, sqlDob);
                } else {
                    pstmt.setNull(6, java.sql.Types.DATE);
                }
                
                pstmt.setString(7, regNumber);
                
                if (admissionDate != null && !admissionDate.trim().isEmpty()) {
                    java.sql.Date sqlAdmissionDate = java.sql.Date.valueOf(admissionDate);
                    pstmt.setDate(8, sqlAdmissionDate);
                } else {
                    java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
                    pstmt.setDate(8, today);
                }
                
                pstmt.setString(9, grade);
                
                if (generatedParentId > 0) {
                    pstmt.setInt(10, generatedParentId);
                } else {
                    pstmt.setNull(10, java.sql.Types.INTEGER);
                }
                
                if (generatedUserId > 0) {
                    pstmt.setInt(11, generatedUserId);
                } else {
                    pstmt.setNull(11, java.sql.Types.INTEGER);
                }
                
                pstmt.executeUpdate();
                
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    generatedStudentId = rs.getInt(1);
                }
                rs.close();
                pstmt.close();
                
                // Step 4: Enroll student in course if selected
                if (courseId != null && !courseId.trim().isEmpty() && generatedStudentId > 0) {
                    String enrollSql = "INSERT INTO student_courses (student_id, course_id, enrollment_date, status) VALUES (?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(enrollSql);
                    pstmt.setInt(1, generatedStudentId);
                    pstmt.setInt(2, Integer.parseInt(courseId));
                    pstmt.setDate(3, new java.sql.Date(System.currentTimeMillis()));
                    pstmt.setString(4, "active");
                    
                    pstmt.executeUpdate();
                    pstmt.close();
                }
                
                // Commit transaction
                conn.commit();
                
                response.sendRedirect(request.getContextPath() + "/teacher/student?success=added");
                
            } catch (Exception e) {
                if (conn != null) {
                    try {
                        conn.rollback(); // Rollback transaction on error
                    } catch (SQLException ex) {
                        LOGGER.log(Level.SEVERE, "Error rolling back transaction", ex);
                    }
                }
                throw e;
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignored */ }
                if (conn != null) {
                    try { 
                        conn.setAutoCommit(true); // Reset auto-commit
                        conn.close(); 
                    } catch (SQLException e) { /* ignored */ }
                }
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding student", e);
            request.setAttribute("errorMessage", "Error adding student: " + e.getMessage());
            showNewStudentForm(request, response);
        }
    }
    
    private void viewStudent(HttpServletRequest request, HttpServletResponse response, int teacherId) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/teacher/student");
            return;
        }
        
        try {
            int id = Integer.parseInt(idParam);
            Student student = studentDAO.getStudentById(id);
            
            if (student == null) {
                response.sendRedirect(request.getContextPath() + "/teacher/student?error=notfound");
                return;
            }
            
            // Get courses this student is enrolled in
            List<Course> enrolledCourses = getCoursesByStudentId(id);
            
            request.setAttribute("student", student);
            request.setAttribute("enrolledCourses", enrolledCourses);
            request.getRequestDispatcher("/WEB-INF/views/teacher/student-view.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/teacher/student?error=invalid");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error viewing student", e);
            request.setAttribute("errorMessage", "Error viewing student: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    private void showEnrollStudentForm(HttpServletRequest request, HttpServletResponse response, int teacherId) throws ServletException, IOException {
        try {
            // Get all courses taught by this teacher
            List<Course> teacherCourses = courseDAO.getCoursesByTeacherId(teacherId);
            
            // Get all students (could be filtered to those not already in a specific course)
            List<Student> availableStudents = studentDAO.getAllAvailableStudents();
            
            request.setAttribute("courses", teacherCourses);
            request.setAttribute("students", availableStudents);
            request.getRequestDispatcher("/WEB-INF/views/teacher/student-enroll.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error showing enrollment form", e);
            request.setAttribute("errorMessage", "Error loading enrollment form: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    private void enrollStudent(HttpServletRequest request, HttpServletResponse response, int teacherId) throws ServletException, IOException {
        String studentIdParam = request.getParameter("studentId");
        String courseIdParam = request.getParameter("courseId");
        
        if (studentIdParam == null || studentIdParam.trim().isEmpty() || 
            courseIdParam == null || courseIdParam.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Student and course must be selected");
            showEnrollStudentForm(request, response, teacherId);
            return;
        }
        
        try {
            int studentId = Integer.parseInt(studentIdParam);
            int courseId = Integer.parseInt(courseIdParam);
            
            // Verify the course belongs to this teacher
            Course course = courseDAO.getCourseById(courseId);
            if (course == null || course.getTeacherId() != teacherId) {
                request.setAttribute("errorMessage", "You can only enroll students in your own courses");
                showEnrollStudentForm(request, response, teacherId);
                return;
            }
            
            // Enroll the student
            boolean success = teacherDAO.enrollStudentInCourse(studentId, courseId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/teacher/student?success=enrolled");
            } else {
                request.setAttribute("errorMessage", "Failed to enroll student in course");
                showEnrollStudentForm(request, response, teacherId);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid student or course ID");
            showEnrollStudentForm(request, response, teacherId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error enrolling student", e);
            request.setAttribute("errorMessage", "Error enrolling student: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Helper method to get courses a student is enrolled in
     */
    private List<Course> getCoursesByStudentId(int studentId) throws SQLException {
        List<Course> courses = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT c.* FROM courses c " +
                         "JOIN student_courses sc ON c.course_id = sc.course_id " +
                         "WHERE sc.student_id = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Course course = new Course();
                course.setId(rs.getInt("course_id"));
                course.setCourseName(rs.getString("course_name"));
                course.setCourseCode(rs.getString("course_code"));
                course.setDescription(rs.getString("description"));
                course.setCredits(rs.getInt("credits"));
                course.setTeacherId(rs.getInt("teacher_id"));
                
                // If teacher name is available in the result set
                try {
                    course.setTeacherName(rs.getString("teacher_name"));
                } catch (SQLException e) {
                    // Ignore if not available
                }
                
                courses.add(course);
            }
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
        
        return courses;
    }
}