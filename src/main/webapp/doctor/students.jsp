<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Health Records - School Management System</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
      rel="stylesheet"
    />
    
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-styles.css">
    
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fc;
        }
        
        .content-card {
            transition: transform 0.3s;
            border-radius: 0.75rem;
            border: none;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            margin-bottom: 1.5rem;
        }
        
        .content-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0.3rem 2rem rgba(0, 0, 0, 0.1);
        }
        
        .card-header {
            background-color: white;
            border-bottom: 1px solid #e9ecef;
            padding: 1rem 1.5rem;
            font-weight: 500;
        }
        
        .student-table {
            font-size: 0.9rem;
        }
        
        .student-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .search-container {
            background-color: white;
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #4e73df;
            box-shadow: 0 0 0 0.25rem rgba(78, 115, 223, 0.25);
        }
        
        .btn-primary {
            background-color: #4e73df;
            border-color: #4e73df;
        }
        
        .btn-primary:hover {
            background-color: #4262c5;
            border-color: #3d5cb8;
        }
        
        .dataTables_wrapper .dataTables_paginate .paginate_button.current, 
        .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
            background: #4e73df !important;
            color: white !important;
            border: none;
        }
        
        .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
            background: #eaecf4 !important;
            color: #4e73df !important;
        }
        
        .badge {
            font-weight: 600;
            font-size: 0.75rem;
            padding: 0.35em 0.65em;
        }
        
        .breadcrumb {
            background-color: transparent;
            padding: 0;
        }
        
        .breadcrumb-item a {
            color: #4e73df;
            text-decoration: none;
        }
        
        .page-title {
            font-weight: 600;
            color: #5a5c69;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Include Doctor Sidebar -->
            <jsp:include page="/WEB-INF/includes/doctor-sidebar.jsp" />
            
            <!-- Main Content -->
            <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <!-- Breadcrumb -->
                <nav aria-label="breadcrumb" class="mt-3">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/dashboard">Home</a>
                        </li>
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/doctor/dashboard">Doctor Dashboard</a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">
                            Student Health Records
                        </li>
                    </ol>
                </nav>

                <div class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center">
                    <h1 class="page-title">Student Health Records</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="dropdown">
                            <button
                                class="btn btn-outline-secondary dropdown-toggle d-flex align-items-center"
                                type="button"
                                id="dropdownMenuLink"
                                data-bs-toggle="dropdown"
                                aria-expanded="false"
                            >
                                <c:choose>
                                    <c:when test="${not empty user.imageLink}">
                                        <img src="${user.imageLink}" alt="${user.username}" class="profile-img me-2" style="width: 32px; height: 32px;">
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-person-circle me-1"></i>
                                    </c:otherwise>
                                </c:choose>
                                <span>Dr. ${user.username}</span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenuLink">
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/doctor/profile">
                                        <i class="bi bi-person me-2"></i> Profile
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider" /></li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                        <i class="bi bi-box-arrow-right me-2"></i> Logout
                                    </a>
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
                
                <!-- Search and Filter Section -->
                <div class="search-container mb-4">
                    <div class="row align-items-center">
                        <div class="col-md-6 mb-3 mb-md-0">
                            <div class="input-group">
                                <span class="input-group-text bg-light border-0">
                                    <i class="bi bi-search text-muted"></i>
                                </span>
                                <input type="text" id="studentSearch" class="form-control border-0 bg-light" placeholder="Search by name, ID, grade...">
                            </div>
                        </div>
                        <div class="col-md-4 mb-3 mb-md-0">
                            <select class="form-select bg-light border-0" id="gradeFilter">
                                <option value="">All Grades</option>
                                <option value="1">Grade 1</option>
                                <option value="2">Grade 2</option>
                                <option value="3">Grade 3</option>
                                <option value="4">Grade 4</option>
                                <option value="5">Grade 5</option>
                                <option value="6">Grade 6</option>
                                <option value="7">Grade 7</option>
                                <option value="8">Grade 8</option>
                                <option value="9">Grade 9</option>
                                <option value="10">Grade 10</option>
                                <option value="11">Grade 11</option>
                                <option value="12">Grade 12</option>
                            </select>
                        </div>
                        <div class="col-md-2 text-md-end">
                            <button class="btn btn-primary w-100">
                                <i class="bi bi-filter me-1"></i> Filter
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Stats Summary Cards -->
                <div class="row mb-4">
                    <div class="col-md-4 mb-3">
                        <div class="content-card h-100">
                            <div class="card-body p-4">
                                <div class="d-flex justify-content-between mb-3">
                                    <div class="bg-primary bg-opacity-10 p-3 rounded">
                                        <i class="bi bi-people text-primary" style="font-size: 1.8rem;"></i>
                                    </div>
                                    <h2 class="text-primary mb-0">${students.size()}</h2>
                                </div>
                                <h5 class="text-muted mb-3">Total Students</h5>
                                <div class="progress">
                                    <div class="progress-bar bg-primary" role="progressbar" style="width: 100%;"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-3">
                        <div class="content-card h-100">
                            <div class="card-body p-4">
                                <div class="d-flex justify-content-between mb-3">
                                    <div class="bg-success bg-opacity-10 p-3 rounded">
                                        <i class="bi bi-check-circle text-success" style="font-size: 1.8rem;"></i>
                                    </div>
                                    <h2 class="text-success mb-0">23</h2>
                                </div>
                                <h5 class="text-muted mb-3">Completed Checkups</h5>
                                <div class="progress">
                                    <div class="progress-bar bg-success" role="progressbar" style="width: 65%;"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-3">
                        <div class="content-card h-100">
                            <div class="card-body p-4">
                                <div class="d-flex justify-content-between mb-3">
                                    <div class="bg-warning bg-opacity-10 p-3 rounded">
                                        <i class="bi bi-clipboard2-pulse text-warning" style="font-size: 1.8rem;"></i>
                                    </div>
                                    <h2 class="text-warning mb-0">12</h2>
                                </div>
                                <h5 class="text-muted mb-3">Pending Checkups</h5>
                                <div class="progress">
                                    <div class="progress-bar bg-warning" role="progressbar" style="width: 35%;"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Students List -->
                <div class="content-card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">
                            <i class="bi bi-person-vcard me-2 text-primary"></i>
                            Student Records
                        </h5>
                        <a href="#" class="btn btn-sm btn-outline-primary">
                            <i class="bi bi-download me-1"></i> Export
                        </a>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover student-table" id="studentTable">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Grade</th>
                                        <th>Gender</th>
                                        <th>Contact</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="student" items="${students}">
                                        <tr>
                                            <td class="fw-medium">${student.id}</td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <div class="bg-primary bg-opacity-10 rounded-circle me-2 student-avatar">
                                                        <i class="bi bi-person text-primary"></i>
                                                    </div>
                                                    <div>
                                                        <span class="fw-medium">${student.firstName} ${student.lastName}</span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>Grade ${student.grade}</td>
                                            <td>
                                                <c:if test="${not empty student.gender}">
                                                    ${student.gender}
                                                </c:if>
                                                <c:if test="${empty student.gender}">
                                                    <span class="text-muted">Not specified</span>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${not empty student.phone}">
                                                    ${student.phone}
                                                </c:if>
                                                <c:if test="${empty student.phone}">
                                                    <span class="text-muted">Not available</span>
                                                </c:if>
                                            </td>
                                            <td>
                                                <!-- Sample status badges - in real app would be based on health record status -->
                                                <c:choose>
                                                    <c:when test="${student.id % 3 == 0}">
                                                        <span class="badge bg-success">Completed</span>
                                                    </c:when>
                                                    <c:when test="${student.id % 3 == 1}">
                                                        <span class="badge bg-warning">Pending</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Not Started</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="d-flex gap-2">
                                                    <a href="${pageContext.request.contextPath}/doctor/students?id=${student.id}" class="btn btn-sm btn-primary">
                                                        <i class="bi bi-heart-pulse"></i>
                                                    </a>
                                                    <a href="#" class="btn btn-sm btn-outline-primary">
                                                        <i class="bi bi-file-earmark-medical"></i>
                                                    </a>
                                                    <a href="#" class="btn btn-sm btn-outline-secondary">
                                                        <i class="bi bi-calendar-plus"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    
                                    <c:if test="${empty students}">
                                        <tr>
                                            <td colspan="7" class="text-center py-5">
                                                <div class="d-flex flex-column align-items-center">
                                                    <i class="bi bi-search text-muted mb-3" style="font-size: 2rem;"></i>
                                                    <h5 class="text-muted">No students found</h5>
                                                    <p class="text-muted">Try adjusting your search or filter to find what you're looking for.</p>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
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
    <!-- DataTables -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize DataTable
            $('#studentTable').DataTable({
                "pageLength": 10,
                "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                "dom": '<"top"f>rt<"bottom"lip><"clear">',
                "language": {
                    "search": "",
                    "searchPlaceholder": "Search records..."
                },
                "ordering": true,
                "info": true
            });
            
            // Use custom search box
            $('#studentSearch').on('keyup', function() {
                $('#studentTable').DataTable().search($(this).val()).draw();
            });
            
            // Add animation to cards
            const cards = document.querySelectorAll('.content-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                setTimeout(() => {
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, 100 * index);
            });
        });
    </script>
</body>
</html> 