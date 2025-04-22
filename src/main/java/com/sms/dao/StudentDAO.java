package com.sms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.sms.model.Student;
import com.sms.util.DBConnection;

/**
 * Data Access Object for Student entity
 */
public class StudentDAO {
    
    private Connection connection;

    public StudentDAO() {
        try {
            connection = DBConnection.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Get a student by ID
     * @param studentId the student ID to search for
     * @return the Student object if found, null otherwise
     */
    public Student getStudentById(int studentId) {
        Student student = null;
        String sql = "SELECT * FROM students WHERE student_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                student = extractStudentFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return student;
    }
    
    /**
     * Get a student by registration number
     * @param regNumber the registration number to search for
     * @return the Student object if found, null otherwise
     */
    public Student getStudentByRegNumber(String regNumber) {
        Student student = null;
        String sql = "SELECT * FROM students WHERE reg_number = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, regNumber);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                student = extractStudentFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return student;
    }
    
    /**
     * Get a student by email
     * @param email the email to search for
     * @return the Student object if found, null otherwise
     */
    public Student getStudentByEmail(String email) {
        Student student = null;
        String sql = "SELECT * FROM students WHERE email = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                student = extractStudentFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return student;
    }
    
    /**
     * Get all students from the database
     * @return a list of all students
     */
    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                students.add(extractStudentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return students;
    }
    
    /**
     * Get all students of a parent
     * @param parentId the parent ID to search for
     * @return a list of students of the parent
     */
    public List<Student> getStudentsByParentId(int parentId) {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students WHERE parent_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, parentId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                students.add(extractStudentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return students;
    }
    
    /**
     * Add a new student to the database
     * @param student the student to add
     * @return true if the addition was successful, false otherwise
     */
    public boolean addStudent(Student student) {
        String sql = "INSERT INTO students (user_id, first_name, last_name, email, reg_number, gender, date_of_birth, grade_class, parent_id, phone, address, medical_info, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, student.getUserId());
            stmt.setString(2, student.getFirstName());
            stmt.setString(3, student.getLastName());
            stmt.setString(4, student.getEmail());
            stmt.setString(5, student.getRegNumber());
            stmt.setString(6, student.getGender());
            stmt.setDate(7, student.getDateOfBirth());
            stmt.setString(8, student.getGradeClass());
            stmt.setInt(9, student.getParentId());
            stmt.setString(10, student.getPhone());
            stmt.setString(11, student.getAddress());
            stmt.setString(12, student.getMedicalInfo());
            stmt.setString(13, student.getStatus());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update an existing student in the database
     * @param student the student to update
     * @return true if the update was successful, false otherwise
     */
    public boolean updateStudent(Student student) {
        String sql = "UPDATE students SET user_id = ?, first_name = ?, last_name = ?, email = ?, reg_number = ?, gender = ?, date_of_birth = ?, grade_class = ?, parent_id = ?, phone = ?, address = ?, medical_info = ?, status = ? WHERE student_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, student.getUserId());
            stmt.setString(2, student.getFirstName());
            stmt.setString(3, student.getLastName());
            stmt.setString(4, student.getEmail());
            stmt.setString(5, student.getRegNumber());
            stmt.setString(6, student.getGender());
            stmt.setDate(7, student.getDateOfBirth());
            stmt.setString(8, student.getGradeClass());
            stmt.setInt(9, student.getParentId());
            stmt.setString(10, student.getPhone());
            stmt.setString(11, student.getAddress());
            stmt.setString(12, student.getMedicalInfo());
            stmt.setString(13, student.getStatus());
            stmt.setInt(14, student.getStudentId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete a student from the database
     * @param studentId the ID of the student to delete
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteStudent(int studentId) {
        String sql = "DELETE FROM students WHERE student_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Map a Student object from a ResultSet
     * @param rs the ResultSet containing student data
     * @return a populated Student object
     * @throws SQLException if a database access error occurs
     */
    private Student extractStudentFromResultSet(ResultSet rs) throws SQLException {
        Student student = new Student();
        student.setStudentId(rs.getInt("student_id"));
        student.setUserId(rs.getInt("user_id"));
        student.setFirstName(rs.getString("first_name"));
        student.setLastName(rs.getString("last_name"));
        student.setEmail(rs.getString("email"));
        student.setRegNumber(rs.getString("reg_number"));
        student.setGender(rs.getString("gender"));
        student.setDateOfBirth(rs.getDate("date_of_birth"));
        student.setGradeClass(rs.getString("grade_class"));
        student.setParentId(rs.getInt("parent_id"));
        student.setPhone(rs.getString("phone"));
        student.setAddress(rs.getString("address"));
        student.setMedicalInfo(rs.getString("medical_info"));
        student.setStatus(rs.getString("status"));
        return student;
    }
    
    /**
     * Search for students based on a search term
     * @param searchTerm the term to search for
     * @return a list of students matching the search term
     */
    public List<Student> searchStudents(String searchTerm) {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students WHERE first_name LIKE ? OR last_name LIKE ? OR reg_number LIKE ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            String searchPattern = "%" + searchTerm + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                students.add(extractStudentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return students;
    }
    
    /**
     * Get students by grade
     * @param grade the grade to search for
     * @return a list of students with the specified grade
     */
    public List<Student> getStudentsByGrade(String grade) {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students WHERE grade_class = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, grade);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                students.add(extractStudentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return students;
    }
    
    /**
     * Get students by status
     * @param status the status to search for
     * @return a list of students with the specified status
     */
    public List<Student> getStudentsByStatus(String status) {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students WHERE status = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                students.add(extractStudentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return students;
    }
    
    /**
     * Get students by course ID
     * @param courseId the course ID to search for
     * @return a list of students enrolled in the course
     */
    public List<Student> getStudentsByCourseId(int courseId) {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT s.* FROM students s " +
                     "JOIN student_courses sc ON s.student_id = sc.student_id " +
                     "WHERE sc.course_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                students.add(extractStudentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return students;
    }
    
    /**
     * Get students by teacher ID
     * @param teacherId the teacher ID to search for
     * @return a list of students taught by the teacher
     */
    public List<Student> getStudentsByTeacherId(int teacherId) {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT DISTINCT s.* FROM students s " +
                     "JOIN student_courses sc ON s.student_id = sc.student_id " +
                     "JOIN courses c ON sc.course_id = c.course_id " +
                     "WHERE c.teacher_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, teacherId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                students.add(extractStudentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return students;
    }
} 