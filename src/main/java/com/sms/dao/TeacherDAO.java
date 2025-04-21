package com.sms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.sms.model.Teacher;
import com.sms.util.DBConnection;

/**
 * Data Access Object for Teacher entity
 */
public class TeacherDAO {
    
    /**
     * Get a teacher by ID
     * @param teacherId the teacher ID to search for
     * @return the Teacher object if found, null otherwise
     */
    public Teacher getTeacherById(int teacherId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Teacher teacher = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Teachers WHERE TeacherId = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, teacherId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                teacher = mapTeacherFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, rs);
        }
        
        return teacher;
    }
    
    /**
     * Get a teacher by email
     * @param email the email to search for
     * @return the Teacher object if found, null otherwise
     */
    public Teacher getTeacherByEmail(String email) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Teacher teacher = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Teachers WHERE Email = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                teacher = mapTeacherFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, rs);
        }
        
        return teacher;
    }
    
    /**
     * Get all teachers from the database
     * @return a list of all teachers
     */
    public List<Teacher> getAllTeachers() {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        List<Teacher> teachers = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Teachers";
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                Teacher teacher = mapTeacherFromResultSet(rs);
                teachers.add(teacher);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, rs);
        }
        
        return teachers;
    }
    
    /**
     * Get teachers by course ID
     * @param courseId the course ID to search for
     * @return a list of teachers assigned to the course
     */
    public List<Teacher> getTeachersByCourseId(int courseId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Teacher> teachers = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Teachers WHERE CourseId = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, courseId);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Teacher teacher = mapTeacherFromResultSet(rs);
                teachers.add(teacher);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, rs);
        }
        
        return teachers;
    }
    
    /**
     * Add a new teacher to the database
     * @param teacher the teacher to add
     * @return the ID of the newly added teacher, or -1 if addition failed
     */
    public int addTeacher(Teacher teacher) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int teacherId = -1;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO Teachers (FirstName, LastName, CourseId, Qualification, Experience, Email, Telephone) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, teacher.getFirstName());
            stmt.setString(2, teacher.getLastName());
            stmt.setInt(3, teacher.getCourseId());
            stmt.setString(4, teacher.getQualification());
            stmt.setInt(5, teacher.getExperience());
            stmt.setString(6, teacher.getEmail());
            stmt.setString(7, teacher.getTelephone());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    teacherId = rs.getInt(1);
                    teacher.setTeacherId(teacherId);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(null, stmt, rs);
        }
        
        return teacherId;
    }
    
    /**
     * Update an existing teacher in the database
     * @param teacher the teacher to update
     * @return true if the update was successful, false otherwise
     */
    public boolean updateTeacher(Teacher teacher) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE Teachers SET FirstName = ?, LastName = ?, CourseId = ?, " +
                         "Qualification = ?, Experience = ?, Email = ?, Telephone = ? " +
                         "WHERE TeacherId = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, teacher.getFirstName());
            stmt.setString(2, teacher.getLastName());
            stmt.setInt(3, teacher.getCourseId());
            stmt.setString(4, teacher.getQualification());
            stmt.setInt(5, teacher.getExperience());
            stmt.setString(6, teacher.getEmail());
            stmt.setString(7, teacher.getTelephone());
            stmt.setInt(8, teacher.getTeacherId());
            
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
     * Delete a teacher from the database
     * @param teacherId the ID of the teacher to delete
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteTeacher(int teacherId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM Teachers WHERE TeacherId = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, teacherId);
            
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
     * Map a Teacher object from a ResultSet
     * @param rs the ResultSet containing teacher data
     * @return a populated Teacher object
     * @throws SQLException if a database access error occurs
     */
    private Teacher mapTeacherFromResultSet(ResultSet rs) throws SQLException {
        Teacher teacher = new Teacher();
        teacher.setTeacherId(rs.getInt("TeacherId"));
        teacher.setFirstName(rs.getString("FirstName"));
        teacher.setLastName(rs.getString("LastName"));
        teacher.setCourseId(rs.getInt("CourseId"));
        teacher.setQualification(rs.getString("Qualification"));
        teacher.setExperience(rs.getInt("Experience"));
        teacher.setEmail(rs.getString("Email"));
        teacher.setTelephone(rs.getString("Telephone"));
        return teacher;
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