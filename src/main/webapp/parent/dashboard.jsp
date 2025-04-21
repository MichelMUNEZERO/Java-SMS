<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Parent Dashboard - School Management System</title>
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
        .parent-primary {
            background-color: #6f42c1;
            color: #fff;
        }
        .parent-success {
            background-color: #28a745;
            color: #fff;
        }
        .parent-danger {
            background-color: #dc3545;
            color: #fff;
        }
        .profile-img {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 15px;
        }
        .attendance-mark {
            width: 25px;
            height: 25px;
            display: inline-block;
            border-radius: 50%;
            margin-right: 5px;
        }
        .attendance-present {
            background-color: #28a745;
        }
        .attendance-absent {
            background-color: #dc3545;
        }
        .attendance-late {
            background-color: #ffc107;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 sidebar">
                <div class="sidebar-heading">
                    <i class="fas fa-school"></i> SMS Parent
                </div>
                <ul class="sidebar-menu">
                    <li><a href="dashboard.jsp" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="children.jsp"><i class="fas fa-user-graduate"></i> My Children</a></li>
                    <li><a href="grades.jsp"><i class="fas fa-chart-line"></i> Academic Progress</a></li>
                    <li><a href="attendance.jsp"><i class="fas fa-calendar-check"></i> Attendance</a></li>
                    <li><a href="behavior.jsp"><i class="fas fa-clipboard-list"></i> Behavior</a></li>
                    <li><a href="appointments.jsp"><i class="fas fa-calendar-alt"></i> Appointments</a></li>
                    <li><a href="messages.jsp"><i class="fas fa-envelope"></i> Messages</a></li>
                    <li><a href="fees.jsp"><i class="fas fa-money-bill-wave"></i> Fees</a></li>
                    <li><a href="../logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                </ul>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 main-content">
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h2>Parent Dashboard</h2>
                        <p>Welcome, ${user.username}! You are logged in as a parent.</p>
                    </div>
                </div>
                
                <!-- Statistics Cards -->
                <div class="row">
                    <div class="col-md-4">
                        <div class="card-counter parent-primary">
                            <i class="fas fa-user-graduate"></i>
                            <div>
                                <span class="count-numbers">2</span>
                                <span class="count-name">Children</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card-counter parent-success">
                            <i class="fas fa-calendar-check"></i>
                            <div>
                                <span class="count-numbers">95%</span>
                                <span class="count-name">Attendance Rate</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card-counter parent-danger">
                            <i class="fas fa-exclamation-triangle"></i>
                            <div>
                                <span class="count-numbers">3</span>
                                <span class="count-name">Important Notices</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Children Overview -->
                <div class="row mt-4">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header">
                                <h5>My Children</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <!-- Child 1 -->
                                    <div class="col-md-6">
                                        <div class="card mb-3">
                                            <div class="card-body">
                                                <div class="d-flex align-items-center mb-3">
                                                    <img src="../images/default-user.png" alt="Student" class="profile-img">
                                                    <div>
                                                        <h5 class="mb-0">John Doe</h5>
                                                        <p class="text-muted mb-0">Grade 10A | ID: ST10045</p>
                                                    </div>
                                                </div>
                                                <div class="row mb-3">
                                                    <div class="col-md-6">
                                                        <h6>Overall Grade: <span class="badge badge-success">A-</span></h6>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <h6>Attendance: <span class="badge badge-success">98%</span></h6>
                                                    </div>
                                                </div>
                                                <div class="mb-2">
                                                    <h6>Recent Performance</h6>
                                                    <div class="progress mb-2">
                                                        <div class="progress-bar bg-success" role="progressbar" style="width: 85%" aria-valuenow="85" aria-valuemin="0" aria-valuemax="100">Mathematics: 85%</div>
                                                    </div>
                                                    <div class="progress mb-2">
                                                        <div class="progress-bar bg-info" role="progressbar" style="width: 90%" aria-valuenow="90" aria-valuemin="0" aria-valuemax="100">Science: 90%</div>
                                                    </div>
                                                    <div class="progress mb-2">
                                                        <div class="progress-bar bg-warning" role="progressbar" style="width: 75%" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100">English: 75%</div>
                                                    </div>
                                                </div>
                                                <a href="student-details.jsp?id=1" class="btn btn-primary btn-sm">View Details</a>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Child 2 -->
                                    <div class="col-md-6">
                                        <div class="card mb-3">
                                            <div class="card-body">
                                                <div class="d-flex align-items-center mb-3">
                                                    <img src="../images/default-user.png" alt="Student" class="profile-img">
                                                    <div>
                                                        <h5 class="mb-0">Sarah Doe</h5>
                                                        <p class="text-muted mb-0">Grade 8B | ID: ST10089</p>
                                                    </div>
                                                </div>
                                                <div class="row mb-3">
                                                    <div class="col-md-6">
                                                        <h6>Overall Grade: <span class="badge badge-primary">B+</span></h6>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <h6>Attendance: <span class="badge badge-warning">92%</span></h6>
                                                    </div>
                                                </div>
                                                <div class="mb-2">
                                                    <h6>Recent Performance</h6>
                                                    <div class="progress mb-2">
                                                        <div class="progress-bar bg-info" role="progressbar" style="width: 78%" aria-valuenow="78" aria-valuemin="0" aria-valuemax="100">Mathematics: 78%</div>
                                                    </div>
                                                    <div class="progress mb-2">
                                                        <div class="progress-bar bg-success" role="progressbar" style="width: 88%" aria-valuenow="88" aria-valuemin="0" aria-valuemax="100">Science: 88%</div>
                                                    </div>
                                                    <div class="progress mb-2">
                                                        <div class="progress-bar bg-info" role="progressbar" style="width: 82%" aria-valuenow="82" aria-valuemin="0" aria-valuemax="100">English: 82%</div>
                                                    </div>
                                                </div>
                                                <a href="student-details.jsp?id=2" class="btn btn-primary btn-sm">View Details</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Recent Attendance & Announcements -->
                <div class="row mt-4">
                    <!-- Recent Attendance -->
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5>Recent Attendance</h5>
                            </div>
                            <div class="card-body">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Child</th>
                                            <th>Date</th>
                                            <th>Status</th>
                                            <th>Note</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>John Doe</td>
                                            <td>Oct 5, 2023</td>
                                            <td><span class="attendance-mark attendance-present" title="Present"></span> Present</td>
                                            <td>-</td>
                                        </tr>
                                        <tr>
                                            <td>John Doe</td>
                                            <td>Oct 4, 2023</td>
                                            <td><span class="attendance-mark attendance-present" title="Present"></span> Present</td>
                                            <td>-</td>
                                        </tr>
                                        <tr>
                                            <td>Sarah Doe</td>
                                            <td>Oct 5, 2023</td>
                                            <td><span class="attendance-mark attendance-present" title="Present"></span> Present</td>
                                            <td>-</td>
                                        </tr>
                                        <tr>
                                            <td>Sarah Doe</td>
                                            <td>Oct 4, 2023</td>
                                            <td><span class="attendance-mark attendance-late" title="Late"></span> Late</td>
                                            <td>Arrived 15 minutes late</td>
                                        </tr>
                                        <tr>
                                            <td>John Doe</td>
                                            <td>Oct 3, 2023</td>
                                            <td><span class="attendance-mark attendance-present" title="Present"></span> Present</td>
                                            <td>-</td>
                                        </tr>
                                    </tbody>
                                </table>
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
                                        <h6>Parent-Teacher Meeting - October 15, 2023</h6>
                                        <p>All parents are requested to attend the Parent-Teacher meeting. Time slots have been allocated.</p>
                                        <p><span class="badge badge-danger">Important</span></p>
                                    </li>
                                    <li class="list-group-item">
                                        <h6>Mid-term Exams - October 20, 2023</h6>
                                        <p>Mid-term examinations will begin on October 20, 2023. Please ensure your children are prepared.</p>
                                        <p><span class="badge badge-danger">Important</span></p>
                                    </li>
                                    <li class="list-group-item">
                                        <h6>School Trip - November 10, 2023</h6>
                                        <p>School trip to Science Museum is scheduled for November 10, 2023. Permission forms will be sent next week.</p>
                                        <p><span class="badge badge-danger">Important</span></p>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Upcoming Events & Fee Status -->
                <div class="row mt-4">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header">
                                <h5>Upcoming Events</h5>
                            </div>
                            <div class="card-body">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Event</th>
                                            <th>Date</th>
                                            <th>Description</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>Parent-Teacher Meeting</td>
                                            <td>October 15, 2023</td>
                                            <td>Scheduled meeting with all subject teachers</td>
                                            <td><span class="badge badge-warning">Pending</span></td>
                                        </tr>
                                        <tr>
                                            <td>Science Fair</td>
                                            <td>November 5, 2023</td>
                                            <td>Annual Science Fair at school</td>
                                            <td><span class="badge badge-info">Upcoming</span></td>
                                        </tr>
                                        <tr>
                                            <td>Term Fee Payment</td>
                                            <td>October 30, 2023</td>
                                            <td>Last date for term fee payment</td>
                                            <td><span class="badge badge-danger">Attention</span></td>
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