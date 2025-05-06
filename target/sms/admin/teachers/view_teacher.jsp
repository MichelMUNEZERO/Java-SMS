<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Teacher Details</title>
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
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
        <!-- Include sidebar -->
        <jsp:include page="../sidebar.jsp" />

        <!-- Main content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
          <div
            class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3"
          >
            <h1 class="h2">Teacher Details</h1>
            <div class="btn-toolbar mb-2 mb-md-0">
              <a
                href="${pageContext.request.contextPath}/admin/teachers"
                class="btn btn-sm btn-outline-secondary me-2"
              >
                <i class="bi bi-arrow-left"></i> Back to Teachers
              </a>
              <a
                href="${pageContext.request.contextPath}/admin/teachers/edit/${teacher.getId()}"
                class="btn btn-sm btn-primary"
              >
                <i class="bi bi-pencil"></i> Edit
              </a>
            </div>
          </div>

          <div class="row">
            <div class="col-lg-8">
              <div class="card">
                <div class="card-header">Personal Information</div>
                <div class="card-body">
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Full Name</div>
                    <div class="col-sm-8">
                      ${teacher.firstName} ${teacher.lastName}
                    </div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Email</div>
                    <div class="col-sm-8">${teacher.email}</div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Phone</div>
                    <div class="col-sm-8">${teacher.phone}</div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Address</div>
                    <div class="col-sm-8">${teacher.address}</div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Join Date</div>
                    <div class="col-sm-8">
                      <fmt:formatDate
                        value="${teacher.joinDate}"
                        pattern="dd-MM-yyyy"
                      />
                    </div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Status</div>
                    <div class="col-sm-8">
                      <span
                        class="badge ${teacher.status eq 'Active' ? 'bg-success' : 'bg-danger'}"
                        >${teacher.status}</span
                      >
                    </div>
                  </div>
                </div>
              </div>

              <div class="card">
                <div class="card-header">Professional Information</div>
                <div class="card-body">
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Qualification</div>
                    <div class="col-sm-8">${teacher.qualification}</div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Specialization</div>
                    <div class="col-sm-8">${teacher.specialization}</div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Experience (Years)</div>
                    <div class="col-sm-8">${teacher.experience}</div>
                  </div>
                </div>
              </div>
            </div>

            <div class="col-lg-4">
              <div class="card">
                <div class="card-header">Courses</div>
                <div class="card-body">
                  <c:if test="${not empty courseError}">
                    <div class="alert alert-warning" role="alert">
                      ${courseError}
                    </div>
                  </c:if>
                  <c:choose>
                    <c:when test="${not empty courses}">
                      <ul class="list-group list-group-flush">
                        <c:forEach items="${courses}" var="course">
                          <li
                            class="list-group-item d-flex justify-content-between align-items-center"
                          >
                            ${course.courseName}
                            <span class="badge bg-primary rounded-pill"
                              >${course.courseCode}</span
                            >
                          </li>
                        </c:forEach>
                      </ul>
                    </c:when>
                    <c:otherwise>
                      <p class="text-muted">No courses assigned</p>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>
            </div>
          </div>
        </main>
      </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
  </body>
</html>
