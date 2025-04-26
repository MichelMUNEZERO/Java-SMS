package com.sms.dao;

import com.sms.model.CourseMaterial;
import java.util.List;

/**
 * Data Access Object interface for Course Material related operations
 */
public interface CourseMaterialDAO {
    
    /**
     * Create a new course material
     * @param material CourseMaterial object to be created
     * @return true if successful, false otherwise
     */
    boolean createCourseMaterial(CourseMaterial material);
    
    /**
     * Get a course material by id
     * @param materialId Material id
     * @return CourseMaterial object if found, null otherwise
     */
    CourseMaterial getCourseMaterialById(int materialId);
    
    /**
     * Get all materials for a specific course
     * @param courseId Course id
     * @return List of course materials for the course
     */
    List<CourseMaterial> getMaterialsByCourseId(int courseId);
    
    /**
     * Get materials uploaded by a specific user
     * @param uploadedBy User id who uploaded the materials
     * @return List of materials uploaded by the user
     */
    List<CourseMaterial> getMaterialsByUploadedBy(int uploadedBy);
    
    /**
     * Update course material information
     * @param material CourseMaterial object with updated information
     * @return true if successful, false otherwise
     */
    boolean updateCourseMaterial(CourseMaterial material);
    
    /**
     * Delete a course material
     * @param materialId Material id to delete
     * @return true if successful, false otherwise
     */
    boolean deleteCourseMaterial(int materialId);
} 