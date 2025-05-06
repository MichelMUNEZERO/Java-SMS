<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Courses - School Management System</title>
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
      .course-card {
        height: 100%;
        transition: all 0.3s ease;
        border: none;
        border-radius: var(--border-radius);
        box-shadow: var(--card-shadow);
        overflow: hidden;
      }

      .course-card:hover {
        transform: translateY(-5px);
        box-shadow: var(--hover-shadow);
      }

      .course-card .card-body {
        padding: 1.5rem;
      }

      .course-card .card-footer {
        background-color: transparent;
        border-top: 1px solid rgba(0, 0, 0, 0.05);
        padding: 1rem 1.5rem;
      }

      .course-card .card-title {
        color: #2c3e50;
        font-weight: 600;
        margin-bottom: 0.5rem;
      }

      .course-card .card-subtitle {
        font-size: 0.9rem;
        margin-bottom: 1rem;
      }

      .course-card .card-text {
        color: #5a6268;
        margin-bottom: 1.25rem;
        font-size: 0.95rem;
      }

      .badge-credits {
        background-color: var(--primary-color);
        color: white;
        padding: 0.5em 0.8em;
        border-radius: 6px;
        font-weight: 500;
      }

      .badge-teacher {
        background-color: var(--info-color);
        color: white;
        padding: 0.5em 0.8em;
        border-radius: 6px;
        font-weight: 500;
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
          <div
            class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center"
          >
            <h1 class="page-title">Courses Management</h1>
          </div>

          <!-- Alerts for success or error messages -->
          <c:if test="${param.success != null}">
            <div
              class="alert alert-success alert-dismissible fade show"
              role="alert"
            >
              <i class="bi bi-check-circle-fill me-2"></i>
              <c:choose>
                <c:when test="${param.success == 'added'}">
                  Course added successfully!
                </c:when>
                <c:when test="${param.success == 'updated'}">
                  Course updated successfully!
                </c:when>
                <c:when test="${param.success == 'deleted'}">
                  Course deleted successfully!
                </c:when>
                <c:otherwise> Operation completed successfully! </c:otherwise>
              </c:choose>
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
                aria-label="Close"
              ></button>
            </div>
          </c:if>

          <c:if test="${param.error != null}">
            <div
              class="alert alert-danger alert-dismissible fade show"
              role="alert"
            >
              <i class="bi bi-exclamation-triangle-fill me-2"></i>
              <c:choose>
                <c:when test="${param.error == 'add_failed'}">
                  Failed to add course. Please try again.
                </c:when>
                <c:when test="${param.error == 'update_failed'}">
                  Failed to update course. Please try again.
                </c:when>
                <c:when test="${param.error == 'delete_failed'}">
                  Failed to delete course. Please try again.
                </c:when>
                <c:when test="${param.error == 'not_found'}">
                  Course not found.
                </c:when>
                <c:when test="${param.error == 'invalid_id'}">
                  Invalid course ID.
                </c:when>
                <c:when test="${param.error == 'no_id'}">
                  No course ID provided.
                </c:when>
                <c:otherwise>
                  An error occurred. Please try again.
                </c:otherwise>
              </c:choose>
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
                aria-label="Close"
              ></button>
            </div>
          </c:if>

          <!-- Courses list in grid view -->
          <div class="row g-4">
            <c:choose>
              <c:when test="${empty courses}">
                <div class="col-12">
                  <div class="alert alert-info" role="alert">
                    <i class="bi bi-info-circle me-2"></i> No courses found.
                  </div>
                </div>
              </c:when>
              <c:otherwise>
                <c:forEach var="course" items="${courses}">
                  <div class="col-md-6 col-lg-4">
                    <div class="card course-card">
                      <div class="card-body">
                        <div class="d-flex align-items-center mb-3">
                          <div class="me-3">
                            <i
                              class="bi bi-journal-bookmark fs-3 text-primary"
                            ></i>
                          </div>
                          <div>
                            <h5 class="card-title mb-0">
                              ${course.courseName}
                            </h5>
                            <h6 class="card-subtitle text-muted">
                              Code: ${course.courseCode}
                            </h6>
                          </div>
                        </div>
                        <p class="card-text">${course.description}</p>
                        <div
                          class="d-flex justify-content-between align-items-center"
                        >
                          <span class="badge badge-credits">
                            <i class="bi bi-star me-1"></i> ${course.credits}
                            Credits
                          </span>
                          <c:if test="${course.teacherId > 0}">
                            <span class="badge badge-teacher">
                              <i class="bi bi-person-badge me-1"></i> Teacher
                              ID: ${course.teacherId}
                            </span>
                          </c:if>
                        </div>
                      </div>
                      <div class="card-footer">
                        <div class="d-flex justify-content-end">
                          <a
                            href="${pageContext.request.contextPath}/admin/courses/view/${course.id}"
                            class="btn btn-sm btn-outline-primary action-btn"
                          >
                            <i class="bi bi-eye"></i>
                          </a>
                          <a
                            href="${pageContext.request.contextPath}/admin/courses/edit/${course.id}"
                            class="btn btn-sm btn-outline-secondary action-btn"
                          >
                            <i class="bi bi-pencil"></i>
                          </a>
                          <button
                            type="button"
                            class="btn btn-sm btn-outline-danger action-btn"
                            data-bs-toggle="modal"
                            data-bs-target="#deleteModal${course.id}"
                          >
                            <i class="bi bi-trash"></i>
                          </button>
                        </div>
                      </div>
                    </div>

                    <!-- Delete Confirmation Modal -->
                    <div
                      class="modal fade"
                      id="deleteModal${course.id}"
                      tabindex="-1"
                      aria-hidden="true"
                    >
                      <div class="modal-dialog">
                        <div class="modal-content">
                          <div class="modal-header">
                            <h5 class="modal-title">Confirm Deletion</h5>
                            <button
                              type="button"
                              class="btn-close"
                              data-bs-dismiss="modal"
                              aria-label="Close"
                            ></button>
                          </div>
                          <div class="modal-body">
                            <p>
                              Are you sure you want to delete course
                              <strong>${course.courseName}</strong>?
                            </p>
                            <p class="text-danger">
                              This action cannot be undone and may affect
                              related records.
                            </p>
                          </div>
                          <div class="modal-footer">
                            <button
                              type="button"
                              class="btn btn-outline-secondary"
                              data-bs-dismiss="modal"
                            >
                              Cancel
                            </button>
                            <a
                              href="${pageContext.request.contextPath}/admin/courses/delete/${course.id}"
                              class="btn btn-danger"
                            >
                              <i class="bi bi-trash me-1"></i> Delete
                            </a>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
