<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Student Details</title>
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
        <jsp:include page="sidebar.jsp" />

        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
          <div
            class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3"
          >
            <h1 class="h2">Student Details</h1>
            <div class="btn-toolbar mb-2 mb-md-0">
              <a
                href="${pageContext.request.contextPath}/admin/students"
                class="btn btn-sm btn-outline-secondary me-2"
              >
                <i class="bi bi-arrow-left"></i> Back to Students
              </a>
              <a
                href="${pageContext.request.contextPath}/admin/students/edit/${student.getId()}"
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
                      ${student.firstName} ${student.lastName}
                    </div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Gender</div>
                    <div class="col-sm-8">${student.gender}</div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Date of Birth</div>
                    <div class="col-sm-8">
                      <fmt:formatDate
                        value="${student.dateOfBirth}"
                        pattern="dd-MM-yyyy"
                      />
                    </div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Email</div>
                    <div class="col-sm-8">${student.email}</div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Phone</div>
                    <div class="col-sm-8">${student.phone}</div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Address</div>
                    <div class="col-sm-8">${student.address}</div>
                  </div>
                </div>
              </div>

              <div class="card">
                <div class="card-header">Academic Information</div>
                <div class="card-body">
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Admission Date</div>
                    <div class="col-sm-8">
                      <fmt:formatDate
                        value="${student.admissionDate}"
                        pattern="dd-MM-yyyy"
                      />
                    </div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Class ID</div>
                    <div class="col-sm-8">${student.classId}</div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Status</div>
                    <div class="col-sm-8">${student.status}</div>
                  </div>
                </div>
              </div>
            </div>

            <div class="col-lg-4">
              <div class="card">
                <div class="card-header">Guardian Information</div>
                <div class="card-body">
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Name</div>
                    <div class="col-sm-8">${student.guardianName}</div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Phone</div>
                    <div class="col-sm-8">${student.guardianPhone}</div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-sm-4 fw-semibold">Email</div>
                    <div class="col-sm-8">${student.guardianEmail}</div>
                  </div>
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
