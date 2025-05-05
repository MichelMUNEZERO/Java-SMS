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
          class="bi bi-building me-2 text-primary"
          style="font-size: 1.8rem"
        ></i>
        <span class="fs-4 fw-bold text-white" style="letter-spacing: 0.5px"
          >School MS</span
        >
      </div>
    </div>
    <hr class="text-secondary mx-3 my-4" style="opacity: 0.3" />

    <div class="px-3">
      <ul class="nav flex-column gap-1">
        <li class="nav-item">
          <a
            class="nav-link ${pageContext.request.requestURI.contains('/admin/dashboard') ? 'active-nav-link' : ''}"
            href="${pageContext.request.contextPath}/admin/dashboard"
          >
            <i class="bi bi-speedometer2 me-3"></i> Dashboard
          </a>
        </li>
        <li class="nav-item">
          <a
            class="nav-link ${pageContext.request.requestURI.contains('/admin/students') ? 'active-nav-link' : ''}"
            href="${pageContext.request.contextPath}/admin/students"
          >
            <i class="bi bi-person me-3"></i> Students
          </a>
        </li>
        <li class="nav-item">
          <a
            class="nav-link ${pageContext.request.requestURI.contains('/admin/teachers') ? 'active-nav-link' : ''}"
            href="${pageContext.request.contextPath}/admin/teachers"
          >
            <i class="bi bi-person-badge me-3"></i> Teachers
          </a>
        </li>
        <li class="nav-item">
          <a
            class="nav-link ${pageContext.request.requestURI.contains('/admin/parents') ? 'active-nav-link' : ''}"
            href="${pageContext.request.contextPath}/admin/parents"
          >
            <i class="bi bi-people me-3"></i> Parents
          </a>
        </li>
        <li class="nav-item">
          <a
            class="nav-link ${pageContext.request.requestURI.contains('/admin/courses') ? 'active-nav-link' : ''}"
            href="${pageContext.request.contextPath}/admin/courses"
          >
            <i class="bi bi-book me-3"></i> Courses
          </a>
        </li>
        <li class="nav-item">
          <a
            class="nav-link ${pageContext.request.requestURI.contains('/admin/doctors') ? 'active-nav-link' : ''}"
            href="${pageContext.request.contextPath}/admin/doctors"
          >
            <i class="bi bi-heart-pulse me-3"></i> Doctors
          </a>
        </li>
        <li class="nav-item">
          <a
            class="nav-link ${pageContext.request.requestURI.contains('/admin/nurses') ? 'active-nav-link' : ''}"
            href="${pageContext.request.contextPath}/admin/nurses"
          >
            <i class="bi bi-bandaid me-3"></i> Nurses
          </a>
        </li>
        <li class="nav-item">
          <a
            class="nav-link ${pageContext.request.requestURI.contains('/admin/announcements') ? 'active-nav-link' : ''}"
            href="${pageContext.request.contextPath}/admin/announcements"
          >
            <i class="bi bi-megaphone me-3"></i> Announcements
          </a>
        </li>
        <li class="nav-item">
          <a
            class="nav-link ${pageContext.request.requestURI.contains('/admin/appointments') ? 'active-nav-link' : ''}"
            href="${pageContext.request.contextPath}/admin/appointments"
          >
            <i class="bi bi-calendar-check me-3"></i> Appointments
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
