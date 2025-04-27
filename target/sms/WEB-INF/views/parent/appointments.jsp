<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Book Appointments - School Management System</title>
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
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/parent/dashboard">
                  <i class="bi bi-speedometer2 me-2"></i> Dashboard
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/parent/student-progress">
                  <i class="bi bi-people me-2"></i> My Children
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/parent/student-progress">
                  <i class="bi bi-card-checklist me-2"></i> Academic Progress
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/parent/announcements">
                  <i class="bi bi-megaphone me-2"></i> Announcements
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link active text-white" href="${pageContext.request.contextPath}/parent/appointments">
                  <i class="bi bi-calendar-check me-2"></i> Book Appointments
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="#">
                  <i class="bi bi-person me-2"></i> Profile
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
            <h1 class="h2">Book Appointments</h1>
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

          <!-- Book Appointment Form -->
          <div class="row mb-4">
            <div class="col-md-12">
              <div class="card dashboard-card">
                <div class="card-header bg-white">
                  <h5 class="card-title mb-0">Schedule a New Appointment</h5>
                </div>
                <div class="card-body">
                  <form action="${pageContext.request.contextPath}/parent/appointments" method="post" class="row g-3">
                    <div class="col-md-6">
                      <label for="staffType" class="form-label">Staff Type</label>
                      <select id="staffType" name="staffType" class="form-select" required onchange="loadStaffMembers()">
                        <option value="">Select Staff Type</option>
                        <option value="teacher">Teacher</option>
                        <option value="admin">Administrator</option>
                      </select>
                    </div>
                    
                    <div class="col-md-6">
                      <label for="staffId" class="form-label">Staff Member</label>
                      <select id="staffId" name="staffId" class="form-select" required disabled>
                        <option value="">Select Staff Type First</option>
                      </select>
                    </div>
                    
                    <div class="col-md-6">
                      <label for="studentId" class="form-label">Child</label>
                      <select id="studentId" name="studentId" class="form-select" required>
                        <option value="">Select Child</option>
                        <c:forEach var="child" items="${children}">
                          <option value="${child.studentId}">${child.fullName} (${child.grade})</option>
                        </c:forEach>
                      </select>
                    </div>
                    
                    <div class="col-md-6">
                      <label for="appointmentDate" class="form-label">Date</label>
                      <input type="date" class="form-control" id="appointmentDate" name="appointmentDate" required 
                             min="<fmt:formatDate value='${now}' pattern='yyyy-MM-dd'/>"
                             max="<fmt:formatDate value='${oneMonthLater}' pattern='yyyy-MM-dd'/>">
                    </div>
                    
                    <div class="col-md-6">
                      <label for="appointmentTime" class="form-label">Time</label>
                      <select id="appointmentTime" name="appointmentTime" class="form-select" required>
                        <option value="">Select Time</option>
                        <option value="08:00">8:00 AM</option>
                        <option value="09:00">9:00 AM</option>
                        <option value="10:00">10:00 AM</option>
                        <option value="11:00">11:00 AM</option>
                        <option value="12:00">12:00 PM</option>
                        <option value="13:00">1:00 PM</option>
                        <option value="14:00">2:00 PM</option>
                        <option value="15:00">3:00 PM</option>
                        <option value="16:00">4:00 PM</option>
                      </select>
                    </div>
                    
                    <div class="col-md-6">
                      <label for="purpose" class="form-label">Purpose</label>
                      <select id="purpose" name="purpose" class="form-select" required>
                        <option value="">Select Purpose</option>
                        <option value="Academic Performance">Academic Performance</option>
                        <option value="Behavior Issues">Behavior Issues</option>
                        <option value="Attendance">Attendance</option>
                        <option value="Special Needs">Special Needs</option>
                        <option value="General Discussion">General Discussion</option>
                        <option value="Other">Other</option>
                      </select>
                    </div>
                    
                    <div class="col-12 mt-4">
                      <button type="submit" class="btn btn-primary">
                        <i class="bi bi-calendar-plus me-2"></i>Book Appointment
                      </button>
                      <button type="reset" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-clockwise me-2"></i>Reset Form
                      </button>
                    </div>
                  </form>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Existing Appointments List -->
          <div class="row">
            <div class="col-md-12 mb-4">
              <div class="card dashboard-card">
                <div class="card-header bg-white">
                  <h5 class="card-title mb-0">Your Appointments</h5>
                </div>
                <div class="card-body">
                  <c:if test="${empty appointments}">
                    <div class="alert alert-info mb-0">
                      <i class="bi bi-info-circle me-2"></i>
                      You have no scheduled appointments yet.
                    </div>
                  </c:if>
                  
                  <c:if test="${not empty appointments}">
                    <div class="table-responsive">
                      <table class="table table-hover">
                        <thead>
                          <tr>
                            <th>Date & Time</th>
                            <th>Child</th>
                            <th>Staff Member</th>
                            <th>Purpose</th>
                            <th>Status</th>
                            <th>Notes</th>
                          </tr>
                        </thead>
                        <tbody>
                          <c:forEach var="appointment" items="${appointments}">
                            <tr>
                              <td>
                                <fmt:formatDate value="${appointment.appointmentDate}" pattern="MMM d, yyyy"/> <br>
                                <small class="text-muted">
                                  <fmt:formatDate value="${appointment.appointmentTime}" pattern="h:mm a"/>
                                </small>
                              </td>
                              <td>${appointment.studentName}</td>
                              <td>
                                ${appointment.staffName} <br>
                                <small class="text-muted">${appointment.staffRole}</small>
                              </td>
                              <td>${appointment.purpose}</td>
                              <td>
                                <span class="badge 
                                  <c:choose>
                                    <c:when test="${appointment.status == 'confirmed'}">bg-success</c:when>
                                    <c:when test="${appointment.status == 'pending'}">bg-warning</c:when>
                                    <c:when test="${appointment.status == 'cancelled'}">bg-danger</c:when>
                                    <c:when test="${appointment.status == 'completed'}">bg-info</c:when>
                                    <c:otherwise>bg-secondary</c:otherwise>
                                  </c:choose> status-badge">
                                  ${appointment.status}
                                </span>
                              </td>
                              <td>
                                <c:if test="${not empty appointment.notes}">
                                  ${appointment.notes}
                                </c:if>
                                <c:if test="${empty appointment.notes}">
                                  -
                                </c:if>
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

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
      // Function to load staff members based on selection
      function loadStaffMembers() {
        const staffType = document.getElementById('staffType').value;
        const staffSelect = document.getElementById('staffId');
        
        // Clear previous options
        staffSelect.innerHTML = '<option value="">Select Staff Member</option>';
        
        if (staffType === '') {
          staffSelect.disabled = true;
          return;
        }
        
        staffSelect.disabled = false;
        
        // Load appropriate staff options
        if (staffType === 'teacher') {
          <c:forEach var="teacher" items="${teachers}">
            const option = document.createElement('option');
            option.value = ${teacher.teacherId};
            option.textContent = '${teacher.fullName} - ${teacher.subject}';
            staffSelect.appendChild(option);
          </c:forEach>
        } else if (staffType === 'admin') {
          <c:forEach var="admin" items="${adminStaff}">
            const option = document.createElement('option');
            option.value = ${admin.adminId};
            option.textContent = '${admin.fullName} - ${admin.designation}';
            staffSelect.appendChild(option);
          </c:forEach>
        }
      }
      
      // Set minimum date for appointment to today
      document.addEventListener('DOMContentLoaded', function() {
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('appointmentDate').setAttribute('min', today);
      });
    </script>
  </body>
</html> 