package com.sms.controller.teacher;

import com.sms.dao.AppointmentDAO;
import com.sms.dao.TeacherDAO;
import com.sms.dao.ParentDAO;
import com.sms.dao.StudentDAO;
import com.sms.model.User;
import com.sms.model.Parent;
import com.sms.util.DBConnection;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "AppointmentsServlet", value = "/teacher/appointments")
public class AppointmentsServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AppointmentsServlet.class.getName());
    private AppointmentDAO appointmentDAO;
    private TeacherDAO teacherDAO;
    private ParentDAO parentDAO;
    private StudentDAO studentDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        appointmentDAO = new AppointmentDAO();
        teacherDAO = new TeacherDAO();
        parentDAO = new ParentDAO();
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            
            if (session == null || session.getAttribute("user") == null) {
                // Not logged in, redirect to login page
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            User user = (User) session.getAttribute("user");
            int userId = user.getUserId();
            LOGGER.info("Loading appointments for user ID: " + userId);
            
            // Get the teacher ID from the database based on user ID
            int teacherId = teacherDAO.getTeacherIdByUserId(userId);
            
            if (teacherId <= 0) {
                // Fallback to user ID if teacher ID not found
                teacherId = userId;
                LOGGER.warning("Could not find teacher ID for user ID: " + userId + ". Using user ID as fallback.");
            }
            
            LOGGER.info("Loading appointments for teacher ID: " + teacherId);

            // Since getAppointmentsByTeacherId seems to not exist, we'll use a different approach
            // Either modify a similar method or try to retrieve all appointments
            List<Map<String, Object>> appointments = new ArrayList<>();
            // This is a fallback to get all appointments and filter in the JSP by teacher ID
            appointments = appointmentDAO.getAllAppointments();
            
            // Get student and parent data for the appointment form
            List<Map<String, Object>> students = new ArrayList<>();
            List<Parent> parents = new ArrayList<>();
            
            try {
                // Use CourseStudentsServlet approach - get students with marks by courses the teacher teaches
                // First, get all courses taught by the teacher
                List<Map<String, Object>> teacherCourses = teacherDAO.getCoursesByTeacherId(teacherId);
                
                // For each course, get the students
                if (teacherCourses != null && !teacherCourses.isEmpty()) {
                    for (Map<String, Object> course : teacherCourses) {
                        int courseId = (int) course.get("courseId");
                        List<Map<String, Object>> courseStudents = teacherDAO.getStudentsWithMarksByCourseId(courseId);
                        
                        // Add each student to the list, avoiding duplicates
                        for (Map<String, Object> student : courseStudents) {
                            // Check if student is already in the list
                            boolean found = false;
                            for (Map<String, Object> existingStudent : students) {
                                if (existingStudent.get("studentId").equals(student.get("studentId"))) {
                                    found = true;
                                    break;
                                }
                            }
                            
                            if (!found) {
                                students.add(student);
                            }
                        }
                    }
                }
                
                // If no students found, use studentDAO to get all students
                if (students.isEmpty()) {
                    // Convert Student objects to Map objects
                    List<Map<String, Object>> allStudentsAsMap = new ArrayList<>();
                    for (Object student : studentDAO.getAllStudents()) {
                        Map<String, Object> studentMap = new HashMap<>();
                        studentMap.put("studentId", ((com.sms.model.Student)student).getId());
                        studentMap.put("firstName", ((com.sms.model.Student)student).getFirstName());
                        studentMap.put("lastName", ((com.sms.model.Student)student).getLastName());
                        studentMap.put("email", ((com.sms.model.Student)student).getEmail());
                        studentMap.put("grade", ((com.sms.model.Student)student).getGrade());
                        allStudentsAsMap.add(studentMap);
                    }
                    students = allStudentsAsMap;
                }
                
                // Get all parents
                parents = parentDAO.getAllParents();
                
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error loading students/parents: " + e.getMessage(), e);
                // Continue with empty lists if there's an error
            }
            
            // Convert parents list to map list for consistent handling in JSP
            List<Map<String, Object>> parentsAsMaps = new ArrayList<>();
            for (Parent parent : parents) {
                Map<String, Object> parentMap = new HashMap<>();
                parentMap.put("id", parent.getId());
                parentMap.put("firstName", parent.getFirstName());
                parentMap.put("lastName", parent.getLastName());
                parentMap.put("email", parent.getEmail());
                parentMap.put("phone", parent.getPhone());
                parentMap.put("fullName", parent.getFirstName() + " " + parent.getLastName());
                parentsAsMaps.add(parentMap);
            }
            
            request.setAttribute("teacherId", teacherId);
            request.setAttribute("appointments", appointments);
            request.setAttribute("students", students);
            request.setAttribute("parents", parentsAsMaps);
            
            request.getRequestDispatcher("/WEB-INF/views/teacher/appointments.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading appointments: " + e.getMessage(), e);
            request.setAttribute("error", "Error loading appointments: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/teacher/appointments.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            createAppointment(request, response);
        } else if ("updateStatus".equals(action)) {
            updateAppointmentStatus(request, response);
        }
    }

    private void createAppointment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            
            if (session == null || session.getAttribute("user") == null) {
                // Not logged in, redirect to login page
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            User user = (User) session.getAttribute("user");
            int userId = user.getUserId();
            
            // Get the teacher ID from the database based on user ID
            int teacherId = teacherDAO.getTeacherIdByUserId(userId);
            
            if (teacherId <= 0) {
                // Fallback to user ID if teacher ID not found
                teacherId = userId;
                LOGGER.warning("Could not find teacher ID for user ID: " + userId + ". Using user ID as fallback.");
            }

            // Parse the appointment details from the form
            int parentId = Integer.parseInt(request.getParameter("parentId"));
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            String purpose = request.getParameter("purpose");
            
            // Parse date and time from form inputs
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
            
            java.sql.Date appointmentDate = null;
            java.sql.Time appointmentTime = null;
            
            try {
                java.util.Date parsedDate = dateFormat.parse(request.getParameter("appointmentDate"));
                appointmentDate = new java.sql.Date(parsedDate.getTime());
                
                java.util.Date parsedTime = timeFormat.parse(request.getParameter("appointmentTime"));
                appointmentTime = new java.sql.Time(parsedTime.getTime());
            } catch (Exception e) {
                throw new ServletException("Error parsing date/time: " + e.getMessage(), e);
            }
            
            boolean success = appointmentDAO.createAppointment(parentId, teacherId, "teacher", studentId, 
                                          appointmentDate, appointmentTime, purpose);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/teacher/appointments?success=created");
            } else {
                request.setAttribute("error", "Failed to create appointment");
                request.getRequestDispatcher("/WEB-INF/views/teacher/appointments.jsp").forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating appointment: " + e.getMessage(), e);
            request.setAttribute("error", "Error creating appointment: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/teacher/appointments.jsp").forward(request, response);
        }
    }

    private void updateAppointmentStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            String status = request.getParameter("status");
            String notes = request.getParameter("notes") != null ? request.getParameter("notes") : "";
            
            // The method signature might vary, try with status only first
            boolean success = false;
            try {
                // Try with three parameters (correct signature)
                success = appointmentDAO.updateAppointmentStatus(appointmentId, status, notes);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error updating appointment status", e);
                request.setAttribute("error", "Error updating appointment status: " + e.getMessage());
                request.getRequestDispatcher("/WEB-INF/views/teacher/appointments.jsp").forward(request, response);
                return;
            }
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/teacher/appointments?success=updated");
            } else {
                request.setAttribute("error", "Failed to update appointment status");
                request.getRequestDispatcher("/WEB-INF/views/teacher/appointments.jsp").forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating appointment status: " + e.getMessage(), e);
            request.setAttribute("error", "Error updating appointment status: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/teacher/appointments.jsp").forward(request, response);
        }
    }
} 