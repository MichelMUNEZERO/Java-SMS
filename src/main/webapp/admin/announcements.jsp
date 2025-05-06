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
                            <a href="${pageContext.request.contextPath}/admin/announcements/view/${announcement.announcementId}" class="btn btn-sm btn-outline-primary action-btn" title="View">
                              <i class="bi bi-eye"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/announcements/edit/${announcement.announcementId}" class="btn btn-sm btn-outline-secondary action-btn" title="Edit">
                              <i class="bi bi-pencil"></i>
                            </a>
                            <button type="button" class="btn btn-sm btn-outline-danger action-btn" data-bs-toggle="modal" data-bs-target="#deleteModal${announcement.announcementId}" title="Delete">
                              <i class="bi bi-trash"></i>
                            </button>
                          </div>
                        </div>
                      </div>
                    </div>
                    
                    <!-- Delete Confirmation Modal -->
                    <div class="modal fade" id="deleteModal${announcement.announcementId}" tabindex="-1" aria-hidden="true">
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
                            <a href="${pageContext.request.contextPath}/admin/announcements/delete/${announcement.announcementId}" class="btn btn-danger">
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
