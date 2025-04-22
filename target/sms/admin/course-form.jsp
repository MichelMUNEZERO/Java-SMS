<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${course == null ? 'Add New Course' : 'Edit Course'} | School Management System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar (you would include this from a common file in a real application) -->
            <nav class="col-md-2 d-none d-md-block bg-dark sidebar p-0" style="min-height: 100vh;">
                <div class="sidebar-sticky">
                    <div class="bg-dark text-white p-3 mb-3">
                        <h4>School Admin</h4>
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/dashboard">
                                <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/user/list">
                                <i class="fas fa-users me-2"></i> Users
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white active bg-primary" href="${pageContext.request.contextPath}/course/list">
                                <i class="fas fa-book me-2"></i> Courses
                            </a>
                        </li>
                        <!-- Other navigation items -->
                    </ul>
                </div>
            </nav>

            <!-- Main content -->
            <main role="main" class="col-md-10 ml-sm-auto px-4 bg-light">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">${course == null ? 'Add New Course' : 'Edit Course'}</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/course/list" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Courses
                        </a>
                    </div>
                </div>

                <!-- Form -->
                <div class="row">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/course/${course == null ? 'insert' : 'update'}" method="post">
                                    <c:if test="${course != null}">
                                        <input type="hidden" name="courseId" value="${course.courseId}" />
                                    </c:if>
                                    
                                    <div class="mb-3">
                                        <label for="courseName" class="form-label">Course Name</label>
                                        <input type="text" class="form-control" id="courseName" name="courseName" value="${course != null ? course.courseName : ''}" required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="description" class="form-label">Description</label>
                                        <textarea class="form-control" id="description" name="description" rows="4">${course != null ? course.description : ''}</textarea>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="teacherId" class="form-label">Assign Teacher</label>
                                        <select class="form-select" id="teacherId" name="teacherId" required>
                                            <option value="" disabled ${course == null ? 'selected' : ''}>Choose a teacher</option>
                                            <c:forEach var="teacher" items="${teachers}">
                                                <option value="${teacher.teacherId}" ${course != null && course.teacherId == teacher.teacherId ? 'selected' : ''}>
                                                    ${teacher.firstName} ${teacher.lastName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    
                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save"></i> ${course == null ? 'Add Course' : 'Update Course'}
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 