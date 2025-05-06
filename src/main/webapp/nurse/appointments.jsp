<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Nurse Appointments - School Management System</title>

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

    <!-- DataTables CSS -->
    <link
      rel="stylesheet"
      href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css"
    />

    <!-- Custom CSS -->
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/admin-styles.css"
    />

    <style>
      body {
        font-family: "Poppins", sans-serif;
        background-color: #f8f9fc;
      }

      .content-card {
        transition: transform 0.3s;
        border-radius: 0.75rem;
        border: none;
        box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        margin-bottom: 1.5rem;
      }

      .content-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 0.3rem 2rem rgba(0, 0, 0, 0.1);
      }

      .card-header {
        background-color: white;
        border-bottom: 1px solid #e9ecef;
        padding: 1rem 1.5rem;
        font-weight: 500;
      }

      .breadcrumb {
        background-color: transparent;
        padding: 0;
      }

      .breadcrumb-item a {
        color: #4e73df;
        text-decoration: none;
      }

      .page-title {
        font-weight: 600;
        color: #5a5c69;
        margin-bottom: 1rem;
      }

      .btn-primary {
        background-color: #4e73df;
        border-color: #4e73df;
      }

      .btn-primary:hover {
        background-color: #4262c5;
        border-color: #3d5cb8;
      }

      .status-badge {
        font-size: 0.75rem;
        padding: 0.25rem 0.5rem;
        border-radius: 50rem;
        font-weight: 500;
      }

      .today-appointment {
        background-color: rgba(78, 115, 223, 0.1);
        border-left: 4px solid #4e73df;
        transition: all 0.3s;
      }

      .today-appointment:hover {
        background-color: rgba(78, 115, 223, 0.15);
      }
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
        <!-- Sidebar - same as nurse_dashboard.jsp -->
        <nav
          id="sidebar"
          class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse"
        >
          <div class="position-sticky pt-3">
            <div
              class="d-flex align-items-center pb-3 mb-3 border-bottom border-secondary"
            >
              <a
                href="${pageContext.request.contextPath}/dashboard"
                class="d-flex align-items-center text-white text-decoration-none"
              >
                <i class="bi bi-hospital fs-4 me-2"></i>
                <span class="fs-5 fw-semibold">School MS</span>
              </a>
            </div>

            <ul class="nav flex-column">
              <li class="nav-item">
                <a
                  class="nav-link text-white d-flex align-items-center py-2"
                  href="${pageContext.request.contextPath}/nurse/dashboard"
                >
                  <i class="bi bi-speedometer2 me-2"></i>
                  Dashboard
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white d-flex align-items-center py-2"
                  href="${pageContext.request.contextPath}/nurse/diagnosed-students"
                >
                  <i class="bi bi-clipboard-pulse me-2"></i>
                  Diagnosed Students
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white d-flex align-items-center py-2"
                  href="${pageContext.request.contextPath}/nurse/students"
                >
                  <i class="bi bi-person-vcard me-2"></i>
                  Student Health Records
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link active text-white d-flex align-items-center py-2"
                  href="${pageContext.request.contextPath}/nurse/appointments"
                >
                  <i class="bi bi-calendar-check me-2"></i>
                  Appointments
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white d-flex align-items-center py-2"
                  href="${pageContext.request.contextPath}/nurse/new-diagnosis"
                >
                  <i class="bi bi-journal-medical me-2"></i>
                  New Diagnosis
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white d-flex align-items-center py-2"
                  href="${pageContext.request.contextPath}/nurse/profile"
                >
                  <i class="bi bi-person-circle me-2"></i>
                  My Profile
                </a>
              </li>
              <li class="nav-item mt-3">
                <a
                  class="nav-link text-white d-flex align-items-center py-2"
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
        <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
          <!-- Breadcrumb -->
          <nav aria-label="breadcrumb" class="mt-3">
            <ol class="breadcrumb">
              <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/dashboard">Home</a>
              </li>
              <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/nurse/dashboard"
                  >Nurse Dashboard</a
                >
              </li>
              <li class="breadcrumb-item active" aria-current="page">
                Appointments
              </li>
            </ol>
          </nav>

          <!-- Page Header -->
          <div
            class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-2 mb-4 border-bottom"
          >
            <h1 class="page-title h2">My Appointments</h1>
            <div class="btn-toolbar mb-2 mb-md-0">
              <a
                href="${pageContext.request.contextPath}/nurse/appointments/new"
                class="btn btn-sm btn-primary"
              >
                <i class="bi bi-plus-circle me-1"></i> Schedule Appointment
              </a>
            </div>
          </div>

          <!-- Alerts -->
          <c:if test="${not empty error}">
            <div
              class="alert alert-danger alert-dismissible fade show"
              role="alert"
            >
              ${error}
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
                aria-label="Close"
              ></button>
            </div>
          </c:if>
          <c:if test="${not empty message}">
            <div
              class="alert alert-success alert-dismissible fade show"
              role="alert"
            >
              ${message}
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
                aria-label="Close"
              ></button>
            </div>
          </c:if>

          <!-- Today's Appointments -->
          <div class="card content-card mb-4">
            <div class="card-header">
              <i class="bi bi-calendar-day me-1"></i> Today's Appointments
            </div>
            <div class="card-body">
              <c:if test="${empty todayAppointments}">
                <div class="text-center py-4">
                  <i
                    class="bi bi-calendar-x text-muted"
                    style="font-size: 2.5rem"
                  ></i>
                  <p class="mt-3 mb-0 text-muted">
                    No appointments scheduled for today.
                  </p>
                </div>
              </c:if>

              <c:if test="${not empty todayAppointments}">
                <div class="row">
                  <c:forEach items="${todayAppointments}" var="apt">
                    <div class="col-md-6 mb-3">
                      <div class="card today-appointment h-100">
                        <div class="card-body">
                          <div
                            class="d-flex justify-content-between align-items-center mb-3"
                          >
                            <span class="text-primary fw-semibold">
                              <i class="bi bi-clock me-1"></i>
                              <fmt:formatDate
                                value="${apt.appointmentTime}"
                                pattern="hh:mm a"
                              />
                            </span>
                            <c:choose>
                              <c:when test="${apt.status eq 'Scheduled'}">
                                <span class="badge bg-warning status-badge"
                                  >Scheduled</span
                                >
                              </c:when>
                              <c:when test="${apt.status eq 'Completed'}">
                                <span class="badge bg-success status-badge"
                                  >Completed</span
                                >
                              </c:when>
                              <c:when test="${apt.status eq 'Cancelled'}">
                                <span class="badge bg-danger status-badge"
                                  >Cancelled</span
                                >
                              </c:when>
                              <c:otherwise>
                                <span class="badge bg-secondary status-badge"
                                  >${apt.status}</span
                                >
                              </c:otherwise>
                            </c:choose>
                          </div>

                          <h5 class="card-title mb-2">${apt.studentName}</h5>
                          <p class="text-muted mb-3">${apt.purpose}</p>

                          <c:if test="${not empty apt.doctorName}">
                            <div class="mb-2">
                              <small class="text-muted">Doctor:</small>
                              <span class="ms-1">${apt.doctorName}</span>
                            </div>
                          </c:if>

                          <div class="d-flex mt-3">
                            <a
                              href="${pageContext.request.contextPath}/nurse/appointments/edit?id=${apt.appointmentId}"
                              class="btn btn-sm btn-outline-primary me-2"
                            >
                              <i class="bi bi-pencil"></i> Update
                            </a>
                            <a
                              href="${pageContext.request.contextPath}/nurse/appointments/complete?id=${apt.appointmentId}"
                              class="btn btn-sm btn-outline-success"
                            >
                              <i class="bi bi-check-circle"></i> Complete
                            </a>
                          </div>
                        </div>
                      </div>
                    </div>
                  </c:forEach>
                </div>
              </c:if>
            </div>
          </div>

          <!-- All Appointments Table -->
          <div class="card content-card">
            <div class="card-header">
              <i class="bi bi-calendar-week me-1"></i> All Appointments
            </div>
            <div class="card-body">
              <table
                id="appointmentsTable"
                class="table table-striped table-hover"
              >
                <thead>
                  <tr>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Student</th>
                    <th>Purpose</th>
                    <th>Doctor</th>
                    <th>Status</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach items="${appointments}" var="apt">
                    <tr>
                      <td>
                        <fmt:formatDate
                          value="${apt.appointmentDate}"
                          pattern="MM/dd/yyyy"
                        />
                      </td>
                      <td>
                        <fmt:formatDate
                          value="${apt.appointmentTime}"
                          pattern="hh:mm a"
                        />
                      </td>
                      <td>${apt.studentName}</td>
                      <td>${apt.purpose}</td>
                      <td>
                        ${apt.doctorName != null ? apt.doctorName : 'Not
                        Assigned'}
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${apt.status eq 'Scheduled'}">
                            <span class="badge bg-warning">Scheduled</span>
                          </c:when>
                          <c:when test="${apt.status eq 'Completed'}">
                            <span class="badge bg-success">Completed</span>
                          </c:when>
                          <c:when test="${apt.status eq 'Cancelled'}">
                            <span class="badge bg-danger">Cancelled</span>
                          </c:when>
                          <c:otherwise>
                            <span class="badge bg-secondary"
                              >${apt.status}</span
                            >
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <div class="btn-group">
                          <a
                            href="${pageContext.request.contextPath}/nurse/appointments/view?id=${apt.appointmentId}"
                            class="btn btn-sm btn-info"
                          >
                            <i class="bi bi-eye"></i>
                          </a>
                          <a
                            href="${pageContext.request.contextPath}/nurse/appointments/edit?id=${apt.appointmentId}"
                            class="btn btn-sm btn-warning"
                          >
                            <i class="bi bi-pencil"></i>
                          </a>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- JavaScript Dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>

    <!-- Initialize DataTables -->
    <script>
      $(document).ready(function () {
        $("#appointmentsTable").DataTable({
          order: [
            [0, "desc"],
            [1, "asc"],
          ], // Sort by date desc, then time asc
          pageLength: 10,
          lengthMenu: [5, 10, 25, 50],
          language: {
            search: "Search appointments:",
            zeroRecords: "No appointments found",
          },
        });
      });
    </script>
  </body>
</html>
