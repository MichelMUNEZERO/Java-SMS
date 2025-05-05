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
    <!-- Bootstrap Icons -->
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css"
    />
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
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
        font-family: "Poppins", sans-serif;
        overflow-x: hidden;
      }

      .login-page {
        height: 100vh;
        display: flex;
        align-items: stretch;
      }

      .login-left {
        background: linear-gradient(135deg, #0143a3, #0273d4);
        color: white;
        padding: 3rem;
        display: flex;
        flex-direction: column;
        justify-content: center;
        position: relative;
        overflow: hidden;
      }

      .login-left::before {
        content: "";
        position: absolute;
        width: 200%;
        height: 200%;
        top: -50%;
        left: -50%;
        background: radial-gradient(
          rgba(255, 255, 255, 0.1) 8%,
          transparent 8%
        );
        background-position: 0 0;
        background-size: 30px 30px;
        transform: rotate(30deg);
        z-index: 0;
      }

      .login-left .content {
        position: relative;
        z-index: 1;
      }

      .login-left h2 {
        font-size: 2.5rem;
        font-weight: 700;
        margin-bottom: 1.5rem;
      }

      .login-left p {
        font-size: 1.1rem;
        opacity: 0.9;
        max-width: 80%;
      }

      .login-features {
        margin-top: 2rem;
      }

      .feature-item {
        display: flex;
        align-items: center;
        margin-bottom: 1rem;
      }

      .feature-icon {
        background-color: rgba(255, 255, 255, 0.2);
        width: 40px;
        height: 40px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 1rem;
      }

      .login-right {
        background-color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 2rem;
      }

      .login-container {
        width: 100%;
        max-width: 400px;
        padding: 2rem;
      }

      .login-header {
        text-align: center;
        margin-bottom: 2.5rem;
      }

      .login-header h1 {
        color: #0d6efd;
        font-weight: 700;
        font-size: 1.8rem;
        margin-bottom: 0.5rem;
      }

      .logo {
        max-width: 100px;
        margin-bottom: 1rem;
      }

      .input-group {
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 3px 15px rgba(0, 0, 0, 0.05);
        margin-bottom: 1.5rem;
        transition: all 0.3s ease;
      }

      .input-group:focus-within {
        box-shadow: 0 5px 15px rgba(13, 110, 253, 0.15);
      }

      .input-group-text {
        background-color: white;
        border-right: none;
        color: #6c757d;
      }

      .form-control {
        border-left: none;
        padding: 0.75rem 0.75rem;
        font-size: 1rem;
      }

      .form-control:focus {
        box-shadow: none;
      }

      .form-label {
        font-weight: 500;
        margin-bottom: 0.5rem;
        font-size: 0.9rem;
      }

      .btn-login {
        width: 100%;
        padding: 0.75rem;
        font-weight: 600;
        border-radius: 10px;
        background: linear-gradient(to right, #0143a3, #0273d4);
        border: none;
        box-shadow: 0 5px 15px rgba(13, 110, 253, 0.3);
        transition: all 0.3s ease;
      }

      .btn-login:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 15px rgba(13, 110, 253, 0.4);
      }

      .alert {
        border-radius: 10px;
        border: none;
        padding: 1rem;
        margin-bottom: 1.5rem;
        font-weight: 500;
      }

      .alert-danger {
        background-color: #fff2f2;
        color: #e74c3c;
      }

      .alert-success {
        background-color: #f0fff4;
        color: #2ecc71;
      }

      .forgot-password {
        text-align: center;
        margin-top: 1.5rem;
      }

      .forgot-password a {
        color: #0d6efd;
        font-weight: 500;
        text-decoration: none;
        transition: color 0.3s;
      }

      .forgot-password a:hover {
        color: #0143a3;
        text-decoration: underline;
      }

      @media (max-width: 992px) {
        .login-left {
          display: none;
        }
      }
    </style>
  </head>
  <body>
    <div class="login-page">
      <!-- Left side with info and features -->
      <div class="col-lg-6 login-left d-none d-lg-flex">
        <div class="content">
          <h2>Welcome to School MS</h2>
          <p>
            A comprehensive solution for educational institutions to manage all
            aspects of school operations efficiently.
          </p>

          <div class="login-features">
            <div class="feature-item">
              <div class="feature-icon">
                <i class="bi bi-person-check"></i>
              </div>
              <div>Student & Staff Management</div>
            </div>
            <div class="feature-item">
              <div class="feature-icon">
                <i class="bi bi-journal-check"></i>
              </div>
              <div>Course & Curriculum Tracking</div>
            </div>
            <div class="feature-item">
              <div class="feature-icon">
                <i class="bi bi-graph-up"></i>
              </div>
              <div>Performance Analytics</div>
            </div>
            <div class="feature-item">
              <div class="feature-icon">
                <i class="bi bi-heart-pulse"></i>
              </div>
              <div>Health Services Integration</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Right side with login form -->
      <div class="col-lg-6 login-right">
        <div class="login-container">
          <div class="login-header">
            <div class="mb-4">
              <i
                class="bi bi-building text-primary"
                style="font-size: 3rem"
              ></i>
            </div>
            <h1>School Management System</h1>
            <p class="text-muted">Sign in to access your account</p>
          </div>

          <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
              <i class="bi bi-exclamation-circle me-2"></i>${error}
            </div>
          </c:if>

          <c:if test="${not empty message}">
            <div class="alert alert-success" role="alert">
              <i class="bi bi-check-circle me-2"></i>${message}
            </div>
          </c:if>

          <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="mb-4">
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
                Sign In <i class="bi bi-arrow-right ms-1"></i>
              </button>
            </div>

            <div class="forgot-password">
              <a href="#">Forgot password?</a>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
