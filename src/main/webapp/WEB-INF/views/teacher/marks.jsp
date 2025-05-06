<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Marks & Grades - School Management System</title>
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
    <!-- DataTables CSS -->
    <link
      rel="stylesheet"
      href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css"
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
      .stats-card {
        border-radius: var(--border-radius);
        border: none;
        box-shadow: var(--card-shadow);
        height: 100%;
        transition: all var(--transition-speed);
      }

      .stats-card:hover {
        transform: translateY(-5px);
        box-shadow: var(--hover-shadow);
      }

      .stats-badge {
        font-size: 0.75rem;
        padding: 0.35em 0.65em;
        border-radius: 50rem;
        font-weight: 500;
      }

      .action-buttons .btn {
        border-radius: var(--border-radius);
        transition: all var(--transition-speed);
      }

      .action-buttons .btn:hover {
        transform: translateY(-2px);
      }

      .stats-badge-progress {
        width: 60px;
        height: 4px;
        background-color: rgba(255, 255, 255, 0.2);
        border-radius: 2px;
        margin-top: 4px;
      }

      .badge-progress-fill {
        height: 100%;
        border-radius: 2px;
      }

      .course-card {
        border-radius: var(--border-radius);
        border: none;
        box-shadow: var(--card-shadow);
        transition: all var(--transition-speed);
      }

      .course-card:hover {
        transform: translateY(-3px);
        box-shadow: var(--hover-shadow);
      }

      .score-badge {
        position: relative;
        width: 70px;
        height: 30px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        text-align: center;
        border-radius: 50rem;
        font-weight: 500;
        font-size: 0.8rem;
      }
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
        <!-- Include Teacher Sidebar -->
        <jsp:include page="/WEB-INF/includes/teacher-sidebar.jsp" />

        <!-- Main content -->
        <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
          <!-- Breadcrumb -->
          <nav aria-label="breadcrumb" class="mt-3">
            <ol class="breadcrumb">
              <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/teacher/dashboard"
                  >Dashboard</a
                >
              </li>
              <li class="breadcrumb-item active" aria-current="page">
                Marks & Grades
              </li>
            </ol>
          </nav>

          <div
            class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center"
          >
            <h1 class="page-title">Marks & Grades Overview</h1>
            <div class="btn-toolbar">
              <div class="dropdown">
                <button
                  class="btn btn-outline-secondary dropdown-toggle"
                  type="button"
                  id="dropdownMenuButton"
                  data-bs-toggle="dropdown"
                  aria-expanded="false"
                >
                  <i class="bi bi-person-circle me-1"></i> ${user.username}
                </button>
                <ul
                  class="dropdown-menu dropdown-menu-end"
                  aria-labelledby="dropdownMenuButton"
                >
                  <li>
                    <a class="dropdown-item" href="#"
                      ><i class="bi bi-person me-2"></i> My Profile</a
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

          <!-- Success/Error Messages -->
          <c:if test="${not empty successMessage}">
            <div
              class="alert alert-success alert-dismissible fade show"
              role="alert"
            >
              <i class="bi bi-check-circle-fill me-2"></i> ${successMessage}
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
                aria-label="Close"
              ></button>
            </div>
          </c:if>

          <c:if test="${not empty errorMessage}">
            <div
              class="alert alert-danger alert-dismissible fade show"
              role="alert"
            >
              <i class="bi bi-exclamation-triangle-fill me-2"></i>
              ${errorMessage}
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
                aria-label="Close"
              ></button>
            </div>
          </c:if>

          <!-- Summary Cards -->
          <div class="row mb-4">
            <div class="col-md-4 mb-3">
              <div class="stats-card bg-primary text-white p-4">
                <div class="d-flex align-items-center mb-3">
                  <div class="stats-icon me-3">
                    <i class="bi bi-book" style="font-size: 2rem"></i>
                  </div>
                  <div>
                    <h6 class="mb-0">Total Courses</h6>
                    <small class="text-white-50"
                      >Courses you currently teach</small
                    >
                  </div>
                </div>
                <h2 class="display-5 fw-bold mb-0">${teacherCourses.size()}</h2>
                <div class="mt-3">
                  <a
                    href="${pageContext.request.contextPath}/teacher/courses"
                    class="btn btn-sm btn-outline-light"
                  >
                    <i class="bi bi-arrow-right me-1"></i> View All Courses
                  </a>
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-3">
              <div class="stats-card bg-success text-white p-4">
                <div class="d-flex align-items-center mb-3">
                  <div class="stats-icon me-3">
                    <i class="bi bi-people" style="font-size: 2rem"></i>
                  </div>
                  <div>
                    <h6 class="mb-0">Total Students</h6>
                    <small class="text-white-50"
                      >Students across all courses</small
                    >
                  </div>
                </div>
                <h2 class="display-5 fw-bold mb-0">
                  <c:set var="totalStudents" value="0" />
                  <c:forEach items="${teacherCourses}" var="course">
                    <c:set
                      var="totalStudents"
                      value="${totalStudents + course.studentCount}"
                    />
                  </c:forEach>
                  ${totalStudents}
                </h2>
                <div class="mt-3">
                  <a
                    href="${pageContext.request.contextPath}/teacher/students"
                    class="btn btn-sm btn-outline-light"
                  >
                    <i class="bi bi-arrow-right me-1"></i> View All Students
                  </a>
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-3">
              <div class="stats-card bg-info text-white p-4">
                <div class="d-flex align-items-center mb-3">
                  <div class="stats-icon me-3">
                    <i class="bi bi-graph-up" style="font-size: 2rem"></i>
                  </div>
                  <div>
                    <h6 class="mb-0">Average Performance</h6>
                    <small class="text-white-50"
                      >Overall student achievement</small
                    >
                  </div>
                </div>
                <h2 class="display-5 fw-bold mb-0">
                  <c:set var="totalAvg" value="0" />
                  <c:set var="courseCount" value="0" />
                  <c:forEach items="${teacherCourses}" var="course">
                    <c:if
                      test="${not empty course.markStats && course.markStats.average > 0}"
                    >
                      <c:set
                        var="totalAvg"
                        value="${totalAvg + course.markStats.average}"
                      />
                      <c:set var="courseCount" value="${courseCount + 1}" />
                    </c:if>
                  </c:forEach>
                  <c:choose>
                    <c:when test="${courseCount > 0}">
                      <fmt:formatNumber
                        value="${totalAvg / courseCount}"
                        pattern="#.##"
                      />%
                    </c:when>
                    <c:otherwise> N/A </c:otherwise>
                  </c:choose>
                </h2>
                <div class="mt-3">
                  <a
                    href="${pageContext.request.contextPath}/teacher/reports"
                    class="btn btn-sm btn-outline-light"
                  >
                    <i class="bi bi-arrow-right me-1"></i> View Reports
                  </a>
                </div>
              </div>
            </div>
          </div>

          <!-- Course List Table -->
          <div class="content-card mb-4">
            <div
              class="card-header d-flex justify-content-between align-items-center"
            >
              <h5 class="mb-0">Courses & Marks</h5>
              <div>
                <div class="input-group">
                  <input
                    type="text"
                    class="form-control form-control-sm"
                    placeholder="Search courses..."
                    id="courseSearch"
                  />
                  <button
                    class="btn btn-outline-secondary btn-sm"
                    type="button"
                  >
                    <i class="bi bi-search"></i>
                  </button>
                </div>
              </div>
            </div>
            <div class="card-body p-0">
              <div class="table-responsive">
                <table id="coursesTable" class="table table-hover mb-0">
                  <thead>
                    <tr>
                      <th>Course Code</th>
                      <th>Course Name</th>
                      <th>Students</th>
                      <th>Average Score</th>
                      <th>Highest Score</th>
                      <th>Lowest Score</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach items="${teacherCourses}" var="course">
                      <tr>
                        <td>${course.courseCode}</td>
                        <td>
                          <div class="d-flex align-items-center">
                            <div class="subject-icon me-2">
                              <span class="badge bg-primary rounded-circle p-2">
                                <i class="bi bi-book"></i>
                              </span>
                            </div>
                            <span class="fw-medium">${course.courseName}</span>
                          </div>
                        </td>
                        <td>
                          <div class="d-flex align-items-center">
                            <span class="badge bg-primary rounded-pill">
                              <i class="bi bi-people-fill me-1"></i>
                              ${course.studentCount}
                            </span>
                          </div>
                        </td>
                        <td>
                          <c:choose>
                            <c:when
                              test="${not empty course.markStats && course.markStats.average > 0}"
                            >
                              <div
                                class="score-badge bg-info bg-opacity-10 text-info"
                              >
                                <fmt:formatNumber
                                  value="${course.markStats.average}"
                                  pattern="#.##"
                                />%
                              </div>
                            </c:when>
                            <c:otherwise>
                              <div
                                class="score-badge bg-secondary bg-opacity-10 text-secondary"
                              >
                                N/A
                              </div>
                            </c:otherwise>
                          </c:choose>
                        </td>
                        <td>
                          <c:choose>
                            <c:when
                              test="${not empty course.markStats && course.markStats.highest > 0}"
                            >
                              <div
                                class="score-badge bg-success bg-opacity-10 text-success"
                              >
                                <fmt:formatNumber
                                  value="${course.markStats.highest}"
                                  pattern="#.##"
                                />%
                              </div>
                            </c:when>
                            <c:otherwise>
                              <div
                                class="score-badge bg-secondary bg-opacity-10 text-secondary"
                              >
                                N/A
                              </div>
                            </c:otherwise>
                          </c:choose>
                        </td>
                        <td>
                          <c:choose>
                            <c:when
                              test="${not empty course.markStats && course.markStats.lowest > 0}"
                            >
                              <div
                                class="score-badge bg-warning bg-opacity-10 text-warning"
                              >
                                <fmt:formatNumber
                                  value="${course.markStats.lowest}"
                                  pattern="#.##"
                                />%
                              </div>
                            </c:when>
                            <c:otherwise>
                              <div
                                class="score-badge bg-secondary bg-opacity-10 text-secondary"
                              >
                                N/A
                              </div>
                            </c:otherwise>
                          </c:choose>
                        </td>
                        <td>
                          <div class="action-buttons">
                            <a
                              href="${pageContext.request.contextPath}/teacher/course-marks?id=${course.courseId}"
                              class="btn btn-primary btn-sm"
                            >
                              <i class="bi bi-pencil-square me-1"></i> Manage
                              Marks
                            </a>
                          </div>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>
            </div>
          </div>

          <!-- Recent Assessments Section -->
          <div class="row mb-4">
            <div class="col-12">
              <div class="content-card">
                <div
                  class="card-header d-flex justify-content-between align-items-center"
                >
                  <h5 class="mb-0">Recent Assessments</h5>
                  <button class="btn btn-outline-primary btn-sm">
                    <i class="bi bi-plus-circle me-1"></i> Add New Assessment
                  </button>
                </div>
                <div class="card-body">
                  <c:choose>
                    <c:when test="${not empty recentAssessments}">
                      <div class="row">
                        <c:forEach
                          items="${recentAssessments}"
                          var="assessment"
                        >
                          <div class="col-md-6 col-lg-4 mb-3">
                            <div class="course-card p-3">
                              <div
                                class="d-flex justify-content-between align-items-center mb-2"
                              >
                                <h6 class="mb-0">${assessment.title}</h6>
                                <span
                                  class="badge bg-${assessment.type eq 'Exam' ? 'danger' : assessment.type eq 'Quiz' ? 'warning' : 'info'}"
                                >
                                  ${assessment.type}
                                </span>
                              </div>
                              <p class="small text-muted mb-2">
                                <i class="bi bi-book me-1"></i>
                                ${assessment.courseName}
                              </p>
                              <p class="small text-muted mb-3">
                                <i class="bi bi-calendar-event me-1"></i>
                                ${assessment.date}
                              </p>
                              <div
                                class="d-flex justify-content-between align-items-center"
                              >
                                <div>
                                  <span class="badge bg-light text-dark">
                                    <i class="bi bi-person me-1"></i>
                                    ${assessment.submissionCount} Submissions
                                  </span>
                                </div>
                                <a
                                  href="#"
                                  class="btn btn-sm btn-outline-secondary"
                                >
                                  <i class="bi bi-eye me-1"></i> View
                                </a>
                              </div>
                            </div>
                          </div>
                        </c:forEach>
                      </div>
                    </c:when>
                    <c:otherwise>
                      <div class="text-center py-5">
                        <div class="mb-3">
                          <i
                            class="bi bi-clipboard2-data text-muted"
                            style="font-size: 3rem"
                          ></i>
                        </div>
                        <h5 class="text-muted">No Recent Assessments</h5>
                        <p class="text-muted">
                          Create a new assessment to start grading students
                        </p>
                        <button class="btn btn-primary mt-2">
                          <i class="bi bi-plus-circle me-1"></i> Create New
                          Assessment
                        </button>
                      </div>
                    </c:otherwise>
                  </c:choose>
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
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>

    <script>
      $(document).ready(function () {
        // Initialize DataTable
        var table = $("#coursesTable").DataTable({
          paging: true,
          lengthChange: false,
          searching: true,
          ordering: true,
          info: true,
          autoWidth: false,
          responsive: true,
          dom: '<"top"f>rt<"bottom"ip>',
          language: {
            search: "",
            searchPlaceholder: "Search courses...",
          },
        });

        // Use the custom search box
        $("#courseSearch").on("keyup", function () {
          table.search(this.value).draw();
        });

        // Tooltip initialization
        var tooltipTriggerList = [].slice.call(
          document.querySelectorAll('[data-bs-toggle="tooltip"]')
        );
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
          return new bootstrap.Tooltip(tooltipTriggerEl);
        });
      });
    </script>
  </body>
</html>
