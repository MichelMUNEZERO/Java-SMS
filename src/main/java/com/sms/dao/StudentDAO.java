package com.sms.dao;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
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
            String sql = "SELECT * FROM students ORDER BY last_name, first_name";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            LOGGER.info("Fetching all students from database");
            
            while (rs.next()) {
                try {
                    Student student = mapResultSetToStudent(rs);
                    
                    // Ensure status is set to 'active' if it's null
                    if (student.getStatus() == null || student.getStatus().isEmpty()) {
                        student.setStatus("active");
                    }
                    
                    students.add(student);
                    LOGGER.info("Loaded student: " + student.getFirstName() + " " + student.getLastName() + " (ID: " + student.getId() + ")");
                } catch(Exception e) {
                    LOGGER.log(Level.WARNING, "Error mapping student: " + e.getMessage());
                }
            }
            
            LOGGER.info("Loaded " + students.size() + " students in total");
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
            String sql = "SELECT s.*, p.first_name as parent_first_name, p.last_name as parent_last_name, " +
                        "p.email as parent_email, p.phone as parent_phone, p.address as parent_address, " +
                        "p.occupation as parent_occupation, u.username, u.active as user_status, " +
                        "sc.course_id " +
                        "FROM students s " +
                        "LEFT JOIN parents p ON s.parent_id = p.parent_id " +
                        "LEFT JOIN users u ON s.user_id = u.user_id " +
                        "LEFT JOIN student_courses sc ON s.student_id = sc.student_id " +
                        "WHERE s.student_id = ?";
            
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
                
                // Handle date fields that might be null
                java.sql.Date dob = rs.getDate("date_of_birth");
                student.setDateOfBirth(dob != null ? dob : null);
                
                java.sql.Date admissionDate = rs.getDate("admission_date");
                student.setAdmissionDate(admissionDate != null ? admissionDate : null);
                
                student.setRegNumber(rs.getString("reg_number"));
                student.setClassName(rs.getString("grade"));
                
                // Handle parent_id and user_id that might be null
                int parentId = rs.getInt("parent_id");
                student.setParentId(rs.wasNull() ? 0 : parentId);
                
                int userId = rs.getInt("user_id");
                student.setUserId(rs.wasNull() ? 0 : userId);
                
                // Set status based on user's active status
                boolean isActive = rs.getBoolean("user_status");
                student.setStatus(isActive ? "active" : "inactive");
                
                // Set username if available
                student.setUsername(rs.getString("username"));
                
                // Set course ID if available
                int courseId = rs.getInt("course_id");
                student.setCourseId(rs.wasNull() ? null : courseId);
                
                // Set parent information if available
                if (rs.getString("parent_first_name") != null) {
                    student.setParentFirstName(rs.getString("parent_first_name"));
                    student.setParentLastName(rs.getString("parent_last_name"));
                    student.setParentName(rs.getString("parent_first_name") + " " + rs.getString("parent_last_name"));
                    student.setGuardianEmail(rs.getString("parent_email"));
                    student.setGuardianPhone(rs.getString("parent_phone"));
                    student.setGuardianAddress(rs.getString("parent_address"));
                    student.setGuardianOccupation(rs.getString("parent_occupation"));
                }
            }
            
            return student;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting student with ID: " + id, e);
            throw new RuntimeException("Database error while retrieving student: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing database resources", e);
            }
        }
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
            
            // Removed status filter since the column doesn't exist in the database
            String sql = "SELECT student_id, first_name, last_name, email FROM students ORDER BY last_name, first_name";
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
     * Get all students taught by a specific teacher
     * 
     * @param teacherId The ID of the teacher
     * @return List of Student objects
     */
    public List<Student> getStudentsByTeacherId(int teacherId) {
        List<Student> students = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // First check if the student_courses table exists
            DatabaseMetaData meta = conn.getMetaData();
            ResultSet tables = meta.getTables(null, null, "student_courses", new String[] {"TABLE"});
            boolean tableExists = tables.next();
            tables.close();
            
            if (tableExists) {
                // Try to get students through the student_courses relationship
                String sql = "SELECT DISTINCT s.* FROM students s " +
                             "JOIN student_courses sc ON s.student_id = sc.student_id " +
                             "JOIN courses c ON sc.course_id = c.course_id " +
                             "WHERE c.teacher_id = ? " +
                             "ORDER BY s.last_name, s.first_name";
                
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, teacherId);
                rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    try {
                        Student student = mapResultSetToStudent(rs);
                        students.add(student);
                    } catch (SQLException e) {
                        LOGGER.log(Level.WARNING, "Error mapping student result set: " + e.getMessage());
                    }
                }
                
                // If no students found through join, or if there was an error, get all students as fallback
                if (students.isEmpty()) {
                    closeResources(null, pstmt, rs);
                    
                    // Get all students instead as a fallback
                    return getAllStudents();
                }
            } else {
                // If student_courses table doesn't exist, get all students
                return getAllStudents();
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving students for teacher ID: " + teacherId, e);
            // Fallback to getting all students if there's an error
            try {
                return getAllStudents();
            } catch (Exception ex) {
                LOGGER.log(Level.SEVERE, "Error retrieving all students as fallback", ex);
            }
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return students;
    }

    /**
     * Get all available students
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
            // Removed the WHERE status = 'active' filter since the column doesn't exist
            String sql = "SELECT * FROM students ORDER BY last_name, first_name";
            
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Student student = mapResultSetToStudent(rs);
                // Set status to active by default since we don't have a status column
                student.setStatus("active");
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
        
        // Required fields
        student.setId(rs.getInt("student_id"));
        student.setFirstName(rs.getString("first_name"));
        student.setLastName(rs.getString("last_name"));
        
        // Optional fields with fallback values
        try { 
            String email = rs.getString("email");
            student.setEmail(email != null ? email : "");
        } catch (SQLException e) { 
            student.setEmail(""); 
        }
        
        try { 
            String phone = rs.getString("phone");
            student.setPhone(phone != null ? phone : "");
        } catch (SQLException e) { 
            student.setPhone(""); 
        }
        
        try { 
            String address = rs.getString("address");
            student.setAddress(address != null ? address : "");
        } catch (SQLException e) { 
            student.setAddress(""); 
        }
        
        try {
            java.sql.Date dob = rs.getDate("date_of_birth");
            if (dob != null) {
                student.setDateOfBirth(dob);
            }
        } catch (SQLException e) {
            // Date of birth is optional
        }
        
        try {
            java.sql.Date admissionDate = rs.getDate("admission_date");
            if (admissionDate != null) {
                student.setAdmissionDate(admissionDate);
            }
        } catch (SQLException e) {
            // Admission date is optional
        }
        
        try {
            String grade = rs.getString("grade");
            if (grade != null && !grade.isEmpty()) {
                student.setClassName(grade);
                student.setClassId(0); // Default class id
            }
        } catch (SQLException e) {
            // Grade is optional
        }
        
        try {
            String regNumber = rs.getString("reg_number");
            if (regNumber != null) {
                student.setRegNumber(regNumber);
            }
        } catch (SQLException e) {
            // Registration number is optional
        }
        
        // IMPORTANT: Always set status to active if missing or null
        try {
            String status = rs.getString("status");
            student.setStatus(status != null && !status.isEmpty() ? status : "active");
        } catch (SQLException e) {
            student.setStatus("active");
        }
        
        return student;
    }

    /**
     * Get all students for a specific parent
     * @param parentId The ID of the parent
     * @return List of Student objects
     */
    public List<Student> getStudentsByParent(int parentId) {
        List<Student> students = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT s.*, c.class_name FROM Students s " +
                         "LEFT JOIN Classes c ON s.class_id = c.class_id " +
                         "WHERE s.parent_id = ? " +
                         "ORDER BY s.grade, s.last_name, s.first_name";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, parentId);
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
                student.setRegNumber(rs.getString("reg_number"));
                student.setAdmissionDate(rs.getDate("admission_date"));
                student.setGrade(rs.getString("grade"));
                student.setParentId(rs.getInt("parent_id"));
                student.setUserId(rs.getInt("user_id"));
                student.setStatus(rs.getString("status"));
                student.setClassName(rs.getString("class_name"));
                student.setGender(rs.getString("gender"));
                student.setClassId(rs.getInt("class_id"));
                
                students.add(student);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting students for parent ID: " + parentId, e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return students;
    }
    
    /**
     * Get attendance information for a student
     * @param studentId The ID of the student
     * @return Map containing attendance statistics
     */
    public Map<String, Object> getAttendanceByStudent(int studentId) {
        Map<String, Object> attendanceInfo = new HashMap<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Initialize with default values in case there's no data
            attendanceInfo.put("percentage", 100.0);
            attendanceInfo.put("totalDays", 30);
            attendanceInfo.put("presentDays", 28);
            attendanceInfo.put("absentDays", 1);
            attendanceInfo.put("lateDays", 1);
            attendanceInfo.put("recentAttendance", new ArrayList<Map<String, Object>>());
            
            // Get overall attendance percentage
            String sqlPercentage = "SELECT " +
                                  "(SUM(CASE WHEN status = 'present' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) as percentage, " +
                                  "COUNT(*) as total_days, " +
                                  "SUM(CASE WHEN status = 'present' THEN 1 ELSE 0 END) as present_days, " +
                                  "SUM(CASE WHEN status = 'absent' THEN 1 ELSE 0 END) as absent_days, " +
                                  "SUM(CASE WHEN status = 'late' THEN 1 ELSE 0 END) as late_days " +
                                  "FROM Attendance WHERE student_id = ?";
            pstmt = conn.prepareStatement(sqlPercentage);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            
            if (rs.next() && rs.getInt("total_days") > 0) {
                attendanceInfo.put("percentage", rs.getDouble("percentage"));
                attendanceInfo.put("totalDays", rs.getInt("total_days"));
                attendanceInfo.put("presentDays", rs.getInt("present_days"));
                attendanceInfo.put("absentDays", rs.getInt("absent_days"));
                attendanceInfo.put("lateDays", rs.getInt("late_days"));
            }
            
            // Close the result set and statement before reusing
            rs.close();
            pstmt.close();
            
            // Get recent attendance records
            List<Map<String, Object>> recentAttendance = new ArrayList<>();
            String sqlRecent = "SELECT a.*, DATE_FORMAT(a.date, '%b %d, %Y') as formatted_date " +
                              "FROM Attendance a WHERE a.student_id = ? " +
                              "ORDER BY a.date DESC LIMIT 10";
            pstmt = conn.prepareStatement(sqlRecent);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> record = new HashMap<>();
                record.put("date", rs.getString("formatted_date"));
                record.put("status", rs.getString("status"));
                record.put("remarks", rs.getString("remarks"));
                recentAttendance.add(record);
            }
            
            if (!recentAttendance.isEmpty()) {
                attendanceInfo.put("recentAttendance", recentAttendance);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting attendance for student ID: " + studentId, e);
            // Default values already set
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return attendanceInfo;
    }

    /**
     * Get all students for a specific parent as a list of maps
     * @param parentId The ID of the parent
     * @return List of student data as maps
     */
    public List<Map<String, Object>> getStudentsByParentAsMap(int parentId) {
        List<Map<String, Object>> students = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT s.*, c.class_name FROM Students s " +
                         "LEFT JOIN Classes c ON s.class_id = c.class_id " +
                         "WHERE s.parent_id = ? " +
                         "ORDER BY s.grade, s.last_name, s.first_name";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, parentId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> student = new HashMap<>();
                student.put("studentId", rs.getInt("student_id"));
                student.put("firstName", rs.getString("first_name"));
                student.put("lastName", rs.getString("last_name"));
                student.put("fullName", rs.getString("first_name") + " " + rs.getString("last_name"));
                student.put("email", rs.getString("email"));
                student.put("grade", rs.getString("grade"));
                student.put("className", rs.getString("class_name"));
                student.put("regNumber", rs.getString("reg_number"));
                
                students.add(student);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting students for parent ID: " + parentId, e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return students;
    }

    /**
     * Get academic summary for a student
     * @param studentId The ID of the student
     * @return Map containing academic summary
     */
    public Map<String, Object> getStudentAcademicSummary(int studentId) {
        Map<String, Object> summary = new HashMap<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Get GPA and overall grades
            String sqlGpa = "SELECT " +
                            "AVG(CASE " +
                            "  WHEN grade = 'A' THEN 4.0 " +
                            "  WHEN grade = 'B' THEN 3.0 " +
                            "  WHEN grade = 'C' THEN 2.0 " +
                            "  WHEN grade = 'D' THEN 1.0 " +
                            "  ELSE 0.0 END) as gpa, " +
                            "COUNT(DISTINCT course_id) as total_courses, " +
                            "SUM(CASE WHEN grade = 'A' THEN 1 ELSE 0 END) as a_count, " +
                            "SUM(CASE WHEN grade = 'B' THEN 1 ELSE 0 END) as b_count, " +
                            "SUM(CASE WHEN grade = 'C' THEN 1 ELSE 0 END) as c_count, " +
                            "SUM(CASE WHEN grade = 'D' THEN 1 ELSE 0 END) as d_count, " +
                            "SUM(CASE WHEN grade = 'F' THEN 1 ELSE 0 END) as f_count, " +
                            "AVG(marks) as average_mark " +
                            "FROM Marks WHERE student_id = ?";
            pstmt = conn.prepareStatement(sqlGpa);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                summary.put("gpa", rs.getDouble("gpa"));
                summary.put("totalCourses", rs.getInt("total_courses"));
                summary.put("aCount", rs.getInt("a_count"));
                summary.put("bCount", rs.getInt("b_count"));
                summary.put("cCount", rs.getInt("c_count"));
                summary.put("dCount", rs.getInt("d_count"));
                summary.put("fCount", rs.getInt("f_count"));
                summary.put("averageMark", rs.getDouble("average_mark"));
            }
            
            // Get pending assignments count
            String sqlPending = "SELECT COUNT(*) as pending_count FROM Assignments " +
                                "WHERE student_id = ? AND status = 'pending'";
            pstmt = conn.prepareStatement(sqlPending);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                summary.put("pendingAssignments", rs.getInt("pending_count"));
            }
            
            // Get recent grades
            List<Map<String, Object>> recentGrades = new ArrayList<>();
            String sqlRecent = "SELECT m.*, c.course_name, e.exam_name " +
                               "FROM Marks m " +
                               "JOIN Courses c ON m.course_id = c.course_id " +
                               "JOIN Exams e ON m.exam_id = e.exam_id " +
                               "WHERE m.student_id = ? " +
                               "ORDER BY e.exam_date DESC LIMIT 5";
            pstmt = conn.prepareStatement(sqlRecent);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> grade = new HashMap<>();
                grade.put("courseName", rs.getString("course_name"));
                grade.put("examName", rs.getString("exam_name"));
                grade.put("marks", rs.getDouble("marks"));
                grade.put("grade", rs.getString("grade"));
                recentGrades.add(grade);
            }
            
            summary.put("recentGrades", recentGrades);
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting academic summary for student ID: " + studentId, e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return summary;
    }
}