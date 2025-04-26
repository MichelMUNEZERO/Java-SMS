<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Details - School Management System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .card {
            border-radius: 10px;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            margin-bottom: 20px;
        }
        .profile-header {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 10px 10px 0 0;
        }
        .profile-img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 5px solid #fff;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }
        .profile-placeholder {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background-color: #6c757d;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: white;
            border: 5px solid #fff;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }
        .info-label {
            font-weight: bold;
            color: #6c757d;
        }
        .badge-section {
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse" style="min-height: 100vh">
                <div class="position-sticky pt-3">
                    <div class="d-flex align-items-center justify-content-center mb-4">
                        <img src="${pageContext.request.contextPath}/images/school-logo.png" alt="School Logo" width="50" class="me-2">
                        <span class="fs-4 text-white">School MS</span>
                    </div>
                    
                    <!-- Teacher Profile Widget -->
                    <div class="teacher-profile bg-dark text-white mb-3 text-center">
                        <c:choose>
                            <c:when test="${not empty profileData.imageLink}">
                                <img src="${profileData.imageLink}" alt="Teacher Avatar" class="teacher-avatar mx-auto d-block mb-2">
                            </c:when>
                            <c:otherwise>
                                <div class="bg-secondary rounded-circle mx-auto mb-2" style="width: 50px; height: 50px; display: flex; align-items: center; justify-content: center;">
                                    <i class="bi bi-person text-white" style="font-size: 1.5rem;"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div>
                            <span class="d-block">${user.username}</span>
                            <small class="text-muted">${user.email}</small>
                        </div>
                    </div>
                    
                    <hr class="text-white">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/teacher/dashboard">
                                <i class="bi bi-speedometer2 me-2"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/teacher/courses">
                                <i class="bi bi-book me-2"></i> My Courses
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active text-white" href="${pageContext.request.contextPath}/teacher/student">
                                <i class="bi bi-people me-2"></i> My Students
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/teacher/marks">
                                <i class="bi bi-card-checklist me-2"></i> Marks & Grades
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/teacher/behavior">
                                <i class="bi bi-clipboard-check me-2"></i> Student Behavior
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/teacher/reports">
                                <i class="bi bi-file-earmark-text me-2"></i> Reports
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/teacher/appointments">
                                <i class="bi bi-calendar-event me-2"></i> Appointments
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
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Student Details</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/teacher/student" class="btn btn-outline-secondary me-2">
                            <i class="bi bi-arrow-left me-1"></i> Back to Students
                        </a>
                        <a href="${pageContext.request.contextPath}/teacher/student/edit?id=${student.id}" class="btn btn-warning me-2">
                            <i class="bi bi-pencil me-1"></i> Edit Student
                        </a>
                        <a href="${pageContext.request.contextPath}/teacher/marks?studentId=${student.id}" class="btn btn-info me-2">
                            <i class="bi bi-award me-1"></i> Manage Marks
                        </a>
                        <a href="${pageContext.request.contextPath}/teacher/behavior?studentId=${student.id}" class="btn btn-secondary">
                            <i class="bi bi-clipboard-check me-1"></i> Behavior Notes
                        </a>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-4">
                        <!-- Student Profile Card -->
                        <div class="card">
                            <div class="profile-header d-flex align-items-center justify-content-center flex-column">
                                <c:choose>
                                    <c:when test="${not empty student.imageLink}">
                                        <img src="${student.imageLink}" alt="Student Photo" class="profile-img mb-3">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="profile-placeholder mb-3">
                                            <i class="bi bi-person-fill"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <h3 class="mb-0">${student.firstName} ${student.lastName}</h3>
                                <p class="text-muted">Student ID: ${student.id}</p>
                                <div class="badge-section">
                                    <span class="badge bg-${student.status eq 'active' ? 'success' : 'warning'}">
                                        ${student.status}
                                    </span>
                                    <span class="badge bg-primary">Grade ${student.className}</span>
                                </div>
                            </div>
                            <div class="card-body">
                                <h5 class="card-title border-bottom pb-2">Contact Information</h5>
                                <p><span class="info-label"><i class="bi bi-envelope me-2"></i>Email:</span> ${student.email}</p>
                                <p><span class="info-label"><i class="bi bi-telephone me-2"></i>Phone:</span> ${student.phone}</p>
                                <p><span class="info-label"><i class="bi bi-geo-alt me-2"></i>Address:</span> ${student.address}</p>
                                
                                <h5 class="card-title border-bottom pb-2 mt-4">Personal Information</h5>
                                <p><span class="info-label"><i class="bi bi-calendar me-2"></i>Date of Birth:</span> <fmt:formatDate value="${student.dateOfBirth}" pattern="MMMM dd, yyyy" /></p>
                                <p><span class="info-label"><i class="bi bi-calendar-check me-2"></i>Admission Date:</span> <fmt:formatDate value="${student.admissionDate}" pattern="MMMM dd, yyyy" /></p>
                                
                                <h5 class="card-title border-bottom pb-2 mt-4">Guardian Information</h5>
                                <p><span class="info-label"><i class="bi bi-person me-2"></i>Guardian:</span> ${not empty student.guardianName ? student.guardianName : 'Not available'}</p>
                                <p><span class="info-label"><i class="bi bi-telephone me-2"></i>Guardian Phone:</span> ${not empty student.guardianPhone ? student.guardianPhone : 'Not available'}</p>
                                <p><span class="info-label"><i class="bi bi-envelope me-2"></i>Guardian Email:</span> ${not empty student.guardianEmail ? student.guardianEmail : 'Not available'}</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-8">
                        <!-- Enrolled Courses -->
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Enrolled Courses</h5>
                            </div>
                            <div class="card-body">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Course Code</th>
                                            <th>Course Name</th>
                                            <th>Credits</th>
                                            <th>Teacher</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${enrolledCourses}" var="course">
                                            <tr>
                                                <td>${course.courseCode}</td>
                                                <td>${course.courseName}</td>
                                                <td>${course.credits}</td>
                                                <td>${course.teacherName}</td>
                                                <td>
                                                    <div class="btn-group">
                                                        <a href="${pageContext.request.contextPath}/teacher/course-details?id=${course.id}" class="btn btn-sm btn-info">
                                                            <i class="bi bi-eye"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/teacher/course-marks?id=${course.id}&studentId=${student.id}" class="btn btn-sm btn-warning">
                                                            <i class="bi bi-award"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty enrolledCourses}">
                                            <tr>
                                                <td colspan="5" class="text-center">Not enrolled in any courses</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                                <a href="${pageContext.request.contextPath}/teacher/student/enroll?id=${student.id}" class="btn btn-primary mt-2">
                                    <i class="bi bi-plus-circle me-1"></i> Enroll in New Course
                                </a>
                            </div>
                        </div>
                        
                        <!-- Academic Performance -->
                        <div class="card mt-4">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Academic Performance</h5>
                            </div>
                            <div class="card-body">
                                <div class="alert alert-info">
                                    <i class="bi bi-info-circle me-2"></i> Select a course from above to view detailed performance.
                                </div>
                                
                                <!-- Performance overview if data is available -->
                                <c:if test="${not empty performanceData}">
                                    <!-- Performance data visualization would go here -->
                                </c:if>
                            </div>
                        </div>
                        
                        <!-- Recent Behavior Notes -->
                        <div class="card mt-4">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Recent Behavior Notes</h5>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${not empty behaviorNotes}">
                                        <ul class="list-group">
                                            <c:forEach items="${behaviorNotes}" var="note" begin="0" end="2">
                                                <li class="list-group-item">
                                                    <div class="d-flex justify-content-between">
                                                        <strong>${note.title}</strong>
                                                        <span class="badge bg-${note.type eq 'positive' ? 'success' : note.type eq 'negative' ? 'danger' : 'warning'}">${note.type}</span>
                                                    </div>
                                                    <p class="mb-1">${note.description}</p>
                                                    <small class="text-muted">
                                                        <i class="bi bi-calendar me-1"></i> <fmt:formatDate value="${note.date}" pattern="MMM dd, yyyy" /> | 
                                                        <i class="bi bi-person me-1"></i> ${note.teacherName}
                                                    </small>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-muted">No behavior notes recorded</p>
                                    </c:otherwise>
                                </c:choose>
                                <a href="${pageContext.request.contextPath}/teacher/behavior?studentId=${student.id}" class="btn btn-secondary mt-3">
                                    <i class="bi bi-clipboard-plus me-1"></i> Add Behavior Note
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
</body>
</html>