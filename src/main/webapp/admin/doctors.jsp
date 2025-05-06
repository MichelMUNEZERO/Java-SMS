<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Doctors - School Management System</title>
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
            <h1 class="page-title">Manage Doctors</h1>
            <div class="btn-toolbar">
              <a
                href="${pageContext.request.contextPath}/admin/doctors/new"
                class="btn btn-primary"
              >
                <i class="bi bi-plus-circle me-1"></i> Add New Doctor
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

          <!-- Doctor Management Section -->
          <div class="content-card">
            <div
              class="card-header d-flex justify-content-between align-items-center"
            >
              <h5 class="mb-0">Doctor List</h5>
            </div>
            <div class="card-body">
              <div class="table-container">
                <table class="table table-striped data-table" id="doctorTable">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Name</th>
                      <th>Email</th>
                      <th>Phone</th>
                      <th>Specialization</th>
                      <th>Hospital</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="doctor" items="${doctors}">
                      <tr>
                        <td>${doctor.doctorId}</td>
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
                              <i class="bi bi-heart-pulse text-secondary"></i>
                            </div>
                            <div>
                              <span class="fw-medium"
                                >${doctor.firstName} ${doctor.lastName}</span
                              >
                            </div>
                          </div>
                        </td>
                        <td>${doctor.email}</td>
                        <td>${doctor.phone}</td>
                        <td>${doctor.specialization}</td>
                        <td>${doctor.hospital}</td>
                        <td>
                          <div class="d-flex">
                            <a
                              href="${pageContext.request.contextPath}/admin/doctors/view/${doctor.doctorId}"
                              class="btn btn-sm btn-outline-primary action-btn"
                              title="View"
                            >
                              <i class="bi bi-eye"></i>
                            </a>
                            <a
                              href="${pageContext.request.contextPath}/admin/doctors/edit/${doctor.doctorId}"
                              class="btn btn-sm btn-outline-secondary action-btn"
                              title="Edit"
                            >
                              <i class="bi bi-pencil"></i>
                            </a>
                            <button
                              type="button"
                              class="btn btn-sm btn-outline-danger action-btn"
                              data-bs-toggle="modal"
                              data-bs-target="#deleteModal${doctor.doctorId}"
                              title="Delete"
                            >
                              <i class="bi bi-trash"></i>
                            </button>
                          </div>

                          <!-- Delete Confirmation Modal -->
                          <div
                            class="modal fade"
                            id="deleteModal${doctor.doctorId}"
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
                                    Are you sure you want to delete doctor
                                    <strong
                                      >${doctor.firstName}
                                      ${doctor.lastName}</strong
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
                                    href="${pageContext.request.contextPath}/admin/doctors/delete/${doctor.doctorId}"
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

                    <c:if test="${empty doctors}">
                      <tr>
                        <td colspan="7" class="text-center">
                          No doctors found
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

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
    <script>
      $(document).ready(function () {
        $("#doctorTable").DataTable({
          pageLength: 10,
          language: {
            search: "Search doctors:",
            lengthMenu: "Show _MENU_ doctors per page",
            info: "Showing _START_ to _END_ of _TOTAL_ doctors",
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
