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
      
      .profile-img {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        object-fit: cover;
      }
      
      .filter-section {
        background-color: #f8f9fa;
        padding: 15px;
        border-radius: 10px;
        margin-bottom: 20px;
      }
      
      .report-table {
        font-size: 0.9rem;
      }
      
      .report-card {
        margin-bottom: 30px;
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
                  href="${pageContext.request.contextPath}/admin/dashboard"
                >
                  <i class="bi bi-speedometer2 me-2"></i> Dashboard
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/admin/students"
                >
                  <i class="bi bi-person me-2"></i> Students
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/admin/teachers"
                >
                  <i class="bi bi-person-badge me-2"></i> Teachers
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/admin/courses"
                >
                  <i class="bi bi-book me-2"></i> Courses
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/admin/schedule"
                >
                  <i class="bi bi-calendar-event me-2"></i> Schedule
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/admin/announcements"
                >
                  <i class="bi bi-megaphone me-2"></i> Announcements
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/admin/appointments"
                >
                  <i class="bi bi-calendar-check me-2"></i> Appointments
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/admin/settings"
                >
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
                  class="btn btn-sm btn-outline-secondary dropdown-toggle d-flex align-items-center"
                  href="#"
                  role="button"
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
                  ${user.username}
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
            <div class="col-md-3 col-xl-2 mb-4">
              <div class="card dashboard-card bg-primary text-white">
                <div class="card-body text-center">
                  <i class="bi bi-people-fill card-icon"></i>
                  <h5 class="card-title">Total Students</h5>
                  <h2 class="card-text">${stats.students}</h2>
                  <a
                    href="${pageContext.request.contextPath}/admin/students"
                    class="text-white"
                    >View Details <i class="bi bi-arrow-right-circle"></i
                  ></a>
                </div>
              </div>
            </div>
            <div class="col-md-3 col-xl-2 mb-4">
              <div class="card dashboard-card bg-success text-white">
                <div class="card-body text-center">
                  <i class="bi bi-person-badge-fill card-icon"></i>
                  <h5 class="card-title">Total Teachers</h5>
                  <h2 class="card-text">${stats.teachers}</h2>
                  <a
                    href="${pageContext.request.contextPath}/admin/teachers"
                    class="text-white"
                    >View Details <i class="bi bi-arrow-right-circle"></i
                  ></a>
                </div>
              </div>
            </div>
            <div class="col-md-3 col-xl-2 mb-4">
              <div class="card dashboard-card bg-warning text-white">
                <div class="card-body text-center">
                  <i class="bi bi-book-fill card-icon"></i>
                  <h5 class="card-title">Total Courses</h5>
                  <h2 class="card-text">${stats.courses}</h2>
                  <a
                    href="${pageContext.request.contextPath}/admin/courses"
                    class="text-white"
                    >View Details <i class="bi bi-arrow-right-circle"></i
                  ></a>
                </div>
              </div>
            </div>
            <div class="col-md-3 col-xl-2 mb-4">
              <div class="card dashboard-card bg-danger text-white">
                <div class="card-body text-center">
                  <i class="bi bi-people card-icon"></i>
                  <h5 class="card-title">Total Parents</h5>
                  <h2 class="card-text">${stats.parents}</h2>
                  <a
                    href="${pageContext.request.contextPath}/admin/parents"
                    class="text-white"
                    >View Details <i class="bi bi-arrow-right-circle"></i
                  ></a>
                </div>
              </div>
            </div>
            <div class="col-md-3 col-xl-2 mb-4">
              <div class="card dashboard-card bg-info text-white">
                <div class="card-body text-center">
                  <i class="bi bi-calendar-check card-icon"></i>
                  <h5 class="card-title">Today's Appointments</h5>
                  <h2 class="card-text">${stats.todayAppointments}</h2>
                  <a
                    href="${pageContext.request.contextPath}/admin/appointments"
                    class="text-white"
                    >View Details <i class="bi bi-arrow-right-circle"></i
                  ></a>
                </div>
              </div>
            </div>
          </div>

          <!-- Recent Activity and Announcements -->
          <div class="row mb-4">
            <div class="col-12 mb-4">
              <div class="card dashboard-card">
                <div class="card-header bg-white">
                  <h5 class="card-title mb-0">Announcements</h5>
                </div>
                <div class="card-body">
                  <ul class="list-group list-group-flush">
                    <c:forEach
                      var="announcement"
                      items="${announcements}"
                      varStatus="loop"
                    >
                      <li class="list-group-item pb-3">
                        <h6 class="card-subtitle mb-1 text-primary">
                          ${announcement.title}
                        </h6>
                        <p class="card-text small">${announcement.message}</p>
                        <div class="d-flex justify-content-between mt-2">
                          <small class="text-muted"
                            >Target: ${announcement.targetGroup}</small
                          >
                          <small class="text-muted">
                            <c:choose>
                              <c:when test="${loop.index == 0}">Today</c:when>
                              <c:when test="${loop.index == 1}"
                                >Yesterday</c:when
                              >
                              <c:otherwise
                                >${loop.index + 1} days ago</c:otherwise
                              >
                            </c:choose>
                          </small>
                        </div>
                      </li>
                    </c:forEach>
                    
                    <c:if test="${empty announcements}">
                      <li class="list-group-item">
                        <p class="text-center text-muted my-3">No announcements available</p>
                      </li>
                    </c:if>
                  </ul>
                </div>
                <div class="card-footer bg-white">
                  <div class="d-flex justify-content-between">
                    <a
                      href="${pageContext.request.contextPath}/admin/announcements"
                      class="btn btn-sm btn-outline-primary"
                      >View All</a
                    >
                    <button
                      type="button"
                      class="btn btn-sm btn-primary"
                      data-bs-toggle="modal"
                      data-bs-target="#announcementModal"
                    >
                      <i class="bi bi-plus-circle me-1"></i> New Announcement
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Quick Actions -->
          <div class="row mb-4">
            <div class="col-12">
              <div class="card dashboard-card">
                <div class="card-header bg-white">
                  <h5 class="card-title mb-0">Quick Actions</h5>
                </div>
                <div class="card-body">
                  <div class="row">
                    <div class="col-md-3 mb-3">
                      <a
                        href="${pageContext.request.contextPath}/admin/teachers/new"
                        class="card-link"
                      >
                        <div class="card dashboard-card text-center py-3">
                          <i
                            class="bi bi-person-plus card-icon text-primary"
                          ></i>
                          <h6>Add Teacher</h6>
                        </div>
                      </a>
                    </div>
                    <div class="col-md-3 mb-3">
                      <a
                        href="${pageContext.request.contextPath}/admin/students/new"
                        class="card-link"
                      >
                        <div class="card dashboard-card text-center py-3">
                          <i
                            class="bi bi-person-plus-fill card-icon text-success"
                          ></i>
                          <h6>Add Student</h6>
                        </div>
                      </a>
                    </div>
                    <div class="col-md-3 mb-3">
                      <a
                        href="${pageContext.request.contextPath}/admin/courses/new"
                        class="card-link"
                      >
                        <div class="card dashboard-card text-center py-3">
                          <i class="bi bi-book card-icon text-warning"></i>
                          <h6>Add Course</h6>
                        </div>
                      </a>
                    </div>
                    <div class="col-md-3 mb-3">
                      <a
                        href="${pageContext.request.contextPath}/admin/appointments/new"
                        class="card-link"
                      >
                        <div class="card dashboard-card text-center py-3">
                          <i
                            class="bi bi-calendar-plus card-icon text-danger"
                          ></i>
                          <h6>Schedule Appointment</h6>
                        </div>
                      </a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Reports Section -->
          <div class="row mb-4">
            <div class="col-12">
              <div class="card dashboard-card report-card">
                <div class="card-header bg-white">
                  <h5 class="card-title mb-0">Generate Reports</h5>
                </div>
                <div class="card-body">
                  <form action="${pageContext.request.contextPath}/admin/dashboard" method="post" class="mb-4">
                    <input type="hidden" name="action" value="generateReport">
                    
                    <div class="filter-section">
                      <div class="row g-3">
                        <div class="col-md-3">
                          <label for="reportType" class="form-label">Report Type</label>
                          <select class="form-select" id="reportType" name="reportType" required>
                            <option value="">Select Report Type</option>
                            <option value="marks">Academic Marks</option>
                            <option value="behavior">Student Behavior</option>
                            <option value="attendance">Attendance Report</option>
                          </select>
                        </div>
                        
                        <!-- Dynamic filters that change based on report type -->
                        <div class="col-md-3 marks-filter behavior-filter attendance-filter d-none">
                          <label for="studentId" class="form-label">Student</label>
                          <select class="form-select" id="studentId" name="studentId">
                            <option value="">All Students</option>
                            <!-- This would be populated from database -->
                            <option value="1">John Smith</option>
                            <option value="2">Maria Johnson</option>
                          </select>
                        </div>
                        
                        <div class="col-md-3 marks-filter attendance-filter d-none">
                          <label for="courseId" class="form-label">Course</label>
                          <select class="form-select" id="courseId" name="courseId">
                            <option value="">All Courses</option>
                            <!-- This would be populated from database -->
                            <option value="1">Mathematics</option>
                            <option value="2">Science</option>
                            <option value="3">English</option>
                          </select>
                        </div>
                        
                        <div class="col-md-3 marks-filter d-none">
                          <label for="gradeThreshold" class="form-label">Min. Grade</label>
                          <input type="number" class="form-control" id="gradeThreshold" name="gradeThreshold" min="0" max="100" placeholder="Min Grade %">
                        </div>
                        
                        <div class="col-md-3 behavior-filter d-none">
                          <label for="behaviorType" class="form-label">Behavior Type</label>
                          <select class="form-select" id="behaviorType" name="behaviorType">
                            <option value="">All Types</option>
                            <option value="positive">Positive</option>
                            <option value="negative">Negative</option>
                            <option value="neutral">Neutral</option>
                          </select>
                        </div>
                        
                        <div class="col-md-3 attendance-filter d-none">
                          <label for="status" class="form-label">Status</label>
                          <select class="form-select" id="status" name="status">
                            <option value="">All Statuses</option>
                            <option value="present">Present</option>
                            <option value="absent">Absent</option>
                            <option value="late">Late</option>
                            <option value="excused">Excused</option>
                          </select>
                        </div>
                        
                        <div class="col-md-3 behavior-filter attendance-filter d-none">
                          <label for="startDate" class="form-label">Start Date</label>
                          <input type="date" class="form-control" id="startDate" name="startDate">
                        </div>
                        
                        <div class="col-md-3 behavior-filter attendance-filter d-none">
                          <label for="endDate" class="form-label">End Date</label>
                          <input type="date" class="form-control" id="endDate" name="endDate">
                        </div>
                        
                        <div class="col-md-12 text-end">
                          <button type="submit" class="btn btn-primary">
                            <i class="bi bi-file-earmark-text me-1"></i> Generate Report
                          </button>
                        </div>
                      </div>
                    </div>
                  </form>
                  
                  <!-- Report Results -->
                  <c:if test="${not empty reportData}">
                    <div class="report-results">
                      <h5 class="mb-3">Report Results: ${reportData.reportType}</h5>
                      
                      <c:if test="${not empty reportData.error}">
                        <div class="alert alert-danger">
                          ${reportData.error}
                        </div>
                      </c:if>
                      
                      <c:if test="${empty reportData.error}">
                        <div class="table-responsive">
                          <table class="table table-striped table-hover report-table">
                            <thead class="table-dark">
                              <tr>
                                <c:if test="${reportData.reportType eq 'marks'}">
                                  <th>Student Name</th>
                                  <th>Course</th>
                                  <th>Mark</th>
                                  <th>Grade</th>
                                </c:if>
                                <c:if test="${reportData.reportType eq 'behavior'}">
                                  <th>Student Name</th>
                                  <th>Date</th>
                                  <th>Type</th>
                                  <th>Description</th>
                                </c:if>
                                <c:if test="${reportData.reportType eq 'attendance'}">
                                  <th>Student Name</th>
                                  <th>Course</th>
                                  <th>Date</th>
                                  <th>Status</th>
                                </c:if>
                              </tr>
                            </thead>
                            <tbody>
                              <c:forEach var="row" items="${reportData.rows}">
                                <c:if test="${reportData.reportType eq 'marks'}">
                                  <tr>
                                    <td>${row.studentName}</td>
                                    <td>${row.courseName}</td>
                                    <td>${row.mark}%</td>
                                    <td>${row.grade}</td>
                                  </tr>
                                </c:if>
                                <c:if test="${reportData.reportType eq 'behavior'}">
                                  <tr>
                                    <td>${row.studentName}</td>
                                    <td>${row.date}</td>
                                    <td>
                                      <span class="badge ${row.behaviorType eq 'positive' ? 'bg-success' : row.behaviorType eq 'negative' ? 'bg-danger' : 'bg-secondary'}">
                                        ${row.behaviorType}
                                      </span>
                                    </td>
                                    <td>${row.description}</td>
                                  </tr>
                                </c:if>
                                <c:if test="${reportData.reportType eq 'attendance'}">
                                  <tr>
                                    <td>${row.studentName}</td>
                                    <td>${row.courseName}</td>
                                    <td>${row.date}</td>
                                    <td>
                                      <span class="badge ${row.status eq 'present' ? 'bg-success' : row.status eq 'absent' ? 'bg-danger' : row.status eq 'late' ? 'bg-warning' : 'bg-info'}">
                                        ${row.status}
                                      </span>
                                    </td>
                                  </tr>
                                </c:if>
                              </c:forEach>
                              
                              <c:if test="${empty reportData.rows}">
                                <tr>
                                  <td colspan="4" class="text-center">No data found for the selected criteria</td>
                                </tr>
                              </c:if>
                            </tbody>
                          </table>
                        </div>
                        
                        <div class="text-end mt-3">
                          <button class="btn btn-outline-secondary">
                            <i class="bi bi-printer me-1"></i> Print Report
                          </button>
                          <button class="btn btn-outline-success ms-2">
                            <i class="bi bi-file-earmark-excel me-1"></i> Export to Excel
                          </button>
                          <button class="btn btn-outline-danger ms-2">
                            <i class="bi bi-file-earmark-pdf me-1"></i> Export to PDF
                          </button>
                        </div>
                      </c:if>
                    </div>
                  </c:if>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Create Announcement Modal -->
    <div class="modal fade" id="announcementModal" tabindex="-1" aria-labelledby="announcementModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="announcementModalLabel">Create New Announcement</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <form action="${pageContext.request.contextPath}/admin/announcements/new" method="post">
            <div class="modal-body">
              <div class="mb-3">
                <label for="title" class="form-label">Title <span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="title" name="title" required>
              </div>
              
              <div class="mb-3">
                <label for="message" class="form-label">Message <span class="text-danger">*</span></label>
                <textarea class="form-control" id="message" name="message" rows="5" required></textarea>
              </div>
              
              <div class="mb-3">
                <label for="targetGroup" class="form-label">Target Group <span class="text-danger">*</span></label>
                <select class="form-select" id="targetGroup" name="targetGroup" required>
                  <option value="" selected disabled>Select target group</option>
                  <option value="All">Everyone</option>
                  <option value="Students">Students</option>
                  <option value="Teachers">Teachers</option>
                  <option value="Parents">Parents</option>
                  <option value="Staff">Staff</option>
                </select>
              </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
              <button type="submit" class="btn btn-primary"><i class="bi bi-megaphone me-1"></i> Post Announcement</button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <!-- Custom JavaScript for interactive reports -->
    <script>
      document.addEventListener('DOMContentLoaded', function() {
        // Show/hide filter fields based on selected report type
        const reportTypeSelect = document.getElementById('reportType');
        
        if (reportTypeSelect) {
          reportTypeSelect.addEventListener('change', function() {
            // Hide all filter fields
            document.querySelectorAll('.marks-filter, .behavior-filter, .attendance-filter').forEach(
              el => el.classList.add('d-none')
            );
            
            // Show relevant filters for selected report
            const reportType = reportTypeSelect.value;
            if (reportType === 'marks') {
              document.querySelectorAll('.marks-filter').forEach(
                el => el.classList.remove('d-none')
              );
            } else if (reportType === 'behavior') {
              document.querySelectorAll('.behavior-filter').forEach(
                el => el.classList.remove('d-none')
              );
            } else if (reportType === 'attendance') {
              document.querySelectorAll('.attendance-filter').forEach(
                el => el.classList.remove('d-none')
              );
            }
          });
          
          // Initialize visibility if report type is already selected
          if (reportTypeSelect.value) {
            reportTypeSelect.dispatchEvent(new Event('change'));
          }
        }
      });
    </script>
  </body>
</html>
