package com.sms.util;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet for testing database connections and table structures
 */
@WebServlet("/admin/dbtest")
public class DatabaseTestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(DatabaseTestServlet.class.getName());
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head><title>Database Test</title></head><body>");
        out.println("<h1>Database Connection Test</h1>");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if (conn != null) {
                out.println("<p style='color:green'>Database connection successful!</p>");
                
                // Get database metadata
                DatabaseMetaData meta = conn.getMetaData();
                out.println("<p>Database: " + meta.getDatabaseProductName() + " " + meta.getDatabaseProductVersion() + "</p>");
                
                // List all tables in the database
                out.println("<h2>Tables in Database</h2>");
                out.println("<ul>");
                rs = meta.getTables(null, null, "%", new String[]{"TABLE"});
                while (rs.next()) {
                    String tableName = rs.getString("TABLE_NAME");
                    out.println("<li>" + tableName + "</li>");
                }
                out.println("</ul>");
                DBConnection.closeResultSet(rs);
                
                // Test doctors table
                out.println("<h2>Test Doctors Table</h2>");
                try {
                    pstmt = conn.prepareStatement("SELECT COUNT(*) FROM doctors");
                    rs = pstmt.executeQuery();
                    if (rs.next()) {
                        int count = rs.getInt(1);
                        out.println("<p>Count of doctors: " + count + "</p>");
                    }
                } catch (SQLException e) {
                    out.println("<p style='color:red'>Error querying doctors table: " + e.getMessage() + "</p>");
                    LOGGER.log(Level.SEVERE, "Error querying doctors table", e);
                }
                DBConnection.closeResultSet(rs);
                DBConnection.closeStatement(pstmt);
                
                // Test nurses table
                out.println("<h2>Test Nurses Table</h2>");
                try {
                    pstmt = conn.prepareStatement("SELECT COUNT(*) FROM nurses");
                    rs = pstmt.executeQuery();
                    if (rs.next()) {
                        int count = rs.getInt(1);
                        out.println("<p>Count of nurses: " + count + "</p>");
                    }
                } catch (SQLException e) {
                    out.println("<p style='color:red'>Error querying nurses table: " + e.getMessage() + "</p>");
                    LOGGER.log(Level.SEVERE, "Error querying nurses table", e);
                }
                DBConnection.closeResultSet(rs);
                DBConnection.closeStatement(pstmt);
                
                // Test courses table
                out.println("<h2>Test Courses Table</h2>");
                try {
                    pstmt = conn.prepareStatement("SELECT COUNT(*) FROM courses");
                    rs = pstmt.executeQuery();
                    if (rs.next()) {
                        int count = rs.getInt(1);
                        out.println("<p>Count of courses: " + count + "</p>");
                    }
                } catch (SQLException e) {
                    out.println("<p style='color:red'>Error querying courses table: " + e.getMessage() + "</p>");
                    LOGGER.log(Level.SEVERE, "Error querying courses table", e);
                }
                DBConnection.closeResultSet(rs);
                DBConnection.closeStatement(pstmt);
                
                // Test appointments table
                out.println("<h2>Test Appointments Table</h2>");
                try {
                    pstmt = conn.prepareStatement("SELECT COUNT(*) FROM appointments");
                    rs = pstmt.executeQuery();
                    if (rs.next()) {
                        int count = rs.getInt(1);
                        out.println("<p>Count of appointments: " + count + "</p>");
                    }
                } catch (SQLException e) {
                    out.println("<p style='color:red'>Error querying appointments table: " + e.getMessage() + "</p>");
                    LOGGER.log(Level.SEVERE, "Error querying appointments table", e);
                }
                DBConnection.closeResultSet(rs);
                DBConnection.closeStatement(pstmt);
                
            } else {
                out.println("<p style='color:red'>Database connection failed!</p>");
            }
            
        } catch (SQLException e) {
            out.println("<p style='color:red'>Database error: " + e.getMessage() + "</p>");
            LOGGER.log(Level.SEVERE, "Database error", e);
        } finally {
            DBConnection.closeAll(conn, pstmt, rs);
        }
        
        out.println("</body></html>");
    }
} 