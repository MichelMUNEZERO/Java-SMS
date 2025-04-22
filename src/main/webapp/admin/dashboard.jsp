<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - School Management System</title>
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
        .card-counter {
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            background-color: #fff;
            border-radius: 5px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }
        .card-counter i {
            font-size: 4rem;
            margin-right: 20px;
        }
        .card-counter .count-name {
            font-size: 1.2rem;
            color: #6c757d;
        }
        .card-counter .count-numbers {
            font-size: 2rem;
            font-weight: bold;
        }
        .admin-primary {
            background-color: #007bff;
            color: #fff;
        }
        .admin-warning {
            background-color: #ffc107;
            color: #fff;
        }
        .admin-success {
            background-color: #28a745;
            color: #fff;
        }
        .admin-danger {
            background-color: #dc3545;
            color: #fff;
        }
        .admin-info {
            background-color: #17a2b8;
            color: #fff;
        }
        .admin-secondary {
            background-color: #6c757d;
            color: #fff;
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
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users"></i> Users</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/teachers"><i class="fas fa-chalkboard-teacher"></i> Teachers</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/students"><i class="fas fa-user-graduate"></i> Students</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/parents"><i class="fas fa-user-friends"></i> Parents</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/courses"><i class="fas fa-book"></i> Courses</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/announcements"><i class="fas fa-bullhorn"></i> Announcements</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/appointments"><i class="fas fa-calendar-check"></i> Appointments</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/health"><i class="fas fa-heartbeat"></i> Health</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/reports"><i class="fas fa-chart-bar"></i> Reports</a></li>
                    <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                </ul>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 main-content">
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h2>Admin Dashboard</h2>
                        <p>Welcome, ${user.username}! You are logged in as an administrator.</p>
                    </div>
                </div>
                
                <!-- Statistics Cards -->
                <div class="row">
                    <div class="col-md-4">
                        <div class="card-counter admin-primary">
                            <i class="fas fa-user-graduate"></i>
                            <div>
                                <span class="count-numbers">${stats.students != null ? stats.students : 0}</span>
                                <span class="count-name">Students</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card-counter admin-warning">
                            <i class="fas fa-chalkboard-teacher"></i>
                            <div>
                                <span class="count-numbers">${stats.teachers != null ? stats.teachers : 0}</span>
                                <span class="count-name">Teachers</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card-counter admin-success">
                            <i class="fas fa-book"></i>
                            <div>
                                <span class="count-numbers">${stats.courses != null ? stats.courses : 0}</span>
                                <span class="count-name">Courses</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row mt-3">
                    <div class="col-md-4">
                        <div class="card-counter admin-danger">
                            <i class="fas fa-user-friends"></i>
                            <div>
                                <span class="count-numbers">${stats.parents != null ? stats.parents : 0}</span>
                                <span class="count-name">Parents</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card-counter admin-info">
                            <i class="fas fa-calendar-check"></i>
                            <div>
                                <span class="count-numbers">${stats.appointments != null ? stats.appointments : 0}</span>
                                <span class="count-name">Appointments</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card-counter admin-secondary">
                            <i class="fas fa-clock"></i>
                            <div>
                                <span class="count-numbers">${stats.pendingAppointments != null ? stats.pendingAppointments : 0}</span>
                                <span class="count-name">Pending Appointments</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Recent Activities and Announcements -->
                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5>Recent Activities</h5>
                            </div>
                            <div class="card-body">
                                <ul class="list-group">
                                    <c:choose>
                                        <c:when test="${empty recentActivities}">
                                            <li class="list-group-item">No recent activities</li>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="activity" items="${recentActivities}">
                                                <li class="list-group-item">${activity}</li>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </ul>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Announcements -->
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between">
                                <h5>Announcements</h5>
                                <a href="${pageContext.request.contextPath}/admin/announcements/new" class="btn btn-sm btn-primary">New</a>
                            </div>
                            <div class="card-body">
                                <ul class="list-group">
                                    <c:choose>
                                        <c:when test="${empty announcements}">
                                            <li class="list-group-item">No announcements available</li>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="announcement" items="${announcements}">
                                                <li class="list-group-item">
                                                    <h6>
                                                        <fmt:formatDate value="${announcement.date}" pattern="MMMM d, yyyy" />
                                                        <span class="badge badge-info">${announcement.targetGroup}</span>
                                                    </h6>
                                                    <p>${announcement.message}</p>
                                                </li>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Quick Actions -->
                <div class="row mt-4">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header">
                                <h5>Quick Actions</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-3 mb-3">
                                        <a href="${pageContext.request.contextPath}/admin/students/new" class="btn btn-primary btn-block">
                                            <i class="fas fa-user-plus"></i> Add Student
                                        </a>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <a href="${pageContext.request.contextPath}/admin/courses/new" class="btn btn-success btn-block">
                                            <i class="fas fa-plus-circle"></i> Add Course
                                        </a>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <a href="${pageContext.request.contextPath}/admin/doctors/new" class="btn btn-danger btn-block">
                                            <i class="fas fa-user-md"></i> Add Doctor
                                        </a>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <a href="${pageContext.request.contextPath}/admin/nurses/new" class="btn btn-info btn-block">
                                            <i class="fas fa-user-nurse"></i> Add Nurse
                                        </a>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <a href="${pageContext.request.contextPath}/admin/announcements/new" class="btn btn-warning btn-block">
                                            <i class="fas fa-bullhorn"></i> New Announcement
                                        </a>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <a href="${pageContext.request.contextPath}/admin/diagnosis/new" class="btn btn-secondary btn-block">
                                            <i class="fas fa-heartbeat"></i> Add Diagnosis Record
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html> 