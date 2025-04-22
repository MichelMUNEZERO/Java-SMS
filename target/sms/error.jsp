<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - School Management System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .error-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            max-width: 500px;
            text-align: center;
        }
        .error-code {
            color: #e74c3c;
            font-size: 72px;
            margin: 0;
            border-right: 1px solid #e74c3c;
            padding-right: 20px;
            display: inline-block;
            margin-right: 20px;
            vertical-align: middle;
        }
        .error-details {
            display: inline-block;
            text-align: left;
            vertical-align: middle;
        }
        h1 {
            margin-top: 0;
            color: #333;
        }
        p {
            color: #666;
            margin-bottom: 20px;
        }
        .btn {
            display: inline-block;
            background-color: #3498db;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.3s;
        }
        .btn:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div>
            <%
                Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
                if (statusCode == null) {
                    statusCode = (Integer) response.getStatus();
                }
            %>
            <span class="error-code"><%= statusCode != null ? statusCode : "Error" %></span>
            <div class="error-details">
                <h1>An error occurred</h1>
                <p>We apologize for the inconvenience. Please try again later or contact the administrator.</p>
                <% if (exception != null) { %>
                <p><small>Details: <%= exception.getMessage() %></small></p>
                <% } %>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/login" class="btn">Return to Login</a>
    </div>
</body>
</html> 