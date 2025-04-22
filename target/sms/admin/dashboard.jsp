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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-styles.css">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <c:set var="active" value="dashboard" scope="request"/>
            <jsp:include page="/WEB-INF/includes/admin-sidebar.jsp">
                <jsp:param name="active" value="dashboard"/>
            </jsp:include>
            
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
                    <div class="col-md-6">
                        <div class="card-counter admin-info">
                            <i class="fas fa-calendar-check"></i>
                            <div>
                                <span class="count-numbers">${stats.appointments != null ? stats.appointments : 0}</span>
                                <span class="count-name">Appointments</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
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
                                        <a href="${pageContext.request.contextPath}/admin/teachers/new" class="btn btn-warning btn-block">
                                            <i class="fas fa-user-plus"></i> Add Teacher
                                        </a>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <a href="${pageContext.request.contextPath}/admin/courses/new" class="btn btn-success btn-block">
                                            <i class="fas fa-plus-circle"></i> Add Course
                                        </a>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <a href="${pageContext.request.contextPath}/admin/reports/generate" class="btn btn-info btn-block">
                                            <i class="fas fa-file-export"></i> Generate Report
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
    
    <!-- Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
</body>
</html> 