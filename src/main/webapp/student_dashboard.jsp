<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
      rel="stylesheet"
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
      .content-card {
        transition: transform 0.3s;
        border-radius: var(--border-radius);
        border: none;
        box-shadow: var(--card-shadow);
        margin-bottom: 1.5rem;
      }

      .content-card:hover {
        transform: translateY(-5px);
        box-shadow: var(--hover-shadow);
      }

      .card-icon {
        font-size: 2.5rem;
        margin-bottom: 1rem;
      }

      .progress {
        height: 10px;
        border-radius: 5px;
      }
      
      .profile-img {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        object-fit: cover;
      }
      
      .summary-card {
        transition: all 0.3s ease;
        height: 100%;
      }
      
      .summary-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 20px rgba(0,0,0,0.1);
      }
      
      .table-hoverable tr {
        transition: all 0.2s;
      }
      
      .table-hoverable tr:hover {
        background-color: rgba(13, 110, 253, 0.05);
      }
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
        <!-- Include Student Sidebar -->
        <jsp:include page="/WEB-INF/includes/student-sidebar.jsp" />

        <!-- Main content -->
        <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
          <!-- Breadcrumb -->
          <nav aria-label="breadcrumb" class="mt-3">
            <ol class="breadcrumb">
              <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/dashboard">Home</a>
              </li>
              <li class="breadcrumb-item active" aria-current="page">
                Student Dashboard
              </li>
            </ol>
          </nav>

          <div class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center">
            <h1 class="page-title">Student Dashboard</h1>
            <div class="btn-toolbar mb-2 mb-md-0">
              <div class="dropdown">
                <button
                  class="btn btn-outline-secondary dropdown-toggle d-flex align-items-center"
                  type="button"
                  id="dropdownMenuLink"
                  data-bs-toggle="dropdown"
                  aria-expanded="false"
                >
                  <c:choose>
                    <c:when test="${not empty profileData.imageLink}">
                      <img src="${profileData.imageLink}" alt="${user.username}" class="profile-img me-2">
                    </c:when>
                    <c:otherwise>
                      <i class="bi bi-person-circle me-1"></i>
                    </c:otherwise>
                  </c:choose>
                  <span>${user.username}</span>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenuLink">
                  <li>
                    <a class="dropdown-item" href="#"
                      ><i class="bi bi-person me-2"></i> Profile</a
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

          <!-- Error display -->
          <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">${error}</div>
          </c:if>

          <!-- Welcome message -->
          <div class="row mb-4">
            <div class="col-md-12">
              <div class="content-card">
                <div class="card-body">
                  <div class="d-flex align-items-center">
                    <div class="flex-shrink-0">
                      <div class="bg-primary bg-opacity-10 p-3 rounded-circle">
                        <i class="bi bi-mortarboard text-primary fs-3"></i>
                      </div>
                    </div>
                    <div class="flex-grow-1 ms-3">
                      <h5 class="card-title mb-1">Welcome, ${user.username}!</h5>
                      <p class="card-text mb-0">
                        You have
                        <span class="badge bg-danger rounded-pill"
                          >${pendingAssignmentsCount} pending assignments</span
                        >
                        and
                        <span class="badge bg-primary rounded-pill"
                          >${upcomingTestsCount} upcoming tests</span
                        >
                        this week.
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Summary cards -->
          <div class="row mb-4">
            <div class="col-md-3 mb-4">
              <div class="content-card h-100 summary-card">
                <div class="card-body p-4">
                  <div class="d-flex justify-content-between align-items-center mb-3">
                    <div class="bg-primary bg-opacity-10 p-3 rounded">
                      <i class="bi bi-book text-primary fs-3"></i>
                    </div>
                    <h2 class="text-primary mb-0">${courseCount}</h2>
                  </div>
                  <h5 class="text-muted mt-3 mb-0">My Courses</h5>
                  <div class="progress mt-3">
                    <div class="progress-bar bg-primary" role="progressbar" style="width: ${(courseCount/10) * 100}%" aria-valuenow="${courseCount}" aria-valuemin="0" aria-valuemax="10"></div>
                  </div>
                </div>
                <div class="card-footer bg-transparent border-0 text-end">
                  <a href="${pageContext.request.contextPath}/student/courses" class="text-decoration-none text-primary">View All</a>
                </div>
              </div>
            </div>
            <div class="col-md-3 mb-4">
              <div class="content-card h-100 summary-card">
                <div class="card-body p-4">
                  <div class="d-flex justify-content-between align-items-center mb-3">
                    <div class="bg-success bg-opacity-10 p-3 rounded">
                      <i class="bi bi-clipboard-check text-success fs-3"></i>
                    </div>
                    <h2 class="text-success mb-0">${attendancePercentage}%</h2>
                  </div>
                  <h5 class="text-muted mt-3 mb-0">Attendance</h5>
                  <div class="progress mt-3">
                    <div class="progress-bar bg-success" role="progressbar" style="width: ${attendancePercentage}%" aria-valuenow="${attendancePercentage}" aria-valuemin="0" aria-valuemax="100"></div>
                  </div>
                </div>
                <div class="card-footer bg-transparent border-0 text-end">
                  <a href="#" class="text-decoration-none text-success">Details</a>
                </div>
              </div>
            </div>
            <div class="col-md-3 mb-4">
              <div class="content-card h-100 summary-card">
                <div class="card-body p-4">
                  <div class="d-flex justify-content-between align-items-center mb-3">
                    <div class="bg-warning bg-opacity-10 p-3 rounded">
                      <i class="bi bi-file-earmark-text text-warning fs-3"></i>
                    </div>
                    <h2 class="text-warning mb-0">${assignmentsCount}</h2>
                  </div>
                  <h5 class="text-muted mt-3 mb-0">Assignments</h5>
                  <div class="progress mt-3">
                    <div class="progress-bar bg-warning" role="progressbar" style="width: ${(assignmentsCount/20) * 100}%" aria-valuenow="${assignmentsCount}" aria-valuemin="0" aria-valuemax="20"></div>
                  </div>
                </div>
                <div class="card-footer bg-transparent border-0 text-end">
                  <a href="${pageContext.request.contextPath}/student/assignments" class="text-decoration-none text-warning">View All</a>
                </div>
              </div>
            </div>
            <div class="col-md-3 mb-4">
              <div class="content-card h-100 summary-card">
                <div class="card-body p-4">
                  <div class="d-flex justify-content-between align-items-center mb-3">
                    <div class="bg-info bg-opacity-10 p-3 rounded">
                      <i class="bi bi-calendar-event text-info fs-3"></i>
                    </div>
                    <h2 class="text-info mb-0">${todayClassesCount}</h2>
                  </div>
                  <h5 class="text-muted mt-3 mb-0">Today's Classes</h5>
                  <div class="progress mt-3">
                    <div class="progress-bar bg-info" role="progressbar" style="width: ${(todayClassesCount/8) * 100}%" aria-valuenow="${todayClassesCount}" aria-valuemin="0" aria-valuemax="8"></div>
                  </div>
                </div>
                <div class="card-footer bg-transparent border-0 text-end">
                  <a href="#" class="text-decoration-none text-info">Schedule</a>
                </div>
              </div>
            </div>
          </div>

          <!-- Today's Schedule and Upcoming Tests -->
          <div class="row mb-4">
            <div class="col-md-8 mb-4">
              <div class="content-card h-100">
                <div class="card-header bg-white py-3">
                  <div class="d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0 d-flex align-items-center">
                      <i class="bi bi-calendar-week me-2 text-primary"></i>
                      Today's Schedule
                    </h5>
                    <div class="dropdown">
                      <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" id="scheduleOptions" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-funnel me-1"></i> Filter
                      </button>
                      <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="scheduleOptions">
                        <li><a class="dropdown-item" href="#">All Classes</a></li>
                        <li><a class="dropdown-item" href="#">Morning Classes</a></li>
                        <li><a class="dropdown-item" href="#">Afternoon Classes</a></li>
                      </ul>
                    </div>
                  </div>
                </div>
                <div class="card-body p-0">
                  <div class="table-responsive">
                    <table class="table table-hover align-middle table-hoverable mb-0">
                      <thead class="table-light">
                        <tr>
                          <th>Time</th>
                          <th>Subject</th>
                          <th>Teacher</th>
                          <th class="text-center">Room</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td>
                            <div class="bg-light rounded p-2 text-center" style="width: 100px">
                              <span class="d-block fw-bold">08:00</span>
                              <small class="text-muted">- 09:30</small>
                            </div>
                          </td>
                          <td>
                            <div class="d-flex align-items-center">
                              <span class="badge bg-primary rounded-circle p-2 me-2">
                                <i class="bi bi-calculator"></i>
                              </span>
                              <span>Mathematics</span>
                            </div>
                          </td>
                          <td>
                            <div class="d-flex align-items-center">
                              <div class="bg-secondary bg-opacity-10 text-secondary p-2 rounded-circle me-2">
                                <i class="bi bi-person-fill"></i>
                              </div>
                              Mr. John Smith
                            </div>
                          </td>
                          <td class="text-center">
                            <span class="badge bg-info rounded-pill px-3">301</span>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <div class="bg-light rounded p-2 text-center" style="width: 100px">
                              <span class="d-block fw-bold">09:45</span>
                              <small class="text-muted">- 11:15</small>
                            </div>
                          </td>
                          <td>
                            <div class="d-flex align-items-center">
                              <span class="badge bg-danger rounded-circle p-2 me-2">
                                <i class="bi bi-book"></i>
                              </span>
                              <span>English Literature</span>
                            </div>
                          </td>
                          <td>
                            <div class="d-flex align-items-center">
                              <div class="bg-secondary bg-opacity-10 text-secondary p-2 rounded-circle me-2">
                                <i class="bi bi-person-fill"></i>
                              </div>
                              Mrs. Sarah Johnson
                            </div>
                          </td>
                          <td class="text-center">
                            <span class="badge bg-info rounded-pill px-3">203</span>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <div class="bg-light rounded p-2 text-center" style="width: 100px">
                              <span class="d-block fw-bold">11:30</span>
                              <small class="text-muted">- 13:00</small>
                            </div>
                          </td>
                          <td>
                            <div class="d-flex align-items-center">
                              <span class="badge bg-success rounded-circle p-2 me-2">
                                <i class="bi bi-lightning"></i>
                              </span>
                              <span>Physics</span>
                            </div>
                          </td>
                          <td>
                            <div class="d-flex align-items-center">
                              <div class="bg-secondary bg-opacity-10 text-secondary p-2 rounded-circle me-2">
                                <i class="bi bi-person-fill"></i>
                              </div>
                              Dr. Robert Brown
                            </div>
                          </td>
                          <td class="text-center">
                            <span class="badge bg-info rounded-pill px-3">305</span>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <div class="bg-light rounded p-2 text-center" style="width: 100px">
                              <span class="d-block fw-bold">14:00</span>
                              <small class="text-muted">- 15:30</small>
                            </div>
                          </td>
                          <td>
                            <div class="d-flex align-items-center">
                              <span class="badge bg-warning text-dark rounded-circle p-2 me-2">
                                <i class="bi bi-pc-display"></i>
                              </span>
                              <span>Computer Science</span>
                            </div>
                          </td>
                          <td>
                            <div class="d-flex align-items-center">
                              <div class="bg-secondary bg-opacity-10 text-secondary p-2 rounded-circle me-2">
                                <i class="bi bi-person-fill"></i>
                              </div>
                              Ms. Emily Davis
                            </div>
                          </td>
                          <td class="text-center">
                            <span class="badge bg-info rounded-pill px-3">401</span>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-4">
              <div class="content-card h-100">
                <div class="card-header bg-white py-3">
                  <div class="d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0 d-flex align-items-center">
                      <i class="bi bi-journal-check me-2 text-primary"></i>
                      Upcoming Tests
                    </h5>
                  </div>
                </div>
                <div class="card-body p-0">
                  <ul class="list-group list-group-flush">
                    <li class="list-group-item px-3 py-3 d-flex">
                      <div class="flex-shrink-0">
                        <div class="bg-danger bg-opacity-10 text-danger p-3 rounded">
                          <i class="bi bi-calendar-event-fill fs-4"></i>
                        </div>
                      </div>
                      <div class="ms-3">
                        <div class="d-flex justify-content-between align-items-center">
                          <h6 class="mb-1 fw-bold">Mathematics</h6>
                          <span class="badge bg-danger rounded-pill">Tomorrow</span>
                        </div>
                        <p class="mb-1 text-muted">Algebra and Calculus</p>
                        <small class="text-secondary">Mr. John Smith</small>
                      </div>
                    </li>
                    <li class="list-group-item px-3 py-3 d-flex">
                      <div class="flex-shrink-0">
                        <div class="bg-warning bg-opacity-10 text-warning p-3 rounded">
                          <i class="bi bi-calendar-event-fill fs-4"></i>
                        </div>
                      </div>
                      <div class="ms-3">
                        <div class="d-flex justify-content-between align-items-center">
                          <h6 class="mb-1 fw-bold">Physics</h6>
                          <span class="badge bg-warning text-dark rounded-pill">3 days left</span>
                        </div>
                        <p class="mb-1 text-muted">Mechanics and Thermodynamics</p>
                        <small class="text-secondary">Dr. Robert Brown</small>
                      </div>
                    </li>
                    <li class="list-group-item px-3 py-3 d-flex">
                      <div class="flex-shrink-0">
                        <div class="bg-info bg-opacity-10 text-info p-3 rounded">
                          <i class="bi bi-calendar-event-fill fs-4"></i>
                        </div>
                      </div>
                      <div class="ms-3">
                        <div class="d-flex justify-content-between align-items-center">
                          <h6 class="mb-1 fw-bold">English Literature</h6>
                          <span class="badge bg-info rounded-pill">Next week</span>
                        </div>
                        <p class="mb-1 text-muted">Shakespearean Sonnets</p>
                        <small class="text-secondary">Mrs. Sarah Johnson</small>
                      </div>
                    </li>
                  </ul>
                </div>
                <div class="card-footer bg-white text-center py-3">
                  <a href="#" class="btn btn-sm btn-outline-primary">
                    <i class="bi bi-calendar3 me-1"></i> View Full Calendar
                  </a>
                </div>
              </div>
            </div>
          </div>

          <!-- Pending Assignments and Notifications -->
          <div class="row mb-4">
            <div class="col-md-6 mb-4">
              <div class="content-card h-100">
                <div class="card-header bg-white py-3">
                  <div class="d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0 d-flex align-items-center">
                      <i class="bi bi-file-earmark-text me-2 text-primary"></i>
                      Pending Assignments
                    </h5>
                    <span class="badge bg-danger rounded-pill">${pendingAssignmentsCount}</span>
                  </div>
                </div>
                <div class="card-body p-0">
                  <div class="list-group list-group-flush">
                    <div class="list-group-item border-0 p-3">
                      <div class="d-flex w-100 justify-content-between">
                        <div class="d-flex align-items-center">
                          <div class="bg-danger bg-opacity-10 p-2 rounded me-3">
                            <i class="bi bi-file-earmark-text text-danger"></i>
                          </div>
                          <div>
                            <h6 class="mb-1 fw-bold">Mathematics</h6>
                            <p class="text-muted mb-0 small">
                              Calculus Problems
                            </p>
                          </div>
                        </div>
                        <div class="text-end">
                          <span class="badge bg-danger mb-1">Due: Tomorrow</span>
                          <div>
                            <a href="#" class="btn btn-sm btn-outline-primary">
                              <i class="bi bi-upload"></i> Submit
                            </a>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="list-group-item border-0 p-3">
                      <div class="d-flex w-100 justify-content-between">
                        <div class="d-flex align-items-center">
                          <div class="bg-warning bg-opacity-10 p-2 rounded me-3">
                            <i class="bi bi-file-earmark-text text-warning"></i>
                          </div>
                          <div>
                            <h6 class="mb-1 fw-bold">Physics</h6>
                            <p class="text-muted mb-0 small">
                              Lab Report
                            </p>
                          </div>
                        </div>
                        <div class="text-end">
                          <span class="badge bg-warning text-dark mb-1">Due: 3 days</span>
                          <div>
                            <a href="#" class="btn btn-sm btn-outline-primary">
                              <i class="bi bi-upload"></i> Submit
                            </a>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="list-group-item border-0 p-3">
                      <div class="d-flex w-100 justify-content-between">
                        <div class="d-flex align-items-center">
                          <div class="bg-info bg-opacity-10 p-2 rounded me-3">
                            <i class="bi bi-file-earmark-text text-info"></i>
                          </div>
                          <div>
                            <h6 class="mb-1 fw-bold">Computer Science</h6>
                            <p class="text-muted mb-0 small">
                              Programming Project
                            </p>
                          </div>
                        </div>
                        <div class="text-end">
                          <span class="badge bg-info mb-1">Due: Next week</span>
                          <div>
                            <a href="#" class="btn btn-sm btn-outline-primary">
                              <i class="bi bi-upload"></i> Submit
                            </a>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="card-footer bg-white text-center py-3">
                  <a href="${pageContext.request.contextPath}/student/assignments" class="btn btn-sm btn-primary">
                    <i class="bi bi-list-task me-1"></i> View All Assignments
                  </a>
                </div>
              </div>
            </div>
            <div class="col-md-6 mb-4">
              <div class="content-card h-100">
                <div class="card-header bg-white py-3">
                  <div class="d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0 d-flex align-items-center">
                      <i class="bi bi-bell me-2 text-primary"></i>
                      Notifications
                    </h5>
                    <span class="badge bg-primary rounded-pill">4</span>
                  </div>
                </div>
                <div class="card-body p-0">
                  <c:choose>
                    <c:when test="${empty announcements}">
                      <div class="list-group list-group-flush">
                        <div class="list-group-item border-0 p-3">
                          <div class="d-flex">
                            <div class="flex-shrink-0">
                              <div class="bg-success bg-opacity-10 p-2 rounded">
                                <i class="bi bi-check-circle text-success"></i>
                              </div>
                            </div>
                            <div class="ms-3">
                              <div class="d-flex justify-content-between align-items-center">
                                <h6 class="mb-1 fw-bold">New Grade Posted</h6>
                                <small class="text-muted">Today</small>
                              </div>
                              <p class="mb-1 text-muted">Your Physics quiz has been graded.</p>
                              <span class="badge bg-success">Grade: A</span>
                            </div>
                          </div>
                        </div>
                        <div class="list-group-item border-0 p-3">
                          <div class="d-flex">
                            <div class="flex-shrink-0">
                              <div class="bg-primary bg-opacity-10 p-2 rounded">
                                <i class="bi bi-megaphone text-primary"></i>
                              </div>
                            </div>
                            <div class="ms-3">
                              <div class="d-flex justify-content-between align-items-center">
                                <h6 class="mb-1 fw-bold">School Announcement</h6>
                                <small class="text-muted">Yesterday</small>
                              </div>
                              <p class="mb-1 text-muted">Field trip permission slips due this Friday.</p>
                            </div>
                          </div>
                        </div>
                        <div class="list-group-item border-0 p-3">
                          <div class="d-flex">
                            <div class="flex-shrink-0">
                              <div class="bg-warning bg-opacity-10 p-2 rounded">
                                <i class="bi bi-exclamation-triangle text-warning"></i>
                              </div>
                            </div>
                            <div class="ms-3">
                              <div class="d-flex justify-content-between align-items-center">
                                <h6 class="mb-1 fw-bold">Assignment Reminder</h6>
                                <small class="text-muted">2 days ago</small>
                              </div>
                              <p class="mb-1 text-muted">Don't forget to submit your Math homework!</p>
                            </div>
                          </div>
                        </div>
                        <div class="list-group-item border-0 p-3">
                          <div class="d-flex">
                            <div class="flex-shrink-0">
                              <div class="bg-info bg-opacity-10 p-2 rounded">
                                <i class="bi bi-calendar text-info"></i>
                              </div>
                            </div>
                            <div class="ms-3">
                              <div class="d-flex justify-content-between align-items-center">
                                <h6 class="mb-1 fw-bold">Calendar Update</h6>
                                <small class="text-muted">3 days ago</small>
                              </div>
                              <p class="mb-1 text-muted">School holiday announced for next Monday.</p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </c:when>
                    <c:otherwise>
                      <div class="list-group list-group-flush">
                        <c:forEach var="announcement" items="${announcements}">
                          <div class="list-group-item border-0 p-3">
                            <div class="d-flex">
                              <div class="flex-shrink-0">
                                <div class="bg-primary bg-opacity-10 p-2 rounded">
                                  <i class="bi bi-megaphone text-primary"></i>
                                </div>
                              </div>
                              <div class="ms-3">
                                <div class="d-flex justify-content-between align-items-center">
                                  <h6 class="mb-1 fw-bold">School Announcement</h6>
                                  <small class="text-muted">${announcement.createdAt}</small>
                                </div>
                                <p class="mb-1 text-muted">${announcement.content}</p>
                              </div>
                            </div>
                          </div>
                        </c:forEach>
                      </div>
                    </c:otherwise>
                  </c:choose>
                </div>
                <div class="card-footer bg-white text-center py-3">
                  <a href="#" class="btn btn-sm btn-primary">
                    <i class="bi bi-bell me-1"></i> View All Notifications
                  </a>
                </div>
              </div>
            </div>
          </div>

          <!-- Parent Information Card -->
          <div class="row mb-4">
            <div class="col-md-12">
              <div class="content-card">
                <div class="card-body p-0">
                  <div class="row g-0">
                    <div class="col-md-3 bg-primary text-white p-4 d-flex align-items-center justify-content-center" style="border-radius: var(--border-radius) 0 0 var(--border-radius)">
                      <div class="text-center">
                        <i class="bi bi-people fs-1 mb-3"></i>
                        <h5 class="card-title mb-0">Parent Information</h5>
                      </div>
                    </div>
                    <div class="col-md-9 p-4">
                      <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                          <h5 class="mb-1">Keep Your Information Up-To-Date</h5>
                          <p class="text-muted mb-0">Ensure your parent information is current for emergency contacts, school communications, and important notifications.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/student/update-parent" class="btn btn-primary">
                          <i class="bi bi-pencil-square me-2"></i> Update Info
                        </a>
                      </div>
                      <div class="bg-light p-3 rounded">
                        <div class="d-flex align-items-center">
                          <i class="bi bi-info-circle text-primary me-2"></i>
                          <p class="mb-0 small">Your parent's information is used by the school for emergency contacts, report card distribution, and important school announcements.</p>
                        </div>
                      </div>
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
    
    <script>
      document.addEventListener('DOMContentLoaded', function() {
        // Add some animations for better UX
        const cards = document.querySelectorAll('.content-card');
        cards.forEach((card, index) => {
          card.style.opacity = '0';
          card.style.transition = 'opacity 0.5s ease, transform 0.3s ease';
          setTimeout(() => {
            card.style.opacity = '1';
          }, 100 * index);
        });
      });
    </script>
  </body>
</html>
