<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Error - School Management System</title>
    <!-- Bootstrap CSS -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <!-- Custom CSS -->
    <style>
      body {
        display: flex;
        align-items: center;
        justify-content: center;
        height: 100vh;
        background-color: #f8f9fa;
      }
      .error-container {
        text-align: center;
        padding: 3rem;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        max-width: 600px;
      }
      .error-code {
        font-size: 5rem;
        font-weight: 700;
        color: #dc3545;
        margin-bottom: 1rem;
      }
      .error-message {
        font-size: 1.5rem;
        margin-bottom: 2rem;
        color: #343a40;
      }
      .btn-back {
        padding: 0.75rem 2rem;
        font-weight: 600;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="row">
        <div class="col-md-12">
          <div class="error-container">
            <div class="error-code">
              <% Integer statusCode =
              (Integer)request.getAttribute("javax.servlet.error.status_code");
              if (statusCode != null) { out.print(statusCode); } else {
              out.print("Error"); } %>
            </div>
            <div class="error-message">
              <% String errorMessage =
              (String)request.getAttribute("javax.servlet.error.message"); if
              (errorMessage != null && !errorMessage.isEmpty()) {
              out.print(errorMessage); } else { out.print("An error occurred
              during your request."); } %>
            </div>
            <p class="mb-4">
              We apologize for the inconvenience. Please try again later or
              contact the system administrator if the problem persists.
            </p>
            <a
              href="${pageContext.request.contextPath}/login"
              class="btn btn-primary btn-back"
            >
              <i class="bi bi-arrow-left"></i> Back to Login
            </a>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Bootstrap Icons -->
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css"
    />
  </body>
</html>
