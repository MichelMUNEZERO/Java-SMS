<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Appointments - School Management System</title>
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
      .dashboard-card {
        transition: transform 0.3s;
        border-radius: 10px;
        border: none;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        height: 100%;
      }

      .dashboard-card:hover {
        transform: translateY(-5px);
      }

      .appointment-card {
        transition: transform 0.2s;
        border-radius: 10px;
        border: none;
        box-shadow: 0 0.25rem 0.5rem rgba(0, 0, 0, 0.1);
        margin-bottom: 1.5rem;
      }

      .appointment-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
      }

      .status-badge {
        font-size: 0.75rem;
        padding: 0.25rem 0.5rem;
        border-radius: 15px;
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
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/dashboard">
                  <i class="bi bi-speedometer2 me-2"></i> Dashboard
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/students">
                  <i class="bi bi-mortarboard me-2"></i> Students
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/teachers">
                  <i class="bi bi-person-workspace me-2"></i> Teachers
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/parents">
                  <i class="bi bi-people me-2"></i> Parents
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/announcements">
                  <i class="bi bi-megaphone me-2"></i> Announcements
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link active text-white" href="${pageContext.request.contextPath}/admin/appointments">
                  <i class="bi bi-calendar-check me-2"></i> Appointments
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
            <h1 class="h2">Manage Appointments</h1>
            <div class="btn-toolbar mb-2 mb-md-0">
              <div class="dropdown">
                <a
                  class="btn btn-sm btn-outline-secondary dropdown-toggle"
                  href="#"
                  role="button"
                  id="dropdownMenuLink"
                  data-bs-toggle="dropdown"
                  aria-expanded="false"
                >
                  <i class="bi bi-person-circle me-1"></i> ${user.username}
                </a>
                <ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
                  <li>
                    <a class="dropdown-item" href="#"
                      ><i class="bi bi-person me-2"></i> Profile</a
                    >
                  </li>
                  <li>
                    <a class="dropdown-item" href="#"
                      ><i class="bi bi-gear me-2"></i> Settings</a
                    >
                  </li>
                  <li><hr class="dropdown-divider" /></li>
                  <li>
                    <a
                      class="dropdown-item"
                      href="${pageContext.request.contextPath}/logout"
                      ><i class="bi bi-box-arrow-right me-2"></i> Logout</a
                    >
                  </li>
                </ul>
              </div>
            </div>
          </div>

          <!-- Status Messages -->
          <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
              <i class="bi bi-check-circle me-2"></i>
              ${sessionScope.successMessage}
              <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="successMessage" scope="session" />
          </c:if>
          
          <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
              <i class="bi bi-exclamation-triangle me-2"></i>
              ${sessionScope.errorMessage}
              <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session" />
          </c:if>

          <!-- Appointments Table -->
          <div class="row">
            <div class="col-md-12 mb-4">
              <div class="card dashboard-card">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                  <h5 class="card-title mb-0">All Appointments</h5>
                  <div>
                    <button class="btn btn-sm btn-outline-primary me-2" id="filterBtn">
                      <i class="bi bi-funnel me-1"></i> Filter
                    </button>
                    <button class="btn btn-sm btn-outline-secondary" id="exportBtn">
                      <i class="bi bi-download me-1"></i> Export
                    </button>
                  </div>
                </div>
                <div class="card-body">
                  <div class="row mb-3 filter-controls" style="display: none;">
                    <div class="col-md-3">
                      <label for="statusFilter" class="form-label">Status</label>
                      <select id="statusFilter" class="form-select form-select-sm">
                        <option value="">All Statuses</option>
                        <option value="Scheduled">Scheduled</option>
                        <option value="Completed">Completed</option>
                        <option value="Cancelled">Cancelled</option>
                        <option value="Pending">Pending</option>
                      </select>
                    </div>
                    <div class="col-md-3">
                      <label for="dateFilter" class="form-label">Date Range</label>
                      <select id="dateFilter" class="form-select form-select-sm">
                        <option value="">All Dates</option>
                        <option value="today">Today</option>
                        <option value="tomorrow">Tomorrow</option>
                        <option value="week">This Week</option>
                        <option value="month">This Month</option>
                      </select>
                    </div>
                    <div class="col-md-3 mt-4">
                      <button type="button" class="btn btn-sm btn-primary mt-1" id="applyFilter">
                        Apply Filter
                      </button>
                      <button type="button" class="btn btn-sm btn-secondary mt-1" id="resetFilter">
                        Reset
                      </button>
                    </div>
                  </div>
                
                  <c:if test="${empty appointments}">
                    <div class="alert alert-info mb-0">
                      <i class="bi bi-info-circle me-2"></i>
                      There are no appointments in the system yet.
                    </div>
                  </c:if>
                  
                  <c:if test="${not empty appointments}">
                    <div class="table-responsive">
                      <table class="table table-hover" id="appointmentsTable">
                        <thead>
                          <tr>
                            <th>ID</th>
                            <th>Date & Time</th>
                            <th>Title</th>
                            <th>Student</th>
                            <th>Parent</th>
                            <th>Teacher</th>
                            <th>Status</th>
                            <th>Actions</th>
                          </tr>
                        </thead>
                        <tbody>
                          <c:forEach var="appointment" items="${appointments}">
                            <tr>
                              <td>${appointment.appointmentId}</td>
                              <td>
                                <fmt:formatDate value="${appointment.appointmentDate}" pattern="MMM d, yyyy h:mm a" />
                              </td>
                              <td>${appointment.title}</td>
                              <td>${appointment.studentName}</td>
                              <td>${appointment.parentName}</td>
                              <td>${appointment.teacherName}</td>
                              <td>
                                <span class="badge rounded-pill 
                                  <c:choose>
                                    <c:when test="${appointment.status eq 'Scheduled'}">bg-primary</c:when>
                                    <c:when test="${appointment.status eq 'Completed'}">bg-success</c:when>
                                    <c:when test="${appointment.status eq 'Cancelled'}">bg-danger</c:when>
                                    <c:when test="${appointment.status eq 'Pending'}">bg-warning</c:when>
                                    <c:otherwise>bg-secondary</c:otherwise>
                                  </c:choose>">
                                  ${appointment.status}
                                </span>
                              </td>
                              <td>
                                <button type="button" class="btn btn-sm btn-primary" 
                                        data-bs-toggle="modal" data-bs-target="#viewAppointmentModal"
                                        data-appointment-id="${appointment.appointmentId}">
                                  <i class="bi bi-eye"></i>
                                </button>
                                <button type="button" class="btn btn-sm btn-success"
                                        data-bs-toggle="modal" data-bs-target="#updateStatusModal"
                                        data-appointment-id="${appointment.appointmentId}"
                                        data-current-status="${appointment.status}">
                                  <i class="bi bi-check2-circle"></i>
                                </button>
                              </td>
                            </tr>
                          </c:forEach>
                        </tbody>
                      </table>
                    </div>
                  </c:if>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- View Appointment Modal -->
    <div class="modal fade" id="viewAppointmentModal" tabindex="-1" aria-labelledby="viewAppointmentModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="viewAppointmentModalLabel">Appointment Details</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <div class="row">
              <div class="col-md-6">
                <p><strong>ID:</strong> <span id="modal-appointment-id"></span></p>
                <p><strong>Title:</strong> <span id="modal-title"></span></p>
                <p><strong>Date & Time:</strong> <span id="modal-datetime"></span></p>
                <p><strong>Status:</strong> <span id="modal-status"></span></p>
              </div>
              <div class="col-md-6">
                <p><strong>Student:</strong> <span id="modal-student"></span></p>
                <p><strong>Parent:</strong> <span id="modal-parent"></span></p>
                <p><strong>Teacher:</strong> <span id="modal-teacher"></span></p>
              </div>
            </div>
            <div class="row mt-3">
              <div class="col-md-12">
                <p><strong>Description:</strong></p>
                <p id="modal-description" class="bg-light p-3 rounded"></p>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Update Status Modal -->
    <div class="modal fade" id="updateStatusModal" tabindex="-1" aria-labelledby="updateStatusModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="updateStatusModalLabel">Update Appointment Status</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <form action="${pageContext.request.contextPath}/admin/appointments" method="post">
            <div class="modal-body">
              <input type="hidden" id="appointmentId" name="appointmentId" value="">
              
              <div class="mb-3">
                <label for="status" class="form-label">Status</label>
                <select class="form-select" id="status" name="status" required>
                  <option value="Scheduled">Scheduled</option>
                  <option value="Completed">Completed</option>
                  <option value="Cancelled">Cancelled</option>
                  <option value="Pending">Pending</option>
                </select>
              </div>
              
              <div class="mb-3">
                <label for="notes" class="form-label">Notes</label>
                <textarea class="form-control" id="notes" name="notes" rows="3"></textarea>
              </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
              <button type="submit" class="btn btn-primary">Update Status</button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
      // Filter toggle
      document.getElementById('filterBtn').addEventListener('click', function() {
        const filterControls = document.querySelector('.filter-controls');
        if (filterControls.style.display === 'none') {
          filterControls.style.display = 'flex';
        } else {
          filterControls.style.display = 'none';
        }
      });
      
      // Update status modal
      const updateStatusModal = document.getElementById('updateStatusModal');
      updateStatusModal.addEventListener('show.bs.modal', function(event) {
        const button = event.relatedTarget;
        const appointmentId = button.getAttribute('data-appointment-id');
        const currentStatus = button.getAttribute('data-current-status');
        
        const appointmentIdInput = updateStatusModal.querySelector('#appointmentId');
        const statusSelect = updateStatusModal.querySelector('#status');
        
        appointmentIdInput.value = appointmentId;
        statusSelect.value = currentStatus;
      });
      
      // View appointment modal
      const viewAppointmentModal = document.getElementById('viewAppointmentModal');
      viewAppointmentModal.addEventListener('show.bs.modal', function(event) {
        const button = event.relatedTarget;
        const appointmentId = button.getAttribute('data-appointment-id');
        
        // Here you would normally fetch the appointment details via AJAX
        // For now, let's just use the data from the table row
        const row = button.closest('tr');
        const cells = row.querySelectorAll('td');
        
        document.getElementById('modal-appointment-id').textContent = cells[0].textContent;
        document.getElementById('modal-datetime').textContent = cells[1].textContent;
        document.getElementById('modal-title').textContent = cells[2].textContent;
        document.getElementById('modal-student').textContent = cells[3].textContent;
        document.getElementById('modal-parent').textContent = cells[4].textContent;
        document.getElementById('modal-teacher').textContent = cells[5].textContent;
        document.getElementById('modal-status').textContent = cells[6].textContent.trim();
        
        // This would normally come from the AJAX call
        document.getElementById('modal-description').textContent = "Loading description...";
        
        // Simulate AJAX call to get full appointment details
        setTimeout(function() {
          // In a real implementation, this would be replaced with actual data from the server
          document.getElementById('modal-description').textContent = "This is a placeholder description for appointment #" + appointmentId;
        }, 500);
      });
    </script>
  </body>
</html> 