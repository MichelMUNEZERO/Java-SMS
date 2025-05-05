<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Student Progress - School Management System</title>
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

      .nav-tabs .nav-link.active {
        font-weight: 600;
        color: var(--primary-color);
        border-bottom: 2px solid var(--primary-color);
      }
      
      .nav-tabs .nav-link {
        color: #6c757d;
        border: none;
        padding: 0.75rem 1rem;
        transition: all 0.3s ease;
      }
      
      .nav-tabs .nav-link:hover:not(.active) {
        color: var(--primary-color);
        background-color: rgba(13, 110, 253, 0.1);
        border-radius: 4px;
      }
      
      .profile-img {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        object-fit: cover;
      }
      
      .summary-card {
        border-radius: 0.5rem;
        transition: all 0.3s ease;
      }
      
      .summary-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 20px rgba(0,0,0,0.1);
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
          <!-- Breadcrumb -->
          <nav aria-label="breadcrumb" class="mt-3">
            <ol class="breadcrumb">
              <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/parent/dashboard">Dashboard</a>
              </li>
              <li class="breadcrumb-item active" aria-current="page">
                Student Progress
              </li>
            </ol>
          </nav>

          <div class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center">
            <h1 class="page-title">Student Progress</h1>
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

          <!-- Student Selection -->
          <div class="row mb-4">
            <div class="col-md-12">
              <div class="content-card">
                <div class="card-header bg-white py-3">
                  <div class="d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0 d-flex align-items-center">
                      <i class="bi bi-people me-2 text-primary"></i>
                      My Children
                    </h5>
                    <a href="${pageContext.request.contextPath}/parent/student-progress" class="text-decoration-none">
                      <span class="small text-primary">Refresh</span>
                    </a>
                  </div>
                </div>
                <div class="card-body">
                  <form action="${pageContext.request.contextPath}/parent/student-progress" method="get" class="row g-3 align-items-center">
                    <div class="col-md-5">
                      <label for="studentSelect" class="form-label">Select Child</label>
                      <select name="studentId" id="studentSelect" class="form-select shadow-sm" onchange="this.form.submit()">
                        <option value="">Select a child</option>
                        <c:forEach var="child" items="${children}">
                          <option value="${child.id}" <c:if test="${selectedStudent.id == child.id}">selected</c:if>>
                            ${child.firstName} ${child.lastName} (${child.grade})
                          </option>
                        </c:forEach>
                      </select>
                    </div>
                    <div class="col-md-7">
                      <c:if test="${selectedStudent != null}">
                        <div class="d-flex align-items-center p-3 bg-light rounded-3 border-start border-4 border-primary">
                          <div class="flex-shrink-0">
                            <div class="bg-primary bg-opacity-10 p-2 rounded-circle">
                              <i class="bi bi-person-badge text-primary fs-3"></i>
                            </div>
                          </div>
                          <div class="ms-3">
                            <h6 class="mb-1 fw-bold">${selectedStudent.firstName} ${selectedStudent.lastName}</h6>
                            <p class="mb-0 text-muted small">
                              <span class="badge bg-primary me-2">Grade: ${selectedStudent.grade}</span>
                              <span class="badge bg-secondary">ID: ${selectedStudent.regNumber}</span>
                            </p>
                          </div>
                        </div>
                      </c:if>
                    </div>
                  </form>
                </div>
              </div>
            </div>
          </div>

          <c:if test="${selectedStudent != null}">
            <!-- Progress Tabs -->
            <ul class="nav nav-tabs mb-4" id="progressTabs" role="tablist">
              <li class="nav-item" role="presentation">
                <button class="nav-link active" id="academic-tab" data-bs-toggle="tab" data-bs-target="#academic" type="button" role="tab" aria-controls="academic" aria-selected="true">
                  <i class="bi bi-mortarboard me-1"></i> Academic Progress
                </button>
              </li>
              <li class="nav-item" role="presentation">
                <button class="nav-link" id="attendance-tab" data-bs-toggle="tab" data-bs-target="#attendance" type="button" role="tab" aria-controls="attendance" aria-selected="false">
                  <i class="bi bi-calendar-check me-1"></i> Attendance
                </button>
              </li>
              <li class="nav-item" role="presentation">
                <button class="nav-link" id="behavior-tab" data-bs-toggle="tab" data-bs-target="#behavior" type="button" role="tab" aria-controls="behavior" aria-selected="false">
                  <i class="bi bi-emoji-smile me-1"></i> Behavior Records
                </button>
              </li>
            </ul>

            <!-- Tab Content -->
            <div class="tab-content" id="progressTabsContent">
              <!-- Academic Progress Tab -->
              <div class="tab-pane fade show active" id="academic" role="tabpanel" aria-labelledby="academic-tab">
                <div class="row">
                  <div class="col-md-12 mb-4">
                    <div class="content-card">
                      <div class="card-header bg-white py-3">
                        <h5 class="card-title mb-0 d-flex align-items-center">
                          <i class="bi bi-graph-up me-2 text-primary"></i>
                          Academic Performance Summary
                        </h5>
                      </div>
                      <div class="card-body">
                        <div class="row">
                          <div class="col-md-4 mb-4">
                            <div class="summary-card bg-primary bg-opacity-10 p-3 text-center rounded h-100">
                              <div class="d-inline-flex align-items-center justify-content-center bg-primary bg-opacity-25 p-3 rounded-circle mb-3">
                                <i class="bi bi-bar-chart-line text-primary fs-3"></i>
                              </div>
                              <h2 class="text-primary mb-0">
                                <c:set var="totalGrade" value="0" />
                                <c:set var="courseCount" value="0" />
                                <c:forEach var="course" items="${academicProgress}">
                                  <c:set var="totalGrade" value="${totalGrade + course.average}" />
                                  <c:set var="courseCount" value="${courseCount + 1}" />
                                </c:forEach>
                                <c:if test="${courseCount > 0}">
                                  <fmt:formatNumber value="${totalGrade / courseCount}" pattern="#.##" />%
                                </c:if>
                                <c:if test="${courseCount == 0}">N/A</c:if>
                              </h2>
                              <p class="text-muted mb-0">Overall Average</p>
                            </div>
                          </div>
                          <div class="col-md-4 mb-4">
                            <div class="summary-card bg-success bg-opacity-10 p-3 text-center rounded h-100">
                              <div class="d-inline-flex align-items-center justify-content-center bg-success bg-opacity-25 p-3 rounded-circle mb-3">
                                <i class="bi bi-book text-success fs-3"></i>
                              </div>
                              <h2 class="text-success mb-0">${courseCount}</h2>
                              <p class="text-muted mb-0">Total Courses</p>
                            </div>
                          </div>
                          <div class="col-md-4 mb-4">
                            <div class="summary-card bg-info bg-opacity-10 p-3 text-center rounded h-100">
                              <div class="d-inline-flex align-items-center justify-content-center bg-info bg-opacity-25 p-3 rounded-circle mb-3">
                                <i class="bi bi-award text-info fs-3"></i>
                              </div>
                              <h2 class="text-info mb-0">
                                <c:if test="${courseCount > 0}">
                                  <c:choose>
                                    <c:when test="${totalGrade / courseCount >= 90}">A</c:when>
                                    <c:when test="${totalGrade / courseCount >= 80}">B</c:when>
                                    <c:when test="${totalGrade / courseCount >= 70}">C</c:when>
                                    <c:when test="${totalGrade / courseCount >= 60}">D</c:when>
                                    <c:otherwise>F</c:otherwise>
                                  </c:choose>
                                </c:if>
                                <c:if test="${courseCount == 0}">N/A</c:if>
                              </h2>
                              <p class="text-muted mb-0">Overall Grade</p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="row">
                  <div class="col-md-12 mb-4">
                    <div class="content-card">
                      <div class="card-header bg-white py-3">
                        <div class="d-flex justify-content-between align-items-center">
                          <h5 class="card-title mb-0 d-flex align-items-center">
                            <i class="bi bi-clipboard-data me-2 text-primary"></i>
                            Course Performance
                          </h5>
                          <div class="dropdown">
                            <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" id="courseDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                              <i class="bi bi-funnel me-1"></i> Filter
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="courseDropdown">
                              <li><a class="dropdown-item" href="#">All Courses</a></li>
                              <li><a class="dropdown-item" href="#">Core Subjects</a></li>
                              <li><a class="dropdown-item" href="#">Electives</a></li>
                              <li><hr class="dropdown-divider"></li>
                              <li><a class="dropdown-item" href="#">Above Average</a></li>
                              <li><a class="dropdown-item" href="#">Below Average</a></li>
                            </ul>
                          </div>
                        </div>
                      </div>
                      <div class="card-body">
                        <div class="table-responsive">
                          <table class="table table-hover align-middle">
                            <thead class="table-light">
                              <tr>
                                <th>Course</th>
                                <th>Teacher</th>
                                <th class="text-center">Average Score</th>
                                <th class="text-center">Grade</th>
                                <th class="text-center">Progress</th>
                              </tr>
                            </thead>
                            <tbody>
                              <c:forEach var="course" items="${academicProgress}" varStatus="loop">
                                <tr ${loop.index % 2 == 0 ? 'class="table-light"' : ''}>
                                  <td>
                                    <div class="d-flex align-items-center">
                                      <span class="badge 
                                        <c:choose>
                                          <c:when test="${course.average >= 90}">bg-success</c:when>
                                          <c:when test="${course.average >= 80}">bg-primary</c:when>
                                          <c:when test="${course.average >= 70}">bg-info</c:when>
                                          <c:when test="${course.average >= 60}">bg-warning</c:when>
                                          <c:otherwise>bg-danger</c:otherwise>
                                        </c:choose> rounded-circle p-2 me-2">
                                        <i class="bi bi-book"></i>
                                      </span>
                                      <span>${course.courseName} <small class="text-muted">(${course.courseCode})</small></span>
                                    </div>
                                  </td>
                                  <td>${course.teacherName}</td>
                                  <td class="text-center"><fmt:formatNumber value="${course.average}" pattern="#.##" />%</td>
                                  <td class="text-center">
                                    <span class="badge rounded-pill px-3 py-2
                                      <c:choose>
                                        <c:when test="${course.grade == 'A'}">bg-success</c:when>
                                        <c:when test="${course.grade == 'B'}">bg-primary</c:when>
                                        <c:when test="${course.grade == 'C'}">bg-info</c:when>
                                        <c:when test="${course.grade == 'D'}">bg-warning</c:when>
                                        <c:otherwise>bg-danger</c:otherwise>
                                      </c:choose>
                                    ">${course.grade}</span>
                                  </td>
                                  <td class="text-center">
                                    <div class="progress">
                                      <div class="progress-bar
                                        <c:choose>
                                          <c:when test="${course.average >= 90}">bg-success</c:when>
                                          <c:when test="${course.average >= 80}">bg-primary</c:when>
                                          <c:when test="${course.average >= 70}">bg-info</c:when>
                                          <c:when test="${course.average >= 60}">bg-warning</c:when>
                                          <c:otherwise>bg-danger</c:otherwise>
                                        </c:choose>
                                      " role="progressbar" style="width: ${course.average}%" 
                                       aria-valuenow="${course.average}" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                  </td>
                                </tr>
                              </c:forEach>
                              <c:if test="${empty academicProgress}">
                                <tr>
                                  <td colspan="5" class="text-center py-4">
                                    <div class="py-5">
                                      <i class="bi bi-journal-x text-muted" style="font-size: 2.5rem"></i>
                                      <p class="mt-3 text-muted">No course data available</p>
                                      <button class="btn btn-sm btn-outline-primary mt-2">
                                        <i class="bi bi-arrow-repeat me-1"></i> Refresh Data
                                      </button>
                                    </div>
                                  </td>
                                </tr>
                              </c:if>
                            </tbody>
                          </table>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Attendance Tab -->
              <div class="tab-pane fade" id="attendance" role="tabpanel" aria-labelledby="attendance-tab">
                <div class="row">
                  <div class="col-md-12 mb-4">
                    <div class="content-card">
                      <div class="card-header bg-white py-3">
                        <h5 class="card-title mb-0 d-flex align-items-center">
                          <i class="bi bi-calendar-check me-2 text-primary"></i>
                          Attendance Summary
                        </h5>
                      </div>
                      <div class="card-body">
                        <div class="row">
                          <div class="col-md-3 mb-4">
                            <div class="summary-card bg-primary bg-opacity-10 p-3 text-center rounded h-100">
                              <div class="d-inline-flex align-items-center justify-content-center bg-primary bg-opacity-25 p-3 rounded-circle mb-3">
                                <i class="bi bi-percent text-primary fs-3"></i>
                              </div>
                              <h2 class="text-primary mb-0">
                                <c:if test="${attendanceInfo != null}">
                                  <fmt:formatNumber value="${attendanceInfo.percentage}" pattern="#.##" />%
                                </c:if>
                                <c:if test="${attendanceInfo == null}">N/A</c:if>
                              </h2>
                              <p class="text-muted mb-0">Overall Attendance</p>
                            </div>
                          </div>
                          <div class="col-md-3 mb-4">
                            <div class="summary-card bg-success bg-opacity-10 p-3 text-center rounded h-100">
                              <div class="d-inline-flex align-items-center justify-content-center bg-success bg-opacity-25 p-3 rounded-circle mb-3">
                                <i class="bi bi-check-circle text-success fs-3"></i>
                              </div>
                              <h2 class="text-success mb-0">${attendanceInfo.presentDays}</h2>
                              <p class="text-muted mb-0">Days Present</p>
                            </div>
                          </div>
                          <div class="col-md-3 mb-4">
                            <div class="summary-card bg-danger bg-opacity-10 p-3 text-center rounded h-100">
                              <div class="d-inline-flex align-items-center justify-content-center bg-danger bg-opacity-25 p-3 rounded-circle mb-3">
                                <i class="bi bi-x-circle text-danger fs-3"></i>
                              </div>
                              <h2 class="text-danger mb-0">${attendanceInfo.absentDays}</h2>
                              <p class="text-muted mb-0">Days Absent</p>
                            </div>
                          </div>
                          <div class="col-md-3 mb-4">
                            <div class="summary-card bg-warning bg-opacity-10 p-3 text-center rounded h-100">
                              <div class="d-inline-flex align-items-center justify-content-center bg-warning bg-opacity-25 p-3 rounded-circle mb-3">
                                <i class="bi bi-clock text-warning fs-3"></i>
                              </div>
                              <h2 class="text-warning mb-0">${attendanceInfo.lateDays}</h2>
                              <p class="text-muted mb-0">Days Late</p>
                            </div>
                          </div>
                        </div>

                        <div class="mt-4 mb-2">
                          <h6 class="fw-bold mb-3">Attendance Breakdown</h6>
                          <div class="progress mb-2" style="height: 20px;">
                            <div class="progress-bar bg-success" role="progressbar" 
                                style="width: ${attendanceInfo.presentDays * 100 / attendanceInfo.totalDays}%" 
                                aria-valuenow="${attendanceInfo.presentDays}" 
                                aria-valuemin="0" aria-valuemax="${attendanceInfo.totalDays}">
                              Present (${attendanceInfo.presentDays})
                            </div>
                            <div class="progress-bar bg-warning" role="progressbar" 
                                style="width: ${attendanceInfo.lateDays * 100 / attendanceInfo.totalDays}%" 
                                aria-valuenow="${attendanceInfo.lateDays}" 
                                aria-valuemin="0" aria-valuemax="${attendanceInfo.totalDays}">
                              Late (${attendanceInfo.lateDays})
                            </div>
                            <div class="progress-bar bg-danger" role="progressbar" 
                                style="width: ${attendanceInfo.absentDays * 100 / attendanceInfo.totalDays}%" 
                                aria-valuenow="${attendanceInfo.absentDays}" 
                                aria-valuemin="0" aria-valuemax="${attendanceInfo.totalDays}">
                              Absent (${attendanceInfo.absentDays})
                            </div>
                          </div>
                          <div class="d-flex justify-content-between small text-muted">
                            <span>Total School Days: ${attendanceInfo.totalDays}</span>
                            <span>Last Updated: <fmt:formatDate value="${attendanceInfo.lastUpdated}" pattern="MMM dd, yyyy" /></span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="row">
                  <div class="col-md-12 mb-4">
                    <div class="content-card">
                      <div class="card-header bg-white py-3">
                        <div class="d-flex justify-content-between align-items-center">
                          <h5 class="card-title mb-0 d-flex align-items-center">
                            <i class="bi bi-calendar-date me-2 text-primary"></i>
                            Recent Attendance Records
                          </h5>
                          <div class="dropdown">
                            <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" id="filterAttendance" data-bs-toggle="dropdown" aria-expanded="false">
                              <i class="bi bi-funnel me-1"></i> Filter
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="filterAttendance">
                              <li><a class="dropdown-item" href="#">All Records</a></li>
                              <li><a class="dropdown-item" href="#">Present Only</a></li>
                              <li><a class="dropdown-item" href="#">Absent Only</a></li>
                              <li><a class="dropdown-item" href="#">Late Only</a></li>
                            </ul>
                          </div>
                        </div>
                      </div>
                      <div class="card-body">
                        <div class="table-responsive">
                          <table class="table table-hover align-middle">
                            <thead class="table-light">
                              <tr>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Remarks</th>
                              </tr>
                            </thead>
                            <tbody>
                              <c:forEach var="record" items="${attendanceInfo.recentAttendance}" varStatus="loop">
                                <tr ${loop.index % 2 == 0 ? 'class="table-light"' : ''}>
                                  <td>
                                    <div class="d-flex align-items-center">
                                      <div class="bg-light p-2 rounded me-2 text-center" style="min-width: 45px;">
                                        <span class="d-block fw-bold"><fmt:formatDate value="${record.date}" pattern="dd" /></span>
                                        <small><fmt:formatDate value="${record.date}" pattern="MMM" /></small>
                                      </div>
                                      <span><fmt:formatDate value="${record.date}" pattern="EEEE" /></span>
                                    </div>
                                  </td>
                                  <td>
                                    <span class="badge rounded-pill px-3 py-2
                                      <c:choose>
                                        <c:when test="${record.status == 'present'}">bg-success</c:when>
                                        <c:when test="${record.status == 'late'}">bg-warning text-dark</c:when>
                                        <c:otherwise>bg-danger</c:otherwise>
                                      </c:choose>
                                    ">
                                      <i class="bi 
                                        <c:choose>
                                          <c:when test="${record.status == 'present'}">bi-check-circle-fill</c:when>
                                          <c:when test="${record.status == 'late'}">bi-clock-fill</c:when>
                                          <c:otherwise>bi-x-circle-fill</c:otherwise>
                                        </c:choose> me-1
                                      "></i>
                                      ${record.status}
                                    </span>
                                  </td>
                                  <td>${record.remarks != null && record.remarks != '' ? record.remarks : '-'}</td>
                                </tr>
                              </c:forEach>
                              <c:if test="${empty attendanceInfo.recentAttendance}">
                                <tr>
                                  <td colspan="3" class="text-center py-4">
                                    <div class="py-5">
                                      <i class="bi bi-calendar-x text-muted" style="font-size: 2.5rem"></i>
                                      <p class="mt-3 text-muted">No attendance records available</p>
                                      <button class="btn btn-sm btn-outline-primary mt-2">
                                        <i class="bi bi-arrow-repeat me-1"></i> Refresh Data
                                      </button>
                                    </div>
                                  </td>
                                </tr>
                              </c:if>
                            </tbody>
                          </table>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Behavior Tab -->
              <div class="tab-pane fade" id="behavior" role="tabpanel" aria-labelledby="behavior-tab">
                <div class="row">
                  <div class="col-md-12 mb-4">
                    <div class="content-card">
                      <div class="card-header bg-white py-3">
                        <div class="d-flex justify-content-between align-items-center">
                          <h5 class="card-title mb-0 d-flex align-items-center">
                            <i class="bi bi-emoji-smile me-2 text-primary"></i>
                            Behavior Records
                          </h5>
                          <div class="dropdown">
                            <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" id="filterBehavior" data-bs-toggle="dropdown" aria-expanded="false">
                              <i class="bi bi-funnel me-1"></i> Filter
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="filterBehavior">
                              <li><a class="dropdown-item" href="#">All Records</a></li>
                              <li><a class="dropdown-item" href="#">Positive Only</a></li>
                              <li><a class="dropdown-item" href="#">Negative Only</a></li>
                            </ul>
                          </div>
                        </div>
                      </div>
                      <div class="card-body">
                        <div class="table-responsive">
                          <table class="table table-hover align-middle">
                            <thead class="table-light">
                              <tr>
                                <th>Date</th>
                                <th>Behavior Type</th>
                                <th>Description</th>
                                <th>Reported By</th>
                                <th>Action Taken</th>
                              </tr>
                            </thead>
                            <tbody>
                              <c:forEach var="record" items="${behaviorRecords}" varStatus="loop">
                                <tr ${loop.index % 2 == 0 ? 'class="table-light"' : ''}>
                                  <td>
                                    <div class="d-flex align-items-center">
                                      <div class="bg-light p-2 rounded me-2 text-center" style="min-width: 45px;">
                                        <span class="d-block fw-bold"><fmt:formatDate value="${record.behaviorDate}" pattern="dd" /></span>
                                        <small><fmt:formatDate value="${record.behaviorDate}" pattern="MMM" /></small>
                                      </div>
                                    </div>
                                  </td>
                                  <td>
                                    <span class="badge rounded-pill px-3 py-2
                                      <c:choose>
                                        <c:when test="${fn:startsWith(record.behaviorType, 'Positive')}">bg-success</c:when>
                                        <c:otherwise>bg-danger</c:otherwise>
                                      </c:choose>
                                    ">
                                      <i class="bi 
                                        <c:choose>
                                          <c:when test="${fn:startsWith(record.behaviorType, 'Positive')}">bi-emoji-smile-fill</c:when>
                                          <c:otherwise>bi-emoji-frown-fill</c:otherwise>
                                        </c:choose> me-1
                                      "></i>
                                      ${record.behaviorType}
                                    </span>
                                  </td>
                                  <td>${record.description}</td>
                                  <td>
                                    <div class="d-flex align-items-center">
                                      <div class="bg-secondary bg-opacity-10 text-secondary p-2 rounded-circle me-2">
                                        <i class="bi bi-person-fill"></i>
                                      </div>
                                      ${record.reporterName}
                                    </div>
                                  </td>
                                  <td>${record.actionTaken}</td>
                                </tr>
                              </c:forEach>
                              <c:if test="${empty behaviorRecords}">
                                <tr>
                                  <td colspan="5" class="text-center py-4">
                                    <div class="py-5">
                                      <i class="bi bi-emoji-smile text-muted" style="font-size: 2.5rem"></i>
                                      <p class="mt-3 text-muted">No behavior records available</p>
                                      <p class="small text-muted mb-3">This is good! It means there are no behavioral concerns to report.</p>
                                      <button class="btn btn-sm btn-outline-primary mt-2">
                                        <i class="bi bi-arrow-repeat me-1"></i> Refresh Data
                                      </button>
                                    </div>
                                  </td>
                                </tr>
                              </c:if>
                            </tbody>
                          </table>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </c:if>

          <c:if test="${selectedStudent == null && children != null && not empty children}">
            <div class="content-card">
              <div class="card-body text-center py-5">
                <div class="py-3">
                  <div class="d-inline-flex align-items-center justify-content-center bg-info bg-opacity-25 p-3 rounded-circle mb-3">
                    <i class="bi bi-arrow-up-circle text-info fs-1"></i>
                  </div>
                  <h4 class="mb-3">Select a Child</h4>
                  <p class="text-muted mb-4">Please select a child from the dropdown above to view their progress details.</p>
                  <button class="btn btn-primary" onclick="document.getElementById('studentSelect').focus()">
                    <i class="bi bi-people me-2"></i> Select Child
                  </button>
                </div>
              </div>
            </div>
          </c:if>

          <c:if test="${children == null || empty children}">
            <div class="content-card">
              <div class="card-body text-center py-5">
                <div class="py-3">
                  <div class="d-inline-flex align-items-center justify-content-center bg-warning bg-opacity-25 p-3 rounded-circle mb-3">
                    <i class="bi bi-exclamation-triangle text-warning fs-1"></i>
                  </div>
                  <h4 class="mb-3">No Children Found</h4>
                  <p class="text-muted mb-4">You don't have any children registered in the system yet. Please contact the school administration.</p>
                  <a href="${pageContext.request.contextPath}/parent/dashboard" class="btn btn-primary">
                    <i class="bi bi-house me-2"></i> Return to Dashboard
                  </a>
                </div>
              </div>
            </div>
          </c:if>
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