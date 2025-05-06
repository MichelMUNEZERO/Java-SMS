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
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
      rel="stylesheet"
    />
    
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-styles.css">
    
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fc;
        }
        
        .content-card {
            transition: transform 0.3s;
            border-radius: 0.75rem;
            border: none;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            margin-bottom: 1.5rem;
        }
        
        .content-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0.3rem 2rem rgba(0, 0, 0, 0.1);
        }
        
        .card-header {
            background-color: white;
            border-bottom: 1px solid #e9ecef;
            padding: 1rem 1.5rem;
            font-weight: 500;
        }
        
        .health-record-table {
            font-size: 0.9rem;
        }
        
        .student-profile-header {
            background: linear-gradient(to right, #4e73df, #224abe);
            border-radius: 0.75rem;
            padding: 2rem;
            margin-bottom: 1.5rem;
            color: white;
            position: relative;
            overflow: hidden;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        }
        
        .student-profile-header::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('${pageContext.request.contextPath}/images/pattern-bg.png') repeat;
            opacity: 0.1;
        }
        
        .student-profile-content {
            position: relative;
            z-index: 1;
        }
        
        .student-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid white;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }
        
        .student-info {
            background-color: white;
            border-radius: 0.75rem;
            padding: 1.5rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            height: 100%;
        }
        
        .info-label {
            color: #6c757d;
            font-size: 0.875rem;
            margin-bottom: 0.25rem;
        }
        
        .info-value {
            font-weight: 500;
            margin-bottom: 1rem;
        }
        
        .btn-primary {
            background-color: #4e73df;
            border-color: #4e73df;
        }
        
        .btn-primary:hover {
            background-color: #4262c5;
            border-color: #3d5cb8;
        }
        
        .badge {
            font-weight: 600;
            font-size: 0.75rem;
            padding: 0.35em 0.65em;
        }
        
        .breadcrumb {
            background-color: transparent;
            padding: 0;
        }
        
        .breadcrumb-item a {
            color: #4e73df;
            text-decoration: none;
        }
        
        .page-title {
            font-weight: 600;
            color: #5a5c69;
            margin-bottom: 1rem;
        }
        
        .record-status-pill {
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-weight: 500;
            display: inline-block;
            margin-bottom: 1rem;
        }
        
        .record-action-btn {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .health-metrics {
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 0.75rem;
            padding: 1rem;
            margin-top: 1rem;
        }
        
        .health-metric-item {
            text-align: center;
            padding: 0.5rem;
        }
        
        .health-metric-value {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 0.25rem;
        }
        
        .health-metric-label {
            font-size: 0.75rem;
            opacity: 0.8;
        }
        
        .tab-content {
            padding: 1.5rem;
        }
        
        .record-timeline {
            position: relative;
            padding-left: 2rem;
            margin-bottom: 1.5rem;
        }
        
        .record-timeline::before {
            content: "";
            position: absolute;
            left: 7px;
            top: 0;
            height: 100%;
            width: 2px;
            background-color: #e3e6f0;
        }
        
        .timeline-item {
            position: relative;
            margin-bottom: 1.5rem;
        }
        
        .timeline-item::before {
            content: "";
            position: absolute;
            left: -2rem;
            top: 0.25rem;
            width: 16px;
            height: 16px;
            border-radius: 50%;
            background-color: #4e73df;
            z-index: 1;
        }
        
        .timeline-date {
            font-size: 0.875rem;
            color: #6c757d;
            margin-bottom: 0.5rem;
        }
        
        .timeline-content {
            background-color: white;
            border-radius: 0.75rem;
            padding: 1rem;
            box-shadow: 0 0.15rem 0.5rem rgba(58, 59, 69, 0.075);
        }
        
        .timeline-content h6 {
            margin-bottom: 0.5rem;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Include Doctor Sidebar -->
            <jsp:include page="/WEB-INF/includes/doctor-sidebar.jsp" />
            
            <!-- Main Content -->
            <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <!-- Breadcrumb -->
                <nav aria-label="breadcrumb" class="mt-3">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/dashboard">Home</a>
                        </li>
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/doctor/dashboard">Doctor Dashboard</a>
                        </li>
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/doctor/students">Student Records</a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">
                            Health Record
                        </li>
                    </ol>
                </nav>

                <div class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center">
                    <h1 class="page-title">Student Health Record</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <button type="button" class="btn btn-primary me-2" data-bs-toggle="modal" data-bs-target="#addHealthRecordModal">
                            <i class="bi bi-plus-circle me-1"></i> New Record
                        </button>
                        <div class="dropdown ms-2">
                            <button
                                class="btn btn-outline-secondary dropdown-toggle d-flex align-items-center"
                                type="button"
                                id="dropdownMenuLink"
                                data-bs-toggle="dropdown"
                                aria-expanded="false"
                            >
                                <c:choose>
                                    <c:when test="${not empty user.imageLink}">
                                        <img src="${user.imageLink}" alt="${user.username}" class="profile-img me-2" style="width: 32px; height: 32px;">
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-person-circle me-1"></i>
                                    </c:otherwise>
                                </c:choose>
                                <span>Dr. ${user.username}</span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenuLink">
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/doctor/profile">
                                        <i class="bi bi-person me-2"></i> Profile
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider" /></li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                        <i class="bi bi-box-arrow-right me-2"></i> Logout
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                
                <!-- Alerts -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <c:if test="${not empty message}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                
                <!-- Student Profile Header -->
                <div class="student-profile-header">
                    <div class="student-profile-content">
                        <div class="row align-items-center">
                            <div class="col-md-auto text-center text-md-start mb-3 mb-md-0">
                                <div class="bg-white rounded-circle d-inline-flex align-items-center justify-content-center" style="width: 120px; height: 120px;">
                                    <i class="bi bi-person-fill text-primary" style="font-size: 3.5rem"></i>
                                </div>
                            </div>
                            <div class="col-md">
                                <h2 class="mb-1 fw-bold">${student.firstName} ${student.lastName}</h2>
                                <p class="text-white-50 mb-2">Student ID: ${student.id} • Grade: ${student.grade}</p>
                                <div class="d-flex flex-wrap gap-3 mt-3">
                                    <div class="d-flex align-items-center">
                                        <i class="bi bi-envelope-fill me-2"></i>
                                        <span>${student.email}</span>
                                    </div>
                                    <div class="d-flex align-items-center">
                                        <i class="bi bi-telephone-fill me-2"></i>
                                        <span>${student.phone}</span>
                                    </div>
                                </div>
                                
                                <!-- Health Metrics Row -->
                                <div class="health-metrics row mt-4">
                                    <div class="col-auto health-metric-item">
                                        <div class="health-metric-value">
                                            <c:if test="${not empty student.bloodType}">
                                                ${student.bloodType}
                                            </c:if>
                                            <c:if test="${empty student.bloodType}">
                                                -
                                            </c:if>
                                        </div>
                                        <div class="health-metric-label">Blood Type</div>
                                    </div>
                                    <div class="col-auto health-metric-item">
                                        <div class="health-metric-value">
                                            <fmt:formatDate value="${student.dateOfBirth}" pattern="yyyy"/>
                                        </div>
                                        <div class="health-metric-label">Birth Year</div>
                                    </div>
                                    <div class="col-auto health-metric-item">
                                        <div class="health-metric-value">
                                            <c:if test="${not empty student.gender}">
                                                ${student.gender.substring(0,1)}
                                            </c:if>
                                            <c:if test="${empty student.gender}">
                                                -
                                            </c:if>
                                        </div>
                                        <div class="health-metric-label">Gender</div>
                                    </div>
                                    <div class="col-auto health-metric-item">
                                        <div class="health-metric-value">
                                            ${healthRecords.size()}
                                        </div>
                                        <div class="health-metric-label">Records</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Student Details & Records Section -->
                <div class="row">
                    <!-- Student Details -->
                    <div class="col-md-4 mb-4">
                        <div class="content-card h-100">
                            <div class="card-header">
                                <h5 class="mb-0">
                                    <i class="bi bi-person-lines-fill me-2 text-primary"></i>
                                    Student Information
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <div class="info-label">Date of Birth</div>
                                    <div class="info-value">
                                        <fmt:formatDate value="${student.dateOfBirth}" pattern="MMMM d, yyyy"/>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <div class="info-label">Gender</div>
                                    <div class="info-value">
                                        <c:if test="${not empty student.gender}">
                                            ${student.gender}
                                        </c:if>
                                        <c:if test="${empty student.gender}">
                                            Not specified
                                        </c:if>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <div class="info-label">Blood Type</div>
                                    <div class="info-value">
                                        <c:if test="${not empty student.bloodType}">
                                            ${student.bloodType}
                                        </c:if>
                                        <c:if test="${empty student.bloodType}">
                                            Not specified
                                        </c:if>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <div class="info-label">Allergies</div>
                                    <div class="info-value">
                                        <c:if test="${not empty student.allergies}">
                                            ${student.allergies}
                                        </c:if>
                                        <c:if test="${empty student.allergies}">
                                            None recorded
                                        </c:if>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <div class="info-label">Emergency Contact</div>
                                    <div class="info-value">
                                        <c:if test="${not empty student.emergencyContact}">
                                            ${student.emergencyContact}
                                        </c:if>
                                        <c:if test="${empty student.emergencyContact}">
                                            Not provided
                                        </c:if>
                                    </div>
                                </div>
                                
                                <div class="d-grid gap-2 mt-4">
                                    <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#updateStudentInfoModal">
                                        <i class="bi bi-pencil me-1"></i> Update Information
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Health Records -->
                    <div class="col-md-8 mb-4">
                        <div class="content-card h-100">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">
                                    <i class="bi bi-clipboard2-pulse me-2 text-primary"></i>
                                    Health Records
                                </h5>
                                <div>
                                    <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#addHealthRecordModal">
                                        <i class="bi bi-plus-circle me-1"></i> Add Record
                                    </button>
                                </div>
                            </div>
                            <div class="card-body p-0">
                                <c:choose>
                                    <c:when test="${not empty healthRecords}">
                                        <div class="record-timeline p-4">
                                            <c:forEach var="record" items="${healthRecords}">
                                                <div class="timeline-item">
                                                    <div class="timeline-date">
                                                        <fmt:formatDate value="${record.recordDate}" pattern="MMMM d, yyyy"/>
                                                    </div>
                                                    <div class="timeline-content">
                                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                                            <h6 class="mb-0">
                                                                <span class="badge ${record.recordType eq 'Checkup' ? 'bg-primary' :
                                                                              record.recordType eq 'Illness' ? 'bg-warning' :
                                                                              record.recordType eq 'Injury' ? 'bg-danger' :
                                                                              record.recordType eq 'Vaccination' ? 'bg-success' : 'bg-secondary'}">
                                                                    ${record.recordType}
                                                                </span>
                                                                <span class="ms-2">${record.description}</span>
                                                            </h6>
                                                            <div class="d-flex gap-2">
                                                                <button class="btn btn-sm btn-outline-primary record-action-btn" title="Edit" data-bs-toggle="modal" data-bs-target="#editRecordModal${record.id}">
                                                                    <i class="bi bi-pencil"></i>
                                                                </button>
                                                                <button class="btn btn-sm btn-outline-danger record-action-btn" title="Delete" data-bs-toggle="modal" data-bs-target="#deleteRecordModal${record.id}">
                                                                    <i class="bi bi-trash"></i>
                                                                </button>
                                                            </div>
                                                        </div>
                                                        
                                                        <c:if test="${not empty record.treatment}">
                                                            <div class="mb-2">
                                                                <span class="fw-medium">Treatment:</span>
                                                                <span>${record.treatment}</span>
                                                            </div>
                                                        </c:if>
                                                        
                                                        <c:if test="${not empty record.medication}">
                                                            <div class="mb-2">
                                                                <span class="fw-medium">Medication:</span>
                                                                <span>${record.medication}</span>
                                                            </div>
                                                        </c:if>
                                                        
                                                        <div class="d-flex justify-content-between align-items-center mt-3">
                                                            <small class="text-muted">Recorded by: ${record.recordedBy}</small>
                                                            <c:if test="${not empty record.nextAppointment}">
                                                                <small class="text-primary">
                                                                    <i class="bi bi-calendar-event me-1"></i>
                                                                    Next Appointment: <fmt:formatDate value="${record.nextAppointment}" pattern="MMM d, yyyy"/>
                                                                </small>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-5">
                                            <i class="bi bi-clipboard-x text-muted mb-3" style="font-size: 2.5rem;"></i>
                                            <h5 class="text-muted">No Health Records</h5>
                                            <p class="text-muted mb-4">This student doesn't have any health records yet.</p>
                                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addHealthRecordModal">
                                                <i class="bi bi-plus-circle me-2"></i> Add First Record
                                            </button>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
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
                <div class="modal-body">
                    <form action="${pageContext.request.contextPath}/doctor/health-records/add" method="post">
                        <input type="hidden" name="studentId" value="${student.id}">
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="recordDate" class="form-label">Record Date</label>
                                <input type="date" class="form-control" id="recordDate" name="recordDate" value="<fmt:formatDate value='${now}' pattern='yyyy-MM-dd'/>" required>
                            </div>
                            <div class="col-md-6">
                                <label for="recordType" class="form-label">Record Type</label>
                                <select class="form-select" id="recordType" name="recordType" required>
                                    <option value="Checkup">Checkup</option>
                                    <option value="Illness">Illness</option>
                                    <option value="Injury">Injury</option>
                                    <option value="Vaccination">Vaccination</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="description" class="form-label">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="treatment" class="form-label">Treatment</label>
                                <textarea class="form-control" id="treatment" name="treatment" rows="3"></textarea>
                            </div>
                            <div class="col-md-6">
                                <label for="medication" class="form-label">Medication</label>
                                <textarea class="form-control" id="medication" name="medication" rows="3"></textarea>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="nextAppointment" class="form-label">Next Appointment (if needed)</label>
                            <input type="date" class="form-control" id="nextAppointment" name="nextAppointment">
                        </div>
                        
                        <div class="text-end mt-4">
                            <button type="button" class="btn btn-outline-secondary me-2" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Save Record</button>
                        </div>
                    </form>
                </div>
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
        document.addEventListener('DOMContentLoaded', function() {
            // Add animation to cards
            const cards = document.querySelectorAll('.content-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                setTimeout(() => {
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, 100 * index);
            });
        });
    </script>
</body>
</html> 