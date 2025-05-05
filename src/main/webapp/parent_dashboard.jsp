<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Parent Dashboard - School Management System</title>
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
      .dashboard-card {
        transition: transform 0.3s;
        border-radius: var(--border-radius);
        border: none;
        box-shadow: var(--card-shadow);
        height: 100%;
      }

      .dashboard-card:hover {
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

      .student-avatar {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        object-fit: cover;
      }
      
      .profile-img {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        object-fit: cover;
      }
      
      .badge {
        font-weight: 500;
        padding: 0.35em 0.65em;
      }
      
      .dashboard-stats {
        transition: all 0.3s;
      }
      
      .dashboard-stats:hover {
        transform: scale(1.05);
      }
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
        <!-- Include Parent Sidebar -->
        <jsp:include page="/WEB-INF/includes/parent-sidebar.jsp" />

        <!-- Main content -->
        <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
          <!-- Breadcrumb and Header -->
          <nav aria-label="breadcrumb" class="mt-3">
            <ol class="breadcrumb">
              <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/dashboard">Home</a>
              </li>
              <li class="breadcrumb-item active" aria-current="page">
                Parent Dashboard
              </li>
            </ol>
          </nav>

          <div class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center">
            <h1 class="page-title">Parent Dashboard</h1>
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

          <!-- Welcome and Child Selection -->
          <div class="row mb-4">
            <div class="col-md-8">
              <div class="content-card">
                <div class="card-body">
                  <div class="d-flex align-items-center">
                    <div class="flex-shrink-0">
                      <c:choose>
                        <c:when test="${not empty profileData.imageLink}">
                          <img src="${profileData.imageLink}" alt="${user.username}" class="mb-3" style="width: 60px; height: 60px; border-radius: 50%; object-fit: cover;">
                        </c:when>
                        <c:otherwise>
                          <div class="bg-primary text-white d-flex align-items-center justify-content-center mb-3" style="width: 60px; height: 60px; border-radius: 50%;">
                            <i class="bi bi-person-fill fs-1"></i>
                          </div>
                        </c:otherwise>
                      </c:choose>
                    </div>
                    <div class="flex-grow-1 ms-3">
                      <h5 class="mb-1">Welcome, ${user.username}!</h5>
                      <p class="card-text mb-0">
                        Welcome to your parent dashboard. Here you can monitor your
                        child's academic progress, attendance, and communicate with
                        teachers.
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-4">
              <div class="content-card">
                <div class="card-header">
                  <h5 class="mb-0">Select Child</h5>
                </div>
                <div class="card-body">
                  <c:choose>
                    <c:when test="${not empty children}">
                      <div class="form-group">
                        <select class="form-select" id="childSelector">
                          <c:forEach items="${children}" var="child">
                            <option value="${child.id}">${child.name}</option>
                          </c:forEach>
                        </select>
                      </div>
                    </c:when>
                    <c:otherwise>
                      <p class="text-muted mb-0">No children associated with your account.</p>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>
            </div>
          </div>

          <!-- Quick Stats -->
          <div class="row mb-4">
            <div class="col-md-3 mb-3">
              <div class="content-card bg-primary text-white h-100">
                <div class="card-body">
                  <div class="d-flex justify-content-between align-items-start">
                    <div>
                      <h6 class="text-white-50 mb-1">Attendance</h6>
                      <h3 class="mb-0">94.5%</h3>
                    </div>
                    <div class="card-icon text-white-50">
                      <i class="bi bi-calendar-check"></i>
                    </div>
                  </div>
                  <div class="mt-3">
                    <div class="progress bg-white bg-opacity-25">
                      <div
                        class="progress-bar bg-white"
                        role="progressbar"
                        style="width: 94.5%"
                        aria-valuenow="94.5"
                        aria-valuemin="0"
                        aria-valuemax="100"
                      ></div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="content-card bg-success text-white h-100">
                <div class="card-body">
                  <div class="d-flex justify-content-between align-items-start">
                    <div>
                      <h6 class="text-white-50 mb-1">Average Grade</h6>
                      <h3 class="mb-0">B+</h3>
                    </div>
                    <div class="card-icon text-white-50">
                      <i class="bi bi-bar-chart"></i>
                    </div>
                  </div>
                  <div class="mt-3">
                    <div class="progress bg-white bg-opacity-25">
                      <div
                        class="progress-bar bg-white"
                        role="progressbar"
                        style="width: 85%"
                        aria-valuenow="85"
                        aria-valuemin="0"
                        aria-valuemax="100"
                      ></div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="content-card bg-warning text-white h-100">
                <div class="card-body">
                  <div class="d-flex justify-content-between align-items-start">
                    <div>
                      <h6 class="text-white-50 mb-1">Assignments</h6>
                      <h3 class="mb-0">12 / 15</h3>
                    </div>
                    <div class="card-icon text-white-50">
                      <i class="bi bi-file-earmark-text"></i>
                    </div>
                  </div>
                  <div class="mt-3">
                    <div class="progress bg-white bg-opacity-25">
                      <div
                        class="progress-bar bg-white"
                        role="progressbar"
                        style="width: 80%"
                        aria-valuenow="80"
                        aria-valuemin="0"
                        aria-valuemax="100"
                      ></div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="content-card bg-danger text-white h-100">
                <div class="card-body">
                  <div class="d-flex justify-content-between align-items-start">
                    <div>
                      <h6 class="text-white-50 mb-1">Upcoming Tests</h6>
                      <h3 class="mb-0">3</h3>
                    </div>
                    <div class="card-icon text-white-50">
                      <i class="bi bi-journal-check"></i>
                    </div>
                  </div>
                  <div class="mt-3">
                    <a href="#" class="btn btn-sm btn-outline-light">View Details</a>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Recent Academic Performance -->
          <div class="row mb-4">
            <div class="col-md-8">
              <div class="content-card h-100">
                <div class="card-header d-flex justify-content-between align-items-center">
                  <h5 class="mb-0">Recent Academic Performance</h5>
                  <div class="dropdown">
                    <button
                      class="btn btn-sm btn-outline-secondary dropdown-toggle"
                      type="button"
                      id="dropdownMenuButton1"
                      data-bs-toggle="dropdown"
                      aria-expanded="false"
                    >
                      <i class="bi bi-funnel me-1"></i> Filter
                    </button>
                    <ul
                      class="dropdown-menu"
                      aria-labelledby="dropdownMenuButton1"
                    >
                      <li><a class="dropdown-item" href="#">All Subjects</a></li>
                      <li><a class="dropdown-item" href="#">Mathematics</a></li>
                      <li><a class="dropdown-item" href="#">English</a></li>
                      <li><a class="dropdown-item" href="#">Science</a></li>
                      <li><a class="dropdown-item" href="#">History</a></li>
                    </ul>
                  </div>
                </div>
                <div class="card-body">
                  <div class="table-responsive">
                    <table class="table table-hover">
                      <thead>
                        <tr>
                          <th>Subject</th>
                          <th>Test Date</th>
                          <th>Score</th>
                          <th>Grade</th>
                          <th>Status</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td>
                            <div class="d-flex align-items-center">
                              <span
                                class="badge bg-primary rounded-circle p-2 me-2"
                              >
                                <i class="bi bi-calculator"></i>
                              </span>
                              <span>Mathematics</span>
                            </div>
                          </td>
                          <td>Mar 15, 2023</td>
                          <td>85%</td>
                          <td>B+</td>
                          <td>
                            <span class="badge bg-success">Above Average</span>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <div class="d-flex align-items-center">
                              <span
                                class="badge bg-danger rounded-circle p-2 me-2"
                              >
                                <i class="bi bi-book"></i>
                              </span>
                              <span>English</span>
                            </div>
                          </td>
                          <td>Mar 12, 2023</td>
                          <td>78%</td>
                          <td>C+</td>
                          <td>
                            <span class="badge bg-warning text-dark"
                              >Average</span
                            >
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <div class="d-flex align-items-center">
                              <span
                                class="badge bg-success rounded-circle p-2 me-2"
                              >
                                <i class="bi bi-flask"></i>
                              </span>
                              <span>Science</span>
                            </div>
                          </td>
                          <td>Mar 10, 2023</td>
                          <td>92%</td>
                          <td>A</td>
                          <td>
                            <span class="badge bg-success">Above Average</span>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <div class="d-flex align-items-center">
                              <span
                                class="badge bg-warning rounded-circle p-2 me-2"
                              >
                                <i class="bi bi-globe"></i>
                              </span>
                              <span>History</span>
                            </div>
                          </td>
                          <td>Mar 8, 2023</td>
                          <td>65%</td>
                          <td>D</td>
                          <td>
                            <span class="badge bg-danger">Below Average</span>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
                <div class="card-footer text-center">
                  <a href="${pageContext.request.contextPath}/parent/student-progress" class="btn btn-sm btn-primary">
                    <i class="bi bi-arrow-right me-1"></i> View All Results
                  </a>
                </div>
              </div>
            </div>
            <div class="col-md-4">
              <div class="content-card h-100">
                <div class="card-header">
                  <h5 class="mb-0">Upcoming Events</h5>
                </div>
                <div class="card-body p-0">
                  <ul class="list-group list-group-flush">
                    <li class="list-group-item">
                      <div class="d-flex justify-content-between align-items-center">
                        <div>
                          <h6 class="mb-0">Mathematics Test</h6>
                          <small class="text-muted">
                            <i class="bi bi-calendar me-1"></i> Mar 25, 2023
                          </small>
                        </div>
                        <span class="badge bg-danger">3 days left</span>
                      </div>
                    </li>
                    <li class="list-group-item">
                      <div class="d-flex justify-content-between align-items-center">
                        <div>
                          <h6 class="mb-0">Parent-Teacher Meeting</h6>
                          <small class="text-muted">
                            <i class="bi bi-calendar me-1"></i> Mar 30, 2023
                          </small>
                        </div>
                        <span class="badge bg-warning text-dark">1 week left</span>
                      </div>
                    </li>
                    <li class="list-group-item">
                      <div class="d-flex justify-content-between align-items-center">
                        <div>
                          <h6 class="mb-0">Science Fair</h6>
                          <small class="text-muted">
                            <i class="bi bi-calendar me-1"></i> Apr 15, 2023
                          </small>
                        </div>
                        <span class="badge bg-info">3 weeks left</span>
                      </div>
                    </li>
                    <li class="list-group-item">
                      <div class="d-flex justify-content-between align-items-center">
                        <div>
                          <h6 class="mb-0">End of Term Exams</h6>
                          <small class="text-muted">
                            <i class="bi bi-calendar me-1"></i> Apr 25, 2023
                          </small>
                        </div>
                        <span class="badge bg-secondary">1 month left</span>
                      </div>
                    </li>
                  </ul>
                </div>
                <div class="card-footer text-center">
                  <a href="#" class="btn btn-sm btn-outline-primary">
                    <i class="bi bi-calendar-week me-1"></i> View Calendar
                  </a>
                </div>
              </div>
            </div>
          </div>

          <!-- Recent Announcements -->
          <div class="row mb-4">
            <div class="col-md-12">
              <div class="content-card">
                <div class="card-header d-flex justify-content-between align-items-center">
                  <h5 class="mb-0">Recent Announcements</h5>
                  <a
                    href="${pageContext.request.contextPath}/parent/announcements"
                    class="btn btn-sm btn-outline-primary"
                  >
                    <i class="bi bi-megaphone me-1"></i> All Announcements
                  </a>
                </div>
                <div class="card-body">
                  <div class="row">
                    <div class="col-md-6 mb-3">
                      <div class="p-3 border rounded">
                        <div class="d-flex justify-content-between">
                          <span class="badge bg-warning text-dark mb-2">School Admin</span>
                          <small class="text-muted">Mar 20, 2023</small>
                        </div>
                        <h6>Upcoming School Renovation</h6>
                        <p class="mb-0 text-muted">
                          The school will undergo renovation during the spring break.
                          All classes will continue as scheduled.
                        </p>
                      </div>
                    </div>
                    <div class="col-md-6 mb-3">
                      <div class="p-3 border rounded">
                        <div class="d-flex justify-content-between">
                          <span class="badge bg-info mb-2">Science Department</span>
                          <small class="text-muted">Mar 18, 2023</small>
                        </div>
                        <h6>Science Fair Registration Open</h6>
                        <p class="mb-0 text-muted">
                          Registration for the annual science fair is now open.
                          Students can register online until April 1.
                        </p>
                      </div>
                    </div>
                    <div class="col-md-6 mb-3">
                      <div class="p-3 border rounded">
                        <div class="d-flex justify-content-between">
                          <span class="badge bg-danger mb-2">Important</span>
                          <small class="text-muted">Mar 15, 2023</small>
                        </div>
                        <h6>End of Term Exam Schedule</h6>
                        <p class="mb-0 text-muted">
                          The end of term exam schedule has been published. Please
                          check the academic calendar for details.
                        </p>
                      </div>
                    </div>
                    <div class="col-md-6 mb-3">
                      <div class="p-3 border rounded">
                        <div class="d-flex justify-content-between">
                          <span class="badge bg-success mb-2">Sports Department</span>
                          <small class="text-muted">Mar 10, 2023</small>
                        </div>
                        <h6>Annual Sports Day</h6>
                        <p class="mb-0 text-muted">
                          The annual sports day will be held on April 10. All
                          parents are invited to attend and cheer for their
                          children.
                        </p>
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
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
      $(document).ready(function () {
        // Child selector change event
        $("#childSelector").on("change", function () {
          const childId = $(this).val();
          console.log("Selected child ID:", childId);
          // Here you could trigger an AJAX call to update dashboard data
          // based on the selected child
        });
      });
    </script>
  </body>
</html>

            <div class="col-md-3 mb-4">
              <div class="card dashboard-card h-100 border-0 shadow-sm dashboard-stats">
                <div class="card-body p-3">
                  <div class="d-flex justify-content-between align-items-center mb-2">
                    <div class="text-start">
                      <h6 class="text-muted mb-0">Attendance</h6>
                      <h3 class="fw-bold mb-0">${selectedChild.attendancePercentage != null ? selectedChild.attendancePercentage : '96'}%</h3>
                    </div>
                    <div class="bg-primary bg-opacity-10 p-2 rounded">
                      <i class="bi bi-clipboard-check-fill text-primary fs-3"></i>
                    </div>
                  </div>
                  <div class="progress" style="height: 6px">
                    <div class="progress-bar bg-primary" role="progressbar" 
                    style="width: ${selectedChild.attendancePercentage != null ? selectedChild.attendancePercentage : '96'}%" 
                    aria-valuenow="${selectedChild.attendancePercentage != null ? selectedChild.attendancePercentage : '96'}" 
                    aria-valuemin="0" aria-valuemax="100"></div>
                  </div>
                  <div class="text-muted small mt-2">
                    <span class="text-success">
                      <i class="bi bi-arrow-up"></i> 1.2%
                    </span> from last month
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-3 mb-4">
              <div class="card dashboard-card h-100 border-0 shadow-sm dashboard-stats">
                <div class="card-body p-3">
                  <div class="d-flex justify-content-between align-items-center mb-2">
                    <div class="text-start">
                      <h6 class="text-muted mb-0">GPA</h6>
                      <h3 class="fw-bold mb-0">${selectedChild.gpa != null ? selectedChild.gpa : '3.8'}</h3>
                    </div>
                    <div class="bg-success bg-opacity-10 p-2 rounded">
                      <i class="bi bi-award-fill text-success fs-3"></i>
                    </div>
                  </div>
                  <div class="progress" style="height: 6px">
                    <div class="progress-bar bg-success" role="progressbar" 
                    style="width: ${selectedChild.gpa != null ? (selectedChild.gpa * 25) : '95'}%" 
                    aria-valuenow="${selectedChild.gpa != null ? (selectedChild.gpa * 25) : '95'}" 
                    aria-valuemin="0" aria-valuemax="100"></div>
                  </div>
                  <div class="text-muted small mt-2">
                    <span class="text-success">
                      <i class="bi bi-arrow-up"></i> 0.2
                    </span> from last semester
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-3 mb-4">
              <div class="card dashboard-card h-100 border-0 shadow-sm dashboard-stats">
                <div class="card-body p-3">
                  <div class="d-flex justify-content-between align-items-center mb-2">
                    <div class="text-start">
                      <h6 class="text-muted mb-0">Pending Assignments</h6>
                      <h3 class="fw-bold mb-0">${selectedChild.pendingAssignments != null ? selectedChild.pendingAssignments : '3'}</h3>
                    </div>
                    <div class="bg-warning bg-opacity-10 p-2 rounded">
                      <i class="bi bi-file-earmark-text text-warning fs-3"></i>
                    </div>
                  </div>
                  <div class="progress" style="height: 6px">
                    <div class="progress-bar bg-warning" role="progressbar" 
                    style="width: ${selectedChild.pendingAssignments != null ? (selectedChild.pendingAssignments * 10) : '30'}%" 
                    aria-valuenow="${selectedChild.pendingAssignments != null ? (selectedChild.pendingAssignments * 10) : '30'}" 
                    aria-valuemin="0" aria-valuemax="100"></div>
                  </div>
                  <div class="text-muted small mt-2">
                    <span class="text-danger">
                      <i class="bi bi-arrow-up"></i> 1
                    </span> from last week
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-3 mb-4">
              <div class="card dashboard-card h-100 border-0 shadow-sm dashboard-stats">
                <div class="card-body p-3">
                  <div class="d-flex justify-content-between align-items-center mb-2">
                    <div class="text-start">
                      <h6 class="text-muted mb-0">Upcoming Events</h6>
                      <h3 class="fw-bold mb-0">${upcomingEvents != null ? upcomingEvents : '2'}</h3>
                    </div>
                    <div class="bg-info bg-opacity-10 p-2 rounded">
                      <i class="bi bi-calendar-event-fill text-info fs-3"></i>
                    </div>
                  </div>
                  <div class="progress" style="height: 6px">
                    <div class="progress-bar bg-info" role="progressbar" 
                    style="width: ${upcomingEvents != null ? (upcomingEvents * 10) : '20'}%" 
                    aria-valuenow="${upcomingEvents != null ? (upcomingEvents * 10) : '20'}" 
                    aria-valuemin="0" aria-valuemax="100"></div>
                  </div>
                  <div class="text-muted small mt-2">Next: <span class="text-info">Parent-Teacher Meeting</span></div>
                </div>
              </div>
            </div>
          </div>

          <!-- Navigational Cards -->
          <div class="row mb-4">
            <div class="col-md-4 mb-4">
              <div class="card dashboard-card h-100 shadow-sm border-0">
                <div class="card-body">
                  <div class="d-flex flex-column align-items-center text-center">
                    <div class="rounded-circle bg-primary bg-opacity-10 p-3 mb-3">
                      <i class="bi bi-card-checklist fs-1 text-primary"></i>
                    </div>
                    <h5 class="card-title">Student Progress</h5>
                    <p class="card-text">
                      View your child's academic progress, behavior records, and
                      attendance information.
                    </p>
                    <a
                      href="${pageContext.request.contextPath}/parent/student-progress"
                      class="btn btn-primary mt-auto"
                      >
                      <i class="bi bi-arrow-right-circle me-2"></i>
                      View Progress
                    </a>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-4">
              <div class="card dashboard-card h-100 shadow-sm border-0">
                <div class="card-body">
                  <div class="d-flex flex-column align-items-center text-center">
                    <div class="rounded-circle bg-success bg-opacity-10 p-3 mb-3">
                      <i class="bi bi-megaphone fs-1 text-success"></i>
                    </div>
                    <h5 class="card-title">Announcements</h5>
                    <p class="card-text">
                      Stay updated with the latest announcements from school
                      administration and teachers.
                    </p>
                    <a
                      href="${pageContext.request.contextPath}/parent/announcements"
                      class="btn btn-success mt-auto"
                      >
                      <i class="bi bi-arrow-right-circle me-2"></i>
                      View Announcements
                    </a>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-4">
              <div class="card dashboard-card h-100 shadow-sm border-0">
                <div class="card-body">
                  <div class="d-flex flex-column align-items-center text-center">
                    <div class="rounded-circle bg-danger bg-opacity-10 p-3 mb-3">
                      <i class="bi bi-calendar-check fs-1 text-danger"></i>
                    </div>
                    <h5 class="card-title">Book Appointments</h5>
                    <p class="card-text">
                      Schedule appointments with teachers and administrators to
                      discuss your child's education.
                    </p>
                    <a
                      href="${pageContext.request.contextPath}/parent/appointments"
                      class="btn btn-danger mt-auto"
                      >
                      <i class="bi bi-arrow-right-circle me-2"></i>
                      Book Appointment
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Recent Attendance and Announcements -->
          <div class="row mb-4">
            <div class="col-md-6 mb-4">
              <div class="card dashboard-card shadow-sm border-0">
                <div class="card-header bg-white py-3">
                  <div class="d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0 d-flex align-items-center">
                      <i class="bi bi-calendar-check me-2 text-primary"></i>
                      Recent Attendance
                    </h5>
                    <a href="${pageContext.request.contextPath}/parent/student-progress" class="text-decoration-none">
                      <span class="small text-primary">View All</span>
                    </a>
                  </div>
                </div>
                <div class="card-body pt-0">
                  <table class="table table-hover align-middle">
                    <thead class="table-light">
                      <tr>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Remarks</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach items="${recentAttendance}" var="attendance" varStatus="loop">
                        <tr ${loop.index % 2 == 0 ? 'class="table-light"' : ''}>
                          <td><fmt:formatDate value="${attendance.date}" pattern="MMM dd, yyyy" /></td>
                          <td>
                            <c:choose>
                              <c:when test="${attendance.status == 'PRESENT'}">
                                <span class="badge bg-success text-white rounded-pill px-3">Present</span>
                              </c:when>
                              <c:when test="${attendance.status == 'ABSENT'}">
                                <span class="badge bg-danger text-white rounded-pill px-3">Absent</span>
                              </c:when>
                              <c:when test="${attendance.status == 'LATE'}">
                                <span class="badge bg-warning text-dark rounded-pill px-3">Late</span>
                              </c:when>
                              <c:otherwise>
                                <span class="badge bg-secondary text-white rounded-pill px-3">${attendance.status}</span>
                              </c:otherwise>
                            </c:choose>
                          </td>
                          <td>${attendance.remarks != null ? attendance.remarks : '-'}</td>
                        </tr>
                      </c:forEach>
                      <c:if test="${empty recentAttendance}">
                        <tr class="table-light">
                          <td>May 15, 2023</td>
                          <td><span class="badge bg-success text-white rounded-pill px-3">Present</span></td>
                          <td>-</td>
                        </tr>
                        <tr>
                          <td>May 14, 2023</td>
                          <td><span class="badge bg-success text-white rounded-pill px-3">Present</span></td>
                          <td>-</td>
                        </tr>
                        <tr class="table-light">
                          <td>May 13, 2023</td>
                          <td><span class="badge bg-warning text-dark rounded-pill px-3">Late</span></td>
                          <td>Arrived 15 minutes late</td>
                        </tr>
                        <tr>
                          <td>May 12, 2023</td>
                          <td><span class="badge bg-success text-white rounded-pill px-3">Present</span></td>
                          <td>-</td>
                        </tr>
                        <tr class="table-light">
                          <td>May 11, 2023</td>
                          <td><span class="badge bg-danger text-white rounded-pill px-3">Absent</span></td>
                          <td>Medical leave</td>
                        </tr>
                      </c:if>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
            <div class="col-md-6 mb-4">
              <div class="card dashboard-card shadow-sm border-0">
                <div class="card-header bg-white py-3">
                  <div class="d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0 d-flex align-items-center">
                      <i class="bi bi-megaphone me-2 text-success"></i>
                      Recent Announcements
                    </h5>
                    <a href="${pageContext.request.contextPath}/parent/announcements" class="text-decoration-none">
                      <span class="small text-primary">View All</span>
                    </a>
                  </div>
                </div>
                <div class="card-body pt-0">
                  <ul class="list-group list-group-flush">
                    <c:forEach items="${recentAnnouncements}" var="announcement" varStatus="loop">
                      <li class="list-group-item px-0 py-3 ${loop.index % 2 == 0 ? 'bg-light' : ''}">
                        <div class="d-flex">
                          <div class="flex-shrink-0">
                            <div class="rounded-circle bg-success bg-opacity-10 p-2 d-flex align-items-center justify-content-center" style="width: 42px; height: 42px;">
                              <i class="bi bi-bell fs-4 text-success"></i>
                            </div>
                          </div>
                          <div class="ms-3">
                            <h6 class="mb-1 fw-bold">${announcement.title}</h6>
                            <p class="mb-1 text-muted">${announcement.content}</p>
                            <small class="text-muted d-flex align-items-center">
                              <i class="bi bi-clock me-1"></i>
                              <fmt:formatDate value="${announcement.createdAt}" pattern="MMM dd, yyyy" />
                            </small>
                          </div>
                        </div>
                      </li>
                    </c:forEach>
                    <c:if test="${empty recentAnnouncements}">
                      <li class="list-group-item px-0 py-3 bg-light">
                        <div class="d-flex">
                          <div class="flex-shrink-0">
                            <div class="rounded-circle bg-success bg-opacity-10 p-2 d-flex align-items-center justify-content-center" style="width: 42px; height: 42px;">
                              <i class="bi bi-bell fs-4 text-success"></i>
                            </div>
                          </div>
                          <div class="ms-3">
                            <h6 class="mb-1 fw-bold">Parent-Teacher Meeting</h6>
                            <p class="mb-1 text-muted">
                              The upcoming parent-teacher meeting is scheduled for
                              June 5th.
                            </p>
                            <small class="text-muted d-flex align-items-center">
                              <i class="bi bi-clock me-1"></i>
                              2 days ago
                            </small>
                          </div>
                        </div>
                      </li>
                      <li class="list-group-item px-0 py-3">
                        <div class="d-flex">
                          <div class="flex-shrink-0">
                            <div class="rounded-circle bg-warning bg-opacity-10 p-2 d-flex align-items-center justify-content-center" style="width: 42px; height: 42px;">
                              <i class="bi bi-trophy fs-4 text-warning"></i>
                            </div>
                          </div>
                          <div class="ms-3">
                            <h6 class="mb-1 fw-bold">Math Competition Results</h6>
                            <p class="mb-1 text-muted">
                              Results of the regional Math Competition are out.
                              Check the announcement board.
                            </p>
                            <small class="text-muted d-flex align-items-center">
                              <i class="bi bi-clock me-1"></i>
                              1 week ago
                            </small>
                          </div>
                        </div>
                      </li>
                      <li class="list-group-item px-0 py-3 bg-light">
                        <div class="d-flex">
                          <div class="flex-shrink-0">
                            <div class="rounded-circle bg-info bg-opacity-10 p-2 d-flex align-items-center justify-content-center" style="width: 42px; height: 42px;">
                              <i class="bi bi-info-circle fs-4 text-info"></i>
                            </div>
                          </div>
                          <div class="ms-3">
                            <h6 class="mb-1 fw-bold">School Trip Permission</h6>
                            <p class="mb-1 text-muted">
                              Please submit the permission slip for the upcoming
                              Science Museum trip.
                            </p>
                            <small class="text-muted d-flex align-items-center">
                              <i class="bi bi-clock me-1"></i>
                              2 weeks ago
                            </small>
                          </div>
                        </div>
                      </li>
                    </c:if>
                  </ul>
                </div>
              </div>
            </div>
          </div>

          <!-- Academic Performance and Teacher Communications -->
          <div class="row mb-4">
            <div class="col-md-6 mb-4">
              <div class="card dashboard-card shadow-sm border-0">
                <div class="card-header bg-white py-3">
                  <div class="d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0 d-flex align-items-center">
                      <i class="bi bi-graph-up me-2 text-primary"></i>
                      Academic Performance
                    </h5>
                    <a href="${pageContext.request.contextPath}/parent/student-progress" class="text-decoration-none">
                      <span class="small text-primary">View Report</span>
                    </a>
                  </div>
                </div>
                <div class="card-body">
                  <c:forEach items="${subjectPerformance}" var="subject" varStatus="loop">
                    <div class="mb-3 ${loop.index % 2 == 0 ? 'py-2 px-2 bg-light rounded' : ''}">
                      <div class="d-flex justify-content-between align-items-center mb-1">
                        <div class="d-flex align-items-center">
                          <span class="badge ${subject.percentage >= 90 ? 'bg-success' : (subject.percentage >= 80 ? 'bg-primary' : (subject.percentage >= 70 ? 'bg-warning' : 'bg-danger'))} me-2">
                            ${subject.grade}
                          </span>
                          <span class="fw-bold">${subject.name}</span>
                        </div>
                        <span>${subject.percentage}%</span>
                      </div>
                      <div class="progress" style="height: 6px">
                        <div
                          class="progress-bar ${subject.percentage >= 90 ? 'bg-success' : (subject.percentage >= 80 ? 'bg-primary' : (subject.percentage >= 70 ? 'bg-warning' : 'bg-danger'))}"
                          role="progressbar"
                          style="width: ${subject.percentage}%"
                          aria-valuenow="${subject.percentage}"
                          aria-valuemin="0"
                          aria-valuemax="100"
                        ></div>
                      </div>
                    </div>
                  </c:forEach>
                  <c:if test="${empty subjectPerformance}">
                    <div class="mb-3 py-2 px-2 bg-light rounded">
                      <div class="d-flex justify-content-between align-items-center mb-1">
                        <div class="d-flex align-items-center">
                          <span class="badge bg-success me-2">A</span>
                          <span class="fw-bold">Mathematics</span>
                        </div>
                        <span>92%</span>
                      </div>
                      <div class="progress" style="height: 6px">
                        <div
                          class="progress-bar bg-success"
                          role="progressbar"
                          style="width: 92%"
                          aria-valuenow="92"
                          aria-valuemin="0"
                          aria-valuemax="100"
                        ></div>
                      </div>
                    </div>
                    <div class="mb-3">
                      <div class="d-flex justify-content-between align-items-center mb-1">
                        <div class="d-flex align-items-center">
                          <span class="badge bg-success me-2">B+</span>
                          <span class="fw-bold">English Literature</span>
                        </div>
                        <span>87%</span>
                      </div>
                      <div class="progress" style="height: 6px">
                        <div
                          class="progress-bar bg-success"
                          role="progressbar"
                          style="width: 87%"
                          aria-valuenow="87"
                          aria-valuemin="0"
                          aria-valuemax="100"
                        ></div>
                      </div>
                    </div>
                    <div class="mb-3 py-2 px-2 bg-light rounded">
                      <div class="d-flex justify-content-between align-items-center mb-1">
                        <div class="d-flex align-items-center">
                          <span class="badge bg-success me-2">A-</span>
                          <span class="fw-bold">Physics</span>
                        </div>
                        <span>90%</span>
                      </div>
                      <div class="progress" style="height: 6px">
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
                      <div class="d-flex justify-content-between align-items-center mb-1">
                        <div class="d-flex align-items-center">
                          <span class="badge bg-primary me-2">B</span>
                          <span class="fw-bold">Chemistry</span>
                        </div>
                        <span>83%</span>
                      </div>
                      <div class="progress" style="height: 6px">
                        <div
                          class="progress-bar bg-primary"
                          role="progressbar"
                          style="width: 83%"
                          aria-valuenow="83"
                          aria-valuemin="0"
                          aria-valuemax="100"
                        ></div>
                      </div>
                    </div>
                    <div class="mb-3 py-2 px-2 bg-light rounded">
                      <div class="d-flex justify-content-between align-items-center mb-1">
                        <div class="d-flex align-items-center">
                          <span class="badge bg-success me-2">A</span>
                          <span class="fw-bold">Computer Science</span>
                        </div>
                        <span>95%</span>
                      </div>
                      <div class="progress" style="height: 6px">
                        <div
                          class="progress-bar bg-success"
                          role="progressbar"
                          style="width: 95%"
                          aria-valuenow="95"
                          aria-valuemin="0"
                          aria-valuemax="100"
                        ></div>
                      </div>
                    </div>
                  </c:if>
                </div>
              </div>
            </div>
            <div class="col-md-6 mb-4">
              <div class="card dashboard-card shadow-sm border-0">
                <div class="card-header bg-white py-3">
                  <div class="d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0 d-flex align-items-center">
                      <i class="bi bi-chat-dots me-2 text-primary"></i>
                      Teacher Communications
                    </h5>
                    <div>
                      <a href="${pageContext.request.contextPath}/parent/appointments" class="btn btn-sm btn-primary me-2">
                        <i class="bi bi-calendar-check"></i> Book Appointment
                      </a>
                      <a href="${pageContext.request.contextPath}/parent/messages" class="text-decoration-none">
                        <span class="small text-primary">View All</span>
                      </a>
                    </div>
                  </div>
                </div>
                <div class="card-body pt-0">
                  <ul class="list-group list-group-flush">
                    <c:forEach items="${teacherCommunications}" var="comm" varStatus="loop">
                      <li class="list-group-item px-0 py-3 ${loop.index % 2 == 0 ? 'bg-light' : ''}">
                        <div class="d-flex">
                          <div class="flex-shrink-0">
                            <c:choose>
                              <c:when test="${not empty comm.teacherPhoto}">
                                <img 
                                  src="${comm.teacherPhoto}" 
                                  alt="${comm.teacherName}" 
                                  class="student-avatar me-3"
                                />
                              </c:when>
                              <c:otherwise>
                                <div class="bg-primary text-white d-flex align-items-center justify-content-center rounded-circle me-3" style="width: 50px; height: 50px;">
                                  <i class="bi bi-person-fill fs-3"></i>
                                </div>
                              </c:otherwise>
                            </c:choose>
                          </div>
                          <div>
                            <div class="d-flex justify-content-between align-items-center">
                              <h6 class="mb-0 fw-bold">${comm.teacherName} <span class="badge bg-secondary ms-2">${comm.subject}</span></h6>
                              <small class="text-muted">
                                <fmt:formatDate value="${comm.sentDate}" pattern="MMM dd, yyyy" />
                              </small>
                            </div>
                            <p class="mb-1 mt-2">${comm.message}</p>
                            <div class="d-flex">
                              <a href="#" class="btn btn-sm btn-outline-primary me-2">
                                <i class="bi bi-reply"></i> Reply
                              </a>
                              <a href="#" class="btn btn-sm btn-outline-secondary">
                                <i class="bi bi-eye"></i> Mark as Read
                              </a>
                            </div>
                          </div>
                        </div>
                      </li>
                    </c:forEach>
                    <c:if test="${empty teacherCommunications}">
                      <li class="list-group-item px-0 py-3 bg-light">
                        <div class="d-flex">
                          <div class="flex-shrink-0">
                            <div class="bg-primary text-white d-flex align-items-center justify-content-center rounded-circle me-3" style="width: 50px; height: 50px;">
                              <i class="bi bi-person-fill fs-3"></i>
                            </div>
                          </div>
                          <div>
                            <div class="d-flex justify-content-between align-items-center">
                              <h6 class="mb-0 fw-bold">Mr. John Smith <span class="badge bg-secondary ms-2">Mathematics</span></h6>
                              <small class="text-muted">3 days ago</small>
                            </div>
                            <p class="mb-1 mt-2">
                              Jane has been doing excellent in calculus. Her
                              latest test score was 95%.
                            </p>
                            <div class="d-flex">
                              <a href="#" class="btn btn-sm btn-outline-primary me-2">
                                <i class="bi bi-reply"></i> Reply
                              </a>
                              <a href="#" class="btn btn-sm btn-outline-secondary">
                                <i class="bi bi-eye"></i> Mark as Read
                              </a>
                            </div>
                          </div>
                        </div>
                      </li>
                      <li class="list-group-item px-0 py-3">
                        <div class="d-flex">
                          <div class="flex-shrink-0">
                            <div class="bg-success text-white d-flex align-items-center justify-content-center rounded-circle me-3" style="width: 50px; height: 50px;">
                              <i class="bi bi-person-fill fs-3"></i>
                            </div>
                          </div>
                          <div>
                            <div class="d-flex justify-content-between align-items-center">
                              <h6 class="mb-0 fw-bold">Mrs. Sarah Johnson <span class="badge bg-secondary ms-2">English Literature</span></h6>
                              <small class="text-muted">1 week ago</small>
                            </div>
                            <p class="mb-1 mt-2">
                              Please remind Jane to submit her essay on
                              Shakespeare by Friday.
                            </p>
                            <div class="d-flex">
                              <a href="#" class="btn btn-sm btn-outline-primary me-2">
                                <i class="bi bi-reply"></i> Reply
                              </a>
                              <a href="#" class="btn btn-sm btn-outline-secondary">
                                <i class="bi bi-eye"></i> Mark as Read
                              </a>
                            </div>
                          </div>
                        </div>
                      </li>
                      <li class="list-group-item px-0 py-3 bg-light">
                        <div class="d-flex">
                          <div class="flex-shrink-0">
                            <div class="bg-info text-white d-flex align-items-center justify-content-center rounded-circle me-3" style="width: 50px; height: 50px;">
                              <i class="bi bi-person-fill fs-3"></i>
                            </div>
                          </div>
                          <div>
                            <div class="d-flex justify-content-between align-items-center">
                              <h6 class="mb-0 fw-bold">Dr. Robert Brown <span class="badge bg-secondary ms-2">Physics</span></h6>
                              <small class="text-muted">2 weeks ago</small>
                            </div>
                            <p class="mb-1 mt-2">
                              Just wanted to let you know that Jane has been
                              selected for the Science Olympiad team.
                            </p>
                            <div class="d-flex">
                              <a href="#" class="btn btn-sm btn-outline-primary me-2">
                                <i class="bi bi-reply"></i> Reply
                              </a>
                              <a href="#" class="btn btn-sm btn-outline-secondary">
                                <i class="bi bi-eye"></i> Mark as Read
                              </a>
                            </div>
                          </div>
                        </div>
                      </li>
                    </c:if>
                  </ul>
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
      function changeChild(childId) {
        // Redirect to the dashboard with the selected child ID
        window.location.href = "${pageContext.request.contextPath}/parent/dashboard?childId=" + childId;
      }
      
      // Add some animations for better UX
      document.addEventListener('DOMContentLoaded', function() {
        // Add fade-in animation to dashboard cards
        const cards = document.querySelectorAll('.dashboard-card');
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
