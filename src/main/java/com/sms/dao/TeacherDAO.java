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
            String sql = "SELECT * FROM teachers WHERE id = ?";
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
                         "WHERE id = ?";
            
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
            String sql = "SELECT COUNT(DISTINCT s.student_id) FROM students s " +
                         "JOIN student_courses sc ON s.student_id = sc.student_id " +
                         "JOIN courses c ON sc.course_id = c.course_id " +
                         "WHERE c.teacher_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, teacherId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting student count for teacher ID: " + teacherId, e);
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
            
            // Get course columns first
            DatabaseMetaData meta = conn.getMetaData();
            ResultSet columnsRS = meta.getColumns(null, null, "courses", null);
            StringBuilder columns = new StringBuilder("Columns in courses table: ");
            while (columnsRS.next()) {
                columns.append(columnsRS.getString("COLUMN_NAME")).append(", ");
            }
            LOGGER.info(columns.toString());
            columnsRS.close();
            
            // Select all courses for this teacher
            String sql = "SELECT * FROM courses WHERE teacher_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, teacherId);
            LOGGER.info("Executing SQL: " + sql.replace("?", String.valueOf(teacherId)));
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> course = new HashMap<>();
                
                // Get the course ID (try common column naming patterns)
                int courseId = -1;
                try {
                    courseId = rs.getInt("course_id");
                } catch (SQLException e) {
                    try {
                        courseId = rs.getInt("id");
                    } catch (SQLException e2) {
                        LOGGER.warning("Could not find course ID column");
                    }
                }
                course.put("courseId", courseId);
                
                // Get other course fields
                try { course.put("courseCode", rs.getString("course_code")); } 
                catch (SQLException e) { 
                    try { course.put("courseCode", rs.getString("code")); }
                    catch (SQLException e2) { course.put("courseCode", "N/A"); }
                }
                
                try { course.put("courseName", rs.getString("course_name")); } 
                catch (SQLException e) { 
                    try { course.put("courseName", rs.getString("name")); }
                    catch (SQLException e2) { course.put("courseName", "Unnamed Course"); }
                }
                
                try { course.put("description", rs.getString("description")); } 
                catch (SQLException e) { course.put("description", ""); }
                
                // Get student count for this course
                if (courseId != -1) {
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
                        LOGGER.warning("Error getting student count for course ID " + courseId + ": " + e.getMessage());
                    } finally {
                        if (countRs != null) try { countRs.close(); } catch (SQLException e) {}
                        if (countStmt != null) try { countStmt.close(); } catch (SQLException e) {}
                    }
                    course.put("studentCount", studentCount);
                } else {
                    course.put("studentCount", 0);
                }
                
                courses.add(course);
                LOGGER.info("Found course: " + course.get("courseName"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting courses for teacher ID: " + teacherId, e);
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
            String sql = "SELECT s.student_id, s.first_name, s.last_name, c.course_name, " +
                         "sb.behavior_date, sb.behavior_type, sb.description " +
                         "FROM studentbehavior sb " +
                         "JOIN students s ON sb.student_id = s.student_id " +
                         "JOIN courses c ON sb.course_id = c.course_id " +
                         "WHERE c.teacher_id = ? " +
                         "ORDER BY sb.behavior_date DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, teacherId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> note = new HashMap<>();
                note.put("studentId", rs.getInt("student_id"));
                note.put("studentName", rs.getString("first_name") + " " + rs.getString("last_name"));
                note.put("courseName", rs.getString("course_name"));
                note.put("date", rs.getDate("behavior_date"));
                note.put("behaviorType", rs.getString("behavior_type"));
                note.put("description", rs.getString("description"));
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
} 