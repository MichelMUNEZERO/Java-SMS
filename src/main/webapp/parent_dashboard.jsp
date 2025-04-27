<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
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

      .student-avatar {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        object-fit: cover;
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
                <a
                  class="nav-link active text-white"
                  href="${pageContext.request.contextPath}/parent/dashboard"
                >
                  <i class="bi bi-speedometer2 me-2"></i> Dashboard
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/parent/student-progress"
                >
                  <i class="bi bi-people me-2"></i> My Children
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/parent/student-progress"
                >
                  <i class="bi bi-card-checklist me-2"></i> Academic Progress
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/parent/announcements"
                >
                  <i class="bi bi-megaphone me-2"></i> Announcements
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/parent/appointments"
                >
                  <i class="bi bi-calendar-check me-2"></i> Book Appointments
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
            <h1 class="h2">Parent Dashboard</h1>
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

          <!-- Welcome and Child Selection -->
          <div class="row mb-4">
            <div class="col-md-8">
              <div class="card dashboard-card">
                <div class="card-body">
                  <h5 class="card-title">Welcome, ${user.username}!</h5>
                  <p class="card-text">
                    Welcome to your parent dashboard. Here you can monitor your
                    child's academic progress, attendance, and communicate with
                    teachers.
                  </p>
                </div>
              </div>
            </div>
            <div class="col-md-4">
              <div class="card dashboard-card">
                <div class="card-body">
                  <h5 class="card-title">Select Child</h5>
                  <select
                    class="form-select"
                    id="childSelect"
                    onchange="changeChild(this.value)"
                  >
                    <option selected>Jane Doe (Grade 10)</option>
                    <option>Tom Doe (Grade 8)</option>
                  </select>
                </div>
              </div>
            </div>
          </div>

          <!-- Navigational Cards -->
          <div class="row mb-4">
            <div class="col-md-4 mb-4">
              <div class="card dashboard-card h-100">
                <div class="card-body text-center">
                  <i class="bi bi-card-checklist card-icon text-primary"></i>
                  <h5 class="card-title">Student Progress</h5>
                  <p class="card-text">
                    View your child's academic progress, behavior records, and
                    attendance information.
                  </p>
                  <a
                    href="${pageContext.request.contextPath}/parent/student-progress"
                    class="btn btn-primary"
                    >View Progress</a
                  >
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-4">
              <div class="card dashboard-card h-100">
                <div class="card-body text-center">
                  <i class="bi bi-megaphone card-icon text-success"></i>
                  <h5 class="card-title">Announcements</h5>
                  <p class="card-text">
                    Stay updated with the latest announcements from school
                    administration and teachers.
                  </p>
                  <a
                    href="${pageContext.request.contextPath}/parent/announcements"
                    class="btn btn-success"
                    >View Announcements</a
                  >
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-4">
              <div class="card dashboard-card h-100">
                <div class="card-body text-center">
                  <i class="bi bi-calendar-check card-icon text-danger"></i>
                  <h5 class="card-title">Book Appointments</h5>
                  <p class="card-text">
                    Schedule appointments with teachers and administrators to
                    discuss your child's education.
                  </p>
                  <a
                    href="${pageContext.request.contextPath}/parent/appointments"
                    class="btn btn-danger"
                    >Book Appointment</a
                  >
                </div>
              </div>
            </div>
          </div>

          <!-- Summary cards -->
          <div class="row mb-4">
            <div class="col-md-3 mb-4">
              <div class="card dashboard-card bg-primary text-white">
                <div class="card-body text-center">
                  <i class="bi bi-clipboard-check-fill card-icon"></i>
                  <h5 class="card-title">Attendance</h5>
                  <h2 class="card-text">96%</h2>
                </div>
              </div>
            </div>
            <div class="col-md-3 mb-4">
              <div class="card dashboard-card bg-success text-white">
                <div class="card-body text-center">
                  <i class="bi bi-award-fill card-icon"></i>
                  <h5 class="card-title">GPA</h5>
                  <h2 class="card-text">3.8</h2>
                </div>
              </div>
            </div>
            <div class="col-md-3 mb-4">
              <div class="card dashboard-card bg-warning text-white">
                <div class="card-body text-center">
                  <i class="bi bi-file-earmark-text card-icon"></i>
                  <h5 class="card-title">Pending Assignments</h5>
                  <h2 class="card-text">3</h2>
                </div>
              </div>
            </div>
            <div class="col-md-3 mb-4">
              <div class="card dashboard-card bg-info text-white">
                <div class="card-body text-center">
                  <i class="bi bi-calendar-event-fill card-icon"></i>
                  <h5 class="card-title">Upcoming Events</h5>
                  <h2 class="card-text">2</h2>
                </div>
              </div>
            </div>
          </div>

          <!-- Recent Attendance and Fee Information -->
          <div class="row mb-4">
            <div class="col-md-6 mb-4">
              <div class="card dashboard-card">
                <div class="card-header bg-white">
                  <h5 class="card-title mb-0">Recent Attendance</h5>
                </div>
                <div class="card-body">
                  <table class="table">
                    <thead>
                      <tr>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Remarks</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>May 15, 2023</td>
                        <td><span class="badge bg-success">Present</span></td>
                        <td>-</td>
                      </tr>
                      <tr>
                        <td>May 14, 2023</td>
                        <td><span class="badge bg-success">Present</span></td>
                        <td>-</td>
                      </tr>
                      <tr>
                        <td>May 13, 2023</td>
                        <td><span class="badge bg-warning">Late</span></td>
                        <td>Arrived 15 minutes late</td>
                      </tr>
                      <tr>
                        <td>May 12, 2023</td>
                        <td><span class="badge bg-success">Present</span></td>
                        <td>-</td>
                      </tr>
                      <tr>
                        <td>May 11, 2023</td>
                        <td><span class="badge bg-danger">Absent</span></td>
                        <td>Medical leave</td>
                      </tr>
                    </tbody>
                  </table>
                </div>
                <div class="card-footer bg-white">
                  <a
                    href="${pageContext.request.contextPath}/parent/student-progress"
                    class="btn btn-sm btn-outline-primary"
                    >View Full Attendance</a
                  >
                </div>
              </div>
            </div>
            <div class="col-md-6 mb-4">
              <div class="card dashboard-card">
                <div class="card-header bg-white">
                  <h5 class="card-title mb-0">Recent Announcements</h5>
                </div>
                <div class="card-body">
                  <ul class="list-group list-group-flush">
                    <li class="list-group-item">
                      <div>
                        <h6 class="mb-1">Parent-Teacher Meeting</h6>
                        <p class="mb-1">
                          The upcoming parent-teacher meeting is scheduled for
                          June 5th.
                        </p>
                        <small class="text-muted">2 days ago</small>
                      </div>
                    </li>
                    <li class="list-group-item">
                      <div>
                        <h6 class="mb-1">Math Competition Results</h6>
                        <p class="mb-1">
                          Results of the regional Math Competition are out.
                          Check the announcement board.
                        </p>
                        <small class="text-muted">1 week ago</small>
                      </div>
                    </li>
                    <li class="list-group-item">
                      <div>
                        <h6 class="mb-1">School Trip Permission</h6>
                        <p class="mb-1">
                          Please submit the permission slip for the upcoming
                          Science Museum trip.
                        </p>
                        <small class="text-muted">2 weeks ago</small>
                      </div>
                    </li>
                  </ul>
                </div>
                <div class="card-footer bg-white">
                  <a
                    href="${pageContext.request.contextPath}/parent/announcements"
                    class="btn btn-sm btn-outline-primary"
                    >View All Announcements</a
                  >
                </div>
              </div>
            </div>
          </div>

          <!-- Academic Performance and Communication -->
          <div class="row mb-4">
            <div class="col-md-6 mb-4">
              <div class="card dashboard-card">
                <div class="card-header bg-white">
                  <h5 class="card-title mb-0">Academic Performance</h5>
                </div>
                <div class="card-body">
                  <div class="mb-3">
                    <div class="d-flex justify-content-between mb-1">
                      <span>Mathematics</span>
                      <span>A (92%)</span>
                    </div>
                    <div class="progress mb-2">
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
                    <div class="d-flex justify-content-between mb-1">
                      <span>English Literature</span>
                      <span>B+ (87%)</span>
                    </div>
                    <div class="progress mb-2">
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
                  <div class="mb-3">
                    <div class="d-flex justify-content-between mb-1">
                      <span>Physics</span>
                      <span>A- (90%)</span>
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
                      <span>B (83%)</span>
                    </div>
                    <div class="progress mb-2">
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
                  <div class="mb-3">
                    <div class="d-flex justify-content-between mb-1">
                      <span>History</span>
                      <span>B+ (88%)</span>
                    </div>
                    <div class="progress mb-2">
                      <div
                        class="progress-bar bg-success"
                        role="progressbar"
                        style="width: 88%"
                        aria-valuenow="88"
                        aria-valuemin="0"
                        aria-valuemax="100"
                      ></div>
                    </div>
                  </div>
                  <div>
                    <div class="d-flex justify-content-between mb-1">
                      <span>Computer Science</span>
                      <span>A (95%)</span>
                    </div>
                    <div class="progress">
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
                </div>
                <div class="card-footer bg-white">
                  <a
                    href="${pageContext.request.contextPath}/parent/student-progress"
                    class="btn btn-sm btn-outline-primary"
                    >View Detailed Report</a
                  >
                </div>
              </div>
            </div>
            <div class="col-md-6 mb-4">
              <div class="card dashboard-card">
                <div class="card-header bg-white">
                  <h5 class="card-title mb-0">Teacher Communications</h5>
                </div>
                <div class="card-body">
                  <ul class="list-group list-group-flush">
                    <li class="list-group-item">
                      <div class="d-flex">
                        <img
                          src="${pageContext.request.contextPath}/images/teacher1.jpg"
                          alt="Teacher"
                          class="student-avatar me-3"
                        />
                        <div>
                          <h6 class="mb-1">Mr. John Smith - Mathematics</h6>
                          <p class="mb-1">
                            Jane has been doing excellent in calculus. Her
                            latest test score was 95%.
                          </p>
                          <small class="text-muted">3 days ago</small>
                        </div>
                      </div>
                    </li>
                    <li class="list-group-item">
                      <div class="d-flex">
                        <img
                          src="${pageContext.request.contextPath}/images/teacher2.jpg"
                          alt="Teacher"
                          class="student-avatar me-3"
                        />
                        <div>
                          <h6 class="mb-1">
                            Mrs. Sarah Johnson - English Literature
                          </h6>
                          <p class="mb-1">
                            Please remind Jane to submit her essay on
                            Shakespeare by Friday.
                          </p>
                          <small class="text-muted">1 week ago</small>
                        </div>
                      </div>
                    </li>
                    <li class="list-group-item">
                      <div class="d-flex">
                        <img
                          src="${pageContext.request.contextPath}/images/teacher3.jpg"
                          alt="Teacher"
                          class="student-avatar me-3"
                        />
                        <div>
                          <h6 class="mb-1">Dr. Robert Brown - Physics</h6>
                          <p class="mb-1">
                            Just wanted to let you know that Jane has been
                            selected for the Science Olympiad team.
                          </p>
                          <small class="text-muted">2 weeks ago</small>
                        </div>
                      </div>
                    </li>
                  </ul>
                </div>
                <div class="card-footer bg-white">
                  <a
                    href="${pageContext.request.contextPath}/parent/appointments"
                    class="btn btn-primary btn-sm"
                  >
                    <i class="bi bi-calendar-check me-2"></i> Book Appointment
                  </a>
                  <a href="#" class="btn btn-sm btn-outline-primary"
                    >View All Messages</a
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

    <script>
      function changeChild(childInfo) {
        // This would be replaced with actual functionality to change the dashboard view
        console.log("Selected child: " + childInfo);
        // In a real implementation, this would trigger an AJAX request to update dashboard data
      }
    </script>
  </body>
</html>
