<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Teacher Sidebar -->
<div class="col-md-2 sidebar bg-dark">
    <div class="sidebar-heading text-center py-3">
        <i class="fas fa-school"></i> SMS Teacher
    </div>
    <div class="text-center mb-3 p-2">
        <img src="${pageContext.request.contextPath}/assets/img/default-user.jpg" alt="Teacher" class="rounded-circle mb-2" style="width: 80px; height: 80px; object-fit: cover;">
        <h6 class="text-white">${user.firstName} ${user.lastName}</h6>
        <p class="text-white-50 small mb-0">${user.username}</p>
    </div>
    <ul class="sidebar-menu">
        <li><a href="${pageContext.request.contextPath}/teacher/dashboard" class="${param.active == 'dashboard' ? 'active' : ''}"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/teacher/courses" class="${param.active == 'courses' ? 'active' : ''}"><i class="fas fa-book"></i> My Courses</a></li>
        <li><a href="${pageContext.request.contextPath}/teacher/students" class="${param.active == 'students' ? 'active' : ''}"><i class="fas fa-user-graduate"></i> My Students</a></li>
        <li><a href="${pageContext.request.contextPath}/teacher/grading" class="${param.active == 'grading' ? 'active' : ''}"><i class="fas fa-chart-line"></i> Grading</a></li>
        <li><a href="${pageContext.request.contextPath}/teacher/announcements" class="${param.active == 'announcements' ? 'active' : ''}"><i class="fas fa-bullhorn"></i> Announcements</a></li>
        <li><a href="${pageContext.request.contextPath}/teacher/schedule" class="${param.active == 'schedule' ? 'active' : ''}"><i class="fas fa-calendar-alt"></i> Schedule</a></li>
        <li><a href="${pageContext.request.contextPath}/teacher/profile" class="${param.active == 'profile' ? 'active' : ''}"><i class="fas fa-user-circle"></i> My Profile</a></li>
        <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
</div> 