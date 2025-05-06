<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Students - School Management System</title>
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
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
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
      .badge {
        padding: 0.5em 0.8em;
        font-weight: 500;
        border-radius: 6px;
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
          <div class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center">
            <h1 class="page-title">Student Management</h1>
          </div>

          <!-- Filters -->
          <div class="filter-section">
            <form action="${pageContext.request.contextPath}/admin/students" method="get" class="row g-3">
              <div class="col-md-3">
                <label for="gradeLevel" class="form-label">Grade Level</label>
                <select class="form-select" id="gradeLevel" name="gradeLevel">
                  <option value="">All Grades</option>
                  <c:forEach var="i" begin="1" end="12">
                    <option value="${i}" ${param.gradeLevel eq i ? 'selected' : ''}>Grade ${i}</option>
                  </c:forEach>
                </select>
              </div>
              <div class="col-md-3">
                <label for="section" class="form-label">Section</label>
                <select class="form-select" id="section" name="section">
                  <option value="">All Sections</option>
                  <option value="A" ${param.section eq 'A' ? 'selected' : ''}>A</option>
                  <option value="B" ${param.section eq 'B' ? 'selected' : ''}>B</option>
                  <option value="C" ${param.section eq 'C' ? 'selected' : ''}>C</option>
                </select>
              </div>
              <div class="col-md-3">
                <label for="status" class="form-label">Status</label>
                <select class="form-select" id="status" name="status">
                  <option value="">All Status</option>
                  <option value="active" ${param.status eq 'active' ? 'selected' : ''}>Active</option>
                  <option value="inactive" ${param.status eq 'inactive' ? 'selected' : ''}>Inactive</option>
                </select>
              </div>
              <div class="col-md-3 d-flex align-items-end">
                <button type="submit" class="btn btn-primary w-100">
                  <i class="bi bi-filter me-1"></i> Apply Filters
                </button>
              </div>
            </form>
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

          <!-- Students Table -->
          <div class="content-card">
            <div class="card-body">
              <div class="table-container">
                <table class="table table-striped data-table" id="studentTable">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Name</th>
                      <th>Grade</th>
                      <th>Section</th>
                      <th>Parent</th>
                      <th>Date of Birth</th>
                      <th>Status</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="student" items="${students}">
                      <tr>
                        <td>${student.getId()}</td>
                        <td>
                          <div class="d-flex align-items-center">
                            <div class="avatar-circle me-2 d-flex align-items-center justify-content-center bg-light" style="width: 35px; height: 35px; border-radius: 50%;">
                              <i class="bi bi-person text-secondary"></i>
                            </div>
                            <div>
                              <span class="fw-medium">${student.firstName} ${student.lastName}</span>
                            </div>
                          </div>
                        </td>
                        <td>${student.className}</td>
                        <td>-</td>
                        <td>-</td>
                        <td><fmt:formatDate value="${student.dateOfBirth}" pattern="MMM dd, yyyy" /></td>
                        <td>
                          <span
                            class="badge ${student.status eq 'active' ? 'bg-dark' : 'bg-danger'}"
                          >
                            ${student.status}
                          </span>
                        </td>
                        <td>
                          <div class="d-flex">
                            <a
                              href="${pageContext.request.contextPath}/admin/students/view/${student.getId()}"
                              class="btn btn-sm btn-outline-primary action-btn"
                              title="View"
                            >
                              <i class="bi bi-eye"></i>
                            </a>
                            <a
                              href="${pageContext.request.contextPath}/admin/students/edit/${student.getId()}"
                              class="btn btn-sm btn-outline-secondary action-btn"
                              title="Edit"
                            >
                              <i class="bi bi-pencil"></i>
                            </a>
                            <button
                              type="button"
                              class="btn btn-sm btn-outline-danger action-btn"
                              data-bs-toggle="modal"
                              data-bs-target="#deleteModal${student.getId()}"
                              title="Delete"
                            >
                              <i class="bi bi-trash"></i>
                            </button>
                          </div>

                          <!-- Delete Confirmation Modal -->
                          <div
                            class="modal fade"
                            id="deleteModal${student.getId()}"
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
                                    Are you sure you want to delete student
                                    <strong
                                      >${student.firstName}
                                      ${student.lastName}</strong
                                    >?
                                  </p>
                                  <p class="text-danger">
                                    This action cannot be undone and will remove all associated attendance and grade records.
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
                                    href="${pageContext.request.contextPath}/admin/students/delete/${student.getId()}"
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
        $("#studentTable").DataTable({
          pageLength: 10,
          language: {
            search: "Search students:",
            lengthMenu: "Show _MENU_ students per page",
            info: "Showing _START_ to _END_ of _TOTAL_ students",
          },
        });
        
        // Initialize tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
          return new bootstrap.Tooltip(tooltipTriggerEl)
        });
      });
    </script>
  </body>
</html>
