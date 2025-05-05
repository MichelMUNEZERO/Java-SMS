<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Nurses - School Management System</title>
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
      .card {
        border-radius: 10px;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
      }
      .action-btn {
        width: 32px;
        height: 32px;
        padding: 0;
        line-height: 32px;
        text-align: center;
      }
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
        <!-- Include Sidebar -->
        <jsp:include page="/WEB-INF/includes/admin-sidebar.jsp" />

        <!-- Main Content -->
        <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
          <div
            class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center"
          >
            <h1 class="page-title">Manage Nurses</h1>
            <div class="btn-toolbar">
              <a
                href="${pageContext.request.contextPath}/admin/nurses/new"
                class="btn btn-primary"
              >
                <i class="bi bi-plus-circle me-1"></i> Add New Nurse
              </a>
            </div>
          </div>

          <!-- Alerts for success or error messages -->
          <c:if test="${param.success != null}">
            <div
              class="alert alert-success alert-dismissible fade show"
              role="alert"
            >
              <i class="bi bi-check-circle-fill me-2"></i> ${param.success}
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
              ></button>
            </div>
          </c:if>

          <c:if test="${param.error != null}">
            <div
              class="alert alert-danger alert-dismissible fade show"
              role="alert"
            >
              <i class="bi bi-exclamation-triangle-fill me-2"></i>
              ${param.error}
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
              ></button>
            </div>
          </c:if>

          <!-- Nurse Management Section -->
          <div class="content-card">
            <div
              class="card-header d-flex justify-content-between align-items-center"
            >
              <h5 class="mb-0">Nurse List</h5>
            </div>
            <div class="card-body">
              <div class="table-container">
                <table class="table table-striped data-table" id="nurseTable">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Name</th>
                      <th>Email</th>
                      <th>Phone</th>
                      <th>Qualification</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="nurse" items="${nurses}">
                      <tr>
                        <td>${nurse.nurseId}</td>
                        <td>
                          <div class="d-flex align-items-center">
                            <div
                              class="avatar-circle me-2 d-flex align-items-center justify-content-center bg-light"
                              style="
                                width: 35px;
                                height: 35px;
                                border-radius: 50%;
                              "
                            >
                              <i class="bi bi-bandaid text-secondary"></i>
                            </div>
                            <div>
                              <span class="fw-medium"
                                >${nurse.firstName} ${nurse.lastName}</span
                              >
                            </div>
                          </div>
                        </td>
                        <td>${nurse.email}</td>
                        <td>${nurse.phone}</td>
                        <td>${nurse.qualification}</td>
                        <td>
                          <div class="d-flex">
                            <a
                              href="${pageContext.request.contextPath}/admin/nurses/view/${nurse.nurseId}"
                              class="btn btn-sm btn-outline-primary action-btn"
                              title="View"
                            >
                              <i class="bi bi-eye"></i>
                            </a>
                            <a
                              href="${pageContext.request.contextPath}/admin/nurses/edit/${nurse.nurseId}"
                              class="btn btn-sm btn-outline-secondary action-btn"
                              title="Edit"
                            >
                              <i class="bi bi-pencil"></i>
                            </a>
                            <button
                              type="button"
                              class="btn btn-sm btn-outline-danger action-btn"
                              data-bs-toggle="modal"
                              data-bs-target="#deleteModal${nurse.nurseId}"
                              title="Delete"
                            >
                              <i class="bi bi-trash"></i>
                            </button>
                          </div>

                          <!-- Delete Confirmation Modal -->
                          <div
                            class="modal fade"
                            id="deleteModal${nurse.nurseId}"
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
                                    Are you sure you want to delete nurse
                                    <strong
                                      >${nurse.firstName}
                                      ${nurse.lastName}</strong
                                    >?
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
                                    href="${pageContext.request.contextPath}/admin/nurses/delete/${nurse.nurseId}"
                                    class="btn btn-danger"
                                  >
                                    <i class="bi bi-trash me-1"></i> Delete
                                  </a>
                                </div>
                              </div>
                            </div>
                          </div>
                        </td>
                      </tr>
                    </c:forEach>

                    <c:if test="${empty nurses}">
                      <tr>
                        <td colspan="6" class="text-center">No nurses found</td>
                      </tr>
                    </c:if>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
    <script>
      $(document).ready(function () {
        $("#nurseTable").DataTable({
          pageLength: 10,
          language: {
            search: "Search nurses:",
            lengthMenu: "Show _MENU_ nurses per page",
            info: "Showing _START_ to _END_ of _TOTAL_ nurses",
          },
        });

        // Initialize tooltips
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

      .sidebar {
        background-color: #343a40;
        min-height: 100vh;
      }

      .sidebar-link {
        color: white;
        text-decoration: none;
      }

      .table-container {
        background-color: white;
        border-radius: 10px;
        padding: 20px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      }

      .action-buttons a {
        margin-right: 5px;
      }
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
        <!-- Sidebar -->
        <div class="col-lg-2 col-md-3 p-0 sidebar">
          <div class="d-flex flex-column p-3">
            <h3 class="text-white mb-4">
              <i class="bi bi-book"></i> School MS
            </h3>
            <ul class="nav flex-column mb-auto">
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/admin/dashboard"
                >
                  <i class="bi bi-speedometer2 me-2"></i> Dashboard
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/admin/students"
                >
                  <i class="bi bi-mortarboard me-2"></i> Students
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/admin/teachers"
                >
                  <i class="bi bi-person-workspace me-2"></i> Teachers
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/admin/parents"
                >
                  <i class="bi bi-people me-2"></i> Parents
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/admin/courses"
                >
                  <i class="bi bi-book me-2"></i> Courses
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/admin/doctors"
                >
                  <i class="bi bi-heart-pulse me-2"></i> Doctors
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link active text-white"
                  href="${pageContext.request.contextPath}/admin/nurses"
                >
                  <i class="bi bi-bandaid me-2"></i> Nurses
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/admin/announcements"
                >
                  <i class="bi bi-megaphone me-2"></i> Announcements
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/admin/settings"
                >
                  <i class="bi bi-gear me-2"></i> Settings
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

        <!-- Main Content -->
        <div class="col-lg-10 col-md-9 p-4">
          <!-- Top Navigation -->
          <header
            class="d-flex justify-content-between align-items-center mb-4"
          >
            <h2 class="h3">Manage Nurses</h2>
            <div class="dropdown">
              <a
                class="btn btn-outline-secondary dropdown-toggle"
                href="#"
                role="button"
                data-bs-toggle="dropdown"
              >
                <i class="bi bi-person-circle me-1"></i>
                Admin
              </a>
              <ul class="dropdown-menu dropdown-menu-end">
                <li>
                  <a
                    class="dropdown-item"
                    href="${pageContext.request.contextPath}/admin/profile"
                  >
                    <i class="bi bi-person me-2"></i>Profile
                  </a>
                </li>
                <li><hr class="dropdown-divider" /></li>
                <li>
                  <a
                    class="dropdown-item"
                    href="${pageContext.request.contextPath}/logout"
                  >
                    <i class="bi bi-box-arrow-right me-2"></i>Logout
                  </a>
                </li>
              </ul>
            </div>
          </header>

          <!-- Alerts for success or error messages -->
          <c:if test="${param.success != null}">
            <div
              class="alert alert-success alert-dismissible fade show"
              role="alert"
            >
              <i class="bi bi-check-circle me-2"></i> Operation completed
              successfully!
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
              ></button>
            </div>
          </c:if>

          <c:if test="${param.error != null}">
            <div
              class="alert alert-danger alert-dismissible fade show"
              role="alert"
            >
              <i class="bi bi-exclamation-triangle me-2"></i> ${param.error}
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
              ></button>
            </div>
          </c:if>

          <!-- Nurse Management Section -->
          <div class="row mb-4">
            <div class="col-md-12">
              <div class="card table-container">
                <div
                  class="card-header bg-white d-flex justify-content-between align-items-center"
                >
                  <h5 class="mb-0">Nurse List</h5>
                  <a
                    href="${pageContext.request.contextPath}/admin/nurses/new"
                    class="btn btn-primary"
                  >
                    <i class="bi bi-plus-circle me-1"></i> Add New Nurse
                  </a>
                </div>
                <div class="card-body">
                  <div class="table-responsive">
                    <table class="table table-striped table-hover">
                      <thead>
                        <tr>
                          <th>ID</th>
                          <th>Name</th>
                          <th>Email</th>
                          <th>Phone</th>
                          <th>Qualification</th>
                          <th>Actions</th>
                        </tr>
                      </thead>
                      <tbody>
                        <c:forEach var="nurse" items="${nurses}">
                          <tr>
                            <td>${nurse.nurseId}</td>
                            <td>${nurse.firstName} ${nurse.lastName}</td>
                            <td>${nurse.email}</td>
                            <td>${nurse.phone}</td>
                            <td>${nurse.qualification}</td>
                            <td class="action-buttons">
                              <a
                                href="${pageContext.request.contextPath}/admin/nurses/view/${nurse.nurseId}"
                                class="btn btn-sm btn-info"
                              >
                                <i class="bi bi-eye"></i>
                              </a>
                              <a
                                href="${pageContext.request.contextPath}/admin/nurses/edit/${nurse.nurseId}"
                                class="btn btn-sm btn-warning"
                              >
                                <i class="bi bi-pencil"></i>
                              </a>
                              <button
                                type="button"
                                onclick="confirmDelete(${nurse.nurseId})"
                                class="btn btn-sm btn-danger"
                              >
                                <i class="bi bi-trash"></i>
                              </button>
                            </td>
                          </tr>
                        </c:forEach>

                        <c:if test="${empty nurses}">
                          <tr>
                            <td colspan="6" class="text-center">
                              No nurses found
                            </td>
                          </tr>
                        </c:if>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Custom JavaScript -->
    <script>
      function confirmDelete(nurseId) {
        if (confirm("Are you sure you want to delete this nurse?")) {
          window.location.href =
            "${pageContext.request.contextPath}/admin/nurses/delete/" + nurseId;
        }
      }
    </script>
  </body>
</html>
