<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                    <li><a href="dashboard.jsp" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="users.jsp"><i class="fas fa-users"></i> Users</a></li>
                    <li><a href="teachers.jsp"><i class="fas fa-chalkboard-teacher"></i> Teachers</a></li>
                    <li><a href="students.jsp"><i class="fas fa-user-graduate"></i> Students</a></li>
                    <li><a href="parents.jsp"><i class="fas fa-user-friends"></i> Parents</a></li>
                    <li><a href="courses.jsp"><i class="fas fa-book"></i> Courses</a></li>
                    <li><a href="announcements.jsp"><i class="fas fa-bullhorn"></i> Announcements</a></li>
                    <li><a href="reports.jsp"><i class="fas fa-chart-bar"></i> Reports</a></li>
                    <li><a href="../logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
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
                    <div class="col-md-3">
                        <div class="card-counter admin-primary">
                            <i class="fas fa-user-graduate"></i>
                            <div>
                                <span class="count-numbers">150</span>
                                <span class="count-name">Students</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-3">
                        <div class="card-counter admin-warning">
                            <i class="fas fa-chalkboard-teacher"></i>
                            <div>
                                <span class="count-numbers">25</span>
                                <span class="count-name">Teachers</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-3">
                        <div class="card-counter admin-success">
                            <i class="fas fa-book"></i>
                            <div>
                                <span class="count-numbers">32</span>
                                <span class="count-name">Courses</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-3">
                        <div class="card-counter admin-danger">
                            <i class="fas fa-user-friends"></i>
                            <div>
                                <span class="count-numbers">120</span>
                                <span class="count-name">Parents</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Recent Activities -->
                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5>Recent Activities</h5>
                            </div>
                            <div class="card-body">
                                <ul class="list-group">
                                    <li class="list-group-item">New student John Doe registered</li>
                                    <li class="list-group-item">Teacher Jane Smith updated profile</li>
                                    <li class="list-group-item">New course Mathematics added</li>
                                    <li class="list-group-item">Grades updated for Science class</li>
                                    <li class="list-group-item">New announcement posted by Admin</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Announcements -->
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5>Announcements</h5>
                            </div>
                            <div class="card-body">
                                <ul class="list-group">
                                    <li class="list-group-item">
                                        <h6>School Holiday - October 12, 2023</h6>
                                        <p>School will be closed for National Holiday.</p>
                                    </li>
                                    <li class="list-group-item">
                                        <h6>Parent-Teacher Meeting - October 15, 2023</h6>
                                        <p>All parents are requested to attend the Parent-Teacher meeting.</p>
                                    </li>
                                    <li class="list-group-item">
                                        <h6>Annual Sports Day - October 25, 2023</h6>
                                        <p>Annual Sports Day will be held at the school grounds.</p>
                                    </li>
                                </ul>
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