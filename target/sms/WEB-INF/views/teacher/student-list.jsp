<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Students - School Management System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .card {
            border-radius: 10px;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }
        .action-buttons .btn {
            margin-right: 5px;
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
                    <h1 class="h2">My Students</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/teacher/student/new" class="btn btn-primary me-2">
                            <i class="bi bi-person-plus-fill me-1"></i> Add New Student
                        </a>
                        <a href="${pageContext.request.contextPath}/teacher/student/enroll" class="btn btn-success">
                            <i class="bi bi-person-plus-fill me-1"></i> Enroll Existing Student
                        </a>
                    </div>
                </div>

                <!-- Success/Error messages -->
                <c:if test="${not empty param.success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>
                        <c:choose>
                            <c:when test="${param.success eq 'added'}">Student has been successfully added!</c:when>
                            <c:when test="${param.success eq 'enrolled'}">Student has been successfully enrolled in the course!</c:when>
                            <c:when test="${param.success eq 'updated'}">Student information has been updated!</c:when>
                            <c:otherwise>Operation completed successfully!</c:otherwise>
                        </c:choose>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                
                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        <c:choose>
                            <c:when test="${param.error eq 'notfound'}">Student not found!</c:when>
                            <c:when test="${param.error eq 'invalid'}">Invalid student ID!</c:when>
                            <c:otherwise>An error occurred!</c:otherwise>
                        </c:choose>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Students Table -->
                <div class="card dashboard-card mb-4">
                    <div class="card-body">
                        <table id="studentsTable" class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Class</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${students}" var="student">
                                    <tr>
                                        <td>${student.id}</td>
                                        <td>${student.firstName} ${student.lastName}</td>
                                        <td>${student.className}</td>
                                        <td>${student.email}</td>
                                        <td>${student.phone}</td>
                                        <td>
                                            <span class="badge bg-${student.status eq 'active' ? 'success' : 'warning'}">
                                                ${student.status}
                                            </span>
                                        </td>
                                        <td class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/teacher/student/view?id=${student.id}" class="btn btn-sm btn-primary">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/teacher/student/edit?id=${student.id}" class="btn btn-sm btn-warning">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/teacher/marks?studentId=${student.id}" class="btn btn-sm btn-info">
                                                <i class="bi bi-award"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/teacher/behavior?studentId=${student.id}" class="btn btn-sm btn-secondary">
                                                <i class="bi bi-clipboard-check"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty students}">
                                    <tr>
                                        <td colspan="7" class="text-center">No students found</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>

    <script>
        $(document).ready(function() {
            $('#studentsTable').DataTable({
                "pageLength": 10,
                "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                "language": {
                    "search": "Search students:",
                    "lengthMenu": "Show _MENU_ students per page",
                    "info": "Showing _START_ to _END_ of _TOTAL_ students",
                    "infoEmpty": "No students available",
                    "infoFiltered": "(filtered from _MAX_ total students)",
                    "zeroRecords": "No matching students found"
                }
            });
        });
    </script>
</body>
</html> 