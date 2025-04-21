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
    
    /**
     * Get a student by ID
     * @param studentId the student ID to search for
     * @return the Student object if found, null otherwise
     */
    public Student getStudentById(int studentId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Student student = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Students WHERE StudentID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, studentId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                student = mapStudentFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, rs);
        }
        
        return student;
    }
    
    /**
     * Get a student by registration number
     * @param regNumber the registration number to search for
     * @return the Student object if found, null otherwise
     */
    public Student getStudentByRegNumber(String regNumber) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Student student = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Students WHERE RegNumber = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, regNumber);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                student = mapStudentFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, rs);
        }
        
        return student;
    }
    
    /**
     * Get a student by email
     * @param email the email to search for
     * @return the Student object if found, null otherwise
     */
    public Student getStudentByEmail(String email) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Student student = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Students WHERE Email = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                student = mapStudentFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, rs);
        }
        
        return student;
    }
    
    /**
     * Get all students from the database
     * @return a list of all students
     */
    public List<Student> getAllStudents() {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        List<Student> students = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Students";
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                Student student = mapStudentFromResultSet(rs);
                students.add(student);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, rs);
        }
        
        return students;
    }
    
    /**
     * Get all students of a parent
     * @param parentId the parent ID to search for
     * @return a list of students of the parent
     */
    public List<Student> getStudentsByParentId(int parentId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Student> students = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT s.* FROM Students s JOIN StudentParent sp ON s.StudentID = sp.StudentID " +
                         "WHERE sp.ParentId = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, parentId);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Student student = mapStudentFromResultSet(rs);
                students.add(student);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, rs);
        }
        
        return students;
    }
    
    /**
     * Add a new student to the database
     * @param student the student to add
     * @return the ID of the newly added student, or -1 if addition failed
     */
    public int addStudent(Student student) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int studentId = -1;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO Students (FirstName, LastName, RegNumber, Telephone, Email, Address) " +
                         "VALUES (?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, student.getFirstName());
            stmt.setString(2, student.getLastName());
            stmt.setString(3, student.getRegNumber());
            stmt.setString(4, student.getTelephone());
            stmt.setString(5, student.getEmail());
            stmt.setString(6, student.getAddress());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    studentId = rs.getInt(1);
                    student.setStudentId(studentId);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, rs);
        }
        
        return studentId;
    }
    
    /**
     * Update an existing student in the database
     * @param student the student to update
     * @return true if the update was successful, false otherwise
     */
    public boolean updateStudent(Student student) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE Students SET FirstName = ?, LastName = ?, RegNumber = ?, " +
                         "Telephone = ?, Email = ?, Address = ? WHERE StudentID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, student.getFirstName());
            stmt.setString(2, student.getLastName());
            stmt.setString(3, student.getRegNumber());
            stmt.setString(4, student.getTelephone());
            stmt.setString(5, student.getEmail());
            stmt.setString(6, student.getAddress());
            stmt.setInt(7, student.getStudentId());
            
            int affectedRows = stmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, null);
        }
        
        return success;
    }
    
    /**
     * Delete a student from the database
     * @param studentId the ID of the student to delete
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteStudent(int studentId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM Students WHERE StudentID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, studentId);
            
            int affectedRows = stmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, null);
        }
        
        return success;
    }
    
    /**
     * Map a Student object from a ResultSet
     * @param rs the ResultSet containing student data
     * @return a populated Student object
     * @throws SQLException if a database access error occurs
     */
    private Student mapStudentFromResultSet(ResultSet rs) throws SQLException {
        Student student = new Student();
        student.setStudentId(rs.getInt("StudentID"));
        student.setFirstName(rs.getString("FirstName"));
        student.setLastName(rs.getString("LastName"));
        student.setRegNumber(rs.getString("RegNumber"));
        student.setTelephone(rs.getString("Telephone"));
        student.setEmail(rs.getString("Email"));
        student.setAddress(rs.getString("Address"));
        return student;
    }
    
    /**
     * Close database resources
     * @param conn the Connection object
     * @param stmt the Statement object
     * @param rs the ResultSet object
     */
    private void closeResources(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (stmt != null) {
                stmt.close();
            }
            // We don't close the connection here because we're using a connection pool
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
} 