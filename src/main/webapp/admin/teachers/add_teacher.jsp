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
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-styles.css">
    <style>
        .form-label {
            font-weight: 500;
            margin-bottom: 0.5rem;
        }
        .required-field::after {
            content: "*";
            color: red;
            margin-left: 4px;
        }
        .breadcrumb {
            background-color: transparent;
            padding: 0.75rem 0;
            margin-bottom: 1rem;
        }
        .breadcrumb-item a {
            color: var(--primary-color);
            text-decoration: none;
        }
        .breadcrumb-item.active {
            color: #6c757d;
        }
        .form-card {
            background: white;
            border-radius: var(--border-radius);
            border: none;
            box-shadow: var(--card-shadow);
            margin-bottom: 1.5rem;
            padding: 1.5rem;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Include Sidebar -->
            <jsp:include page="/WEB-INF/includes/admin-sidebar.jsp" />

            <!-- Main content -->
            <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <!-- Breadcrumb -->
                <nav aria-label="breadcrumb" class="mt-3">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/teachers">Teachers</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Add New Teacher</li>
                    </ol>
                </nav>

                <div class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center">
                    <h1 class="page-title">Add New Teacher</h1>
                </div>

                <!-- Alert messages -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Add Teacher Form -->
                <div class="form-card">
                    <form action="${pageContext.request.contextPath}/admin/teachers/new" method="post" class="needs-validation" novalidate>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="firstName" class="form-label required-field">First Name</label>
                                <input type="text" class="form-control" id="firstName" name="firstName" value="${teacher.firstName}" required>
                                <div class="invalid-feedback">
                                    First name is required.
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="lastName" class="form-label required-field">Last Name</label>
                                <input type="text" class="form-control" id="lastName" name="lastName" value="${teacher.lastName}" required>
                                <div class="invalid-feedback">
                                    Last name is required.
                                </div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="email" class="form-label required-field">Email</label>
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
                                <textarea class="form-control" id="address" name="address" rows="3">${teacher.address}</textarea>
                            </div>
                        </div>
                        
                        <!-- Login Credentials -->
                        <h5 class="mt-4 mb-3 border-bottom pb-2">Login Credentials</h5>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="username" class="form-label required-field">Username</label>
                                <input type="text" class="form-control" id="username" name="username" ${empty teacher || empty teacher.id ? 'required' : ''}>
                                <div class="form-text">${empty teacher || empty teacher.id ? 'Username for teacher to login to the system' : 'Leave blank to keep existing username'}</div>
                            </div>
                            <div class="col-md-6">
                                <label for="password" class="form-label required-field">Password</label>
                                <input type="password" class="form-control" id="password" name="password" ${empty teacher || empty teacher.id ? 'required' : ''}>
                                <div class="form-text">${empty teacher || empty teacher.id ? 'Initial password for teacher account' : 'Leave blank to keep existing password'}</div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end mt-4">
                            <a href="${pageContext.request.contextPath}/admin/teachers" class="btn btn-outline-secondary me-2">
                                <i class="bi bi-x-circle me-1"></i> Cancel
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-save me-1"></i> Save Teacher
                            </button>
                        </div>
                    </form>
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