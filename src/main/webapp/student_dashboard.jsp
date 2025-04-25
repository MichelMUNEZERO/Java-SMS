<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Student Dashboard - School Management System</title>
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

      .progress {
        height: 10px;
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
                  <i class="bi bi-book me-2"></i> My Courses
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="#">
                  <i class="bi bi-card-checklist me-2"></i> Grades
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="#">
                  <i class="bi bi-file-earmark-text me-2"></i> Assignments
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
            <h1 class="h2">Student Dashboard</h1>
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

          <!-- Welcome message -->
          <div class="row mb-4">
            <div class="col-md-12">
              <div class="card dashboard-card">
                <div class="card-body">
                  <h5 class="card-title">Welcome, ${user.username}!</h5>
                  <p class="card-text">
                    You have <span class="fw-bold text-danger">3</span> pending
                    assignments and
                    <span class="fw-bold text-primary">2</span> upcoming tests
                    this week.
                  </p>
                </div>
              </div>
            </div>
          </div>

          <!-- Summary cards -->
          <div class="row mb-4">
            <div class="col-md-3 mb-4">
              <div class="card dashboard-card bg-primary text-white">
                <div class="card-body text-center">
                  <i class="bi bi-book-fill card-icon"></i>
                  <h5 class="card-title">My Courses</h5>
                  <h2 class="card-text">6</h2>
                </div>
              </div>
            </div>
            <div class="col-md-3 mb-4">
              <div class="card dashboard-card bg-success text-white">
                <div class="card-body text-center">
                  <i class="bi bi-clipboard-check-fill card-icon"></i>
                  <h5 class="card-title">Attendance</h5>
                  <h2 class="card-text">96%</h2>
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
                  <h2 class="card-text">4</h2>
                </div>
              </div>
            </div>
          </div>

          <!-- Today's Schedule and Upcoming Tests -->
          <div class="row mb-4">
            <div class="col-md-8 mb-4">
              <div class="card dashboard-card">
                <div class="card-header bg-white">
                  <h5 class="card-title mb-0">Today's Schedule</h5>
                </div>
                <div class="card-body">
                  <table class="table">
                    <thead>
                      <tr>
                        <th>Time</th>
                        <th>Subject</th>
                        <th>Teacher</th>
                        <th>Room</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>08:00 - 09:30</td>
                        <td>Mathematics</td>
                        <td>Mr. John Smith</td>
                        <td>301</td>
                      </tr>
                      <tr>
                        <td>09:45 - 11:15</td>
                        <td>English Literature</td>
                        <td>Mrs. Sarah Johnson</td>
                        <td>203</td>
                      </tr>
                      <tr>
                        <td>11:30 - 13:00</td>
                        <td>Physics</td>
                        <td>Dr. Robert Brown</td>
                        <td>305</td>
                      </tr>
                      <tr>
                        <td>14:00 - 15:30</td>
                        <td>Computer Science</td>
                        <td>Ms. Emily Davis</td>
                        <td>401</td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-4">
              <div class="card dashboard-card">
                <div class="card-header bg-white">
                  <h5 class="card-title mb-0">Upcoming Tests</h5>
                </div>
                <div class="card-body">
                  <ul class="list-group list-group-flush">
                    <li class="list-group-item">
                      <div class="d-flex w-100 justify-content-between">
                        <h6 class="mb-1">Mathematics</h6>
                        <small class="text-danger">Tomorrow</small>
                      </div>
                      <p class="mb-1">Algebra and Calculus</p>
                      <small>Mr. John Smith</small>
                    </li>
                    <li class="list-group-item">
                      <div class="d-flex w-100 justify-content-between">
                        <h6 class="mb-1">Physics</h6>
                        <small>3 days left</small>
                      </div>
                      <p class="mb-1">Mechanics and Thermodynamics</p>
                      <small>Dr. Robert Brown</small>
                    </li>
                    <li class="list-group-item">
                      <div class="d-flex w-100 justify-content-between">
                        <h6 class="mb-1">English Literature</h6>
                        <small>Next week</small>
                      </div>
                      <p class="mb-1">Shakespearean Sonnets</p>
                      <small>Mrs. Sarah Johnson</small>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
          </div>

          <!-- Pending Assignments and Course Progress -->
          <div class="row mb-4">
            <div class="col-md-6 mb-4">
              <div class="card dashboard-card">
                <div class="card-header bg-white">
                  <h5 class="card-title mb-0">Pending Assignments</h5>
                </div>
                <div class="card-body">
                  <ul class="list-group list-group-flush">
                    <li
                      class="list-group-item d-flex justify-content-between align-items-center"
                    >
                      <div>
                        <span class="fw-bold">Mathematics</span>
                        <p class="text-muted mb-0">
                          Calculus Problems - Due: Tomorrow
                        </p>
                      </div>
                      <span class="badge bg-danger rounded-pill">Urgent</span>
                    </li>
                    <li
                      class="list-group-item d-flex justify-content-between align-items-center"
                    >
                      <div>
                        <span class="fw-bold">Physics</span>
                        <p class="text-muted mb-0">Lab Report - Due: 3 days</p>
                      </div>
                      <span class="badge bg-warning rounded-pill"
                        >Important</span
                      >
                    </li>
                    <li
                      class="list-group-item d-flex justify-content-between align-items-center"
                    >
                      <div>
                        <span class="fw-bold">Computer Science</span>
                        <p class="text-muted mb-0">
                          Programming Project - Due: Next week
                        </p>
                      </div>
                      <span class="badge bg-info rounded-pill">Upcoming</span>
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
              <div class="card dashboard-card">
                <div class="card-header bg-white">
                  <h5 class="card-title mb-0">Course Progress</h5>
                </div>
                <div class="card-body">
                  <div class="mb-3">
                    <div class="d-flex justify-content-between mb-1">
                      <span>Mathematics</span>
                      <span>85%</span>
                    </div>
                    <div class="progress mb-2">
                      <div
                        class="progress-bar bg-success"
                        role="progressbar"
                        style="width: 85%"
                        aria-valuenow="85"
                        aria-valuemin="0"
                        aria-valuemax="100"
                      ></div>
                    </div>
                  </div>
                  <div class="mb-3">
                    <div class="d-flex justify-content-between mb-1">
                      <span>English Literature</span>
                      <span>70%</span>
                    </div>
                    <div class="progress mb-2">
                      <div
                        class="progress-bar bg-primary"
                        role="progressbar"
                        style="width: 70%"
                        aria-valuenow="70"
                        aria-valuemin="0"
                        aria-valuemax="100"
                      ></div>
                    </div>
                  </div>
                  <div class="mb-3">
                    <div class="d-flex justify-content-between mb-1">
                      <span>Physics</span>
                      <span>60%</span>
                    </div>
                    <div class="progress mb-2">
                      <div
                        class="progress-bar bg-info"
                        role="progressbar"
                        style="width: 60%"
                        aria-valuenow="60"
                        aria-valuemin="0"
                        aria-valuemax="100"
                      ></div>
                    </div>
                  </div>
                  <div class="mb-3">
                    <div class="d-flex justify-content-between mb-1">
                      <span>Computer Science</span>
                      <span>90%</span>
                    </div>
                    <div class="progress mb-2">
                      <div
                        class="progress-bar bg-success"
                        role="progressbar"
                        style="width: 90%"
                        aria-valuenow="90"
                        aria-valuemin="0"
                        aria-valuemax="100"
                      ></div>
                    </div>
                  </div>
                  <div class="mb-3">
                    <div class="d-flex justify-content-between mb-1">
                      <span>Chemistry</span>
                      <span>65%</span>
                    </div>
                    <div class="progress mb-2">
                      <div
                        class="progress-bar bg-warning"
                        role="progressbar"
                        style="width: 65%"
                        aria-valuenow="65"
                        aria-valuemin="0"
                        aria-valuemax="100"
                      ></div>
                    </div>
                  </div>
                  <div>
                    <div class="d-flex justify-content-between mb-1">
                      <span>History</span>
                      <span>75%</span>
                    </div>
                    <div class="progress">
                      <div
                        class="progress-bar bg-primary"
                        role="progressbar"
                        style="width: 75%"
                        aria-valuenow="75"
                        aria-valuemin="0"
                        aria-valuemax="100"
                      ></div>
                    </div>
                  </div>
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
