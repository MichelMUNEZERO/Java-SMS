<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Parent Information - School Management System</title>
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
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
      rel="stylesheet"
    />
    <!-- Custom CSS -->
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/admin-styles.css"
    />
    <style>
      .parent-form-card {
        transition: transform 0.3s;
        border-radius: var(--border-radius);
        border: none;
        box-shadow: var(--card-shadow);
      }
      .parent-form-card:hover {
        transform: translateY(-5px);
        box-shadow: var(--hover-shadow);
      }
      .required-field::after {
        content: "*";
        color: red;
        margin-left: 4px;
      }
      .info-icon {
        width: 40px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 10px;
        margin-right: 15px;
      }
      .benefit-item {
        padding: 0.5rem 0;
        border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        transition: all 0.3s ease;
      }
      .benefit-item:hover {
        background-color: rgba(13, 110, 253, 0.05);
        padding-left: 0.5rem;
      }
      .benefit-item:last-child {
        border-bottom: none;
      }
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
        <!-- Include Student Sidebar -->
        <jsp:include page="/WEB-INF/includes/student-sidebar.jsp" />

        <!-- Main content -->
        <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
          <!-- Breadcrumb -->
          <nav aria-label="breadcrumb" class="mt-3">
            <ol class="breadcrumb">
              <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/dashboard">Home</a>
              </li>
              <li class="breadcrumb-item active" aria-current="page">
                Parent Information
              </li>
            </ol>
          </nav>

          <div class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center">
            <h1 class="page-title">Parent Information</h1>
            <div class="btn-toolbar mb-2 mb-md-0">
              <div class="dropdown">
                <button
                  class="btn btn-outline-secondary dropdown-toggle d-flex align-items-center"
                  type="button"
                  id="dropdownMenuLink"
                  data-bs-toggle="dropdown"
                  aria-expanded="false"
                >
                  <c:choose>
                    <c:when test="${not empty profileData.imageLink}">
                      <img src="${profileData.imageLink}" alt="${user.username}" class="profile-img me-2">
                    </c:when>
                    <c:otherwise>
                      <i class="bi bi-person-circle me-1"></i>
                    </c:otherwise>
                  </c:choose>
                  <span>${user.username}</span>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenuLink">
                  <li>
                    <a class="dropdown-item" href="#"><i class="bi bi-person me-2"></i> Profile</a>
                  </li>
                  <li><hr class="dropdown-divider" /></li>
                  <li>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
                  </li>
                </ul>
              </div>
            </div>
          </div>

          <!-- Alerts -->
          <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
              ${error}
              <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
          </c:if>
          <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
              ${message}
              <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
          </c:if>
          
          <!-- Parent Information Summary -->
          <div class="row mb-4">
            <div class="col-md-6 mb-3">
              <div class="content-card h-100">
                <div class="card-body p-4">
                  <div class="d-flex align-items-center mb-3">
                    <div class="bg-primary bg-opacity-10 p-3 rounded">
                      <i class="bi bi-people-fill text-primary" style="font-size: 1.8rem;"></i>
                    </div>
                    <div class="ms-3">
                      <h5 class="mb-0 fw-bold">Parent Profile</h5>
                      <p class="text-muted mb-0">
                        <c:choose>
                          <c:when test="${empty parent}">Not linked yet</c:when>
                          <c:otherwise>Linked to your account</c:otherwise>
                        </c:choose>
                      </p>
                    </div>
                  </div>
                  <c:if test="${not empty parent}">
                    <div class="card bg-light border-0 mb-0">
                      <div class="card-body py-2">
                        <div class="d-flex align-items-center">
                          <div class="flex-shrink-0">
                            <div class="bg-secondary bg-opacity-10 p-2 rounded-circle">
                              <i class="bi bi-person text-secondary"></i>
                            </div>
                          </div>
                          <div class="flex-grow-1 ms-3">
                            <h6 class="mb-0">${parent.firstName} ${parent.lastName}</h6>
                            <p class="text-muted small mb-0">${parent.email}</p>
                          </div>
                        </div>
                      </div>
                    </div>
                  </c:if>
                </div>
              </div>
            </div>
            <div class="col-md-6 mb-3">
              <div class="content-card h-100">
                <div class="card-body p-4">
                  <div class="d-flex align-items-center mb-3">
                    <div class="bg-info bg-opacity-10 p-3 rounded">
                      <i class="bi bi-info-circle-fill text-info" style="font-size: 1.8rem;"></i>
                    </div>
                    <div class="ms-3">
                      <h5 class="mb-0 fw-bold">Why It Matters</h5>
                      <p class="text-muted mb-0">Parent information helps in emergencies and communications</p>
                    </div>
                  </div>
                  <ul class="list-unstyled mb-0">
                    <li class="benefit-item d-flex align-items-center">
                      <i class="bi bi-check-circle-fill text-success me-2"></i>
                      <span>Emergency contacts</span>
                    </li>
                    <li class="benefit-item d-flex align-items-center">
                      <i class="bi bi-check-circle-fill text-success me-2"></i>
                      <span>School communications</span>
                    </li>
                    <li class="benefit-item d-flex align-items-center">
                      <i class="bi bi-check-circle-fill text-success me-2"></i>
                      <span>Report card delivery</span>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
          </div>

          <!-- Parent Information Form -->
          <div class="content-card parent-form-card mb-4">
            <div class="card-header d-flex align-items-center">
              <i class="bi bi-people-fill text-primary me-2 fs-5"></i>
              <h5 class="card-title mb-0">
                <c:choose>
                  <c:when test="${empty parent}">Add Parent Information</c:when>
                  <c:otherwise>Update Parent Information</c:otherwise>
                </c:choose>
              </h5>
            </div>
            <div class="card-body">
              <form 
                action="${pageContext.request.contextPath}/student/update-parent"
                method="post"
                class="needs-validation"
                novalidate
              >
                <div class="row g-3">
                  <div class="col-md-6">
                    <label for="firstName" class="form-label required-field">First Name</label>
                    <div class="input-group">
                      <span class="input-group-text bg-light border-0">
                        <i class="bi bi-person text-muted"></i>
                      </span>
                      <input
                        type="text"
                        class="form-control border-0 bg-light"
                        id="firstName"
                        name="firstName"
                        value="${parent.firstName}"
                        placeholder="Enter first name"
                        required
                      />
                    </div>
                    <div class="invalid-feedback">
                      First name is required.
                    </div>
                  </div>
                  <div class="col-md-6">
                    <label for="lastName" class="form-label required-field">Last Name</label>
                    <div class="input-group">
                      <span class="input-group-text bg-light border-0">
                        <i class="bi bi-person text-muted"></i>
                      </span>
                      <input
                        type="text"
                        class="form-control border-0 bg-light"
                        id="lastName"
                        name="lastName"
                        value="${parent.lastName}"
                        placeholder="Enter last name"
                        required
                      />
                    </div>
                    <div class="invalid-feedback">
                      Last name is required.
                    </div>
                  </div>
                  <div class="col-md-6">
                    <label for="email" class="form-label">Email</label>
                    <div class="input-group">
                      <span class="input-group-text bg-light border-0">
                        <i class="bi bi-envelope text-muted"></i>
                      </span>
                      <input
                        type="email"
                        class="form-control border-0 bg-light"
                        id="email"
                        name="email"
                        value="${parent.email}"
                        placeholder="Enter email address"
                      />
                    </div>
                    <div class="invalid-feedback">
                      Please enter a valid email address.
                    </div>
                  </div>
                  <div class="col-md-6">
                    <label for="phone" class="form-label required-field">Phone</label>
                    <div class="input-group">
                      <span class="input-group-text bg-light border-0">
                        <i class="bi bi-telephone text-muted"></i>
                      </span>
                      <input
                        type="tel"
                        class="form-control border-0 bg-light"
                        id="phone"
                        name="phone"
                        value="${parent.phone}"
                        placeholder="Enter phone number"
                        required
                      />
                    </div>
                    <div class="invalid-feedback">
                      Phone number is required.
                    </div>
                  </div>
                  <div class="col-12">
                    <label for="address" class="form-label">Address</label>
                    <div class="input-group">
                      <span class="input-group-text bg-light border-0">
                        <i class="bi bi-geo-alt text-muted"></i>
                      </span>
                      <textarea
                        class="form-control border-0 bg-light"
                        id="address"
                        name="address"
                        rows="3"
                        placeholder="Enter complete address"
                      >${parent.address}</textarea>
                    </div>
                  </div>
                  <div class="col-md-6">
                    <label for="occupation" class="form-label">Occupation</label>
                    <div class="input-group">
                      <span class="input-group-text bg-light border-0">
                        <i class="bi bi-briefcase text-muted"></i>
                      </span>
                      <input
                        type="text"
                        class="form-control border-0 bg-light"
                        id="occupation"
                        name="occupation"
                        value="${parent.occupation}"
                        placeholder="Enter occupation"
                      />
                    </div>
                  </div>
                  <div class="col-12 mt-4">
                    <div class="d-flex justify-content-between">
                      <button type="submit" class="btn btn-primary">
                        <i class="bi bi-save me-2"></i> 
                        <c:choose>
                          <c:when test="${empty parent}">Add Parent Information</c:when>
                          <c:otherwise>Update Parent Information</c:otherwise>
                        </c:choose>
                      </button>
                      <a
                        href="${pageContext.request.contextPath}/student/dashboard"
                        class="btn btn-outline-secondary"
                      >
                        <i class="bi bi-arrow-left me-2"></i> Back to Dashboard
                      </a>
                    </div>
                  </div>
                </div>
              </form>
            </div>
          </div>

          <!-- Parent-Student Relationship Card -->
          <div class="content-card mb-4">
            <div class="card-header bg-white d-flex align-items-center">
              <i class="bi bi-info-circle-fill text-info me-2 fs-5"></i>
              <h5 class="card-title mb-0">Benefits of Maintaining Parent Information</h5>
            </div>
            <div class="card-body">
              <div class="row">
                <div class="col-md-6">
                  <div class="d-flex align-items-start mb-3">
                    <div class="info-icon bg-primary bg-opacity-10">
                      <i class="bi bi-bell text-primary"></i>
                    </div>
                    <div>
                      <h6 class="fw-bold mb-1">School Communications</h6>
                      <p class="text-muted mb-0 small">Parents receive important notifications about school events, closures, and other announcements.</p>
                    </div>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="d-flex align-items-start mb-3">
                    <div class="info-icon bg-danger bg-opacity-10">
                      <i class="bi bi-shield-check text-danger"></i>
                    </div>
                    <div>
                      <h6 class="fw-bold mb-1">Emergency Contacts</h6>
                      <p class="text-muted mb-0 small">In case of emergencies, the school needs reliable contact information for your parents/guardians.</p>
                    </div>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="d-flex align-items-start mb-3">
                    <div class="info-icon bg-success bg-opacity-10">
                      <i class="bi bi-calendar-check text-success"></i>
                    </div>
                    <div>
                      <h6 class="fw-bold mb-1">Parent-Teacher Meetings</h6>
                      <p class="text-muted mb-0 small">Facilitates scheduling and communication for parent-teacher conferences.</p>
                    </div>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="d-flex align-items-start mb-3">
                    <div class="info-icon bg-warning bg-opacity-10">
                      <i class="bi bi-file-earmark-text text-warning"></i>
                    </div>
                    <div>
                      <h6 class="fw-bold mb-1">Academic Reports</h6>
                      <p class="text-muted mb-0 small">Report cards and academic progress reports can be sent directly to parents.</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

    <script>
      document.addEventListener('DOMContentLoaded', function() {
        // Form validation
        (function () {
          "use strict";

          // Fetch all forms with needs-validation class
          var forms = document.querySelectorAll(".needs-validation");

          // Loop over them and prevent submission
          Array.from(forms).forEach(function (form) {
            form.addEventListener(
              "submit",
              function (event) {
                if (!form.checkValidity()) {
                  event.preventDefault();
                  event.stopPropagation();
                }

                form.classList.add("was-validated");
              },
              false
            );
          });
        })();
        
        // Add animation to cards
        const cards = document.querySelectorAll('.content-card, .parent-form-card');
        cards.forEach((card, index) => {
          card.style.opacity = '0';
          card.style.transition = 'opacity 0.5s ease, transform 0.3s ease';
          setTimeout(() => {
            card.style.opacity = '1';
          }, 100 * index);
        });
      });
    </script>
  </body>
</html>
