<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Details - School Management System</title>
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
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        }
        .card-header {
            background-color: #fff;
            border-bottom: 1px solid rgba(0, 0, 0, 0.125);
            padding: 15px 20px;
        }
        .profile-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
            padding: 20px;
            margin-bottom: 20px;
        }
        .profile-img {
            width: 150px;
            height: 150px;
            object-fit: cover;
            border-radius: 50%;
            border: 5px solid #fff;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        }
        .profile-info h3 {
            margin-bottom: 5px;
        }
        .profile-info p {
            color: #6c757d;
            margin-bottom: 5px;
        }
        .profile-details .label {
            font-weight: bold;
            color: #495057;
        }
        .status-badge {
            font-size: 0.9rem;
            padding: 5px 10px;
            border-radius: 30px;
        }
        .nav-tabs .nav-item .nav-link {
            color: #495057;
            border: none;
            padding: 15px 20px;
            font-weight: 500;
        }
        .nav-tabs .nav-item .nav-link.active {
            color: #007bff;
            background: none;
            border-bottom: 3px solid #007bff;
        }
        .tab-content {
            padding: 20px;
            background-color: #fff;
            border-radius: 0 0 5px 5px;
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
                    <li><a href="dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="users.jsp"><i class="fas fa-users"></i> Users</a></li>
                    <li><a href="student?action=list" class="active"><i class="fas fa-user-graduate"></i> Students</a></li>
                    <li><a href="teachers.jsp"><i class="fas fa-chalkboard-teacher"></i> Teachers</a></li>
                    <li><a href="parents.jsp"><i class="fas fa-user-friends"></i> Parents</a></li>
                    <li><a href="courses.jsp"><i class="fas fa-book"></i> Courses</a></li>
                    <li><a href="classes.jsp"><i class="fas fa-chalkboard"></i> Classes</a></li>
                    <li><a href="announcements.jsp"><i class="fas fa-bullhorn"></i> Announcements</a></li>
                    <li><a href="reports.jsp"><i class="fas fa-chart-bar"></i> Reports</a></li>
                    <li><a href="../logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                </ul>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 main-content">
                <div class="row mb-4">
                    <div class="col-md-8">
                        <h2><i class="fas fa-user-graduate"></i> Student Details</h2>
                        <p>Viewing detailed information for student</p>
                    </div>
                    <div class="col-md-4 text-right">
                        <a href="student?action=list" class="btn btn-secondary mr-2">
                            <i class="fas fa-arrow-left"></i> Back to Students
                        </a>
                        <a href="student?action=edit&id=${student.studentId}" class="btn btn-primary">
                            <i class="fas fa-edit"></i> Edit Student
                        </a>
                    </div>
                </div>
                
                <!-- Profile Header -->
                <div class="card">
                    <div class="card-body p-0">
                        <div class="profile-header row">
                            <div class="col-md-2 text-center">
                                <c:choose>
                                    <c:when test="${not empty student.photoPath}">
                                        <img src="../uploads/students/${student.photoPath}" alt="Student Photo" class="profile-img">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="../images/default-student.png" alt="Default Student Photo" class="profile-img">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="col-md-5 profile-info">
                                <h3>${student.firstName} ${student.lastName}</h3>
                                <p><i class="fas fa-id-card"></i> ${student.regNumber}</p>
                                <p><i class="fas fa-graduation-cap"></i> Grade ${student.gradeClass}</p>
                                <p>
                                    <c:choose>
                                        <c:when test="${student.status == 'active'}">
                                            <span class="badge badge-success status-badge">Active</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-warning status-badge">Inactive</span>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <div class="col-md-5 text-right">
                                <div class="btn-group">
                                    <button type="button" class="btn btn-outline-primary">
                                        <i class="fas fa-print"></i> Print Info
                                    </button>
                                    <button type="button" class="btn btn-outline-primary">
                                        <i class="fas fa-file-pdf"></i> Generate Report
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Student Information Tabs -->
                <div class="card">
                    <div class="card-body p-0">
                        <ul class="nav nav-tabs" id="studentTabs" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="basic-tab" data-toggle="tab" href="#basicInfo" role="tab" aria-controls="basicInfo" aria-selected="true">
                                    <i class="fas fa-info-circle"></i> Basic Information
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="academic-tab" data-toggle="tab" href="#academicInfo" role="tab" aria-controls="academicInfo" aria-selected="false">
                                    <i class="fas fa-book"></i> Academic Information
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="medical-tab" data-toggle="tab" href="#medicalInfo" role="tab" aria-controls="medicalInfo" aria-selected="false">
                                    <i class="fas fa-medkit"></i> Medical Information
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="attendance-tab" data-toggle="tab" href="#attendanceInfo" role="tab" aria-controls="attendanceInfo" aria-selected="false">
                                    <i class="fas fa-calendar-check"></i> Attendance
                                </a>
                            </li>
                        </ul>
                        
                        <div class="tab-content" id="studentTabContent">
                            <!-- Basic Information Tab -->
                            <div class="tab-pane fade show active" id="basicInfo" role="tabpanel" aria-labelledby="basic-tab">
                                <div class="row">
                                    <div class="col-md-6">
                                        <table class="table table-borderless profile-details">
                                            <tr>
                                                <td class="label">Full Name</td>
                                                <td>${student.firstName} ${student.lastName}</td>
                                            </tr>
                                            <tr>
                                                <td class="label">Registration No.</td>
                                                <td>${student.regNumber}</td>
                                            </tr>
                                            <tr>
                                                <td class="label">Gender</td>
                                                <td>${student.gender}</td>
                                            </tr>
                                            <tr>
                                                <td class="label">Date of Birth</td>
                                                <td><fmt:formatDate value="${student.dateOfBirth}" pattern="MMMM d, yyyy" /></td>
                                            </tr>
                                            <tr>
                                                <td class="label">Email</td>
                                                <td>${student.email}</td>
                                            </tr>
                                            <tr>
                                                <td class="label">Phone</td>
                                                <td>${student.phone}</td>
                                            </tr>
                                        </table>
                                    </div>
                                    <div class="col-md-6">
                                        <table class="table table-borderless profile-details">
                                            <tr>
                                                <td class="label">Address</td>
                                                <td>${student.address}</td>
                                            </tr>
                                            <tr>
                                                <td class="label">Parent</td>
                                                <td>${parent.firstName} ${parent.lastName}</td>
                                            </tr>
                                            <tr>
                                                <td class="label">Parent Phone</td>
                                                <td>${parent.phone}</td>
                                            </tr>
                                            <tr>
                                                <td class="label">Parent Email</td>
                                                <td>${parent.email}</td>
                                            </tr>
                                            <tr>
                                                <td class="label">Grade/Class</td>
                                                <td>${student.gradeClass}</td>
                                            </tr>
                                            <tr>
                                                <td class="label">Status</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${student.status == 'active'}">
                                                            <span class="badge badge-success">Active</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-warning">Inactive</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Academic Information Tab -->
                            <div class="tab-pane fade" id="academicInfo" role="tabpanel" aria-labelledby="academic-tab">
                                <h5 class="mb-4">Enrolled Courses</h5>
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Course Code</th>
                                            <th>Course Name</th>
                                            <th>Teacher</th>
                                            <th>Average Grade</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:if test="${not empty courses}">
                                            <c:forEach var="course" items="${courses}">
                                                <tr>
                                                    <td>${course.courseCode}</td>
                                                    <td>${course.courseName}</td>
                                                    <td>${course.teacherName}</td>
                                                    <td>${course.averageGrade}%</td>
                                                    <td><span class="badge badge-success">Enrolled</span></td>
                                                </tr>
                                            </c:forEach>
                                        </c:if>
                                        <c:if test="${empty courses}">
                                            <tr>
                                                <td colspan="5" class="text-center">No courses enrolled</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                                
                                <h5 class="mt-5 mb-4">Academic History</h5>
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Semester</th>
                                            <th>Year</th>
                                            <th>Grade/Class</th>
                                            <th>GPA</th>
                                            <th>Rank</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:if test="${not empty academicHistory}">
                                            <c:forEach var="term" items="${academicHistory}">
                                                <tr>
                                                    <td>${term.semester}</td>
                                                    <td>${term.year}</td>
                                                    <td>${term.gradeClass}</td>
                                                    <td>${term.gpa}</td>
                                                    <td>${term.rank} out of ${term.totalStudents}</td>
                                                </tr>
                                            </c:forEach>
                                        </c:if>
                                        <c:if test="${empty academicHistory}">
                                            <tr>
                                                <td colspan="5" class="text-center">No academic history available</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                            
                            <!-- Medical Information Tab -->
                            <div class="tab-pane fade" id="medicalInfo" role="tabpanel" aria-labelledby="medical-tab">
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="card border-light mb-4">
                                            <div class="card-header bg-light">
                                                <h5 class="mb-0">Medical Information</h5>
                                            </div>
                                            <div class="card-body">
                                                <p>${not empty student.medicalInfo ? student.medicalInfo : 'No medical information provided.'}</p>
                                            </div>
                                        </div>
                                        
                                        <div class="card border-light mb-4">
                                            <div class="card-header bg-light">
                                                <h5 class="mb-0">Medical History</h5>
                                            </div>
                                            <div class="card-body">
                                                <c:if test="${not empty medicalHistory}">
                                                    <table class="table table-striped">
                                                        <thead>
                                                            <tr>
                                                                <th>Date</th>
                                                                <th>Type</th>
                                                                <th>Description</th>
                                                                <th>Action Taken</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="record" items="${medicalHistory}">
                                                                <tr>
                                                                    <td><fmt:formatDate value="${record.date}" pattern="MMMM d, yyyy" /></td>
                                                                    <td>${record.type}</td>
                                                                    <td>${record.description}</td>
                                                                    <td>${record.actionTaken}</td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </c:if>
                                                <c:if test="${empty medicalHistory}">
                                                    <p>No medical history records available.</p>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Attendance Tab -->
                            <div class="tab-pane fade" id="attendanceInfo" role="tabpanel" aria-labelledby="attendance-tab">
                                <div class="row mb-4">
                                    <div class="col-md-12">
                                        <h5>Attendance Overview</h5>
                                        <div class="row mt-4">
                                            <div class="col-md-3">
                                                <div class="card bg-success text-white">
                                                    <div class="card-body text-center">
                                                        <h1>95%</h1>
                                                        <p class="mb-0">Present</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="card bg-warning text-white">
                                                    <div class="card-body text-center">
                                                        <h1>3%</h1>
                                                        <p class="mb-0">Excused</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="card bg-danger text-white">
                                                    <div class="card-body text-center">
                                                        <h1>2%</h1>
                                                        <p class="mb-0">Absent</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="card bg-info text-white">
                                                    <div class="card-body text-center">
                                                        <h1>160</h1>
                                                        <p class="mb-0">Total Days</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <h5 class="mb-4">Recent Attendance</h5>
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Status</th>
                                            <th>Note</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:if test="${not empty attendance}">
                                            <c:forEach var="record" items="${attendance}">
                                                <tr>
                                                    <td><fmt:formatDate value="${record.date}" pattern="MMMM d, yyyy" /></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${record.status == 'present'}">
                                                                <span class="badge badge-success">Present</span>
                                                            </c:when>
                                                            <c:when test="${record.status == 'excused'}">
                                                                <span class="badge badge-warning">Excused</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-danger">Absent</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${record.note}</td>
                                                </tr>
                                            </c:forEach>
                                        </c:if>
                                        <c:if test="${empty attendance}">
                                            <tr>
                                                <td colspan="3" class="text-center">No attendance records available</td>
                                            </tr>
                                        </c:if>
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