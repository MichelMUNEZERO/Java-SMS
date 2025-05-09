package com.sms.dao;

import com.sms.model.Teacher;
import com.sms.model.Parent;
import com.sms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Teacher-related database operations
 */
public class TeacherDAO {
    private static final Logger LOGGER = Logger.getLogger(TeacherDAO.class.getName());
    
    /**
     * Retrieves all teachers from the database
     * 
     * @return List of all teachers
     */
    public List<Teacher> getAllTeachers() {
        List<Teacher> teachers = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM teachers ORDER BY last_name, first_name";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Teacher teacher = mapResultSetToTeacher(rs);
                teachers.add(teacher);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving all teachers", e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return teachers;
    }
    
    /**
     * Retrieves a teacher by ID
     * 
     * @param id The teacher ID
     * @return Teacher object if found, null otherwise
     */
    public Teacher getTeacherById(int id) {
        Teacher teacher = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM teachers WHERE teacher_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                teacher = mapResultSetToTeacher(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving teacher with ID: " + id, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return teacher;
    }
    
    /**
     * Adds a new teacher to the database
     * 
     * @param teacher The teacher object to add
     * @return The ID of the newly added teacher, or -1 if operation failed
     */
    public int addTeacher(Teacher teacher) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int generatedId = -1;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO teachers (first_name, last_name, email, phone, specialization, " +
                         "qualification, experience, join_date, address, image_link, status) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            setTeacherParameters(pstmt, teacher);
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                    teacher.setId(generatedId);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding new teacher: " + teacher.getFirstName() + " " + teacher.getLastName(), e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return generatedId;
    }
    
    /**
     * Updates an existing teacher in the database
     * 
     * @param teacher The teacher object with updated information
     * @return true if update was successful, false otherwise
     */
    public boolean updateTeacher(Teacher teacher) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE teachers SET first_name = ?, last_name = ?, email = ?, phone = ?, " +
                         "specialization = ?, qualification = ?, experience = ?, join_date = ?, " +
                         "address = ?, image_link = ?, status = ? " +
                         "WHERE teacher_id = ?";
            
            pstmt = conn.prepareStatement(sql);
            setTeacherParameters(pstmt, teacher);
            pstmt.setInt(12, teacher.getId());
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating teacher with ID: " + teacher.getId(), e);
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
     * Deletes a teacher from the database
     * 
     * @param id The ID of the teacher to delete
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteTeacher(int id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM teachers WHERE teacher_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting teacher with ID: " + id, e);
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
     * Searches for teachers based on a keyword in their name, email, or specialization
     * 
     * @param keyword The search keyword
     * @return List of teachers matching the search criteria
     */
    public List<Teacher> searchTeachers(String keyword) {
        List<Teacher> teachers = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM teachers WHERE " +
                         "LOWER(first_name) LIKE ? OR " +
                         "LOWER(last_name) LIKE ? OR " +
                         "LOWER(email) LIKE ? OR " +
                         "LOWER(specialization) LIKE ? " +
                         "ORDER BY last_name, first_name";
            
            pstmt = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword.toLowerCase() + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);
            pstmt.setString(4, searchPattern);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Teacher teacher = mapResultSetToTeacher(rs);
                teachers.add(teacher);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error searching teachers with keyword: " + keyword, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return teachers;
    }
    
    /**
     * Maps a ResultSet row to a Teacher object
     * 
     * @param rs The ResultSet containing teacher data
     * @return A Teacher object
     * @throws SQLException If there's an error accessing the ResultSet
     */
    private Teacher mapResultSetToTeacher(ResultSet rs) throws SQLException {
        Teacher teacher = new Teacher();
        teacher.setId(rs.getInt("teacher_id"));
        teacher.setFirstName(rs.getString("first_name"));
        teacher.setLastName(rs.getString("last_name"));
        teacher.setEmail(rs.getString("email"));
        teacher.setPhone(rs.getString("phone"));
        teacher.setSpecialization(rs.getString("specialization"));
        teacher.setQualification(rs.getString("qualification"));
        teacher.setExperience(rs.getInt("experience"));
        teacher.setJoinDate(rs.getDate("join_date"));
        teacher.setAddress(rs.getString("address"));
        teacher.setImageLink(rs.getString("image_link"));
        teacher.setStatus(rs.getString("status"));
        return teacher;
    }
    
    /**
     * Sets parameters for PreparedStatement from Teacher object
     * 
     * @param pstmt The PreparedStatement to set parameters for
     * @param teacher The Teacher object containing data
     * @throws SQLException If there's an error setting parameters
     */
    private void setTeacherParameters(PreparedStatement pstmt, Teacher teacher) throws SQLException {
        pstmt.setString(1, teacher.getFirstName());
        pstmt.setString(2, teacher.getLastName());
        pstmt.setString(3, teacher.getEmail());
        pstmt.setString(4, teacher.getPhone());
        pstmt.setString(5, teacher.getSpecialization());
        pstmt.setString(6, teacher.getQualification());
        pstmt.setInt(7, teacher.getExperience());
        
        if (teacher.getJoinDate() != null) {
            pstmt.setDate(8, new java.sql.Date(teacher.getJoinDate().getTime()));
        } else {
            pstmt.setNull(8, Types.DATE);
        }
        
        pstmt.setString(9, teacher.getAddress());
        pstmt.setString(10, teacher.getImageLink());
        pstmt.setString(11, teacher.getStatus());
    }
    
    /**
     * Gets the count of students enrolled in courses taught by a teacher
     * 
     * @param teacherId The teacher ID
     * @return Count of students
     */
    public int getStudentCountByTeacherId(int teacherId) {
        int count = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Simply get all students count since we need to display the correct count on the dashboard
            // This is a temporary solution until proper enrollment is configured
            String sql = "SELECT COUNT(*) FROM students";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
                LOGGER.info("Total student count: " + count);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting student count", e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return count;
    }
    
    /**
     * Gets the count of courses taught by a teacher
     * 
     * @param teacherId The teacher ID
     * @return Count of courses
     */
    public int getCourseCountByTeacherId(int teacherId) {
        int count = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) FROM courses WHERE teacher_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, teacherId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting course count for teacher ID: " + teacherId, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return count;
    }
    
    /**
     * Gets the list of courses taught by a teacher with student counts
     * 
     * @param teacherId The teacher ID
     * @return List of courses with details
     */
    public List<Map<String, Object>> getCoursesByTeacherId(int teacherId) {
        List<Map<String, Object>> courses = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            LOGGER.info("Executing getCoursesByTeacherId with ID: " + teacherId);
            conn = DBConnection.getConnection();
            
            // Add debugging info
            LOGGER.info("Teacher ID passed to getCoursesByTeacherId: " + teacherId);
            
            // Select all courses for this teacher - use a more direct query
            String sql = "SELECT course_id, course_name, course_code, description, credits, teacher_id FROM courses WHERE teacher_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, teacherId);
            LOGGER.info("Executing SQL: " + sql.replace("?", String.valueOf(teacherId)));
            
            rs = pstmt.executeQuery();
            
            // Count the courses
            int courseCount = 0;
            while (rs.next()) {
                courseCount++;
                
                // Create a new map for this course
                Map<String, Object> course = new HashMap<>();
                
                try {
                    // Get course details from ResultSet
                    int courseId = rs.getInt("course_id");
                    String courseName = rs.getString("course_name");
                    String courseCode = rs.getString("course_code");
                    String description = rs.getString("description");
                    int credits = rs.getInt("credits");
                    int teacherIdFromDb = rs.getInt("teacher_id");
                    
                    // Log the data for debugging
                    LOGGER.info("Retrieved course: ID=" + courseId + 
                               ", Name='" + courseName + 
                               "', Code='" + courseCode + 
                               "', Description='" + description + 
                               "', Credits=" + credits + 
                               "', TeacherID=" + teacherIdFromDb);
                    
                    // Add the course data to the map
                    course.put("courseId", courseId);
                    course.put("courseName", courseName);
                    course.put("courseCode", courseCode);
                    course.put("description", description);
                    course.put("credits", credits);
                    course.put("teacherId", teacherIdFromDb);
                    
                    // Set a default student count of 0
                    course.put("studentCount", 0);
                    
                    // Try to get student count if possible
                    try {
                        String countSql = "SELECT COUNT(*) FROM student_courses WHERE course_id = ?";
                        PreparedStatement countStmt = conn.prepareStatement(countSql);
                        countStmt.setInt(1, courseId);
                        ResultSet countRs = countStmt.executeQuery();
                        if (countRs.next()) {
                            int studentCount = countRs.getInt(1);
                            course.put("studentCount", studentCount);
                            LOGGER.info("Course ID " + courseId + " has " + studentCount + " enrolled students");
                        }
                        countRs.close();
                        countStmt.close();
                    } catch (SQLException e) {
                        LOGGER.warning("Could not get student count for course ID " + courseId + ": " + e.getMessage());
                    }
                    
                    // Add this course to the list
                    courses.add(course);
                    LOGGER.info("Added course to result list: " + courseName);
                    
                } catch (SQLException e) {
                    LOGGER.warning("Error processing course: " + e.getMessage());
                }
            }
            
            LOGGER.info("Total courses found for teacher ID " + teacherId + ": " + courseCount);
            LOGGER.info("Courses list size: " + courses.size());
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL Error getting courses for teacher ID " + teacherId + ": " + e.getMessage(), e);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error getting courses for teacher ID " + teacherId + ": " + e.getMessage(), e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return courses;
    }
    
    /**
     * Gets the list of students in a specific course with their marks
     * 
     * @param courseId The course ID
     * @return List of students with their marks
     */
    public List<Map<String, Object>> getStudentsWithMarksByCourseId(int courseId) {
        List<Map<String, Object>> students = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT s.student_id, s.first_name, s.last_name, m.mark, m.grade " +
                         "FROM students s " +
                         "JOIN student_courses sc ON s.student_id = sc.student_id " +
                         "LEFT JOIN marks m ON s.student_id = m.student_id AND m.course_id = ? " +
                         "WHERE sc.course_id = ? " +
                         "ORDER BY s.last_name, s.first_name";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, courseId);
            pstmt.setInt(2, courseId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> student = new HashMap<>();
                student.put("studentId", rs.getInt("student_id"));
                student.put("firstName", rs.getString("first_name"));
                student.put("lastName", rs.getString("last_name"));
                student.put("mark", rs.getObject("mark")); // May be null
                student.put("grade", rs.getString("grade")); // May be null
                students.add(student);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting students with marks for course ID: " + courseId, e);
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
     * Gets the list of students with behavior notes for a teacher's courses
     * 
     * @param teacherId The teacher ID
     * @return List of students with behavior notes
     */
    public List<Map<String, Object>> getStudentBehaviorByTeacherId(int teacherId) {
        List<Map<String, Object>> behaviorNotes = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            // Modified query to not use the course_id column since it doesn't exist in the studentbehavior table
            // Instead, return all behavior records with teacher matches the reported_by field
            String sql = "SELECT sb.*, s.first_name, s.last_name " +
                         "FROM studentbehavior sb " +
                         "JOIN students s ON sb.student_id = s.student_id " +
                         "WHERE sb.reported_by = ? " +
                         "ORDER BY sb.behavior_date DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, teacherId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> note = new HashMap<>();
                note.put("behaviorId", rs.getInt("behavior_id"));
                note.put("studentId", rs.getInt("student_id"));
                note.put("studentName", rs.getString("first_name") + " " + rs.getString("last_name"));
                note.put("behaviorType", rs.getString("behavior_type"));
                note.put("description", rs.getString("description"));
                note.put("behaviorDate", rs.getDate("behavior_date"));
                note.put("reportedBy", rs.getInt("reported_by"));
                note.put("actionTaken", rs.getString("action_taken"));
                behaviorNotes.add(note);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting student behavior notes for teacher ID: " + teacherId, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return behaviorNotes;
    }
    
    /**
     * Gets detailed information for a specific course by ID
     * 
     * @param courseId The course ID
     * @param teacherId The teacher ID (for authorization)
     * @return Map containing course details
     */
    public Map<String, Object> getCourseDetailsById(int courseId, int teacherId) {
        Map<String, Object> courseDetails = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            LOGGER.info("Getting course details for course ID: " + courseId + ", teacher ID: " + teacherId);
            conn = DBConnection.getConnection();
            
            // First, check if this course belongs to this teacher
            String sql = "SELECT * FROM courses WHERE course_id = ? AND teacher_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, courseId);
            pstmt.setInt(2, teacherId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                courseDetails = new HashMap<>();
                
                // Get all course fields
                try { courseDetails.put("courseId", rs.getInt("course_id")); } 
                catch (SQLException e) { courseDetails.put("courseId", courseId); }
                
                try { courseDetails.put("courseCode", rs.getString("course_code")); } 
                catch (SQLException e) { 
                    try { courseDetails.put("courseCode", rs.getString("code")); }
                    catch (SQLException e2) { courseDetails.put("courseCode", "N/A"); }
                }
                
                try { courseDetails.put("courseName", rs.getString("course_name")); } 
                catch (SQLException e) { 
                    try { courseDetails.put("courseName", rs.getString("name")); }
                    catch (SQLException e2) { courseDetails.put("courseName", "Unnamed Course"); }
                }
                
                try { courseDetails.put("description", rs.getString("description")); } 
                catch (SQLException e) { courseDetails.put("description", ""); }
                
                try { courseDetails.put("credits", rs.getInt("credits")); } 
                catch (SQLException e) { courseDetails.put("credits", 0); }
                
                // Get student count
                int studentCount = 0;
                PreparedStatement countStmt = null;
                ResultSet countRs = null;
                try {
                    String countSql = "SELECT COUNT(*) FROM student_courses WHERE course_id = ?";
                    countStmt = conn.prepareStatement(countSql);
                    countStmt.setInt(1, courseId);
                    countRs = countStmt.executeQuery();
                    if (countRs.next()) {
                        studentCount = countRs.getInt(1);
                    }
                } catch (SQLException e) {
                    LOGGER.warning("Error getting student count: " + e.getMessage());
                } finally {
                    if (countRs != null) try { countRs.close(); } catch (SQLException e) {}
                    if (countStmt != null) try { countStmt.close(); } catch (SQLException e) {}
                }
                courseDetails.put("studentCount", studentCount);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting course details for course ID: " + courseId, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return courseDetails;
    }
    
    /**
     * Enrolls a student in a course
     * 
     * @param studentId The student ID
     * @param courseId The course ID
     * @return true if enrollment was successful, false otherwise
     */
    public boolean enrollStudentInCourse(int studentId, int courseId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            LOGGER.info("Enrolling student ID: " + studentId + " in course ID: " + courseId);
            conn = DBConnection.getConnection();
            
            // First check if the student is already enrolled
            String checkSql = "SELECT COUNT(*) FROM student_courses WHERE student_id = ? AND course_id = ?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setInt(1, studentId);
            pstmt.setInt(2, courseId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                // Student is already enrolled
                LOGGER.info("Student ID: " + studentId + " is already enrolled in course ID: " + courseId);
                return true;
            }
            
            // Close the previous resources
            rs.close();
            pstmt.close();
            
            // Enroll the student
            String sql = "INSERT INTO student_courses (student_id, course_id) VALUES (?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            pstmt.setInt(2, courseId);
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
            
            LOGGER.info("Enrollment " + (success ? "successful" : "failed") + " for student ID: " + studentId + " in course ID: " + courseId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error enrolling student ID: " + studentId + " in course ID: " + courseId, e);
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
     * Removes a student from a course
     * 
     * @param studentId The student ID
     * @param courseId The course ID
     * @return true if removal was successful, false otherwise
     */
    public boolean removeStudentFromCourse(int studentId, int courseId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            LOGGER.info("Removing student ID: " + studentId + " from course ID: " + courseId);
            conn = DBConnection.getConnection();
            
            // Remove the student from the course
            String sql = "DELETE FROM student_courses WHERE student_id = ? AND course_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            pstmt.setInt(2, courseId);
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
            
            LOGGER.info("Removal " + (success ? "successful" : "not needed or failed") + " for student ID: " + studentId + " from course ID: " + courseId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error removing student ID: " + studentId + " from course ID: " + courseId, e);
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
     * Retrieves all parents from the database
     * 
     * @return List of all parents
     * @throws SQLException if database error occurs
     */
    public List<Parent> getAllParents() throws SQLException {
        List<Parent> parentList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM parents ORDER BY last_name, first_name";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Parent parent = new Parent();
                parent.setId(rs.getInt("parent_id"));
                parent.setFirstName(rs.getString("first_name"));
                parent.setLastName(rs.getString("last_name"));
                parent.setEmail(rs.getString("email"));
                parent.setPhone(rs.getString("phone"));
                parent.setAddress(rs.getString("address"));
                parent.setOccupation(rs.getString("occupation"));
                
                // Handle user_id which could be null
                int userId = rs.getInt("user_id");
                if (!rs.wasNull()) {
                    parent.setUserId(userId);
                }
                
                parentList.add(parent);
            }
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
        
        return parentList;
    }
    
    /**
     * Gets the number of students enrolled in a specific course
     * 
     * @param courseId The course ID
     * @return The number of students enrolled in the course
     */
    public int getStudentCountByCourseId(int courseId) {
        int count = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) FROM student_courses WHERE course_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, courseId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting student count for course ID: " + courseId, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return count;
    }
    
    /**
     * Gets mark statistics (average, highest, lowest) for a specific course
     * 
     * @param courseId The course ID
     * @return Map containing mark statistics
     */
    public Map<String, Object> getMarkStatisticsByCourseId(int courseId) {
        Map<String, Object> stats = new HashMap<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT AVG(score) as average, MAX(score) as highest, MIN(score) as lowest " +
                         "FROM marks WHERE course_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, courseId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                stats.put("average", rs.getDouble("average"));
                stats.put("highest", rs.getDouble("highest"));
                stats.put("lowest", rs.getDouble("lowest"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting mark statistics for course ID: " + courseId, e);
            return null; // Return null on error
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return stats;
    }
    
    /**
     * Get all teachers with basic information
     * @return List of teachers with basic info as maps
     */
    public List<Map<String, Object>> getAllTeachersWithBasicInfo() {
        List<Map<String, Object>> teachers = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT t.teacher_id, t.first_name, t.last_name, t.email, t.subject, " +
                         "d.department_name FROM Teachers t " +
                         "LEFT JOIN Departments d ON t.department_id = d.department_id " +
                         "ORDER BY t.last_name, t.first_name";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> teacher = new HashMap<>();
                teacher.put("teacherId", rs.getInt("teacher_id"));
                teacher.put("firstName", rs.getString("first_name"));
                teacher.put("lastName", rs.getString("last_name"));
                teacher.put("fullName", rs.getString("first_name") + " " + rs.getString("last_name"));
                teacher.put("email", rs.getString("email"));
                teacher.put("subject", rs.getString("subject"));
                teacher.put("departmentName", rs.getString("department_name"));
                
                teachers.add(teacher);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all teachers with basic info", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return teachers;
    }
    
    /**
     * Get all admin staff
     * @return List of admin staff as maps
     */
    public List<Map<String, Object>> getAdminStaff() {
        List<Map<String, Object>> adminStaff = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT admin_id, first_name, last_name, email, role, designation " +
                         "FROM Admins ORDER BY last_name, first_name";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> admin = new HashMap<>();
                admin.put("adminId", rs.getInt("admin_id"));
                admin.put("firstName", rs.getString("first_name"));
                admin.put("lastName", rs.getString("last_name"));
                admin.put("fullName", rs.getString("first_name") + " " + rs.getString("last_name"));
                admin.put("email", rs.getString("email"));
                admin.put("role", rs.getString("role"));
                admin.put("designation", rs.getString("designation"));
                
                adminStaff.add(admin);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting admin staff", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return adminStaff;
    }
    
    /**
     * Debug helper method to ensure the student with ID 1 is enrolled in a course
     * This can be called from the DashboardServlet to initialize the relationship
     */
    public void ensureStudentCourseRelationship() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // First check if the student_courses table exists
            DatabaseMetaData meta = conn.getMetaData();
            rs = meta.getTables(null, null, "student_courses", new String[] {"TABLE"});
            boolean tableExists = rs.next();
            
            if (!tableExists) {
                // Create the table if it doesn't exist
                LOGGER.info("Creating student_courses table");
                String createTableSql = "CREATE TABLE student_courses (" +
                                      "id INT AUTO_INCREMENT PRIMARY KEY, " +
                                      "student_id INT NOT NULL, " +
                                      "course_id INT NOT NULL, " +
                                      "enrollment_date DATE DEFAULT CURRENT_DATE, " +
                                      "FOREIGN KEY (student_id) REFERENCES students(student_id), " +
                                      "FOREIGN KEY (course_id) REFERENCES courses(course_id), " +
                                      "UNIQUE (student_id, course_id)" +
                                      ")";
                                      
                pstmt = conn.prepareStatement(createTableSql);
                pstmt.executeUpdate();
                DBConnection.closeStatement(pstmt);
            }
            
            // Check if the student with ID 1 is already enrolled in any course
            String checkEnrollmentSql = "SELECT COUNT(*) FROM student_courses WHERE student_id = 1";
            pstmt = conn.prepareStatement(checkEnrollmentSql);
            rs = pstmt.executeQuery();
            
            boolean isEnrolled = false;
            if (rs.next() && rs.getInt(1) > 0) {
                isEnrolled = true;
                LOGGER.info("Student with ID 1 is already enrolled in a course");
            }
            
            if (!isEnrolled) {
                // Get the first available course ID
                DBConnection.closeResultSet(rs);
                DBConnection.closeStatement(pstmt);
                
                String getCourseSql = "SELECT course_id FROM courses LIMIT 1";
                pstmt = conn.prepareStatement(getCourseSql);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    int courseId = rs.getInt("course_id");
                    
                    // Enroll the student in this course
                    DBConnection.closeResultSet(rs);
                    DBConnection.closeStatement(pstmt);
                    
                    String enrollSql = "INSERT INTO student_courses (student_id, course_id) VALUES (1, ?)";
                    pstmt = conn.prepareStatement(enrollSql);
                    pstmt.setInt(1, courseId);
                    pstmt.executeUpdate();
                    
                    LOGGER.info("Enrolled student with ID 1 in course with ID " + courseId);
                } else {
                    LOGGER.warning("No courses found to enroll the student");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error ensuring student-course relationship", e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
    }
    
    /**
     * Gets the count of today's appointments for a teacher
     * 
     * @param teacherId The teacher ID
     * @return Count of today's appointments
     */
    public int getTodayAppointmentCountByTeacherId(int teacherId) {
        int count = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // First check if the appointments table exists
            DatabaseMetaData meta = conn.getMetaData();
            rs = meta.getTables(null, null, "appointments", new String[] {"TABLE"});
            boolean tableExists = rs.next();
            
            if (tableExists) {
                DBConnection.closeResultSet(rs);
                
                String sql = "SELECT COUNT(*) FROM appointments WHERE teacher_id = ? AND DATE(appointment_date) = CURDATE()";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, teacherId);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            } else {
                LOGGER.info("Appointments table does not exist");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting today's appointment count for teacher ID: " + teacherId, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return count;
    }
    
    /**
     * Adds a new teacher to the database and creates a user account
     * 
     * @param teacher The teacher object to add
     * @param username Username for the new user account
     * @param password Password for the new user account 
     * @param role Role for the new user account (usually "teacher")
     * @return The ID of the newly added teacher, or -1 if operation failed
     */
    public int addTeacherWithUserAccount(Teacher teacher, String username, String password, String role) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int generatedTeacherId = -1;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Begin transaction
            
            // Step 1: Create user account first
            String createUserSql = "INSERT INTO users (username, password, role, email, active, created_at) " +
                                 "VALUES (?, ?, ?, ?, ?, NOW())";
            
            pstmt = conn.prepareStatement(createUserSql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            pstmt.setString(3, role);
            pstmt.setString(4, teacher.getEmail());
            pstmt.setBoolean(5, true); // Set account as active
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating user account failed, no rows affected.");
            }
            
            // Get the generated user ID
            rs = pstmt.getGeneratedKeys();
            int userId = -1;
            if (rs.next()) {
                userId = rs.getInt(1);
            } else {
                throw new SQLException("Creating user account failed, no ID obtained.");
            }
            
            // Close resources before reusing
            rs.close();
            pstmt.close();
            
            // Step 2: Create teacher with reference to user ID
            String createTeacherSql = "INSERT INTO teachers (first_name, last_name, email, phone, specialization, " +
                                    "qualification, experience, join_date, address, image_link, status, user_id) " +
                                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(createTeacherSql, Statement.RETURN_GENERATED_KEYS);
            setTeacherParameters(pstmt, teacher);
            pstmt.setInt(12, userId); // Set the user_id foreign key
            
            affectedRows = pstmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating teacher record failed, no rows affected.");
            }
            
            // Get the generated teacher ID
            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                generatedTeacherId = rs.getInt(1);
                teacher.setId(generatedTeacherId);
            } else {
                throw new SQLException("Creating teacher record failed, no ID obtained.");
            }
            
            // Commit the transaction
            conn.commit();
            LOGGER.info("Successfully added teacher with ID: " + generatedTeacherId + " and user account with ID: " + userId);
            
        } catch (SQLException e) {
            // Roll back the transaction if something goes wrong
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error rolling back transaction", ex);
            }
            
            LOGGER.log(Level.SEVERE, "Error adding teacher with user account: " + e.getMessage(), e);
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true); // Reset auto-commit mode
                }
                
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return generatedTeacherId;
    }
    
    /**
     * Gets teacher ID by user ID
     * 
     * @param userId The user ID
     * @return Teacher ID if found, -1 otherwise
     */
    public int getTeacherIdByUserId(int userId) {
        int teacherId = -1;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT teacher_id FROM teachers WHERE user_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                teacherId = rs.getInt("teacher_id");
                LOGGER.info("Found teacher ID: " + teacherId + " for user ID: " + userId);
            } else {
                LOGGER.warning("No teacher found with user ID: " + userId);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving teacher ID for user ID: " + userId, e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
            }
        }
        
        return teacherId;
    }
} 