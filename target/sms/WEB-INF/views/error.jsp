<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
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
    <div class="container">
      <div class="row justify-content-center mt-5">
        <div class="col-md-8">
          <div class="card">
            <div class="card-header bg-danger text-white">
              <h4 class="mb-0">Error</h4>
            </div>
            <div class="card-body">
              <div class="text-center mb-4">
                <i
                  class="bi bi-exclamation-triangle-fill text-danger"
                  style="font-size: 4rem"
                ></i>
              </div>
              <h5 class="text-center mb-4">Something went wrong!</h5>

              <c:if test="${not empty error}">
                <div class="alert alert-danger">
                  <strong>Error Details:</strong> ${error}
                </div>
              </c:if>

              <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                  <strong>Error Message:</strong> ${errorMessage}
                </div>
              </c:if>

              <div class="text-center mt-4">
                <a
                  href="${pageContext.request.contextPath}/teacher/dashboard"
                  class="btn btn-primary"
                >
                  <i class="bi bi-house-door me-2"></i> Return to Dashboard
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
