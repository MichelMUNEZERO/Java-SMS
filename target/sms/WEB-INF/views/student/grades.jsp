<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Grades - School Management System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css" />
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <style>
        .grade-card {
            transition: transform 0.3s;
            border-radius: 10px;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }
        .grade-card:hover {
            transform: translateY(-5px);
        }
        .progress {
            height: 10px;
            border-radius: 5px;
        }
        .grade-badge {
            font-size: 1.1rem;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .gpa-display {
            font-size: 3rem;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse" style="min-height: 100vh">
                <div class="position-sticky pt-3">
                    <div class="d-flex align-items-center justify-content-center mb-4">
                        <img src="${pageContext.request.contextPath}/images/school-logo.png" alt="School Logo" width="50" class="me-2" />
                        <span class="fs-4 text-white">School MS</span>
                    </div>
                    <hr class="text-white" />
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/student/dashboard">
                                <i class="bi bi-speedometer2 me-2"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/student/courses">
                                <i class="bi bi-book me-2"></i> My Courses
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active text-white" href="${pageContext.request.contextPath}/student/grades">
                                <i class="bi bi-card-checklist me-2"></i> Grades
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/student/assignments">
                                <i class="bi bi-file-earmark-text me-2"></i> Assignments
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/student/update-parent">
                                <i class="bi bi-people me-2"></i> Parent Info
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="#">
                                <i class="bi bi-person me-2"></i> Profile
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

            <!-- Main content -->
            <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 mt-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">My Grades</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="dropdown">
                            <a class="btn btn-sm btn-outline-secondary dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-person-circle me-1"></i> ${user.username}
                            </a>
                            <ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
                                <li>
                                    <a class="dropdown-item" href="#"><i class="bi bi-person me-2"></i> Profile</a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="#"><i class="bi bi-gear me-2"></i> Settings</a>
                                </li>
                                <li><hr class="dropdown-divider" /></li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Alerts -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <c:if test="${not empty message}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- GPA Summary Card -->
                <div class="row mb-4">
                    <div class="col-md-12">
                        <div class="card grade-card">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col-md-4 text-center">
                                        <h5 class="text-muted mb-2">Current GPA</h5>
                                        <div class="gpa-display text-primary">${gpa}</div>
                                        <p class="text-muted">on a 4.0 scale</p>
                                    </div>
                                    <div class="col-md-8">
                                        <h5>GPA Breakdown</h5>
                                        <div class="progress mb-2" style="height: 20px">
                                            <div class="progress-bar bg-danger" role="progressbar" style="width: 25%" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100">0-1.0</div>
                                            <div class="progress-bar bg-warning" role="progressbar" style="width: 25%" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100">1.0-2.0</div>
                                            <div class="progress-bar bg-info" role="progressbar" style="width: 25%" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100">2.0-3.0</div>
                                            <div class="progress-bar bg-success" role="progressbar" style="width: 25%" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100">3.0-4.0</div>
                                        </div>
                                        <p class="text-muted small">
                                            <i class="bi bi-info-circle-fill me-1"></i> GPA is calculated based on all course grades weighted by credit hours.
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Grades by Course -->
                <h4 class="mb-3">Grades by Course</h4>

                <c:choose>
                    <c:when test="${empty gradesList}">
                        <div class="alert alert-info" role="alert">
                            <i class="bi bi-info-circle me-2"></i> No grade records found.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Group grades by course -->
                        <c:set var="currentCourse" value="" />
                        <c:forEach var="grade" items="${gradesList}" varStatus="loop">
                            <c:if test="${currentCourse != grade.courseCode || loop.first}">
                                <c:if test="${!loop.first}">
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                                </c:if>

                                <c:set var="currentCourse" value="${grade.courseCode}" />
                                <div class="row mb-4">
                                    <div class="col-md-12">
                                        <div class="card grade-card mb-4">
                                            <div class="card-header d-flex justify-content-between align-items-center">
                                                <h5 class="mb-0">${grade.courseCode}: ${grade.courseName}</h5>
                                                <span class="badge bg-primary">${grade.credits} Credits</span>
                                            </div>
                                            <div class="card-body">
                                                <table class="table table-hover">
                                                    <thead>
                                                        <tr>
                                                            <th>Assignment</th>
                                                            <th>Score</th>
                                                            <th>Percentage</th>
                                                            <th>Grade</th>
                                                            <th>Feedback</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                            </c:if>

                            <tr>
                                <td>${grade.assignmentName}</td>
                                <td>${grade.marksObtained} / ${grade.totalMarks}</td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="progress flex-grow-1 me-2">
                                            <div class="progress-bar ${grade.percentage >= 90 ? 'bg-success' : grade.percentage >= 70 ? 'bg-info' : grade.percentage >= 60 ? 'bg-warning' : 'bg-danger'}" 
                                                role="progressbar" 
                                                style="width: ${grade.percentage}%" 
                                                aria-valuenow="${grade.percentage}" 
                                                aria-valuemin="0" 
                                                aria-valuemax="100">
                                            </div>
                                        </div>
                                        <span>${grade.percentage}%</span>
                                    </div>
                                </td>
                                <td>
                                    <span class="grade-badge ${grade.percentage >= 90 ? 'bg-success' : grade.percentage >= 70 ? 'bg-info' : grade.percentage >= 60 ? 'bg-warning' : 'bg-danger'} text-white">${grade.grade}</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${empty grade.feedback}">
                                            <span class="text-muted">No feedback provided</span>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#feedbackModal${loop.index}">
                                                <i class="bi bi-chat-left-text me-1"></i> View
                                            </button>

                                            <!-- Feedback Modal -->
                                            <div class="modal fade" id="feedbackModal${loop.index}" tabindex="-1" aria-labelledby="feedbackModalLabel${loop.index}" aria-hidden="true">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="feedbackModalLabel${loop.index}">Feedback: ${grade.assignmentName}</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <p>${grade.feedback}</p>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            <c:if test="${loop.last}">
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                            </c:if>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>

                <!-- Grade Explanation Card -->
                <div class="row mt-4 mb-4">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header bg-info text-white">
                                <h5 class="card-title mb-0">
                                    <i class="bi bi-info-circle me-2"></i> Grade Information
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <h6>Grading Scale</h6>
                                        <table class="table table-sm">
                                            <thead>
                                                <tr>
                                                    <th>Percentage</th>
                                                    <th>Letter Grade</th>
                                                    <th>GPA</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>90-100%</td>
                                                    <td>A</td>
                                                    <td>4.0</td>
                                                </tr>
                                                <tr>
                                                    <td>80-89%</td>
                                                    <td>B</td>
                                                    <td>3.0</td>
                                                </tr>
                                                <tr>
                                                    <td>70-79%</td>
                                                    <td>C</td>
                                                    <td>2.0</td>
                                                </tr>
                                                <tr>
                                                    <td>60-69%</td>
                                                    <td>D</td>
                                                    <td>1.0</td>
                                                </tr>
                                                <tr>
                                                    <td>0-59%</td>
                                                    <td>F</td>
                                                    <td>0.0</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="col-md-6">
                                        <h6>Academic Standing</h6>
                                        <table class="table table-sm">
                                            <thead>
                                                <tr>
                                                    <th>GPA Range</th>
                                                    <th>Standing</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>3.5-4.0</td>
                                                    <td><span class="badge bg-success">Excellent</span></td>
                                                </tr>
                                                <tr>
                                                    <td>3.0-3.49</td>
                                                    <td><span class="badge bg-primary">Very Good</span></td>
                                                </tr>
                                                <tr>
                                                    <td>2.5-2.99</td>
                                                    <td><span class="badge bg-info">Good</span></td>
                                                </tr>
                                                <tr>
                                                    <td>2.0-2.49</td>
                                                    <td><span class="badge bg-warning">Satisfactory</span></td>
                                                </tr>
                                                <tr>
                                                    <td>0-1.99</td>
                                                    <td><span class="badge bg-danger">Academic Probation</span></td>
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
        </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 