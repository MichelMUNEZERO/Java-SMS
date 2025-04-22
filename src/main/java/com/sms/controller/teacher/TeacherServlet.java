package com.sms.controller.teacher;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.dao.CourseDAO;
import com.sms.dao.TeacherDAO;
import com.sms.dao.StudentDAO;
import com.sms.model.Course;
import com.sms.model.Teacher;
import com.sms.model.Student;
import com.sms.util.PasswordHasher;

@WebServlet("/teacher/*")
public class TeacherServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TeacherDAO teacherDAO;
    private CourseDAO courseDAO;
    private StudentDAO studentDAO;
    
    public void init() {
        teacherDAO = new TeacherDAO();
        courseDAO = new CourseDAO();
        studentDAO = new StudentDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        
        if (action == null) {
            action = "/dashboard";
        }
        
        try {
            switch (action) {
                case "/dashboard":
                    showDashboard(request, response);
                    break;
                case "/courses":
                    listTeacherCourses(request, response);
                    break;
                case "/course-details":
                    showCourseDetails(request, response);
                    break;
                case "/students":
                    listStudents(request, response);
                    break;
                case "/profile":
                    showProfile(request, response);
                    break;
                case "/edit-profile":
                    showEditProfileForm(request, response);
                    break;
                default:
                    showDashboard(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/teacher/dashboard");
            return;
        }
        
        try {
            switch (action) {
                case "/update-profile":
                    updateProfile(request, response);
                    break;
                case "/change-password":
                    changePassword(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/teacher/dashboard");
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
    
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        int teacherId = (int) session.getAttribute("userId");
        
        Teacher teacher = teacherDAO.getTeacherById(teacherId);
        List<Course> courses = courseDAO.getCoursesByTeacherId(teacherId);
        
        request.setAttribute("teacher", teacher);
        request.setAttribute("courses", courses);
        request.setAttribute("courseCount", courses.size());
        
        // Get count of all students in teacher's courses
        int studentCount = 0;
        for (Course course : courses) {
            // Assuming we have a method to get students by course ID
            List<Student> students = studentDAO.getStudentsByCourseId(course.getCourseId());
            studentCount += students.size();
        }
        request.setAttribute("studentCount", studentCount);
        
        // Pending assessments count - this would come from a real assessment system
        request.setAttribute("pendingAssessments", 12);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/teacher/dashboard.jsp");
        dispatcher.forward(request, response);
    }
    
    private void listTeacherCourses(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        int teacherId = (int) session.getAttribute("userId");
        
        List<Course> courses = courseDAO.getCoursesByTeacherId(teacherId);
        request.setAttribute("courses", courses);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/teacher/courses.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showCourseDetails(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int courseId = Integer.parseInt(request.getParameter("id"));
        Course course = courseDAO.getCourseById(courseId);
        
        HttpSession session = request.getSession();
        int teacherId = (int) session.getAttribute("userId");
        
        // Verify that this course belongs to the logged-in teacher
        if (course != null && course.getTeacherId() == teacherId) {
            List<Student> students = studentDAO.getStudentsByCourseId(courseId);
            
            request.setAttribute("course", course);
            request.setAttribute("students", students);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/teacher/course-details.jsp");
            dispatcher.forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/teacher/courses");
        }
    }
    
    private void listStudents(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        int teacherId = (int) session.getAttribute("userId");
        
        List<Course> courses = courseDAO.getCoursesByTeacherId(teacherId);
        request.setAttribute("courses", courses);
        
        // If a specific course is selected, show only students from that course
        String courseIdParam = request.getParameter("courseId");
        if (courseIdParam != null && !courseIdParam.isEmpty()) {
            int courseId = Integer.parseInt(courseIdParam);
            List<Student> students = studentDAO.getStudentsByCourseId(courseId);
            request.setAttribute("students", students);
            request.setAttribute("selectedCourseId", courseId);
        } else {
            // Otherwise, show all students from all courses taught by this teacher
            List<Student> allStudents = studentDAO.getStudentsByTeacherId(teacherId);
            request.setAttribute("students", allStudents);
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/teacher/students.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        int teacherId = (int) session.getAttribute("userId");
        
        Teacher teacher = teacherDAO.getTeacherById(teacherId);
        request.setAttribute("teacher", teacher);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/teacher/profile.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showEditProfileForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        int teacherId = (int) session.getAttribute("userId");
        
        Teacher teacher = teacherDAO.getTeacherById(teacherId);
        request.setAttribute("teacher", teacher);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/teacher/edit-profile.jsp");
        dispatcher.forward(request, response);
    }
    
    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        int teacherId = (int) session.getAttribute("userId");
        
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String specialization = request.getParameter("specialization");
        
        Teacher teacher = teacherDAO.getTeacherById(teacherId);
        
        teacher.setFirstName(firstName);
        teacher.setLastName(lastName);
        teacher.setEmail(email);
        teacher.setPhone(phone);
        teacher.setAddress(address);
        teacher.setSpecialization(specialization);
        
        teacherDAO.updateTeacher(teacher);
        
        session.setAttribute("message", "Profile updated successfully");
        response.sendRedirect(request.getContextPath() + "/teacher/profile");
    }
    
    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        int teacherId = (int) session.getAttribute("userId");
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate that new password and confirm password match
        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("error", "New password and confirm password do not match");
            response.sendRedirect(request.getContextPath() + "/teacher/profile");
            return;
        }
        
        Teacher teacher = teacherDAO.getTeacherById(teacherId);
        
        // Validate current password
        if (!PasswordHasher.checkPassword(currentPassword, teacher.getPassword())) {
            session.setAttribute("error", "Current password is incorrect");
            response.sendRedirect(request.getContextPath() + "/teacher/profile");
            return;
        }
        
        // Hash new password and update
        String hashedPassword = PasswordHasher.hashPassword(newPassword);
        teacher.setPassword(hashedPassword);
        
        teacherDAO.updateTeacher(teacher);
        
        session.setAttribute("message", "Password changed successfully");
        response.sendRedirect(request.getContextPath() + "/teacher/profile");
    }
} 