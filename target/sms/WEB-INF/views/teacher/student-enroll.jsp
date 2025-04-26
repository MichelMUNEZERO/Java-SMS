<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enroll Student in Course - School Management System</title>
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
                    <h1 class="h2">Enroll Student in Course</h1>
                    <a href="${pageContext.request.contextPath}/teacher/student" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i> Back to Students
                    </a>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
                    </div>
                </c:if>

                <div class="card mb-4">
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/teacher/student/enroll" method="post" class="row g-3">
                            <c:if test="${not empty param.id}">
                                <input type="hidden" name="studentId" value="${param.id}">
                                <div class="col-12 mb-3">
                                    <div class="alert alert-info">
                                        <strong><i class="bi bi-info-circle-fill me-2"></i> Enrolling Student:</strong> ${student.firstName} ${student.lastName} (ID: ${student.id})
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${empty param.id}">
                                <!-- Student Selection -->
                                <div class="col-12 mb-3">
                                    <label for="studentId" class="form-label">Select Student</label>
                                    <select class="form-select" id="studentId" name="studentId" required>
                                        <option value="">Choose a student</option>
                                        <c:forEach var="student" items="${students}">
                                            <option value="${student.id}">${student.firstName} ${student.lastName} (ID: ${student.id})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </c:if>
                            
                            <!-- Course Selection -->
                            <div class="col-12 mb-3">
                                <label for="courseId" class="form-label">Select Course</label>
                                <select class="form-select" id="courseId" name="courseId" required>
                                    <option value="">Choose a course</option>
                                    <c:forEach var="course" items="${courses}">
                                        <option value="${course.id}">${course.courseName} (${course.courseCode})</option>
                                    </c:forEach>
                                </select>
                            </div>
                            
                            <!-- Enrollment Details -->
                            <div class="col-md-6">
                                <label for="enrollmentDate" class="form-label">Enrollment Date</label>
                                <input type="date" class="form-control" id="enrollmentDate" name="enrollmentDate" 
                                       value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label for="status" class="form-label">Status</label>
                                <select class="form-select" id="status" name="status" required>
                                    <option value="active" selected>Active</option>
                                    <option value="pending">Pending</option>
                                    <option value="waitlisted">Waitlisted</option>
                                </select>
                            </div>
                            
                            <!-- Optional Note -->
                            <div class="col-12 mt-3">
                                <label for="notes" class="form-label">Notes (Optional)</label>
                                <textarea class="form-control" id="notes" name="notes" rows="3" placeholder="Any additional information or notes regarding this enrollment"></textarea>
                            </div>
                            
                            <!-- Submit Buttons -->
                            <div class="col-12 mt-4">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-person-plus-fill me-1"></i> Enroll Student
                                </button>
                                <a href="${pageContext.request.contextPath}/teacher/student" class="btn btn-outline-secondary ms-2">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Course Information Cards -->
                <div class="row mt-4">
                    <div class="col-12">
                        <h4>Your Courses</h4>
                        <p class="text-muted">Select a course from above to enroll the student</p>
                    </div>
                    
                    <c:forEach var="course" items="${courses}" varStatus="status">
                        <div class="col-md-4 mb-4">
                            <div class="card h-100">
                                <div class="card-header bg-light">
                                    <h5 class="card-title mb-0">${course.courseCode}</h5>
                                </div>
                                <div class="card-body">
                                    <h6 class="card-subtitle mb-2 text-muted">${course.courseName}</h6>
                                    <p class="card-text">${course.description}</p>
                                    <ul class="list-group list-group-flush mb-3">
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            Credits
                                            <span class="badge bg-primary rounded-pill">${course.credits}</span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            Students
                                            <span class="badge bg-info rounded-pill">${course.studentCount}</span>
                                        </li>
                                    </ul>
                                    <button type="button" class="btn btn-outline-primary btn-sm w-100" 
                                            onclick="document.getElementById('courseId').value='${course.id}'; window.scrollTo(0, 0);">
                                        <i class="bi bi-plus-circle me-1"></i> Select This Course
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 