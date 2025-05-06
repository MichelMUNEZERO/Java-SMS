<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Nurse Dashboard - School Management System</title>

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

      .quick-action {
        transition: all 0.3s ease;
        border-radius: 0.75rem;
        border: 1px solid #e3e6f0;
        height: 100%;
      }

      .quick-action:hover {
        transform: translateY(-5px);
        box-shadow: 0 0.3rem 1.5rem rgba(0, 0, 0, 0.1);
      }

      .icon-box {
        width: 64px;
        height: 64px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        margin-bottom: 1rem;
      }

      .feature-icon {
        font-size: 1.75rem;
      }

      .stat-value {
        font-size: 2rem;
        font-weight: 600;
      }

      .stat-label {
        color: #858796;
        font-weight: 500;
      }

      .announcement-date {
        font-size: 0.75rem;
        color: #858796;
      }

      .announcement-item {
        border-left: 3px solid #4e73df;
        padding-left: 1rem;
        margin-bottom: 1rem;
      }

      .tab-pane {
        padding: 1.5rem;
      }
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
        <!-- Sidebar - Replace with a JSP include if you have a common sidebar -->
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
                  class="nav-link active text-white d-flex align-items-center py-2"
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
                  class="nav-link text-white d-flex align-items-center py-2"
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
              <li class="breadcrumb-item active" aria-current="page">
                Nurse Dashboard
              </li>
            </ol>
          </nav>

          <!-- Page Header -->
          <div
            class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-2 mb-4 border-bottom"
          >
            <h1 class="page-title h2">Nurse Dashboard</h1>
            <div class="btn-toolbar mb-2 mb-md-0">
              <div class="btn-group me-2">
                <a
                  href="${pageContext.request.contextPath}/nurse/new-diagnosis"
                  class="btn btn-sm btn-outline-primary"
                >
                  <i class="bi bi-clipboard-plus me-1"></i> New Diagnosis
                </a>
                <a
                  href="${pageContext.request.contextPath}/nurse/students"
                  class="btn btn-sm btn-outline-success"
                >
                  <i class="bi bi-search me-1"></i> Find Student
                </a>
              </div>
              <button
                type="button"
                class="btn btn-sm btn-outline-danger"
                data-bs-toggle="modal"
                data-bs-target="#healthAlertModal"
              >
                <i class="bi bi-exclamation-triangle me-1"></i> Health Alert
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
                      style="width: 65%"
                    ></div>
                  </div>
                  <div class="text-end mt-2">
                    <a
                      href="${pageContext.request.contextPath}/nurse/appointments"
                      class="text-decoration-none fw-semibold"
                      >View all</a
                    >
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
                        class="bi bi-clipboard-pulse text-success"
                        style="font-size: 1.8rem"
                      ></i>
                    </div>
                    <h2 class="text-success mb-0">12</h2>
                  </div>
                  <h5 class="text-muted mb-3">Diagnosed Students</h5>
                  <div class="progress">
                    <div
                      class="progress-bar bg-success"
                      role="progressbar"
                      style="width: 60%"
                    ></div>
                  </div>
                  <div class="text-end mt-2">
                    <a
                      href="${pageContext.request.contextPath}/nurse/diagnosed-students"
                      class="text-decoration-none fw-semibold"
                      >View all</a
                    >
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-3">
              <div class="content-card h-100">
                <div class="card-body p-4">
                  <div class="d-flex justify-content-between mb-3">
                    <div class="bg-info bg-opacity-10 p-3 rounded">
                      <i
                        class="bi bi-capsule text-info"
                        style="font-size: 1.8rem"
                      ></i>
                    </div>
                    <h2 class="text-info mb-0">23</h2>
                  </div>
                  <h5 class="text-muted mb-3">Medication Schedules</h5>
                  <div class="progress">
                    <div
                      class="progress-bar bg-info"
                      role="progressbar"
                      style="width: 75%"
                    ></div>
                  </div>
                  <div class="text-end mt-2">
                    <a
                      href="${pageContext.request.contextPath}/nurse/medications"
                      class="text-decoration-none fw-semibold"
                      >View all</a
                    >
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Quick Actions and Announcements -->
          <div class="row">
            <!-- Quick Actions Cards -->
            <div class="col-lg-7 mb-4">
              <div class="content-card h-100">
                <div
                  class="card-header d-flex justify-content-between align-items-center"
                >
                  <h5 class="mb-0">
                    <i class="bi bi-lightning-charge me-2 text-warning"></i>
                    Quick Actions
                  </h5>
                </div>
                <div class="card-body">
                  <div class="row g-4">
                    <div class="col-md-6 col-lg-6">
                      <a
                        href="${pageContext.request.contextPath}/nurse/new-diagnosis"
                        class="text-decoration-none"
                      >
                        <div class="quick-action p-4 text-center h-100">
                          <div
                            class="icon-box bg-primary bg-opacity-10 mx-auto"
                          >
                            <i
                              class="bi bi-clipboard-plus feature-icon text-primary"
                            ></i>
                          </div>
                          <h5 class="mt-3 mb-2">Record Diagnosis</h5>
                          <p class="text-muted mb-0">
                            Record a new student diagnosis
                          </p>
                        </div>
                      </a>
                    </div>
                    <div class="col-md-6 col-lg-6">
                      <a
                        href="${pageContext.request.contextPath}/nurse/diagnosed-students"
                        class="text-decoration-none"
                      >
                        <div class="quick-action p-4 text-center h-100">
                          <div
                            class="icon-box bg-success bg-opacity-10 mx-auto"
                          >
                            <i
                              class="bi bi-clipboard-pulse feature-icon text-success"
                            ></i>
                          </div>
                          <h5 class="mt-3 mb-2">Diagnosed Students</h5>
                          <p class="text-muted mb-0">
                            View list of diagnosed students
                          </p>
                        </div>
                      </a>
                    </div>
                    <div class="col-md-6 col-lg-6">
                      <a
                        href="${pageContext.request.contextPath}/nurse/appointments"
                        class="text-decoration-none"
                      >
                        <div class="quick-action p-4 text-center h-100">
                          <div class="icon-box bg-info bg-opacity-10 mx-auto">
                            <i
                              class="bi bi-calendar-check feature-icon text-info"
                            ></i>
                          </div>
                          <h5 class="mt-3 mb-2">Appointments</h5>
                          <p class="text-muted mb-0">
                            View and manage appointments
                          </p>
                        </div>
                      </a>
                    </div>
                    <div class="col-md-6 col-lg-6">
                      <a
                        href="${pageContext.request.contextPath}/nurse/students"
                        class="text-decoration-none"
                      >
                        <div class="quick-action p-4 text-center h-100">
                          <div class="icon-box bg-danger bg-opacity-10 mx-auto">
                            <i
                              class="bi bi-search feature-icon text-danger"
                            ></i>
                          </div>
                          <h5 class="mt-3 mb-2">Find Student</h5>
                          <p class="text-muted mb-0">
                            Search for student health records
                          </p>
                        </div>
                      </a>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Recent Announcements -->
            <div class="col-lg-5 mb-4">
              <div class="content-card h-100">
                <div
                  class="card-header d-flex justify-content-between align-items-center"
                >
                  <h5 class="mb-0">
                    <i class="bi bi-megaphone me-2 text-primary"></i>
                    Recent Announcements
                  </h5>
                </div>
                <div class="card-body">
                  <c:choose>
                    <c:when test="${empty announcements}">
                      <div class="text-center py-5">
                        <i
                          class="bi bi-bell-slash text-muted mb-3"
                          style="font-size: 2.5rem"
                        ></i>
                        <h5 class="text-muted">No Recent Announcements</h5>
                        <p class="text-muted">
                          There are no announcements at this time.
                        </p>
                      </div>
                    </c:when>
                    <c:otherwise>
                      <div class="announcements-list">
                        <c:forEach var="announcement" items="${announcements}">
                          <div
                            class="announcement-item p-3 mb-3 bg-light rounded"
                          >
                            <h6 class="mb-1">${announcement.title}</h6>
                            <p class="announcement-date mb-2">
                              <i class="bi bi-calendar3 me-1"></i>
                              <fmt:formatDate
                                value="${announcement.createdAt}"
                                pattern="MMMM d, yyyy"
                              />
                            </p>
                            <p class="mb-0">${announcement.content}</p>
                          </div>
                        </c:forEach>
                      </div>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>
            </div>
          </div>

          <!-- Recent Health Incidents and Upcoming Vaccinations -->
          <div class="row">
            <!-- Recent Health Incidents -->
            <div class="col-lg-7 mb-4">
              <div class="content-card">
                <div
                  class="card-header d-flex justify-content-between align-items-center"
                >
                  <h5 class="mb-0">
                    <i class="bi bi-activity me-2 text-danger"></i>
                    Recent Health Incidents
                  </h5>
                  <a
                    href="${pageContext.request.contextPath}/nurse/incidents"
                    class="btn btn-sm btn-outline-primary"
                    >View All</a
                  >
                </div>
                <div class="card-body p-0">
                  <div class="table-responsive">
                    <table class="table table-hover mb-0">
                      <thead class="table-light">
                        <tr>
                          <th>Date</th>
                          <th>Student</th>
                          <th>Incident Type</th>
                          <th>Status</th>
                          <th>Actions</th>
                        </tr>
                      </thead>
                      <tbody>
                        <!-- Sample data - would be populated from database -->
                        <tr>
                          <td>May 15, 2023</td>
                          <td>James Wilson</td>
                          <td>Minor Injury</td>
                          <td>
                            <span class="badge bg-success">Resolved</span>
                          </td>
                          <td>
                            <button class="btn btn-sm btn-outline-primary">
                              <i class="bi bi-eye"></i>
                            </button>
                          </td>
                        </tr>
                        <tr>
                          <td>May 14, 2023</td>
                          <td>Emma Thompson</td>
                          <td>Illness</td>
                          <td>
                            <span class="badge bg-warning">Follow-up</span>
                          </td>
                          <td>
                            <button class="btn btn-sm btn-outline-primary">
                              <i class="bi bi-eye"></i>
                            </button>
                          </td>
                        </tr>
                        <tr>
                          <td>May 12, 2023</td>
                          <td>Lucas Rodriguez</td>
                          <td>Allergic Reaction</td>
                          <td>
                            <span class="badge bg-success">Resolved</span>
                          </td>
                          <td>
                            <button class="btn btn-sm btn-outline-primary">
                              <i class="bi bi-eye"></i>
                            </button>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>

            <!-- Upcoming Vaccinations -->
            <div class="col-lg-5 mb-4">
              <div class="content-card">
                <div
                  class="card-header d-flex justify-content-between align-items-center"
                >
                  <h5 class="mb-0">
                    <i class="bi bi-shield-plus me-2 text-success"></i>
                    Upcoming Vaccinations
                  </h5>
                  <a
                    href="${pageContext.request.contextPath}/nurse/vaccinations"
                    class="btn btn-sm btn-outline-primary"
                    >View All</a
                  >
                </div>
                <div class="card-body p-0">
                  <div class="table-responsive">
                    <table class="table table-hover mb-0">
                      <thead class="table-light">
                        <tr>
                          <th>Date</th>
                          <th>Student</th>
                          <th>Vaccination</th>
                          <th>Status</th>
                        </tr>
                      </thead>
                      <tbody>
                        <!-- Sample data - would be populated from database -->
                        <tr>
                          <td>May 20, 2023</td>
                          <td>Sophia Lee</td>
                          <td>Flu Vaccine</td>
                          <td>
                            <span class="badge bg-warning">Scheduled</span>
                          </td>
                        </tr>
                        <tr>
                          <td>May 22, 2023</td>
                          <td>Noah Clark</td>
                          <td>Tetanus Booster</td>
                          <td>
                            <span class="badge bg-warning">Scheduled</span>
                          </td>
                        </tr>
                        <tr>
                          <td>May 25, 2023</td>
                          <td>Olivia Martinez</td>
                          <td>MMR</td>
                          <td>
                            <span class="badge bg-warning">Scheduled</span>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Health Alert Modal -->
    <div
      class="modal fade"
      id="healthAlertModal"
      tabindex="-1"
      aria-labelledby="healthAlertModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="healthAlertModalLabel">
              Create Health Alert
            </h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <form id="healthAlertForm">
              <div class="mb-3">
                <label for="alertTitle" class="form-label">Alert Title</label>
                <input
                  type="text"
                  class="form-control"
                  id="alertTitle"
                  required
                />
              </div>
              <div class="mb-3">
                <label for="alertType" class="form-label">Alert Type</label>
                <select class="form-select" id="alertType" required>
                  <option value="">Select Alert Type</option>
                  <option value="disease">Infectious Disease</option>
                  <option value="allergy">Allergy Alert</option>
                  <option value="hygiene">Hygiene Reminder</option>
                  <option value="other">Other</option>
                </select>
              </div>
              <div class="mb-3">
                <label for="alertMessage" class="form-label"
                  >Alert Message</label
                >
                <textarea
                  class="form-control"
                  id="alertMessage"
                  rows="4"
                  required
                ></textarea>
              </div>
              <div class="mb-3">
                <label for="affectedGrades" class="form-label"
                  >Affected Grades</label
                >
                <select
                  class="form-select"
                  id="affectedGrades"
                  multiple
                  required
                >
                  <option value="all">All Grades</option>
                  <option value="K">Kindergarten</option>
                  <option value="1">Grade 1</option>
                  <option value="2">Grade 2</option>
                  <option value="3">Grade 3</option>
                  <option value="4">Grade 4</option>
                  <option value="5">Grade 5</option>
                  <option value="6">Grade 6</option>
                  <option value="7">Grade 7</option>
                  <option value="8">Grade 8</option>
                  <option value="9">Grade 9</option>
                  <option value="10">Grade 10</option>
                  <option value="11">Grade 11</option>
                  <option value="12">Grade 12</option>
                </select>
                <div class="form-text">
                  Hold Ctrl/Cmd to select multiple grades
                </div>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
            >
              Close
            </button>
            <button type="button" class="btn btn-danger">Send Alert</button>
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

        // Initialize any DataTables if needed
        // $('.datatable').DataTable();
      });
    </script>
  </body>
</html>
