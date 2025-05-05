<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Behavior Management - School Management System</title>
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
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-styles.css">
    <style>
        .behavior-positive {
            background-color: rgba(40, 167, 69, 0.1);
            border-left: 3px solid var(--success-color);
        }
        
        .behavior-negative {
            background-color: rgba(220, 53, 69, 0.1);
            border-left: 3px solid var(--danger-color);
        }
        
        .behavior-neutral {
            background-color: rgba(255, 193, 7, 0.1);
            border-left: 3px solid var(--warning-color);
        }
        
        .behavior-badge {
            padding: 0.35em 0.65em;
            border-radius: 50rem;
            font-size: 0.75em;
            font-weight: 500;
        }
        
        .behavior-badge-positive {
            background-color: var(--success-color);
            color: white;
        }
        
        .behavior-badge-negative {
            background-color: var(--danger-color);
            color: white;
        }
        
        .behavior-badge-neutral {
            background-color: var(--warning-color);
            color: dark;
        }
        
        .behavior-item {
            padding: 1rem;
            border-radius: var(--border-radius);
            margin-bottom: 1rem;
            transition: all var(--transition-speed);
        }
        
        .behavior-item:hover {
            transform: translateY(-2px);
            box-shadow: var(--card-shadow);
        }
        
        .action-buttons .btn {
            width: 32px;
            height: 32px;
            padding: 0;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            margin-right: 0.25rem;
        }
        
        .form-card {
            height: 100%;
            box-shadow: var(--card-shadow);
            border-radius: var(--border-radius);
            border: none;
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
                        <li class="breadcrumb-item active" aria-current="page">Student Behavior</li>
                    </ol>
                </nav>

                <div class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center">
                    <h1 class="page-title">Student Behavior Management</h1>
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
                
                <!-- Success/Error Messages -->
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
                
                <div class="row">
                    <!-- Behavior Records -->
                    <div class="col-md-8">
                        <div class="content-card mb-4">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Student Behavior Records</h5>
                                <div>
                                    <button class="btn btn-sm btn-outline-secondary me-2 filter-btn" data-filter="all">
                                        <i class="bi bi-filter me-1"></i> All
                                    </button>
                                    <button class="btn btn-sm btn-outline-success me-2 filter-btn" data-filter="positive">
                                        <i class="bi bi-emoji-smile me-1"></i> Positive
                                    </button>
                                    <button class="btn btn-sm btn-outline-danger filter-btn" data-filter="negative">
                                        <i class="bi bi-emoji-frown me-1"></i> Negative
                                    </button>
                                </div>
                            </div>
                            <div class="card-body p-0">
                                <c:choose>
                                    <c:when test="${empty behaviorRecords}">
                                        <div class="text-center py-5">
                                            <div class="mb-3">
                                                <i class="bi bi-clipboard-x text-muted" style="font-size: 3rem;"></i>
                                            </div>
                                            <h5 class="text-muted">No Behavior Records Found</h5>
                                            <p class="text-muted">Start by adding a new record using the form.</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="table-responsive">
                                            <table class="table table-hover mb-0" id="behaviorTable">
                                                <thead>
                                                    <tr>
                                                        <th>Student</th>
                                                        <th>Behavior Type</th>
                                                        <th>Date</th>
                                                        <th>Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="record" items="${behaviorRecords}">
                                                        <tr class="behavior-item-row ${record.behaviorType.toLowerCase().contains('positive') ? 'behavior-positive' : record.behaviorType.toLowerCase().contains('negative') ? 'behavior-negative' : 'behavior-neutral'}">
                                                            <td>
                                                                <div class="d-flex align-items-center">
                                                                    <div class="avatar-circle me-2">
                                                                        <i class="bi bi-person"></i>
                                                                    </div>
                                                                    <span class="fw-medium">${record.studentName}</span>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <span class="behavior-badge ${record.behaviorType.toLowerCase().contains('positive') ? 'behavior-badge-positive' : record.behaviorType.toLowerCase().contains('negative') ? 'behavior-badge-negative' : 'behavior-badge-neutral'}">
                                                                    ${record.behaviorType}
                                                                </span>
                                                            </td>
                                                            <td><fmt:formatDate value="${record.behaviorDate}" pattern="MMM dd, yyyy" /></td>
                                                            <td>
                                                                <div class="action-buttons">
                                                                    <button type="button" class="btn btn-sm btn-primary view-behavior-btn" 
                                                                    data-behavior-id="${record.behaviorId}"
                                                                    data-student-name="${record.studentName}"
                                                                    data-behavior-type="${record.behaviorType}"
                                                                        data-behavior-date="<fmt:formatDate value="${record.behaviorDate}" pattern="MMM dd, yyyy" />"
                                                                    data-description="${record.description}"
                                                                        data-action-taken="${record.actionTaken}"
                                                                        title="View Details">
                                                                        <i class="bi bi-eye"></i>
                                                                </button>
                                                                <button type="button" class="btn btn-sm btn-warning edit-behavior-btn"
                                                                    data-behavior-id="${record.behaviorId}"
                                                                    data-behavior-type="${record.behaviorType}"
                                                                    data-description="${record.description}"
                                                                        data-action-taken="${record.actionTaken}"
                                                                        title="Edit Record">
                                                                        <i class="bi bi-pencil"></i>
                                                                </button>
                                                                <button type="button" class="btn btn-sm btn-danger delete-behavior-btn"
                                                                        data-behavior-id="${record.behaviorId}"
                                                                        title="Delete Record">
                                                                        <i class="bi bi-trash"></i>
                                                                </button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Add Behavior Form -->
                    <div class="col-md-4">
                        <div class="form-card mb-4">
                            <div class="card-header">
                                <h5 class="mb-0">Add New Behavior Record</h5>
                            </div>
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/teacher/behavior" method="post" class="needs-validation" novalidate>
                                    <input type="hidden" name="action" value="addBehavior">
                                    
                                    <div class="mb-3">
                                        <label for="studentId" class="form-label required-field">Student</label>
                                        <select class="form-select" id="studentId" name="studentId" required>
                                            <option value="">Select Student</option>
                                            <c:forEach var="course" items="${teacherCourses}">
                                                <optgroup label="${course.courseName}">
                                                <c:forEach var="student" items="${course.students}">
                                                    <option value="${student.studentId}">${student.firstName} ${student.lastName}</option>
                                                </c:forEach>
                                                </optgroup>
                                            </c:forEach>
                                        </select>
                                        <div class="invalid-feedback">
                                            Please select a student.
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="courseId" class="form-label required-field">Course</label>
                                        <select class="form-select" id="courseId" name="courseId" required>
                                            <option value="">Select Course</option>
                                            <c:forEach var="course" items="${teacherCourses}">
                                                <option value="${course.courseId}">${course.courseName}</option>
                                            </c:forEach>
                                        </select>
                                        <div class="invalid-feedback">
                                            Please select a course.
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="behaviorType" class="form-label required-field">Behavior Type</label>
                                        <select class="form-select" id="behaviorType" name="behaviorType" required>
                                            <option value="">Select Behavior Type</option>
                                            <c:forEach var="type" items="${behaviorTypes}">
                                                <option value="${type}">${type}</option>
                                            </c:forEach>
                                        </select>
                                        <div class="invalid-feedback">
                                            Please select a behavior type.
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="description" class="form-label required-field">Description</label>
                                        <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                                        <div class="invalid-feedback">
                                            Please provide a description.
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="actionTaken" class="form-label">Action Taken (Optional)</label>
                                        <textarea class="form-control" id="actionTaken" name="actionTaken" rows="2"></textarea>
                                    </div>
                                    
                                    <div class="d-grid">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="bi bi-plus-circle me-1"></i> Add Record
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                        
                        <!-- Quick Stats Card -->
                        <div class="form-card mb-4">
                            <div class="card-header">
                                <h5 class="mb-0">Behavior Statistics</h5>
                            </div>
                            <div class="card-body">
                                <div class="row g-3">
                                    <div class="col-6">
                                        <div class="p-3 border rounded bg-light text-center">
                                            <h3 class="text-success mb-0">${positiveCount}</h3>
                                            <small class="text-muted">Positive Records</small>
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <div class="p-3 border rounded bg-light text-center">
                                            <h3 class="text-danger mb-0">${negativeCount}</h3>
                                            <small class="text-muted">Negative Records</small>
                                        </div>
                                    </div>
                                    <div class="col-12">
                                        <div class="p-3 border rounded bg-light text-center">
                                            <h3 class="text-primary mb-0">${totalCount}</h3>
                                            <small class="text-muted">Total Records</small>
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
    
    <!-- View Behavior Modal -->
    <div class="modal fade" id="viewBehaviorModal" tabindex="-1" aria-labelledby="viewBehaviorModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="viewBehaviorModalLabel">Behavior Record Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <h6 class="text-muted mb-2">Student</h6>
                        <p class="fs-5 fw-medium" id="viewStudentName"></p>
                    </div>
                    <div class="mb-3">
                        <h6 class="text-muted mb-2">Behavior Type</h6>
                        <p id="viewBehaviorTypeContainer">
                            <span class="badge bg-primary" id="viewBehaviorType"></span>
                        </p>
                    </div>
                    <div class="mb-3">
                        <h6 class="text-muted mb-2">Date</h6>
                        <p id="viewBehaviorDate"></p>
                    </div>
                    <div class="mb-3">
                        <h6 class="text-muted mb-2">Description</h6>
                        <p id="viewDescription" class="border p-3 rounded bg-light"></p>
                    </div>
                    <div class="mb-3">
                        <h6 class="text-muted mb-2">Action Taken</h6>
                        <p id="viewActionTaken" class="border p-3 rounded bg-light"></p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="bi bi-x-circle me-1"></i> Close
                    </button>
                    <button type="button" class="btn btn-primary edit-from-view">
                        <i class="bi bi-pencil me-1"></i> Edit Record
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Edit Behavior Modal -->
    <div class="modal fade" id="editBehaviorModal" tabindex="-1" aria-labelledby="editBehaviorModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editBehaviorModalLabel">Edit Behavior Record</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editBehaviorForm" action="${pageContext.request.contextPath}/teacher/behavior" method="post" class="needs-validation" novalidate>
                        <input type="hidden" name="action" value="updateBehavior">
                        <input type="hidden" id="editBehaviorId" name="behaviorId">
                        
                        <div class="mb-3">
                            <label for="editBehaviorType" class="form-label required-field">Behavior Type</label>
                            <select class="form-select" id="editBehaviorType" name="behaviorType" required>
                                <c:forEach var="type" items="${behaviorTypes}">
                                    <option value="${type}">${type}</option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">
                                Please select a behavior type.
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editDescription" class="form-label required-field">Description</label>
                            <textarea class="form-control" id="editDescription" name="description" rows="3" required></textarea>
                            <div class="invalid-feedback">
                                Please provide a description.
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editActionTaken" class="form-label">Action Taken (Optional)</label>
                            <textarea class="form-control" id="editActionTaken" name="actionTaken" rows="2"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                        <i class="bi bi-x-circle me-1"></i> Cancel
                    </button>
                    <button type="button" class="btn btn-primary" id="saveEditBtn">
                        <i class="bi bi-check-circle me-1"></i> Save Changes
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Behavior Modal -->
    <div class="modal fade" id="deleteBehaviorModal" tabindex="-1" aria-labelledby="deleteBehaviorModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteBehaviorModalLabel">Delete Behavior Record</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-danger">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        Are you sure you want to delete this behavior record? This action cannot be undone.
                </div>
                    <form id="deleteBehaviorForm" action="${pageContext.request.contextPath}/teacher/behavior" method="post">
                        <input type="hidden" name="action" value="deleteBehavior">
                        <input type="hidden" id="deleteBehaviorId" name="behaviorId">
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                        <i class="bi bi-x-circle me-1"></i> Cancel
                    </button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteBtn">
                        <i class="bi bi-trash me-1"></i> Delete Record
                    </button>
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
            var dataTable = $('#behaviorTable').DataTable({
                "paging": true,
                "ordering": true,
                "info": true,
                "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]]
            });
            
            // Form validation
            (function() {
                'use strict';
                
                // Fetch all forms we want to apply validation styles to
                var forms = document.querySelectorAll('.needs-validation');
                
                // Loop over them and prevent submission
                Array.prototype.slice.call(forms).forEach(function(form) {
                    form.addEventListener('submit', function(event) {
                        if (!form.checkValidity()) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            })();
            
            // Filter buttons
            $('.filter-btn').click(function() {
                const filter = $(this).data('filter');
                
                // Update active state
                $('.filter-btn').removeClass('active');
                $(this).addClass('active');
                
                if (filter === 'all') {
                    dataTable.search('').draw();
                } else {
                    dataTable.search(filter).draw();
                }
            });
            
            // View Behavior Record
            $('.view-behavior-btn').click(function() {
                const behaviorId = $(this).data('behavior-id');
                const studentName = $(this).data('student-name');
                const behaviorType = $(this).data('behavior-type');
                const behaviorDate = $(this).data('behavior-date');
                const description = $(this).data('description');
                const actionTaken = $(this).data('action-taken');
                
                // Update modal content
                $('#viewStudentName').text(studentName);
                $('#viewBehaviorType').text(behaviorType);
                
                // Set appropriate badge class
                const $badge = $('#viewBehaviorType');
                $badge.removeClass('bg-primary bg-success bg-danger bg-warning');
                
                if (behaviorType.toLowerCase().includes('positive')) {
                    $badge.addClass('bg-success');
                } else if (behaviorType.toLowerCase().includes('negative')) {
                    $badge.addClass('bg-danger');
                } else {
                    $badge.addClass('bg-warning');
                }
                
                $('#viewBehaviorDate').text(behaviorDate);
                $('#viewDescription').text(description || 'No description provided');
                $('#viewActionTaken').text(actionTaken || 'No action taken');
                
                // Set the current behavior ID for the edit button
                $('.edit-from-view').data('behavior-id', behaviorId);
                
                // Show the modal
                $('#viewBehaviorModal').modal('show');
            });
            
            // Edit from view button
            $('.edit-from-view').click(function() {
                const behaviorId = $(this).data('behavior-id');
                
                // Close the view modal
                $('#viewBehaviorModal').modal('hide');
                
                // Find the edit button with the same behavior ID and trigger its click
                $(`.edit-behavior-btn[data-behavior-id="${behaviorId}"]`).click();
            });
            
            // Edit Behavior Record
            $('.edit-behavior-btn').click(function() {
                const behaviorId = $(this).data('behavior-id');
                const behaviorType = $(this).data('behavior-type');
                const description = $(this).data('description');
                const actionTaken = $(this).data('action-taken');
                
                // Update form values
                $('#editBehaviorId').val(behaviorId);
                $('#editBehaviorType').val(behaviorType);
                $('#editDescription').val(description);
                $('#editActionTaken').val(actionTaken);
                
                // Show the modal
                $('#editBehaviorModal').modal('show');
            });
            
            // Delete Behavior Record
            $('.delete-behavior-btn').click(function() {
                const behaviorId = $(this).data('behavior-id');
                
                // Update the hidden input
                $('#deleteBehaviorId').val(behaviorId);
                
                // Show the modal
                $('#deleteBehaviorModal').modal('show');
            });
            
            // Form submission handlers
            $('#saveEditBtn').click(function() {
                $('#editBehaviorForm').submit();
            });
            
            $('#confirmDeleteBtn').click(function() {
                $('#deleteBehaviorForm').submit();
            });
        });
    </script>
</body>
</html> 