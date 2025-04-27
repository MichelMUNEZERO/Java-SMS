<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Announcements - School Management System</title>
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
    <style>
      .dashboard-card {
        transition: transform 0.3s;
        border-radius: 10px;
        border: none;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        height: 100%;
      }

      .dashboard-card:hover {
        transform: translateY(-5px);
      }

      .announcement-card {
        transition: transform 0.2s;
        border-radius: 10px;
        border: none;
        box-shadow: 0 0.25rem 0.5rem rgba(0, 0, 0, 0.1);
        margin-bottom: 1.5rem;
      }

      .announcement-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
      }

      .announcement-date {
        font-size: 0.85rem;
        color: #6c757d;
      }

      .target-badge {
        font-size: 0.75rem;
        padding: 0.25rem 0.5rem;
        border-radius: 15px;
      }
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
        <!-- Sidebar -->
        <div
          class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse"
          style="min-height: 100vh"
        >
          <div class="position-sticky pt-3">
            <div class="d-flex align-items-center justify-content-center mb-4">
              <img
                src="${pageContext.request.contextPath}/images/school-logo.png"
                alt="School Logo"
                width="50"
                class="me-2"
              />
              <span class="fs-4 text-white">School MS</span>
            </div>
            <hr class="text-white" />
            <ul class="nav flex-column">
              <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/parent/dashboard">
                  <i class="bi bi-speedometer2 me-2"></i> Dashboard
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/parent/student-progress">
                  <i class="bi bi-people me-2"></i> My Children
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/parent/student-progress">
                  <i class="bi bi-card-checklist me-2"></i> Academic Progress
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link active text-white" href="${pageContext.request.contextPath}/parent/announcements">
                  <i class="bi bi-megaphone me-2"></i> Announcements
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/parent/appointments">
                  <i class="bi bi-calendar-check me-2"></i> Book Appointments
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="#">
                  <i class="bi bi-person me-2"></i> Profile
                </a>
              </li>
              <li class="nav-item mt-5">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/logout"
                >
                  <i class="bi bi-box-arrow-right me-2"></i> Logout
                </a>
              </li>
            </ul>
          </div>
        </div>

        <!-- Main content -->
        <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 mt-4">
          <div
            class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom"
          >
            <h1 class="h2">Announcements</h1>
            <div class="btn-toolbar mb-2 mb-md-0">
              <div class="dropdown">
                <a
                  class="btn btn-sm btn-outline-secondary dropdown-toggle"
                  href="#"
                  role="button"
                  id="dropdownMenuLink"
                  data-bs-toggle="dropdown"
                  aria-expanded="false"
                >
                  <i class="bi bi-person-circle me-1"></i> ${user.username}
                </a>
                <ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
                  <li>
                    <a class="dropdown-item" href="#"
                      ><i class="bi bi-person me-2"></i> Profile</a
                    >
                  </li>
                  <li>
                    <a class="dropdown-item" href="#"
                      ><i class="bi bi-gear me-2"></i> Settings</a
                    >
                  </li>
                  <li><hr class="dropdown-divider" /></li>
                  <li>
                    <a
                      class="dropdown-item"
                      href="${pageContext.request.contextPath}/logout"
                      ><i class="bi bi-box-arrow-right me-2"></i> Logout</a
                    >
                  </li>
                </ul>
              </div>
            </div>
          </div>

          <!-- Announcements Header -->
          <div class="row mb-4">
            <div class="col-md-12">
              <div class="card dashboard-card">
                <div class="card-body">
                  <div class="d-flex justify-content-between align-items-center">
                    <div>
                      <h5 class="card-title mb-0">School Announcements</h5>
                      <p class="text-muted mb-0">Stay updated with the latest announcements from the school</p>
                    </div>
                    <div>
                      <span class="badge bg-info me-2 target-badge">All</span>
                      <span class="badge bg-primary target-badge">Parents</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Announcements List -->
          <div class="row">
            <div class="col-md-12">
              <c:if test="${empty announcements}">
                <div class="alert alert-info">
                  <i class="bi bi-info-circle me-2"></i>
                  There are no announcements at this time.
                </div>
              </c:if>

              <c:forEach var="announcement" items="${announcements}">
                <div class="card announcement-card">
                  <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                      <h5 class="card-title mb-0">${announcement.title}</h5>
                      <span class="badge 
                        <c:choose>
                          <c:when test="${announcement.targetGroup == 'all'}">bg-info</c:when>
                          <c:when test="${announcement.targetGroup == 'parent'}">bg-primary</c:when>
                          <c:when test="${announcement.targetGroup == 'teacher'}">bg-success</c:when>
                          <c:when test="${announcement.targetGroup == 'student'}">bg-warning</c:when>
                          <c:otherwise>bg-secondary</c:otherwise>
                        </c:choose> target-badge">
                        ${announcement.targetGroup}
                      </span>
                    </div>
                    <p class="card-text">${announcement.message}</p>
                    <div class="d-flex justify-content-between align-items-center mt-3">
                      <span class="announcement-date">
                        <i class="bi bi-calendar3 me-1"></i>
                        <fmt:formatDate value="${announcement.date}" pattern="MMMM d, yyyy"/>
                      </span>
                      <span class="text-muted small">
                        Posted by: ${announcement.postedBy}
                      </span>
                    </div>
                  </div>
                </div>
              </c:forEach>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html> 