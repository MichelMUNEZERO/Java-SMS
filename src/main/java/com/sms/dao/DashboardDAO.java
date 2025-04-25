package com.sms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.sms.util.DBConnection;

/**
 * Data Access Object for Dashboard statistics and reporting data
 */
public class DashboardDAO {
    private static final Logger LOGGER = Logger.getLogger(DashboardDAO.class.getName());
    
    /**
     * Get dashboard statistics
     * @return Map containing various statistics for the dashboard
     */
    public Map<String, Integer> getDashboardStats() {
        Map<String, Integer> stats = new HashMap<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Count students
            String sql = "SELECT COUNT(*) FROM Students";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                stats.put("students", rs.getInt(1));
            }
            DBConnection.closeResultSet(rs);
            DBConnection.closeStatement(pstmt);
            
            // Count teachers
            sql = "SELECT COUNT(*) FROM Teachers";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                stats.put("teachers", rs.getInt(1));
            }
            DBConnection.closeResultSet(rs);
            DBConnection.closeStatement(pstmt);
            
            // Count parents
            sql = "SELECT COUNT(*) FROM Parents";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                stats.put("parents", rs.getInt(1));
            }
            DBConnection.closeResultSet(rs);
            DBConnection.closeStatement(pstmt);
            
            // Count courses
            sql = "SELECT COUNT(*) FROM Courses";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                stats.put("courses", rs.getInt(1));
            }
            DBConnection.closeResultSet(rs);
            DBConnection.closeStatement(pstmt);
            
            // Count today's appointments
            sql = "SELECT COUNT(*) FROM Appointment WHERE Date = CURDATE()";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                stats.put("todayAppointments", rs.getInt(1));
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching dashboard statistics", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return stats;
    }
    
    /**
     * Get report data based on the specified report type
     * @param reportType Type of report (e.g., "marks", "behavior", "attendance")
     * @param filterParams Map containing filter parameters
     * @return Map containing the report data
     */
    public Map<String, Object> getReportData(String reportType, Map<String, Object> filterParams) {
        Map<String, Object> reportData = new HashMap<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            StringBuilder sqlBuilder = new StringBuilder();
            
            switch (reportType.toLowerCase()) {
                case "marks":
                    sqlBuilder.append("SELECT s.first_name, s.last_name, c.course_name, m.mark, m.grade ");
                    sqlBuilder.append("FROM Marks m ");
                    sqlBuilder.append("JOIN Students s ON m.student_id = s.student_id ");
                    sqlBuilder.append("JOIN Courses c ON m.course_id = c.course_id ");
                    
                    // Apply filters if provided
                    if (filterParams != null && !filterParams.isEmpty()) {
                        boolean whereAdded = false;
                        
                        if (filterParams.containsKey("courseId")) {
                            sqlBuilder.append("WHERE m.course_id = ? ");
                            whereAdded = true;
                        }
                        
                        if (filterParams.containsKey("studentId")) {
                            sqlBuilder.append(whereAdded ? "AND " : "WHERE ");
                            sqlBuilder.append("m.student_id = ? ");
                            whereAdded = true;
                        }
                        
                        if (filterParams.containsKey("gradeThreshold")) {
                            sqlBuilder.append(whereAdded ? "AND " : "WHERE ");
                            sqlBuilder.append("m.mark >= ? ");
                        }
                    }
                    
                    sqlBuilder.append("ORDER BY c.course_name, s.last_name, s.first_name");
                    break;
                    
                case "behavior":
                    sqlBuilder.append("SELECT s.first_name, s.last_name, sb.behavior_date, sb.behavior_type, sb.description ");
                    sqlBuilder.append("FROM StudentBehavior sb ");
                    sqlBuilder.append("JOIN Students s ON sb.student_id = s.student_id ");
                    
                    // Apply filters if provided
                    if (filterParams != null && !filterParams.isEmpty()) {
                        boolean whereAdded = false;
                        
                        if (filterParams.containsKey("studentId")) {
                            sqlBuilder.append("WHERE sb.student_id = ? ");
                            whereAdded = true;
                        }
                        
                        if (filterParams.containsKey("behaviorType")) {
                            sqlBuilder.append(whereAdded ? "AND " : "WHERE ");
                            sqlBuilder.append("sb.behavior_type = ? ");
                            whereAdded = true;
                        }
                        
                        if (filterParams.containsKey("startDate")) {
                            sqlBuilder.append(whereAdded ? "AND " : "WHERE ");
                            sqlBuilder.append("sb.behavior_date >= ? ");
                            whereAdded = true;
                        }
                        
                        if (filterParams.containsKey("endDate")) {
                            sqlBuilder.append(whereAdded ? "AND " : "WHERE ");
                            sqlBuilder.append("sb.behavior_date <= ? ");
                        }
                    }
                    
                    sqlBuilder.append("ORDER BY sb.behavior_date DESC, s.last_name, s.first_name");
                    break;
                    
                case "attendance":
                    sqlBuilder.append("SELECT s.first_name, s.last_name, c.course_name, a.date, a.status ");
                    sqlBuilder.append("FROM Attendance a ");
                    sqlBuilder.append("JOIN Students s ON a.student_id = s.student_id ");
                    sqlBuilder.append("JOIN Courses c ON a.course_id = c.course_id ");
                    
                    // Apply filters if provided
                    if (filterParams != null && !filterParams.isEmpty()) {
                        boolean whereAdded = false;
                        
                        if (filterParams.containsKey("courseId")) {
                            sqlBuilder.append("WHERE a.course_id = ? ");
                            whereAdded = true;
                        }
                        
                        if (filterParams.containsKey("studentId")) {
                            sqlBuilder.append(whereAdded ? "AND " : "WHERE ");
                            sqlBuilder.append("a.student_id = ? ");
                            whereAdded = true;
                        }
                        
                        if (filterParams.containsKey("status")) {
                            sqlBuilder.append(whereAdded ? "AND " : "WHERE ");
                            sqlBuilder.append("a.status = ? ");
                            whereAdded = true;
                        }
                        
                        if (filterParams.containsKey("startDate")) {
                            sqlBuilder.append(whereAdded ? "AND " : "WHERE ");
                            sqlBuilder.append("a.date >= ? ");
                            whereAdded = true;
                        }
                        
                        if (filterParams.containsKey("endDate")) {
                            sqlBuilder.append(whereAdded ? "AND " : "WHERE ");
                            sqlBuilder.append("a.date <= ? ");
                        }
                    }
                    
                    sqlBuilder.append("ORDER BY a.date DESC, c.course_name, s.last_name, s.first_name");
                    break;
                    
                default:
                    // Invalid report type
                    reportData.put("error", "Invalid report type: " + reportType);
                    return reportData;
            }
            
            pstmt = conn.prepareStatement(sqlBuilder.toString());
            
            // Set parameters if filters were provided
            if (filterParams != null && !filterParams.isEmpty()) {
                int paramIndex = 1;
                
                if (reportType.equalsIgnoreCase("marks")) {
                    if (filterParams.containsKey("courseId")) {
                        pstmt.setInt(paramIndex++, (Integer) filterParams.get("courseId"));
                    }
                    
                    if (filterParams.containsKey("studentId")) {
                        pstmt.setInt(paramIndex++, (Integer) filterParams.get("studentId"));
                    }
                    
                    if (filterParams.containsKey("gradeThreshold")) {
                        pstmt.setDouble(paramIndex, (Double) filterParams.get("gradeThreshold"));
                    }
                } else if (reportType.equalsIgnoreCase("behavior")) {
                    if (filterParams.containsKey("studentId")) {
                        pstmt.setInt(paramIndex++, (Integer) filterParams.get("studentId"));
                    }
                    
                    if (filterParams.containsKey("behaviorType")) {
                        pstmt.setString(paramIndex++, (String) filterParams.get("behaviorType"));
                    }
                    
                    if (filterParams.containsKey("startDate")) {
                        pstmt.setDate(paramIndex++, java.sql.Date.valueOf((String) filterParams.get("startDate")));
                    }
                    
                    if (filterParams.containsKey("endDate")) {
                        pstmt.setDate(paramIndex, java.sql.Date.valueOf((String) filterParams.get("endDate")));
                    }
                } else if (reportType.equalsIgnoreCase("attendance")) {
                    if (filterParams.containsKey("courseId")) {
                        pstmt.setInt(paramIndex++, (Integer) filterParams.get("courseId"));
                    }
                    
                    if (filterParams.containsKey("studentId")) {
                        pstmt.setInt(paramIndex++, (Integer) filterParams.get("studentId"));
                    }
                    
                    if (filterParams.containsKey("status")) {
                        pstmt.setString(paramIndex++, (String) filterParams.get("status"));
                    }
                    
                    if (filterParams.containsKey("startDate")) {
                        pstmt.setDate(paramIndex++, java.sql.Date.valueOf((String) filterParams.get("startDate")));
                    }
                    
                    if (filterParams.containsKey("endDate")) {
                        pstmt.setDate(paramIndex, java.sql.Date.valueOf((String) filterParams.get("endDate")));
                    }
                }
            }
            
            rs = pstmt.executeQuery();
            
            // Create a list to hold the report rows
            reportData.put("reportType", reportType);
            reportData.put("rows", new java.util.ArrayList<Map<String, Object>>());
            
            java.util.List<Map<String, Object>> rows = (java.util.List<Map<String, Object>>) reportData.get("rows");
            
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                
                if (reportType.equalsIgnoreCase("marks")) {
                    row.put("studentName", rs.getString("first_name") + " " + rs.getString("last_name"));
                    row.put("courseName", rs.getString("course_name"));
                    row.put("mark", rs.getDouble("mark"));
                    row.put("grade", rs.getString("grade"));
                } else if (reportType.equalsIgnoreCase("behavior")) {
                    row.put("studentName", rs.getString("first_name") + " " + rs.getString("last_name"));
                    row.put("date", rs.getDate("behavior_date"));
                    row.put("behaviorType", rs.getString("behavior_type"));
                    row.put("description", rs.getString("description"));
                } else if (reportType.equalsIgnoreCase("attendance")) {
                    row.put("studentName", rs.getString("first_name") + " " + rs.getString("last_name"));
                    row.put("courseName", rs.getString("course_name"));
                    row.put("date", rs.getDate("date"));
                    row.put("status", rs.getString("status"));
                }
                
                rows.add(row);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error generating " + reportType + " report", e);
            reportData.put("error", "Error generating report: " + e.getMessage());
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return reportData;
    }
    
    /**
     * Get user profile data including image link
     * @param userId User ID
     * @return Map containing user profile data
     */
    public Map<String, Object> getUserProfile(int userId) {
        Map<String, Object> profileData = new HashMap<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT username, email, role, image_link FROM Users WHERE user_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                profileData.put("username", rs.getString("username"));
                profileData.put("email", rs.getString("email"));
                profileData.put("role", rs.getString("role"));
                profileData.put("imageLink", rs.getString("image_link"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching user profile data for user ID: " + userId, e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        return profileData;
    }
} 