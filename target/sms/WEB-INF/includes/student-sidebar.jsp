<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Sidebar -->
<div
  class="col-md-3 col-lg-2 d-md-block sidebar collapse"
  style="
    min-height: 100vh;
    background: linear-gradient(180deg, #1e2a3a 0%, #11161f 100%);
    box-shadow: 3px 0 10px rgba(0, 0, 0, 0.1);
    z-index: 100;
  "
>
  <div class="position-sticky pt-4">
    <div class="d-flex justify-content-center mb-4 px-3">
      <div class="d-flex align-items-center">
        <i
          class="bi bi-mortarboard me-2 text-primary"
          style="font-size: 1.8rem"
        ></i>
        <span class="fs-4 fw-bold text-white" style="letter-spacing: 0.5px"
          >School MS</span
        >
      </div>
    </div>

    <!-- Student Profile Widget -->
    <div class="text-center mb-4 px-3">
      <div
        class="avatar-circle mx-auto mb-3 d-flex align-items-center justify-content-center bg-primary"
        style="width: 70px; height: 70px; border-radius: 50%"
      >
        <c:choose>
          <c:when test="${not empty profileData.imageLink}">
            <img
              src="${profileData.imageLink}"
              alt="Student Avatar"
              class="w-100 h-100 rounded-circle"
              style="object-fit: cover"
            />
          </c:when>
          <c:otherwise>
            <i class="bi bi-person-fill text-white" style="font-size: 2rem"></i>
          </c:otherwise>
        </c:choose>
      </div>
      <div class="text-white">
        <p class="mb-0 fw-medium">${user.username}</p>
        <small class="text-muted">${user.email}</small>
      </div>
    </div>

    <hr class="text-secondary mx-3 my-4" style="opacity: 0.3" />

    <div class="px-3">
      <ul class="nav flex-column gap-1">
        <li class="nav-item">
          <a
            class="nav-link ${pageContext.request.requestURI.contains('/student/dashboard') || pageContext.request.requestURI.contains('student_dashboard.jsp') ? 'active-nav-link' : ''}"
            href="${pageContext.request.contextPath}/student/dashboard"
          >
            <i class="bi bi-speedometer2 me-3"></i> Dashboard
          </a>
        </li>
        <li class="nav-item">
          <a
            class="nav-link ${pageContext.request.requestURI.contains('/student/courses') ? 'active-nav-link' : ''}"
            href="${pageContext.request.contextPath}/student/courses"
          >
            <i class="bi bi-book me-3"></i> My Courses
          </a>
        </li>
        <li class="nav-item">
          <a
            class="nav-link ${pageContext.request.requestURI.contains('/student/grades') ? 'active-nav-link' : ''}"
            href="${pageContext.request.contextPath}/student/grades"
          >
            <i class="bi bi-card-checklist me-3"></i> Grades
          </a>
        </li>
        <li class="nav-item">
          <a
            class="nav-link ${pageContext.request.requestURI.contains('/student/assignments') ? 'active-nav-link' : ''}"
            href="${pageContext.request.contextPath}/student/assignments"
          >
            <i class="bi bi-file-earmark-text me-3"></i> Assignments
          </a>
        </li>
        <li class="nav-item">
          <a
            class="nav-link ${pageContext.request.requestURI.contains('/student/update-parent') ? 'active-nav-link' : ''}"
            href="${pageContext.request.contextPath}/student/update-parent"
          >
            <i class="bi bi-people me-3"></i> Parent Info
          </a>
        </li>
        <li class="nav-item">
          <a
            class="nav-link ${pageContext.request.requestURI.contains('/student/profile') ? 'active-nav-link' : ''}"
            href="${pageContext.request.contextPath}/student/profile"
          >
            <i class="bi bi-person me-3"></i> Profile
          </a>
        </li>
      </ul>
    </div>

    <hr class="text-secondary mx-3 my-4" style="opacity: 0.3" />

    <div class="px-3">
      <ul class="nav flex-column">
        <li class="nav-item">
          <a
            class="nav-link logout-link"
            href="${pageContext.request.contextPath}/logout"
          >
            <i class="bi bi-box-arrow-right me-3"></i> Logout
          </a>
        </li>
      </ul>
    </div>
  </div>
</div>

<style>
  .sidebar .nav-link {
    color: rgba(255, 255, 255, 0.7);
    font-size: 0.95rem;
    font-weight: 500;
    border-radius: 8px;
    padding: 0.8rem 1rem;
    transition: all 0.3s ease;
    margin-bottom: 2px;
  }

  .sidebar .nav-link:hover {
    color: white;
    background-color: rgba(255, 255, 255, 0.1);
  }

  .sidebar .active-nav-link {
    color: white !important;
    background-color: rgba(13, 110, 253, 0.9) !important;
    box-shadow: 0 4px 8px rgba(13, 110, 253, 0.3);
  }

  .sidebar .logout-link {
    color: rgba(255, 255, 255, 0.7);
  }

  .sidebar .logout-link:hover {
    color: #ff5e5e;
    background-color: rgba(255, 94, 94, 0.1);
  }
</style>
