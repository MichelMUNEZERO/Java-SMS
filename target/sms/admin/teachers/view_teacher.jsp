<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Details - School Management System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .teacher-profile-img {
            width: 150px;
            height: 150px;
            object-fit: cover;
            border-radius: 50%;
            border: 5px solid #f8f9fa;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }
        .profile-header {
            background-color: #f8f9fa;
            border-radius: 10px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse" style="min-height: 100vh;">
                <div class="position-sticky pt-3">
                    <div class="d-flex align-items-center justify-content-center mb-4">
                        <img src="${pageContext.request.contextPath}/images/school-logo.png" alt="School Logo" width="50" class="me-2">
                        <span class="fs-4 text-white">School MS</span>
                    </div>
                    <hr class="text-white">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/dashboard">
                                <i class="bi bi-speedometer2 me-2"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/students">
                                <i class="bi bi-person me-2"></i> Students
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active text-white" href="${pageContext.request.contextPath}/admin/teachers">
                                <i class="bi bi-person-badge me-2"></i> Teachers
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/courses">
                                <i class="bi bi-book me-2"></i> Courses
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/schedule">
                                <i class="bi bi-calendar-event me-2"></i> Schedule
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
            <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 pt-4">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/teachers">Teachers</a></li>
                        <li class="breadcrumb-item active" aria-current="page">View Teacher</li>
                    </ol>
                </nav>

                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Teacher Details</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/admin/teachers/edit/${teacher.id}" class="btn btn-warning me-2">
                            <i class="bi bi-pencil me-1"></i> Edit
                        </a>
                        <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal">
                            <i class="bi bi-trash me-1"></i> Delete
                        </button>
                    </div>
                </div>
                
                <!-- Teacher Profile -->
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="row profile-header py-4 mb-4">
                            <div class="col-md-3 text-center">
                                <c:choose>
                                    <c:when test="${not empty teacher.imageLink}">
                                        <img src="${teacher.imageLink}" alt="${teacher.firstName}" class="teacher-profile-img mb-3">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/images/default-user.png" alt="Default" class="teacher-profile-img mb-3">
                                    </c:otherwise>
                                </c:choose>
                                <h4>${teacher.firstName} ${teacher.lastName}</h4>
                                <p class="text-muted">
                                    <c:choose>
                                        <c:when test="${teacher.status eq 'Active'}">
                                            <span class="badge bg-success">Active</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">${teacher.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <div class="col-md-9">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <h5 class="text-primary">Specialization</h5>
                                        <p>${not empty teacher.specialization ? teacher.specialization : 'Not specified'}</p>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <h5 class="text-primary">Qualification</h5>
                                        <p>${not empty teacher.qualification ? teacher.qualification : 'Not specified'}</p>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <h5 class="text-primary">Experience</h5>
                                        <p>${teacher.experience} years</p>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <h5 class="text-primary">Join Date</h5>
                                        <p>
                                            <c:choose>
                                                <c:when test="${not empty teacher.joinDate}">
                                                    <fmt:formatDate value="${teacher.joinDate}" pattern="MMMM dd, yyyy" />
                                                </c:when>
                                                <c:otherwise>
                                                    Not specified
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="mb-0">Contact Information</h5>
                                    </div>
                                    <div class="card-body">
                                        <p><strong>Email:</strong> ${teacher.email}</p>
                                        <p><strong>Phone:</strong> ${not empty teacher.phone ? teacher.phone : 'Not provided'}</p>
                                        <p><strong>Address:</strong> ${not empty teacher.address ? teacher.address : 'Not provided'}</p>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="mb-0">Classes & Courses</h5>
                                    </div>
                                    <div class="card-body">
                                        <!-- This would be populated from a database query in a real implementation -->
                                        <p class="text-muted">No classes or courses assigned yet.</p>
                                        
                                        <div class="mt-3">
                                            <a href="#" class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-plus-circle me-1"></i> Assign Course
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Back button -->
                <div class="mb-4">
                    <a href="${pageContext.request.contextPath}/admin/teachers" class="btn btn-secondary">
                        <i class="bi bi-arrow-left me-1"></i> Back to Teachers List
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete the teacher ${teacher.firstName} ${teacher.lastName}?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <a href="${pageContext.request.contextPath}/admin/teachers/delete/${teacher.id}" class="btn btn-danger">Delete</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 