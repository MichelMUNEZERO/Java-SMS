package com.sms.dao.impl;

import com.sms.dao.CourseMaterialDAO;
import com.sms.model.CourseMaterial;
import com.sms.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CourseMaterialDAOImpl implements CourseMaterialDAO {
    
    private static final Logger LOGGER = Logger.getLogger(CourseMaterialDAOImpl.class.getName());
    
    @Override
    public boolean createCourseMaterial(CourseMaterial material) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO course_materials (course_id, title, description, file_url, file_type, uploaded_by, upload_date) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, material.getCourseId());
            pstmt.setString(2, material.getTitle());
            pstmt.setString(3, material.getDescription());
            pstmt.setString(4, material.getFileUrl());
            pstmt.setString(5, material.getFileType());
            pstmt.setInt(6, material.getUploadedBy());
            pstmt.setTimestamp(7, material.getUploadDate() != null ? material.getUploadDate() : new Timestamp(System.currentTimeMillis()));
            
            int rowsAffected = pstmt.executeUpdate();
            success = rowsAffected > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating course material", e);
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
    
    @Override
    public CourseMaterial getCourseMaterialById(int materialId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        CourseMaterial material = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM course_materials WHERE id = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, materialId);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                material = extractCourseMaterialFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving course material with ID: " + materialId, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return material;
    }
    
    @Override
    public List<CourseMaterial> getMaterialsByCourseId(int courseId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<CourseMaterial> materials = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM course_materials WHERE course_id = ? ORDER BY upload_date DESC";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, courseId);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                materials.add(extractCourseMaterialFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving course materials for course ID: " + courseId, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return materials;
    }
    
    @Override
    public List<CourseMaterial> getMaterialsByUploadedBy(int uploadedBy) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<CourseMaterial> materials = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM course_materials WHERE uploaded_by = ? ORDER BY upload_date DESC";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, uploadedBy);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                materials.add(extractCourseMaterialFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving course materials uploaded by user ID: " + uploadedBy, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return materials;
    }
    
    @Override
    public boolean updateCourseMaterial(CourseMaterial material) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE course_materials SET course_id = ?, title = ?, description = ?, " +
                         "file_url = ?, file_type = ?, uploaded_by = ?, upload_date = ? WHERE id = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, material.getCourseId());
            pstmt.setString(2, material.getTitle());
            pstmt.setString(3, material.getDescription());
            pstmt.setString(4, material.getFileUrl());
            pstmt.setString(5, material.getFileType());
            pstmt.setInt(6, material.getUploadedBy());
            pstmt.setTimestamp(7, material.getUploadDate() != null ? material.getUploadDate() : new Timestamp(System.currentTimeMillis()));
            pstmt.setInt(8, material.getId());
            
            int rowsAffected = pstmt.executeUpdate();
            success = rowsAffected > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating course material with ID: " + material.getId(), e);
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
    
    @Override
    public boolean deleteCourseMaterial(int materialId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM course_materials WHERE id = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, materialId);
            
            int rowsAffected = pstmt.executeUpdate();
            success = rowsAffected > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting course material with ID: " + materialId, e);
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
    
    private CourseMaterial extractCourseMaterialFromResultSet(ResultSet rs) throws SQLException {
        CourseMaterial material = new CourseMaterial();
        material.setId(rs.getInt("id"));
        material.setCourseId(rs.getInt("course_id"));
        material.setTitle(rs.getString("title"));
        material.setDescription(rs.getString("description"));
        material.setFileUrl(rs.getString("file_url"));
        material.setFileType(rs.getString("file_type"));
        material.setUploadedBy(rs.getInt("uploaded_by"));
        material.setUploadDate(rs.getTimestamp("upload_date"));
        return material;
    }
} 