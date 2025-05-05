package com.school.controller;

import com.school.dao.AppointmentDAO;
import com.school.model.Appointment;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

@Controller
@RequestMapping("/teacher")
public class TeacherAppointmentsController {

    private final Connection connection;
    private final AppointmentDAO appointmentDAO;

    public TeacherAppointmentsController(Connection connection) {
        this.connection = connection;
        this.appointmentDAO = new AppointmentDAO(connection);
    }

    @GetMapping("/appointments")
    public String showAppointments(Model model, HttpSession session) {
        try {
            Integer teacherId = (Integer) session.getAttribute("teacherId");
            if (teacherId == null) {
                return "redirect:/login";
            }

            List<Appointment> appointments = appointmentDAO.getTeacherAppointments(teacherId);
            model.addAttribute("appointments", appointments);
            return "teacher/appointments";
        } catch (SQLException e) {
            model.addAttribute("error", "Error loading appointments: " + e.getMessage());
            return "teacher/appointments";
        }
    }

    @PostMapping("/appointments")
    public String createAppointment(@ModelAttribute Appointment appointment, HttpSession session) {
        try {
            Integer teacherId = (Integer) session.getAttribute("teacherId");
            if (teacherId == null) {
                return "redirect:/login";
            }

            appointment.setTeacherId(teacherId);
            appointment.setCreatedBy(teacherId);
            appointment.setStatus("Scheduled");

            appointmentDAO.createAppointment(appointment);
            return "redirect:/teacher/appointments";
        } catch (SQLException e) {
            return "redirect:/teacher/appointments?error=" + e.getMessage();
        }
    }

    @PostMapping("/appointments/{id}/status")
    public String updateAppointmentStatus(@PathVariable int id, @RequestParam String status) {
        try {
            appointmentDAO.updateAppointmentStatus(id, status);
            return "redirect:/teacher/appointments";
        } catch (SQLException e) {
            return "redirect:/teacher/appointments?error=" + e.getMessage();
        }
    }
} 