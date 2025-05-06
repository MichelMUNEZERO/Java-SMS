<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Course Details | Admin Dashboard</title>
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
      body {
        font-family: "Poppins", sans-serif;
        background-color: #f5f5f9;
      }
      .container-fluid {
        padding: 0;
      }
      main {
        padding: 20px;
        background-color: #f5f5f9;
      }
      .card {
        border-radius: 10px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        border: none;
        margin-bottom: 20px;
      }
      .card-header {
        background-color: #fff;
        border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        font-weight: 600;
        padding: 15px 20px;
        border-radius: 10px 10px 0 0 !important;
      }
      .card-body {
        padding: 20px;
      }
      .text-secondary {
        color: #6c757d !important;
      }
      .action-btn {
        margin-right: 5px;
      }
      h1.h2 {
        font-weight: 600;
        color: #333;
      }
      .course-code {
        background-color: #e9ecef;
        padding: 0.25rem 0.5rem;
        border-radius: 4px;
        font-size: 0.9em;
        color: #495057;
      }
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
        <!-- Include sidebar -->
        <jsp:include page="sidebar.jsp" />

        <!-- Main content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
          <div
            class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3"
          >
            <h1 class="h2">Course Details</h1>
            <div class="btn-toolbar mb-2 mb-md-0">
              <a
                href="${pageContext.request.contextPath}/admin/courses"
                class="btn btn-sm btn-outline-secondary me-2"
              >
                <i class="bi bi-arrow-left"></i> Back to Courses
              </a>
              <a
                href="${pageContext.request.contextPath}/admin/courses/edit/${course.id}"
                class="btn btn-sm btn-primary"
              >
                <i class="bi bi-pencil"></i> Edit
              </a>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-8">
              <div class="card">
                <div class="card-header">Course Information</div>
                <div class="card-body">
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Course Name</div>
                    <div class="col-sm-8">${course.courseName}</div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Course Code</div>
                    <div class="col-sm-8">
                      <span class="course-code">${course.courseCode}</span>
                    </div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Credits</div>
                    <div class="col-sm-8">${course.credits}</div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Teacher</div>
                    <div class="col-sm-8">
                      <c:choose>
                        <c:when test="${not empty course.teacherName}">
                          <a
                            href="${pageContext.request.contextPath}/admin/teachers/view/${course.teacherId}"
                          >
                            ${course.teacherName}
                          </a>
                        </c:when>
                        <c:otherwise>
                          <span class="text-muted">Not assigned</span>
                        </c:otherwise>
                      </c:choose>
                    </div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Status</div>
                    <div class="col-sm-8">
                      <span
                        class="badge ${course.status eq 'active' ? 'bg-success' : 'bg-danger'}"
                        >${course.status}</span
                      >
                    </div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Enrolled Students</div>
                    <div class="col-sm-8">${course.studentCount}</div>
                  </div>
                </div>
              </div>

              <div class="card">
                <div class="card-header">Description</div>
                <div class="card-body">
                  <p>${course.description}</p>
                </div>
              </div>
            </div>

            <div class="col-lg-4">
              <div class="card">
                <div class="card-header">Quick Actions</div>
                <div class="card-body">
                  <div class="d-grid gap-2">
                    <a
                      href="${pageContext.request.contextPath}/admin/courses/edit/${course.id}"
                      class="btn btn-primary"
                    >
                      <i class="bi bi-pencil-square"></i> Edit Course
                    </a>
                    <a
                      href="${pageContext.request.contextPath}/admin/courses/students/${course.id}"
                      class="btn btn-info"
                    >
                      <i class="bi bi-people-fill"></i> View Enrolled Students
                    </a>
                    <button
                      type="button"
                      class="btn btn-danger"
                      data-bs-toggle="modal"
                      data-bs-target="#deleteModal"
                    >
                      <i class="bi bi-trash"></i> Delete Course
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </main>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div
      class="modal fade"
      id="deleteModal"
      tabindex="-1"
      aria-labelledby="deleteModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="deleteModalLabel">Confirm Delete</h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <p>
              Are you sure you want to delete the course "${course.courseName}"?
            </p>
            <p class="text-danger">
              <strong>This action cannot be undone.</strong>
            </p>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
            >
              Cancel
            </button>
            <a
              href="${pageContext.request.contextPath}/admin/courses/delete/${course.id}"
              class="btn btn-danger"
              >Delete</a
            >
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
  </body>
</html>
