<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Parent Details - School Management System</title>
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
      }
      .profile-header {
        background-color: #f8f9fa;
        border-radius: 10px 10px 0 0;
        padding: 20px;
      }
      .detail-label {
        font-weight: bold;
        color: #6c757d;
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
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/admin/students"
                >
                  <i class="bi bi-person me-2"></i> Students
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link active text-white"
                  href="${pageContext.request.contextPath}/admin/parents"
                >
                  <i class="bi bi-people me-2"></i> Parents
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
                  href="${pageContext.request.contextPath}/admin/courses"
                >
                  <i class="bi bi-book me-2"></i> Courses
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
            <h1 class="h2">Parent Details</h1>
            <div class="btn-toolbar mb-2 mb-md-0">
              <a
                href="${pageContext.request.contextPath}/admin/parents"
                class="btn btn-sm btn-outline-secondary me-2"
              >
                <i class="bi bi-arrow-left me-1"></i> Back to List
              </a>
              <a
                href="${pageContext.request.contextPath}/admin/parents/edit/${parent.id}"
                class="btn btn-sm btn-primary"
              >
                <i class="bi bi-pencil me-1"></i> Edit
              </a>
            </div>
          </div>

          <!-- Parent Details Card -->
          <div class="card mb-4">
            <div class="profile-header d-flex align-items-center">
              <div
                class="profile-avatar bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3"
                style="width: 80px; height: 80px; font-size: 2.5rem"
              >
                ${parent.firstName.charAt(0)}${parent.lastName.charAt(0)}
              </div>
              <div>
                <h3>${parent.firstName} ${parent.lastName}</h3>
                <p class="mb-0 text-muted">
                  <span
                    class="badge ${parent.status eq 'active' ? 'bg-success' : 'bg-danger'}"
                  >
                    ${parent.status}
                  </span>
                  <span class="ms-2">ID: ${parent.id}</span>
                </p>
              </div>
            </div>
            <div class="card-body">
              <div class="row mb-4">
                <div class="col-md-6">
                  <h5 class="mb-4">Contact Information</h5>
                  <div class="mb-3">
                    <p class="detail-label">Email</p>
                    <p>
                      <i class="bi bi-envelope me-2 text-primary"></i>
                      <a href="mailto:${parent.email}">${parent.email}</a>
                    </p>
                  </div>
                  <div class="mb-3">
                    <p class="detail-label">Phone</p>
                    <p>
                      <i class="bi bi-telephone me-2 text-primary"></i>
                      <a href="tel:${parent.phone}">${parent.phone}</a>
                    </p>
                  </div>
                  <div class="mb-3">
                    <p class="detail-label">Address</p>
                    <p>
                      <i class="bi bi-geo-alt me-2 text-primary"></i>
                      ${parent.address}
                    </p>
                  </div>
                </div>
                <div class="col-md-6">
                  <h5 class="mb-4">Additional Information</h5>
                  <div class="mb-3">
                    <p class="detail-label">Occupation</p>
                    <p>
                      <i class="bi bi-briefcase me-2 text-primary"></i>
                      ${not empty parent.occupation ? parent.occupation : 'Not
                      specified'}
                    </p>
                  </div>
                  <div class="mb-3">
                    <p class="detail-label">Children</p>
                    <p>
                      <i class="bi bi-people me-2 text-primary"></i>
                      <span class="badge bg-info"
                        >${parent.childrenCount} ${parent.childrenCount == 1 ?
                        'Child' : 'Children'}</span
                      >
                    </p>
                  </div>
                </div>
              </div>

              <h5 class="mb-3">Children</h5>
              <div class="table-responsive">
                <table class="table table-striped table-hover">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Name</th>
                      <th>Grade</th>
                      <th>Section</th>
                      <th>Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:choose>
                      <c:when test="${not empty children}">
                        <c:forEach var="child" items="${children}">
                          <tr>
                            <td>${child.id}</td>
                            <td>${child.firstName} ${child.lastName}</td>
                            <td>${child.grade}</td>
                            <td>${child.section}</td>
                            <td>
                              <a
                                href="${pageContext.request.contextPath}/admin/students/view/${child.id}"
                                class="btn btn-sm btn-outline-primary"
                              >
                                <i class="bi bi-eye"></i> View
                              </a>
                            </td>
                          </tr>
                        </c:forEach>
                      </c:when>
                      <c:otherwise>
                        <tr>
                          <td colspan="5" class="text-center">
                            No children records found
                          </td>
                        </tr>
                      </c:otherwise>
                    </c:choose>
                  </tbody>
                </table>
              </div>

              <div class="d-flex justify-content-between mt-4">
                <div>
                  <a
                    href="${pageContext.request.contextPath}/admin/parents/edit/${parent.id}"
                    class="btn btn-primary"
                  >
                    <i class="bi bi-pencil me-1"></i> Edit
                  </a>
                  <button
                    type="button"
                    class="btn btn-danger ms-2"
                    data-bs-toggle="modal"
                    data-bs-target="#deleteModal"
                  >
                    <i class="bi bi-trash me-1"></i> Delete
                  </button>
                </div>
                <a
                  href="${pageContext.request.contextPath}/admin/parents"
                  class="btn btn-outline-secondary"
                >
                  <i class="bi bi-arrow-left me-1"></i> Back to List
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
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
              Are you sure you want to delete parent
              <strong>${parent.firstName} ${parent.lastName}</strong>?
            </p>
            <p class="text-danger">
              This action cannot be undone and may affect related student
              records.
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
              href="${pageContext.request.contextPath}/admin/parents/delete/${parent.id}"
              class="btn btn-danger"
            >
              <i class="bi bi-trash me-1"></i> Delete
            </a>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
