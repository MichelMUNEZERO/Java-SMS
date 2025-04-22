<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Details | School Management System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="container mt-4">
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="d-flex justify-content-between align-items-center">
                    <h1 class="mb-0">Course Details</h1>
                    <a href="${pageContext.request.contextPath}/course/list" class="btn btn-primary">
                        <i class="fas fa-arrow-left me-2"></i> Back to Courses
                    </a>
                </div>
                <hr>
            </div>
        </div>

        <div class="row">
            <!-- Course Information -->
            <div class="col-md-8">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-book me-2"></i> Course Information</h5>
                    </div>
                    <div class="card-body">
                        <table class="table table-borderless">
                            <tr>
                                <th style="width: 30%;">Course Name:</th>
                                <td>${course.courseName}</td>
                            </tr>
                            <tr>
                                <th>Course ID:</th>
                                <td>${course.courseId}</td>
                            </tr>
                            <tr>
                                <th>Description:</th>
                                <td>${course.description}</td>
                            </tr>
                            <tr>
                                <th>Number of Students:</th>
                                <td>${studentCount}</td>
                            </tr>
                        </table>
                    </div>
                </div>

                <!-- Teacher Information -->
                <div class="card mb-4">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="fas fa-chalkboard-teacher me-2"></i> Teacher Information</h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${teacher != null}">
                            <div class="row">
                                <div class="col-md-4 text-center mb-3">
                                    <img src="${pageContext.request.contextPath}/images/teacher-avatar.png" 
                                         alt="${teacher.firstName} ${teacher.lastName}" 
                                         class="img-fluid rounded-circle" 
                                         style="width: 120px; height: 120px;">
                                </div>
                                <div class="col-md-8">
                                    <table class="table table-borderless">
                                        <tr>
                                            <th style="width: 30%;">Name:</th>
                                            <td>${teacher.firstName} ${teacher.lastName}</td>
                                        </tr>
                                        <tr>
                                            <th>Email:</th>
                                            <td>${teacher.email}</td>
                                        </tr>
                                        <tr>
                                            <th>Phone:</th>
                                            <td>${teacher.phone}</td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${teacher == null}">
                            <div class="alert alert-warning">
                                No teacher assigned to this course yet.
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Sidebar with actions and stats -->
            <div class="col-md-4">
                <!-- Actions -->
                <div class="card mb-4">
                    <div class="card-header bg-dark text-white">
                        <h5 class="mb-0"><i class="fas fa-cogs me-2"></i> Actions</h5>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/course/edit?id=${course.courseId}" class="btn btn-warning">
                                <i class="fas fa-edit me-2"></i> Edit Course
                            </a>
                            <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal">
                                <i class="fas fa-trash me-2"></i> Delete Course
                            </button>
                            <a href="${pageContext.request.contextPath}/enrollment/manage?courseId=${course.courseId}" class="btn btn-info">
                                <i class="fas fa-users me-2"></i> Manage Students
                            </a>
                            <a href="${pageContext.request.contextPath}/course/materials?id=${course.courseId}" class="btn btn-secondary">
                                <i class="fas fa-file me-2"></i> Course Materials
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Course Statistics -->
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0"><i class="fas fa-chart-bar me-2"></i> Course Statistics</h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <div class="d-flex justify-content-between mb-1">
                                <span>Completion Rate</span>
                                <span>65%</span>
                            </div>
                            <div class="progress">
                                <div class="progress-bar bg-success" role="progressbar" style="width: 65%;" aria-valuenow="65" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="d-flex justify-content-between mb-1">
                                <span>Average Score</span>
                                <span>78%</span>
                            </div>
                            <div class="progress">
                                <div class="progress-bar bg-primary" role="progressbar" style="width: 78%;" aria-valuenow="78" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                        </div>
                        <div>
                            <div class="d-flex justify-content-between mb-1">
                                <span>Attendance</span>
                                <span>92%</span>
                            </div>
                            <div class="progress">
                                <div class="progress-bar bg-info" role="progressbar" style="width: 92%;" aria-valuenow="92" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Student List -->
        <div class="row mt-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-warning">
                        <h5 class="mb-0"><i class="fas fa-user-graduate me-2"></i> Enrolled Students</h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty students}">
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Name</th>
                                            <th>Reg. Number</th>
                                            <th>Grade</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="student" items="${students}">
                                            <tr>
                                                <td>${student.studentId}</td>
                                                <td>${student.firstName} ${student.lastName}</td>
                                                <td>${student.regNumber}</td>
                                                <td>${student.gradeClass}</td>
                                                <td>
                                                    <span class="badge bg-success">Active</span>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/student/view?id=${student.studentId}" class="btn btn-sm btn-info">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/mark/add?courseId=${course.courseId}&studentId=${student.studentId}" class="btn btn-sm btn-primary">
                                                        <i class="fas fa-plus"></i> Grade
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                        <c:if test="${empty students}">
                            <div class="alert alert-info">
                                No students are currently enrolled in this course.
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this course: <strong>${course.courseName}</strong>?</p>
                    <p class="text-danger">This action cannot be undone and will remove all student enrollments in this course.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <a href="${pageContext.request.contextPath}/course/delete?id=${course.courseId}" class="btn btn-danger">Delete</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 