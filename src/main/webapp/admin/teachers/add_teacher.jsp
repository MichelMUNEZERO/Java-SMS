<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Teacher - School Management System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse" style="min-height: 100vh;">
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
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/students">
                                <i class="bi bi-person me-2"></i> Students
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active text-white" href="${pageContext.request.contextPath}/admin/teachers">
                                <i class="bi bi-person-badge me-2"></i> Teachers
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/courses">
                                <i class="bi bi-book me-2"></i> Courses
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/schedule">
                                <i class="bi bi-calendar-event me-2"></i> Schedule
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/announcements">
                                <i class="bi bi-megaphone me-2"></i> Announcements
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
            <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 pt-4">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/teachers">Teachers</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Add New Teacher</li>
                    </ol>
                </nav>

                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Add New Teacher</h1>
                </div>

                <!-- Alert messages -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Add Teacher Form -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/admin/teachers/new" method="post" class="needs-validation" novalidate>
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="firstName" class="form-label">First Name *</label>
                                    <input type="text" class="form-control" id="firstName" name="firstName" value="${teacher.firstName}" required>
                                    <div class="invalid-feedback">
                                        First name is required.
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="lastName" class="form-label">Last Name *</label>
                                    <input type="text" class="form-control" id="lastName" name="lastName" value="${teacher.lastName}" required>
                                    <div class="invalid-feedback">
                                        Last name is required.
                                    </div>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="email" class="form-label">Email *</label>
                                    <input type="email" class="form-control" id="email" name="email" value="${teacher.email}" required>
                                    <div class="invalid-feedback">
                                        Please provide a valid email.
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="phone" class="form-label">Phone</label>
                                    <input type="tel" class="form-control" id="phone" name="phone" value="${teacher.phone}">
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="qualification" class="form-label">Qualification</label>
                                    <select class="form-select" id="qualification" name="qualification">
                                        <option value="">Select qualification</option>
                                        <option value="Bachelor's Degree" ${teacher.qualification eq "Bachelor's Degree" ? 'selected' : ''}>Bachelor's Degree</option>
                                        <option value="Master's Degree" ${teacher.qualification eq "Master's Degree" ? 'selected' : ''}>Master's Degree</option>
                                        <option value="Ph.D." ${teacher.qualification eq "Ph.D." ? 'selected' : ''}>Ph.D.</option>
                                        <option value="B.Ed" ${teacher.qualification eq "B.Ed" ? 'selected' : ''}>B.Ed</option>
                                        <option value="M.Ed" ${teacher.qualification eq "M.Ed" ? 'selected' : ''}>M.Ed</option>
                                        <option value="Other" ${teacher.qualification eq "Other" ? 'selected' : ''}>Other</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="experience" class="form-label">Experience (years)</label>
                                    <input type="number" class="form-control" id="experience" name="experience" min="0" value="${teacher.experience}">
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="specialization" class="form-label">Specialization</label>
                                    <select class="form-select" id="specialization" name="specialization">
                                        <option value="">Select specialization</option>
                                        <option value="Mathematics" ${teacher.specialization eq "Mathematics" ? 'selected' : ''}>Mathematics</option>
                                        <option value="Science" ${teacher.specialization eq "Science" ? 'selected' : ''}>Science</option>
                                        <option value="Language Arts" ${teacher.specialization eq "Language Arts" ? 'selected' : ''}>Language Arts</option>
                                        <option value="Social Studies" ${teacher.specialization eq "Social Studies" ? 'selected' : ''}>Social Studies</option>
                                        <option value="Computer Science" ${teacher.specialization eq "Computer Science" ? 'selected' : ''}>Computer Science</option>
                                        <option value="Physical Education" ${teacher.specialization eq "Physical Education" ? 'selected' : ''}>Physical Education</option>
                                        <option value="Art" ${teacher.specialization eq "Art" ? 'selected' : ''}>Art</option>
                                        <option value="Music" ${teacher.specialization eq "Music" ? 'selected' : ''}>Music</option>
                                        <option value="Foreign Language" ${teacher.specialization eq "Foreign Language" ? 'selected' : ''}>Foreign Language</option>
                                        <option value="Special Education" ${teacher.specialization eq "Special Education" ? 'selected' : ''}>Special Education</option>
                                        <option value="Other" ${teacher.specialization eq "Other" ? 'selected' : ''}>Other</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="address" class="form-label">Address</label>
                                    <textarea class="form-control" id="address" name="address" rows="2">${teacher.address}</textarea>
                                </div>
                            </div>

                            <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                                <a href="${pageContext.request.contextPath}/admin/teachers" class="btn btn-secondary me-md-2">Cancel</a>
                                <button type="submit" class="btn btn-primary">Save Teacher</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Form validation -->
    <script>
        // Example starter JavaScript for disabling form submissions if there are invalid fields
        (function () {
            'use strict'

            // Fetch all the forms we want to apply custom Bootstrap validation styles to
            var forms = document.querySelectorAll('.needs-validation')

            // Loop over them and prevent submission
            Array.prototype.slice.call(forms)
                .forEach(function (form) {
                    form.addEventListener('submit', function (event) {
                        if (!form.checkValidity()) {
                            event.preventDefault()
                            event.stopPropagation()
                        }

                        form.classList.add('was-validated')
                    }, false)
                })
        })()
    </script>
</body>
</html> 