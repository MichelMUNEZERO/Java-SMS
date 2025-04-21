<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - School Management System</title>
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
        .student-primary {
            background-color: #007bff;
            color: #fff;
        }
        .student-success {
            background-color: #28a745;
            color: #fff;
        }
        .student-danger {
            background-color: #dc3545;
            color: #fff;
        }
        .progress {
            height: 10px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 sidebar">
                <div class="sidebar-heading">
                    <i class="fas fa-school"></i> SMS Student
                </div>
                <ul class="sidebar-menu">
                    <li><a href="dashboard.jsp" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="courses.jsp"><i class="fas fa-book"></i> My Courses</a></li>
                    <li><a href="grades.jsp"><i class="fas fa-chart-line"></i> Grades</a></li>
                    <li><a href="assignments.jsp"><i class="fas fa-tasks"></i> Assignments</a></li>
                    <li><a href="attendance.jsp"><i class="fas fa-calendar-check"></i> Attendance</a></li>
                    <li><a href="schedule.jsp"><i class="fas fa-calendar-alt"></i> Schedule</a></li>
                    <li><a href="announcements.jsp"><i class="fas fa-bullhorn"></i> Announcements</a></li>
                    <li><a href="../logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                </ul>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 main-content">
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h2>Student Dashboard</h2>
                        <p>Welcome, ${user.username}! You are logged in as a student.</p>
                    </div>
                </div>
                
                <!-- Statistics Cards -->
                <div class="row">
                    <div class="col-md-4">
                        <div class="card-counter student-primary">
                            <i class="fas fa-book"></i>
                            <div>
                                <span class="count-numbers">5</span>
                                <span class="count-name">Enrolled Courses</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card-counter student-success">
                            <i class="fas fa-tasks"></i>
                            <div>
                                <span class="count-numbers">3</span>
                                <span class="count-name">Pending Assignments</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card-counter student-danger">
                            <i class="fas fa-calendar-check"></i>
                            <div>
                                <span class="count-numbers">92%</span>
                                <span class="count-name">Attendance</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Course Progress -->
                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5>Course Progress</h5>
                            </div>
                            <div class="card-body">
                                <div class="mb-4">
                                    <div class="d-flex justify-content-between">
                                        <span>Mathematics</span>
                                        <span>85%</span>
                                    </div>
                                    <div class="progress">
                                        <div class="progress-bar bg-success" role="progressbar" style="width: 85%" aria-valuenow="85" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                                <div class="mb-4">
                                    <div class="d-flex justify-content-between">
                                        <span>Physics</span>
                                        <span>70%</span>
                                    </div>
                                    <div class="progress">
                                        <div class="progress-bar bg-info" role="progressbar" style="width: 70%" aria-valuenow="70" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                                <div class="mb-4">
                                    <div class="d-flex justify-content-between">
                                        <span>Chemistry</span>
                                        <span>65%</span>
                                    </div>
                                    <div class="progress">
                                        <div class="progress-bar bg-warning" role="progressbar" style="width: 65%" aria-valuenow="65" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                                <div class="mb-4">
                                    <div class="d-flex justify-content-between">
                                        <span>Biology</span>
                                        <span>90%</span>
                                    </div>
                                    <div class="progress">
                                        <div class="progress-bar bg-success" role="progressbar" style="width: 90%" aria-valuenow="90" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                                <div class="mb-4">
                                    <div class="d-flex justify-content-between">
                                        <span>English</span>
                                        <span>75%</span>
                                    </div>
                                    <div class="progress">
                                        <div class="progress-bar bg-info" role="progressbar" style="width: 75%" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
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
                                        <h6>Mid-term Exams - October 20, 2023</h6>
                                        <p>Mid-term examinations will begin on October 20, 2023.</p>
                                    </li>
                                    <li class="list-group-item">
                                        <h6>Science Fair - November 5, 2023</h6>
                                        <p>Annual Science Fair will be held on November 5, 2023. All science students are encouraged to participate.</p>
                                    </li>
                                    <li class="list-group-item">
                                        <h6>Parent-Teacher Meeting - October 15, 2023</h6>
                                        <p>All parents are requested to attend the Parent-Teacher meeting.</p>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Upcoming Assignments -->
                <div class="row mt-4">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header">
                                <h5>Upcoming Assignments</h5>
                            </div>
                            <div class="card-body">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Assignment</th>
                                            <th>Course</th>
                                            <th>Due Date</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>Problem Set 3</td>
                                            <td>Mathematics</td>
                                            <td>October 10, 2023</td>
                                            <td><span class="badge badge-warning">Pending</span></td>
                                            <td><a href="#" class="btn btn-sm btn-primary">View</a></td>
                                        </tr>
                                        <tr>
                                            <td>Lab Report</td>
                                            <td>Physics</td>
                                            <td>October 12, 2023</td>
                                            <td><span class="badge badge-warning">Pending</span></td>
                                            <td><a href="#" class="btn btn-sm btn-primary">View</a></td>
                                        </tr>
                                        <tr>
                                            <td>Essay</td>
                                            <td>English</td>
                                            <td>October 15, 2023</td>
                                            <td><span class="badge badge-warning">Pending</span></td>
                                            <td><a href="#" class="btn btn-sm btn-primary">View</a></td>
                                        </tr>
                                    </tbody>
                                </table>
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