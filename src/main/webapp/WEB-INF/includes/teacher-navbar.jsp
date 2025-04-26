<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container-fluid">
    <a
      class="navbar-brand"
      href="${pageContext.request.contextPath}/teacher/dashboard"
    >
      <i class="fas fa-school me-2"></i>School Management System
    </a>
    <button
      class="navbar-toggler"
      type="button"
      data-bs-toggle="collapse"
      data-bs-target="#teacherNavbar"
      aria-controls="teacherNavbar"
      aria-expanded="false"
      aria-label="Toggle navigation"
    >
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="teacherNavbar">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item">
          <a
            class="nav-link"
            href="${pageContext.request.contextPath}/teacher/dashboard"
          >
            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
          </a>
        </li>
        <li class="nav-item">
          <a
            class="nav-link"
            href="${pageContext.request.contextPath}/teacher/courses"
          >
            <i class="fas fa-book me-1"></i>Courses
          </a>
        </li>
        <li class="nav-item">
          <a
            class="nav-link"
            href="${pageContext.request.contextPath}/teacher/students"
          >
            <i class="fas fa-user-graduate me-1"></i>Students
          </a>
        </li>
        <li class="nav-item">
          <a
            class="nav-link"
            href="${pageContext.request.contextPath}/teacher/marks"
          >
            <i class="fas fa-chart-line me-1"></i>Marks
          </a>
        </li>
        <li class="nav-item">
          <a
            class="nav-link active"
            href="${pageContext.request.contextPath}/teacher/behavior"
          >
            <i class="fas fa-clipboard-list me-1"></i>Behavior
          </a>
        </li>
      </ul>

      <ul class="navbar-nav ms-auto">
        <li class="nav-item dropdown">
          <a
            class="nav-link dropdown-toggle"
            href="#"
            id="userDropdown"
            role="button"
            data-bs-toggle="dropdown"
            aria-expanded="false"
          >
            <i class="fas fa-user-circle me-1"></i>${user.username}
          </a>
          <ul
            class="dropdown-menu dropdown-menu-end"
            aria-labelledby="userDropdown"
          >
            <li>
              <a
                class="dropdown-item"
                href="${pageContext.request.contextPath}/profile"
              >
                <i class="fas fa-id-card me-1"></i>Profile
              </a>
            </li>
            <li><hr class="dropdown-divider" /></li>
            <li>
              <a
                class="dropdown-item"
                href="${pageContext.request.contextPath}/logout"
              >
                <i class="fas fa-sign-out-alt me-1"></i>Logout
              </a>
            </li>
          </ul>
        </li>
      </ul>
    </div>
  </div>
</nav>
