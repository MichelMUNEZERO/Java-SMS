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
                  href="${pageContext.request.contextPath}/admin/dashboard"
                >
                  <i class="bi bi-speedometer2 me-2"></i> Dashboard
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link active text-white"
                  href="${pageContext.request.contextPath}/admin/students"
                >
                  <i class="bi bi-person me-2"></i> Students
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/admin/teachers"
                >
                  <i class="bi bi-person-badge me-2"></i> Teachers
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
                  class="nav-link text-white"
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
                  href="${pageContext.request.contextPath}/admin/appointments"
                >
                  <i class="bi bi-calendar-check me-2"></i> Appointments
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

        <!-- Main content -->
        <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 mt-4">
          <div
            class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom"
          >
            <h1 class="h2">Student Management</h1>
            <div class="btn-toolbar mb-2 mb-md-0">
              <a href="${pageContext.request.contextPath}/admin/students/new" class="btn btn-primary">
                <i class="bi bi-plus-circle me-1"></i> Add Student
              </a>
            </div>
          </div>

          <!-- Filters -->
          <div class="card mb-4">
            <div class="card-body">
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
          <div class="card mb-4">
            <div class="card-body">
              <div class="table-responsive">
                <table
                  class="table table-striped table-hover"
                  id="studentTable"
                >
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
                        <td>${student.id}</td>
                        <td>${student.firstName} ${student.lastName}</td>
                        <td>${student.className}</td>
                        <td>-</td>
                        <td>-</td>
                        <td><fmt:formatDate value="${student.dateOfBirth}" pattern="MMM dd, yyyy" /></td>
                        <td>
                          <span
                            class="badge ${student.status eq 'active' ? 'bg-success' : 'bg-danger'}"
                          >
                            ${student.status}
                          </span>
                        </td>
                        <td>
                          <div class="btn-group">
                            <a
                              href="${pageContext.request.contextPath}/admin/students/view/${student.id}"
                              class="btn btn-sm btn-outline-primary action-btn me-1"
                              title="View"
                            >
                              <i class="bi bi-eye"></i>
                            </a>
                            <a
                              href="${pageContext.request.contextPath}/admin/students/edit/${student.id}"
                              class="btn btn-sm btn-outline-secondary action-btn me-1"
                              title="Edit"
                            >
                              <i class="bi bi-pencil"></i>
                            </a>
                            <button
                              type="button"
                              class="btn btn-sm btn-outline-danger action-btn"
                              data-bs-toggle="modal"
                              data-bs-target="#deleteModal${student.id}"
                              title="Delete"
                            >
                              <i class="bi bi-trash"></i>
                            </button>
                          </div>

                          <!-- Delete Confirmation Modal -->
                          <div
                            class="modal fade"
                            id="deleteModal${student.id}"
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
                                    class="btn btn-secondary"
                                    data-bs-dismiss="modal"
                                  >
                                    Cancel
                                  </button>
                                  <a
                                    href="${pageContext.request.contextPath}/admin/students/delete/${student.id}"
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
