<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Admin Sidebar -->
<div class="col-md-2 sidebar">
    <div class="sidebar-heading">
        <i class="fas fa-school"></i> SMS Admin
    </div>
    <ul class="sidebar-menu">
        <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="${param.active == 'dashboard' ? 'active' : ''}"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/teachers" class="${param.active == 'teachers' ? 'active' : ''}"><i class="fas fa-chalkboard-teacher"></i> Teachers</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/students" class="${param.active == 'students' ? 'active' : ''}"><i class="fas fa-user-graduate"></i> Students</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/courses" class="${param.active == 'courses' ? 'active' : ''}"><i class="fas fa-book"></i> Courses</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/announcements" class="${param.active == 'announcements' ? 'active' : ''}"><i class="fas fa-bullhorn"></i> Announcements</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/appointments" class="${param.active == 'appointments' ? 'active' : ''}"><i class="fas fa-calendar-check"></i> Appointments</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/reports" class="${param.active == 'reports' ? 'active' : ''}"><i class="fas fa-chart-bar"></i> Reports</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/users" class="${param.active == 'users' ? 'active' : ''}"><i class="fas fa-users"></i> Users</a></li>
        <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
</div> 