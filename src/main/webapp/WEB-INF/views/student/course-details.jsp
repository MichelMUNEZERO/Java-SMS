<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>${courseDetails.courseCode} - Course Details</title>

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
      .course-header {
        background-color: #f8f9fa;
        border-radius: 10px;
        padding: 20px;
        margin-bottom: 30px;
      }
      .stats-card {
        transition: transform 0.3s;
        border-radius: 10px;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
      }
      .stats-card:hover {
        transform: translateY(-5px);
      }
      .assignment-card {
        margin-bottom: 20px;
        border-radius: 10px;
        box-shadow: 0 0.25rem 0.5rem rgba(0, 0, 0, 0.1);
      }
    </style>
  </head>
  <body>
    <!-- Include the sidebar -->
    <jsp:include page="../includes/sidebar.jsp" />

    <!-- Main content -->
    <div class="main-content">
      <div class="container-fluid">
        <!-- Header -->
        <div class="row mb-4">
          <div class="col-12">
            <nav aria-label="breadcrumb">
              <ol class="breadcrumb">
                <li class="breadcrumb-item">
                  <a href="${pageContext.request.contextPath}/student/dashboard"
                    >Dashboard</a
                  >
                </li>
                <li class="breadcrumb-item">
                  <a href="${pageContext.request.contextPath}/student/courses"
                    >My Courses</a
                  >
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                  ${courseDetails.courseCode}
                </li>
              </ol>
            </nav>
          </div>
        </div>

        <!-- Course Header -->
        <div class="course-header">
          <div class="row align-items-center">
            <div class="col-md-8">
              <h2 class="mb-3">${courseDetails.courseName}</h2>
              <p class="text-muted mb-2">
                <i class="bi bi-code-square me-2"></i> Course Code:
                ${courseDetails.courseCode}
              </p>
              <p class="text-muted mb-2">
                <i class="bi bi-person me-2"></i> Instructor:
                ${courseDetails.teacherName}
              </p>
              <p class="text-muted mb-0">
                <i class="bi bi-book me-2"></i> ${courseDetails.credits} Credits
              </p>
            </div>
            <div class="col-md-4 text-md-end">
              <span class="badge bg-primary p-2 fs-6">
                <i class="bi bi-star me-1"></i>
                Grade: ${marks.grade != null ? marks.grade : 'Not graded yet'}
              </span>
            </div>
          </div>
        </div>

        <!-- Course Stats -->
        <div class="row mb-4">
          <div class="col-md-3">
            <div class="card stats-card bg-primary text-white">
              <div class="card-body">
                <h6 class="card-title">Midterm</h6>
                <h3 class="card-text mb-0">
                  ${marks.midterm != null ? marks.midterm : 'N/A'}
                </h3>
              </div>
            </div>
          </div>
          <div class="col-md-3">
            <div class="card stats-card bg-success text-white">
              <div class="card-body">
                <h6 class="card-title">Final</h6>
                <h3 class="card-text mb-0">
                  ${marks.final != null ? marks.final : 'N/A'}
                </h3>
              </div>
            </div>
          </div>
          <div class="col-md-3">
            <div class="card stats-card bg-info text-white">
              <div class="card-body">
                <h6 class="card-title">Assignments</h6>
                <h3 class="card-text mb-0">
                  ${marks.assignments != null ? marks.assignments : 'N/A'}
                </h3>
              </div>
            </div>
          </div>
          <div class="col-md-3">
            <div class="card stats-card bg-warning text-white">
              <div class="card-body">
                <h6 class="card-title">Total</h6>
                <h3 class="card-text mb-0">
                  ${marks.total != null ? marks.total : 'N/A'}
                </h3>
              </div>
            </div>
          </div>
        </div>

        <!-- Course Description -->
        <div class="row mb-4">
          <div class="col-12">
            <div class="card">
              <div class="card-header">
                <h5 class="card-title mb-0">Course Description</h5>
              </div>
              <div class="card-body">
                <p class="card-text">${courseDetails.description}</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Assignments -->
        <div class="row mb-4">
          <div class="col-12">
            <div class="card">
              <div
                class="card-header d-flex justify-content-between align-items-center"
              >
                <h5 class="card-title mb-0">Assignments</h5>
                <span class="badge bg-primary"
                  >${assignments.size()} Total</span
                >
              </div>
              <div class="card-body">
                <c:choose>
                  <c:when test="${empty assignments}">
                    <div class="alert alert-info mb-0">
                      <i class="bi bi-info-circle me-2"></i>
                      No assignments have been posted yet.
                    </div>
                  </c:when>
                  <c:otherwise>
                    <div class="row">
                      <c:forEach items="${assignments}" var="assignment">
                        <div class="col-md-6">
                          <div class="card assignment-card">
                            <div class="card-body">
                              <h5 class="card-title">${assignment.title}</h5>
                              <p class="card-text">${assignment.description}</p>
                              <div
                                class="d-flex justify-content-between align-items-center"
                              >
                                <small class="text-muted">
                                  Due:
                                  <fmt:formatDate
                                    value="${assignment.dueDate}"
                                    pattern="MMM dd, yyyy"
                                  />
                                </small>
                                <span class="badge bg-info">
                                  Max Score: ${assignment.maxScore}
                                </span>
                              </div>
                            </div>
                          </div>
                        </div>
                      </c:forEach>
                    </div>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
