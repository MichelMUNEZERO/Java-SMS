<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Dashboard - School Management System</title>
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

      .card-link {
        text-decoration: none;
        color: inherit;
      }

      .chart-container {
        height: 300px;
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
                  <i class="bi bi-person me-2"></i> Students
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="#">
                  <i class="bi bi-person-badge me-2"></i> Teachers
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="#">
                  <i class="bi bi-book me-2"></i> Courses
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="#">
                  <i class="bi bi-calendar-event me-2"></i> Schedule
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="#">
                  <i class="bi bi-megaphone me-2"></i> Announcements
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="#">
                  <i class="bi bi-gear me-2"></i> Settings
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
            <h1 class="h2">Admin Dashboard</h1>
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
                  <i class="bi bi-people-fill card-icon"></i>
                  <h5 class="card-title">Total Students</h5>
                  <h2 class="card-text"></h2>
                  <a href="#" class="text-white"
                    >View Details <i class="bi bi-arrow-right-circle"></i
                  ></a>
                </div>
              </div>
            </div>
            <div class="col-md-3 mb-4">
              <div class="card dashboard-card bg-success text-white">
                <div class="card-body text-center">
                  <i class="bi bi-person-badge-fill card-icon"></i>
                  <h5 class="card-title">Total Teachers</h5>
                  <h2 class="card-text">32</h2>
                  <a href="#" class="text-white"
                    >View Details <i class="bi bi-arrow-right-circle"></i
                  ></a>
                </div>
              </div>
            </div>
            <div class="col-md-3 mb-4">
              <div class="card dashboard-card bg-warning text-white">
                <div class="card-body text-center">
                  <i class="bi bi-book-fill card-icon"></i>
                  <h5 class="card-title">Total Courses</h5>
                  <h2 class="card-text">24</h2>
                  <a href="#" class="text-white"
                    >View Details <i class="bi bi-arrow-right-circle"></i
                  ></a>
                </div>
              </div>
            </div>
            <div class="col-md-3 mb-4">
              <div class="card dashboard-card bg-danger text-white">
                <div class="card-body text-center">
                  <i class="bi bi-calendar-event-fill card-icon"></i>
                  <h5 class="card-title">Events Today</h5>
                  <h2 class="card-text">5</h2>
                  <a href="#" class="text-white"
                    >View Details <i class="bi bi-arrow-right-circle"></i
                  ></a>
                </div>
              </div>
            </div>
          </div>

          <!-- Recent Activity and Announcements -->
          <div class="row mb-4">
            <div class="col-md-8 mb-4">
              <div class="card dashboard-card">
                <div class="card-header bg-white">
                  <h5 class="card-title mb-0">Recent Activity</h5>
                </div>
                <div class="card-body">
                  <ul class="list-group list-group-flush">
                    <li
                      class="list-group-item d-flex justify-content-between align-items-center"
                    >
                      <div>
                        <i class="bi bi-person-plus text-primary me-2"></i>
                        <span>New student Jane Doe was registered</span>
                      </div>
                      <span class="badge bg-primary rounded-pill"
                        >5 mins ago</span
                      >
                    </li>
                    <li
                      class="list-group-item d-flex justify-content-between align-items-center"
                    >
                      <div>
                        <i class="bi bi-calendar-check text-success me-2"></i>
                        <span>Math exam scheduled for Class 10</span>
                      </div>
                      <span class="badge bg-primary rounded-pill"
                        >2 hours ago</span
                      >
                    </li>
                    <li
                      class="list-group-item d-flex justify-content-between align-items-center"
                    >
                      <div>
                        <i
                          class="bi bi-file-earmark-text text-warning me-2"
                        ></i>
                        <span>Annual report for 2023 generated</span>
                      </div>
                      <span class="badge bg-primary rounded-pill"
                        >Yesterday</span
                      >
                    </li>
                    <li
                      class="list-group-item d-flex justify-content-between align-items-center"
                    >
                      <div>
                        <i class="bi bi-megaphone text-danger me-2"></i>
                        <span>New announcement: Summer break schedule</span>
                      </div>
                      <span class="badge bg-primary rounded-pill"
                        >2 days ago</span
                      >
                    </li>
                    <li
                      class="list-group-item d-flex justify-content-between align-items-center"
                    >
                      <div>
                        <i class="bi bi-person-badge text-info me-2"></i>
                        <span>New teacher John Smith was added</span>
                      </div>
                      <span class="badge bg-primary rounded-pill"
                        >3 days ago</span
                      >
                    </li>
                  </ul>
                </div>
                <div class="card-footer bg-white">
                  <a href="#" class="btn btn-sm btn-outline-primary"
                    >View All Activity</a
                  >
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-4">
              <div class="card dashboard-card">
                <div class="card-header bg-white">
                  <h5 class="card-title mb-0">Quick Actions</h5>
                </div>
                <div class="card-body">
                  <div class="d-grid gap-2">
                    <button class="btn btn-primary" type="button">
                      <i class="bi bi-person-plus me-2"></i> Add New Student
                    </button>
                    <button class="btn btn-success" type="button">
                      <i class="bi bi-person-badge-fill me-2"></i> Add New
                      Teacher
                    </button>
                    <button class="btn btn-warning" type="button">
                      <i class="bi bi-book-fill me-2"></i> Add New Course
                    </button>
                    <button class="btn btn-info" type="button">
                      <i class="bi bi-megaphone me-2"></i> Post Announcement
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
        </div>
      </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
