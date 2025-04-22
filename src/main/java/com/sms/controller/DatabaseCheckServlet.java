package com.sms.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sms.util.DBConnection;

/**
 * Servlet that checks database connectivity and returns status
 */
@WebServlet("/checkDatabase")
public class DatabaseCheckServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head><title>Database Connection Check</title>");
        out.println("<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css' rel='stylesheet'>");
        out.println("</head><body class='container mt-5'>");
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null && !conn.isClosed()) {
                out.println("<div class='alert alert-success'>");
                out.println("<h2><i class='bi bi-check-circle-fill'></i> Database Connection Successful</h2>");
                out.println("<p>Successfully connected to the SMS database.</p>");
                out.println("</div>");
            } else {
                out.println("<div class='alert alert-danger'>");
                out.println("<h2><i class='bi bi-x-circle-fill'></i> Database Connection Failed</h2>");
                out.println("<p>Unable to establish a connection to the database.</p>");
                out.println("</div>");
            }
        } catch (SQLException e) {
            out.println("<div class='alert alert-danger'>");
            out.println("<h2><i class='bi bi-x-circle-fill'></i> Database Connection Error</h2>");
            out.println("<p>Error: " + e.getMessage() + "</p>");
            out.println("</div>");
        }
        
        out.println("<a href='index.jsp' class='btn btn-primary'>Back to Home</a>");
        out.println("</body></html>");
    }
} 