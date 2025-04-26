<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Student - School Management System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .card {
            border-radius: 10px;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
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
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/teacher/courses">
                                <i class="bi bi-book me-2"></i> My Courses
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active text-white" href="${pageContext.request.contextPath}/teacher/student">
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
                    <h1 class="h2">Add New Student</h1>
                    <a href="${pageContext.request.contextPath}/teacher/student" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i> Back to Students
                    </a>
                </div>

                <!-- Error message if any -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
                    </div>
                </c:if>

                <!-- Student Form -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/teacher/student/add" method="post" class="row g-3">
                            <!-- Course Selection (Optional) -->
                            <div class="col-12 mb-3">
                                <h5 class="border-bottom pb-2">Course Enrollment (Optional)</h5>
                                <label for="courseId" class="form-label">Enroll in Course</label>
                                <select class="form-select" id="courseId" name="courseId">
                                    <option value="">Select Course (Optional)</option>
                                    <c:forEach var="course" items="${courses}">
                                        <option value="${course.id}">${course.courseName} (${course.courseCode})</option>
                                    </c:forEach>
                                </select>
                                <div class="form-text">You can enroll the student in a course later if needed.</div>
                            </div>
                            
                            <!-- Personal Information -->
                            <h5 class="mb-3 border-bottom pb-2">Personal Information</h5>
                            
                            <div class="col-md-6">
                                <label for="firstName" class="form-label">First Name *</label>
                                <input type="text" class="form-control" id="firstName" name="firstName" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label for="lastName" class="form-label">Last Name *</label>
                                <input type="text" class="form-control" id="lastName" name="lastName" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label for="regNumber" class="form-label">Registration Number *</label>
                                <input type="text" class="form-control" id="regNumber" name="regNumber" required>
                                <div class="form-text">Unique registration number for the student</div>
                            </div>
                            
                            <div class="col-md-6">
                                <label for="dateOfBirth" class="form-label">Date of Birth</label>
                                <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth">
                            </div>
                            
                            <div class="col-md-6">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email">
                            </div>
                            
                            <div class="col-md-6">
                                <label for="phone" class="form-label">Phone</label>
                                <input type="tel" class="form-control" id="phone" name="phone">
                            </div>
                            
                            <div class="col-12">
                                <label for="address" class="form-label">Address</label>
                                <textarea class="form-control" id="address" name="address" rows="2"></textarea>
                            </div>
                            
                            <!-- Academic Information -->
                            <h5 class="mt-4 mb-3 border-bottom pb-2">Academic Information</h5>
                            
                            <div class="col-md-6">
                                <label for="admissionDate" class="form-label">Admission Date</label>
                                <input type="date" class="form-control" id="admissionDate" name="admissionDate" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                            </div>
                            
                            <div class="col-md-6">
                                <label for="grade" class="form-label">Grade</label>
                                <select class="form-select" id="grade" name="grade">
                                    <option value="">Select Grade</option>
                                    <c:forEach var="i" begin="1" end="12">
                                        <option value="Grade ${i}">Grade ${i}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            
                            <!-- Parent Information -->
                            <h5 class="mt-4 mb-3 border-bottom pb-2">Parent/Guardian Information</h5>
                            
                            <div class="col-12 mb-3">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="createNewParent" name="createNewParent" value="true" checked>
                                    <label class="form-check-label" for="createNewParent">
                                        Create New Parent/Guardian
                                    </label>
                                </div>
                                <div class="form-text">Uncheck if you want to assign to an existing parent</div>
                            </div>
                            
                            <!-- Existing Parent Selection (Hidden initially) -->
                            <div class="col-12 mb-3" id="existingParentSection" style="display: none;">
                                <label for="parentId" class="form-label">Select Existing Parent</label>
                                <select class="form-select" id="parentId" name="parentId">
                                    <option value="">Choose a parent</option>
                                    <c:forEach var="parent" items="${parents}">
                                        <option value="${parent.id}">${parent.firstName} ${parent.lastName} (${parent.email})</option>
                                    </c:forEach>
                                </select>
                            </div>
                            
                            <!-- New Parent Information -->
                            <div id="newParentSection">
                                <div class="col-md-6">
                                    <label for="parentFirstName" class="form-label">Parent First Name</label>
                                    <input type="text" class="form-control" id="parentFirstName" name="parentFirstName">
                                </div>
                                
                                <div class="col-md-6">
                                    <label for="parentLastName" class="form-label">Parent Last Name</label>
                                    <input type="text" class="form-control" id="parentLastName" name="parentLastName">
                                </div>
                                
                                <div class="col-md-6">
                                    <label for="parentEmail" class="form-label">Parent Email</label>
                                    <input type="email" class="form-control" id="parentEmail" name="parentEmail">
                                </div>
                                
                                <div class="col-md-6">
                                    <label for="parentPhone" class="form-label">Parent Phone</label>
                                    <input type="tel" class="form-control" id="parentPhone" name="parentPhone">
                                </div>
                                
                                <div class="col-md-6">
                                    <label for="parentAddress" class="form-label">Parent Address</label>
                                    <textarea class="form-control" id="parentAddress" name="parentAddress" rows="2"></textarea>
                                </div>
                                
                                <div class="col-md-6">
                                    <label for="parentOccupation" class="form-label">Parent Occupation</label>
                                    <input type="text" class="form-control" id="parentOccupation" name="parentOccupation">
                                </div>
                            </div>
                            
                            <!-- User Account Information -->
                            <h5 class="mt-4 mb-3 border-bottom pb-2">User Account Information</h5>
                            
                            <div class="col-12 mb-3">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="createUserAccount" name="createUserAccount" value="true">
                                    <label class="form-check-label" for="createUserAccount">
                                        Create User Account for Student
                                    </label>
                                </div>
                                <div class="form-text">This will create a login account for the student</div>
                            </div>
                            
                            <div id="userAccountSection" style="display: none;">
                                <div class="col-md-6">
                                    <label for="username" class="form-label">Username</label>
                                    <input type="text" class="form-control" id="username" name="username">
                                </div>
                                
                                <div class="col-md-6">
                                    <label for="password" class="form-label">Password</label>
                                    <input type="password" class="form-control" id="password" name="password">
                                </div>
                            </div>
                            
                            <div class="col-12 mt-4">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-person-plus-fill me-1"></i> Add Student
                                </button>
                                <a href="${pageContext.request.contextPath}/teacher/student" class="btn btn-outline-secondary ms-2">
                                    Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Toggle parent sections based on checkbox
            $('#createNewParent').change(function() {
                if($(this).is(':checked')) {
                    $('#newParentSection').show();
                    $('#existingParentSection').hide();
                } else {
                    $('#newParentSection').hide();
                    $('#existingParentSection').show();
                }
            });
            
            // Toggle user account section based on checkbox
            $('#createUserAccount').change(function() {
                if($(this).is(':checked')) {
                    $('#userAccountSection').show();
                } else {
                    $('#userAccountSection').hide();
                }
            });
            
            // Auto-generate username based on first and last name when they change
            $('#firstName, #lastName').on('blur', function() {
                if ($('#username').val() === '') {
                    let firstName = $('#firstName').val().toLowerCase();
                    let lastName = $('#lastName').val().toLowerCase();
                    
                    if (firstName && lastName) {
                        let suggestedUsername = firstName.charAt(0) + lastName;
                        suggestedUsername = suggestedUsername.replace(/[^a-z0-9]/g, '');
                        $('#username').val(suggestedUsername);
                    }
                }
            });
        });
    </script>
</body>
</html> 