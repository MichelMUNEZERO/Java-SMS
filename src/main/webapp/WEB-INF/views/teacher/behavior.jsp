<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Behavior Management</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .behavior-positive {
            background-color: rgba(40, 167, 69, 0.1);
        }
        .behavior-negative {
            background-color: rgba(220, 53, 69, 0.1);
        }
        .card {
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .table th {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/includes/teacher-navbar.jsp" />
    
    <div class="container-fluid py-4">
        <div class="row">
            <div class="col-12">
                <h2 class="mb-4"><i class="fas fa-clipboard-list me-2"></i>Student Behavior Management</h2>
                
                <!-- Success/Error Messages -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                
                <div class="row">
                    <!-- Behavior Records -->
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Student Behavior Records</h5>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${empty behaviorRecords}">
                                        <div class="alert alert-info">
                                            No behavior records found. You can add a new record using the form.
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="table-responsive">
                                            <table class="table table-striped table-hover">
                                                <thead>
                                                    <tr>
                                                        <th>Student Name</th>
                                                        <th>Behavior Type</th>
                                                        <th>Date</th>
                                                        <th>Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="record" items="${behaviorRecords}">
                                                        <tr class="${record.behaviorType.startsWith('Positive') ? 'behavior-positive' : 'behavior-negative'}">
                                                            <td>${record.studentName}</td>
                                                            <td>${record.behaviorType}</td>
                                                            <td><fmt:formatDate value="${record.behaviorDate}" pattern="MM/dd/yyyy" /></td>
                                                            <td>
                                                                <button type="button" class="btn btn-sm btn-info view-behavior-btn" 
                                                                    data-behavior-id="${record.behaviorId}"
                                                                    data-student-name="${record.studentName}"
                                                                    data-behavior-type="${record.behaviorType}"
                                                                    data-behavior-date="<fmt:formatDate value="${record.behaviorDate}" pattern="MM/dd/yyyy" />"
                                                                    data-description="${record.description}"
                                                                    data-action-taken="${record.actionTaken}">
                                                                    <i class="fas fa-eye"></i>
                                                                </button>
                                                                <button type="button" class="btn btn-sm btn-warning edit-behavior-btn"
                                                                    data-behavior-id="${record.behaviorId}"
                                                                    data-behavior-type="${record.behaviorType}"
                                                                    data-description="${record.description}"
                                                                    data-action-taken="${record.actionTaken}">
                                                                    <i class="fas fa-edit"></i>
                                                                </button>
                                                                <button type="button" class="btn btn-sm btn-danger delete-behavior-btn"
                                                                    data-behavior-id="${record.behaviorId}">
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
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
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">Add New Behavior Record</h5>
                            </div>
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/teacher/behavior" method="post">
                                    <input type="hidden" name="action" value="addBehavior">
                                    
                                    <div class="mb-3">
                                        <label for="studentId" class="form-label">Student</label>
                                        <select class="form-select" id="studentId" name="studentId" required>
                                            <option value="">Select Student</option>
                                            <c:forEach var="course" items="${teacherCourses}">
                                                <c:forEach var="student" items="${course.students}">
                                                    <option value="${student.studentId}">${student.firstName} ${student.lastName}</option>
                                                </c:forEach>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="courseId" class="form-label">Course</label>
                                        <select class="form-select" id="courseId" name="courseId" required>
                                            <option value="">Select Course</option>
                                            <c:forEach var="course" items="${teacherCourses}">
                                                <option value="${course.courseId}">${course.courseName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="behaviorType" class="form-label">Behavior Type</label>
                                        <select class="form-select" id="behaviorType" name="behaviorType" required>
                                            <option value="">Select Behavior Type</option>
                                            <c:forEach var="type" items="${behaviorTypes}">
                                                <option value="${type}">${type}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="description" class="form-label">Description</label>
                                        <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="actionTaken" class="form-label">Action Taken</label>
                                        <textarea class="form-control" id="actionTaken" name="actionTaken" rows="2"></textarea>
                                    </div>
                                    
                                    <button type="submit" class="btn btn-primary">Add Record</button>
                                </form>
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
                    <p><strong>Student:</strong> <span id="viewStudentName"></span></p>
                    <p><strong>Behavior Type:</strong> <span id="viewBehaviorType"></span></p>
                    <p><strong>Date:</strong> <span id="viewBehaviorDate"></span></p>
                    <p><strong>Description:</strong></p>
                    <p id="viewDescription" class="border p-2 bg-light"></p>
                    <p><strong>Action Taken:</strong></p>
                    <p id="viewActionTaken" class="border p-2 bg-light"></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
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
                    <form id="editBehaviorForm" action="${pageContext.request.contextPath}/teacher/behavior" method="post">
                        <input type="hidden" name="action" value="updateBehavior">
                        <input type="hidden" id="editBehaviorId" name="behaviorId">
                        
                        <div class="mb-3">
                            <label for="editBehaviorType" class="form-label">Behavior Type</label>
                            <select class="form-select" id="editBehaviorType" name="behaviorType" required>
                                <c:forEach var="type" items="${behaviorTypes}">
                                    <option value="${type}">${type}</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editDescription" class="form-label">Description</label>
                            <textarea class="form-control" id="editDescription" name="description" rows="3" required></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editActionTaken" class="form-label">Action Taken</label>
                            <textarea class="form-control" id="editActionTaken" name="actionTaken" rows="2"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="saveEditBtn">Save Changes</button>
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
                    <p>Are you sure you want to delete this behavior record? This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form id="deleteBehaviorForm" action="${pageContext.request.contextPath}/teacher/behavior" method="post">
                        <input type="hidden" name="action" value="deleteBehavior">
                        <input type="hidden" id="deleteBehaviorId" name="behaviorId">
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // View behavior record
            $('.view-behavior-btn').click(function() {
                $('#viewStudentName').text($(this).data('student-name'));
                $('#viewBehaviorType').text($(this).data('behavior-type'));
                $('#viewBehaviorDate').text($(this).data('behavior-date'));
                $('#viewDescription').text($(this).data('description'));
                $('#viewActionTaken').text($(this).data('action-taken'));
                
                var viewBehaviorModal = new bootstrap.Modal(document.getElementById('viewBehaviorModal'));
                viewBehaviorModal.show();
            });
            
            // Edit behavior record
            $('.edit-behavior-btn').click(function() {
                $('#editBehaviorId').val($(this).data('behavior-id'));
                $('#editBehaviorType').val($(this).data('behavior-type'));
                $('#editDescription').val($(this).data('description'));
                $('#editActionTaken').val($(this).data('action-taken'));
                
                var editBehaviorModal = new bootstrap.Modal(document.getElementById('editBehaviorModal'));
                editBehaviorModal.show();
            });
            
            // Save edited behavior record
            $('#saveEditBtn').click(function() {
                $('#editBehaviorForm').submit();
            });
            
            // Delete behavior record
            $('.delete-behavior-btn').click(function() {
                $('#deleteBehaviorId').val($(this).data('behavior-id'));
                
                var deleteBehaviorModal = new bootstrap.Modal(document.getElementById('deleteBehaviorModal'));
                deleteBehaviorModal.show();
            });
        });
    </script>
</body>
</html> 