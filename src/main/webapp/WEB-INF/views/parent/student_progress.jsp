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

      .nav-tabs .nav-link.active {
        font-weight: bold;
        color: #0d6efd;
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
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/parent/dashboard">
                  <i class="bi bi-speedometer2 me-2"></i> Dashboard
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link active text-white" href="${pageContext.request.contextPath}/parent/student-progress">
                  <i class="bi bi-people me-2"></i> My Children
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/parent/student-progress">
                  <i class="bi bi-card-checklist me-2"></i> Academic Progress
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/parent/announcements">
                  <i class="bi bi-megaphone me-2"></i> Announcements
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/parent/appointments">
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
            <h1 class="h2">Student Progress</h1>
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

          <!-- Student Selection -->
          <div class="row mb-4">
            <div class="col-md-12">
              <div class="card dashboard-card">
                <div class="card-body">
                  <form action="${pageContext.request.contextPath}/parent/student-progress" method="get" class="row g-3 align-items-center">
                    <div class="col-md-5">
                      <label for="studentSelect" class="form-label">Select Child</label>
                      <select name="studentId" id="studentSelect" class="form-select" onchange="this.form.submit()">
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
                        <div class="alert alert-info mb-0">
                          <strong>Selected Child:</strong> ${selectedStudent.firstName} ${selectedStudent.lastName} | 
                          <strong>Grade:</strong> ${selectedStudent.grade} | 
                          <strong>ID:</strong> ${selectedStudent.regNumber}
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
                  Academic Progress
                </button>
              </li>
              <li class="nav-item" role="presentation">
                <button class="nav-link" id="attendance-tab" data-bs-toggle="tab" data-bs-target="#attendance" type="button" role="tab" aria-controls="attendance" aria-selected="false">
                  Attendance
                </button>
              </li>
              <li class="nav-item" role="presentation">
                <button class="nav-link" id="behavior-tab" data-bs-toggle="tab" data-bs-target="#behavior" type="button" role="tab" aria-controls="behavior" aria-selected="false">
                  Behavior Records
                </button>
              </li>
            </ul>

            <!-- Tab Content -->
            <div class="tab-content" id="progressTabsContent">
              <!-- Academic Progress Tab -->
              <div class="tab-pane fade show active" id="academic" role="tabpanel" aria-labelledby="academic-tab">
                <div class="row">
                  <div class="col-md-12 mb-4">
                    <div class="card dashboard-card">
                      <div class="card-header bg-white">
                        <h5 class="card-title mb-0">Academic Performance Summary</h5>
                      </div>
                      <div class="card-body">
                        <div class="row">
                          <div class="col-md-4 text-center mb-4">
                            <div class="border rounded p-3">
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
                          <div class="col-md-4 text-center mb-4">
                            <div class="border rounded p-3">
                              <h2 class="text-success mb-0">${courseCount}</h2>
                              <p class="text-muted mb-0">Total Courses</p>
                            </div>
                          </div>
                          <div class="col-md-4 text-center mb-4">
                            <div class="border rounded p-3">
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
                    <div class="card dashboard-card">
                      <div class="card-header bg-white">
                        <h5 class="card-title mb-0">Course Performance</h5>
                      </div>
                      <div class="card-body">
                        <div class="table-responsive">
                          <table class="table table-hover">
                            <thead>
                              <tr>
                                <th>Course</th>
                                <th>Teacher</th>
                                <th class="text-center">Average Score</th>
                                <th class="text-center">Grade</th>
                                <th class="text-center">Progress</th>
                              </tr>
                            </thead>
                            <tbody>
                              <c:forEach var="course" items="${academicProgress}">
                                <tr>
                                  <td>${course.courseName} (${course.courseCode})</td>
                                  <td>${course.teacherName}</td>
                                  <td class="text-center"><fmt:formatNumber value="${course.average}" pattern="#.##" />%</td>
                                  <td class="text-center">
                                    <span class="badge 
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
                                  <td colspan="5" class="text-center">No course data available</td>
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
                    <div class="card dashboard-card">
                      <div class="card-header bg-white">
                        <h5 class="card-title mb-0">Attendance Summary</h5>
                      </div>
                      <div class="card-body">
                        <div class="row">
                          <div class="col-md-3 text-center mb-4">
                            <div class="border rounded p-3">
                              <h2 class="text-primary mb-0">
                                <c:if test="${attendanceInfo != null}">
                                  <fmt:formatNumber value="${attendanceInfo.percentage}" pattern="#.##" />%
                                </c:if>
                                <c:if test="${attendanceInfo == null}">N/A</c:if>
                              </h2>
                              <p class="text-muted mb-0">Overall Attendance</p>
                            </div>
                          </div>
                          <div class="col-md-3 text-center mb-4">
                            <div class="border rounded p-3">
                              <h2 class="text-success mb-0">${attendanceInfo.presentDays}</h2>
                              <p class="text-muted mb-0">Days Present</p>
                            </div>
                          </div>
                          <div class="col-md-3 text-center mb-4">
                            <div class="border rounded p-3">
                              <h2 class="text-danger mb-0">${attendanceInfo.absentDays}</h2>
                              <p class="text-muted mb-0">Days Absent</p>
                            </div>
                          </div>
                          <div class="col-md-3 text-center mb-4">
                            <div class="border rounded p-3">
                              <h2 class="text-warning mb-0">${attendanceInfo.lateDays}</h2>
                              <p class="text-muted mb-0">Days Late</p>
                            </div>
                          </div>
                        </div>

                        <div class="progress mb-4" style="height: 20px;">
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
                      </div>
                    </div>
                  </div>
                </div>

                <div class="row">
                  <div class="col-md-12 mb-4">
                    <div class="card dashboard-card">
                      <div class="card-header bg-white">
                        <h5 class="card-title mb-0">Recent Attendance Records</h5>
                      </div>
                      <div class="card-body">
                        <div class="table-responsive">
                          <table class="table table-hover">
                            <thead>
                              <tr>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Remarks</th>
                              </tr>
                            </thead>
                            <tbody>
                              <c:forEach var="record" items="${attendanceInfo.recentAttendance}">
                                <tr>
                                  <td>${record.date}</td>
                                  <td>
                                    <span class="badge 
                                      <c:choose>
                                        <c:when test="${record.status == 'present'}">bg-success</c:when>
                                        <c:when test="${record.status == 'late'}">bg-warning</c:when>
                                        <c:otherwise>bg-danger</c:otherwise>
                                      </c:choose>
                                    ">
                                      ${record.status}
                                    </span>
                                  </td>
                                  <td>${record.remarks}</td>
                                </tr>
                              </c:forEach>
                              <c:if test="${empty attendanceInfo.recentAttendance}">
                                <tr>
                                  <td colspan="3" class="text-center">No attendance records available</td>
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
                    <div class="card dashboard-card">
                      <div class="card-header bg-white">
                        <h5 class="card-title mb-0">Behavior Records</h5>
                      </div>
                      <div class="card-body">
                        <div class="table-responsive">
                          <table class="table table-hover">
                            <thead>
                              <tr>
                                <th>Date</th>
                                <th>Behavior Type</th>
                                <th>Description</th>
                                <th>Reported By</th>
                                <th>Action Taken</th>
                              </tr>
                            </thead>
                            <tbody>
                              <c:forEach var="record" items="${behaviorRecords}">
                                <tr>
                                  <td>${record.behaviorDate}</td>
                                  <td>
                                    <span class="badge 
                                      <c:choose>
                                        <c:when test="${fn:startsWith(record.behaviorType, 'Positive')}">bg-success</c:when>
                                        <c:otherwise>bg-danger</c:otherwise>
                                      </c:choose>
                                    ">
                                      ${record.behaviorType}
                                    </span>
                                  </td>
                                  <td>${record.description}</td>
                                  <td>${record.reporterName}</td>
                                  <td>${record.actionTaken}</td>
                                </tr>
                              </c:forEach>
                              <c:if test="${empty behaviorRecords}">
                                <tr>
                                  <td colspan="5" class="text-center">No behavior records available</td>
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
            <div class="alert alert-info">
              <i class="bi bi-info-circle me-2"></i>
              Please select a child from the dropdown above to view their progress.
            </div>
          </c:if>

          <c:if test="${children == null || empty children}">
            <div class="alert alert-warning">
              <i class="bi bi-exclamation-triangle me-2"></i>
              You don't have any children registered in the system yet. Please contact the school administration.
            </div>
          </c:if>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html> 