package com.sms.dao;

import com.sms.model.Course;
import java.util.List;

public interface CourseDAO {
    
    /**
     * Create a new course
     * @param course Course object to be created
     * @return id of the created course
     */
    int createCourse(Course course);
    
    /**
     * Get a course by id
     * @param id Course id
     * @return Course object if found, null otherwise
     */
    Course getCourseById(int id);
    
    /**
     * Get all courses
     * @return List of all courses
     */
    List<Course> getAllCourses();
    
    /**
     * Get courses assigned to a specific teacher
     * @param teacherId Teacher id
     * @return List of courses for the teacher
     */
    List<Course> getCoursesByTeacherId(int teacherId);
    
    /**
     * Update course information
     * @param course Course object with updated information
     * @return true if successful, false otherwise
     */
    boolean updateCourse(Course course);
    
    /**
     * Delete a course
     * @param courseId Course id to delete
     * @return true if successful, false otherwise
     */
    boolean deleteCourse(int courseId);
} 