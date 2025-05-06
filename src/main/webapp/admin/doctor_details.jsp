<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Doctor Details | Admin Dashboard</title>

    <!-- Bootstrap CSS -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />

    <!-- Bootstrap Icons -->
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css"
    />

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-styles.css">

    <style>
      body {
        font-family: 'Poppins', sans-serif;
        background-color: #f5f5f9;
      }
      .container-fluid {
        padding: 0;
      }
      main {
        padding: 20px;
        background-color: #f5f5f9;
      }
      .card {
        border-radius: 10px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        border: none;
        margin-bottom: 20px;
      }
      .card-header {
        background-color: #fff;
        border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        font-weight: 600;
        padding: 15px 20px;
        border-radius: 10px 10px 0 0 !important;
      }
      .card-body {
        padding: 20px;
      }
      .text-secondary {
        color: #6c757d !important;
      }
      .action-btn {
        margin-right: 5px;
      }
      h1.h2 {
        font-weight: 600;
        color: #333;
      }
      .profile-image {
        width: 150px;
        height: 150px;
        object-fit: cover;
        border-radius: 10px;
        border: 1px solid #e0e0e0;
      }
      .placeholder-image {
        width: 150px;
        height: 150px;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: #f8f9fa;
        border-radius: 10px;
        border: 1px solid #e0e0e0;
        color: #6c757d;
        font-size: 40px;
      }
      .profile-img {
        width: 100px;
        height: 100px;
        background-color: #f0f0f0;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 40px;
        color: #6c757d;
        margin-bottom: 15px;
      }
      .detail-label {
        font-weight: 600;
        color: #495057;
      }
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
        <!-- Include sidebar -->
        <jsp:include page="/WEB-INF/includes/admin-sidebar.jsp" />

        <!-- Main Content -->
        <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
          <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3">
            <h1 class="h2">Doctor Details</h1>
            <div class="btn-toolbar mb-2 mb-md-0">
              <a href="${pageContext.request.contextPath}/admin/doctors" class="btn btn-sm btn-outline-secondary me-2">
                <i class="bi bi-arrow-left"></i> Back to Doctors
              </a>
              <a href="${pageContext.request.contextPath}/admin/doctors/edit/${doctor.doctorId}" class="btn btn-sm btn-primary">
                <i class="bi bi-pencil"></i> Edit
              </a>
            </div>
          </div>

          <!-- Doctor Details Section -->
          <div class="row">
            <div class="col-lg-8">
              <div class="card">
                <div class="card-header">Personal Information</div>
                <div class="card-body">
                  <div class="row">
                    <div class="col-md-3 mb-4 text-center">
                      <c:choose>
                        <c:when test="${not empty doctor.imageUrl}">
                          <img src="${doctor.imageUrl}" alt="${doctor.firstName} ${doctor.lastName}" class="profile-image">
                        </c:when>
                        <c:otherwise>
                          <div class="placeholder-image">
                            <i class="bi bi-person"></i>
                          </div>
                        </c:otherwise>
                      </c:choose>
                    </div>
                    <div class="col-md-9">
                      <div class="row mb-3">
                        <div class="col-sm-4 fw-semibold">Full Name</div>
                        <div class="col-sm-8">${doctor.firstName} ${doctor.lastName}</div>
                      </div>
                      <div class="row mb-3">
                        <div class="col-sm-4 fw-semibold">Email</div>
                        <div class="col-sm-8">${doctor.email}</div>
                      </div>
                      <div class="row mb-3">
                        <div class="col-sm-4 fw-semibold">Phone</div>
                        <div class="col-sm-8">${doctor.phone}</div>
                      </div>
                      <div class="row mb-3">
                        <div class="col-sm-4 fw-semibold">Specialization</div>
                        <div class="col-sm-8">${doctor.specialization}</div>
                      </div>
                      <div class="row mb-3">
                        <div class="col-sm-4 fw-semibold">Hospital</div>
                        <div class="col-sm-8">${doctor.hospital}</div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="col-lg-4">
              <div class="card">
                <div class="card-header">Actions</div>
                <div class="card-body">
                  <a href="${pageContext.request.contextPath}/admin/doctors/edit/${doctor.doctorId}" 
                     class="btn btn-warning w-100 mb-2">
                    <i class="bi bi-pencil me-2"></i> Edit Doctor
                  </a>
                  <button onclick="confirmDelete('${doctor.doctorId}')" 
                          class="btn btn-danger w-100">
                    <i class="bi bi-trash me-2"></i> Delete Doctor
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Custom JavaScript -->
    <script>
      function confirmDelete(doctorId) {
        if (confirm("Are you sure you want to delete this doctor?")) {
          window.location.href =
            "${pageContext.request.contextPath}/admin/doctors/delete/" +
            doctorId;
        }
      }
    </script>
  </body>
</html>
