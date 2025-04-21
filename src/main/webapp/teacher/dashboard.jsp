<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Dashboard - School Management System</title>
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
        .teacher-primary {
            background-color: #007bff;
            color: #fff;
        }
        .teacher-warning {
            background-color: #ffc107;
            color: #fff;
        }
        .teacher-info {
            background-color: #17a2b8;
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
                    <i class="fas fa-school"></i> SMS Teacher
                </div>
                <ul class="sidebar-menu">
                    <li><a href="dashboard.jsp" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="courses.jsp"><i class="fas fa-book"></i> My Courses</a></li>
                    <li><a href="students.jsp"><i class="fas fa-user-graduate"></i> My Students</a></li>
                    <li><a href="grading.jsp"><i class="fas fa-chart-line"></i> Grading</a></li>
                    <li><a href="announcements.jsp"><i class="fas fa-bullhorn"></i> Announcements</a></li>
                    <li><a href="schedule.jsp"><i class="fas fa-calendar-alt"></i> Schedule</a></li>
                    <li><a href="../logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                </ul>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 main-content">
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h2>Teacher Dashboard</h2>
                        <p>Welcome, ${user.username}! You are logged in as a teacher.</p>
                    </div>
                </div>
                
                <!-- Statistics Cards -->
                <div class="row">
                    <div class="col-md-4">
                        <div class="card-counter teacher-primary">
                            <i class="fas fa-book"></i>
                            <div>
                                <span class="count-numbers">3</span>
                                <span class="count-name">Courses</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card-counter teacher-warning">
                            <i class="fas fa-user-graduate"></i>
                            <div>
                                <span class="count-numbers">42</span>
                                <span class="count-name">Students</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card-counter teacher-info">
                            <i class="fas fa-tasks"></i>
                            <div>
                                <span class="count-numbers">12</span>
                                <span class="count-name">Pending Assessments</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Course Overview -->
                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5>My Courses</h5>
                            </div>
                            <div class="card-body">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Course Name</th>
                                            <th>Students</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>Mathematics</td>
                                            <td>15</td>
                                            <td><a href="course-details.jsp?id=1" class="btn btn-sm btn-primary">View</a></td>
                                        </tr>
                                        <tr>
                                            <td>Physics</td>
                                            <td>12</td>
                                            <td><a href="course-details.jsp?id=2" class="btn btn-sm btn-primary">View</a></td>
                                        </tr>
                                        <tr>
                                            <td>Chemistry</td>
                                            <td>15</td>
                                            <td><a href="course-details.jsp?id=3" class="btn btn-sm btn-primary">View</a></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Recent Activities -->
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5>Announcements</h5>
                            </div>
                            <div class="card-body">
                                <ul class="list-group">
                                    <li class="list-group-item">
                                        <h6>Parent-Teacher Meeting - October 15, 2023</h6>
                                        <p>All teachers are required to attend the Parent-Teacher meeting.</p>
                                    </li>
                                    <li class="list-group-item">
                                        <h6>Mid-term Exams - October 20, 2023</h6>
                                        <p>Mid-term examinations will begin on October 20, 2023.</p>
                                    </li>
                                    <li class="list-group-item">
                                        <h6>Grade Submission Deadline - October 25, 2023</h6>
                                        <p>All teachers must submit student grades by October 25, 2023.</p>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Today's Schedule -->
                <div class="row mt-4">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header">
                                <h5>Today's Schedule</h5>
                            </div>
                            <div class="card-body">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Time</th>
                                            <th>Course</th>
                                            <th>Class</th>
                                            <th>Room</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>08:00 - 09:30</td>
                                            <td>Mathematics</td>
                                            <td>Grade 10A</td>
                                            <td>Room 101</td>
                                        </tr>
                                        <tr>
                                            <td>10:00 - 11:30</td>
                                            <td>Physics</td>
                                            <td>Grade 11B</td>
                                            <td>Room 102</td>
                                        </tr>
                                        <tr>
                                            <td>13:00 - 14:30</td>
                                            <td>Chemistry</td>
                                            <td>Grade 10B</td>
                                            <td>Lab 201</td>
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