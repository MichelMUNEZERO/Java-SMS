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

      .card-icon {
        font-size: 2.5rem;
        margin-bottom: 1rem;
      }

      .class-table th,
      .class-table td {
        vertical-align: middle;
      }

      .teacher-profile {
        display: flex;
        align-items: center;
        padding: 1rem;
      }

      .teacher-avatar {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        object-fit: cover;
        margin-right: 10px;
      }

      .tab-content {
        padding: 20px;
        background-color: #fff;
        border-radius: 0 0 10px 10px;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.05);
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

            <!-- Teacher Profile Widget -->
            <div class="teacher-profile bg-dark text-white mb-3 text-center">
              <c:choose>
                <c:when test="${not empty profileData.imageLink}">
                  <img
                    src="${profileData.imageLink}"
                    alt="Teacher Avatar"
                    class="teacher-avatar mx-auto d-block mb-2"
                  />
                </c:when>
                <c:otherwise>
                  <div
                    class="bg-secondary rounded-circle mx-auto mb-2"
                    style="
                      width: 50px;
                      height: 50px;
                      display: flex;
                      align-items: center;
                      justify-content: center;
                    "
                  >
                    <i
                      class="bi bi-person text-white"
                      style="font-size: 1.5rem"
                    ></i>
                  </div>
                </c:otherwise>
              </c:choose>
              <div>
                <span class="d-block">${user.username}</span>
                <small class="text-muted">${user.email}</small>
              </div>
            </div>

            <hr class="text-white" />
            <ul class="nav flex-column">
              <li class="nav-item">
                <a class="nav-link active text-white" href="#">
                  <i class="bi bi-speedometer2 me-2"></i> Dashboard
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="#"
                  data-bs-toggle="tab"
                  data-bs-target="#courses-tab"
                >
                  <i class="bi bi-book me-2"></i> My Courses
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/teacher/student"
                >
                  <i class="bi bi-people me-2"></i> My Students
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="#"
                  data-bs-toggle="tab"
                  data-bs-target="#marks-tab"
                >
                  <i class="bi bi-card-checklist me-2"></i> Marks & Grades
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="#"
                  data-bs-toggle="tab"
                  data-bs-target="#behavior-tab"
                >
                  <i class="bi bi-clipboard-check me-2"></i> Student Behavior
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="#"
                  data-bs-toggle="tab"
                  data-bs-target="#reports-tab"
                >
                  <i class="bi bi-file-earmark-text me-2"></i> Reports
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="#"
                  data-bs-toggle="tab"
                  data-bs-target="#appointments-tab"
                >
                  <i class="bi bi-calendar-event me-2"></i> Appointments
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
            <h1 class="h2">Teacher Dashboard</h1>
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

          <!-- Main dashboard content below -->

          <!-- Summary cards -->
          <div class="row mb-4">
            <div class="col-md-4 mb-4">
              <div class="card dashboard-card bg-primary text-white">
                <div class="card-body text-center">
                  <i class="bi bi-people-fill card-icon"></i>
                  <h5 class="card-title">Total Students</h5>
                  <h2 class="card-text">${dashboardData.totalStudents}</h2>
                  <small>Enrolled in your courses</small>
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-4">
              <div class="card dashboard-card bg-success text-white">
                <div class="card-body text-center">
                  <i class="bi bi-book-fill card-icon"></i>
                  <h5 class="card-title">My Courses</h5>
                  <h2 class="card-text">${dashboardData.totalCourses}</h2>
                  <small>Courses you manage</small>
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-4">
              <div class="card dashboard-card bg-info text-white">
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
          <div class="row mb-4">
            <!-- Left Column -->
            <div class="col-md-8">
              <div class="card dashboard-card mb-4">
                <div class="card-header bg-white">
                  <h5 class="card-title mb-0">My Courses</h5>
                </div>
                <div class="card-body">
                  <table class="table table-striped table-hover">
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
                          <td>${course.courseCode}</td>
                          <td>${course.courseName}</td>
                          <td>${course.studentCount}</td>
                          <td>
                            <div class="btn-group">
                              <button
                                class="btn btn-sm btn-primary"
                                onclick="viewCourse('${course.courseId}')"
                              >
                                <i class="bi bi-eye"></i>
                              </button>
                              <button
                                class="btn btn-sm btn-success"
                                onclick="manageStudents('${course.courseId}')"
                              >
                                <i class="bi bi-people"></i>
                              </button>
                              <button
                                class="btn btn-sm btn-warning"
                                onclick="manageMarks('${course.courseId}')"
                              >
                                <i class="bi bi-card-checklist"></i>
                              </button>
                            </div>
                          </td>
                        </tr>
                      </c:forEach>
                      <c:if test="${empty teacherCourses}">
                        <tr>
                          <td colspan="4" class="text-center">
                            No courses available
                          </td>
                        </tr>
                      </c:if>
                    </tbody>
                  </table>
                </div>
                <div class="card-footer bg-white">
                  <a
                    href="#"
                    class="btn btn-sm btn-outline-primary"
                    onclick="viewAllCourses()"
                  >
                    View All Courses
                  </a>
                </div>
              </div>

              <!-- Student Behavior Table -->
              <div class="card dashboard-card">
                <div class="card-header bg-white">
                  <h5 class="card-title mb-0">Recent Student Behavior</h5>
                </div>
                <div class="card-body">
                  <table class="table table-striped">
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
                <div class="card-footer bg-white">
                  <a
                    href="#"
                    class="btn btn-sm btn-outline-primary"
                    onclick="viewAllBehaviorReports()"
                  >
                    View All Behavior Reports
                  </a>
                </div>
              </div>
            </div>

            <!-- Right Column -->
            <div class="col-md-4">
              <!-- Announcements -->
              <div class="card dashboard-card mb-4">
                <div class="card-header bg-white">
                  <h5 class="card-title mb-0">Announcements</h5>
                </div>
                <div class="card-body">
                  <ul class="list-group list-group-flush">
                    <c:forEach
                      items="${announcements}"
                      var="announcement"
                      begin="0"
                      end="2"
                    >
                      <li class="list-group-item">
                        <h6 class="card-subtitle mb-1">
                          ${announcement.title}
                        </h6>
                        <p class="card-text">${announcement.message}</p>
                        <small class="text-muted"
                          >Posted on ${announcement.date}</small
                        >
                      </li>
                    </c:forEach>
                    <c:if test="${empty announcements}">
                      <li class="list-group-item">
                        <p class="text-muted">No announcements available</p>
                      </li>
                    </c:if>
                  </ul>
                </div>
                <div class="card-footer bg-white">
                  <a href="#" class="btn btn-sm btn-outline-primary"
                    >View All Announcements</a
                  >
                </div>
              </div>

              <!-- Quick Actions -->
              <div class="card dashboard-card mb-4">
                <div class="card-header bg-white">
                  <h5 class="card-title mb-0">Quick Actions</h5>
                </div>
                <div class="card-body">
                  <div class="d-grid gap-2">
                    <button
                      class="btn btn-primary"
                      type="button"
                      onclick="enterMarks()"
                    >
                      <i class="bi bi-calculator me-2"></i> Enter Marks
                    </button>
                    <button
                      class="btn btn-success"
                      type="button"
                      onclick="generateReports()"
                    >
                      <i class="bi bi-file-earmark-text me-2"></i> Generate
                      Reports
                    </button>
                    <button
                      class="btn btn-warning"
                      type="button"
                      onclick="bookAppointment()"
                    >
                      <i class="bi bi-calendar-plus me-2"></i> Book Appointment
                    </button>
                    <button
                      class="btn btn-info"
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
                  <form id="appointmentForm">
                    <div class="mb-3">
                      <label for="appointmentTitle" class="form-label"
                        >Title</label
                      >
                      <input
                        type="text"
                        class="form-control"
                        id="appointmentTitle"
                        required
                      />
                    </div>
                    <div class="mb-3">
                      <label for="appointmentDate" class="form-label"
                        >Date</label
                      >
                      <input
                        type="date"
                        class="form-control"
                        id="appointmentDate"
                        required
                      />
                    </div>
                    <div class="mb-3">
                      <label for="appointmentTime" class="form-label"
                        >Time</label
                      >
                      <input
                        type="time"
                        class="form-control"
                        id="appointmentTime"
                        required
                      />
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
                    class="btn btn-secondary"
                    data-bs-dismiss="modal"
                  >
                    Close
                  </button>
                  <button
                    type="button"
                    class="btn btn-primary"
                    id="saveAppointment"
                  >
                    Save
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
            '<td><span class="badge ' +
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
        // In a real application, this would submit the form via AJAX
        alert("Appointment saved successfully!");
        $("#appointmentModal").modal("hide");
      });
    </script>
  </body>
</html>
