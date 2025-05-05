<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sidebar -->
<div class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse" style="min-height: 100vh">
    <div class="position-sticky pt-3">
        <div class="d-flex align-items-center justify-content-center mb-4">
            <img src="${pageContext.request.contextPath}/images/school-logo.png" alt="School Logo" width="50" class="me-2">
            <span class="fs-4 text-white">School MS</span>
        </div>
        
        <!-- Teacher Profile Widget -->
        <div class="teacher-profile bg-dark text-white mb-3 text-center">
            <c:choose>
                <c:when test="${not empty profileData.imageLink}">
                    <img src="${profileData.imageLink}" alt="Teacher Avatar" class="teacher-avatar mx-auto d-block mb-2">
                </c:when>
                <c:otherwise>
                    <div class="bg-secondary rounded-circle mx-auto mb-2" style="width: 50px; height: 50px; display: flex; align-items: center; justify-content: center;">
                        <i class="bi bi-person text-white" style="font-size: 1.5rem;"></i>
                    </div>
                </c:otherwise>
            </c:choose>
            <div>
                <span class="d-block">${user.username}</span>
                <small class="text-muted">${user.email}</small>
            </div>
        </div>
        
        <hr class="text-white">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/teacher/dashboard">
                    <i class="bi bi-speedometer2 me-2"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/teacher/courses">
                    <i class="bi bi-book me-2"></i> My Courses
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link active text-white" href="${pageContext.request.contextPath}/teacher/student">
                    <i class="bi bi-people me-2"></i> My Students
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/teacher/marks">
                    <i class="bi bi-card-checklist me-2"></i> Marks & Grades
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/teacher/behavior">
                    <i class="bi bi-clipboard-check me-2"></i> Student Behavior
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/teacher/reports">
                    <i class="bi bi-file-earmark-text me-2"></i> Reports
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/teacher/appointments">
                    <i class="bi bi-calendar-event me-2"></i> Appointments
                </a>
            </li>
            <li class="nav-item mt-5">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/logout">
                    <i class="bi bi-box-arrow-right me-2"></i> Logout
                </a>
            </li>
        </ul>
    </div>
</div> 