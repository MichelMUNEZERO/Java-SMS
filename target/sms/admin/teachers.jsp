<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Teachers - School Management System</title>
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
      .search-container {
        margin-bottom: 20px;
      }
      .search-box {
        max-width: 600px;
        border-radius: 10px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
      }
      .btn-add-teacher {
        border-radius: 8px;
        padding: 8px 20px;
        font-weight: 500;
      }
      .btn-icon {
        margin-right: 8px;
      }
      .table th {
        font-weight: 600;
        color: #333;
        background-color: #f8f9fa;
      }
      .active-badge {
        background-color: #28a745;
        color: white;
        font-weight: 500;
        padding: 5px 10px;
        border-radius: 5px;
      }
      .inactive-badge {
        background-color: #dc3545;
        color: white;
        font-weight: 500;
        padding: 5px 10px;
        border-radius: 5px;
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
            <h1 class="page-title">Teacher Management</h1>
            <div class="btn-toolbar">
              <a
                href="${pageContext.request.contextPath}/admin/teachers/new"
                class="btn btn-primary btn-add-teacher"
              >
                <i class="bi bi-person-plus btn-icon"></i> Add New Teacher
              </a>
            </div>
          </div>

          <!-- Alert for success/error messages -->
          <c:if test="${not empty param.message}">
            <div
              class="alert alert-success alert-dismissible fade show"
              role="alert"
            >
              <i class="bi bi-check-circle-fill me-2"></i>${param.message}
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
                aria-label="Close"
              ></button>
            </div>
          </c:if>
          <c:if test="${not empty param.error}">
            <div
              class="alert alert-danger alert-dismissible fade show"
              role="alert"
            >
              <i class="bi bi-exclamation-triangle-fill me-2"></i>${param.error}
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
                aria-label="Close"
              ></button>
            </div>
          </c:if>

          <!-- Search box -->
          <div class="search-container">
            <div class="input-group search-box">
              <input
                type="text"
                class="form-control"
                placeholder="Search by name or specialization"
                id="teacherSearch"
              />
              <button class="btn btn-primary" type="button" id="searchButton">
                Search
              </button>
            </div>
          </div>

          <!-- Teachers Table -->
          <div class="content-card">
            <div class="card-body">
              <div class="table-container">
                <table class="table table-hover" id="teacherTable">
                  <thead>
                    <tr>
                      <th>#</th>
                      <th>Photo</th>
                      <th>Name</th>
                      <th>Email</th>
                      <th>Specialization</th>
                      <th>Experience</th>
                      <th>Status</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach
                      var="teacher"
                      items="${teachers}"
                      varStatus="status"
                    >
                      <tr>
                        <td>${status.count}</td>
                        <td>
                          <div
                            class="d-flex align-items-center justify-content-center bg-light"
                            style="
                              width: 40px;
                              height: 40px;
                              border-radius: 50%;
                            "
                          >
                            <i class="bi bi-person-badge text-primary"></i>
                          </div>
                        </td>
                        <td>
                          <span class="fw-medium"
                            >${teacher.firstName} ${teacher.lastName}</span
                          >
                        </td>
                        <td>${teacher.email}</td>
                        <td>${teacher.specialization}</td>
                        <td>
                          ${teacher.experience > 0 ? teacher.experience : '5'}
                          years
                        </td>
                        <td>
                          <span
                            class="badge ${teacher.status eq 'active' ? 'active-badge' : 'inactive-badge'}"
                          >
                            ${teacher.status}
                          </span>
                        </td>
                        <td>
                          <div class="d-flex">
                            <a
                              href="${pageContext.request.contextPath}/admin/teachers/view/${teacher.id}"
                              class="btn btn-sm btn-outline-primary action-btn me-1"
                              title="View"
                            >
                              <i class="bi bi-eye"></i>
                            </a>
                            <a
                              href="${pageContext.request.contextPath}/admin/teachers/edit/${teacher.id}"
                              class="btn btn-sm btn-outline-secondary action-btn me-1"
                              title="Edit"
                            >
                              <i class="bi bi-pencil"></i>
                            </a>
                            <button
                              type="button"
                              class="btn btn-sm btn-outline-danger action-btn"
                              data-bs-toggle="modal"
                              data-bs-target="#deleteModal${teacher.id}"
                              title="Delete"
                            >
                              <i class="bi bi-trash"></i>
                            </button>
                          </div>

                          <!-- Delete Confirmation Modal -->
                          <div
                            class="modal fade"
                            id="deleteModal${teacher.id}"
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
                                    Are you sure you want to delete teacher
                                    <strong
                                      >${teacher.firstName}
                                      ${teacher.lastName}</strong
                                    >?
                                  </p>
                                  <p class="text-danger">
                                    This action cannot be undone and may affect
                                    related course assignments.
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
                                    href="${pageContext.request.contextPath}/admin/teachers/delete/${teacher.id}"
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
                    <c:if test="${empty teachers}">
                      <tr>
                        <td colspan="8" class="text-center">
                          No teachers found
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
        // Initialize DataTable
        var table = $("#teacherTable").DataTable({
          pageLength: 10,
          dom: "lrtip", // Hide the default search box
          language: {
            emptyTable: "No teachers found",
            info: "Showing _START_ to _END_ of _TOTAL_ teachers",
            lengthMenu: "Show _MENU_ teachers per page",
            paginate: {
              next: '<i class="bi bi-chevron-right"></i>',
              previous: '<i class="bi bi-chevron-left"></i>',
            },
          },
        });

        // Custom search functionality
        $("#searchButton").on("click", function () {
          table.search($("#teacherSearch").val()).draw();
        });

        $("#teacherSearch").on("keyup", function (e) {
          if (e.key === "Enter") {
            table.search($(this).val()).draw();
          }
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
