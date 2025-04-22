package com.sms.controller;

import java.io.IOException;
import java.util.ArrayList;
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
import com.sms.model.Course;
import com.sms.model.Teacher;

/**
 * Servlet implementation class CourseServlet
 * Handles course-related operations
 */
@WebServlet("/course/*")
public class CourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CourseDAO courseDAO;
    private TeacherDAO teacherDAO;
    
    /**
     * Initialize the DAOs
     */
    public void init() {
        courseDAO = new CourseDAO();
        teacherDAO = new TeacherDAO();
    }
    
    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/";
        }
        
        try {
            switch (pathInfo) {
                case "/list":
                    listCourses(request, response);
                    break;
                case "/view":
                    viewCourse(request, response);
                    break;
                case "/new":
                    showNewForm(request, response);
                    break;
                case "/edit":
                    showEditForm(request, response);
                    break;
                case "/delete":
                    deleteCourse(request, response);
                    break;
                case "/teacher":
                    listTeacherCourses(request, response);
                    break;
                default:
                    listCourses(request, response);
                    break;
            }
        } catch (Exception ex) {
            request.setAttribute("error", "Error: " + ex.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/error.jsp");
            dispatcher.forward(request, response);
        }
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) {
            action = "/";
        }
        
        try {
            switch (action) {
                case "/insert":
                    insertCourse(request, response);
                    break;
                case "/update":
                    updateCourse(request, response);
                    break;
                default:
                    listCourses(request, response);
                    break;
            }
        } catch (Exception ex) {
            request.setAttribute("error", "Error: " + ex.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/error.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    /**
     * List all courses
     */
    private void listCourses(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Course> courses = courseDAO.getAllCourses();
        
        // Create a course data map with additional information
        List<Course> enhancedCourses = new ArrayList<>();
        for (Course course : courses) {
            // Get student count for each course
            int studentCount = courseDAO.getStudentsCountByCourseId(course.getCourseId());
            course.setStudentCount(studentCount);
            enhancedCourses.add(course);
        }
        
        request.setAttribute("courses", enhancedCourses);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/courses.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * List courses assigned to a teacher
     */
    private void listTeacherCourses(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("teacherId") != null) {
            int teacherId = (int) session.getAttribute("teacherId");
            List<Course> courses = courseDAO.getCoursesByTeacherId(teacherId);
            request.setAttribute("courses", courses);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/teacher/courses.jsp");
            dispatcher.forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
    
    /**
     * View a single course
     */
    private void viewCourse(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int courseId = Integer.parseInt(request.getParameter("id"));
        Course course = courseDAO.getCourseById(courseId);
        
        if (course != null) {
            Teacher teacher = teacherDAO.getTeacherById(course.getTeacherId());
            int studentCount = courseDAO.getStudentsCountByCourseId(courseId);
            
            request.setAttribute("course", course);
            request.setAttribute("teacher", teacher);
            request.setAttribute("studentCount", studentCount);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/course-details.jsp");
            dispatcher.forward(request, response);
        } else {
            request.setAttribute("error", "Course not found");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/error.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    /**
     * Show the form to add a new course
     */
    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Teacher> teachers = teacherDAO.getAllTeachers();
        request.setAttribute("teachers", teachers);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/course-form.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * Show the form to edit an existing course
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int courseId = Integer.parseInt(request.getParameter("id"));
        Course course = courseDAO.getCourseById(courseId);
        List<Teacher> teachers = teacherDAO.getAllTeachers();
        
        request.setAttribute("course", course);
        request.setAttribute("teachers", teachers);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/course-form.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * Insert a new course
     */
    private void insertCourse(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String courseName = request.getParameter("courseName");
        String description = request.getParameter("description");
        int teacherId = Integer.parseInt(request.getParameter("teacherId"));
        
        Course course = new Course();
        course.setCourseName(courseName);
        course.setDescription(description);
        course.setTeacherId(teacherId);
        
        int courseId = courseDAO.addCourse(course);
        if (courseId > 0) {
            request.setAttribute("message", "Course added successfully");
        } else {
            request.setAttribute("error", "Failed to add course");
        }
        
        listCourses(request, response);
    }
    
    /**
     * Update an existing course
     */
    private void updateCourse(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        String courseName = request.getParameter("courseName");
        String description = request.getParameter("description");
        int teacherId = Integer.parseInt(request.getParameter("teacherId"));
        
        Course course = new Course();
        course.setCourseId(courseId);
        course.setCourseName(courseName);
        course.setDescription(description);
        course.setTeacherId(teacherId);
        
        boolean updated = courseDAO.updateCourse(course);
        if (updated) {
            request.setAttribute("message", "Course updated successfully");
        } else {
            request.setAttribute("error", "Failed to update course");
        }
        
        listCourses(request, response);
    }
    
    /**
     * Delete a course
     */
    private void deleteCourse(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int courseId = Integer.parseInt(request.getParameter("id"));
        boolean deleted = courseDAO.deleteCourse(courseId);
        
        if (deleted) {
            request.setAttribute("message", "Course deleted successfully");
        } else {
            request.setAttribute("error", "Failed to delete course");
        }
        
        listCourses(request, response);
    }
    
    /**
     * Clean up resources
     */
    public void destroy() {
        courseDAO.close();
    }
} 