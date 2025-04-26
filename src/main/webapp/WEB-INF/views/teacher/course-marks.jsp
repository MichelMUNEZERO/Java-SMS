<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Course Marks - School Management System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .dashboard-card {
            transition: transform 0.3s;
            border-radius: 10px;
            border: none;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            height: 100%;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        .teacher-profile {
            display: flex;
            align-items: center;
            padding: 1rem;
        }
        .teacher-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 10px;
        }
        .table-marks input {
            width: 80px;
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
                            <a class="nav-link active text-white" href="${pageContext.request.contextPath}/teacher/courses">
                                <i class="bi bi-book me-2"></i> My Courses
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/teacher/student">
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

            <!-- Main content -->
            <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 mt-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Manage Course Marks: ${courseDetails.courseName}</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/teacher/course-details?id=${courseDetails.courseId}" class="btn btn-sm btn-outline-secondary">
                            <i class="bi bi-arrow-left me-1"></i> Back to Course Details
                        </a>
                    </div>
                </div>

                <!-- Course information card -->
                <div class="row mb-4">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header bg-primary text-white">
                                <h5 class="card-title mb-0">Course Information</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <p><strong>Course Code:</strong> ${courseDetails.courseCode}</p>
                                        <p><strong>Course Name:</strong> ${courseDetails.courseName}</p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><strong>Credits:</strong> ${courseDetails.credits}</p>
                                        <p><strong>Semester:</strong> ${courseDetails.semester}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Marks Management Form -->
                <div class="row mb-4">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="card-title mb-0">Student Marks</h5>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${not empty enrolledStudents}">
                                        <form id="marksForm" action="${pageContext.request.contextPath}/teacher/course-marks" method="post">
                                            <input type="hidden" name="courseId" value="${courseDetails.courseId}">
                                            <input type="hidden" name="action" value="update">
                                            
                                            <div class="table-responsive">
                                                <table id="marksTable" class="table table-striped table-marks">
                                                    <thead>
                                                        <tr>
                                                            <th>Student Name</th>
                                                            <th>Assignment (20%)</th>
                                                            <th>Midterm (30%)</th>
                                                            <th>Final Exam (40%)</th>
                                                            <th>Participation (10%)</th>
                                                            <th>Total</th>
                                                            <th>Grade</th>
                                                            <th>Actions</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach items="${enrolledStudents}" var="student" varStatus="status">
                                                            <tr>
                                                                <td>${student.firstName} ${student.lastName}</td>
                                                                <td>
                                                                    <input type="number" class="form-control form-control-sm assignment" 
                                                                        name="students[${status.index}].assignment" 
                                                                        value="${student.marks.assignment}" 
                                                                        min="0" max="100">
                                                                    <input type="hidden" name="students[${status.index}].studentId" value="${student.studentId}">
                                                                </td>
                                                                <td>
                                                                    <input type="number" class="form-control form-control-sm midterm" 
                                                                        name="students[${status.index}].midterm" 
                                                                        value="${student.marks.midterm}" 
                                                                        min="0" max="100">
                                                                </td>
                                                                <td>
                                                                    <input type="number" class="form-control form-control-sm finalExam" 
                                                                        name="students[${status.index}].finalExam" 
                                                                        value="${student.marks.finalExam}" 
                                                                        min="0" max="100">
                                                                </td>
                                                                <td>
                                                                    <input type="number" class="form-control form-control-sm participation" 
                                                                        name="students[${status.index}].participation" 
                                                                        value="${student.marks.participation}" 
                                                                        min="0" max="100">
                                                                </td>
                                                                <td>
                                                                    <span class="total-mark">${student.marks.total}</span>
                                                                    <input type="hidden" name="students[${status.index}].total" class="total-input" value="${student.marks.total}">
                                                                </td>
                                                                <td>
                                                                    <span class="grade">${student.marks.grade}</span>
                                                                    <input type="hidden" name="students[${status.index}].grade" class="grade-input" value="${student.marks.grade}">
                                                                </td>
                                                                <td>
                                                                    <button type="button" class="btn btn-primary btn-sm calculate-row">
                                                                        <i class="bi bi-calculator"></i> Calculate
                                                                    </button>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                            
                                            <div class="text-end mt-3">
                                                <button type="button" id="calculateAll" class="btn btn-secondary me-2">
                                                    <i class="bi bi-calculator"></i> Calculate All
                                                </button>
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="bi bi-save"></i> Save All Marks
                                                </button>
                                            </div>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert alert-info">
                                            <i class="bi bi-info-circle me-2"></i> No students enrolled in this course yet. Please enroll students first.
                                        </div>
                                        <div class="text-center">
                                            <a href="${pageContext.request.contextPath}/teacher/course-students?id=${courseDetails.courseId}" class="btn btn-primary">
                                                <i class="bi bi-people me-1"></i> Manage Students
                                            </a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Grade Scale Reference -->
                <div class="row mb-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header bg-info text-white">
                                <h5 class="card-title mb-0">Grading Scale Reference</h5>
                            </div>
                            <div class="card-body">
                                <table class="table table-sm table-bordered">
                                    <thead>
                                        <tr>
                                            <th>Grade</th>
                                            <th>Range</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr><td>A+</td><td>95-100</td></tr>
                                        <tr><td>A</td><td>90-94</td></tr>
                                        <tr><td>A-</td><td>85-89</td></tr>
                                        <tr><td>B+</td><td>80-84</td></tr>
                                        <tr><td>B</td><td>75-79</td></tr>
                                        <tr><td>B-</td><td>70-74</td></tr>
                                        <tr><td>C+</td><td>65-69</td></tr>
                                        <tr><td>C</td><td>60-64</td></tr>
                                        <tr><td>C-</td><td>55-59</td></tr>
                                        <tr><td>D</td><td>50-54</td></tr>
                                        <tr><td>F</td><td>0-49</td></tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header bg-warning">
                                <h5 class="card-title mb-0">Mark Weights</h5>
                            </div>
                            <div class="card-body">
                                <table class="table table-sm table-bordered">
                                    <thead>
                                        <tr>
                                            <th>Assessment</th>
                                            <th>Weight</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr><td>Assignment</td><td>20%</td></tr>
                                        <tr><td>Midterm</td><td>30%</td></tr>
                                        <tr><td>Final Exam</td><td>40%</td></tr>
                                        <tr><td>Participation</td><td>10%</td></tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#marksTable').DataTable({
                "paging": true,
                "searching": true,
                "ordering": true,
                "info": true,
                "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]]
            });
            
            // Calculate marks for a single row
            $('.calculate-row').click(function() {
                const row = $(this).closest('tr');
                calculateMarks(row);
            });
            
            // Calculate all marks
            $('#calculateAll').click(function() {
                $('#marksTable tbody tr').each(function() {
                    calculateMarks($(this));
                });
            });
            
            function calculateMarks(row) {
                const assignment = parseFloat(row.find('.assignment').val()) || 0;
                const midterm = parseFloat(row.find('.midterm').val()) || 0;
                const finalExam = parseFloat(row.find('.finalExam').val()) || 0;
                const participation = parseFloat(row.find('.participation').val()) || 0;
                
                // Calculate weighted total
                const total = (assignment * 0.2) + (midterm * 0.3) + (finalExam * 0.4) + (participation * 0.1);
                const roundedTotal = Math.round(total * 10) / 10;  // Round to 1 decimal place
                
                // Assign grade based on total
                let grade = '';
                if (roundedTotal >= 95) grade = 'A+';
                else if (roundedTotal >= 90) grade = 'A';
                else if (roundedTotal >= 85) grade = 'A-';
                else if (roundedTotal >= 80) grade = 'B+';
                else if (roundedTotal >= 75) grade = 'B';
                else if (roundedTotal >= 70) grade = 'B-';
                else if (roundedTotal >= 65) grade = 'C+';
                else if (roundedTotal >= 60) grade = 'C';
                else if (roundedTotal >= 55) grade = 'C-';
                else if (roundedTotal >= 50) grade = 'D';
                else grade = 'F';
                
                // Update display and hidden inputs
                row.find('.total-mark').text(roundedTotal);
                row.find('.total-input').val(roundedTotal);
                row.find('.grade').text(grade);
                row.find('.grade-input').val(grade);
                
                // Highlight the row briefly to show it's been calculated
                row.addClass('table-success');
                setTimeout(function() {
                    row.removeClass('table-success');
                }, 500);
            }
        });
    </script>
</body>
</html> 