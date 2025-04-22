<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty teacher ? 'Add New Teacher' : 'Edit Teacher'} - School Management System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .sidebar {
            min-height: 100vh;
            background-color: #343a40;
            color: #fff;
            padding-top: 20px;
        }
        .sidebar-heading {
            padding: 15px;
            font-size: 1.2rem;
            text-align: center;
            border-bottom: 1px solid #495057;
        }
        .sidebar-menu {
            padding: 0;
            list-style: none;
        }
        .sidebar-menu li {
            margin: 0;
            padding: 0;
        }
        .sidebar-menu li a {
            display: block;
            padding: 15px;
            color: #adb5bd;
            text-decoration: none;
            transition: all 0.3s;
        }
        .sidebar-menu li a:hover, .sidebar-menu li a.active {
            background-color: #495057;
            color: #fff;
        }
        .sidebar-menu li a i {
            margin-right: 10px;
        }
        .main-content {
            padding: 20px;
        }
        .card {
            margin-bottom: 20px;
            border: none;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .card-header {
            background-color: #fff;
            border-bottom: 1px solid #f0f0f0;
        }
        .card-header h5 {
            margin-bottom: 0;
        }
        .btn-teacher {
            background-color: #ffc107;
            color: #212529;
        }
        .btn-teacher:hover {
            background-color: #e0a800;
            color: #212529;
        }
        .select2-container {
            width: 100% !important;
        }
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/includes/admin-sidebar.jsp">
                <jsp:param name="active" value="teachers"/>
            </jsp:include>
            
            <!-- Main Content -->
            <div class="col-md-10 main-content">
                <!-- Error Message -->
                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger notification" role="alert">
                        ${param.error}
                    </div>
                </c:if>
                
                <div class="row mb-4">
                    <div class="col">
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/teachers">Teachers</a></li>
                                <li class="breadcrumb-item active" aria-current="page">${empty teacher ? 'Add New Teacher' : 'Edit Teacher'}</li>
                            </ol>
                        </nav>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-chalkboard-teacher"></i> ${empty teacher ? 'Add New Teacher' : 'Edit Teacher'}</h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/admin/teachers" method="post">
                            <input type="hidden" name="action" value="${empty teacher ? 'create' : 'update'}">
                            <c:if test="${not empty teacher}">
                                <input type="hidden" name="id" value="${teacher.id}">
                            </c:if>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="firstName">First Name <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="firstName" name="firstName" value="${teacher.firstName}" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="lastName">Last Name <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="lastName" name="lastName" value="${teacher.lastName}" required>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="email">Email <span class="text-danger">*</span></label>
                                        <input type="email" class="form-control" id="email" name="email" value="${teacher.email}" required>
                                        <small class="form-text text-muted">This will be used as the username for login.</small>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="telephone">Telephone <span class="text-danger">*</span></label>
                                        <input type="tel" class="form-control" id="telephone" name="telephone" value="${teacher.telephone}" required>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="qualification">Qualification <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="qualification" name="qualification" value="${teacher.qualification}" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="experience">Years of Experience</label>
                                        <input type="number" class="form-control" id="experience" name="experience" value="${teacher.experience}" min="0">
                                    </div>
                                </div>
                            </div>
                            
                            <c:if test="${empty teacher}">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="password">Password <span class="text-danger">*</span></label>
                                            <input type="password" class="form-control" id="password" name="password" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="confirmPassword">Confirm Password <span class="text-danger">*</span></label>
                                            <input type="password" class="form-control" id="confirmPassword" required>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                            
                            <div class="form-group">
                                <label for="courses">Assigned Courses</label>
                                <select class="form-control select2" id="courses" name="courses" multiple>
                                    <c:forEach var="course" items="${courses}">
                                        <c:set var="isSelected" value="false" />
                                        <c:forEach var="teacherCourse" items="${teacherCourses}">
                                            <c:if test="${course.id == teacherCourse.id}">
                                                <c:set var="isSelected" value="true" />
                                            </c:if>
                                        </c:forEach>
                                        <option value="${course.id}" ${isSelected ? 'selected' : ''}>${course.courseName}</option>
                                    </c:forEach>
                                </select>
                                <small class="form-text text-muted">Select multiple courses to assign to this teacher.</small>
                            </div>
                            
                            <div class="form-group mt-4">
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-save"></i> ${empty teacher ? 'Add Teacher' : 'Update Teacher'}
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/teachers" class="btn btn-secondary">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- JavaScript -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        $(document).ready(function() {
            // Initialize Select2
            $('.select2').select2({
                placeholder: 'Select courses to assign'
            });
            
            // Hide notification after 5 seconds
            setTimeout(function() {
                $('.notification').fadeOut('slow');
            }, 5000);
            
            // Password confirmation validation
            $('#confirmPassword').on('input', function() {
                var password = $('#password').val();
                var confirmPassword = $(this).val();
                
                if (password !== confirmPassword) {
                    this.setCustomValidity('Passwords must match');
                } else {
                    this.setCustomValidity('');
                }
            });
        });
    </script>
</body>
</html> 