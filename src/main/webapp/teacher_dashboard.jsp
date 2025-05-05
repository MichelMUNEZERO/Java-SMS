<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Teacher Dashboard - School Management System</title>
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
      .stat-card {
        transition: all var(--transition-speed);
        border-radius: var(--border-radius);
        border: none;
        box-shadow: var(--card-shadow);
        height: 100%;
        overflow: hidden;
      }

      .stat-card:hover {
        transform: translateY(-5px);
        box-shadow: var(--hover-shadow);
      }

      .stat-card .card-body {
        padding: 1.5rem;
      }

      .card-icon {
        font-size: 2.5rem;
        margin-bottom: 1rem;
      }

      .avatar-circle {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: rgba(13, 110, 253, 0.1);
        color: var(--primary-color);
        margin-right: 0.75rem;
      }

      .table > tbody > tr > td {
        vertical-align: middle;
      }

      .action-buttons .btn {
        width: 32px;
        height: 32px;
        padding: 0;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        margin-right: 0.25rem;
      }

      .announcement-item {
        border-left: 3px solid var(--primary-color);
        background-color: rgba(13, 110, 253, 0.05);
        padding: 1rem;
        border-radius: 0.5rem;
        margin-bottom: 1rem;
      }

      .quick-actions-btn {
        border-radius: 8px;
        margin-bottom: 0.75rem;
        padding: 0.75rem 1rem;
        font-weight: 500;
        position: relative;
        overflow: hidden;
        z-index: 1;
        transition: all 0.3s ease;
      }

      .quick-actions-btn::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 0;
        height: 100%;
        background-color: rgba(255, 255, 255, 0.1);
        z-index: -1;
        transition: width 0.3s ease;
      }

      .quick-actions-btn:hover::before {
        width: 100%;
      }

      .quick-actions-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
      }

      .behavior-badge {
        padding: 0.35rem 0.65rem;
        border-radius: 50rem;
        font-weight: 500;
        font-size: 0.75rem;
      }
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
        <!-- Include Teacher Sidebar -->
        <jsp:include page="/WEB-INF/includes/teacher-sidebar.jsp" />

        <!-- Main content -->
        <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
          <!-- Breadcrumb -->
          <nav aria-label="breadcrumb" class="mt-3">
            <ol class="breadcrumb">
              <li class="breadcrumb-item active" aria-current="page">
                Dashboard
              </li>
            </ol>
          </nav>

          <div
            class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center"
          >
            <h1 class="page-title">Teacher Dashboard</h1>
            <div class="btn-toolbar">
              <div class="dropdown">
                <button
                  class="btn btn-outline-secondary dropdown-toggle"
                  type="button"
                  id="dropdownMenuButton"
                  data-bs-toggle="dropdown"
                  aria-expanded="false"
                >
                  <i class="bi bi-person-circle me-1"></i> ${user.username}
                </button>
                <ul
                  class="dropdown-menu dropdown-menu-end"
                  aria-labelledby="dropdownMenuButton"
                >
                  <li>
                    <a class="dropdown-item" href="#"
                      ><i class="bi bi-person me-2"></i> My Profile</a
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

          <!-- Alert for messages -->
          <c:if test="${not empty successMessage}">
            <div
              class="alert alert-success alert-dismissible fade show"
              role="alert"
            >
              <i class="bi bi-check-circle-fill me-2"></i> ${successMessage}
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
                aria-label="Close"
              ></button>
            </div>
          </c:if>

          <c:if test="${not empty errorMessage}">
            <div
              class="alert alert-danger alert-dismissible fade show"
              role="alert"
            >
              <i class="bi bi-exclamation-triangle-fill me-2"></i>
              ${errorMessage}
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
                aria-label="Close"
              ></button>
            </div>
          </c:if>

          <!-- Summary cards -->
          <div class="row mb-4">
            <div class="col-md-4 mb-4">
              <div class="card stat-card bg-primary text-white">
                <div class="card-body text-center">
                  <i class="bi bi-people-fill card-icon"></i>
                  <h5 class="card-title">Total Students</h5>
                  <h2 class="card-text">${dashboardData.totalStudents}</h2>
                  <small>Enrolled in your courses</small>
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-4">
              <div class="card stat-card bg-success text-white">
                <div class="card-body text-center">
                  <i class="bi bi-book-fill card-icon"></i>
                  <h5 class="card-title">My Courses</h5>
                  <h2 class="card-text">${dashboardData.totalCourses}</h2>
                  <small>Courses you manage</small>
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-4">
              <div class="card stat-card bg-info text-white">
                <div class="card-body text-center">
                  <i class="bi bi-calendar-event-fill card-icon"></i>
                  <h5 class="card-title">Today's Appointments</h5>
                  <h2 class="card-text">${dashboardData.todayAppointments}</h2>
                  <small>Scheduled for today</small>
                </div>
              </div>
            </div>
          </div>

          <!-- Main Content -->
          <div class="row">
            <!-- Left Column -->
            <div class="col-md-8">
              <div class="content-card mb-4">
                <div
                  class="card-header d-flex justify-content-between align-items-center"
                >
                  <h5 class="mb-0">My Courses</h5>
                  <button
                    class="btn btn-sm btn-outline-primary"
                    onclick="viewAllCourses()"
                  >
                    <i class="bi bi-grid-3x3-gap-fill me-1"></i> View All
                  </button>
                </div>
                <div class="card-body p-0">
                  <div class="table-responsive">
                    <table class="table table-hover mb-0">
                      <thead>
                        <tr>
                          <th>Course Code</th>
                          <th>Course Name</th>
                          <th>Students</th>
                          <th>Actions</th>
                        </tr>
                      </thead>
                      <tbody>
                        <c:forEach items="${teacherCourses}" var="course">
                          <tr>
                            <td>
                              <span class="fw-medium"
                                >${course.courseCode}</span
                              >
                            </td>
                            <td>${course.courseName}</td>
                            <td>
                              <span class="badge bg-primary"
                                >${course.studentCount}</span
                              >
                            </td>
                            <td>
                              <div class="action-buttons">
                                <button
                                  class="btn btn-sm btn-primary"
                                  onclick="viewCourse('${course.courseId}')"
                                  title="View Course"
                                >
                                  <i class="bi bi-eye"></i>
                                </button>
                                <button
                                  class="btn btn-sm btn-success"
                                  onclick="manageStudents('${course.courseId}')"
                                  title="Manage Students"
                                >
                                  <i class="bi bi-people"></i>
                                </button>
                                <button
                                  class="btn btn-sm btn-warning"
                                  onclick="manageMarks('${course.courseId}')"
                                  title="Manage Marks"
                                >
                                  <i class="bi bi-card-checklist"></i>
                                </button>
                              </div>
                            </td>
                          </tr>
                        </c:forEach>
                        <c:if test="${empty teacherCourses}">
                          <tr>
                            <td colspan="4" class="text-center py-3">
                              <div
                                class="d-flex flex-column align-items-center"
                              >
                                <i
                                  class="bi bi-info-circle text-muted mb-2"
                                  style="font-size: 1.5rem"
                                ></i>
                                <p class="text-muted mb-0">
                                  No courses available
                                </p>
                              </div>
                            </td>
                          </tr>
                        </c:if>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>

              <!-- Student Behavior Table -->
              <div class="content-card">
                <div
                  class="card-header d-flex justify-content-between align-items-center"
                >
                  <h5 class="mb-0">Recent Student Behavior</h5>
                  <button
                    class="btn btn-sm btn-outline-primary"
                    onclick="viewAllBehaviorReports()"
                  >
                    <i class="bi bi-list-ul me-1"></i> View All
                  </button>
                </div>
                <div class="card-body p-0">
                  <div class="table-responsive">
                    <table class="table table-hover mb-0" id="behaviorTable">
                      <thead>
                        <tr>
                          <th>Student</th>
                          <th>Course</th>
                          <th>Type</th>
                          <th>Date</th>
                          <th>Details</th>
                        </tr>
                      </thead>
                      <tbody id="behaviorTableBody">
                        <!-- This will be populated with AJAX -->
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>

            <!-- Right Column -->
            <div class="col-md-4">
              <!-- Announcements -->
              <div class="content-card mb-4">
                <div class="card-header">
                  <h5 class="mb-0">Announcements</h5>
                </div>
                <div class="card-body">
                  <c:forEach
                    items="${announcements}"
                    var="announcement"
                    begin="0"
                    end="2"
                  >
                    <div class="announcement-item mb-3">
                      <h6 class="mb-1">${announcement.title}</h6>
                      <p class="mb-1 text-muted small">
                        ${announcement.message}
                      </p>
                      <div class="d-flex align-items-center mt-2">
                        <i class="bi bi-calendar-event text-muted me-1"></i>
                        <small class="text-muted"
                          >Posted on ${announcement.date}</small
                        >
                      </div>
                    </div>
                  </c:forEach>
                  <c:if test="${empty announcements}">
                    <div class="text-center py-4">
                      <i
                        class="bi bi-megaphone text-muted mb-3"
                        style="font-size: 2rem"
                      ></i>
                      <p class="text-muted mb-0">No announcements available</p>
                    </div>
                  </c:if>
                </div>
                <div class="card-footer text-center">
                  <a href="#" class="btn btn-sm btn-outline-primary"
                    >View All Announcements</a
                  >
                </div>
              </div>

              <!-- Quick Actions -->
              <div class="content-card">
                <div class="card-header">
                  <h5 class="mb-0">Quick Actions</h5>
                </div>
                <div class="card-body">
                  <div class="d-grid gap-2">
                    <button
                      class="btn btn-primary quick-actions-btn"
                      type="button"
                      onclick="enterMarks()"
                    >
                      <i class="bi bi-calculator me-2"></i> Enter Marks
                    </button>
                    <button
                      class="btn btn-success quick-actions-btn"
                      type="button"
                      onclick="generateReports()"
                    >
                      <i class="bi bi-file-earmark-text me-2"></i> Generate
                      Reports
                    </button>
                    <button
                      class="btn btn-warning quick-actions-btn text-white"
                      type="button"
                      onclick="bookAppointment()"
                    >
                      <i class="bi bi-calendar-plus me-2"></i> Book Appointment
                    </button>
                    <button
                      class="btn btn-info quick-actions-btn text-white"
                      type="button"
                      onclick="addBehaviorNote()"
                    >
                      <i class="bi bi-journal-plus me-2"></i> Add Behavior Note
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Modals and Forms -->
          <!-- Book Appointment Modal -->
          <div
            class="modal fade"
            id="appointmentModal"
            tabindex="-1"
            aria-labelledby="appointmentModalLabel"
            aria-hidden="true"
          >
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title" id="appointmentModalLabel">
                    Book Appointment
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
                    id="appointmentForm"
                    class="needs-validation"
                    novalidate
                  >
                    <div class="mb-3">
                      <label
                        for="appointmentTitle"
                        class="form-label required-field"
                        >Title</label
                      >
                      <input
                        type="text"
                        class="form-control"
                        id="appointmentTitle"
                        required
                      />
                      <div class="invalid-feedback">
                        Please enter an appointment title.
                      </div>
                    </div>
                    <div class="mb-3">
                      <label
                        for="appointmentDate"
                        class="form-label required-field"
                        >Date</label
                      >
                      <input
                        type="date"
                        class="form-control"
                        id="appointmentDate"
                        required
                      />
                      <div class="invalid-feedback">Please select a date.</div>
                    </div>
                    <div class="mb-3">
                      <label
                        for="appointmentTime"
                        class="form-label required-field"
                        >Time</label
                      >
                      <input
                        type="time"
                        class="form-control"
                        id="appointmentTime"
                        required
                      />
                      <div class="invalid-feedback">Please select a time.</div>
                    </div>
                    <div class="mb-3">
                      <label for="appointmentNotes" class="form-label"
                        >Notes</label
                      >
                      <textarea
                        class="form-control"
                        id="appointmentNotes"
                        rows="3"
                      ></textarea>
                    </div>
                  </form>
                </div>
                <div class="modal-footer">
                  <button
                    type="button"
                    class="btn btn-outline-secondary"
                    data-bs-dismiss="modal"
                  >
                    <i class="bi bi-x-circle me-1"></i> Cancel
                  </button>
                  <button
                    type="button"
                    class="btn btn-primary"
                    id="saveAppointment"
                  >
                    <i class="bi bi-calendar-check me-1"></i> Save Appointment
                  </button>
                </div>
              </div>
            </div>
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
      // Initialize DataTables
      $(document).ready(function () {
        // Load behavior data
        loadBehaviorData();

        // Form validation
        (function () {
          "use strict";

          // Fetch all forms we want to apply validation styles to
          var forms = document.querySelectorAll(".needs-validation");

          // Loop over them and prevent submission
          Array.prototype.slice.call(forms).forEach(function (form) {
            form.addEventListener(
              "submit",
              function (event) {
                if (!form.checkValidity()) {
                  event.preventDefault();
                  event.stopPropagation();
                }
                form.classList.add("was-validated");
              },
              false
            );
          });
        })();
      });

      // Function to load behavior data via AJAX
      function loadBehaviorData() {
        // In a real application, this would be an AJAX call to the server
        // For demonstration, we'll simulate it with static data
        const behaviorData = [
          {
            student: "John Smith",
            course: "Mathematics",
            type: "Achievement",
            date: "2023-05-10",
            details: "Excellent performance in class test",
          },
          {
            student: "Mary Johnson",
            course: "Science",
            type: "Concern",
            date: "2023-05-08",
            details: "Missed homework submission",
          },
          {
            student: "David Wilson",
            course: "English",
            type: "Achievement",
            date: "2023-05-05",
            details: "Outstanding essay writing",
          },
        ];

        let tableContent = "";
        behaviorData.forEach((item) => {
          tableContent +=
            "<tr>" +
            "<td>" +
            item.student +
            "</td>" +
            "<td>" +
            item.course +
            "</td>" +
            '<td><span class="behavior-badge ' +
            (item.type === "Achievement" ? "bg-success" : "bg-warning") +
            '">' +
            item.type +
            "</span></td>" +
            "<td>" +
            item.date +
            "</td>" +
            "<td>" +
            item.details +
            "</td>" +
            "</tr>";
        });

        $("#behaviorTableBody").html(tableContent);
      }

      // Function handlers for buttons
      function viewCourse(courseId) {
        // Navigate to course details page
        window.location.href =
          "${pageContext.request.contextPath}/teacher/course?id=" + courseId;
      }

      function manageStudents(courseId) {
        // Navigate to student management page
        window.location.href =
          "${pageContext.request.contextPath}/teacher/course/students?id=" +
          courseId;
      }

      function manageMarks(courseId) {
        // Navigate to marks management page
        window.location.href =
          "${pageContext.request.contextPath}/teacher/course/marks?id=" +
          courseId;
      }

      function viewAllCourses() {
        // Navigate to all courses page
        window.location.href =
          "${pageContext.request.contextPath}/teacher/courses";
      }

      function viewAllBehaviorReports() {
        // Navigate to behavior reports page
        window.location.href =
          "${pageContext.request.contextPath}/teacher/behavior-reports";
      }

      function enterMarks() {
        // Navigate to marks entry page
        window.location.href =
          "${pageContext.request.contextPath}/teacher/marks";
      }

      function generateReports() {
        // Navigate to reports page
        window.location.href =
          "${pageContext.request.contextPath}/teacher/reports";
      }

      function bookAppointment() {
        // Show appointment modal
        $("#appointmentModal").modal("show");
      }

      function addBehaviorNote() {
        // Navigate to add behavior note page
        window.location.href =
          "${pageContext.request.contextPath}/teacher/add-behavior-note";
      }

      // Save appointment
      $("#saveAppointment").click(function () {
        const form = document.getElementById("appointmentForm");
        if (form.checkValidity()) {
          // In a real application, this would submit the form via AJAX
          alert("Appointment saved successfully!");
          $("#appointmentModal").modal("hide");
        } else {
          form.classList.add("was-validated");
        }
      });
    </script>
  </body>
</html>
