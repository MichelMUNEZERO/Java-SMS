<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Profile - School Management System</title>
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
        .profile-header {
            background: linear-gradient(135deg, #ffc107 0%, #ff9800 100%);
            color: #fff;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .profile-img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 4px solid #fff;
            object-fit: cover;
        }
        .info-label {
            font-weight: 600;
            color: #495057;
        }
        .badge-course {
            background-color: #17a2b8;
            color: white;
            font-size: 85%;
            margin-right: 5px;
            margin-bottom: 5px;
            padding: 8px 12px;
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
                    <li><a href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users"></i> Users</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/teachers" class="active"><i class="fas fa-chalkboard-teacher"></i> Teachers</a></li>
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
                    <div class="col">
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/teachers">Teachers</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Teacher Profile</li>
                            </ol>
                        </nav>
                    </div>
                </div>
                
                <!-- Profile Header -->
                <div class="profile-header row align-items-center">
                    <div class="col-md-2 text-center">
                        <c:choose>
                            <c:when test="${not empty teacher.imageUrl}">
                                <img src="${teacher.imageUrl}" alt="${teacher.firstName}" class="profile-img">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/assets/img/default-user.jpg" alt="${teacher.firstName}" class="profile-img">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col-md-10">
                        <h2>${teacher.firstName} ${teacher.lastName}</h2>
                        <p><i class="fas fa-envelope"></i> ${teacher.email}</p>
                        <p><i class="fas fa-phone"></i> ${teacher.telephone}</p>
                    </div>
                </div>
                
                <div class="row">
                    <!-- Teacher Details -->
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5>Teacher Information</h5>
                            </div>
                            <div class="card-body">
                                <div class="row mb-3">
                                    <div class="col-md-4 info-label">ID:</div>
                                    <div class="col-md-8">${teacher.id}</div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-4 info-label">Full Name:</div>
                                    <div class="col-md-8">${teacher.firstName} ${teacher.lastName}</div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-4 info-label">Email:</div>
                                    <div class="col-md-8">${teacher.email}</div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-4 info-label">Telephone:</div>
                                    <div class="col-md-8">${teacher.telephone}</div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-4 info-label">Qualification:</div>
                                    <div class="col-md-8">${teacher.qualification}</div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-4 info-label">Experience:</div>
                                    <div class="col-md-8">${teacher.experience} years</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Teacher Courses -->
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5>Assigned Courses</h5>
                            </div>
                            <div class="card-body">
                                <c:if test="${empty teacherCourses}">
                                    <p class="text-muted">No courses assigned to this teacher yet.</p>
                                </c:if>
                                <div class="d-flex flex-wrap">
                                    <c:forEach var="course" items="${teacherCourses}">
                                        <span class="badge badge-course">
                                            ${course.courseName}
                                        </span>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Teacher Statistics -->
                        <div class="card mt-4">
                            <div class="card-header">
                                <h5>Teaching Statistics</h5>
                            </div>
                            <div class="card-body">
                                <div class="row mb-3">
                                    <div class="col-md-8 info-label">Total Students:</div>
                                    <div class="col-md-4">${teacherStats.totalStudents != null ? teacherStats.totalStudents : 0}</div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-8 info-label">Average Student Performance:</div>
                                    <div class="col-md-4">${teacherStats.avgPerformance != null ? teacherStats.avgPerformance : 'N/A'}</div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-8 info-label">Classes per Week:</div>
                                    <div class="col-md-4">${teacherStats.classesPerWeek != null ? teacherStats.classesPerWeek : 'N/A'}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Actions -->
                <div class="row mt-4">
                    <div class="col-md-12">
                        <a href="${pageContext.request.contextPath}/admin/teachers" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Teachers List
                        </a>
                        <!-- Edit button removed as per requirements -->
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- JavaScript -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 