<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Courses | Teacher Dashboard</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .course-card {
            transition: transform 0.3s ease;
            height: 100%;
        }
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .student-count {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: rgba(0,0,0,0.7);
            color: white;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }
        .sidebar {
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            width: 250px;
            z-index: 100;
            padding-top: 20px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .main-content {
            margin-left: 250px;
            padding: 20px;
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <nav class="sidebar bg-dark">
        <div class="px-3 py-4">
            <div class="text-center mb-4">
                <img src="${pageContext.request.contextPath}/images/teacher-avatar.png" alt="Teacher" class="img-fluid rounded-circle mb-3" style="width: 80px;">
                <h5 class="text-white">Teacher Name</h5>
                <p class="text-white-50 small">Science Department</p>
            </div>
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link text-white" href="${pageContext.request.contextPath}/teacher/dashboard">
                        <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active bg-primary text-white" href="${pageContext.request.contextPath}/course/teacher">
                        <i class="fas fa-book me-2"></i> My Courses
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="${pageContext.request.contextPath}/student/teacher">
                        <i class="fas fa-user-graduate me-2"></i> My Students
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="${pageContext.request.contextPath}/grading/teacher">
                        <i class="fas fa-star me-2"></i> Grading
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="${pageContext.request.contextPath}/announcement/teacher">
                        <i class="fas fa-bullhorn me-2"></i> Announcements
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="${pageContext.request.contextPath}/schedule/teacher">
                        <i class="fas fa-calendar-alt me-2"></i> Schedule
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="${pageContext.request.contextPath}/profile/teacher">
                        <i class="fas fa-user-circle me-2"></i> My Profile
                    </a>
                </li>
                <li class="nav-item mt-3">
                    <a class="nav-link text-white" href="${pageContext.request.contextPath}/logout">
                        <i class="fas fa-sign-out-alt me-2"></i> Logout
                    </a>
                </li>
            </ul>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container-fluid">
            <div class="row mb-4">
                <div class="col">
                    <h2><i class="fas fa-book me-2"></i> My Courses</h2>
                    <p class="text-muted">Manage your assigned courses and student progress</p>
                </div>
            </div>

            <!-- Alert messages -->
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Search and Filters -->
            <div class="row mb-4">
                <div class="col-md-6">
                    <div class="input-group">
                        <input type="text" class="form-control" placeholder="Search courses..." id="searchInput">
                        <button class="btn btn-primary" type="button">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Course Cards -->
            <div class="row g-4" id="courseContainer">
                <c:forEach var="course" items="${courses}">
                    <div class="col-md-4 course-item">
                        <div class="card course-card">
                            <div class="position-relative">
                                <img src="${pageContext.request.contextPath}/images/course-${course.courseId % 5 + 1}.jpg" class="card-img-top" alt="${course.courseName}" style="height: 160px; object-fit: cover;">
                                <div class="student-count" title="${course.studentCount} Students">
                                    ${course.studentCount}
                                </div>
                            </div>
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title">${course.courseName}</h5>
                                <p class="card-text text-muted small">
                                    <c:choose>
                                        <c:when test="${course.description.length() > 100}">
                                            ${course.description.substring(0, 100)}...
                                        </c:when>
                                        <c:otherwise>
                                            ${course.description}
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <div class="mt-auto pt-3">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <a href="${pageContext.request.contextPath}/course/view?id=${course.courseId}" class="btn btn-primary btn-sm">
                                            <i class="fas fa-eye me-1"></i> View Details
                                        </a>
                                        <div>
                                            <a href="${pageContext.request.contextPath}/grading/course?id=${course.courseId}" class="btn btn-outline-secondary btn-sm">
                                                <i class="fas fa-star"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/material/course?id=${course.courseId}" class="btn btn-outline-secondary btn-sm">
                                                <i class="fas fa-file"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty courses}">
                    <div class="col-12">
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i> You don't have any assigned courses yet.
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Search functionality
        document.getElementById('searchInput').addEventListener('keyup', function() {
            let searchValue = this.value.toLowerCase();
            let courses = document.getElementsByClassName('course-item');
            
            for (let i = 0; i < courses.length; i++) {
                let courseTitle = courses[i].getElementsByClassName('card-title')[0].textContent.toLowerCase();
                let courseDesc = courses[i].getElementsByClassName('card-text')[0].textContent.toLowerCase();
                
                if (courseTitle.includes(searchValue) || courseDesc.includes(searchValue)) {
                    courses[i].style.display = "";
                } else {
                    courses[i].style.display = "none";
                }
            }
        });
    </script>
</body>
</html> 