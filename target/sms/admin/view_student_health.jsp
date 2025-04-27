<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Student Health Records - School Management System</title>
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

      .card-icon {
        font-size: 2.5rem;
        margin-bottom: 1rem;
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
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/courses">
                  <i class="bi bi-book me-2"></i> Courses
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/doctors">
                  <i class="bi bi-heart-pulse me-2"></i> Doctors
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/nurses">
                  <i class="bi bi-bandaid me-2"></i> Nurses
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link active text-white" href="${pageContext.request.contextPath}/admin/health-records">
                  <i class="bi bi-journal-medical me-2"></i> Health Records
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/announcements">
                  <i class="bi bi-megaphone me-2"></i> Announcements
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/settings">
                  <i class="bi bi-gear me-2"></i> Settings
                </a>
              </li>
              <li class="nav-item mt-5">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/logout">
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
            <h1 class="h2">Student Health Records</h1>
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

          <!-- Student Selection -->
          <div class="row mb-4">
            <div class="col-md-12">
              <div class="card dashboard-card">
                <div class="card-body">
                  <form action="${pageContext.request.contextPath}/admin/view-student-health" method="get" class="row g-3 align-items-center">
                    <div class="col-md-6">
                      <label for="studentSelect" class="form-label">Select Student</label>
                      <select name="studentId" id="studentSelect" class="form-select" onchange="this.form.submit()">
                        <option value="">Select a student</option>
                        <c:forEach var="student" items="${allStudents}">
                          <option value="${student.id}" <c:if test="${selectedStudent.id == student.id}">selected</c:if>>
                            ${student.firstName} ${student.lastName} (${student.grade})
                          </option>
                        </c:forEach>
                      </select>
                    </div>
                    <div class="col-md-6">
                      <c:if test="${selectedStudent != null}">
                        <div class="alert alert-info mb-0">
                          <strong>Selected Student:</strong> ${selectedStudent.firstName} ${selectedStudent.lastName} | 
                          <strong>Grade:</strong> ${selectedStudent.grade} | 
                          <strong>ID:</strong> ${selectedStudent.regNumber}
                        </div>
                      </c:if>
                    </div>
                  </form>
                </div>
              </div>
            </div>
          </div>

          <c:if test="${selectedStudent != null}">
            <!-- Health Summary -->
            <div class="row mb-4">
              <div class="col-md-12">
                <div class="card dashboard-card">
                  <div class="card-header bg-white">
                    <h5 class="card-title mb-0">Health Summary</h5>
                  </div>
                  <div class="card-body">
                    <div class="row">
                      <div class="col-md-4 text-center mb-4">
                        <div class="border rounded p-3">
                          <h2 class="text-primary mb-0">${healthStats.totalDiagnoses}</h2>
                          <p class="text-muted mb-0">Total Diagnoses</p>
                        </div>
                      </div>
                      <div class="col-md-4 text-center mb-4">
                        <div class="border rounded p-3">
                          <h2 class="text-info mb-0">${healthStats.pendingFollowUps}</h2>
                          <p class="text-muted mb-0">Pending Follow-ups</p>
                        </div>
                      </div>
                      <div class="col-md-4 text-center mb-4">
                        <div class="border rounded p-3">
                          <h2 class="text-success mb-0">${healthStats.lastVisitDays} days ago</h2>
                          <p class="text-muted mb-0">Last Clinic Visit</p>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Health Records -->
            <div class="row">
              <div class="col-md-12 mb-4">
                <div class="card dashboard-card">
                  <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0">Diagnosis History</h5>
                    <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#addDiagnosisModal">
                      <i class="bi bi-plus-circle me-1"></i> Add Diagnosis
                    </button>
                  </div>
                  <div class="card-body">
                    <div class="table-responsive">
                      <table class="table table-hover">
                        <thead>
                          <tr>
                            <th>Date</th>
                            <th>Symptoms</th>
                            <th>Diagnosis</th>
                            <th>Treatment</th>
                            <th>Diagnosed By</th>
                            <th>Follow-up Date</th>
                            <th>Actions</th>
                          </tr>
                        </thead>
                        <tbody>
                          <c:forEach var="record" items="${diagnosisRecords}">
                            <tr>
                              <td><fmt:formatDate value="${record.diagnosisDate}" pattern="MMM dd, yyyy" /></td>
                              <td>${record.symptoms}</td>
                              <td>${record.diagnosis}</td>
                              <td>${record.treatment}</td>
                              <td>
                                <c:choose>
                                  <c:when test="${record.doctorName != null}">
                                    Dr. ${record.doctorName}
                                  </c:when>
                                  <c:when test="${record.nurseName != null}">
                                    Nurse ${record.nurseName}
                                  </c:when>
                                  <c:otherwise>
                                    Unknown
                                  </c:otherwise>
                                </c:choose>
                              </td>
                              <td>
                                <c:if test="${record.followUpDate != null}">
                                  <fmt:formatDate value="${record.followUpDate}" pattern="MMM dd, yyyy" />
                                </c:if>
                                <c:if test="${record.followUpDate == null}">
                                  None
                                </c:if>
                              </td>
                              <td>
                                <button type="button" class="btn btn-sm btn-outline-primary me-1" 
                                        onclick="viewDetails(${record.diagnosisId})">
                                  <i class="bi bi-eye"></i>
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-danger" 
                                        onclick="confirmDelete(${record.diagnosisId})">
                                  <i class="bi bi-trash"></i>
                                </button>
                              </td>
                            </tr>
                          </c:forEach>
                          <c:if test="${empty diagnosisRecords}">
                            <tr>
                              <td colspan="7" class="text-center">No health records available</td>
                            </tr>
                          </c:if>
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            
            <!-- Add Diagnosis Modal -->
            <div class="modal fade" id="addDiagnosisModal" tabindex="-1" aria-labelledby="addDiagnosisModalLabel" aria-hidden="true">
              <div class="modal-dialog modal-lg">
                <div class="modal-content">
                  <div class="modal-header">
                    <h5 class="modal-title" id="addDiagnosisModalLabel">Add New Diagnosis</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    <form action="${pageContext.request.contextPath}/admin/add-diagnosis" method="post" id="diagnosisForm">
                      <input type="hidden" name="studentId" value="${selectedStudent.id}">
                      
                      <div class="mb-3">
                        <label for="diagnosisDate" class="form-label">Diagnosis Date</label>
                        <input type="date" class="form-control" id="diagnosisDate" name="diagnosisDate" required value="${currentDate}">
                      </div>
                      
                      <div class="mb-3">
                        <label for="symptoms" class="form-label">Symptoms</label>
                        <textarea class="form-control" id="symptoms" name="symptoms" rows="2" required></textarea>
                      </div>
                      
                      <div class="mb-3">
                        <label for="diagnosis" class="form-label">Diagnosis</label>
                        <textarea class="form-control" id="diagnosis" name="diagnosis" rows="2" required></textarea>
                      </div>
                      
                      <div class="mb-3">
                        <label for="treatment" class="form-label">Treatment</label>
                        <textarea class="form-control" id="treatment" name="treatment" rows="2" required></textarea>
                      </div>
                      
                      <div class="row">
                        <div class="col-md-6 mb-3">
                          <label for="doctorId" class="form-label">Doctor</label>
                          <select class="form-select" id="doctorId" name="doctorId">
                            <option value="">Select Doctor (if applicable)</option>
                            <c:forEach var="doctor" items="${doctors}">
                              <option value="${doctor.id}">Dr. ${doctor.firstName} ${doctor.lastName}</option>
                            </c:forEach>
                          </select>
                        </div>
                        
                        <div class="col-md-6 mb-3">
                          <label for="nurseId" class="form-label">Nurse</label>
                          <select class="form-select" id="nurseId" name="nurseId">
                            <option value="">Select Nurse (if applicable)</option>
                            <c:forEach var="nurse" items="${nurses}">
                              <option value="${nurse.id}">${nurse.firstName} ${nurse.lastName}</option>
                            </c:forEach>
                          </select>
                        </div>
                      </div>
                      
                      <div class="mb-3">
                        <label for="followUpDate" class="form-label">Follow-up Date (if needed)</label>
                        <input type="date" class="form-control" id="followUpDate" name="followUpDate">
                      </div>
                    </form>
                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" form="diagnosisForm" class="btn btn-primary">Save Diagnosis</button>
                  </div>
                </div>
              </div>
            </div>
          </c:if>

          <c:if test="${selectedStudent == null && allStudents != null && not empty allStudents}">
            <div class="alert alert-info">
              <i class="bi bi-info-circle me-2"></i>
              Please select a student from the dropdown above to view their health records.
            </div>
          </c:if>

          <c:if test="${allStudents == null || empty allStudents}">
            <div class="alert alert-warning">
              <i class="bi bi-exclamation-triangle me-2"></i>
              No students found in the system. Please add students first.
            </div>
          </c:if>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
      function viewDetails(diagnosisId) {
        // View details functionality
        window.location.href = '${pageContext.request.contextPath}/admin/diagnosis-details?id=' + diagnosisId;
      }
      
      function confirmDelete(diagnosisId) {
        if (confirm('Are you sure you want to delete this diagnosis record?')) {
          window.location.href = '${pageContext.request.contextPath}/admin/delete-diagnosis?id=' + diagnosisId;
        }
      }
    </script>
  </body>
</html> 