<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${student == null ? 'Add New Student' : 'Edit Student'} - School Management System</title>
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
        .form-group label {
            font-weight: 500;
        }
        .required-field::after {
            content: "*";
            color: red;
            margin-left: 4px;
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
                    <li><a href="student?action=list" class="active"><i class="fas fa-user-graduate"></i> Students</a></li>
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
                        <h2>
                            <i class="fas fa-user-graduate"></i> 
                            ${student == null ? 'Add New Student' : 'Edit Student'}
                        </h2>
                        <p>${student == null ? 'Create a new student record' : 'Update existing student information'}</p>
                    </div>
                    <div class="col-md-4 text-right">
                        <a href="student?action=list" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Students
                        </a>
                    </div>
                </div>
                
                <!-- Alert for error messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <strong>Error!</strong> ${error}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </c:if>
                
                <!-- Alert for success messages -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <strong>Success!</strong> ${success}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </c:if>
                
                <!-- Student Form Card -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Student Information</h5>
                    </div>
                    <div class="card-body">
                        <form action="student" method="post" enctype="multipart/form-data">
                            <!-- Hidden fields for form control -->
                            <input type="hidden" name="action" value="${student == null ? 'add' : 'update'}" />
                            <c:if test="${student != null}">
                                <input type="hidden" name="studentId" value="${student.studentId}" />
                                <input type="hidden" name="userId" value="${student.userId}" />
                            </c:if>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="firstName" class="required-field">First Name</label>
                                        <input type="text" class="form-control" id="firstName" name="firstName" value="${student.firstName}" required />
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="lastName" class="required-field">Last Name</label>
                                        <input type="text" class="form-control" id="lastName" name="lastName" value="${student.lastName}" required />
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="email" class="required-field">Email</label>
                                        <input type="email" class="form-control" id="email" name="email" value="${student.email}" required />
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="regNumber" class="required-field">Registration Number</label>
                                        <input type="text" class="form-control" id="regNumber" name="regNumber" value="${student.regNumber}" required />
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label for="gender" class="required-field">Gender</label>
                                        <select class="form-control" id="gender" name="gender" required>
                                            <option value="">Select Gender</option>
                                            <option value="Male" ${student.gender == 'Male' ? 'selected' : ''}>Male</option>
                                            <option value="Female" ${student.gender == 'Female' ? 'selected' : ''}>Female</option>
                                            <option value="Other" ${student.gender == 'Other' ? 'selected' : ''}>Other</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label for="dob" class="required-field">Date of Birth</label>
                                        <input type="date" class="form-control" id="dob" name="dob" value="${student.dateOfBirth}" required />
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label for="gradeClass" class="required-field">Grade/Class</label>
                                        <select class="form-control" id="gradeClass" name="gradeClass" required>
                                            <option value="">Select Grade/Class</option>
                                            <option value="1-A" ${student.gradeClass == '1-A' ? 'selected' : ''}>Grade 1-A</option>
                                            <option value="1-B" ${student.gradeClass == '1-B' ? 'selected' : ''}>Grade 1-B</option>
                                            <option value="2-A" ${student.gradeClass == '2-A' ? 'selected' : ''}>Grade 2-A</option>
                                            <option value="2-B" ${student.gradeClass == '2-B' ? 'selected' : ''}>Grade 2-B</option>
                                            <!-- More grade options -->
                                            <option value="12-A" ${student.gradeClass == '12-A' ? 'selected' : ''}>Grade 12-A</option>
                                            <option value="12-B" ${student.gradeClass == '12-B' ? 'selected' : ''}>Grade 12-B</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="parentId" class="required-field">Parent</label>
                                        <select class="form-control" id="parentId" name="parentId" required>
                                            <option value="">Select Parent</option>
                                            <c:forEach var="parent" items="${parents}">
                                                <option value="${parent.parentId}" ${student.parentId == parent.parentId ? 'selected' : ''}>
                                                    ${parent.firstName} ${parent.lastName} (${parent.email})
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="phone">Phone Number</label>
                                        <input type="tel" class="form-control" id="phone" name="phone" value="${student.phone}" />
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label for="address">Address</label>
                                        <textarea class="form-control" id="address" name="address" rows="2">${student.address}</textarea>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label for="medicalInfo">Medical Information</label>
                                        <textarea class="form-control" id="medicalInfo" name="medicalInfo" rows="3">${student.medicalInfo}</textarea>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="status" class="required-field">Status</label>
                                        <select class="form-control" id="status" name="status" required>
                                            <option value="active" ${student.status == 'active' || student == null ? 'selected' : ''}>Active</option>
                                            <option value="inactive" ${student.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="photo">Student Photo</label>
                                        <input type="file" class="form-control-file" id="photo" name="photo" />
                                        <c:if test="${student != null && not empty student.photoPath}">
                                            <small class="text-muted">Current photo: ${student.photoPath}</small>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group text-right mt-4">
                                <a href="student?action=list" class="btn btn-secondary mr-2">Cancel</a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> ${student == null ? 'Save Student' : 'Update Student'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html> 