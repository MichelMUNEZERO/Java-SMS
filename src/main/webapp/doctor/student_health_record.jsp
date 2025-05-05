<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Health Record - School Management System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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
        
        .health-record-table {
            font-size: 0.9rem;
        }
        
        .doctor-profile {
            display: flex;
            align-items: center;
            padding: 1rem;
        }
        
        .doctor-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 10px;
        }
        
        .student-profile-header {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .student-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav id="sidebar" class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse" style="min-height: 100vh">
                <div class="position-sticky pt-3">
                    <div class="d-flex align-items-center justify-content-center mb-4">
                        <img src="${pageContext.request.contextPath}/images/school-logo.png" alt="School Logo" width="50" class="me-2">
                        <span class="fs-4 text-white">School MS</span>
                    </div>
                    
                    <!-- Doctor Profile Widget -->
                    <div class="doctor-profile bg-dark text-white mb-3 text-center">
                        <c:choose>
                            <c:when test="${not empty user.imageLink}">
                                <img src="${user.imageLink}" alt="Doctor Avatar" class="doctor-avatar mx-auto d-block mb-2">
                            </c:when>
                            <c:otherwise>
                                <div class="bg-secondary rounded-circle mx-auto mb-2" style="width: 50px; height: 50px; display: flex; align-items: center; justify-content: center;">
                                    <i class="bi bi-person text-white" style="font-size: 1.5rem"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div>
                            <span class="d-block">Dr. ${user.username}</span>
                            <small class="text-muted">${user.email}</small>
                        </div>
                    </div>
                    
                    <hr class="text-white">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/doctor/dashboard">
                                <i class="bi bi-speedometer2 me-2"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active text-white" href="${pageContext.request.contextPath}/doctor/students">
                                <i class="bi bi-person-vcard me-2"></i> Student Health Records
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/doctor/appointments">
                                <i class="bi bi-calendar-check me-2"></i> Appointments
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/doctor/health-reports">
                                <i class="bi bi-graph-up me-2"></i> Health Reports
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/doctor/profile">
                                <i class="bi bi-person-circle me-2"></i> My Profile
                            </a>
                        </li>
                        <li class="nav-item mt-5">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/logout">
                                <i class="bi bi-box-arrow-right me-2"></i> Logout
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>
            
            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <!-- Navbar -->
                <header class="navbar navbar-light sticky-top bg-light flex-md-nowrap p-2 border-bottom">
                    <a class="navbar-brand col-md-3 col-lg-2 me-0 px-3" href="#">
                        <button class="btn btn-outline-secondary d-md-none" type="button" data-bs-toggle="collapse" data-bs-target="#sidebar">
                            <i class="bi bi-list"></i>
                        </button>
                        <span class="d-none d-md-inline">School Management System</span>
                    </a>
                    
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item">
                            <div class="dropdown">
                                <a class="nav-link dropdown-toggle text-dark" href="#" role="button" data-bs-toggle="dropdown">
                                    <i class="bi bi-person-circle me-1"></i>
                                    <span>Dr. ${user.username}</span>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/doctor/profile">
                                            <i class="bi bi-person me-2"></i>Profile
                                        </a>
                                    </li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                            <i class="bi bi-box-arrow-right me-2"></i>Logout
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </li>
                    </ul>
                </header>
                
                <!-- Page Content -->
                <div class="container-fluid mt-4 mb-5">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3">
                        <div>
                            <a href="${pageContext.request.contextPath}/doctor/students" class="btn btn-outline-secondary mb-3">
                                <i class="bi bi-arrow-left me-1"></i> Back to Students
                            </a>
                            <h2 class="h3">Student Health Record</h2>
                        </div>
                        <div>
                            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addHealthRecordModal">
                                <i class="bi bi-plus-circle me-1"></i> Add Health Record
                            </button>
                        </div>
                    </div>
                    
                    <!-- Student Profile -->
                    <div class="student-profile-header">
                        <div class="row">
                            <div class="col-md-2 text-center">
                                <!-- Fixed: Removed the check for student.imageLink property that doesn't exist -->
                                <div class="bg-secondary rounded-circle mx-auto mb-2" style="width: 100px; height: 100px; display: flex; align-items: center; justify-content: center;">
                                    <i class="bi bi-person text-white" style="font-size: 3rem"></i>
                                </div>
                            </div>
                            <div class="col-md-5">
                                <h4>${student.firstName} ${student.lastName}</h4>
                                <p class="text-muted mb-1">Student ID: ${student.id}</p>
                                <p class="mb-1"><i class="bi bi-envelope me-2"></i>${student.email}</p>
                                <p class="mb-1"><i class="bi bi-telephone me-2"></i>${student.phone}</p>
                            </div>
                            <div class="col-md-5">
                                <p class="mb-1"><strong>Date of Birth:</strong> <fmt:formatDate value="${student.dateOfBirth}" pattern="MMMM d, yyyy"/></p>
                                <c:if test="${not empty student.gender}">
                                    <p class="mb-1"><strong>Gender:</strong> ${student.gender}</p>
                                </c:if>
                                <c:if test="${not empty student.bloodType}">
                                    <p class="mb-1"><strong>Blood Type:</strong> ${student.bloodType}</p>
                                </c:if>
                                <c:if test="${empty student.bloodType}">
                                    <p class="mb-1"><strong>Blood Type:</strong> Not specified</p>
                                </c:if>
                                <c:if test="${not empty student.allergies}">
                                    <p class="mb-1"><strong>Allergies:</strong> ${student.allergies}</p>
                                </c:if>
                                <c:if test="${empty student.allergies}">
                                    <p class="mb-1"><strong>Allergies:</strong> None recorded</p>
                                </c:if>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Health Records List -->
                    <div class="card dashboard-card mb-4">
                        <div class="card-header bg-white">
                            <h5 class="card-title mb-0">Health Records</h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover health-record-table" id="healthRecordTable">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Date</th>
                                            <th>Type</th>
                                            <th>Description</th>
                                            <th>Treatment</th>
                                            <th>Medication</th>
                                            <th>Recorded By</th>
                                            <th>Next Appointment</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="record" items="${healthRecords}">
                                            <tr>
                                                <td><fmt:formatDate value="${record.recordDate}" pattern="MMM d, yyyy"/></td>
                                                <td>
                                                    <span class="badge ${record.recordType eq 'Checkup' ? 'bg-primary' :
                                                                      record.recordType eq 'Illness' ? 'bg-warning' :
                                                                      record.recordType eq 'Injury' ? 'bg-danger' :
                                                                      record.recordType eq 'Vaccination' ? 'bg-success' : 'bg-secondary'}">
                                                        ${record.recordType}
                                                    </span>
                                                </td>
                                                <td>${record.description}</td>
                                                <td>${record.treatment}</td>
                                                <td>${record.medication}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${record.doctorName != null}">
                                                            Dr. ${record.doctorName}
                                                        </c:when>
                                                        <c:when test="${record.nurseName != null}">
                                                            Nurse ${record.nurseName}
                                                        </c:when>
                                                        <c:otherwise>
                                                            -
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:if test="${record.nextAppointment != null}">
                                                        <fmt:formatDate value="${record.nextAppointment}" pattern="MMM d, yyyy"/>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <button type="button" class="btn btn-sm btn-outline-primary me-1" onclick="viewRecord('${record.recordId}')">
                                                        <i class="bi bi-eye"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-sm btn-outline-secondary" onclick="editRecord('${record.recordId}')">
                                                        <i class="bi bi-pencil"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        
                                        <c:if test="${empty healthRecords}">
                                            <tr>
                                                <td colspan="8" class="text-center">No health records found for this student</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
    
    <!-- Add Health Record Modal -->
    <div class="modal fade" id="addHealthRecordModal" tabindex="-1" aria-labelledby="addHealthRecordModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addHealthRecordModalLabel">Add Health Record</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/doctor/add-health-record" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="studentId" value="${student.id}">
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="recordDate" class="form-label">Record Date</label>
                                <input type="date" class="form-control" id="recordDate" name="recordDate" value="<fmt:formatDate value='${now}' pattern='yyyy-MM-dd'/>" required>
                            </div>
                            <div class="col-md-6">
                                <label for="recordType" class="form-label">Record Type</label>
                                <select class="form-select" id="recordType" name="recordType" required>
                                    <option value="">Select Type</option>
                                    <option value="Checkup">Checkup</option>
                                    <option value="Illness">Illness</option>
                                    <option value="Injury">Injury</option>
                                    <option value="Vaccination">Vaccination</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="description" class="form-label">Description/Symptoms</label>
                            <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label for="treatment" class="form-label">Treatment</label>
                            <textarea class="form-control" id="treatment" name="treatment" rows="2"></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label for="medication" class="form-label">Medication</label>
                            <textarea class="form-control" id="medication" name="medication" rows="2"></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label for="nextAppointment" class="form-label">Next Appointment Date (if needed)</label>
                            <input type="date" class="form-control" id="nextAppointment" name="nextAppointment">
                        </div>
                        
                        <div class="mb-3">
                            <label for="notes" class="form-label">Additional Notes</label>
                            <textarea class="form-control" id="notes" name="notes" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Record</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- DataTables -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Initialize DataTable
            $('#healthRecordTable').DataTable({
                "pageLength": 10,
                "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                "order": [[0, "desc"]] // Sort by date column in descending order
            });
        });
        
        // Function to view record details
        function viewRecord(recordId) {
            // This would be implemented to show a modal with record details
            alert("View record details for ID: " + recordId);
        }
        
        // Function to edit record
        function editRecord(recordId) {
            // This would be implemented to show an edit form
            alert("Edit record with ID: " + recordId);
        }
    </script>
</body>
</html> 