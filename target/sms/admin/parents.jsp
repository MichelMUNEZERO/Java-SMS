<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Parents - School Management System</title>
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
        .btn-parent {
            background-color: #dc3545;
            color: #fff;
        }
        .btn-parent:hover {
            background-color: #c82333;
            color: #fff;
        }
        .parent-info {
            display: flex;
            align-items: center;
        }
        .parent-img {
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
            <div class="col-md-2 sidebar">
                <div class="sidebar-heading">
                    <i class="fas fa-school"></i> SMS Admin
                </div>
                <ul class="sidebar-menu">
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/teachers"><i class="fas fa-chalkboard-teacher"></i> Teachers</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/students"><i class="fas fa-user-graduate"></i> Students</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/parents" class="active"><i class="fas fa-user-friends"></i> Parents</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/courses"><i class="fas fa-book"></i> Courses</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/announcements"><i class="fas fa-bullhorn"></i> Announcements</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/appointments"><i class="fas fa-calendar-check"></i> Appointments</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/reports"><i class="fas fa-chart-bar"></i> Reports</a></li>
                    <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                </ul>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 main-content">
                <!-- Flash Message -->
                <c:if test="${not empty param.message}">
                    <div class="alert alert-success notification" role="alert">
                        ${param.message}
                    </div>
                </c:if>
                
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h2>Parents</h2>
                        <p>View parent information. Parents are added by students when they register.</p>
                    </div>
                </div>
                
                <!-- Parents List -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5>Parents List</h5>
                        <div>
                            <input type="text" id="parentSearch" class="form-control" placeholder="Search parents...">
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover" id="parentsTable">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Email</th>
                                        <th>Telephone</th>
                                        <th>Location</th>
                                        <th>Children</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty parents}">
                                            <tr>
                                                <td colspan="7" class="text-center">No parents found</td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="parent" items="${parents}">
                                                <tr>
                                                    <td>${parent.id}</td>
                                                    <td class="parent-info">
                                                        <c:choose>
                                                            <c:when test="${not empty parent.imageUrl}">
                                                                <img src="${parent.imageUrl}" alt="Parent" class="parent-img">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img src="${pageContext.request.contextPath}/assets/img/default-user.jpg" alt="Parent" class="parent-img">
                                                            </c:otherwise>
                                                        </c:choose>
                                                        ${parent.firstName} ${parent.lastName}
                                                    </td>
                                                    <td>${parent.email}</td>
                                                    <td>${parent.telephone}</td>
                                                    <td>${parent.location}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${empty parent.children}">
                                                                None
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${parent.childrenCount}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/admin/parents/view/${parent.id}" class="btn btn-sm btn-info">
                                                            <i class="fas fa-eye"></i> View
                                                        </a>
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
            $("#parentSearch").on("keyup", function() {
                var value = $(this).val().toLowerCase();
                $("#parentsTable tbody tr").filter(function() {
                    $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
                });
            });
        });
    </script>
</body>
</html> 