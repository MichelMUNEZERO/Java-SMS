<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teachers - School Management System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
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
        .teacher-info {
            display: flex;
            align-items: center;
        }
        .teacher-img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin-right: 15px;
            object-fit: cover;
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
                <!-- Flash Message -->
                <c:if test="${not empty param.message}">
                    <div class="alert alert-success notification" role="alert">
                        ${param.message}
                    </div>
                </c:if>
                
                <div class="row mb-4">
                    <div class="col-md-8">
                        <h2>Manage Teachers</h2>
                        <p>View, add, edit, and manage teacher accounts. You can also assign courses to teachers.</p>
                    </div>
                    <div class="col-md-4 text-right">
                        <a href="${pageContext.request.contextPath}/admin/teachers/new" class="btn btn-success">
                            <i class="fas fa-user-plus"></i> Add New Teacher
                        </a>
                    </div>
                </div>
                
                <!-- Teachers List -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5>Teachers List</h5>
                        <div>
                            <input type="text" id="teacherSearch" class="form-control" placeholder="Search teachers...">
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover" id="teachersTable">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Email</th>
                                        <th>Qualification</th>
                                        <th>Experience</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty teachers}">
                                            <tr>
                                                <td colspan="6" class="text-center">No teachers found</td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="teacher" items="${teachers}">
                                                <tr>
                                                    <td>${teacher.id}</td>
                                                    <td class="teacher-info">
                                                        <c:choose>
                                                            <c:when test="${not empty teacher.imageUrl}">
                                                                <img src="${teacher.imageUrl}" alt="Teacher" class="teacher-img">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img src="${pageContext.request.contextPath}/assets/img/default-user.jpg" alt="Teacher" class="teacher-img">
                                                            </c:otherwise>
                                                        </c:choose>
                                                        ${teacher.firstName} ${teacher.lastName}
                                                    </td>
                                                    <td>${teacher.email}</td>
                                                    <td>${teacher.qualification}</td>
                                                    <td>${teacher.experience} years</td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/admin/teachers/view/${teacher.id}" class="btn btn-sm btn-info">
                                                            <i class="fas fa-eye"></i> View
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/admin/teachers/edit/${teacher.id}" class="btn btn-sm btn-primary">
                                                            <i class="fas fa-edit"></i> Edit
                                                        </a>
                                                        <button type="button" class="btn btn-sm btn-danger delete-btn" data-id="${teacher.id}">
                                                            <i class="fas fa-trash"></i> Delete
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- JavaScript -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        $(document).ready(function() {
            // Hide notification after 5 seconds
            setTimeout(function() {
                $('.notification').fadeOut('slow');
            }, 5000);
            
            // Search functionality
            $("#teacherSearch").on("keyup", function() {
                var value = $(this).val().toLowerCase();
                $("#teachersTable tbody tr").filter(function() {
                    $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
                });
            });
            
            // Delete confirmation using event delegation
            $(document).on('click', '.delete-btn', function() {
                var id = $(this).data('id');
                if (confirm('Are you sure you want to delete this teacher? All associated course assignments will be removed.')) {
                    window.location.href = '${pageContext.request.contextPath}/admin/teachers/delete/' + id;
                }
            });
        });
    </script>
</body>
</html> 