<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Materials - School Management System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .dashboard-card {
            transition: transform 0.3s;
            border-radius: 10px;
            border: none;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            height: 100%;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        .teacher-profile {
            display: flex;
            align-items: center;
            padding: 1rem;
        }
        .teacher-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 10px;
        }
        .file-type-icon {
            font-size: 2rem;
            margin-right: 10px;
        }
        .material-item {
            transition: all 0.3s;
            border-radius: 8px;
        }
        .material-item:hover {
            background-color: rgba(0, 0, 0, 0.05);
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
                            <a class="nav-link active text-white" href="${pageContext.request.contextPath}/teacher/courses">
                                <i class="bi bi-book me-2"></i> My Courses
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="${pageContext.request.contextPath}/teacher/student">
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
                    <h1 class="h2">Course Materials: ${courseDetails.courseName}</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/teacher/course-details?id=${courseDetails.courseId}" class="btn btn-sm btn-outline-secondary">
                            <i class="bi bi-arrow-left me-1"></i> Back to Course Details
                        </a>
                    </div>
                </div>

                <!-- Course information card -->
                <div class="row mb-4">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header bg-primary text-white">
                                <h5 class="card-title mb-0">Course Information</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <p><strong>Course Code:</strong> ${courseDetails.courseCode}</p>
                                        <p><strong>Course Name:</strong> ${courseDetails.courseName}</p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><strong>Credits:</strong> ${courseDetails.credits}</p>
                                        <p><strong>Semester:</strong> ${courseDetails.semester}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Upload Form -->
                <div class="row mb-4">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header bg-success text-white">
                                <h5 class="card-title mb-0">Upload New Material</h5>
                            </div>
                            <div class="card-body">
                                <form id="uploadForm" action="${pageContext.request.contextPath}/teacher/course-materials" method="post" enctype="multipart/form-data">
                                    <input type="hidden" name="courseId" value="${courseDetails.courseId}">
                                    <input type="hidden" name="action" value="upload">
                                    
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label for="materialTitle" class="form-label">Title</label>
                                            <input type="text" class="form-control" id="materialTitle" name="title" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="materialType" class="form-label">Material Type</label>
                                            <select class="form-select" id="materialType" name="type" required>
                                                <option value="" selected disabled>Select a type</option>
                                                <option value="LECTURE">Lecture Notes</option>
                                                <option value="ASSIGNMENT">Assignment</option>
                                                <option value="READING">Reading Material</option>
                                                <option value="PRESENTATION">Presentation</option>
                                                <option value="VIDEO">Video Link</option>
                                                <option value="QUIZ">Quiz</option>
                                                <option value="OTHER">Other</option>
                                            </select>
                                        </div>
                                        <div class="col-md-12">
                                            <label for="materialDescription" class="form-label">Description</label>
                                            <textarea class="form-control" id="materialDescription" name="description" rows="3"></textarea>
                                        </div>
                                        <div class="col-md-12 mb-3" id="fileUploadDiv">
                                            <label for="materialFile" class="form-label">File</label>
                                            <input type="file" class="form-control" id="materialFile" name="file">
                                            <div class="form-text">Supported formats: PDF, DOC, DOCX, PPT, PPTX, ZIP, RAR, MP4, MP3 (Max size: 50MB)</div>
                                        </div>
                                        <div class="col-md-12 mb-3 d-none" id="linkInputDiv">
                                            <label for="materialLink" class="form-label">Link URL</label>
                                            <input type="url" class="form-control" id="materialLink" name="link" placeholder="https://...">
                                            <div class="form-text">For video content, please paste a direct link (YouTube, Google Drive, etc.)</div>
                                        </div>
                                        <div class="col-md-12 text-end">
                                            <button type="submit" class="btn btn-primary">
                                                <i class="bi bi-cloud-upload"></i> Upload Material
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Materials List -->
                <div class="row mb-4">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="card-title mb-0">Course Materials</h5>
                                <div class="btn-group">
                                    <button type="button" class="btn btn-sm btn-outline-primary filter-btn active" data-filter="all">All</button>
                                    <button type="button" class="btn btn-sm btn-outline-primary filter-btn" data-filter="LECTURE">Lectures</button>
                                    <button type="button" class="btn btn-sm btn-outline-primary filter-btn" data-filter="ASSIGNMENT">Assignments</button>
                                    <button type="button" class="btn btn-sm btn-outline-primary filter-btn" data-filter="READING">Readings</button>
                                    <button type="button" class="btn btn-sm btn-outline-primary filter-btn" data-filter="OTHER">Others</button>
                                </div>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${not empty courseMaterials}">
                                        <div class="list-group">
                                            <c:forEach items="${courseMaterials}" var="material">
                                                <div class="list-group-item material-item p-3 d-flex justify-content-between align-items-center mb-2" data-type="${material.type}">
                                                    <div class="d-flex align-items-center">
                                                        <div class="file-type-icon">
                                                            <c:choose>
                                                                <c:when test="${material.type eq 'LECTURE'}">
                                                                    <i class="bi bi-file-text text-primary"></i>
                                                                </c:when>
                                                                <c:when test="${material.type eq 'ASSIGNMENT'}">
                                                                    <i class="bi bi-journal-check text-warning"></i>
                                                                </c:when>
                                                                <c:when test="${material.type eq 'READING'}">
                                                                    <i class="bi bi-book text-info"></i>
                                                                </c:when>
                                                                <c:when test="${material.type eq 'PRESENTATION'}">
                                                                    <i class="bi bi-easel text-success"></i>
                                                                </c:when>
                                                                <c:when test="${material.type eq 'VIDEO'}">
                                                                    <i class="bi bi-play-btn text-danger"></i>
                                                                </c:when>
                                                                <c:when test="${material.type eq 'QUIZ'}">
                                                                    <i class="bi bi-question-square text-secondary"></i>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <i class="bi bi-folder text-dark"></i>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div>
                                                            <h5 class="mb-1">${material.title}</h5>
                                                            <p class="mb-1">${material.description}</p>
                                                            <small class="text-muted">
                                                                Uploaded: <fmt:formatDate value="${material.uploadDate}" pattern="MMM dd, yyyy HH:mm" />
                                                            </small>
                                                        </div>
                                                    </div>
                                                    <div class="btn-group">
                                                        <c:choose>
                                                            <c:when test="${material.type eq 'VIDEO'}">
                                                                <a href="${material.link}" target="_blank" class="btn btn-outline-primary btn-sm">
                                                                    <i class="bi bi-play-circle"></i> View
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <a href="${pageContext.request.contextPath}/teacher/download-material?id=${material.materialId}" class="btn btn-outline-primary btn-sm">
                                                                    <i class="bi bi-download"></i> Download
                                                                </a>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <a href="#" class="btn btn-outline-danger btn-sm delete-material" data-id="${material.materialId}" data-title="${material.title}">
                                                            <i class="bi bi-trash"></i> Delete
                                                        </a>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert alert-info">
                                            <i class="bi bi-info-circle me-2"></i> No materials have been uploaded for this course yet.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete <span id="materialToDelete"></span>? This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form id="deleteMaterialForm" action="${pageContext.request.contextPath}/teacher/course-materials" method="post">
                        <input type="hidden" name="courseId" value="${courseDetails.courseId}">
                        <input type="hidden" name="materialId" id="materialIdToDelete">
                        <input type="hidden" name="action" value="delete">
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </form>
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
            // Toggle between file upload and link input based on material type
            $('#materialType').on('change', function() {
                const type = $(this).val();
                if (type === 'VIDEO') {
                    $('#fileUploadDiv').addClass('d-none');
                    $('#linkInputDiv').removeClass('d-none');
                    $('#materialLink').prop('required', true);
                    $('#materialFile').prop('required', false);
                } else {
                    $('#fileUploadDiv').removeClass('d-none');
                    $('#linkInputDiv').addClass('d-none');
                    $('#materialLink').prop('required', false);
                    $('#materialFile').prop('required', true);
                }
            });
            
            // Filter materials by type
            $('.filter-btn').on('click', function() {
                $('.filter-btn').removeClass('active');
                $(this).addClass('active');
                
                const filterType = $(this).data('filter');
                if (filterType === 'all') {
                    $('.material-item').show();
                } else {
                    $('.material-item').hide();
                    $('.material-item[data-type="' + filterType + '"]').show();
                }
            });
            
            // Delete material confirmation
            $('.delete-material').on('click', function(e) {
                e.preventDefault();
                const materialId = $(this).data('id');
                const materialTitle = $(this).data('title');
                
                $('#materialIdToDelete').val(materialId);
                $('#materialToDelete').text('"' + materialTitle + '"');
                
                const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
                deleteModal.show();
            });
        });
    </script>
</body>
</html> 