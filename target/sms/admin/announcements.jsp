<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Announcements - School Management System</title>
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
      .announcement-card {
        border-radius: var(--border-radius);
        box-shadow: var(--card-shadow);
        transition: all var(--transition-speed);
        border-left: 4px solid #3498db;
        margin-bottom: 1.5rem;
      }
      
      .announcement-card:hover {
        box-shadow: var(--hover-shadow);
        transform: translateY(-3px);
      }
      
      .announcement-title {
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 0.5rem;
      }
      
      .announcement-date {
        font-size: 0.8rem;
        color: #6c757d;
      }
      
      .target-badge {
        background-color: #e9ecef;
        color: #495057;
        font-size: 0.75rem;
        font-weight: 600;
        padding: 0.35em 0.65em;
        border-radius: 50rem;
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
            <h1 class="page-title">Announcements</h1>
            <div class="btn-toolbar">
              <a
                href="${pageContext.request.contextPath}/admin/announcements/new"
                class="btn btn-primary"
              >
                <i class="bi bi-plus-circle me-1"></i> New Announcement
              </a>
            </div>
          </div>

          <!-- Alerts for success/error messages -->
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

          <!-- Announcement Filter -->
          <div class="filter-section mb-4">
            <form action="${pageContext.request.contextPath}/admin/announcements" method="get" class="row g-3">
              <div class="col-md-4">
                <label for="targetGroup" class="form-label">Target Group</label>
                <select class="form-select" id="targetGroup" name="targetGroup">
                  <option value="" ${empty param.targetGroup ? 'selected' : ''}>All Groups</option>
                  <option value="All" ${param.targetGroup eq 'All' ? 'selected' : ''}>Everyone</option>
                  <option value="Students" ${param.targetGroup eq 'Students' ? 'selected' : ''}>Students</option>
                  <option value="Teachers" ${param.targetGroup eq 'Teachers' ? 'selected' : ''}>Teachers</option>
                  <option value="Parents" ${param.targetGroup eq 'Parents' ? 'selected' : ''}>Parents</option>
                  <option value="Staff" ${param.targetGroup eq 'Staff' ? 'selected' : ''}>Staff</option>
                </select>
              </div>
              <div class="col-md-4">
                <label for="startDate" class="form-label">Start Date</label>
                <input type="date" class="form-control" id="startDate" name="startDate" value="${param.startDate}">
              </div>
              <div class="col-md-4 d-flex align-items-end">
                <button type="submit" class="btn btn-primary w-100">
                  <i class="bi bi-filter me-1"></i> Apply Filters
                </button>
              </div>
            </form>
          </div>

          <!-- Announcements List -->
          <div class="row">
            <div class="col-12">
              <c:choose>
                <c:when test="${empty announcements}">
                  <div class="text-center py-5">
                    <i class="bi bi-megaphone text-muted" style="font-size: 3rem;"></i>
                    <p class="mt-3 text-muted">No announcements found</p>
                    <a href="${pageContext.request.contextPath}/admin/announcements/new" class="btn btn-primary mt-2">
                      <i class="bi bi-plus-circle me-1"></i> Create New Announcement
                    </a>
                  </div>
                </c:when>
                <c:otherwise>
                  <c:forEach var="announcement" items="${announcements}">
                    <div class="card announcement-card">
                      <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                          <h5 class="announcement-title">${announcement.title}</h5>
                          <span class="target-badge">
                            <i class="bi bi-people-fill me-1"></i> ${announcement.targetGroup}
                          </span>
                        </div>
                        <p class="card-text">${announcement.message}</p>
                        <div class="d-flex justify-content-between align-items-center">
                          <span class="announcement-date">
                            <i class="bi bi-calendar-event me-1"></i> 
                            <fmt:formatDate value="${announcement.createdAt}" pattern="MMMM dd, yyyy" />
                          </span>
                          <div class="d-flex">
                            <a href="${pageContext.request.contextPath}/admin/announcements/view/${announcement.id}" class="btn btn-sm btn-outline-primary action-btn" title="View">
                              <i class="bi bi-eye"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/announcements/edit/${announcement.id}" class="btn btn-sm btn-outline-secondary action-btn" title="Edit">
                              <i class="bi bi-pencil"></i>
                            </a>
                            <button type="button" class="btn btn-sm btn-outline-danger action-btn" data-bs-toggle="modal" data-bs-target="#deleteModal${announcement.id}" title="Delete">
                              <i class="bi bi-trash"></i>
                            </button>
                          </div>
                        </div>
                      </div>
                    </div>
                    
                    <!-- Delete Confirmation Modal -->
                    <div class="modal fade" id="deleteModal${announcement.id}" tabindex="-1" aria-hidden="true">
                      <div class="modal-dialog">
                        <div class="modal-content">
                          <div class="modal-header">
                            <h5 class="modal-title">Confirm Deletion</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                          </div>
                          <div class="modal-body">
                            <p>Are you sure you want to delete the announcement "<strong>${announcement.title}</strong>"?</p>
                            <p class="text-danger">This action cannot be undone.</p>
                          </div>
                          <div class="modal-footer">
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                            <a href="${pageContext.request.contextPath}/admin/announcements/delete/${announcement.id}" class="btn btn-danger">
                              <i class="bi bi-trash me-1"></i> Delete
                            </a>
                          </div>
                        </div>
                      </div>
                    </div>
                  </c:forEach>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      // Initialize tooltips
      document.addEventListener('DOMContentLoaded', function() {
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
          return new bootstrap.Tooltip(tooltipTriggerEl)
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

      .announcement-card {
        transition: transform 0.3s;
      }

      .announcement-card:hover {
        transform: translateY(-5px);
      }

      .announcement-title {
        font-weight: bold;
        font-size: 1.2rem;
      }

      .announcement-date {
        font-size: 0.8rem;
        color: #6c757d;
      }

      .announcement-message {
        margin-top: 10px;
        overflow: hidden;
        text-overflow: ellipsis;
        display: -webkit-box;
        -webkit-line-clamp: 3;
        -webkit-box-orient: vertical;
      }

      .target-badge {
        font-size: 0.8rem;
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
            <h2 class="h3">Manage Announcements</h2>
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
          <c:if test="${param.message != null}">
            <div
              class="alert alert-success alert-dismissible fade show"
              role="alert"
            >
              <i class="bi bi-check-circle me-2"></i> ${param.message}
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

          <!-- Announcement Management Section -->
          <div class="row mb-4">
            <div class="col-md-12">
              <div class="card table-container">
                <div
                  class="card-header bg-white d-flex justify-content-between align-items-center"
                >
                  <h5 class="mb-0">Announcements List</h5>
                  <a
                    href="${pageContext.request.contextPath}/admin/announcements/new"
                    class="btn btn-primary"
                  >
                    <i class="bi bi-plus-circle me-1"></i> Create New
                    Announcement
                  </a>
                </div>
                <div class="card-body">
                  <c:if test="${empty announcements}">
                    <div class="alert alert-info">
                      No announcements found. Create your first announcement!
                    </div>
                  </c:if>

                  <div class="row">
                    <c:forEach var="announcement" items="${announcements}">
                      <div class="col-md-6 col-lg-4 mb-4">
                        <div class="card announcement-card h-100">
                          <div
                            class="card-header d-flex justify-content-between align-items-center"
                          >
                            <span class="badge bg-primary target-badge">
                              <i class="bi bi-people"></i>
                              ${announcement.targetGroup}
                            </span>
                            <div class="announcement-date">
                              <fmt:formatDate
                                value="${announcement.date}"
                                pattern="MMM dd, yyyy HH:mm"
                              />
                            </div>
                          </div>
                          <div class="card-body">
                            <h5 class="announcement-title">
                              ${announcement.title}
                            </h5>
                            <div class="announcement-message">
                              ${announcement.message}
                            </div>
                          </div>
                          <div
                            class="card-footer bg-white d-flex justify-content-between"
                          >
                            <small class="text-muted"
                              >By: ${announcement.postedBy}</small
                            >
                            <div class="action-buttons">
                              <a
                                href="${pageContext.request.contextPath}/admin/announcements/view/${announcement.announcementId}"
                                class="btn btn-sm btn-info"
                              >
                                <i class="bi bi-eye"></i>
                              </a>
                              <a
                                href="${pageContext.request.contextPath}/admin/announcements/edit/${announcement.announcementId}"
                                class="btn btn-sm btn-warning"
                              >
                                <i class="bi bi-pencil"></i>
                              </a>
                              <button
                                type="button"
                                onclick="confirmDelete('${announcement.announcementId}')"
                                class="btn btn-sm btn-danger"
                              >
                                <i class="bi bi-trash"></i>
                              </button>
                            </div>
                          </div>
                        </div>
                      </div>
                    </c:forEach>
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
