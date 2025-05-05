<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Profile - School Management System</title>
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
      .profile-card {
        transition: transform 0.3s;
        border-radius: var(--border-radius);
        border: none;
        box-shadow: var(--card-shadow);
      }
      .profile-card:hover {
        transform: translateY(-5px);
        box-shadow: var(--hover-shadow);
      }
      .profile-header {
        background: linear-gradient(to right, #6a11cb, #2575fc);
        border-radius: var(--border-radius);
        padding: 2rem;
        margin-bottom: 2rem;
        position: relative;
        overflow: hidden;
        color: white;
      }
      .profile-header::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: url('${pageContext.request.contextPath}/images/pattern-bg.png') repeat;
        opacity: 0.1;
      }
      .profile-image {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        object-fit: cover;
        border: 4px solid white;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        position: relative;
        z-index: 1;
      }
      .profile-image-overlay {
        position: absolute;
        bottom: 0;
        right: 0;
        background: rgba(13, 110, 253, 0.9);
        width: 35px;
        height: 35px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        border: 2px solid white;
      }
      .stats-card {
        border-radius: var(--border-radius);
        border: none;
        box-shadow: var(--card-shadow);
        transition: all 0.3s ease;
        height: 100%;
      }
      .stats-card:hover {
        transform: translateY(-5px);
        box-shadow: var(--hover-shadow);
      }
      .nav-pills .nav-link {
        color: #495057;
        padding: 0.75rem 1.5rem;
        border-radius: 8px;
        font-weight: 500;
        transition: all 0.3s ease;
        margin-bottom: 0.5rem;
      }
      .nav-pills .nav-link.active {
        background-color: var(--primary-color);
        box-shadow: 0 4px 8px rgba(13, 110, 253, 0.3);
      }
      .nav-pills .nav-link:hover:not(.active) {
        background-color: rgba(13, 110, 253, 0.1);
      }
      .form-control, .form-select {
        border-radius: 8px;
        padding: 0.6rem 1rem;
        border: 1px solid #dee2e6;
        transition: all 0.3s ease;
      }
      .form-control:focus, .form-select:focus {
        border-color: #80bdff;
        box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
      }
      .form-label {
        font-weight: 500;
        color: #495057;
        margin-bottom: 0.5rem;
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
                My Profile
              </li>
            </ol>
          </nav>

          <div class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center">
            <h1 class="page-title">My Profile</h1>
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
                      <img src="${profileData.imageLink}" alt="${profile.username}" class="profile-img me-2">
                    </c:when>
                    <c:otherwise>
                      <i class="bi bi-person-circle me-1"></i>
                    </c:otherwise>
                  </c:choose>
                  <span>${profile.username}</span>
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

          <!-- Profile Header -->
          <div class="profile-header">
            <div class="row align-items-center">
              <div class="col-md-auto text-center text-md-start mb-3 mb-md-0">
                <div class="position-relative d-inline-block">
                  <c:choose>
                    <c:when test="${not empty profileData.imageLink}">
                      <img
                        src="${profileData.imageLink}"
                        alt="Profile Picture"
                        class="profile-image"
                      />
                    </c:when>
                    <c:otherwise>
                      <img
                        src="${pageContext.request.contextPath}/images/default-profile.jpg"
                        alt="Profile Picture"
                        class="profile-image"
                      />
                    </c:otherwise>
                  </c:choose>
                  <div class="profile-image-overlay">
                    <i class="bi bi-camera-fill text-white"></i>
                  </div>
                </div>
              </div>
              <div class="col-md">
                <h2 class="mb-1 fw-bold">${profile.firstName} ${profile.lastName}</h2>
                <p class="text-white-50 mb-2">Student ID: ${profile.regNumber}</p>
                <div class="d-flex flex-wrap gap-3 mt-3">
                  <div class="d-flex align-items-center">
                    <i class="bi bi-envelope-fill me-2"></i>
                    <span>${profile.email}</span>
                  </div>
                  <div class="d-flex align-items-center">
                    <i class="bi bi-telephone-fill me-2"></i>
                    <span>${profile.phone}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Profile Stats -->
          <div class="row mb-4">
            <div class="col-md-4 mb-3">
              <div class="stats-card">
                <div class="card-body p-4">
                  <div class="d-flex align-items-center">
                    <div class="bg-primary bg-opacity-10 p-3 rounded me-3">
                      <i class="bi bi-book text-primary" style="font-size: 1.5rem;"></i>
                    </div>
                    <div>
                      <h6 class="text-muted mb-1">Enrolled Courses</h6>
                      <h3 class="mb-0 fw-bold">5</h3>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-3">
              <div class="stats-card">
                <div class="card-body p-4">
                  <div class="d-flex align-items-center">
                    <div class="bg-success bg-opacity-10 p-3 rounded me-3">
                      <i class="bi bi-award text-success" style="font-size: 1.5rem;"></i>
                    </div>
                    <div>
                      <h6 class="text-muted mb-1">Current GPA</h6>
                      <h3 class="mb-0 fw-bold">3.8</h3>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-3">
              <div class="stats-card">
                <div class="card-body p-4">
                  <div class="d-flex align-items-center">
                    <div class="bg-warning bg-opacity-10 p-3 rounded me-3">
                      <i class="bi bi-clipboard-check text-warning" style="font-size: 1.5rem;"></i>
                    </div>
                    <div>
                      <h6 class="text-muted mb-1">Pending Assignments</h6>
                      <h3 class="mb-0 fw-bold">3</h3>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Profile Tabs -->
          <div class="row">
            <div class="col-md-3 mb-4">
              <div class="content-card mb-4">
                <div class="card-body p-3">
                  <h5 class="fw-bold mb-3">Account Settings</h5>
                  <div class="nav flex-column nav-pills" id="profileTabs" role="tablist">
                    <button
                      class="nav-link active d-flex align-items-center"
                      id="info-tab"
                      data-bs-toggle="pill"
                      data-bs-target="#info"
                      type="button"
                      role="tab"
                      aria-controls="info"
                      aria-selected="true"
                    >
                      <i class="bi bi-person-vcard me-2"></i> Personal Information
                    </button>
                    <button
                      class="nav-link d-flex align-items-center"
                      id="security-tab"
                      data-bs-toggle="pill"
                      data-bs-target="#security"
                      type="button"
                      role="tab"
                      aria-controls="security"
                      aria-selected="false"
                    >
                      <i class="bi bi-shield-lock me-2"></i> Security
                    </button>
                    <button
                      class="nav-link d-flex align-items-center"
                      id="academic-tab"
                      data-bs-toggle="pill"
                      data-bs-target="#academic"
                      type="button"
                      role="tab"
                      aria-controls="academic"
                      aria-selected="false"
                    >
                      <i class="bi bi-mortarboard me-2"></i> Academic Info
                    </button>
                  </div>
                </div>
              </div>
              <div class="content-card">
                <div class="card-body p-3">
                  <h5 class="fw-bold mb-3">Help & Support</h5>
                  <div class="list-group list-group-flush">
                    <a href="#" class="list-group-item list-group-item-action border-0 ps-0">
                      <i class="bi bi-question-circle me-2 text-primary"></i> FAQs
                    </a>
                    <a href="#" class="list-group-item list-group-item-action border-0 ps-0">
                      <i class="bi bi-headset me-2 text-primary"></i> Contact Support
                    </a>
                    <a href="#" class="list-group-item list-group-item-action border-0 ps-0">
                      <i class="bi bi-book me-2 text-primary"></i> User Guide
                    </a>
                  </div>
                </div>
              </div>
            </div>
            
            <div class="col-md-9">
              <div class="tab-content" id="profileTabsContent">
                <!-- Basic Information Tab -->
                <div
                  class="tab-pane fade show active"
                  id="info"
                  role="tabpanel"
                  aria-labelledby="info-tab"
                >
                  <div class="content-card profile-card">
                    <div class="card-header bg-white py-3">
                      <h5 class="card-title mb-0">
                        <i class="bi bi-person-fill me-2 text-primary"></i>
                        Personal Information
                      </h5>
                    </div>
                    <div class="card-body p-4">
                      <form
                        action="${pageContext.request.contextPath}/student/profile"
                        method="post"
                        class="needs-validation"
                        novalidate
                      >
                        <div class="row mb-4">
                          <div class="col-md-6 mb-3">
                            <label for="firstName" class="form-label">First Name</label>
                            <div class="input-group">
                              <span class="input-group-text bg-light border-0">
                                <i class="bi bi-person text-muted"></i>
                              </span>
                              <input
                                type="text"
                                class="form-control border-0 bg-light"
                                id="firstName"
                                value="${profile.firstName}"
                                disabled
                              />
                            </div>
                          </div>
                          <div class="col-md-6 mb-3">
                            <label for="lastName" class="form-label">Last Name</label>
                            <div class="input-group">
                              <span class="input-group-text bg-light border-0">
                                <i class="bi bi-person text-muted"></i>
                              </span>
                              <input
                                type="text"
                                class="form-control border-0 bg-light"
                                id="lastName"
                                value="${profile.lastName}"
                                disabled
                              />
                            </div>
                          </div>
                          <div class="col-md-6 mb-3">
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
                                value="${profile.email}"
                                required
                              />
                            </div>
                            <div class="invalid-feedback">
                              Please provide a valid email.
                            </div>
                          </div>
                          <div class="col-md-6 mb-3">
                            <label for="phone" class="form-label">Phone</label>
                            <div class="input-group">
                              <span class="input-group-text bg-light border-0">
                                <i class="bi bi-telephone text-muted"></i>
                              </span>
                              <input
                                type="tel"
                                class="form-control border-0 bg-light"
                                id="phone"
                                name="phone"
                                value="${profile.phone}"
                                required
                              />
                            </div>
                            <div class="invalid-feedback">
                              Please provide a valid phone number.
                            </div>
                          </div>
                          <div class="col-12 mb-3">
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
                                required
                              >${profile.address}</textarea>
                            </div>
                            <div class="invalid-feedback">
                              Please provide your address.
                            </div>
                          </div>
                        </div>
                        <button type="submit" class="btn btn-primary">
                          <i class="bi bi-save me-2"></i> Save Changes
                        </button>
                      </form>
                    </div>
                  </div>
                </div>

                <!-- Security Tab -->
                <div
                  class="tab-pane fade"
                  id="security"
                  role="tabpanel"
                  aria-labelledby="security-tab"
                >
                  <div class="content-card profile-card">
                    <div class="card-header bg-white py-3">
                      <h5 class="card-title mb-0">
                        <i class="bi bi-shield-lock me-2 text-primary"></i>
                        Security Settings
                      </h5>
                    </div>
                    <div class="card-body p-4">
                      <form
                        action="${pageContext.request.contextPath}/student/profile"
                        method="post"
                        class="needs-validation"
                        novalidate
                      >
                        <div class="mb-4">
                          <h6 class="text-muted mb-3">Change Password</h6>
                          <div class="mb-3">
                            <label for="currentPassword" class="form-label">Current Password</label>
                            <div class="input-group">
                              <span class="input-group-text bg-light border-0">
                                <i class="bi bi-key text-muted"></i>
                              </span>
                              <input
                                type="password"
                                class="form-control border-0 bg-light"
                                id="currentPassword"
                                name="currentPassword"
                                required
                              />
                            </div>
                            <div class="invalid-feedback">
                              Please enter your current password.
                            </div>
                          </div>
                          <div class="mb-3">
                            <label for="newPassword" class="form-label">New Password</label>
                            <div class="input-group">
                              <span class="input-group-text bg-light border-0">
                                <i class="bi bi-lock text-muted"></i>
                              </span>
                              <input
                                type="password"
                                class="form-control border-0 bg-light"
                                id="newPassword"
                                name="newPassword"
                                required
                              />
                            </div>
                            <div class="invalid-feedback">
                              Please enter a new password.
                            </div>
                          </div>
                          <div class="mb-4">
                            <label for="confirmPassword" class="form-label">Confirm New Password</label>
                            <div class="input-group">
                              <span class="input-group-text bg-light border-0">
                                <i class="bi bi-lock text-muted"></i>
                              </span>
                              <input
                                type="password"
                                class="form-control border-0 bg-light"
                                id="confirmPassword"
                                name="confirmPassword"
                                required
                              />
                            </div>
                            <div class="invalid-feedback">
                              Please confirm your new password.
                            </div>
                          </div>
                        </div>
                        <div class="alert alert-info d-flex align-items-center" role="alert">
                          <i class="bi bi-info-circle-fill me-2"></i>
                          <div>
                            Make sure your password has at least 8 characters, including uppercase, lowercase, numbers, and special characters.
                          </div>
                        </div>
                        <button type="submit" class="btn btn-primary">
                          <i class="bi bi-shield-check me-2"></i> Update Password
                        </button>
                      </form>
                    </div>
                  </div>
                </div>

                <!-- Academic Info Tab -->
                <div
                  class="tab-pane fade"
                  id="academic"
                  role="tabpanel"
                  aria-labelledby="academic-tab"
                >
                  <div class="content-card profile-card">
                    <div class="card-header bg-white py-3">
                      <h5 class="card-title mb-0">
                        <i class="bi bi-mortarboard me-2 text-primary"></i>
                        Academic Information
                      </h5>
                    </div>
                    <div class="card-body p-4">
                      <div class="row">
                        <div class="col-md-6 mb-4">
                          <h6 class="form-label">Registration Number</h6>
                          <div class="input-group">
                            <span class="input-group-text bg-light border-0">
                              <i class="bi bi-card-list text-muted"></i>
                            </span>
                            <input
                              type="text"
                              class="form-control border-0 bg-light"
                              value="${profile.regNumber}"
                              disabled
                            />
                          </div>
                        </div>
                        <div class="col-md-6 mb-4">
                          <h6 class="form-label">Date of Birth</h6>
                          <div class="input-group">
                            <span class="input-group-text bg-light border-0">
                              <i class="bi bi-calendar text-muted"></i>
                            </span>
                            <input
                              type="text"
                              class="form-control border-0 bg-light"
                              value="<fmt:formatDate value='${profile.dateOfBirth}' pattern='MMM dd, yyyy'/>"
                              disabled
                            />
                          </div>
                        </div>
                        <div class="col-md-6 mb-4">
                          <h6 class="form-label">Admission Date</h6>
                          <div class="input-group">
                            <span class="input-group-text bg-light border-0">
                              <i class="bi bi-calendar-check text-muted"></i>
                            </span>
                            <input
                              type="text"
                              class="form-control border-0 bg-light"
                              value="<fmt:formatDate value='${profile.admissionDate}' pattern='MMM dd, yyyy'/>"
                              disabled
                            />
                          </div>
                        </div>
                      </div>
                      <hr class="my-4" />
                      <h6 class="mb-3">Academic Performance</h6>
                      <div class="row mb-3">
                        <div class="col-md-4 mb-3">
                          <div class="card bg-light border-0">
                            <div class="card-body p-3 text-center">
                              <h2 class="fw-bold mb-0 text-primary">3.8</h2>
                              <p class="text-muted mb-0">Current GPA</p>
                            </div>
                          </div>
                        </div>
                        <div class="col-md-4 mb-3">
                          <div class="card bg-light border-0">
                            <div class="card-body p-3 text-center">
                              <h2 class="fw-bold mb-0 text-success">5</h2>
                              <p class="text-muted mb-0">Courses Enrolled</p>
                            </div>
                          </div>
                        </div>
                        <div class="col-md-4 mb-3">
                          <div class="card bg-light border-0">
                            <div class="card-body p-3 text-center">
                              <h2 class="fw-bold mb-0 text-info">15</h2>
                              <p class="text-muted mb-0">Credit Hours</p>
                            </div>
                          </div>
                        </div>
                      </div>
                      <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <a href="${pageContext.request.contextPath}/student/grades" class="btn btn-outline-primary">
                          <i class="bi bi-bar-chart me-2"></i> View Complete Academic Records
                        </a>
                      </div>
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
          'use strict';

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
        const cards = document.querySelectorAll('.content-card, .stats-card');
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
