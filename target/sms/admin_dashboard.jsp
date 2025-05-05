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
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />
    <style>
      body {
        font-family: 'Poppins', sans-serif;
        background-color: #f5f7fa;
        color: #343a40;
      }
      
      .main-content {
        padding-top: 1.5rem;
        padding-bottom: 1.5rem;
      }
      
      .page-title {
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 0;
      }
      
      .header-container {
        margin-bottom: 1.75rem;
        padding-bottom: 1.25rem;
        border-bottom: 1px solid rgba(0,0,0,0.06);
      }
      
      .user-dropdown .dropdown-toggle {
        background-color: white;
        border: 1px solid #e6e8ec;
        border-radius: 8px;
        padding: 0.5rem 1rem;
        font-weight: 500;
        color: #495057;
        transition: all 0.3s ease;
      }
      
      .user-dropdown .dropdown-toggle:hover, 
      .user-dropdown .dropdown-toggle:focus {
        background-color: #f8f9fa;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
      }
      
      .dashboard-card {
        border: none;
        border-radius: 12px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        transition: all 0.3s ease;
        height: 100%;
        overflow: hidden;
      }

      .dashboard-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 15px rgba(0,0,0,0.1);
      }
      
      .card-gradient-blue {
        background: linear-gradient(135deg, #3498db, #1a5fb4);
      }
      
      .card-gradient-green {
        background: linear-gradient(135deg, #2ecc71, #27ae60);
      }
      
      .card-gradient-orange {
        background: linear-gradient(135deg, #f39c12, #e67e22);
      }
      
      .card-gradient-red {
        background: linear-gradient(135deg, #e74c3c, #c0392b);
      }
      
      .card-gradient-purple {
        background: linear-gradient(135deg, #9b59b6, #8e44ad);
      }
      
      .card-gradient-teal {
        background: linear-gradient(135deg, #1abc9c, #16a085);
      }
      
      .card-gradient-dark {
        background: linear-gradient(135deg, #34495e, #2c3e50);
      }

      .dashboard-card .card-body {
        padding: 1.75rem;
        position: relative;
        z-index: 1;
      }
      
      .dashboard-card::after {
        content: '';
        position: absolute;
        top: 0;
        right: 0;
        width: 150px;
        height: 150px;
        background: rgba(255,255,255,0.1);
        border-radius: 50%;
        transform: translate(30%, -30%);
        z-index: 0;
      }

      .card-icon {
        font-size: 2.25rem;
        margin-bottom: 1.25rem;
        opacity: 0.9;
        display: inline-block;
      }
      
      .card-title {
        font-size: 1rem;
        font-weight: 600;
        margin-bottom: 0.5rem;
        opacity: 0.9;
      }
      
      .card-text {
        font-size: 2.25rem;
        font-weight: 700;
        margin-bottom: 1.25rem;
        letter-spacing: -0.5px;
      }

      .card-link {
        color: white;
        text-decoration: none;
        font-size: 0.875rem;
        font-weight: 500;
        display: inline-flex;
        align-items: center;
        transition: all 0.2s;
        opacity: 0.9;
      }
      
      .card-link:hover {
        opacity: 1;
        transform: translateX(3px);
      }
      
      .card-link i {
        margin-left: 5px;
        transition: all 0.2s;
      }
      
      .card-link:hover i {
        transform: translateX(2px);
      }

      .content-card {
        background: white;
        border-radius: 12px;
        border: none;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        margin-bottom: 24px;
      }
      
      .content-card .card-header {
        background: white;
        padding: 1.25rem 1.5rem;
        border-bottom: 1px solid rgba(0,0,0,0.05);
      }
      
      .content-card .card-header h5 {
        margin-bottom: 0;
        font-weight: 600;
        color: #2c3e50;
      }
      
      .content-card .card-body {
        padding: 1.5rem;
      }
      
      .content-card .card-footer {
        background: white;
        border-top: 1px solid rgba(0,0,0,0.05);
        padding: 1rem 1.5rem;
      }
      
      .announcement-item {
        border-left: 3px solid #3498db;
        padding-left: 1rem;
        margin-bottom: 1.25rem;
      }
      
      .announcement-item:last-child {
        margin-bottom: 0;
      }
      
      .announcement-title {
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 0.25rem;
      }
      
      .announcement-text {
        color: #5a6268;
        margin-bottom: 0.5rem;
      }
      
      .announcement-meta {
        font-size: 0.8rem;
        color: #6c757d;
        display: flex;
        justify-content: space-between;
      }
      
      .quick-action-card {
        border-radius: 10px;
        border: 1px solid rgba(0,0,0,0.05);
        padding: 1.5rem;
        text-align: center;
        transition: all 0.3s;
        height: 100%;
      }
      
      .quick-action-card:hover {
        background-color: #f8f9fa;
        transform: translateY(-3px);
        box-shadow: 0 5px 15px rgba(0,0,0,0.05);
      }
      
      .quick-action-icon {
        font-size: 2rem;
        color: #3498db;
        margin-bottom: 1rem;
      }
      
      .quick-action-title {
        font-weight: 600;
        font-size: 0.95rem;
        color: #2c3e50;
        margin-bottom: 0;
      }
      
      .profile-img {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        object-fit: cover;
      }
      
      .filter-section {
        background-color: #f8f9fa;
        padding: 1.25rem;
        border-radius: 10px;
        margin-bottom: 1.5rem;
      }
      
      .report-table {
        font-size: 0.9rem;
      }
      
      .report-card {
        margin-bottom: 1.75rem;
      }
      
      @media (max-width: 768px) {
        .dashboard-card {
          margin-bottom: 1rem;
        }
      }
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
        <!-- Include Sidebar -->
        <jsp:include page="/WEB-INF/includes/admin-sidebar.jsp" />

        <!-- Main content -->
        <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
          <div class="header-container d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center">
            <h1 class="page-title">Admin Dashboard</h1>
            <div class="user-dropdown">
              <div class="dropdown">
                <a
                  class="btn dropdown-toggle d-flex align-items-center"
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
                      <c:choose>
                        <c:when test="${user.role eq 'admin'}">
                          <i class="bi bi-person-workspace me-2"></i>
                        </c:when>
                        <c:otherwise>
                          <i class="bi bi-person-circle me-2"></i>
                        </c:otherwise>
                      </c:choose>
                    </c:otherwise>
                  </c:choose>
                  <span>${user.username}</span>
                </a>
                <ul class="dropdown-menu shadow-sm" aria-labelledby="dropdownMenuLink">
                  <li>
                    <a class="dropdown-item" href="#">
                      <i class="bi bi-person me-2"></i> Profile
                    </a>
                  </li>
                  <li>
                    <a class="dropdown-item" href="#">
                      <i class="bi bi-gear me-2"></i> Settings
                    </a>
                  </li>
                  <li><hr class="dropdown-divider" /></li>
                  <li>
                    <a
                      class="dropdown-item text-danger"
                      href="${pageContext.request.contextPath}/logout"
                    >
                      <i class="bi bi-box-arrow-right me-2"></i> Logout
                    </a>
                  </li>
                </ul>
              </div>
            </div>
          </div>

          <!-- Summary cards -->
          <div class="row mb-4">
            <div class="col-md-4 col-xl-3 mb-4">
              <div class="card dashboard-card card-gradient-blue text-white">
                <div class="card-body">
                  <i class="bi bi-people-fill card-icon"></i>
                  <h5 class="card-title">Total Students</h5>
                  <h2 class="card-text">${stats.students}</h2>
                  <a
                    href="${pageContext.request.contextPath}/admin/students"
                    class="card-link"
                  >
                    View Details <i class="bi bi-arrow-right-circle"></i>
                  </a>
                </div>
              </div>
            </div>
            <div class="col-md-4 col-xl-3 mb-4">
              <div class="card dashboard-card card-gradient-green text-white">
                <div class="card-body">
                  <i class="bi bi-person-badge-fill card-icon"></i>
                  <h5 class="card-title">Total Teachers</h5>
                  <h2 class="card-text">${stats.teachers}</h2>
                  <a
                    href="${pageContext.request.contextPath}/admin/teachers"
                    class="card-link"
                  >
                    View Details <i class="bi bi-arrow-right-circle"></i>
                  </a>
                </div>
              </div>
            </div>
            <div class="col-md-4 col-xl-3 mb-4">
              <div class="card dashboard-card card-gradient-orange text-white">
                <div class="card-body">
                  <i class="bi bi-book-fill card-icon"></i>
                  <h5 class="card-title">Total Courses</h5>
                  <h2 class="card-text">${stats.courses}</h2>
                  <a
                    href="${pageContext.request.contextPath}/admin/courses"
                    class="card-link"
                  >
                    View Details <i class="bi bi-arrow-right-circle"></i>
                  </a>
                </div>
              </div>
            </div>
            <div class="col-md-4 col-xl-3 mb-4">
              <div class="card dashboard-card card-gradient-red text-white">
                <div class="card-body">
                  <i class="bi bi-people card-icon"></i>
                  <h5 class="card-title">Total Parents</h5>
                  <h2 class="card-text">${stats.parents}</h2>
                  <a
                    href="${pageContext.request.contextPath}/admin/parents"
                    class="card-link"
                  >
                    View Details <i class="bi bi-arrow-right-circle"></i>
                  </a>
                </div>
              </div>
            </div>
            <div class="col-md-4 col-xl-3 mb-4">
              <div class="card dashboard-card card-gradient-purple text-white">
                <div class="card-body">
                  <i class="bi bi-heart-pulse card-icon"></i>
                  <h5 class="card-title">Total Doctors</h5>
                  <h2 class="card-text">${stats.doctors}</h2>
                  <a
                    href="${pageContext.request.contextPath}/admin/doctors"
                    class="card-link"
                  >
                    View Details <i class="bi bi-arrow-right-circle"></i>
                  </a>
                </div>
              </div>
            </div>
            <div class="col-md-4 col-xl-3 mb-4">
              <div class="card dashboard-card card-gradient-teal text-white">
                <div class="card-body">
                  <i class="bi bi-bandaid card-icon"></i>
                  <h5 class="card-title">Total Nurses</h5>
                  <h2 class="card-text">${stats.nurses}</h2>
                  <a
                    href="${pageContext.request.contextPath}/admin/nurses"
                    class="card-link"
                  >
                    View Details <i class="bi bi-arrow-right-circle"></i>
                  </a>
                </div>
              </div>
            </div>
            <div class="col-md-4 col-xl-3 mb-4">
              <div class="card dashboard-card card-gradient-dark text-white">
                <div class="card-body">
                  <i class="bi bi-calendar-check card-icon"></i>
                  <h5 class="card-title">Today's Appointments</h5>
                  <h2 class="card-text">${stats.todayAppointments}</h2>
                  <a
                    href="${pageContext.request.contextPath}/admin/appointments"
                    class="card-link"
                  >
                    View Details <i class="bi bi-arrow-right-circle"></i>
                  </a>
                </div>
              </div>
            </div>
          </div>

          <!-- Recent Activity and Announcements -->
          <div class="row mb-4">
            <div class="col-12">
              <div class="card content-card">
                <div class="card-header d-flex justify-content-between align-items-center">
                  <h5 class="mb-0">Recent Announcements</h5>
                    <button
                      type="button"
                      class="btn btn-sm btn-primary"
                      data-bs-toggle="modal"
                      data-bs-target="#announcementModal"
                    >
                      <i class="bi bi-plus-circle me-1"></i> New Announcement
                    </button>
                  </div>
                <div class="card-body">
                  <c:if test="${empty announcements}">
                    <div class="text-center py-4">
                      <i class="bi bi-megaphone text-muted" style="font-size: 2.5rem;"></i>
                      <p class="text-muted mt-3 mb-0">No announcements available</p>
                    </div>
                  </c:if>
                  
                  <c:if test="${not empty announcements}">
                    <div class="announcement-list">
                      <c:forEach var="announcement" items="${announcements}" varStatus="loop">
                        <div class="announcement-item">
                          <h6 class="announcement-title">${announcement.title}</h6>
                          <p class="announcement-text">${announcement.message}</p>
                          <div class="announcement-meta">
                            <span>Target: ${announcement.targetGroup}</span>
                            <span>
                              <c:choose>
                                <c:when test="${loop.index == 0}">Today</c:when>
                                <c:when test="${loop.index == 1}">Yesterday</c:when>
                                <c:otherwise>${loop.index + 1} days ago</c:otherwise>
                              </c:choose>
                            </span>
                          </div>
                        </div>
                      </c:forEach>
                    </div>
                  </c:if>
                </div>
                <div class="card-footer text-end">
                  <a href="${pageContext.request.contextPath}/admin/announcements" class="btn btn-sm btn-outline-primary">
                    View All Announcements
                  </a>
                </div>
              </div>
            </div>
          </div>

          <!-- Quick Actions -->
          <div class="row mb-4">
            <div class="col-12">
              <div class="card content-card">
                <div class="card-header">
                  <h5 class="mb-0">Quick Actions</h5>
                </div>
                <div class="card-body">
                  <div class="row">
                    <div class="col-md-3 mb-3">
                      <a href="${pageContext.request.contextPath}/admin/students/new" class="text-decoration-none">
                        <div class="quick-action-card">
                          <i class="bi bi-person-plus quick-action-icon"></i>
                          <h6 class="quick-action-title">Add Student</h6>
                        </div>
                      </a>
                    </div>
                    <div class="col-md-3 mb-3">
                      <a href="${pageContext.request.contextPath}/admin/teachers/new" class="text-decoration-none">
                        <div class="quick-action-card">
                          <i class="bi bi-person-badge quick-action-icon"></i>
                          <h6 class="quick-action-title">Add Teacher</h6>
                        </div>
                      </a>
                    </div>
                    <div class="col-md-3 mb-3">
                      <a href="${pageContext.request.contextPath}/admin/courses/new" class="text-decoration-none">
                        <div class="quick-action-card">
                          <i class="bi bi-journal-plus quick-action-icon"></i>
                          <h6 class="quick-action-title">Add Course</h6>
                        </div>
                      </a>
                    </div>
                    <div class="col-md-3 mb-3">
                      <a href="${pageContext.request.contextPath}/admin/announcements/new" class="text-decoration-none">
                        <div class="quick-action-card">
                          <i class="bi bi-megaphone quick-action-icon"></i>
                          <h6 class="quick-action-title">New Announcement</h6>
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
              <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
              <button type="submit" class="btn btn-primary">
                <i class="bi bi-megaphone me-1"></i> Post Announcement
              </button>
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
