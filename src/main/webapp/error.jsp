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
    <!-- Bootstrap Icons -->
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css"
    />
    <!-- Custom CSS -->
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />
  </head>
  <body>
    <div class="container py-5">
      <div class="row justify-content-center">
        <div class="col-md-8">
          <div class="card border-danger shadow-sm">
            <div class="card-header bg-danger text-white">
              <h4 class="mb-0">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>Error
              </h4>
            </div>
            <div class="card-body">
              <h5 class="card-title">Something went wrong!</h5>

              <% if(request.getAttribute("errorMessage") != null) { %>
              <div class="alert alert-danger mt-3">
                <p><strong>Error Details:</strong> ${errorMessage}</p>
              </div>
              <% } %> <% if(exception != null) { %>
              <div class="alert alert-danger mt-3">
                <p><strong>Exception:</strong> <%= exception.getMessage() %></p>
                <p>
                  <strong>Type:</strong> <%= exception.getClass().getName() %>
                </p>
              </div>

              <div class="mt-3">
                <p><strong>Stack Trace:</strong></p>
                <pre
                  class="bg-light p-3"
                  style="max-height: 300px; overflow-y: auto"
                >
<% for(StackTraceElement element : exception.getStackTrace()) { %>
<%= element.toString() %>
<% } %>
                  </pre
                >
              </div>
              <% } %>

              <a
                href="${pageContext.request.contextPath}/"
                class="btn btn-primary mt-3"
              >
                <i class="bi bi-house-door me-2"></i>Return to Home Page
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
