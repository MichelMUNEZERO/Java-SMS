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
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-styles.css" />
    <style>
        .grade-card {
            transition: transform 0.3s;
            border-radius: var(--border-radius);
            border: none;
            box-shadow: var(--card-shadow);
        }
        .grade-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--hover-shadow);
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
        .profile-img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }
        .chart-container {
            position: relative;
            margin: auto;
            height: 160px;
            width: 160px;
        }
        .grade-distribution {
            height: 140px;
        }
        .gpa-chart-label {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
        }
        .grade-letter {
            position: relative;
            width: 40px;
            height: 40px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            color: white;
            font-weight: 600;
            margin-right: 5px;
        }
        .academic-status {
            padding: 0.5rem 1rem;
            border-radius: 30px;
            font-weight: 500;
            display: inline-block;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Include Student Sidebar -->
            <jsp:include page="/WEB-INF/includes/student-sidebar.jsp" />

            <!-- Main content -->
            <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <!-- Breadcrumb -->
                <nav aria-label="breadcrumb" class="mt-3">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/dashboard">Home</a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">
                            My Grades
                        </li>
                    </ol>
                </nav>

                <div class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center">
                    <h1 class="page-title">My Academic Performance</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="dropdown">
                            <button class="btn btn-outline-secondary dropdown-toggle d-flex align-items-center" type="button" id="dropdownMenuLink" data-bs-toggle="dropdown" aria-expanded="false">
                                <c:choose>
                                    <c:when test="${not empty profileData.imageLink}">
                                        <img src="${profileData.imageLink}" alt="${user.username}" class="profile-img me-2">
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-person-circle me-1"></i>
                                    </c:otherwise>
                                </c:choose>
                                <span>${user.username}</span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenuLink">
                                <li>
                                    <a class="dropdown-item" href="#"><i class="bi bi-person me-2"></i> Profile</a>
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
                        <div class="content-card">
                            <div class="card-body py-4">
                                <div class="row align-items-center">
                                    <div class="col-md-3 text-center border-end">
                                        <div class="chart-container mb-2">
                                            <canvas id="gpaChart"></canvas>
                                            <div class="gpa-chart-label">
                                                <div class="gpa-display text-primary">${gpa}</div>
                                                <small class="text-muted">GPA</small>
                                            </div>
                                        </div>
                                        <c:choose>
                                            <c:when test="${gpa >= 3.5}">
                                                <div class="academic-status bg-success bg-opacity-10 text-success">
                                                    <i class="bi bi-award me-1"></i> Dean's List
                                                </div>
                                            </c:when>
                                            <c:when test="${gpa >= 3.0}">
                                                <div class="academic-status bg-primary bg-opacity-10 text-primary">
                                                    <i class="bi bi-check-circle me-1"></i> Good Standing
                                                </div>
                                            </c:when>
                                            <c:when test="${gpa >= 2.0}">
                                                <div class="academic-status bg-warning bg-opacity-10 text-warning">
                                                    <i class="bi bi-exclamation-triangle me-1"></i> Academic Warning
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="academic-status bg-danger bg-opacity-10 text-danger">
                                                    <i class="bi bi-exclamation-circle me-1"></i> Academic Probation
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="col-md-5">
                                        <h5 class="mb-3">Grade Distribution</h5>
                                        <canvas id="gradeDistribution" class="grade-distribution"></canvas>
                                    </div>
                                    <div class="col-md-4">
                                        <h5 class="mb-3">Grade Scale</h5>
                                        <div class="d-flex flex-wrap gap-2 mb-2">
                                            <div class="grade-letter bg-success">A</div>
                                            <div class="grade-letter bg-primary">B</div>
                                            <div class="grade-letter bg-info">C</div>
                                            <div class="grade-letter bg-warning">D</div>
                                            <div class="grade-letter bg-danger">F</div>
                                        </div>
                                        <div class="bg-light p-3 rounded">
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <span class="small">Your GPA Percentile:</span>
                                                <span class="badge bg-primary rounded-pill">Top ${gpa >= 3.5 ? '10%' : (gpa >= 3.0 ? '25%' : (gpa >= 2.5 ? '50%' : '75%'))}</span>
                                            </div>
                                            <div class="progress">
                                                <div class="progress-bar bg-success" role="progressbar" 
                                                    style="width: ${gpa * 25}%;" 
                                                    aria-valuenow="${gpa * 25}" 
                                                    aria-valuemin="0" 
                                                    aria-valuemax="100">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Term Selector and Export Options -->
                <div class="row mb-4">
                    <div class="col-md-12">
                        <div class="content-card">
                            <div class="card-body p-3">
                                <div class="row align-items-center">
                                    <div class="col-md-6">
                                        <select class="form-select" id="termSelector">
                                            <option selected>Current Term (Spring 2023)</option>
                                            <option>Fall 2022</option>
                                            <option>Summer 2022</option>
                                            <option>Spring 2022</option>
                                            <option>All Terms</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6 text-md-end mt-3 mt-md-0">
                                        <div class="btn-group">
                                            <button type="button" class="btn btn-outline-primary">
                                                <i class="bi bi-printer me-2"></i> Print
                                            </button>
                                            <button type="button" class="btn btn-outline-primary">
                                                <i class="bi bi-download me-2"></i> Export
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Course Grades -->
                <h4 class="mb-3 d-flex align-items-center">
                    <i class="bi bi-mortarboard-fill text-primary me-2"></i>
                    Course Performance
                </h4>

                <c:choose>
                    <c:when test="${empty gradesList}">
                        <div class="content-card">
                            <div class="card-body text-center py-5">
                                <i class="bi bi-clipboard-data text-muted" style="font-size: 4rem;"></i>
                                <h4 class="mt-3">No Grade Records Found</h4>
                                <p class="text-muted">Grades will appear here once your assignments are evaluated.</p>
                            </div>
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
                                <div class="content-card mb-4">
                                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                        <div>
                                            <h5 class="mb-0 d-flex align-items-center">
                                                <div class="bg-primary bg-opacity-10 p-2 rounded me-2">
                                                    <i class="bi bi-book text-primary"></i>
                                                </div>
                                                ${grade.courseCode}: ${grade.courseName}
                                            </h5>
                                        </div>
                                        <span class="badge bg-primary rounded-pill px-3">${grade.credits} Credits</span>
                                    </div>
                                    <div class="card-body p-0">
                                        <div class="table-responsive">
                                            <table class="table table-hover align-middle mb-0">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Assignment</th>
                                                        <th>Score</th>
                                                        <th style="width: 30%">Percentage</th>
                                                        <th class="text-center">Grade</th>
                                                        <th class="text-center">Feedback</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                            </c:if>

                            <tr>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="bg-${grade.percentage >= 90 ? 'success' : grade.percentage >= 80 ? 'primary' : grade.percentage >= 70 ? 'info' : grade.percentage >= 60 ? 'warning' : 'danger'} bg-opacity-10 p-2 rounded-circle me-2">
                                            <i class="bi bi-${grade.assignmentName.toLowerCase().contains('exam') ? 'journal-check' : grade.assignmentName.toLowerCase().contains('quiz') ? 'question-circle' : 'file-earmark-text'} text-${grade.percentage >= 90 ? 'success' : grade.percentage >= 80 ? 'primary' : grade.percentage >= 70 ? 'info' : grade.percentage >= 60 ? 'warning' : 'danger'}"></i>
                                        </div>
                                        <span>${grade.assignmentName}</span>
                                    </div>
                                </td>
                                <td>
                                    <strong>${grade.marksObtained}</strong> / ${grade.totalMarks}
                                </td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="progress flex-grow-1 me-2">
                                            <div class="progress-bar bg-${grade.percentage >= 90 ? 'success' : grade.percentage >= 80 ? 'primary' : grade.percentage >= 70 ? 'info' : grade.percentage >= 60 ? 'warning' : 'danger'}" 
                                                role="progressbar" 
                                                style="width: ${grade.percentage}%;" 
                                                aria-valuenow="${grade.percentage}" 
                                                aria-valuemin="0" 
                                                aria-valuemax="100">
                                            </div>
                                        </div>
                                        <span class="badge bg-${grade.percentage >= 90 ? 'success' : grade.percentage >= 80 ? 'primary' : grade.percentage >= 70 ? 'info' : grade.percentage >= 60 ? 'warning' : 'danger'} bg-opacity-10 text-${grade.percentage >= 90 ? 'success' : grade.percentage >= 80 ? 'primary' : grade.percentage >= 70 ? 'info' : grade.percentage >= 60 ? 'warning' : 'danger'} fw-normal">${grade.percentage}%</span>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <span class="grade-badge bg-${grade.percentage >= 90 ? 'success' : grade.percentage >= 80 ? 'primary' : grade.percentage >= 70 ? 'info' : grade.percentage >= 60 ? 'warning' : 'danger'} text-white">${grade.grade}</span>
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${empty grade.feedback}">
                                            <span class="text-muted small">No feedback</span>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#feedbackModal${loop.index}">
                                                <i class="bi bi-chat-left-text me-1"></i> View
                                            </button>

                                            <!-- Feedback Modal -->
                                            <div class="modal fade" id="feedbackModal${loop.index}" tabindex="-1" aria-labelledby="feedbackModalLabel${loop.index}" aria-hidden="true">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="feedbackModalLabel${loop.index}">
                                                                <i class="bi bi-chat-left-quote me-2 text-primary"></i>
                                                                Feedback: ${grade.assignmentName}
                                                            </h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <div class="mb-3">
                                                                <div class="d-flex justify-content-between mb-2">
                                                                    <span class="fw-medium">Score:</span>
                                                                    <span class="badge bg-${grade.percentage >= 90 ? 'success' : grade.percentage >= 80 ? 'primary' : grade.percentage >= 70 ? 'info' : grade.percentage >= 60 ? 'warning' : 'danger'} text-white">${grade.marksObtained} / ${grade.totalMarks} (${grade.percentage}%)</span>
                                                                </div>
                                                                <div class="d-flex justify-content-between mb-2">
                                                                    <span class="fw-medium">Grade:</span>
                                                                    <span class="badge bg-${grade.percentage >= 90 ? 'success' : grade.percentage >= 80 ? 'primary' : grade.percentage >= 70 ? 'info' : grade.percentage >= 60 ? 'warning' : 'danger'} text-white">${grade.grade}</span>
                                                                </div>
                                                            </div>
                                                            <div class="card">
                                                                <div class="card-header bg-light">
                                                                    <h6 class="mb-0">Instructor Feedback</h6>
                                                                </div>
                                                                <div class="card-body">
                                                                    <p class="mb-0">${grade.feedback}</p>
                                                                </div>
                                                            </div>
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

                <!-- Grade Information -->
                <div class="row mt-4 mb-4">
                    <div class="col-md-12">
                        <div class="content-card">
                            <div class="card-header bg-white d-flex align-items-center">
                                <i class="bi bi-info-circle text-primary me-2 fs-5"></i>
                                <h5 class="card-title mb-0">Grading Information</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <h6 class="mb-3">Grading Scale</h6>
                                        <div class="table-responsive">
                                            <table class="table table-bordered mb-0">
                                                <thead>
                                                    <tr class="table-light">
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
                                    </div>
                                    <div class="col-md-6">
                                        <h6 class="mb-3">Academic Standing</h6>
                                        <div class="table-responsive">
                                            <table class="table table-bordered mb-0">
                                                <thead>
                                                    <tr class="table-light">
                                                        <th>GPA Range</th>
                                                        <th>Standing</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td>3.5 - 4.0</td>
                                                        <td><span class="badge bg-success">Dean's List</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td>3.0 - 3.49</td>
                                                        <td><span class="badge bg-primary">Good Standing</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td>2.0 - 2.99</td>
                                                        <td><span class="badge bg-warning text-dark">Academic Warning</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Below 2.0</td>
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
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize GPA Chart
            const gpaCanvas = document.getElementById('gpaChart');
            if (gpaCanvas) {
                new Chart(gpaCanvas, {
                    type: 'doughnut',
                    data: {
                        datasets: [{
                            data: [${gpa}, 4.0 - ${gpa}],
                            backgroundColor: [
                                '${gpa >= 3.5 ? "#28a745" : (gpa >= 3.0 ? "#0d6efd" : (gpa >= 2.0 ? "#ffc107" : "#dc3545"))}',
                                '#e9ecef'
                            ],
                            cutout: '75%',
                            borderWidth: 0
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                display: false
                            },
                            tooltip: {
                                enabled: false
                            }
                        }
                    }
                });
            }
            
            // Initialize Grade Distribution Chart
            const gradeDistCanvas = document.getElementById('gradeDistribution');
            if (gradeDistCanvas) {
                new Chart(gradeDistCanvas, {
                    type: 'bar',
                    data: {
                        labels: ['A', 'B', 'C', 'D', 'F'],
                        datasets: [{
                            label: 'Number of Grades',
                            data: [
                                // In a real implementation, these would be calculated from gradesList
                                ${gradesList.stream().filter(g -> g.percentage >= 90).count()},
                                ${gradesList.stream().filter(g -> g.percentage >= 80 && g.percentage < 90).count()},
                                ${gradesList.stream().filter(g -> g.percentage >= 70 && g.percentage < 80).count()},
                                ${gradesList.stream().filter(g -> g.percentage >= 60 && g.percentage < 70).count()},
                                ${gradesList.stream().filter(g -> g.percentage < 60).count()}
                            ],
                            backgroundColor: [
                                'rgba(40, 167, 69, 0.7)', // success
                                'rgba(13, 110, 253, 0.7)', // primary
                                'rgba(23, 162, 184, 0.7)', // info
                                'rgba(255, 193, 7, 0.7)', // warning
                                'rgba(220, 53, 69, 0.7)'  // danger
                            ],
                            borderColor: [
                                'rgb(40, 167, 69)',
                                'rgb(13, 110, 253)',
                                'rgb(23, 162, 184)',
                                'rgb(255, 193, 7)',
                                'rgb(220, 53, 69)'
                            ],
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    stepSize: 1
                                },
                                grid: {
                                    display: false
                                }
                            },
                            x: {
                                grid: {
                                    display: false
                                }
                            }
                        },
                        plugins: {
                            legend: {
                                display: false
                            }
                        }
                    }
                });
            }
            
            // Add animation to cards
            const cards = document.querySelectorAll('.content-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transition = 'opacity 0.5s ease, transform 0.3s ease';
                setTimeout(() => {
                    card.style.opacity = '1';
                }, 100 * index);
            });
        });
    </script>
</body>
</html> 