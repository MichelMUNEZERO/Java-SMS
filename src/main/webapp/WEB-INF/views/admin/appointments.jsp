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
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-styles.css" />
    <style>
      .card-appointments {
        background: white;
        border-radius: var(--border-radius);
        border: none;
        box-shadow: var(--card-shadow);
        margin-bottom: 1.5rem;
      }
      
      .card-appointments:hover {
        box-shadow: 0 0.75rem 1.5rem rgba(0, 0, 0, 0.12);
        transform: translateY(-3px);
        transition: all 0.3s ease;
      }
      
      .badge.status-badge {
        font-size: 0.75rem;
        padding: 0.4rem 0.75rem;
        border-radius: 50rem;
        font-weight: 500;
      }
      
      .badge.bg-scheduled {
        background-color: var(--primary-color);
      }
      
      .badge.bg-completed {
        background-color: var(--success-color);
      }
      
      .badge.bg-cancelled {
        background-color: var(--danger-color);
      }
      
      .badge.bg-pending {
        background-color: var(--warning-color);
      }
      
      .filter-controls {
        background-color: rgba(0, 0, 0, 0.02);
        border-radius: 0.5rem;
        padding: 1rem;
        margin-bottom: 1.5rem;
      }
      
      .btn-icon {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 32px;
        height: 32px;
        padding: 0;
        border-radius: 50%;
      }
      
      .table>:not(caption)>*>* {
        padding: 0.75rem 1rem;
      }
      
      .appointment-description {
        background-color: rgba(0, 0, 0, 0.02);
        border-radius: 0.5rem;
        padding: 1rem;
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
          <!-- Breadcrumb -->
          <nav aria-label="breadcrumb" class="mt-3">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
              <li class="breadcrumb-item active" aria-current="page">Appointments</li>
            </ol>
          </nav>

          <div class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center">
            <h1 class="page-title">Manage Appointments</h1>
            <div class="btn-toolbar">
              <button class="btn btn-sm btn-outline-primary me-2" id="filterBtn">
                <i class="bi bi-funnel me-1"></i> Filter
              </button>
              <button class="btn btn-sm btn-outline-secondary" id="exportBtn">
                <i class="bi bi-download me-1"></i> Export
              </button>
            </div>
          </div>

          <!-- Status Messages -->
          <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
              <i class="bi bi-check-circle-fill me-2"></i>
              ${sessionScope.successMessage}
              <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="successMessage" scope="session" />
          </c:if>
          
          <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
              <i class="bi bi-exclamation-triangle-fill me-2"></i>
              ${sessionScope.errorMessage}
              <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session" />
          </c:if>

          <!-- Appointments Table -->
          <div class="card-appointments">
            <div class="card-body">
              <div class="filter-controls" style="display: none;">
                <div class="row">
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
                  <div class="col-md-6 d-flex align-items-end">
                    <button type="button" class="btn btn-sm btn-primary me-2" id="applyFilter">
                      <i class="bi bi-check-lg me-1"></i> Apply Filter
                    </button>
                    <button type="button" class="btn btn-sm btn-outline-secondary" id="resetFilter">
                      <i class="bi bi-arrow-counterclockwise me-1"></i> Reset
                    </button>
                  </div>
                </div>
              </div>
            
              <c:if test="${empty appointments}">
                <div class="alert alert-info mb-0">
                  <i class="bi bi-info-circle-fill me-2"></i>
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
                          <td>
                            <div class="d-flex align-items-center">
                              <div class="avatar-circle me-2 d-flex align-items-center justify-content-center bg-light">
                                <i class="bi bi-person text-primary"></i>
                              </div>
                              ${appointment.studentName}
                            </div>
                          </td>
                          <td>
                            <div class="d-flex align-items-center">
                              <div class="avatar-circle me-2 d-flex align-items-center justify-content-center bg-light">
                                <i class="bi bi-people text-primary"></i>
                              </div>
                              ${appointment.parentName}
                            </div>
                          </td>
                          <td>
                            <div class="d-flex align-items-center">
                              <div class="avatar-circle me-2 d-flex align-items-center justify-content-center bg-light">
                                <i class="bi bi-person-badge text-primary"></i>
                              </div>
                              ${appointment.teacherName}
                            </div>
                          </td>
                          <td>
                            <span class="badge status-badge 
                              <c:choose>
                                <c:when test="${appointment.status eq 'Scheduled'}">bg-scheduled</c:when>
                                <c:when test="${appointment.status eq 'Completed'}">bg-completed</c:when>
                                <c:when test="${appointment.status eq 'Cancelled'}">bg-cancelled</c:when>
                                <c:when test="${appointment.status eq 'Pending'}">bg-pending</c:when>
                                <c:otherwise>bg-secondary</c:otherwise>
                              </c:choose>">
                              ${appointment.status}
                            </span>
                          </td>
                          <td>
                            <button type="button" class="btn btn-icon btn-primary" 
                                    data-bs-toggle="modal" data-bs-target="#viewAppointmentModal"
                                    data-appointment-id="${appointment.appointmentId}"
                                    title="View Details">
                              <i class="bi bi-eye"></i>
                            </button>
                            <button type="button" class="btn btn-icon btn-success"
                                    data-bs-toggle="modal" data-bs-target="#updateStatusModal"
                                    data-appointment-id="${appointment.appointmentId}"
                                    data-current-status="${appointment.status}"
                                    title="Update Status">
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
                <p><strong>Status:</strong> <span id="modal-status" class="badge status-badge"></span></p>
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
                <p id="modal-description" class="appointment-description"></p>
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
          <form action="${pageContext.request.contextPath}/admin/appointments" method="post" class="needs-validation" novalidate>
            <div class="modal-body">
              <input type="hidden" id="appointmentId" name="appointmentId" value="">
              
              <div class="mb-3">
                <label for="status" class="form-label required-field">Status</label>
                <select class="form-select" id="status" name="status" required>
                  <option value="Scheduled">Scheduled</option>
                  <option value="Completed">Completed</option>
                  <option value="Cancelled">Cancelled</option>
                  <option value="Pending">Pending</option>
                </select>
                <div class="invalid-feedback">
                  Please select a status.
                </div>
              </div>
              
              <div class="mb-3">
                <label for="notes" class="form-label">Notes</label>
                <textarea class="form-control" id="notes" name="notes" rows="3"></textarea>
              </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                <i class="bi bi-x-circle me-1"></i> Cancel
              </button>
              <button type="submit" class="btn btn-primary">
                <i class="bi bi-check2-circle me-1"></i> Update Status
              </button>
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
          filterControls.style.display = 'block';
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
        document.getElementById('modal-student').textContent = cells[3].textContent.trim();
        document.getElementById('modal-parent').textContent = cells[4].textContent.trim();
        document.getElementById('modal-teacher').textContent = cells[5].textContent.trim();
        
        // Set status with appropriate class
        const statusElement = document.getElementById('modal-status');
        const statusText = cells[6].querySelector('.badge').textContent.trim();
        statusElement.textContent = statusText;
        
        // Set appropriate class based on status
        statusElement.className = 'badge status-badge';
        if (statusText === 'Scheduled') {
          statusElement.classList.add('bg-scheduled');
        } else if (statusText === 'Completed') {
          statusElement.classList.add('bg-completed');
        } else if (statusText === 'Cancelled') {
          statusElement.classList.add('bg-cancelled');
        } else if (statusText === 'Pending') {
          statusElement.classList.add('bg-pending');
        } else {
          statusElement.classList.add('bg-secondary');
        }
        
        // This would normally come from the AJAX call
        document.getElementById('modal-description').textContent = "Loading description...";
        
        // Simulate AJAX call to get full appointment details
        setTimeout(function() {
          // In a real implementation, this would be replaced with actual data from the server
          document.getElementById('modal-description').textContent = "This is a placeholder description for appointment #" + appointmentId;
        }, 500);
      });
      
      // Form validation
      (function() {
        'use strict'
        
        // Fetch all forms we want to apply validation styles to
        var forms = document.querySelectorAll('.needs-validation')
        
        // Loop over them and prevent submission
        Array.prototype.slice.call(forms)
          .forEach(function(form) {
            form.addEventListener('submit', function(event) {
              if (!form.checkValidity()) {
                event.preventDefault()
                event.stopPropagation()
              }
              
              form.classList.add('was-validated')
            }, false)
          })
      })()
    </script>
  </body>
</html> 