<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Student Details - School Management System</title>
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
      .card {
        border-radius: 10px;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        margin-bottom: 20px;
      }
      .profile-header {
        background-color: #f8f9fa;
        padding: 20px;
        border-radius: 10px 10px 0 0;
      }
      .profile-img {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        object-fit: cover;
        border: 5px solid #fff;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
      }
      .profile-placeholder {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        background-color: #6c757d;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 3rem;
        color: white;
        border: 5px solid #fff;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
      }
      .info-label {
        font-weight: bold;
        color: #6c757d;
      }
      .badge-section {
        margin-bottom: 10px;
      }
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
        <!-- Include the sidebar -->
        <jsp:include page="../includes/sidebar.jsp" />

        <!-- Main content -->
        <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
          <!-- Header -->
          <div
            class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom"
          >
            <h1 class="h2">Student Details</h1>
            <div class="btn-toolbar mb-2 mb-md-0">
              <a
                href="${pageContext.request.contextPath}/teacher/student"
                class="btn btn-outline-secondary me-2"
              >
                <i class="bi bi-arrow-left me-1"></i> Back to Students
              </a>
              <a
                href="${pageContext.request.contextPath}/teacher/student/edit?id=${student.id}"
                class="btn btn-warning me-2"
              >
                <i class="bi bi-pencil me-1"></i> Edit Student
              </a>
              <a
                href="${pageContext.request.contextPath}/teacher/marks?studentId=${student.id}"
                class="btn btn-info me-2"
              >
                <i class="bi bi-award me-1"></i> Manage Marks
              </a>
              <a
                href="${pageContext.request.contextPath}/teacher/behavior?studentId=${student.id}"
                class="btn btn-secondary"
              >
                <i class="bi bi-clipboard-check me-1"></i> Behavior Notes
              </a>
            </div>
          </div>

          <!-- Error/Success Messages -->
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

          <c:if test="${empty student}">
            <div class="alert alert-danger">
              <strong>Error:</strong> Student data is not available.
            </div>
          </c:if>

          <c:if test="${not empty student}">
            <div class="row">
              <div class="col-md-4">
                <!-- Student Profile Card -->
                <div class="card">
                  <div
                    class="profile-header d-flex align-items-center justify-content-center flex-column"
                  >
                    <div class="profile-placeholder mb-3">
                      <i class="bi bi-person-fill"></i>
                    </div>
                    <h3 class="mb-0">
                      ${student.firstName} ${student.lastName}
                    </h3>
                    <p class="text-muted">Student ID: ${student.id}</p>
                    <div class="badge-section">
                      <span
                        class="badge bg-${student.status eq 'active' ? 'success' : 'warning'}"
                      >
                        ${student.status != null ? student.status : 'Unknown'}
                      </span>
                      <c:if test="${not empty student.className}">
                        <span class="badge bg-primary"
                          >Grade ${student.className}</span
                        >
                      </c:if>
                    </div>
                  </div>
                  <div class="card-body">
                    <h5 class="border-bottom pb-2">Contact Information</h5>
                    <p><strong>Email:</strong> ${student.email}</p>
                    <p>
                      <strong>Phone:</strong> ${student.phone != null ?
                      student.phone : 'Not provided'}
                    </p>
                    <p>
                      <strong>Address:</strong> ${student.address != null ?
                      student.address : 'Not provided'}
                    </p>

                    <h5 class="border-bottom pb-2 mt-4">
                      Academic Information
                    </h5>
                    <p>
                      <strong>Registration Number:</strong> ${student.regNumber
                      != null ? student.regNumber : 'Not provided'}
                    </p>
                    <p>
                      <strong>Admission Date:</strong>
                      <c:if test="${not empty student.admissionDate}">
                        <fmt:formatDate
                          value="${student.admissionDate}"
                          pattern="MMM dd, yyyy"
                        />
                      </c:if>
                    </p>
                    <p>
                      <strong>Date of Birth:</strong>
                      <c:if test="${not empty student.dateOfBirth}">
                        <fmt:formatDate
                          value="${student.dateOfBirth}"
                          pattern="MMM dd, yyyy"
                        />
                      </c:if>
                    </p>

                    <h5 class="border-bottom pb-2 mt-4">
                      Parent/Guardian Information
                    </h5>
                    <p>
                      <strong>Name:</strong> ${student.parentName != null ?
                      student.parentName : 'Not provided'}
                    </p>
                    <p>
                      <strong>Email:</strong> ${student.guardianEmail != null ?
                      student.guardianEmail : 'Not provided'}
                    </p>
                    <p>
                      <strong>Phone:</strong> ${student.guardianPhone != null ?
                      student.guardianPhone : 'Not provided'}
                    </p>
                  </div>
                </div>
              </div>

              <div class="col-md-8">
                <!-- Enrolled Courses -->
                <div class="card">
                  <div
                    class="card-header d-flex justify-content-between align-items-center"
                  >
                    <h5 class="card-title mb-0">Enrolled Courses</h5>
                    <a
                      href="${pageContext.request.contextPath}/teacher/student/enroll?id=${student.id}"
                      class="btn btn-primary btn-sm"
                    >
                      <i class="bi bi-plus-circle me-1"></i> Enroll in Course
                    </a>
                  </div>
                  <div class="card-body">
                    <div class="table-responsive">
                      <table class="table table-striped">
                        <thead>
                          <tr>
                            <th>Course Code</th>
                            <th>Course Name</th>
                            <th>Credits</th>
                            <th>Teacher</th>
                            <th>Actions</th>
                          </tr>
                        </thead>
                        <tbody>
                          <c:choose>
                            <c:when test="${not empty enrolledCourses}">
                              <c:forEach
                                items="${enrolledCourses}"
                                var="course"
                              >
                                <tr>
                                  <td>${course.courseCode}</td>
                                  <td>${course.courseName}</td>
                                  <td>${course.credits}</td>
                                  <td>${course.teacherName}</td>
                                  <td>
                                    <div class="btn-group">
                                      <a
                                        href="${pageContext.request.contextPath}/teacher/course-details?id=${course.id}"
                                        class="btn btn-sm btn-info"
                                      >
                                        <i class="bi bi-eye"></i>
                                      </a>
                                      <a
                                        href="${pageContext.request.contextPath}/teacher/course-marks?id=${course.id}&studentId=${student.id}"
                                        class="btn btn-sm btn-warning"
                                      >
                                        <i class="bi bi-award"></i>
                                      </a>
                                    </div>
                                  </td>
                                </tr>
                              </c:forEach>
                            </c:when>
                            <c:otherwise>
                              <tr>
                                <td colspan="5" class="text-center">
                                  Not enrolled in any courses
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
          </c:if>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
