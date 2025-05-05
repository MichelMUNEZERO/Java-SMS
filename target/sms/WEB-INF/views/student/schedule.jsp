<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %> <%! // Define a Java method to
determine border color based on course code public String getBorderColor(String
courseCode) { if (courseCode == null) return "#6c757d"; // Default to gray
String prefix = courseCode.substring(0, Math.min(3,
courseCode.length())).toLowerCase(); if (prefix.contains("mat") ||
prefix.contains("alg") || prefix.contains("cal")) { return "#0d6efd"; //
Bootstrap primary (blue) } else if (prefix.contains("sci") ||
prefix.contains("bio") || prefix.contains("che") || prefix.contains("phy")) {
return "#198754"; // Bootstrap success (green) } else if (prefix.contains("eng")
|| prefix.contains("spa") || prefix.contains("fre") || prefix.contains("lan")) {
return "#0dcaf0"; // Bootstrap info (cyan) } else if (prefix.contains("his") ||
prefix.contains("geo") || prefix.contains("soc")) { return "#ffc107"; //
Bootstrap warning (yellow) } else if (prefix.contains("art") ||
prefix.contains("mus") || prefix.contains("dra")) { return "#dc3545"; //
Bootstrap danger (red) } else { return "#6c757d"; // Bootstrap secondary (gray)
} } %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Schedule - School Management System</title>
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
      .schedule-card {
        transition: transform 0.3s;
        border-radius: 10px;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        margin-bottom: 20px;
      }
      .schedule-card:hover {
        transform: translateY(-5px);
      }
      .class-item {
        border-left: 4px solid;
        padding: 10px 15px;
        margin-bottom: 10px;
        border-radius: 5px;
        background-color: #f8f9fa;
        transition: all 0.3s;
        position: relative;
      }
      .class-item:hover {
        transform: translateX(5px);
      }
      .class-time {
        font-weight: bold;
      }
      .teacher-info {
        font-size: 0.9rem;
        color: #6c757d;
      }
      .room-badge {
        position: absolute;
        top: 10px;
        right: 10px;
      }
      .day-header {
        background-color: #f0f0f0;
        padding: 10px;
        border-radius: 5px;
        margin-bottom: 15px;
        font-weight: bold;
      }
      .schedule-legend {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        margin-bottom: 20px;
      }
      .legend-item {
        display: flex;
        align-items: center;
        font-size: 0.9rem;
      }
      .legend-color {
        width: 15px;
        height: 15px;
        margin-right: 5px;
        border-radius: 3px;
      }
      
      .profile-img {
        width: 40px;
        height: 40px;
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
              <span class="fs-4 text-white"
                ><i class="bi bi-building me-2"></i>School MS</span
              >
            </div>
            <hr class="text-white" />
            <ul class="nav flex-column">
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/student/dashboard"
                >
                  <i class="bi bi-speedometer2 me-2"></i> Dashboard
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/student/courses"
                >
                  <i class="bi bi-book me-2"></i> My Courses
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/student/grades"
                >
                  <i class="bi bi-card-checklist me-2"></i> Grades
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/student/assignments"
                >
                  <i class="bi bi-file-earmark-text me-2"></i> Assignments
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/student/update-parent"
                >
                  <i class="bi bi-people me-2"></i> Parent Info
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
            <h1 class="h2">My Weekly Schedule</h1>
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
                  <c:choose>
                    <c:when test="${not empty profileData.imageLink}">
                      <img src="${profileData.imageLink}" alt="${user.username}" class="profile-img me-2">
                    </c:when>
                    <c:otherwise>
                      <c:choose>
                        <c:when test="${user.role eq 'student'}">
                          <i class="bi bi-book me-1"></i>
                        </c:when>
                        <c:otherwise>
                          <i class="bi bi-person-circle me-1"></i>
                        </c:otherwise>
                      </c:choose>
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

          <!-- Alerts -->
          <c:if test="${not empty error}">
            <div
              class="alert alert-danger alert-dismissible fade show"
              role="alert"
            >
              ${error}
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
                aria-label="Close"
              ></button>
            </div>
          </c:if>
          <c:if test="${not empty message}">
            <div
              class="alert alert-success alert-dismissible fade show"
              role="alert"
            >
              ${message}
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
                aria-label="Close"
              ></button>
            </div>
          </c:if>

          <!-- Schedule Legend -->
          <div class="schedule-legend">
            <div class="legend-item">
              <div class="legend-color bg-primary"></div>
              <span>Mathematics</span>
            </div>
            <div class="legend-item">
              <div class="legend-color bg-success"></div>
              <span>Science</span>
            </div>
            <div class="legend-item">
              <div class="legend-color bg-info"></div>
              <span>Languages</span>
            </div>
            <div class="legend-item">
              <div class="legend-color bg-warning"></div>
              <span>Social Studies</span>
            </div>
            <div class="legend-item">
              <div class="legend-color bg-danger"></div>
              <span>Arts</span>
            </div>
            <div class="legend-item">
              <div class="legend-color bg-secondary"></div>
              <span>Other</span>
            </div>
          </div>

          <!-- Weekly Schedule -->
          <div class="row">
            <c:choose>
              <c:when test="${empty schedule}">
                <div class="col-12">
                  <div class="alert alert-info" role="alert">
                    <i class="bi bi-info-circle me-2"></i> No schedule
                    information available.
                  </div>
                </div>
              </c:when>
              <c:otherwise>
                <c:forEach var="day" items="${daysOfWeek}">
                  <div class="col-md-12 mb-4">
                    <div class="card schedule-card">
                      <div class="card-header">
                        <h5 class="mb-0">
                          <i class="bi bi-calendar3 me-2"></i> ${day}
                        </h5>
                      </div>
                      <div class="card-body">
                        <c:choose>
                          <c:when test="${empty schedule[day]}">
                            <p class="text-muted">
                              No classes scheduled for this day.
                            </p>
                          </c:when>
                          <c:otherwise>
                            <c:forEach
                              var="class"
                              items="${schedule[day]}"
                              varStatus="loop"
                            >
                              <div
                                class="class-item"
                                style="border-left-color: ${getBorderColor(class.courseCode)};"
                              >
                                <span class="room-badge badge bg-secondary"
                                  >Room ${class.roomNumber}</span
                                >
                                <div class="class-time">
                                  <i class="bi bi-clock me-1"></i>
                                  <fmt:formatDate
                                    value="${class.startTime}"
                                    pattern="h:mm a"
                                  />
                                  -
                                  <fmt:formatDate
                                    value="${class.endTime}"
                                    pattern="h:mm a"
                                  />
                                </div>
                                <h5>
                                  ${class.courseCode}: ${class.courseName}
                                </h5>
                                <div class="teacher-info">
                                  <i class="bi bi-person me-1"></i>
                                  ${class.teacherName}
                                </div>
                              </div>
                            </c:forEach>
                          </c:otherwise>
                        </c:choose>
                      </div>
                    </div>
                  </div>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </div>

          <!-- Schedule Information Card -->
          <div class="row mt-4 mb-4">
            <div class="col-md-12">
              <div class="card">
                <div class="card-header bg-info text-white">
                  <h5 class="card-title mb-0">
                    <i class="bi bi-info-circle me-2"></i> Schedule Information
                  </h5>
                </div>
                <div class="card-body">
                  <div class="row">
                    <div class="col-md-6">
                      <h6>
                        <i class="bi bi-check-circle-fill text-success me-2"></i
                        >Attendance Policy
                      </h6>
                      <ul>
                        <li>
                          Arrive at class at least 5 minutes before start time
                        </li>
                        <li>
                          Attendance is taken at the beginning of each class
                        </li>
                        <li>Three late arrivals count as one absence</li>
                        <li>Maximum allowed absences: 3 per semester</li>
                      </ul>
                    </div>
                    <div class="col-md-6">
                      <h6>
                        <i
                          class="bi bi-calendar-check-fill text-primary me-2"
                        ></i
                        >Important Dates
                      </h6>
                      <ul>
                        <li>Midterm Exams: October 15-19</li>
                        <li>Fall Break: November 22-26</li>
                        <li>Final Exams: December 10-14</li>
                        <li>Winter Break: December 15 - January 2</li>
                      </ul>
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
