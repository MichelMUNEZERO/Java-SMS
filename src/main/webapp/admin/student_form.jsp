<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${student != null ? 'Edit' : 'Add'} Student - School Management System</title>
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
                    <hr class="text-white">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/dashboard">
                                <i class="bi bi-speedometer2 me-2"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active text-white" href="${pageContext.request.contextPath}/admin/students">
                                <i class="bi bi-person me-2"></i> Students
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/teachers">
                                <i class="bi bi-person-badge me-2"></i> Teachers
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/parents">
                                <i class="bi bi-people me-2"></i> Parents
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/courses">
                                <i class="bi bi-book me-2"></i> Courses
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/doctors">
                                <i class="bi bi-heart-pulse me-2"></i> Doctors
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/nurses">
                                <i class="bi bi-bandaid me-2"></i> Nurses
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/announcements">
                                <i class="bi bi-megaphone me-2"></i> Announcements
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/appointments">
                                <i class="bi bi-calendar-check me-2"></i> Appointments
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/settings">
                                <i class="bi bi-gear me-2"></i> Settings
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
                    <h1 class="h2">${student != null ? 'Edit' : 'Add'} Student</h1>
                    <a href="${pageContext.request.contextPath}/admin/students" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i> Back to List
                    </a>
                </div>

                <!-- Student Form -->
                <div class="card mb-4">
                    <div class="card-body">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                            </div>
                        </c:if>
                        
                        <form action="${pageContext.request.contextPath}/admin/students/${student != null ? 'edit/' : 'new'}${student != null ? student.id : ''}" method="post" class="row g-3">
                            <!-- Personal Information -->
                            <h5 class="mb-3 border-bottom pb-2">Personal Information</h5>
                            
                            <div class="col-md-6">
                                <label for="firstName" class="form-label">First Name</label>
                                <input type="text" class="form-control" id="firstName" name="firstName" value="${student != null ? student.firstName : ''}" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label for="lastName" class="form-label">Last Name</label>
                                <input type="text" class="form-control" id="lastName" name="lastName" value="${student != null ? student.lastName : ''}" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label for="gender" class="form-label">Gender</label>
                                <select class="form-select" id="gender" name="gender" required>
                                    <option value="">Select Gender</option>
                                    <option value="Male" ${student != null && student.gender == 'Male' ? 'selected' : ''}>Male</option>
                                    <option value="Female" ${student != null && student.gender == 'Female' ? 'selected' : ''}>Female</option>
                                    <option value="Other" ${student != null && student.gender == 'Other' ? 'selected' : ''}>Other</option>
                                </select>
                            </div>
                            
                            <div class="col-md-6">
                                <label for="dateOfBirth" class="form-label">Date of Birth</label>
                                <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" 
                                       value="<fmt:formatDate value="${student.dateOfBirth}" pattern="yyyy-MM-dd" />" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" value="${student != null ? student.email : ''}">
                            </div>
                            
                            <div class="col-md-6">
                                <label for="phone" class="form-label">Phone</label>
                                <input type="tel" class="form-control" id="phone" name="phone" value="${student != null ? student.phone : ''}">
                            </div>
                            
                            <div class="col-12">
                                <label for="address" class="form-label">Address</label>
                                <textarea class="form-control" id="address" name="address" rows="2">${student != null ? student.address : ''}</textarea>
                            </div>
                            
                            <!-- Guardian Information -->
                            <h5 class="mt-4 mb-3 border-bottom pb-2">Guardian Information</h5>
                            
                            <div class="col-md-4">
                                <label for="guardianName" class="form-label">Guardian Name</label>
                                <input type="text" class="form-control" id="guardianName" name="guardianName" value="${student != null ? student.guardianName : ''}">
                            </div>
                            
                            <div class="col-md-4">
                                <label for="guardianPhone" class="form-label">Guardian Phone</label>
                                <input type="tel" class="form-control" id="guardianPhone" name="guardianPhone" value="${student != null ? student.guardianPhone : ''}">
                            </div>
                            
                            <div class="col-md-4">
                                <label for="guardianEmail" class="form-label">Guardian Email</label>
                                <input type="email" class="form-control" id="guardianEmail" name="guardianEmail" value="${student != null ? student.guardianEmail : ''}">
                            </div>
                            
                            <!-- Academic Information -->
                            <h5 class="mt-4 mb-3 border-bottom pb-2">Academic Information</h5>
                            
                            <div class="col-md-6">
                                <label for="admissionDate" class="form-label">Admission Date</label>
                                <input type="date" class="form-control" id="admissionDate" name="admissionDate" 
                                       value="<fmt:formatDate value="${student.admissionDate}" pattern="yyyy-MM-dd" />" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label for="classId" class="form-label">Grade Level</label>
                                <select class="form-select" id="classId" name="classId" required>
                                    <option value="">Select Grade</option>
                                    <c:forEach var="i" begin="1" end="12">
                                        <option value="${i}" ${student != null && student.classId == i ? 'selected' : ''}>Grade ${i}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            
                            <div class="col-md-6">
                                <label for="status" class="form-label">Status</label>
                                <select class="form-select" id="status" name="status" required>
                                    <option value="active" ${student != null && student.status == 'active' ? 'selected' : ''}>Active</option>
                                    <option value="inactive" ${student != null && student.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                                    <option value="suspended" ${student != null && student.status == 'suspended' ? 'selected' : ''}>Suspended</option>
                                </select>
                            </div>
                            
                            <div class="col-12 mt-4">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-save me-1"></i> ${student != null ? 'Update' : 'Save'} Student
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/students" class="btn btn-outline-secondary ms-2">
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
</body>
</html> 