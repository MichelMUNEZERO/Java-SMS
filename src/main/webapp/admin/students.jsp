<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Management - School Management System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-styles.css">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/includes/admin-sidebar.jsp">
                <jsp:param name="active" value="students"/>
            </jsp:include>
            
            <!-- Main Content -->
            <div class="col-md-10 main-content">
                <div class="row mb-4">
                    <div class="col-md-8">
                        <h2><i class="fas fa-user-graduate"></i> Student Management</h2>
                        <p>View, add, edit, and manage student information</p>
                    </div>
                    <div class="col-md-4 text-right">
                        <button class="btn btn-primary" data-toggle="modal" data-target="#addStudentModal">
                            <i class="fas fa-plus"></i> Add New Student
                        </button>
                    </div>
                </div>
                
                <!-- Filter Card -->
                <div class="card filter-card mb-4">
                    <div class="card-body">
                        <form action="" method="get">
                            <div class="row">
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label for="searchName">Search by Name/ID</label>
                                        <input type="text" class="form-control" id="searchName" name="searchName" placeholder="Name or ID">
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label for="grade">Grade/Class</label>
                                        <select class="form-control" id="grade" name="grade">
                                            <option value="">All Classes</option>
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
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label for="status">Status</label>
                                        <select class="form-control" id="status" name="status">
                                            <option value="">All</option>
                                            <option value="active">Active</option>
                                            <option value="inactive">Inactive</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-3 d-flex align-items-end">
                                    <button type="submit" class="btn btn-primary mb-3 mr-2">
                                        <i class="fas fa-search"></i> Search
                                    </button>
                                    <button type="reset" class="btn btn-secondary mb-3">
                                        <i class="fas fa-redo"></i> Reset
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Students Table -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Students List</h5>
                        <div>
                            <button class="btn btn-sm btn-outline-secondary">
                                <i class="fas fa-print"></i> Print
                            </button>
                            <button class="btn btn-sm btn-outline-secondary">
                                <i class="fas fa-file-excel"></i> Export
                            </button>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="thead-light">
                                    <tr>
                                        <th>Student ID</th>
                                        <th>Name</th>
                                        <th>Registration No.</th>
                                        <th>Grade/Class</th>
                                        <th>Gender</th>
                                        <th>Contact</th>
                                        <th>Parent</th>
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
                                            <td>${student.gender}</td>
                                            <td>${student.email}</td>
                                            <td>${student.parentName}</td>
                                            <td><span class="badge badge-${student.status == 'active' ? 'success' : 'secondary'}">${student.status}</span></td>
                                        <td class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/admin/students/view?id=${student.studentId}" class="btn btn-sm btn-info" data-toggle="tooltip" title="View Details">
                                                <i class="fas fa-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/students/edit?id=${student.studentId}" class="btn btn-sm btn-primary" data-toggle="tooltip" title="Edit">
                                                <i class="fas fa-edit"></i>
                                                </a>
                                                <button class="btn btn-sm btn-danger" data-toggle="modal" data-target="#deleteStudentModal" data-student-id="${student.studentId}" data-toggle="tooltip" title="Delete">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    </c:forEach>
                                    <c:if test="${empty students}">
                                        <tr>
                                            <td colspan="9" class="text-center">No students found</td>
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
    
    <!-- Delete Student Modal -->
    <div class="modal fade" id="deleteStudentModal" tabindex="-1" role="dialog" aria-labelledby="deleteStudentModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteStudentModalLabel">Confirm Delete</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete this student? This action cannot be undone.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Delete</a>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
    <script>
        // Handle delete student 
        $('#deleteStudentModal').on('show.bs.modal', function (event) {
            var button = $(event.relatedTarget);
            var studentId = button.data('student-id');
            var confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
            confirmDeleteBtn.href = '${pageContext.request.contextPath}/admin/students/delete?id=' + studentId;
        });
    </script>
</body>
</html> 