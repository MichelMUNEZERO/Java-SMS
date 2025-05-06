package com.sms.controller.teacher;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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
    "/teacher/student/enroll",
    "/teacher/student/edit",
    "/teacher/student/update"
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
                listStudents(request, response, getTeacherId(request));
            } else if (path.equals("/teacher/student/new")) {
                showNewStudentForm(request, response);
            } else if (path.equals("/teacher/student/view")) {
                viewStudent(request, response, getTeacherId(request));
            } else if (path.equals("/teacher/student/enroll")) {
                showEnrollStudentForm(request, response, getTeacherId(request));
            } else if (path.equals("/teacher/student/edit")) {
                showEditStudentForm(request, response);
            } else {
                listStudents(request, response, getTeacherId(request));
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
                enrollStudent(request, response, getTeacherId(request));
            } else if (path.equals("/teacher/student/update")) {
                updateStudent(request, response);
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
        // Always show all students for now 
        // This ensures all students in the database are visible
        List<Student> students = studentDAO.getAllStudents();
        LOGGER.info("Showing all " + students.size() + " students from database");
        
        request.setAttribute("students", students);
        request.getRequestDispatcher("/WEB-INF/views/teacher/student-list.jsp").forward(request, response);
    }
    
    private void showNewStudentForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get all courses taught by this teacher to populate the dropdown
            List<Course> courses = courseDAO.getCoursesByTeacherId(getTeacherId(request));
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
        
        // User account information (now required)
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Parent information
        String createNewParent = request.getParameter("createNewParent");
        String parentId = request.getParameter("parentId");
        String parentFirstName = request.getParameter("parentFirstName");
        String parentLastName = request.getParameter("parentLastName");
        String parentEmail = request.getParameter("parentEmail");
        String parentPhone = request.getParameter("parentPhone");
        String parentAddress = request.getParameter("parentAddress");
        String parentOccupation = request.getParameter("parentOccupation");
        
        // Validate required inputs
        if (firstName == null || firstName.trim().isEmpty() || 
            lastName == null || lastName.trim().isEmpty() || 
            regNumber == null || regNumber.trim().isEmpty() ||
            username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
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
                
                // Step 2: Create user account (now required)
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
                    // First check if student_courses table exists
                    DatabaseMetaData dbMeta = conn.getMetaData();
                    ResultSet tables = dbMeta.getTables(null, null, "student_courses", null);
                    boolean tableExists = tables.next();
                    tables.close();
                    
                    if (!tableExists) {
                        // Create the student_courses table if it doesn't exist
                        String createTableSql = "CREATE TABLE student_courses (" +
                                              "id INT AUTO_INCREMENT PRIMARY KEY, " +
                                              "student_id INT NOT NULL, " +
                                              "course_id INT NOT NULL, " +
                                              "enrollment_date DATE DEFAULT CURRENT_DATE(), " +
                                              "status VARCHAR(20) DEFAULT 'active', " +
                                              "FOREIGN KEY (student_id) REFERENCES students(student_id), " +
                                              "FOREIGN KEY (course_id) REFERENCES courses(course_id), " +
                                              "UNIQUE (student_id, course_id)" +
                                              ")";
                        
                        Statement stmt = conn.createStatement();
                        stmt.executeUpdate(createTableSql);
                        stmt.close();
                        LOGGER.info("Created student_courses table");
                    }
                    
                    String enrollSql = "INSERT INTO student_courses (student_id, course_id, enrollment_date, status) VALUES (?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(enrollSql);
                    pstmt.setInt(1, generatedStudentId);
                    pstmt.setInt(2, Integer.parseInt(courseId));
                    pstmt.setDate(3, new java.sql.Date(System.currentTimeMillis()));
                    pstmt.setString(4, "active");
                    
                    pstmt.executeUpdate();
                    pstmt.close();
                    LOGGER.info("Enrolled student ID " + generatedStudentId + " in course ID " + courseId);
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
            LOGGER.warning("Student ID parameter is missing");
            request.setAttribute("error", "Student ID is required");
            request.getRequestDispatcher("/WEB-INF/views/teacher/student-list.jsp").forward(request, response);
            return;
        }
        
        try {
            int studentId = Integer.parseInt(idParam);
            LOGGER.info("Attempting to view student with ID: " + studentId);
            
            Student student = studentDAO.getStudentById(studentId);
            LOGGER.info("Retrieved student: " + (student != null ? student.getFirstName() + " " + student.getLastName() : "null"));
            
            if (student == null) {
                LOGGER.warning("No student found with ID: " + studentId);
                request.setAttribute("error", "Student not found");
                request.getRequestDispatcher("/WEB-INF/views/teacher/student-list.jsp").forward(request, response);
                return;
            }
            
            // Ensure required fields have default values if null
            if (student.getStatus() == null || student.getStatus().trim().isEmpty()) {
                student.setStatus("active");
            }
            if (student.getEmail() == null) {
                student.setEmail("");
            }
            if (student.getPhone() == null) {
                student.setPhone("Not provided");
            }
            if (student.getAddress() == null) {
                student.setAddress("Not provided");
            }
            if (student.getRegNumber() == null) {
                student.setRegNumber("Not provided");
            }
            
            // Get courses this student is enrolled in
            LOGGER.info("Getting enrolled courses for student ID: " + studentId);
            List<Course> enrolledCourses = getCoursesByStudentId(studentId);
            LOGGER.info("Found " + (enrolledCourses != null ? enrolledCourses.size() : 0) + " enrolled courses");
            
            if (enrolledCourses == null) {
                enrolledCourses = new ArrayList<>();
            }
            
            // Set attributes for the JSP
            request.setAttribute("student", student);
            request.setAttribute("enrolledCourses", enrolledCourses);
            
            // Forward to the view page
            LOGGER.info("Forwarding to student-view.jsp");
            request.getRequestDispatcher("/WEB-INF/views/teacher/student-view.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid student ID format: " + idParam, e);
            request.setAttribute("error", "Invalid student ID format");
            request.getRequestDispatcher("/WEB-INF/views/teacher/student-list.jsp").forward(request, response);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error while viewing student", e);
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error while viewing student", e);
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
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
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Course> courses = new ArrayList<>();
        
        try {
            LOGGER.info("Getting courses for student ID: " + studentId);
            conn = DBConnection.getConnection();
            
            // First check if the student_courses table exists
            DatabaseMetaData dbMeta = conn.getMetaData();
            ResultSet tables = dbMeta.getTables(null, null, "student_courses", null);
            boolean tableExists = tables.next();
            tables.close();
            
            if (!tableExists) {
                LOGGER.warning("student_courses table does not exist");
                return courses;
            }
            
            String sql = "SELECT c.*, t.first_name as teacher_first_name, t.last_name as teacher_last_name " +
                        "FROM courses c " +
                        "JOIN student_courses sc ON c.course_id = sc.course_id " +
                        "JOIN teachers t ON c.teacher_id = t.teacher_id " +
                        "WHERE sc.student_id = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Course course = new Course();
                course.setId(rs.getInt("course_id"));
                course.setCourseCode(rs.getString("course_code"));
                course.setCourseName(rs.getString("course_name"));
                course.setCredits(rs.getInt("credits"));
                course.setTeacherName(rs.getString("teacher_first_name") + " " + rs.getString("teacher_last_name"));
                courses.add(course);
            }
            
            LOGGER.info("Found " + courses.size() + " courses for student ID: " + studentId);
            return courses;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting courses for student ID: " + studentId, e);
            throw e;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignored */ }
        }
    }
    
    private void showEditStudentForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String studentId = request.getParameter("id");
            if (studentId == null || studentId.trim().isEmpty()) {
                throw new IllegalArgumentException("Student ID is required");
            }
            
            int id = Integer.parseInt(studentId);
            Student student = studentDAO.getStudentById(id);
            if (student == null) {
                throw new IllegalArgumentException("Student not found");
            }
            
            // Get all courses taught by this teacher to populate the dropdown
            List<Course> courses = courseDAO.getCoursesByTeacherId(getTeacherId(request));
            request.setAttribute("courses", courses);
            
            // Get all parents for the existing parent dropdown
            List<Parent> parents = teacherDAO.getAllParents();
            request.setAttribute("parents", parents);
            
            // Set the student object for the form
            request.setAttribute("student", student);
            request.setAttribute("isEdit", true);
            
            request.getRequestDispatcher("/WEB-INF/views/teacher/student-form.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error preparing edit student form", e);
            request.setAttribute("errorMessage", "Error loading edit form: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    private void updateStudent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String studentId = request.getParameter("studentId");
            if (studentId == null || studentId.trim().isEmpty()) {
                throw new IllegalArgumentException("Student ID is required");
            }
            
            int id = Integer.parseInt(studentId);
            Student existingStudent = studentDAO.getStudentById(id);
            if (existingStudent == null) {
                throw new IllegalArgumentException("Student not found");
            }
            
            // Get updated student information
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String regNumber = request.getParameter("regNumber");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String dateOfBirth = request.getParameter("dateOfBirth");
            String admissionDate = request.getParameter("admissionDate");
            String grade = request.getParameter("grade");
            
            // Validate required inputs
            if (firstName == null || firstName.trim().isEmpty() || 
                lastName == null || lastName.trim().isEmpty() || 
                regNumber == null || regNumber.trim().isEmpty()) {
                
                request.setAttribute("errorMessage", "Required fields cannot be empty");
                showEditStudentForm(request, response);
                return;
            }
            
            // Update student information
            existingStudent.setFirstName(firstName);
            existingStudent.setLastName(lastName);
            existingStudent.setRegNumber(regNumber);
            existingStudent.setEmail(email);
            existingStudent.setPhone(phone);
            existingStudent.setAddress(address);
            if (dateOfBirth != null && !dateOfBirth.trim().isEmpty()) {
                existingStudent.setDateOfBirth(java.sql.Date.valueOf(dateOfBirth));
            }
            if (admissionDate != null && !admissionDate.trim().isEmpty()) {
                existingStudent.setAdmissionDate(java.sql.Date.valueOf(admissionDate));
            }
            existingStudent.setGrade(grade);
            
            // Update the student in the database
            studentDAO.updateStudent(existingStudent);
            
            // Redirect to student view with success message
            request.getSession().setAttribute("message", "Student information updated successfully");
            response.sendRedirect(request.getContextPath() + "/teacher/student/view?id=" + id);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating student", e);
            request.setAttribute("errorMessage", "Error updating student: " + e.getMessage());
            showEditStudentForm(request, response);
        }
    }
    
    private int getTeacherId(HttpServletRequest request) {
        User user = (User) request.getSession().getAttribute("user");
        int userId = user.getUserId();
        
        // Get the teacher ID from the database based on user ID
        int teacherId = teacherDAO.getTeacherIdByUserId(userId);
        
        if (teacherId <= 0) {
            // Fallback to user ID if teacher ID not found
            teacherId = userId;
            LOGGER.warning("Could not find teacher ID for user ID: " + userId + ". Using user ID as fallback.");
        }
        
        return teacherId;
    }
}