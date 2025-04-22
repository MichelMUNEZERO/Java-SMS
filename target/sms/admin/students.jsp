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
    <style>
        body {
            background-color: #f8f9fa;
        }
        .sidebar {
            min-height: 100vh;
            background-color: #343a40;
            color: #fff;
            padding-top: 20px;
        }
        .sidebar-heading {
            padding: 15px;
            font-size: 1.2rem;
            text-align: center;
            border-bottom: 1px solid #495057;
        }
        .sidebar-menu {
            padding: 0;
            list-style: none;
        }
        .sidebar-menu li {
            margin: 0;
            padding: 0;
        }
        .sidebar-menu li a {
            display: block;
            padding: 15px;
            color: #adb5bd;
            text-decoration: none;
            transition: all 0.3s;
        }
        .sidebar-menu li a:hover, .sidebar-menu li a.active {
            background-color: #495057;
            color: #fff;
        }
        .sidebar-menu li a i {
            margin-right: 10px;
        }
        .main-content {
            padding: 20px;
        }
        .card {
            margin-bottom: 20px;
            border: none;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        }
        .card-header {
            background-color: #fff;
            border-bottom: 1px solid rgba(0, 0, 0, 0.125);
            padding: 15px 20px;
        }
        .filter-card {
            background-color: #f8f9fa;
            border: 1px solid #e9ecef;
        }
        .action-buttons .btn {
            margin: 0 3px;
        }
        .form-group label {
            font-weight: 500;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 sidebar">
                <div class="sidebar-heading">
                    <i class="fas fa-school"></i> SMS Admin
                </div>
                <ul class="sidebar-menu">
                    <li><a href="dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="users.jsp"><i class="fas fa-users"></i> Users</a></li>
                    <li><a href="students.jsp" class="active"><i class="fas fa-user-graduate"></i> Students</a></li>
                    <li><a href="teachers.jsp"><i class="fas fa-chalkboard-teacher"></i> Teachers</a></li>
                    <li><a href="parents.jsp"><i class="fas fa-user-friends"></i> Parents</a></li>
                    <li><a href="courses.jsp"><i class="fas fa-book"></i> Courses</a></li>
                    <li><a href="classes.jsp"><i class="fas fa-chalkboard"></i> Classes</a></li>
                    <li><a href="announcements.jsp"><i class="fas fa-bullhorn"></i> Announcements</a></li>
                    <li><a href="reports.jsp"><i class="fas fa-chart-bar"></i> Reports</a></li>
                    <li><a href="../logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                </ul>
            </div>
            
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
                                    <tr>
                                        <td>STU001</td>
                                        <td>John Doe</td>
                                        <td>REG20230001</td>
                                        <td>Grade 10-A</td>
                                        <td>Male</td>
                                        <td>john.doe@example.com</td>
                                        <td>Michael Doe</td>
                                        <td><span class="badge badge-success">Active</span></td>
                                        <td class="action-buttons">
                                            <button class="btn btn-sm btn-info" data-toggle="tooltip" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-primary" data-toggle="modal" data-target="#editStudentModal" data-toggle="tooltip" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" data-toggle="tooltip" title="Delete">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>STU002</td>
                                        <td>Jane Smith</td>
                                        <td>REG20230002</td>
                                        <td>Grade 8-B</td>
                                        <td>Female</td>
                                        <td>jane.smith@example.com</td>
                                        <td>Robert Smith</td>
                                        <td><span class="badge badge-success">Active</span></td>
                                        <td class="action-buttons">
                                            <button class="btn btn-sm btn-info" data-toggle="tooltip" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-primary" data-toggle="modal" data-target="#editStudentModal" data-toggle="tooltip" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" data-toggle="tooltip" title="Delete">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>STU003</td>
                                        <td>Michael Johnson</td>
                                        <td>REG20230003</td>
                                        <td>Grade 11-A</td>
                                        <td>Male</td>
                                        <td>michael.j@example.com</td>
                                        <td>Sarah Johnson</td>
                                        <td><span class="badge badge-success">Active</span></td>
                                        <td class="action-buttons">
                                            <button class="btn btn-sm btn-info" data-toggle="tooltip" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-primary" data-toggle="modal" data-target="#editStudentModal" data-toggle="tooltip" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" data-toggle="tooltip" title="Delete">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>STU004</td>
                                        <td>Emily Brown</td>
                                        <td>REG20230004</td>
                                        <td>Grade 9-C</td>
                                        <td>Female</td>
                                        <td>emily.b@example.com</td>
                                        <td>David Brown</td>
                                        <td><span class="badge badge-warning">Inactive</span></td>
                                        <td class="action-buttons">
                                            <button class="btn btn-sm btn-info" data-toggle="tooltip" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-primary" data-toggle="modal" data-target="#editStudentModal" data-toggle="tooltip" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" data-toggle="tooltip" title="Delete">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>STU005</td>
                                        <td>David Wilson</td>
                                        <td>REG20230005</td>
                                        <td>Grade 12-A</td>
                                        <td>Male</td>
                                        <td>david.w@example.com</td>
                                        <td>Patricia Wilson</td>
                                        <td><span class="badge badge-success">Active</span></td>
                                        <td class="action-buttons">
                                            <button class="btn btn-sm btn-info" data-toggle="tooltip" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-primary" data-toggle="modal" data-target="#editStudentModal" data-toggle="tooltip" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" data-toggle="tooltip" title="Delete">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        
                        <!-- Pagination -->
                        <nav aria-label="Page navigation">
                            <ul class="pagination justify-content-center">
                                <li class="page-item disabled">
                                    <a class="page-link" href="#" tabindex="-1">Previous</a>
                                </li>
                                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                <li class="page-item"><a class="page-link" href="#">2</a></li>
                                <li class="page-item"><a class="page-link" href="#">3</a></li>
                                <li class="page-item">
                                    <a class="page-link" href="#">Next</a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Add Student Modal -->
    <div class="modal fade" id="addStudentModal" tabindex="-1" role="dialog" aria-labelledby="addStudentModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addStudentModalLabel">Add New Student</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="addStudentForm" action="../admin/student" method="post">
                        <input type="hidden" name="action" value="add">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="firstName">First Name *</label>
                                    <input type="text" class="form-control" id="firstName" name="firstName" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="lastName">Last Name *</label>
                                    <input type="text" class="form-control" id="lastName" name="lastName" required>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="email">Email *</label>
                                    <input type="email" class="form-control" id="email" name="email" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="regNumber">Registration Number *</label>
                                    <input type="text" class="form-control" id="regNumber" name="regNumber" required>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="gender">Gender *</label>
                                    <select class="form-control" id="gender" name="gender" required>
                                        <option value="">Select Gender</option>
                                        <option value="Male">Male</option>
                                        <option value="Female">Female</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="dob">Date of Birth *</label>
                                    <input type="date" class="form-control" id="dob" name="dob" required>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="gradeClass">Grade/Class *</label>
                                    <select class="form-control" id="gradeClass" name="gradeClass" required>
                                        <option value="">Select Grade/Class</option>
                                        <option value="1-A">Grade 1-A</option>
                                        <option value="1-B">Grade 1-B</option>
                                        <option value="2-A">Grade 2-A</option>
                                        <option value="2-B">Grade 2-B</option>
                                        <!-- More options... -->
                                        <option value="12-A">Grade 12-A</option>
                                        <option value="12-B">Grade 12-B</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="parentId">Parent *</label>
                                    <select class="form-control" id="parentId" name="parentId" required>
                                        <option value="">Select Parent</option>
                                        <option value="1">Michael Doe (PAR001)</option>
                                        <option value="2">Robert Smith (PAR002)</option>
                                        <option value="3">Sarah Johnson (PAR003)</option>
                                        <option value="4">David Brown (PAR004)</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="phone">Phone Number</label>
                                    <input type="tel" class="form-control" id="phone" name="phone">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="address">Address</label>
                                    <input type="text" class="form-control" id="address" name="address">
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label for="medicalInfo">Medical Information</label>
                                    <textarea class="form-control" id="medicalInfo" name="medicalInfo" rows="3"></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="status">Status *</label>
                                    <select class="form-control" id="status" name="status" required>
                                        <option value="active">Active</option>
                                        <option value="inactive">Inactive</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="photo">Student Photo</label>
                                    <input type="file" class="form-control-file" id="photo" name="photo">
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="submit" form="addStudentForm" class="btn btn-primary">Save Student</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Edit Student Modal (similar structure to Add Modal) -->
    <div class="modal fade" id="editStudentModal" tabindex="-1" role="dialog" aria-labelledby="editStudentModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editStudentModalLabel">Edit Student</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="editStudentForm" action="../admin/student" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="studentId" id="editStudentId" value="">
                        <!-- Form fields (same as add modal) -->
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="editFirstName">First Name *</label>
                                    <input type="text" class="form-control" id="editFirstName" name="firstName" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="editLastName">Last Name *</label>
                                    <input type="text" class="form-control" id="editLastName" name="lastName" required>
                                </div>
                            </div>
                        </div>
                        <!-- More fields... similar to add form -->
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="submit" form="editStudentForm" class="btn btn-primary">Update Student</button>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
        });
    </script>
</body>
</html> 