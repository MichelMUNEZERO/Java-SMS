<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Reports - School Management System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-styles.css">
    <style>
        .filter-section {
            background-color: var(--bg-light);
            padding: 1.5rem;
            border-radius: var(--border-radius);
            margin-bottom: 1.5rem;
            box-shadow: var(--card-shadow);
        }
        
        .report-container {
            margin-top: 1.5rem;
        }
        
        .report-card {
            border-radius: var(--border-radius);
            border: none;
            box-shadow: var(--card-shadow);
            transition: all var(--transition-speed);
            height: 100%;
        }
        
        .report-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--hover-shadow);
        }
        
        .report-type-card {
            cursor: pointer;
            height: 100%;
            padding: 1.5rem;
            text-align: center;
            transition: all var(--transition-speed);
        }
        
        .report-type-card:hover {
            background-color: rgba(13, 110, 253, 0.05);
        }
        
        .report-type-card.selected {
            background-color: rgba(13, 110, 253, 0.1);
            border-left: 3px solid var(--primary-color);
        }
        
        .report-type-icon {
            font-size: 2rem;
            margin-bottom: 1rem;
            color: var(--primary-color);
        }
        
        .report-preview {
            min-height: 400px;
        }
        
        .report-actions {
            display: flex;
            gap: 0.5rem;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Include Teacher Sidebar -->
            <jsp:include page="/WEB-INF/includes/teacher-sidebar.jsp" />
            
            <!-- Main content -->
            <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <!-- Breadcrumb -->
                <nav aria-label="breadcrumb" class="mt-3">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/teacher/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Reports</li>
                    </ol>
                </nav>

                <div class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center">
                    <h1 class="page-title">Teacher Reports</h1>
                    <div class="btn-toolbar">
                        <div class="dropdown">
                            <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="dropdownMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-person-circle me-1"></i> ${user.username}
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenuButton">
                                <li><a class="dropdown-item" href="#"><i class="bi bi-person me-2"></i> My Profile</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i> Logout</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
                
                <!-- Alert for messages -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i> ${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                
                <!-- Generate Reports Section -->
                <div class="content-card mb-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Generate Reports</h5>
                        <button class="btn btn-sm btn-outline-secondary">
                            <i class="bi bi-question-circle me-1"></i> Help
                        </button>
                    </div>
                    <div class="card-body">
                <div class="row mb-4">
                            <div class="col-md-4 mb-3">
                                <div class="report-type-card selected" data-report="marks">
                                    <div class="report-type-icon">
                                        <i class="bi bi-bar-chart"></i>
                                    </div>
                                    <h5>Academic Marks</h5>
                                    <p class="text-muted small">Generate reports on student academic performance</p>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="report-type-card" data-report="behavior">
                                    <div class="report-type-icon">
                                        <i class="bi bi-clipboard-check"></i>
                                    </div>
                                    <h5>Student Behavior</h5>
                                    <p class="text-muted small">Track behavioral records and incidents</p>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="report-type-card" data-report="attendance">
                                    <div class="report-type-icon">
                                        <i class="bi bi-calendar-check"></i>
                                    </div>
                                    <h5>Attendance Report</h5>
                                    <p class="text-muted small">Monitor student attendance patterns</p>
                                </div>
                            </div>
                                            </div>
                                            
                        <div class="filter-section">
                            <form id="report-filter-form" action="${pageContext.request.contextPath}/teacher/reports" method="post">
                                <input type="hidden" id="reportTypeInput" name="reportType" value="marks">
                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <label for="courseId" class="form-label required-field">Course</label>
                                        <select class="form-select" id="courseId" name="courseId" required>
                                            <option value="">Select Course</option>
                                                    <c:forEach items="${teacherCourses}" var="course">
                                                        <option value="${course.courseId}" ${param.courseId eq course.courseId ? 'selected' : ''}>${course.courseName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            
                                    <div class="col-md-4">
                                        <label for="periodSelect" class="form-label">Time Period</label>
                                        <select class="form-select" id="periodSelect" name="period">
                                            <option value="current">Current Term</option>
                                            <option value="lastTerm">Last Term</option>
                                            <option value="year">Full Academic Year</option>
                                            <option value="custom">Custom Range</option>
                                        </select>
                                    </div>
                                    
                                    <div class="col-md-4">
                                        <label for="formatSelect" class="form-label">Output Format</label>
                                        <select class="form-select" id="formatSelect" name="format">
                                            <option value="table">Tabular View</option>
                                            <option value="chart">Chart View</option>
                                            <option value="pdf">PDF Document</option>
                                            <option value="excel">Excel Spreadsheet</option>
                                        </select>
                                    </div>
                                    
                                    <!-- Dynamic fields for Academic Marks report type -->
                                    <div class="col-md-4 marks-filter">
                                        <label for="gradeThreshold" class="form-label">Minimum Grade (%)</label>
                                        <input type="number" class="form-control" id="gradeThreshold" name="gradeThreshold" 
                                               min="0" max="100" placeholder="e.g., 70" value="${param.gradeThreshold}">
                                    </div>
                                    
                                    <div class="col-md-4 marks-filter">
                                        <label for="studentId" class="form-label">Student (Optional)</label>
                                                <select class="form-select" id="studentId" name="studentId">
                                                    <option value="">All Students</option>
                                            <c:forEach items="${students}" var="student">
                                                <option value="${student.id}" ${param.studentId eq student.id ? 'selected' : ''}>${student.firstName} ${student.lastName}</option>
                                            </c:forEach>
                                                </select>
                                            </div>
                                            
                                    <div class="col-md-4 marks-filter">
                                        <label for="assessmentType" class="form-label">Assessment Type</label>
                                        <select class="form-select" id="assessmentType" name="assessmentType">
                                            <option value="">All Types</option>
                                            <option value="exam">Exams</option>
                                            <option value="quiz">Quizzes</option>
                                            <option value="assignment">Assignments</option>
                                            <option value="project">Projects</option>
                                        </select>
                                            </div>
                                            
                                    <!-- Dynamic fields for Student Behavior report type (initially hidden) -->
                                    <div class="col-md-4 behavior-filter d-none">
                                                <label for="behaviorType" class="form-label">Behavior Type</label>
                                                <select class="form-select" id="behaviorType" name="behaviorType">
                                                    <option value="">All Types</option>
                                                    <option value="positive" ${param.behaviorType eq 'positive' ? 'selected' : ''}>Positive</option>
                                                    <option value="negative" ${param.behaviorType eq 'negative' ? 'selected' : ''}>Negative</option>
                                                    <option value="neutral" ${param.behaviorType eq 'neutral' ? 'selected' : ''}>Neutral</option>
                                                </select>
                                            </div>
                                            
                                    <!-- Dynamic fields for Attendance report type (initially hidden) -->
                                    <div class="col-md-4 attendance-filter d-none">
                                        <label for="attendanceStatus" class="form-label">Attendance Status</label>
                                        <select class="form-select" id="attendanceStatus" name="attendanceStatus">
                                            <option value="">All Status</option>
                                            <option value="present" ${param.attendanceStatus eq 'present' ? 'selected' : ''}>Present</option>
                                            <option value="absent" ${param.attendanceStatus eq 'absent' ? 'selected' : ''}>Absent</option>
                                            <option value="late" ${param.attendanceStatus eq 'late' ? 'selected' : ''}>Late</option>
                                                </select>
                                            </div>
                                            </div>
                                            
                                <div class="d-flex justify-content-end mt-4">
                                    <button type="button" class="btn btn-outline-secondary me-2" id="resetFilters">
                                        <i class="bi bi-x-circle me-1"></i> Reset
                                    </button>
                                    <button type="submit" class="btn btn-primary" id="generateReport">
                                                    <i class="bi bi-file-earmark-text me-1"></i> Generate Report
                                                </button>
                                            </div>
                            </form>
                        </div>
                        
                        <!-- Report Preview -->
                        <div class="report-container">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5>Report Preview</h5>
                                <div class="report-actions">
                                    <button class="btn btn-sm btn-outline-primary">
                                        <i class="bi bi-printer me-1"></i> Print
                                    </button>
                                    <button class="btn btn-sm btn-outline-success">
                                        <i class="bi bi-file-earmark-excel me-1"></i> Export
                                    </button>
                                    <button class="btn btn-sm btn-outline-info">
                                        <i class="bi bi-share me-1"></i> Share
                                    </button>
                                        </div>
                                    </div>
                            
                            <div class="report-preview">
                                <!-- If report data exists, show the report, otherwise show initial state -->
                                <c:choose>
                                    <c:when test="${not empty reportData}">
                                        <!-- Report data will be displayed here based on the selected type -->
                                            <div class="table-responsive">
                                            <table class="table table-striped table-hover">
                                                <thead>
                                                        <tr>
                                                        <th>Student</th>
                                                        <th>Assessment</th>
                                                                <th>Course</th>
                                                                <th>Grade</th>
                                                                <th>Date</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                    <c:forEach items="${reportData}" var="item">
                                                        <tr>
                                                            <td>${item.studentName}</td>
                                                            <td>${item.assessmentName}</td>
                                                            <td>${item.courseName}</td>
                                                            <td>${item.grade}</td>
                                                            <td>${item.date}</td>
                                                                </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Initial state -->
                                        <div class="text-center py-5">
                                            <div class="mb-3">
                                                <i class="bi bi-file-earmark-text text-muted" style="font-size: 3rem;"></i>
                                            </div>
                                            <h5 class="text-muted">No Report Generated Yet</h5>
                                            <p class="text-muted">Select your filters above and click "Generate Report" to view data</p>
                                    </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Saved Reports Section -->
                <div class="content-card mb-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Saved Reports</h5>
                        <button class="btn btn-sm btn-outline-primary">
                            <i class="bi bi-folder-plus me-1"></i> New Folder
                        </button>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th>Report Name</th>
                                        <th>Type</th>
                                        <th>Course</th>
                                        <th>Created</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty savedReports}">
                                            <c:forEach items="${savedReports}" var="report">
                                                <tr>
                                                    <td>${report.name}</td>
                                                    <td><span class="badge bg-primary">${report.type}</span></td>
                                                    <td>${report.course}</td>
                                                    <td>${report.created}</td>
                                                    <td>
                                                        <div class="action-buttons">
                                                            <button class="btn btn-sm btn-primary" title="View Report">
                                                                <i class="bi bi-eye"></i>
                                                            </button>
                                                            <button class="btn btn-sm btn-success" title="Download Report">
                                                                <i class="bi bi-download"></i>
                                                            </button>
                                                            <button class="btn btn-sm btn-danger" title="Delete Report">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="5" class="text-center py-3">
                                                    <div class="d-flex flex-column align-items-center">
                                                        <i class="bi bi-info-circle text-muted mb-2" style="font-size: 1.5rem"></i>
                                                        <p class="text-muted mb-0">No saved reports found</p>
                                                    </div>
                                                </td>
                                            </tr>
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
    
    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Initialize DataTable
            if ($.fn.DataTable.isDataTable('table')) {
                $('table').DataTable().destroy();
            }
            
            $('table').DataTable({
                "paging": true,
                "ordering": true,
                "info": true,
                "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]]
            });
            
            // Report Type selection
            $('.report-type-card').click(function() {
                // Remove selected class from all cards
                $('.report-type-card').removeClass('selected');
                // Add selected class to clicked card
                $(this).addClass('selected');
                
                // Get report type
                const reportType = $(this).data('report');
                
                // Update hidden input
                $('#reportTypeInput').val(reportType);
                
                // Hide all dynamic filter fields
                $('.marks-filter, .behavior-filter, .attendance-filter').addClass('d-none');
                
                // Show specific filter fields for selected report type
                if (reportType === 'marks') {
                    $('.marks-filter').removeClass('d-none');
                } else if (reportType === 'behavior') {
                    $('.behavior-filter').removeClass('d-none');
                } else if (reportType === 'attendance') {
                    $('.attendance-filter').removeClass('d-none');
                }
            });
            
            // Reset filters
            $('#resetFilters').click(function() {
                $('#report-filter-form')[0].reset();
            });
            
            // Check initial state
            const initialReportType = $('#reportTypeInput').val();
            $(`.report-type-card[data-report="${initialReportType}"]`).click();
        });
    </script>
</body>
</html> 