<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Doctor Dashboard - School Management System</title>

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
      body,
      html {
        height: 100%;
      }

      .container-fluid,
      .row {
        min-height: 100vh;
      }

      #sidebar {
        height: 100vh;
        position: fixed;
        z-index: 100;
        padding-top: 20px;
      }

      main {
        margin-left: 16.66%; /* Matches col-md-2 width */
      }

      @media (max-width: 767.98px) {
        #sidebar {
          position: static;
          height: auto;
        }

        main {
          margin-left: 0;
        }
      }

      .stats-card {
        border-radius: 10px;
        padding: 20px;
        margin-bottom: 20px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      }

      .quick-action {
        text-align: center;
        padding: 15px;
        border-radius: 8px;
        transition: all 0.3s ease;
        margin-bottom: 10px;
      }

      .quick-action:hover {
        transform: translateY(-5px);
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
      }

      .card {
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        border-radius: 10px;
        overflow: hidden;
      }

      .card-header {
        background-color: #f8f9fa;
        border-bottom: 1px solid #e9ecef;
      }
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
        <!-- Sidebar -->
        <nav
          id="sidebar"
          class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse"
        >
          <div class="position-sticky">
            <div class="text-center mb-4">
              <img
                src="${pageContext.request.contextPath}/images/logo.png"
                alt="School Logo"
                class="img-fluid rounded-circle mb-3"
                style="max-width: 100px"
              />
              <h5 class="text-white">School Management System</h5>
              <div class="text-white-50 mb-2">Doctor Dashboard</div>
            </div>

            <ul class="nav flex-column">
              <li class="nav-item">
                <a
                  class="nav-link active text-white"
                  href="${pageContext.request.contextPath}/doctor/dashboard"
                >
                  <i class="bi bi-speedometer2 me-2"></i>
                  Dashboard
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/doctor/students"
                >
                  <i class="bi bi-person-vcard me-2"></i>
                  Student Health Records
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/doctor/appointments"
                >
                  <i class="bi bi-calendar-check me-2"></i>
                  Appointments
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/doctor/health-reports"
                >
                  <i class="bi bi-graph-up me-2"></i>
                  Health Reports
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/doctor/profile"
                >
                  <i class="bi bi-person-circle me-2"></i>
                  My Profile
                </a>
              </li>
              <li class="nav-item mt-5">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/logout"
                >
                  <i class="bi bi-box-arrow-right me-2"></i>
                  Logout
                </a>
              </li>
            </ul>
          </div>
        </nav>

        <!-- Main Content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
          <!-- Navbar -->
          <header
            class="navbar navbar-light sticky-top bg-light flex-md-nowrap p-2 border-bottom"
          >
            <a class="navbar-brand col-md-3 col-lg-2 me-0 px-3" href="#">
              <button
                class="btn btn-outline-secondary d-md-none"
                type="button"
                data-bs-toggle="collapse"
                data-bs-target="#sidebar"
              >
                <i class="bi bi-list"></i>
              </button>
              <span class="d-none d-md-inline">School Management System</span>
            </a>

            <ul class="navbar-nav ms-auto">
              <li class="nav-item">
                <div class="dropdown">
                  <a
                    class="nav-link dropdown-toggle text-dark"
                    href="#"
                    role="button"
                    data-bs-toggle="dropdown"
                  >
                    <i class="bi bi-person-circle me-1"></i>
                    <span>Dr. ${sessionScope.user.username}</span>
                  </a>
                  <ul class="dropdown-menu dropdown-menu-end">
                    <li>
                      <a
                        class="dropdown-item"
                        href="${pageContext.request.contextPath}/doctor/profile"
                        ><i class="bi bi-person me-2"></i>Profile</a
                      >
                    </li>
                    <li><hr class="dropdown-divider" /></li>
                    <li>
                      <a
                        class="dropdown-item"
                        href="${pageContext.request.contextPath}/logout"
                        ><i class="bi bi-box-arrow-right me-2"></i>Logout</a
                      >
                    </li>
                  </ul>
                </div>
              </li>
            </ul>
          </header>

          <!-- Dashboard Content -->
          <div class="container-fluid mt-4 mb-5">
            <h2 class="h3 mb-4">Doctor Dashboard</h2>

            <!-- Stats Cards -->
            <div class="row mb-4">
              <div class="col-md-4 mb-3">
                <div class="card bg-primary text-white shadow-sm stats-card">
                  <div class="card-body">
                    <div class="d-flex align-items-center">
                      <i class="bi bi-calendar-check fs-1 me-3"></i>
                      <div>
                        <h6 class="card-title mb-0">Today's Appointments</h6>
                        <h2 class="mb-0">${todayAppointments}</h2>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-md-4 mb-3">
                <div class="card bg-success text-white shadow-sm stats-card">
                  <div class="card-body">
                    <div class="d-flex align-items-center">
                      <i class="bi bi-bandaid fs-1 me-3"></i>
                      <div>
                        <h6 class="card-title mb-0">Active Treatments</h6>
                        <h2 class="mb-0">15</h2>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-md-4 mb-3">
                <div class="card bg-info text-white shadow-sm stats-card">
                  <div class="card-body">
                    <div class="d-flex align-items-center">
                      <i class="bi bi-clipboard2-pulse fs-1 me-3"></i>
                      <div>
                        <h6 class="card-title mb-0">Pending Checkups</h6>
                        <h2 class="mb-0">8</h2>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="row">
              <!-- Recent Announcements -->
              <div class="col-md-6 mb-4">
                <div class="card border-0 shadow-sm h-100">
                  <div class="card-header bg-white">
                    <h5 class="card-title mb-0">Recent Announcements</h5>
                  </div>
                  <div class="card-body">
                    <c:choose>
                      <c:when test="${empty announcements}">
                        <p class="text-muted text-center py-4">
                          No recent announcements
                        </p>
                      </c:when>
                      <c:otherwise>
                        <div class="list-group list-group-flush">
                          <c:forEach
                            var="announcement"
                            items="${announcements}"
                          >
                            <div class="list-group-item px-0">
                              <div
                                class="d-flex justify-content-between align-items-start"
                              >
                                <div>
                                  <h6 class="mb-1">${announcement.title}</h6>
                                  <p class="mb-1 text-muted small">
                                    <fmt:formatDate
                                      value="${announcement.createdAt}"
                                      pattern="MMMM d, yyyy"
                                    />
                                  </p>
                                  <p class="mb-0">${announcement.content}</p>
                                </div>
                              </div>
                            </div>
                          </c:forEach>
                        </div>
                      </c:otherwise>
                    </c:choose>
                  </div>
                </div>
              </div>

              <!-- Quick Actions -->
              <div class="col-md-6 mb-4">
                <div class="card border-0 shadow-sm h-100">
                  <div class="card-header bg-white">
                    <h5 class="card-title mb-0">Quick Actions</h5>
                  </div>
                  <div class="card-body">
                    <div class="row g-3">
                      <div class="col-md-6">
                        <a
                          href="${pageContext.request.contextPath}/doctor/diagnosis/new"
                          class="btn btn-outline-primary w-100 py-3 quick-action"
                        >
                          <i class="bi bi-plus-circle mb-2 d-block fs-4"></i>
                          New Diagnosis
                        </a>
                      </div>
                      <div class="col-md-6">
                        <a
                          href="${pageContext.request.contextPath}/doctor/prescription/new"
                          class="btn btn-outline-info w-100 py-3 quick-action"
                        >
                          <i
                            class="bi bi-file-earmark-medical mb-2 d-block fs-4"
                          ></i>
                          New Prescription
                        </a>
                      </div>
                      <div class="col-md-6">
                        <a
                          href="${pageContext.request.contextPath}/doctor/search-student"
                          class="btn btn-outline-success w-100 py-3 quick-action"
                        >
                          <i class="bi bi-search mb-2 d-block fs-4"></i>
                          Search Student
                        </a>
                      </div>
                      <div class="col-md-6">
                        <a
                          href="${pageContext.request.contextPath}/doctor/health-alert"
                          class="btn btn-outline-danger w-100 py-3 quick-action"
                        >
                          <i
                            class="bi bi-exclamation-triangle mb-2 d-block fs-4"
                          ></i>
                          Health Alert
                        </a>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </main>
      </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/js/script.js"></script>
  </body>
</html>
