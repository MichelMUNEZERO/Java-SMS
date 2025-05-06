<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %>

<!-- Sidebar -->
<nav id="sidebar" class="col-md-3 col-lg-2 d-md-block bg-dark sidebar">
  <div class="position-sticky pt-3">
    <ul class="nav flex-column">
      <li class="nav-item">
        <a
          class="nav-link"
          href="${pageContext.request.contextPath}/admin/dashboard"
        >
          <i class="bi bi-speedometer2 me-2"></i>
          Dashboard
        </a>
      </li>
      <li class="nav-item">
        <a
          class="nav-link active"
          href="${pageContext.request.contextPath}/admin/students"
        >
          <i class="bi bi-people me-2"></i>
          Students
        </a>
      </li>
      <li class="nav-item">
        <a
          class="nav-link"
          href="${pageContext.request.contextPath}/admin/teachers"
        >
          <i class="bi bi-person-badge me-2"></i>
          Teachers
        </a>
      </li>
      <li class="nav-item">
        <a
          class="nav-link"
          href="${pageContext.request.contextPath}/admin/parents"
        >
          <i class="bi bi-person-lines-fill me-2"></i>
          Parents
        </a>
      </li>
      <li class="nav-item">
        <a
          class="nav-link"
          href="${pageContext.request.contextPath}/admin/courses"
        >
          <i class="bi bi-book me-2"></i>
          Courses
        </a>
      </li>
      <li class="nav-item">
        <a
          class="nav-link"
          href="${pageContext.request.contextPath}/admin/announcements"
        >
          <i class="bi bi-megaphone me-2"></i>
          Announcements
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}/logout">
          <i class="bi bi-box-arrow-right me-2"></i>
          Logout
        </a>
      </li>
    </ul>
  </div>
</nav>
