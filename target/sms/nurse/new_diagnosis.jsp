<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>New Diagnosis - School Management System</title>

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

    <!-- Select2 CSS -->
    <link
      href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css"
      rel="stylesheet"
    />
    <link
      href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css"
      rel="stylesheet"
    />

    <style>
      body {
        font-family: "Poppins", sans-serif;
        background-color: #f8f9fc;
      }

      .content-card {
        transition: transform 0.3s;
        border-radius: 0.75rem;
        border: none;
        box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        margin-bottom: 1.5rem;
      }

      .card-header {
        background-color: white;
        border-bottom: 1px solid #e9ecef;
        padding: 1rem 1.5rem;
        font-weight: 500;
      }

      .breadcrumb {
        background-color: transparent;
        padding: 0;
      }

      .breadcrumb-item a {
        color: #4e73df;
        text-decoration: none;
      }

      .page-title {
        font-weight: 600;
        color: #5a5c69;
        margin-bottom: 1rem;
      }

      .btn-primary {
        background-color: #4e73df;
        border-color: #4e73df;
      }

      .btn-primary:hover {
        background-color: #4262c5;
        border-color: #3d5cb8;
      }

      .form-label {
        font-weight: 500;
      }

      .required::after {
        content: " *";
        color: red;
      }
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
        <!-- Sidebar - same as nurse_dashboard.jsp -->
        <nav
          id="sidebar"
          class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse"
        >
          <div class="position-sticky pt-3">
            <div
              class="d-flex align-items-center pb-3 mb-3 border-bottom border-secondary"
            >
              <a
                href="${pageContext.request.contextPath}/dashboard"
                class="d-flex align-items-center text-white text-decoration-none"
              >
                <i class="bi bi-hospital fs-4 me-2"></i>
                <span class="fs-5 fw-semibold">School MS</span>
              </a>
            </div>

            <ul class="nav flex-column">
              <li class="nav-item">
                <a
                  class="nav-link text-white d-flex align-items-center py-2"
                  href="${pageContext.request.contextPath}/nurse/dashboard"
                >
                  <i class="bi bi-speedometer2 me-2"></i>
                  Dashboard
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white d-flex align-items-center py-2"
                  href="${pageContext.request.contextPath}/nurse/diagnosed-students"
                >
                  <i class="bi bi-clipboard-pulse me-2"></i>
                  Diagnosed Students
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white d-flex align-items-center py-2"
                  href="${pageContext.request.contextPath}/nurse/students"
                >
                  <i class="bi bi-person-vcard me-2"></i>
                  Student Health Records
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white d-flex align-items-center py-2"
                  href="${pageContext.request.contextPath}/nurse/appointments"
                >
                  <i class="bi bi-calendar-check me-2"></i>
                  Appointments
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link active text-white d-flex align-items-center py-2"
                  href="${pageContext.request.contextPath}/nurse/new-diagnosis"
                >
                  <i class="bi bi-journal-medical me-2"></i>
                  New Diagnosis
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white d-flex align-items-center py-2"
                  href="${pageContext.request.contextPath}/nurse/profile"
                >
                  <i class="bi bi-person-circle me-2"></i>
                  My Profile
                </a>
              </li>
              <li class="nav-item mt-3">
                <a
                  class="nav-link text-white d-flex align-items-center py-2"
                  href="${pageContext.request.contextPath}/logout"
                >
                  <i class="bi bi-box-arrow-right me-2"></i>
                  Logout
                </a>
              </li>
            </ul>
          </div>
        </nav>

        <!-- Main Content -->
        <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
          <!-- Breadcrumb -->
          <nav aria-label="breadcrumb" class="mt-3">
            <ol class="breadcrumb">
              <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/dashboard">Home</a>
              </li>
              <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/nurse/dashboard"
                  >Nurse Dashboard</a
                >
              </li>
              <li class="breadcrumb-item active" aria-current="page">
                New Diagnosis
              </li>
            </ol>
          </nav>

          <!-- Page Header -->
          <div
            class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-2 mb-4 border-bottom"
          >
            <h1 class="page-title h2">New Student Diagnosis</h1>
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

          <!-- Diagnosis Form -->
          <div class="card content-card">
            <div class="card-header">
              <i class="bi bi-journal-medical me-1"></i> Enter New Diagnosis
              Details
            </div>
            <div class="card-body">
              <form
                action="${pageContext.request.contextPath}/nurse/new-diagnosis"
                method="post"
                id="diagnosisForm"
              >
                <!-- Hidden fields -->
                <input type="hidden" name="nurseId" value="${user.userId}" />

                <!-- Student and Date Section -->
                <div class="row mb-3">
                  <div class="col-md-6">
                    <label for="studentId" class="form-label required"
                      >Student</label
                    >
                    <select
                      class="form-select select2"
                      id="studentId"
                      name="studentId"
                      required
                    >
                      <option value="">Select Student</option>
                      <c:forEach items="${students}" var="student">
                        <option value="${student.id}">
                          ${student.firstName} ${student.lastName}
                        </option>
                      </c:forEach>
                    </select>
                  </div>
                  <div class="col-md-6">
                    <label for="recordDate" class="form-label required"
                      >Date of Diagnosis</label
                    >
                    <input
                      type="date"
                      class="form-control"
                      id="recordDate"
                      name="recordDate"
                      value="<fmt:formatDate value='${today}' pattern='yyyy-MM-dd' />"
                      required
                    />
                  </div>
                </div>

                <!-- Diagnosis Section -->
                <div class="mb-3">
                  <label for="description" class="form-label required"
                    >Diagnosis Description</label
                  >
                  <textarea
                    class="form-control"
                    id="description"
                    name="description"
                    rows="3"
                    required
                  ></textarea>
                </div>

                <!-- Treatment Section -->
                <div class="row mb-3">
                  <div class="col-md-6">
                    <label for="treatment" class="form-label"
                      >Recommended Treatment</label
                    >
                    <textarea
                      class="form-control"
                      id="treatment"
                      name="treatment"
                      rows="3"
                    ></textarea>
                  </div>
                  <div class="col-md-6">
                    <label for="medication" class="form-label"
                      >Medication</label
                    >
                    <textarea
                      class="form-control"
                      id="medication"
                      name="medication"
                      rows="3"
                    ></textarea>
                  </div>
                </div>

                <!-- Doctor Assignment Section -->
                <div class="mb-3">
                  <label for="doctorId" class="form-label"
                    >Assign to Doctor</label
                  >
                  <select
                    class="form-select select2"
                    id="doctorId"
                    name="doctorId"
                  >
                    <option value="">Select Doctor (Optional)</option>
                    <c:forEach items="${doctors}" var="doctor">
                      <option value="${doctor.doctorId}">
                        ${doctor.firstName} ${doctor.lastName} -
                        ${doctor.specialization}
                      </option>
                    </c:forEach>
                  </select>
                </div>

                <!-- Notes Section -->
                <div class="mb-4">
                  <label for="notes" class="form-label">Additional Notes</label>
                  <textarea
                    class="form-control"
                    id="notes"
                    name="notes"
                    rows="3"
                  ></textarea>
                </div>

                <!-- Form Buttons -->
                <div class="d-flex justify-content-end">
                  <button
                    type="button"
                    class="btn btn-secondary me-2"
                    onclick="window.history.back();"
                  >
                    <i class="bi bi-x-circle me-1"></i> Cancel
                  </button>
                  <button type="submit" class="btn btn-primary">
                    <i class="bi bi-save me-1"></i> Save Diagnosis
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- JavaScript Dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

    <!-- Initialize Select2 -->
    <script>
      $(document).ready(function () {
        $(".select2").select2({
          theme: "bootstrap-5",
          dropdownParent: $("#diagnosisForm"),
        });

        // Set today as default date if not set
        if (!$("#recordDate").val()) {
          const today = new Date();
          const formattedDate = today.toISOString().substr(0, 10);
          $("#recordDate").val(formattedDate);
        }
      });
    </script>
  </body>
</html>
