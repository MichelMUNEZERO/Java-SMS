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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/teacher-styles.css">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/includes/teacher-sidebar.jsp">
                <jsp:param name="active" value="dashboard"/>
            </jsp:include>
            
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
                                <span class="count-numbers">${stats.courses != null ? stats.courses : 3}</span>
                                <span class="count-name">Courses</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card-counter teacher-warning">
                            <i class="fas fa-user-graduate"></i>
                            <div>
                                <span class="count-numbers">${stats.students != null ? stats.students : 42}</span>
                                <span class="count-name">Students</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card-counter teacher-info">
                            <i class="fas fa-tasks"></i>
                            <div>
                                <span class="count-numbers">${stats.pendingAssessments != null ? stats.pendingAssessments : 12}</span>
                                <span class="count-name">Pending Assessments</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Course Overview -->
                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5>My Courses</h5>
                                <a href="${pageContext.request.contextPath}/teacher/courses" class="btn btn-sm btn-primary">View All</a>
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
                                        <c:choose>
                                            <c:when test="${empty teacherCourses}">
                                                <tr>
                                                    <td colspan="3" class="text-center">No courses assigned yet</td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="course" items="${teacherCourses}" varStatus="loop">
                                                    <c:if test="${loop.index < 3}">
                                                        <tr>
                                                            <td>${course.courseName}</td>
                                                            <td>${course.studentCount}</td>
                                                            <td><a href="${pageContext.request.contextPath}/teacher/course-details?id=${course.courseId}" class="btn btn-sm btn-primary">View</a></td>
                                                        </tr>
                                                    </c:if>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Recent Activities -->
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5>Announcements</h5>
                                <a href="${pageContext.request.contextPath}/teacher/announcements" class="btn btn-sm btn-primary">View All</a>
                            </div>
                            <div class="card-body">
                                <ul class="list-group">
                                    <c:choose>
                                        <c:when test="${empty announcements}">
                                            <li class="list-group-item">No announcements available</li>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="announcement" items="${announcements}" varStatus="loop">
                                                <c:if test="${loop.index < 3}">
                                                    <li class="list-group-item">
                                                        <h6>${announcement.title} - <small class="text-muted">${announcement.date}</small></h6>
                                                        <p>${announcement.message}</p>
                                                    </li>
                                                </c:if>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Today's Schedule -->
                <div class="row mt-4">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5>Today's Schedule</h5>
                                <a href="${pageContext.request.contextPath}/teacher/schedule" class="btn btn-sm btn-primary">Full Schedule</a>
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
                                        <c:choose>
                                            <c:when test="${empty todaySchedule}">
                                                <tr>
                                                    <td colspan="4" class="text-center">No classes scheduled for today</td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="schedule" items="${todaySchedule}">
                                                    <tr>
                                                        <td>${schedule.startTime} - ${schedule.endTime}</td>
                                                        <td>${schedule.courseName}</td>
                                                        <td>${schedule.className}</td>
                                                        <td>${schedule.roomNumber}</td>
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
    </div>
    
    <!-- JavaScript -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html> 