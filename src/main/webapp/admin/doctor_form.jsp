<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>
      ${empty doctor ? 'Add New' : 'Edit'} Doctor - School Management System
    </title>

    <!-- Bootstrap CSS -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />

    <!-- Bootstrap Icons -->
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css"
    />

    <!-- Custom CSS -->
    <style>
      body {
        background-color: #f8f9fa;
      }

      .sidebar {
        background-color: #343a40;
        min-height: 100vh;
      }

      .form-container {
        background-color: white;
        border-radius: 10px;
        padding: 20px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
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
                  class="nav-link active text-white"
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
            <h2 class="h3">${empty doctor ? 'Add New' : 'Edit'} Doctor</h2>
            <div class="dropdown">
              <a
                class="btn btn-outline-secondary dropdown-toggle"
                href="#"
                role="button"
                data-bs-toggle="dropdown"
              >
                <i class="bi bi-person-circle me-1"></i> Admin
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

          <!-- Error Alert -->
          <c:if test="${not empty error}">
            <div
              class="alert alert-danger alert-dismissible fade show"
              role="alert"
            >
              <i class="bi bi-exclamation-triangle me-2"></i> ${error}
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
              ></button>
            </div>
          </c:if>

          <!-- Doctor Form -->
          <div class="row">
            <div class="col-md-12">
              <div class="card form-container mb-4">
                <div class="card-header bg-white">
                  <h5 class="mb-0">
                    <i class="bi bi-heart-pulse me-2"></i> Doctor Information
                  </h5>
                </div>
                <div class="card-body">
                  <form
                    action="${pageContext.request.contextPath}${empty doctor ? '/admin/doctors/new' : '/admin/doctors/edit/'.concat(doctor.doctorId)}"
                    method="post"
                  >
                    <div class="row mb-3">
                      <div class="col-md-6">
                        <label for="firstName" class="form-label"
                          >First Name <span class="text-danger">*</span></label
                        >
                        <input
                          type="text"
                          class="form-control"
                          id="firstName"
                          name="firstName"
                          value="${doctor.firstName}"
                          required
                        />
                      </div>
                      <div class="col-md-6">
                        <label for="lastName" class="form-label"
                          >Last Name <span class="text-danger">*</span></label
                        >
                        <input
                          type="text"
                          class="form-control"
                          id="lastName"
                          name="lastName"
                          value="${doctor.lastName}"
                          required
                        />
                      </div>
                    </div>

                    <div class="row mb-3">
                      <div class="col-md-6">
                        <label for="email" class="form-label"
                          >Email <span class="text-danger">*</span></label
                        >
                        <input
                          type="email"
                          class="form-control"
                          id="email"
                          name="email"
                          value="${doctor.email}"
                          required
                        />
                      </div>
                      <div class="col-md-6">
                        <label for="phone" class="form-label">Phone</label>
                        <input
                          type="tel"
                          class="form-control"
                          id="phone"
                          name="phone"
                          value="${doctor.phone}"
                        />
                      </div>
                    </div>

                    <div class="row mb-3">
                      <div class="col-md-6">
                        <label for="specialization" class="form-label"
                          >Specialization</label
                        >
                        <input
                          type="text"
                          class="form-control"
                          id="specialization"
                          name="specialization"
                          value="${doctor.specialization}"
                        />
                      </div>
                      <div class="col-md-6">
                        <label for="hospital" class="form-label"
                          >Hospital</label
                        >
                        <input
                          type="text"
                          class="form-control"
                          id="hospital"
                          name="hospital"
                          value="${doctor.hospital}"
                        />
                      </div>
                    </div>

                    <!-- Login Credentials -->
                    <div class="row mb-3">
                      <div class="col-12">
                        <h5 class="border-bottom pb-2 mb-3">
                          Login Credentials
                        </h5>
                      </div>
                      <div class="col-md-6">
                        <label for="username" class="form-label">
                          Username
                          <span class="text-danger"
                            >${empty doctor ? '*' : ''}</span
                          >
                        </label>
                        <input type="text" class="form-control" id="username"
                        name="username" ${empty doctor ? 'required' : ''} />
                        <div class="form-text">
                          ${empty doctor ? 'Username for doctor to login to the
                          system' : 'Leave blank to keep existing username'}
                        </div>
                      </div>
                      <div class="col-md-6">
                        <label for="password" class="form-label">
                          Password
                          <span class="text-danger"
                            >${empty doctor ? '*' : ''}</span
                          >
                        </label>
                        <input type="password" class="form-control"
                        id="password" name="password" ${empty doctor ?
                        'required' : ''} />
                        <div class="form-text">
                          ${empty doctor ? 'Initial password for doctor account'
                          : 'Leave blank to keep existing password'}
                        </div>
                      </div>
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                      <a
                        href="${pageContext.request.contextPath}/admin/doctors"
                        class="btn btn-secondary me-md-2"
                      >
                        <i class="bi bi-x-circle me-1"></i> Cancel
                      </a>
                      <button type="submit" class="btn btn-primary">
                        <i class="bi bi-save me-1"></i> ${empty doctor ? 'Add' :
                        'Update'} Doctor
                      </button>
                    </div>
                  </form>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
