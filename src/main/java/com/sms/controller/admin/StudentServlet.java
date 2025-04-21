package com.sms.controller.admin;

import com.sms.dao.StudentDAO;
import com.sms.dao.ParentDAO;
import com.sms.dao.UserDAO;
import com.sms.model.Student;
import com.sms.model.User;
import com.sms.util.PasswordHash;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/admin/student")
public class StudentServlet extends HttpServlet {
    private StudentDAO studentDAO;
    private ParentDAO parentDAO;
    private UserDAO userDAO;
    private PasswordHash passwordHash;

    public void init() {
        studentDAO = new StudentDAO();
        parentDAO = new ParentDAO();
        userDAO = new UserDAO();
        passwordHash = new PasswordHash();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listStudents(request, response);
                break;
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "view":
                viewStudent(request, response);
                break;
            case "delete":
                deleteStudent(request, response);
                break;
            default:
                listStudents(request, response);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "add":
                addStudent(request, response);
                break;
            case "update":
                updateStudent(request, response);
                break;
            default:
                listStudents(request, response);
                break;
        }
    }

    private void listStudents(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get search parameters
        String searchName = request.getParameter("searchName");
        String grade = request.getParameter("grade");
        String status = request.getParameter("status");
        
        List<Student> students;
        
        // Apply filters if provided
        if (searchName != null && !searchName.isEmpty()) {
            students = studentDAO.searchStudents(searchName);
        } else if (grade != null && !grade.isEmpty()) {
            students = studentDAO.getStudentsByGrade(grade);
        } else if (status != null && !status.isEmpty()) {
            students = studentDAO.getStudentsByStatus(status);
        } else {
            students = studentDAO.getAllStudents();
        }
        
        request.setAttribute("students", students);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/students.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Load parents for dropdown
        request.setAttribute("parents", parentDAO.getAllParents());
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/student-form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int studentId = Integer.parseInt(request.getParameter("id"));
            Student student = studentDAO.getStudentById(studentId);
            
            if (student == null) {
                response.sendRedirect(request.getContextPath() + "/admin/student?error=studentNotFound");
                return;
            }
            
            request.setAttribute("student", student);
            request.setAttribute("parents", parentDAO.getAllParents());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/student-form.jsp");
            dispatcher.forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/student?error=invalidId");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/student?error=databaseError");
        }
    }

    private void viewStudent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int studentId = Integer.parseInt(request.getParameter("id"));
            Student student = studentDAO.getStudentById(studentId);
            
            if (student == null) {
                response.sendRedirect(request.getContextPath() + "/admin/student?error=studentNotFound");
                return;
            }
            
            request.setAttribute("student", student);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/student-view.jsp");
            dispatcher.forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/student?error=invalidId");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/student?error=databaseError");
        }
    }

    private void addStudent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Extract form data
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String regNumber = request.getParameter("regNumber");
        String gender = request.getParameter("gender");
        String dobStr = request.getParameter("dob");
        String gradeClass = request.getParameter("gradeClass");
        int parentId = Integer.parseInt(request.getParameter("parentId"));
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String medicalInfo = request.getParameter("medicalInfo");
        String status = request.getParameter("status");
        
        // Basic validation
        if (firstName == null || lastName == null || email == null || regNumber == null || 
            firstName.isEmpty() || lastName.isEmpty() || email.isEmpty() || regNumber.isEmpty()) {
            request.setAttribute("error", "All required fields must be filled out");
            request.setAttribute("parents", parentDAO.getAllParents());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/student-form.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        try {
            // Check if email already exists
            if (userDAO.getUserByEmail(email) != null) {
                request.setAttribute("error", "Email already exists");
                request.setAttribute("parents", parentDAO.getAllParents());
                RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/student-form.jsp");
                dispatcher.forward(request, response);
                return;
            }
            
            // Create User account first
            User user = new User();
            user.setEmail(email);
            user.setFirstName(firstName);
            user.setLastName(lastName);
            // Generate a default password (could be student ID or registration number)
            String defaultPassword = regNumber;
            user.setPassword(passwordHash.hashPassword(defaultPassword));
            user.setRole("student");
            user.setStatus(status);
            
            int userId = userDAO.addUser(user);
            
            if (userId > 0) {
                // Create Student record
                Student student = new Student();
                student.setUserId(userId);
                student.setFirstName(firstName);
                student.setLastName(lastName);
                student.setEmail(email);
                student.setRegNumber(regNumber);
                student.setGender(gender);
                if (dobStr != null && !dobStr.isEmpty()) {
                    student.setDateOfBirth(Date.valueOf(dobStr));
                }
                student.setGradeClass(gradeClass);
                student.setParentId(parentId);
                student.setPhone(phone);
                student.setAddress(address);
                student.setMedicalInfo(medicalInfo);
                student.setStatus(status);
                
                boolean success = studentDAO.addStudent(student);
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/student?success=added");
                } else {
                    // If student creation fails, delete the user
                    userDAO.deleteUser(userId);
                    request.setAttribute("error", "Failed to add student");
                    request.setAttribute("parents", parentDAO.getAllParents());
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/student-form.jsp");
                    dispatcher.forward(request, response);
                }
            } else {
                request.setAttribute("error", "Failed to create user account");
                request.setAttribute("parents", parentDAO.getAllParents());
                RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/student-form.jsp");
                dispatcher.forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            request.setAttribute("parents", parentDAO.getAllParents());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/student-form.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void updateStudent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            int userId = Integer.parseInt(request.getParameter("userId"));
            
            Student existingStudent = studentDAO.getStudentById(studentId);
            if (existingStudent == null) {
                response.sendRedirect(request.getContextPath() + "/admin/student?error=studentNotFound");
                return;
            }
            
            // Extract form data
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String regNumber = request.getParameter("regNumber");
            String gender = request.getParameter("gender");
            String dobStr = request.getParameter("dob");
            String gradeClass = request.getParameter("gradeClass");
            int parentId = Integer.parseInt(request.getParameter("parentId"));
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String medicalInfo = request.getParameter("medicalInfo");
            String status = request.getParameter("status");
            
            // Basic validation
            if (firstName == null || lastName == null || email == null || regNumber == null || 
                firstName.isEmpty() || lastName.isEmpty() || email.isEmpty() || regNumber.isEmpty()) {
                request.setAttribute("error", "All required fields must be filled out");
                request.setAttribute("student", existingStudent);
                request.setAttribute("parents", parentDAO.getAllParents());
                RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/student-form.jsp");
                dispatcher.forward(request, response);
                return;
            }
            
            // Check if email already exists and belongs to a different user
            User userWithEmail = userDAO.getUserByEmail(email);
            if (userWithEmail != null && userWithEmail.getUserId() != userId) {
                request.setAttribute("error", "Email already in use by another user");
                request.setAttribute("student", existingStudent);
                request.setAttribute("parents", parentDAO.getAllParents());
                RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/student-form.jsp");
                dispatcher.forward(request, response);
                return;
            }
            
            // Update user record
            User user = userDAO.getUserById(userId);
            user.setEmail(email);
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setStatus(status);
            userDAO.updateUser(user);
            
            // Update student record
            Student student = new Student();
            student.setStudentId(studentId);
            student.setUserId(userId);
            student.setFirstName(firstName);
            student.setLastName(lastName);
            student.setEmail(email);
            student.setRegNumber(regNumber);
            student.setGender(gender);
            if (dobStr != null && !dobStr.isEmpty()) {
                student.setDateOfBirth(Date.valueOf(dobStr));
            }
            student.setGradeClass(gradeClass);
            student.setParentId(parentId);
            student.setPhone(phone);
            student.setAddress(address);
            student.setMedicalInfo(medicalInfo);
            student.setStatus(status);
            
            boolean success = studentDAO.updateStudent(student);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/student?success=updated");
            } else {
                request.setAttribute("error", "Failed to update student");
                request.setAttribute("student", existingStudent);
                request.setAttribute("parents", parentDAO.getAllParents());
                RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/student-form.jsp");
                dispatcher.forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/student?error=invalidId");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/student?error=databaseError&message=" + e.getMessage());
        }
    }

    private void deleteStudent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int studentId = Integer.parseInt(request.getParameter("id"));
            Student student = studentDAO.getStudentById(studentId);
            
            if (student == null) {
                response.sendRedirect(request.getContextPath() + "/admin/student?error=studentNotFound");
                return;
            }
            
            // Delete student record
            boolean success = studentDAO.deleteStudent(studentId);
            
            if (success) {
                // Also delete the associated user
                userDAO.deleteUser(student.getUserId());
                response.sendRedirect(request.getContextPath() + "/admin/student?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/student?error=deleteFailed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/student?error=invalidId");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/student?error=databaseError");
        }
    }
} 