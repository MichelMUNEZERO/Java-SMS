<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard | School Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/student-styles.css">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Include the student sidebar -->
            <jsp:include page="/WEB-INF/includes/student-sidebar.jsp">
                <jsp:param name="active" value="dashboard" />
            </jsp:include>
            
            <!-- Main Content -->
            <div class="col-md-10 main-content ml-auto">
                <div class="row p-4">
                    <div class="col-12">
                        <h1 class="page-title mb-4">Welcome, ${user.firstName}!</h1>
                    </div>
                </div>
                
                <!-- Stats Cards -->
                <div class="row px-4 pb-4">
                    <div class="col-md-4">
                        <div class="card stats-card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-8">
                                        <h5 class="card-title">Enrolled Courses</h5>
                                        <h2 class="card-text">5</h2>
                                    </div>
                                    <div class="col-4 text-right">
                                        <i class="fas fa-book fa-3x text-primary"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer text-muted">
                                <a href="${pageContext.request.contextPath}/student/courses">View all courses</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card stats-card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-8">
                                        <h5 class="card-title">Pending Assignments</h5>
                                        <h2 class="card-text">3</h2>
                                    </div>
                                    <div class="col-4 text-right">
                                        <i class="fas fa-clipboard-list fa-3x text-warning"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer text-muted">
                                <a href="${pageContext.request.contextPath}/student/assignments">View all assignments</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card stats-card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-8">
                                        <h5 class="card-title">Attendance</h5>
                                        <h2 class="card-text">92%</h2>
                                    </div>
                                    <div class="col-4 text-right">
                                        <i class="fas fa-calendar-check fa-3x text-success"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer text-muted">
                                <a href="${pageContext.request.contextPath}/student/attendance">View attendance</a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Course Progress -->
                <div class="row px-4 pb-4">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">Course Progress</h5>
                            </div>
                            <div class="card-body">
                                <div class="course-progress mb-3">
                                    <div class="d-flex justify-content-between mb-1">
                                        <span>Mathematics</span>
                                        <span>75%</span>
                                    </div>
                                    <div class="progress">
                                        <div class="progress-bar bg-success" role="progressbar" style="width: 75%" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                                <div class="course-progress mb-3">
                                    <div class="d-flex justify-content-between mb-1">
                                        <span>Physics</span>
                                        <span>60%</span>
                                    </div>
                                    <div class="progress">
                                        <div class="progress-bar bg-info" role="progressbar" style="width: 60%" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                                <div class="course-progress mb-3">
                                    <div class="d-flex justify-content-between mb-1">
                                        <span>Chemistry</span>
                                        <span>80%</span>
                                    </div>
                                    <div class="progress">
                                        <div class="progress-bar bg-success" role="progressbar" style="width: 80%" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                                <div class="course-progress mb-3">
                                    <div class="d-flex justify-content-between mb-1">
                                        <span>Biology</span>
                                        <span>55%</span>
                                    </div>
                                    <div class="progress">
                                        <div class="progress-bar bg-warning" role="progressbar" style="width: 55%" aria-valuenow="55" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                                <div class="course-progress">
                                    <div class="d-flex justify-content-between mb-1">
                                        <span>English</span>
                                        <span>70%</span>
                                    </div>
                                    <div class="progress">
                                        <div class="progress-bar bg-info" role="progressbar" style="width: 70%" aria-valuenow="70" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Announcements & Assignments -->
                <div class="row px-4 pb-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">Announcements</h5>
                            </div>
                            <div class="card-body">
                                <div class="announcements">
                                    <div class="announcement-item mb-3">
                                        <h6>Mid-Term Exam Schedule</h6>
                                        <p>Mid-term exams will be held from 15th to 20th October. Prepare accordingly.</p>
                                        <small class="text-muted">Posted 2 days ago</small>
                                    </div>
                                    <div class="announcement-item mb-3">
                                        <h6>Science Fair</h6>
                                        <p>Annual science fair will be held on November 5th. Register your projects by October 25th.</p>
                                        <small class="text-muted">Posted 5 days ago</small>
                                    </div>
                                    <div class="announcement-item">
                                        <h6>Holiday Notice</h6>
                                        <p>School will remain closed on September 30th due to national holiday.</p>
                                        <small class="text-muted">Posted 1 week ago</small>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer text-muted">
                                <a href="${pageContext.request.contextPath}/student/announcements">View all announcements</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">Upcoming Assignments</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Assignment</th>
                                                <th>Course</th>
                                                <th>Due Date</th>
                                                <th>Status</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Essay on Climate Change</td>
                                                <td>Biology</td>
                                                <td>Sep 25, 2023</td>
                                                <td><span class="badge badge-warning">Pending</span></td>
                                                <td><a href="#" class="btn btn-sm btn-primary">View</a></td>
                                            </tr>
                                            <tr>
                                                <td>Algebra Problem Set</td>
                                                <td>Mathematics</td>
                                                <td>Sep 28, 2023</td>
                                                <td><span class="badge badge-warning">Pending</span></td>
                                                <td><a href="#" class="btn btn-sm btn-primary">View</a></td>
                                            </tr>
                                            <tr>
                                                <td>Lab Report</td>
                                                <td>Chemistry</td>
                                                <td>Oct 2, 2023</td>
                                                <td><span class="badge badge-warning">Pending</span></td>
                                                <td><a href="#" class="btn btn-sm btn-primary">View</a></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="card-footer text-muted">
                                <a href="${pageContext.request.contextPath}/student/assignments">View all assignments</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 