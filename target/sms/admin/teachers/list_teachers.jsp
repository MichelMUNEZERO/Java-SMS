<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Management - School Management System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .teacher-image {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }
        .action-buttons .btn {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
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
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Teacher Management</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/admin/teachers/new" class="btn btn-primary">
                            <i class="bi bi-plus-circle me-1"></i> Add New Teacher
                        </a>
                    </div>
                </div>

                <!-- Alert messages -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${sessionScope.successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>

                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${sessionScope.errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <!-- Search bar -->
                <div class="row mb-4">
                    <div class="col-md-6">
                        <form action="${pageContext.request.contextPath}/admin/teachers" method="get" class="d-flex">
                            <input type="text" name="search" class="form-control me-2" placeholder="Search by name or specialization" value="${searchQuery}">
                            <button type="submit" class="btn btn-outline-primary">Search</button>
                        </form>
                    </div>
                    <div class="col-md-6 text-end">
                        <c:if test="${not empty searchQuery}">
                            <span class="text-muted">
                                Search results for: "${searchQuery}" (${teachers.size()} results)
                                <a href="${pageContext.request.contextPath}/admin/teachers" class="ms-2 text-decoration-none">
                                    <i class="bi bi-x-circle"></i> Clear
                                </a>
                            </span>
                        </c:if>
                    </div>
                </div>

                <!-- Teachers Table -->
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th scope="col">#</th>
                                <th scope="col">Photo</th>
                                <th scope="col">Name</th>
                                <th scope="col">Email</th>
                                <th scope="col">Specialization</th>
                                <th scope="col">Experience</th>
                                <th scope="col">Status</th>
                                <th scope="col">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="teacher" items="${teachers}" varStatus="loop">
                                <tr>
                                    <td>${loop.index + 1}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty teacher.imageLink}">
                                                <img src="${teacher.imageLink}" alt="${teacher.firstName}" class="teacher-image">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/images/default-user.png" alt="Default" class="teacher-image">
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${teacher.firstName} ${teacher.lastName}</td>
                                    <td>${teacher.email}</td>
                                    <td>${teacher.specialization}</td>
                                    <td>${teacher.experience} years</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${teacher.status eq 'Active'}">
                                                <span class="badge bg-success">Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${teacher.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/admin/teachers/view/${teacher.id}" class="btn btn-info text-white">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/teachers/edit/${teacher.id}" class="btn btn-warning text-white">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal${teacher.id}">
                                            <i class="bi bi-trash"></i>
                                        </button>

                                        <!-- Delete Confirmation Modal -->
                                        <div class="modal fade" id="deleteModal${teacher.id}" tabindex="-1" aria-labelledby="deleteModalLabel${teacher.id}" aria-hidden="true">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title" id="deleteModalLabel${teacher.id}">Confirm Delete</h5>
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
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty teachers}">
                                <tr>
                                    <td colspan="8" class="text-center py-4">
                                        <div class="d-flex flex-column align-items-center">
                                            <i class="bi bi-search fs-1 text-secondary mb-2"></i>
                                            <c:choose>
                                                <c:when test="${not empty searchQuery}">
                                                    <p class="mb-0">No teachers found matching your search: "${searchQuery}"</p>
                                                    <a href="${pageContext.request.contextPath}/admin/teachers" class="btn btn-sm btn-outline-primary mt-2">
                                                        View All Teachers
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="mb-0">No teachers have been added yet.</p>
                                                    <a href="${pageContext.request.contextPath}/admin/teachers/new" class="btn btn-sm btn-primary mt-2">
                                                        <i class="bi bi-plus-circle me-1"></i> Add Teacher
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 