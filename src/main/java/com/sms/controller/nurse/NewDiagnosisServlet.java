package com.sms.controller.nurse;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sms.dao.DoctorDAO;
import com.sms.dao.HealthRecordDAO;
import com.sms.dao.StudentDAO;
import com.sms.model.Doctor;
import com.sms.model.HealthRecord;
import com.sms.model.Student;
import com.sms.model.User;

/**
 * Servlet to handle new diagnosis creation
 */
@WebServlet("/nurse/new-diagnosis")
public class NewDiagnosisServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private HealthRecordDAO healthRecordDAO;
    private StudentDAO studentDAO;
    private DoctorDAO doctorDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        healthRecordDAO = new HealthRecordDAO();
        studentDAO = new StudentDAO();
        doctorDAO = new DoctorDAO();
    }
    
    /**
     * Handle GET requests - show new diagnosis form
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"nurse".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get all students for the dropdown
            List<Student> allStudents = studentDAO.getAllStudents();
            request.setAttribute("students", allStudents);
            
            // Get all doctors for the dropdown
            List<Doctor> allDoctors = doctorDAO.getAllDoctors();
            request.setAttribute("doctors", allDoctors);
            
            // Forward to new diagnosis form
            request.getRequestDispatcher("/nurse/new_diagnosis.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading form data: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle POST requests - process new diagnosis form submission
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"nurse".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get form data
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            String diagnosisDescription = request.getParameter("description");
            String treatment = request.getParameter("treatment");
            String medication = request.getParameter("medication");
            String notes = request.getParameter("notes");
            
            // Parse date
            String recordDateStr = request.getParameter("recordDate");
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date recordDate = dateFormat.parse(recordDateStr);
            
            // Get doctor ID if assigned
            Integer doctorId = null;
            String doctorIdStr = request.getParameter("doctorId");
            if (doctorIdStr != null && !doctorIdStr.isEmpty()) {
                doctorId = Integer.parseInt(doctorIdStr);
            }
            
            // Create a new health record
            HealthRecord record = new HealthRecord();
            record.setStudentId(studentId);
            record.setRecordDate(recordDate);
            record.setRecordType("diagnosis");
            record.setDescription(diagnosisDescription);
            record.setTreatment(treatment);
            record.setMedication(medication);
            record.setDoctorId(doctorId);
            record.setNurseId(Integer.parseInt(request.getParameter("nurseId")));
            record.setNotes(notes);
            
            // Save the record
            boolean success = healthRecordDAO.addHealthRecord(record);
            
            if (success) {
                request.setAttribute("message", "Diagnosis added successfully!");
                response.sendRedirect(request.getContextPath() + "/nurse/diagnosed-students");
            } else {
                throw new Exception("Failed to add diagnosis. Please try again.");
            }
        } catch (ParseException e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid date format: " + e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error adding diagnosis: " + e.getMessage());
            doGet(request, response);
        }
    }
} 