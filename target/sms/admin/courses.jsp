<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Management | School Management System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-styles.css">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/includes/admin-sidebar.jsp">
                <jsp:param name="active" value="courses"/>
            </jsp:include>

            <!-- Main content -->
            <main role="main" class="col-md-10 ml-sm-auto px-4 bg-light">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Course Management</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/admin/courses/new" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Add New Course
                        </a>
                    </div>
                </div>

                <!-- Alert messages -->
                <c:if test="${not empty message}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Search Box -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <form action="${pageContext.request.contextPath}/admin/courses/search" method="get" class="d-flex">
                            <input type="text" name="searchTerm" class="form-control me-2" placeholder="Search courses..." required>
                            <button type="submit" class="btn btn-outline-primary">Search</button>
                        </form>
                    </div>
                </div>

                <!-- Course List Table -->
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Course Name</th>
                                <th>Description</th>
                                <th>Teacher</th>
                                <th>Students</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="course" items="${courses}">
                                <tr>
                                    <td>${course.courseId}</td>
                                    <td>${course.courseName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${course.description.length() > 50}">
                                                ${course.description.substring(0, 50)}...
                                            </c:when>
                                            <c:otherwise>
                                                ${course.description}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${course.teacherId}</td>
                                    <td>${course.studentCount}</td>
                                    <td class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/admin/courses/view?id=${course.courseId}" class="btn btn-info btn-sm">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/courses/edit?id=${course.courseId}" class="btn btn-warning btn-sm">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="#" onclick="confirmDelete('${course.courseId}')" class="btn btn-danger btn-sm">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty courses}">
                                <tr>
                                    <td colspan="6" class="text-center">No courses found</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </main>
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
                    Are you sure you want to delete this course? This action cannot be undone.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Delete</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
    <script>
        // Function to confirm deletion
        function confirmDelete(courseId) {
            const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
            confirmDeleteBtn.href = "${pageContext.request.contextPath}/admin/courses/delete?id=" + courseId;
            deleteModal.show();
        }
    </script>
</body>
</html> 