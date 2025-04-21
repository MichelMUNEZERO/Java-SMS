<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - School Management System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            padding-top: 50px;
        }
        .error-container {
            max-width: 600px;
            margin: 0 auto;
            text-align: center;
            padding: 30px;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .error-code {
            font-size: 5rem;
            font-weight: bold;
            color: #dc3545;
            margin-bottom: 20px;
        }
        .error-message {
            font-size: 1.2rem;
            margin-bottom: 20px;
            color: #6c757d;
        }
        .home-link {
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="error-container">
            <div class="error-code">
                <%
                    Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
                    if (statusCode != null) {
                        out.println(statusCode);
                    } else {
                        out.println("Error");
                    }
                %>
            </div>
            
            <div class="error-message">
                <%
                    String errorMessage = (String) request.getAttribute("javax.servlet.error.message");
                    if (errorMessage != null && !errorMessage.isEmpty()) {
                        out.println(errorMessage);
                    } else {
                        out.println("An error occurred while processing your request.");
                    }
                %>
            </div>
            
            <p>We apologize for the inconvenience. Please try again later or contact the administrator.</p>
            
            <div class="home-link">
                <a href="<%= request.getContextPath() %>/login" class="btn btn-primary">Go to Login</a>
            </div>
        </div>
    </div>
</body>
</html> 