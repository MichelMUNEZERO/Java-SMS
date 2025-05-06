<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Doctor Appointments - School Management System</title>

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

      .badge {
        font-weight: 600;
        font-size: 0.75rem;
        padding: 0.35em 0.65em;
      }

      .status-badge {
        padding: 0.35rem 0.65rem;
        border-radius: 50px;
        font-weight: 600;
        font-size: 0.75rem;
      }
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
        <!-- Include Doctor Sidebar -->
        <jsp:include page="/WEB-INF/includes/doctor-sidebar.jsp" />

        <!-- Main Content -->
        <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
          <!-- Breadcrumb -->
          <nav aria-label="breadcrumb" class="mt-3">
            <ol class="breadcrumb">
              <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/dashboard">Home</a>
              </li>
              <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/doctor/dashboard"
                  >Doctor Dashboard</a
                >
              </li>
              <li class="breadcrumb-item active" aria-current="page">
                Appointments
              </li>
            </ol>
          </nav>

          <div
            class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center"
          >
            <h1 class="page-title">Appointments</h1>
            <div class="btn-toolbar mb-2 mb-md-0">
              <button
                type="button"
                class="btn btn-primary me-2"
                data-bs-toggle="modal"
                data-bs-target="#newAppointmentModal"
              >
                <i class="bi bi-plus-circle me-1"></i> New Appointment
              </button>
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

          <!-- Stats Summary Cards -->
          <div class="row mb-4">
            <div class="col-md-4 mb-3">
              <div class="content-card h-100">
                <div class="card-body p-4">
                  <div class="d-flex justify-content-between mb-3">
                    <div class="bg-primary bg-opacity-10 p-3 rounded">
                      <i
                        class="bi bi-calendar-check text-primary"
                        style="font-size: 1.8rem"
                      ></i>
                    </div>
                    <h2 class="text-primary mb-0">${todayAppointments}</h2>
                  </div>
                  <h5 class="text-muted mb-3">Today's Appointments</h5>
                  <div class="progress">
                    <div
                      class="progress-bar bg-primary"
                      role="progressbar"
                      style="width: ${(todayAppointments / 10) * 100}%;"
                    ></div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-3">
              <div class="content-card h-100">
                <div class="card-body p-4">
                  <div class="d-flex justify-content-between mb-3">
                    <div class="bg-success bg-opacity-10 p-3 rounded">
                      <i
                        class="bi bi-check-circle text-success"
                        style="font-size: 1.8rem"
                      ></i>
                    </div>
                    <h2 class="text-success mb-0">15</h2>
                  </div>
                  <h5 class="text-muted mb-3">Completed Checkups</h5>
                  <div class="progress">
                    <div
                      class="progress-bar bg-success"
                      role="progressbar"
                      style="width: 75%"
                    ></div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-3">
              <div class="content-card h-100">
                <div class="card-body p-4">
                  <div class="d-flex justify-content-between mb-3">
                    <div class="bg-warning bg-opacity-10 p-3 rounded">
                      <i
                        class="bi bi-hourglass-split text-warning"
                        style="font-size: 1.8rem"
                      ></i>
                    </div>
                    <h2 class="text-warning mb-0">8</h2>
                  </div>
                  <h5 class="text-muted mb-3">Pending Appointments</h5>
                  <div class="progress">
                    <div
                      class="progress-bar bg-warning"
                      role="progressbar"
                      style="width: 40%"
                    ></div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Filter Section -->
          <div class="content-card mb-4">
            <div class="card-body p-4">
              <div class="row g-3">
                <div class="col-md-4">
                  <label for="dateFilter" class="form-label">Date Range</label>
                  <select class="form-select" id="dateFilter">
                    <option value="all">All Dates</option>
                    <option value="today">Today</option>
                    <option value="tomorrow">Tomorrow</option>
                    <option value="thisWeek">This Week</option>
                    <option value="nextWeek">Next Week</option>
                    <option value="thisMonth">This Month</option>
                  </select>
                </div>
                <div class="col-md-4">
                  <label for="statusFilter" class="form-label">Status</label>
                  <select class="form-select" id="statusFilter">
                    <option value="all">All Statuses</option>
                    <option value="pending">Pending</option>
                    <option value="confirmed">Confirmed</option>
                    <option value="completed">Completed</option>
                    <option value="cancelled">Cancelled</option>
                  </select>
                </div>
                <div class="col-md-4">
                  <label for="searchInput" class="form-label">Search</label>
                  <div class="input-group">
                    <input
                      type="text"
                      class="form-control"
                      id="searchInput"
                      placeholder="Student name, purpose..."
                    />
                    <button class="btn btn-primary" type="button">
                      <i class="bi bi-search"></i>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Appointments Table -->
          <div class="content-card">
            <div
              class="card-header d-flex justify-content-between align-items-center"
            >
              <h5 class="mb-0">
                <i class="bi bi-calendar-date me-2 text-primary"></i>
                Appointment Schedule
              </h5>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-hover" id="appointmentsTable">
                  <thead>
                    <tr>
                      <th>Date & Time</th>
                      <th>Student</th>
                      <th>Purpose</th>
                      <th>Status</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:choose>
                      <c:when
                        test="${not empty appointments && appointments.size() > 0}"
                      >
                        <c:forEach var="appointment" items="${appointments}">
                          <tr>
                            <td>
                              <div class="d-flex flex-column">
                                <span class="fw-medium"
                                  ><fmt:formatDate
                                    value="${appointment.date}"
                                    pattern="MMM d, yyyy"
                                /></span>
                                <small class="text-muted"
                                  ><fmt:formatDate
                                    value="${appointment.time}"
                                    pattern="hh:mm a"
                                /></small>
                              </div>
                            </td>
                            <td>
                              <div class="d-flex align-items-center">
                                <div
                                  class="bg-primary bg-opacity-10 rounded-circle me-2"
                                  style="
                                    width: 32px;
                                    height: 32px;
                                    display: flex;
                                    align-items: center;
                                    justify-content: center;
                                  "
                                >
                                  <i class="bi bi-person text-primary"></i>
                                </div>
                                <span>${appointment.studentName}</span>
                              </div>
                            </td>
                            <td>${appointment.purpose}</td>
                            <td>
                              <c:choose>
                                <c:when
                                  test="${appointment.status == 'Confirmed'}"
                                >
                                  <span
                                    class="status-badge bg-success bg-opacity-10 text-success"
                                    >Confirmed</span
                                  >
                                </c:when>
                                <c:when
                                  test="${appointment.status == 'Pending'}"
                                >
                                  <span
                                    class="status-badge bg-warning bg-opacity-10 text-warning"
                                    >Pending</span
                                  >
                                </c:when>
                                <c:when
                                  test="${appointment.status == 'Completed'}"
                                >
                                  <span
                                    class="status-badge bg-info bg-opacity-10 text-info"
                                    >Completed</span
                                  >
                                </c:when>
                                <c:when
                                  test="${appointment.status == 'Cancelled'}"
                                >
                                  <span
                                    class="status-badge bg-danger bg-opacity-10 text-danger"
                                    >Cancelled</span
                                  >
                                </c:when>
                                <c:otherwise>
                                  <span
                                    class="status-badge bg-secondary bg-opacity-10 text-secondary"
                                    >${appointment.status}</span
                                  >
                                </c:otherwise>
                              </c:choose>
                            </td>
                            <td>
                              <div class="d-flex gap-2">
                                <button
                                  class="btn btn-sm btn-outline-primary"
                                  data-bs-toggle="modal"
                                  data-bs-target="#viewAppointmentModal${appointment.id}"
                                >
                                  <i class="bi bi-eye"></i>
                                </button>
                                <button
                                  class="btn btn-sm btn-outline-success"
                                  data-bs-toggle="modal"
                                  data-bs-target="#updateStatusModal${appointment.id}"
                                >
                                  <i class="bi bi-check2-circle"></i>
                                </button>
                                <button
                                  class="btn btn-sm btn-outline-danger"
                                  data-bs-toggle="modal"
                                  data-bs-target="#cancelAppointmentModal${appointment.id}"
                                >
                                  <i class="bi bi-x-circle"></i>
                                </button>
                              </div>
                            </td>
                          </tr>
                        </c:forEach>
                      </c:when>
                      <c:otherwise>
                        <tr>
                          <td colspan="5" class="text-center py-5">
                            <div class="d-flex flex-column align-items-center">
                              <i
                                class="bi bi-calendar-x text-muted mb-3"
                                style="font-size: 2.5rem"
                              ></i>
                              <h5 class="text-muted">No Appointments Found</h5>
                              <p class="text-muted mb-4">
                                There are currently no appointments scheduled.
                              </p>
                              <button
                                class="btn btn-primary"
                                data-bs-toggle="modal"
                                data-bs-target="#newAppointmentModal"
                              >
                                <i class="bi bi-plus-circle me-2"></i> Create
                                New Appointment
                              </button>
                            </div>
                          </td>
                        </tr>
                      </c:otherwise>
                    </c:choose>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- New Appointment Modal -->
    <div
      class="modal fade"
      id="newAppointmentModal"
      tabindex="-1"
      aria-labelledby="newAppointmentModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="newAppointmentModalLabel">
              Schedule New Appointment
            </h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <form
              action="${pageContext.request.contextPath}/doctor/appointments"
              method="post"
            >
              <input type="hidden" name="action" value="create" />

              <div class="row mb-3">
                <div class="col-md-6">
                  <label for="studentId" class="form-label">Student</label>
                  <select
                    class="form-select"
                    id="studentId"
                    name="studentId"
                    required
                  >
                    <option value="">Select Student</option>
                    <c:forEach items="${studentsList}" var="student">
                      <option value="${student.id}">
                        ${student.firstName} ${student.lastName} (Grade
                        ${student.className})
                      </option>
                    </c:forEach>
                  </select>
                </div>
                <div class="col-md-6">
                  <label for="appointmentDate" class="form-label">Date</label>
                  <input
                    type="date"
                    class="form-control"
                    id="appointmentDate"
                    name="appointmentDate"
                    required
                  />
                </div>
              </div>

              <div class="row mb-3">
                <div class="col-md-6">
                  <label for="appointmentTime" class="form-label">Time</label>
                  <input
                    type="time"
                    class="form-control"
                    id="appointmentTime"
                    name="appointmentTime"
                    required
                  />
                </div>
                <div class="col-md-6">
                  <label for="appointmentType" class="form-label"
                    >Appointment Type</label
                  >
                  <select
                    class="form-select"
                    id="appointmentType"
                    name="appointmentType"
                    required
                  >
                    <option value="">Select Type</option>
                    <option value="General Checkup">General Checkup</option>
                    <option value="Follow-up">Follow-up</option>
                    <option value="Vaccination">Vaccination</option>
                    <option value="Injury">Injury</option>
                    <option value="Illness">Illness</option>
                    <option value="Other">Other</option>
                  </select>
                </div>
              </div>

              <div class="mb-3">
                <label for="notes" class="form-label">Notes</label>
                <textarea
                  class="form-control"
                  id="notes"
                  name="notes"
                  rows="3"
                ></textarea>
              </div>

              <div class="text-end mt-4">
                <button
                  type="button"
                  class="btn btn-outline-secondary me-2"
                  data-bs-dismiss="modal"
                >
                  Cancel
                </button>
                <button type="submit" class="btn btn-primary">
                  Create Appointment
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- DataTables -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>

    <script>
      document.addEventListener("DOMContentLoaded", function () {
        // Initialize DataTable
        $("#appointmentsTable").DataTable({
          pageLength: 10,
          lengthMenu: [
            [10, 25, 50, -1],
            [10, 25, 50, "All"],
          ],
          ordering: true,
          info: true,
          paging: true,
          searching: true,
          dom: '<"top"f>rt<"bottom"lip><"clear">',
        });

        // Add animation to cards
        const cards = document.querySelectorAll(".content-card");
        cards.forEach((card, index) => {
          card.style.opacity = "0";
          card.style.transform = "translateY(20px)";
          card.style.transition = "opacity 0.5s ease, transform 0.5s ease";
          setTimeout(() => {
            card.style.opacity = "1";
            card.style.transform = "translateY(0)";
          }, 100 * index);
        });

        // Date filter functionality
        document
          .getElementById("dateFilter")
          .addEventListener("change", function () {
            // Logic to filter appointments by date
          });

        // Status filter functionality
        document
          .getElementById("statusFilter")
          .addEventListener("change", function () {
            // Logic to filter appointments by status
          });

        // Search functionality
        document
          .getElementById("searchInput")
          .addEventListener("keyup", function () {
            // Logic to search appointments
          });
      });
    </script>
  </body>
</html>
