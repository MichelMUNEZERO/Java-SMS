package com.sms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.sms.model.Student;
import com.sms.util.DBConnection;

/**
 * Data Access Object for Student-related database operations
 */
public class StudentDAO {
    private static final Logger LOGGER = Logger.getLogger(StudentDAO.class.getName());
    
    /**
     * Get all students from the database
     * @return List of Student objects
     */
    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM students";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("student_id"));
                student.setFirstName(rs.getString("first_name"));
                student.setLastName(rs.getString("last_name"));
                student.setEmail(rs.getString("email"));
                student.setPhone(rs.getString("phone"));
                student.setAddress(rs.getString("address"));
                student.setDateOfBirth(rs.getDate("date_of_birth"));
                student.setAdmissionDate(rs.getDate("admission_date"));
                // Set classId based on grade field from the database
                String grade = rs.getString("grade");
                if (grade != null) {
                    student.setClassId(0); // Set a default value
                    student.setClassName(grade); // Use grade as the class name
                }
                student.setStatus("active"); // Set a default status
                
                students.add(student);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all students", e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return students;
    }
    
    /**
     * Get a student by ID
     * @param id Student ID
     * @return Student object if found, null otherwise
     */
    public Student getStudentById(int id) {
        Student student = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM students WHERE student_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                student = new Student();
                student.setId(rs.getInt("student_id"));
                student.setFirstName(rs.getString("first_name"));
                student.setLastName(rs.getString("last_name"));
                student.setEmail(rs.getString("email"));
                student.setPhone(rs.getString("phone"));
                student.setAddress(rs.getString("address"));
                student.setDateOfBirth(rs.getDate("date_of_birth"));
                student.setAdmissionDate(rs.getDate("admission_date"));
                // Set classId based on grade field from the database
                String grade = rs.getString("grade");
                if (grade != null) {
                    student.setClassId(0); // Set a default value
                    student.setClassName(grade); // Use grade as the class name
                }
                student.setStatus("active"); // Set a default status
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting student with ID: " + id, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return student;
    }
    
    /**
     * Add a new student to the database
     * @param student Student object with data to insert
     * @return true if insertion was successful, false otherwise
     */
    public boolean addStudent(Student student) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO students (first_name, last_name, email, phone, address, date_of_birth, admission_date, grade, reg_number) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, student.getFirstName());
            pstmt.setString(2, student.getLastName());
            pstmt.setString(3, student.getEmail());
            pstmt.setString(4, student.getPhone());
            pstmt.setString(5, student.getAddress());
            pstmt.setDate(6, new java.sql.Date(student.getDateOfBirth().getTime()));
            pstmt.setDate(7, new java.sql.Date(student.getAdmissionDate().getTime()));
            pstmt.setString(8, student.getClassName()); // Use className as grade
            
            // Generate a registration number if not provided
            String regNumber = "STU" + System.currentTimeMillis();
            pstmt.setString(9, regNumber);
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding student", e);
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return success;
    }
    
    /**
     * Update an existing student's information
     * @param student Student object with updated data
     * @return true if update was successful, false otherwise
     */
    public boolean updateStudent(Student student) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE students SET first_name = ?, last_name = ?, email = ?, phone = ?, " +
                         "address = ?, date_of_birth = ?, admission_date = ?, grade = ? " +
                         "WHERE student_id = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, student.getFirstName());
            pstmt.setString(2, student.getLastName());
            pstmt.setString(3, student.getEmail());
            pstmt.setString(4, student.getPhone());
            pstmt.setString(5, student.getAddress());
            pstmt.setDate(6, new java.sql.Date(student.getDateOfBirth().getTime()));
            pstmt.setDate(7, new java.sql.Date(student.getAdmissionDate().getTime()));
            pstmt.setString(8, student.getClassName()); // Use className as grade
            pstmt.setInt(9, student.getId());
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating student with ID: " + student.getId(), e);
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return success;
    }
    
    /**
     * Delete a student by ID
     * @param id The ID of the student to delete
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteStudent(int id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM students WHERE student_id = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting student with ID: " + id, e);
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return success;
    }
    
    /**
     * Get students by class ID
     * @param classId The class ID to search for
     * @return List of Student objects in the specified class
     */
    public List<Student> getStudentsByClass(int classId) {
        List<Student> students = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            // Since we don't have a classes table, we can filter by grade
            // For this implementation, we'll assume grade value corresponds to classId
            String sql = "SELECT * FROM students WHERE grade = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, String.valueOf(classId)); // Convert classId to string to match grade
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("student_id"));
                student.setFirstName(rs.getString("first_name"));
                student.setLastName(rs.getString("last_name"));
                student.setEmail(rs.getString("email"));
                student.setPhone(rs.getString("phone"));
                student.setAddress(rs.getString("address"));
                student.setDateOfBirth(rs.getDate("date_of_birth"));
                student.setAdmissionDate(rs.getDate("admission_date"));
                // Set classId and className based on grade
                String grade = rs.getString("grade");
                if (grade != null) {
                    student.setClassId(classId);
                    student.setClassName(grade);
                }
                student.setStatus("active"); // Set a default status
                
                students.add(student);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting students by class ID: " + classId, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return students;
    }
    
    /**
     * Gets all students that can be enrolled in courses
     * 
     * @return List of students with basic information
     */
    public List<Map<String, Object>> getAllStudentsForEnrollment() {
        List<Map<String, Object>> students = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            LOGGER.info("Getting all students for enrollment");
            conn = DBConnection.getConnection();
            
            String sql = "SELECT student_id, first_name, last_name, email FROM students WHERE status = 'Active' ORDER BY last_name, first_name";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> student = new HashMap<>();
                student.put("studentId", rs.getInt("student_id"));
                student.put("firstName", rs.getString("first_name"));
                student.put("lastName", rs.getString("last_name"));
                student.put("email", rs.getString("email"));
                student.put("fullName", rs.getString("first_name") + " " + rs.getString("last_name"));
                students.add(student);
            }
            
            LOGGER.info("Found " + students.size() + " students for enrollment");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting students for enrollment", e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return students;
    }

    /**
     * Get all students for a specific teacher
     * 
     * @param teacherId The teacher ID
     * @return List of students enrolled in this teacher's courses
     */
    public List<Student> getStudentsByTeacherId(int teacherId) {
        List<Student> students = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT DISTINCT s.* FROM students s " +
                         "JOIN student_courses sc ON s.student_id = sc.student_id " +
                         "JOIN courses c ON sc.course_id = c.course_id " +
                         "WHERE c.teacher_id = ? " +
                         "ORDER BY s.last_name, s.first_name";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, teacherId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Student student = mapResultSetToStudent(rs);
                students.add(student);
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving students for teacher ID: " + teacherId);
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return students;
    }

    /**
     * Get all available students for enrollment
     * (students not already enrolled in a specific course could be shown here)
     * 
     * @return List of all active students
     */
    public List<Student> getAllAvailableStudents() {
        List<Student> students = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM students WHERE status = 'active' ORDER BY last_name, first_name";
            
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Student student = mapResultSetToStudent(rs);
                students.add(student);
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving all available students");
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return students;
    }

    /**
     * Helper method to close database resources
     */
    private void closeResources(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Map database result set to a Student object
     */
    private Student mapResultSetToStudent(ResultSet rs) throws SQLException {
        Student student = new Student();
        student.setId(rs.getInt("student_id"));
        student.setFirstName(rs.getString("first_name"));
        student.setLastName(rs.getString("last_name"));
        student.setEmail(rs.getString("email"));
        student.setPhone(rs.getString("phone"));
        student.setAddress(rs.getString("address"));
        student.setGender(rs.getString("gender"));
        student.setDateOfBirth(rs.getDate("date_of_birth"));
        student.setAdmissionDate(rs.getDate("admission_date"));
        student.setClassId(rs.getInt("class_id"));
        
        // Optional fields (may be null)
        try {
            student.setClassName(rs.getString("class_name"));
        } catch (SQLException e) {
            // Column not available, ignore
        }
        
        try {
            student.setGuardianName(rs.getString("guardian_name"));
            student.setGuardianPhone(rs.getString("guardian_phone"));
            student.setGuardianEmail(rs.getString("guardian_email"));
        } catch (SQLException e) {
            // Columns not available, ignore
        }
        
        student.setStatus(rs.getString("status"));
        
        return student;
    }
}