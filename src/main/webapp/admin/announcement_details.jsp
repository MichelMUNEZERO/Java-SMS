<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Announcement Details - School Management System</title>

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

      .detail-container {
        background-color: white;
        border-radius: 10px;
        padding: 20px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      }

      .announcement-meta {
        font-size: 0.9rem;
        color: #6c757d;
      }

      .announcement-content {
        margin-top: 20px;
        padding: 20px;
        background-color: #f8f9fa;
        border-radius: 10px;
        border-left: 5px solid #0d6efd;
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
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/admin/nurses"
                >
                  <i class="bi bi-bandaid me-2"></i> Nurses
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link active text-white"
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
            <h2 class="h3">Announcement Details</h2>
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

          <!-- Announcement Details Section -->
          <div class="row mb-4">
            <div class="col-md-12">
              <div class="card detail-container">
                <div
                  class="card-header bg-white d-flex justify-content-between align-items-center"
                >
                  <h5 class="mb-0">
                    <i class="bi bi-megaphone me-2"></i>
                    Announcement Information
                  </h5>
                  <div>
                    <a
                      href="${pageContext.request.contextPath}/admin/announcements/edit/${announcement.announcementId}"
                      class="btn btn-warning btn-sm me-2"
                    >
                      <i class="bi bi-pencil me-1"></i> Edit
                    </a>
                    <button
                      type="button"
                      onclick="confirmDelete('${announcement.announcementId}')"
                      class="btn btn-danger btn-sm"
                    >
                      <i class="bi bi-trash me-1"></i> Delete
                    </button>
                  </div>
                </div>
                <div class="card-body">
                  <div class="row">
                    <div class="col-md-12">
                      <h2 class="mb-4">${announcement.title}</h2>

                      <div class="announcement-meta mb-4">
                        <div class="row">
                          <div class="col-md-4">
                            <p>
                              <i class="bi bi-calendar me-2"></i>
                              <fmt:formatDate
                                value="${announcement.date}"
                                pattern="MMMM dd, yyyy hh:mm a"
                              />
                            </p>
                          </div>
                          <div class="col-md-4">
                            <p>
                              <i class="bi bi-person me-2"></i> Posted by:
                              ${announcement.postedBy}
                            </p>
                          </div>
                          <div class="col-md-4">
                            <p>
                              <i class="bi bi-people me-2"></i> Target:
                              ${announcement.targetGroup}
                            </p>
                          </div>
                        </div>
                      </div>

                      <div class="announcement-content">
                        <p>${announcement.message}</p>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="card-footer bg-white">
                  <a
                    href="${pageContext.request.contextPath}/admin/announcements"
                    class="btn btn-secondary"
                  >
                    <i class="bi bi-arrow-left me-1"></i> Back to Announcements
                  </a>
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
      function confirmDelete(announcementId) {
        if (confirm("Are you sure you want to delete this announcement?")) {
          window.location.href =
            "${pageContext.request.contextPath}/admin/announcements/delete/" +
            announcementId;
        }
      }
    </script>
  </body>
</html>
