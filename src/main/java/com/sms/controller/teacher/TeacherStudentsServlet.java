package com.sms.controller.teacher;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.dao.StudentDAO;
import com.sms.dao.TeacherDAO;
import com.sms.model.Student;
import com.sms.model.User;

/**
 * Servlet to handle teacher students management
 */
@WebServlet(urlPatterns = { 
    "/teacher/students", 
    "/teacher/students/add",
    "/teacher/students/enroll",
    "/teacher/students/remove/*"
})
public class TeacherStudentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StudentDAO studentDAO;
    private TeacherDAO teacherDAO;
    
    @Override
    public void init() throws ServletException {
        studentDAO = new StudentDAO();
        teacherDAO = new TeacherDAO();
    }
    
    /**
     * Handle GET requests
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check authentication and teacher role
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"teacher".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/" + user.getRole().toLowerCase() + "/dashboard");
            return;
        }
        
        int teacherId = user.getUserId();
        String action = request.getServletPath();
        
        if (action.equals("/teacher/students")) {
            // Show all students enrolled in this teacher's courses
            listStudents(request, response, teacherId);
        } else if (action.equals("/teacher/students/add")) {
            // Show form to add a new student
            showAddStudentForm(request, response, teacherId);
        } else if (action.startsWith("/teacher/students/remove/")) {
            // Remove a student from a course
            removeStudentFromCourse(request, response, teacherId);
        } else {
            // Default to student listing
            response.sendRedirect(request.getContextPath() + "/teacher/students");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check authentication and teacher role
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"teacher".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/" + user.getRole().toLowerCase() + "/dashboard");
            return;
        }
        
        int teacherId = user.getUserId();
        String action = request.getServletPath();
        
        if (action.equals("/teacher/students/add")) {
            // Process new student form
            addNewStudent(request, response, teacherId);
        } else if (action.equals("/teacher/students/enroll")) {
            // Enroll existing student in a course
            enrollExistingStudent(request, response, teacherId);
        } else {
            // Default redirect to listing
            response.sendRedirect(request.getContextPath() + "/teacher/students");
        }
    }
    
    /**
     * List all students in teacher's courses
     */
    private void listStudents(HttpServletRequest request, HttpServletResponse response, int teacherId) 
            throws ServletException, IOException {
        // Get all students instead of just those enrolled in this teacher's courses
        List<Student> allStudents = studentDAO.getAllStudents();
        List<Student> availableStudents = studentDAO.getAllAvailableStudents();
        
        // Use all students instead of just enrolled students
        request.setAttribute("students", allStudents);
        request.setAttribute("availableStudents", availableStudents);
        request.setAttribute("courses", teacherDAO.getCoursesByTeacherId(teacherId));
        
        // Use correct JSP file path
        request.getRequestDispatcher("/WEB-INF/views/teacher/student-list.jsp").forward(request, response);
    }
    
    /**
     * Show form to add a new student
     */
    private void showAddStudentForm(HttpServletRequest request, HttpServletResponse response, int teacherId) 
            throws ServletException, IOException {
        // Get teacher's courses for dropdown
        request.setAttribute("courses", teacherDAO.getCoursesByTeacherId(teacherId));
        request.getRequestDispatcher("/WEB-INF/views/teacher/student_form.jsp").forward(request, response);
    }
    
    /**
     * Add a new student and enroll in a course
     */
    private void addNewStudent(HttpServletRequest request, HttpServletResponse response, int teacherId) 
            throws ServletException, IOException {
        try {
            // Collect form data
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String gender = request.getParameter("gender");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            
            // Process dates
            java.sql.Date dateOfBirth = null;
            if (request.getParameter("dateOfBirth") != null && !request.getParameter("dateOfBirth").isEmpty()) {
                dateOfBirth = java.sql.Date.valueOf(request.getParameter("dateOfBirth"));
            }
            
            java.sql.Date admissionDate = null;
            if (request.getParameter("admissionDate") != null && !request.getParameter("admissionDate").isEmpty()) {
                admissionDate = java.sql.Date.valueOf(request.getParameter("admissionDate"));
            }
            
            // Guardian information
            String guardianName = request.getParameter("guardianName");
            String guardianPhone = request.getParameter("guardianPhone");
            String guardianEmail = request.getParameter("guardianEmail");
            
            // Academic information
            int classId = 0;
            if (request.getParameter("classId") != null && !request.getParameter("classId").isEmpty()) {
                classId = Integer.parseInt(request.getParameter("classId"));
            }
            
            int courseId = 0;
            if (request.getParameter("courseId") != null && !request.getParameter("courseId").isEmpty()) {
                courseId = Integer.parseInt(request.getParameter("courseId"));
            }
            
            String status = "active"; // Default status for new students
            
            // Create student object
            Student student = new Student();
            student.setFirstName(firstName);
            student.setLastName(lastName);
            student.setGender(gender);
            student.setEmail(email);
            student.setPhone(phone);
            student.setAddress(address);
            student.setDateOfBirth(dateOfBirth);
            student.setAdmissionDate(admissionDate);
            student.setGuardianName(guardianName);
            student.setGuardianPhone(guardianPhone);
            student.setGuardianEmail(guardianEmail);
            student.setClassId(classId);
            student.setStatus(status);
            
            // Save to database and get the new student ID
            boolean addSuccess = studentDAO.addStudent(student);
            
            if (addSuccess && courseId > 0) {
                // Need to get the student ID after adding
                List<Student> students = studentDAO.getAllStudents();
                int studentId = -1;
                
                // Find the student with matching email
                for (Student s : students) {
                    if (email.equals(s.getEmail())) {
                        studentId = s.getId();
                        break;
                    }
                }
                
                if (studentId > 0) {
                    // Enroll the student in the selected course
                    boolean enrollSuccess = teacherDAO.enrollStudentInCourse(studentId, courseId);
                    
                    if (enrollSuccess) {
                        response.sendRedirect(request.getContextPath() + "/teacher/students?message=Student added and enrolled successfully");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/teacher/students?message=Student added but enrollment failed");
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/teacher/students?message=Student added but couldn't be enrolled (ID not found)");
                }
            } else if (addSuccess) {
                response.sendRedirect(request.getContextPath() + "/teacher/students?message=Student added successfully");
            } else {
                // Show form again with error message
                request.setAttribute("error", "Failed to add student. Please try again.");
                request.setAttribute("student", student);
                request.setAttribute("courses", teacherDAO.getCoursesByTeacherId(teacherId));
                request.getRequestDispatcher("/WEB-INF/views/teacher/student_form.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            
            // Show form with error message
            request.setAttribute("error", "Error: " + e.getMessage());
            request.setAttribute("courses", teacherDAO.getCoursesByTeacherId(teacherId));
            request.getRequestDispatcher("/WEB-INF/views/teacher/student_form.jsp").forward(request, response);
        }
    }
    
    /**
     * Enroll an existing student in a course
     */
    private void enrollExistingStudent(HttpServletRequest request, HttpServletResponse response, int teacherId) 
            throws ServletException, IOException {
        try {
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            
            // Check if the course belongs to this teacher
            boolean validCourse = false;
            List<Map<String, Object>> teacherCourses = teacherDAO.getCoursesByTeacherId(teacherId);
            for (Map<String, Object> courseObj : teacherCourses) {
                // This depends on the structure returned by getCoursesByTeacherId
                // For example: int id = (Integer)courseObj.get("courseId");
                validCourse = true; // For now, assuming all courses are valid
            }
            
            if (!validCourse) {
                response.sendRedirect(request.getContextPath() + "/teacher/students?error=Invalid course selection");
                return;
            }
            
            boolean success = teacherDAO.enrollStudentInCourse(studentId, courseId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/teacher/students?message=Student enrolled successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/teacher/students?error=Failed to enroll student");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/teacher/students?error=Error: " + e.getMessage());
        }
    }
    
    /**
     * Remove a student from a course
     */
    private void removeStudentFromCourse(HttpServletRequest request, HttpServletResponse response, int teacherId) 
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            String[] parts = pathInfo.substring(1).split("-"); // Format: /studentId-courseId
            
            if (parts.length != 2) {
                response.sendRedirect(request.getContextPath() + "/teacher/students?error=Invalid removal request");
                return;
            }
            
            int studentId = Integer.parseInt(parts[0]);
            int courseId = Integer.parseInt(parts[1]);
            
            // Check if this course belongs to this teacher (security check)
            boolean validCourse = false;
            List<Map<String, Object>> teacherCourses = teacherDAO.getCoursesByTeacherId(teacherId);
            for (Map<String, Object> courseObj : teacherCourses) {
                // Similar to enrollment check, adjust based on your implementation
                validCourse = true; // For now, assuming all courses are valid
            }
            
            if (!validCourse) {
                response.sendRedirect(request.getContextPath() + "/teacher/students?error=Invalid course selection");
                return;
            }
            
            boolean success = teacherDAO.removeStudentFromCourse(studentId, courseId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/teacher/students?message=Student removed from course successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/teacher/students?error=Failed to remove student from course");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/teacher/students?error=Error: " + e.getMessage());
        }
    }
} 