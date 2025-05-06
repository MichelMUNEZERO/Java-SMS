<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isNew ? 'Add' : 'Edit'} Course | Admin Dashboard</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-styles.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f5f5f9;
        }
        .container-fluid {
            padding: 0;
        }
        main {
            padding: 20px;
            background-color: #f5f5f9;
        }
        .card {
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            border: none;
            margin-bottom: 20px;
        }
        .card-header {
            background-color: #fff;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            font-weight: 600;
            padding: 15px 20px;
            border-radius: 10px 10px 0 0 !important;
        }
        .card-body {
            padding: 20px;
        }
        h1.h2 {
            font-weight: 600;
            color: #333;
        }
        .required:after {
            content: "*";
            color: red;
            margin-left: 4px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Include sidebar -->
            <jsp:include page="sidebar.jsp" />

            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3">
                    <h1 class="h2">${isNew ? 'Add New' : 'Edit'} Course</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-sm btn-outline-secondary">
                            <i class="bi bi-arrow-left"></i> Back to Courses
                        </a>
                    </div>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <div class="card">
                    <div class="card-header">Course Information</div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/admin/courses/edit/${not isNew ? course.id : ''}" method="post">
                            <!-- Hidden field for course ID if editing -->
                            <c:if test="${not isNew}">
                                <input type="hidden" name="courseId" value="${course.id}">
                            </c:if>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="courseName" class="form-label required">Course Name</label>
                                    <input type="text" class="form-control" id="courseName" name="courseName" 
                                           value="${course.courseName}" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="courseCode" class="form-label required">Course Code</label>
                                    <input type="text" class="form-control" id="courseCode" name="courseCode" 
                                           value="${course.courseCode}" required>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="teacherId" class="form-label">Assigned Teacher</label>
                                    <select class="form-select" id="teacherId" name="teacherId">
                                        <option value="0">-- Select Teacher --</option>
                                        <c:forEach items="${teachers}" var="teacher">
                                            <option value="${teacher.id}" ${teacher.id eq course.teacherId ? 'selected' : ''}>
                                                ${teacher.firstName} ${teacher.lastName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label for="credits" class="form-label required">Credits</label>
                                    <input type="number" class="form-control" id="credits" name="credits" 
                                           value="${course.credits}" min="0" required>
                                </div>
                                <div class="col-md-3">
                                    <label for="status" class="form-label">Status</label>
                                    <select class="form-select" id="status" name="status">
                                        <option value="active" ${course.status eq 'active' ? 'selected' : ''}>Active</option>
                                        <option value="inactive" ${course.status eq 'inactive' ? 'selected' : ''}>Inactive</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="description" class="form-label">Description</label>
                                <textarea class="form-control" id="description" name="description" 
                                          rows="4">${course.description}</textarea>
                            </div>
                            
                            <div class="d-flex justify-content-end">
                                <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-outline-secondary me-2">
                                    Cancel
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-save"></i> ${isNew ? 'Add' : 'Save'} Course
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
</body>
</html> 