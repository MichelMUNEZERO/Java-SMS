<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login - School Management System</title>
    <!-- Bootstrap CSS -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <!-- Custom CSS -->
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />
    <style>
      body {
        background-color: #f8f9fa;
        height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
      }
      .login-container {
        max-width: 400px;
        padding: 2rem;
        background-color: #ffffff;
        border-radius: 10px;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
      }
      .login-header {
        text-align: center;
        margin-bottom: 2rem;
      }
      .login-header h1 {
        color: #0d6efd;
        font-weight: 700;
      }
      .logo {
        max-width: 100px;
        margin-bottom: 1rem;
      }
      .btn-login {
        width: 100%;
        padding: 0.75rem;
        font-weight: 600;
      }
      .alert {
        margin-bottom: 1.5rem;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="row justify-content-center">
        <div class="col-md-6 login-container">
          <div class="login-header">
            <img
              src="${pageContext.request.contextPath}/images/school-logo.png"
              alt="School Logo"
              class="logo"
            />
            <h1>School Management System</h1>
            <p class="text-muted">
              Enter your credentials to access the system
            </p>
          </div>

          <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">${error}</div>
          </c:if>

          <c:if test="${not empty message}">
            <div class="alert alert-success" role="alert">${message}</div>
          </c:if>

          <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="mb-3">
              <label for="username" class="form-label">Username</label>
              <div class="input-group">
                <span class="input-group-text"
                  ><i class="bi bi-person-fill"></i
                ></span>
                <input
                  type="text"
                  class="form-control"
                  id="username"
                  name="username"
                  placeholder="Enter your username"
                  required
                />
              </div>
            </div>

            <div class="mb-4">
              <label for="password" class="form-label">Password</label>
              <div class="input-group">
                <span class="input-group-text"
                  ><i class="bi bi-lock-fill"></i
                ></span>
                <input
                  type="password"
                  class="form-control"
                  id="password"
                  name="password"
                  placeholder="Enter your password"
                  required
                />
              </div>
            </div>

            <div class="mb-3">
              <button type="submit" class="btn btn-primary btn-login">
                Login
              </button>
            </div>

            <div class="text-center">
              <a href="#" class="text-decoration-none">Forgot password?</a>
            </div>
          </form>
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
