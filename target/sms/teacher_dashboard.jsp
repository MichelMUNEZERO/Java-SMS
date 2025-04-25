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
                <a class="nav-link active text-white" href="#">
                  <i class="bi bi-speedometer2 me-2"></i> Dashboard
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="#">
                  <i class="bi bi-book me-2"></i> My Classes
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="#">
                  <i class="bi bi-journal-check me-2"></i> Attendance
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="#">
                  <i class="bi bi-card-checklist me-2"></i> Grades
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="#">
                  <i class="bi bi-calendar-event me-2"></i> Schedule
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="#">
                  <i class="bi bi-chat-dots me-2"></i> Messages
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

          <!-- Summary cards -->
          <div class="row mb-4">
            <div class="col-md-3 mb-4">
              <div class="card dashboard-card bg-primary text-white">
                <div class="card-body text-center">
                  <i class="bi bi-book-fill card-icon"></i>
                  <h5 class="card-title">My Classes</h5>
                  <h2 class="card-text">5</h2>
                </div>
              </div>
            </div>
            <div class="col-md-3 mb-4">
              <div class="card dashboard-card bg-success text-white">
                <div class="card-body text-center">
                  <i class="bi bi-people-fill card-icon"></i>
                  <h5 class="card-title">Total Students</h5>
                  <h2 class="card-text">128</h2>
                </div>
              </div>
            </div>
            <div class="col-md-3 mb-4">
              <div class="card dashboard-card bg-warning text-white">
                <div class="card-body text-center">
                  <i class="bi bi-file-earmark-text card-icon"></i>
                  <h5 class="card-title">Assignments</h5>
                  <h2 class="card-text">12</h2>
                </div>
              </div>
            </div>
            <div class="col-md-3 mb-4">
              <div class="card dashboard-card bg-info text-white">
                <div class="card-body text-center">
                  <i class="bi bi-calendar-event-fill card-icon"></i>
                  <h5 class="card-title">Today's Classes</h5>
                  <h2 class="card-text">3</h2>
                </div>
              </div>
            </div>
          </div>

          <!-- Today's Schedule -->
          <div class="row mb-4">
            <div class="col-md-8">
              <div class="card dashboard-card">
                <div class="card-header bg-white">
                  <h5 class="card-title mb-0">Today's Schedule</h5>
                </div>
                <div class="card-body">
                  <table class="table class-table">
                    <thead>
                      <tr>
                        <th>Time</th>
                        <th>Class</th>
                        <th>Room</th>
                        <th>Actions</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>08:00 - 09:30</td>
                        <td>Mathematics - Class 10A</td>
                        <td>Room 301</td>
                        <td>
                          <button class="btn btn-sm btn-outline-primary">
                            <i class="bi bi-journal-check"></i> Attendance
                          </button>
                        </td>
                      </tr>
                      <tr>
                        <td>10:00 - 11:30</td>
                        <td>Mathematics - Class 9B</td>
                        <td>Room 302</td>
                        <td>
                          <button class="btn btn-sm btn-outline-primary">
                            <i class="bi bi-journal-check"></i> Attendance
                          </button>
                        </td>
                      </tr>
                      <tr>
                        <td>13:00 - 14:30</td>
                        <td>Mathematics - Class 11A</td>
                        <td>Room 305</td>
                        <td>
                          <button class="btn btn-sm btn-outline-primary">
                            <i class="bi bi-journal-check"></i> Attendance
                          </button>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
                <div class="card-footer bg-white">
                  <a href="#" class="btn btn-sm btn-outline-primary"
                    >View Full Schedule</a
                  >
                </div>
              </div>
            </div>
            <div class="col-md-4">
              <div class="card dashboard-card">
                <div class="card-header bg-white">
                  <h5 class="card-title mb-0">Quick Actions</h5>
                </div>
                <div class="card-body">
                  <div class="d-grid gap-2">
                    <button class="btn btn-primary" type="button">
                      <i class="bi bi-file-earmark-plus me-2"></i> Create
                      Assignment
                    </button>
                    <button class="btn btn-success" type="button">
                      <i class="bi bi-journal-plus me-2"></i> Record Attendance
                    </button>
                    <button class="btn btn-warning" type="button">
                      <i class="bi bi-calculator me-2"></i> Enter Grades
                    </button>
                    <button class="btn btn-info" type="button">
                      <i class="bi bi-chat-dots me-2"></i> Message Parents
                    </button>
                    <button class="btn btn-danger" type="button">
                      <i class="bi bi-file-earmark-text me-2"></i> Generate
                      Report
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Recent Assignments and Announcements -->
          <div class="row mb-4">
            <div class="col-md-6 mb-4">
              <div class="card dashboard-card h-100">
                <div class="card-header bg-white">
                  <h5 class="card-title mb-0">Recent Assignments</h5>
                </div>
                <div class="card-body">
                  <ul class="list-group list-group-flush">
                    <li
                      class="list-group-item d-flex justify-content-between align-items-center"
                    >
                      <div>
                        <span class="fw-bold">Algebra Problems</span>
                        <p class="text-muted mb-0">
                          Class 10A - Due: May 15, 2023
                        </p>
                      </div>
                      <span class="badge bg-warning rounded-pill">Pending</span>
                    </li>
                    <li
                      class="list-group-item d-flex justify-content-between align-items-center"
                    >
                      <div>
                        <span class="fw-bold">Geometry Quiz</span>
                        <p class="text-muted mb-0">
                          Class 9B - Due: May 12, 2023
                        </p>
                      </div>
                      <span class="badge bg-success rounded-pill">Graded</span>
                    </li>
                    <li
                      class="list-group-item d-flex justify-content-between align-items-center"
                    >
                      <div>
                        <span class="fw-bold">Calculus Project</span>
                        <p class="text-muted mb-0">
                          Class 11A - Due: May 20, 2023
                        </p>
                      </div>
                      <span class="badge bg-warning rounded-pill">Pending</span>
                    </li>
                  </ul>
                </div>
                <div class="card-footer bg-white">
                  <a href="#" class="btn btn-sm btn-outline-primary"
                    >View All Assignments</a
                  >
                </div>
              </div>
            </div>
            <div class="col-md-6 mb-4">
              <div class="card dashboard-card h-100">
                <div class="card-header bg-white">
                  <h5 class="card-title mb-0">Recent Announcements</h5>
                </div>
                <div class="card-body">
                  <ul class="list-group list-group-flush">
                    <li class="list-group-item">
                      <h6 class="card-subtitle mb-1">
                        Math Department Meeting
                      </h6>
                      <p class="card-text">
                        There will be a department meeting on Friday at 3:00 PM
                        in the conference room.
                      </p>
                      <small class="text-muted">Posted 2 days ago</small>
                    </li>
                    <li class="list-group-item">
                      <h6 class="card-subtitle mb-1">Final Exam Schedule</h6>
                      <p class="card-text">
                        The final exam schedule has been published. Please check
                        your email for details.
                      </p>
                      <small class="text-muted">Posted 5 days ago</small>
                    </li>
                    <li class="list-group-item">
                      <h6 class="card-subtitle mb-1">
                        Professional Development Workshop
                      </h6>
                      <p class="card-text">
                        A workshop on "Effective Teaching Methods" will be held
                        next Monday.
                      </p>
                      <small class="text-muted">Posted 1 week ago</small>
                    </li>
                  </ul>
                </div>
                <div class="card-footer bg-white">
                  <a href="#" class="btn btn-sm btn-outline-primary"
                    >View All Announcements</a
                  >
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
