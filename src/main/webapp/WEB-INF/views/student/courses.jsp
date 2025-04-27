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
    <!-- Custom CSS -->
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />
    <style>
      .course-card {
        transition: transform 0.3s;
        border-radius: 10px;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        height: 100%;
      }
      .course-card:hover {
        transform: translateY(-5px);
      }
      .card-icon {
        font-size: 2.5rem;
        margin-bottom: 0.5rem;
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
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/student/dashboard"
                >
                  <i class="bi bi-speedometer2 me-2"></i> Dashboard
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link active text-white"
                  href="${pageContext.request.contextPath}/student/courses"
                >
                  <i class="bi bi-book me-2"></i> My Courses
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="#">
                  <i class="bi bi-card-checklist me-2"></i> Grades
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="#">
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
            <h1 class="h2">My Courses</h1>
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

          <!-- Course List -->
          <div class="row">
            <c:choose>
              <c:when test="${empty courses}">
                <div class="col-12">
                  <div class="alert alert-info" role="alert">
                    <i class="bi bi-info-circle me-2"></i> You are not enrolled
                    in any courses yet.
                  </div>
                </div>
              </c:when>
              <c:otherwise>
                <c:forEach var="course" items="${courses}">
                  <div class="col-md-4 mb-4">
                    <div class="card course-card h-100">
                      <div class="card-body">
                        <div class="text-center mb-3">
                          <i class="bi bi-book-half card-icon text-primary"></i>
                          <h5 class="card-title">${course.courseCode}</h5>
                          <div class="badge bg-primary mb-2">
                            ${course.credits} Credits
                          </div>
                        </div>
                        <h6 class="card-subtitle mb-2 text-muted">
                          ${course.courseName}
                        </h6>
                        <p class="card-text">${course.description}</p>
                      </div>
                      <div class="card-footer bg-white border-top-0">
                        <div class="d-grid gap-2">
                          <a
                            href="${pageContext.request.contextPath}/student/course-details?id=${course.id}"
                            class="btn btn-outline-primary"
                          >
                            <i class="bi bi-eye me-1"></i> View Details
                          </a>
                        </div>
                      </div>
                    </div>
                  </div>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </div>

          <!-- Course Information Section -->
          <div class="row mt-4 mb-4">
            <div class="col-md-12">
              <div class="card">
                <div class="card-header bg-info text-white">
                  <h5 class="card-title mb-0">
                    <i class="bi bi-info-circle me-2"></i> Course Information
                  </h5>
                </div>
                <div class="card-body">
                  <p>
                    As a student, you can access detailed information about each
                    of your enrolled courses. Each course may include:
                  </p>
                  <ul>
                    <li>Course materials and resources</li>
                    <li>Assignments and due dates</li>
                    <li>Quizzes and exams</li>
                    <li>Grades and feedback</li>
                    <li>Discussion forums</li>
                  </ul>
                  <p class="mb-0">
                    Click on "View Details" for any course to access these
                    resources.
                  </p>
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
