<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Courses - School Management System</title>
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
      .action-buttons .btn {
        width: 32px;
        height: 32px;
        padding: 0;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        margin-right: 0.25rem;
      }

      .course-card {
        transition: all var(--transition-speed);
        border-radius: var(--border-radius);
        border: none;
        box-shadow: var(--card-shadow);
        height: 100%;
      }

      .course-card:hover {
        transform: translateY(-5px);
        box-shadow: var(--hover-shadow);
      }

      .table > tbody > tr > td {
        vertical-align: middle;
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
                My Courses
              </li>
            </ol>
          </nav>

          <div
            class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center"
          >
            <h1 class="page-title">My Courses</h1>
            <div class="btn-toolbar">
              <button
                type="button"
                class="btn btn-primary"
                data-bs-toggle="modal"
                data-bs-target="#addCourseModal"
              >
                <i class="bi bi-plus-circle me-1"></i> Add Course
              </button>
            </div>
          </div>

          <!-- Alert for messages -->
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

          <!-- Course List -->
          <div class="content-card mb-4">
            <div
              class="card-header d-flex justify-content-between align-items-center"
            >
              <h5 class="mb-0">Course List</h5>
              <div>
                <button class="btn btn-sm btn-outline-secondary me-2">
                  <i class="bi bi-download me-1"></i> Export
                </button>
                <div class="dropdown d-inline-block">
                  <button
                    class="btn btn-sm btn-outline-secondary dropdown-toggle"
                    type="button"
                    id="dropdownMenuButton"
                    data-bs-toggle="dropdown"
                    aria-expanded="false"
                  >
                    <i class="bi bi-funnel me-1"></i> Filter
                  </button>
                  <ul
                    class="dropdown-menu"
                    aria-labelledby="dropdownMenuButton"
                  >
                    <li><a class="dropdown-item" href="#">All Courses</a></li>
                    <li>
                      <a class="dropdown-item" href="#">Active Courses</a>
                    </li>
                    <li>
                      <a class="dropdown-item" href="#">Archived Courses</a>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
            <div class="card-body p-0">
              <div class="table-responsive">
                <table id="courseTable" class="table table-hover mb-0">
                  <thead>
                    <tr>
                      <th>Course Code</th>
                      <th>Course Name</th>
                      <th>Description</th>
                      <th>Students</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:choose>
                      <c:when test="${not empty teacherCourses}">
                        <c:forEach items="${teacherCourses}" var="course">
                          <tr>
                            <td>
                              <span class="fw-medium"
                                >${course.courseCode}</span
                              >
                            </td>
                            <td>${course.courseName}</td>
                            <td>${course.description}</td>
                            <td>
                              <span class="badge bg-primary"
                                >${course.studentCount}</span
                              >
                            </td>
                            <td>
                              <div class="action-buttons">
                                <button
                                  type="button"
                                  class="btn btn-sm btn-primary"
                                  onclick="viewCourseDetails('${course.courseId}')"
                                  title="View Course"
                                >
                                  <i class="bi bi-eye"></i>
                                </button>
                                <button
                                  type="button"
                                  class="btn btn-sm btn-success"
                                  onclick="manageStudents('${course.courseId}')"
                                  title="Manage Students"
                                >
                                  <i class="bi bi-people"></i>
                                </button>
                                <button
                                  type="button"
                                  class="btn btn-sm btn-warning"
                                  onclick="manageMarks('${course.courseId}')"
                                  title="Manage Marks"
                                >
                                  <i class="bi bi-card-checklist"></i>
                                </button>
                              </div>
                            </td>
                          </tr>
                        </c:forEach>
                      </c:when>
                      <c:otherwise>
                        <tr>
                          <td colspan="5" class="text-center py-3">
                            <div class="d-flex flex-column align-items-center">
                              <i
                                class="bi bi-info-circle text-muted mb-2"
                                style="font-size: 1.5rem"
                              ></i>
                              <p class="text-muted mb-0">
                                No courses available
                              </p>
                            </div>
                          </td>
                        </tr>
                      </c:otherwise>
                    </c:choose>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Add Course Modal -->
    <div
      class="modal fade"
      id="addCourseModal"
      tabindex="-1"
      aria-labelledby="addCourseModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="addCourseModalLabel">Add New Course</h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <form
              id="addCourseForm"
              action="${pageContext.request.contextPath}/teacher/courses"
              method="post"
              class="needs-validation"
              novalidate
            >
              <input type="hidden" name="action" value="add" />
              <div class="mb-3">
                <label for="courseCode" class="form-label required-field"
                  >Course Code</label
                >
                <input
                  type="text"
                  class="form-control"
                  id="courseCode"
                  name="courseCode"
                  required
                />
                <div class="invalid-feedback">Please enter a course code.</div>
              </div>
              <div class="mb-3">
                <label for="courseName" class="form-label required-field"
                  >Course Name</label
                >
                <input
                  type="text"
                  class="form-control"
                  id="courseName"
                  name="courseName"
                  required
                />
                <div class="invalid-feedback">Please enter a course name.</div>
              </div>
              <div class="mb-3">
                <label for="description" class="form-label">Description</label>
                <textarea
                  class="form-control"
                  id="description"
                  name="description"
                  rows="3"
                ></textarea>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-outline-secondary"
              data-bs-dismiss="modal"
            >
              <i class="bi bi-x-circle me-1"></i> Cancel
            </button>
            <button type="submit" form="addCourseForm" class="btn btn-primary">
              <i class="bi bi-plus-circle me-1"></i> Add Course
            </button>
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
        $("#courseTable").DataTable({
          paging: true,
          searching: true,
          ordering: true,
          info: true,
          lengthMenu: [
            [10, 25, 50, -1],
            [10, 25, 50, "All"],
          ],
        });

        // Form validation
        (function () {
          "use strict";

          // Fetch all forms we want to apply validation styles to
          var forms = document.querySelectorAll(".needs-validation");

          // Loop over them and prevent submission
          Array.prototype.slice.call(forms).forEach(function (form) {
            form.addEventListener(
              "submit",
              function (event) {
                if (!form.checkValidity()) {
                  event.preventDefault();
                  event.stopPropagation();
                }
                form.classList.add("was-validated");
              },
              false
            );
          });
        })();
      });

      function viewCourseDetails(courseId) {
        window.location.href =
          "${pageContext.request.contextPath}/teacher/course-details?id=" +
          courseId;
      }

      function manageStudents(courseId) {
        window.location.href =
          "${pageContext.request.contextPath}/teacher/course-students?id=" +
          courseId;
      }

      function manageMarks(courseId) {
        window.location.href =
          "${pageContext.request.contextPath}/teacher/course-marks?id=" +
          courseId;
      }
    </script>
  </body>
</html>
