<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Update Parent Information - School Management System</title>
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
    <!-- Custom CSS -->
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />
    <style>
      .form-card {
        border-radius: 10px;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
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
        <div
          class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse"
          style="min-height: 100vh"
        >
          <div class="position-sticky pt-3">
            <div class="d-flex align-items-center justify-content-center mb-4">
              <img
                src="${pageContext.request.contextPath}/images/school-logo.png"
                alt="School Logo"
                width="50"
                class="me-2"
              />
              <span class="fs-4 text-white">School MS</span>
            </div>
            <hr class="text-white" />
            <ul class="nav flex-column">
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/student/dashboard"
                >
                  <i class="bi bi-speedometer2 me-2"></i> Dashboard
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="#">
                  <i class="bi bi-book me-2"></i> My Courses
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="#">
                  <i class="bi bi-card-checklist me-2"></i> Grades
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="#">
                  <i class="bi bi-file-earmark-text me-2"></i> Assignments
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link active text-white"
                  href="${pageContext.request.contextPath}/student/update-parent"
                >
                  <i class="bi bi-people me-2"></i> Parent Info
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link text-white" href="#">
                  <i class="bi bi-person me-2"></i> Profile
                </a>
              </li>
              <li class="nav-item mt-5">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/logout"
                >
                  <i class="bi bi-box-arrow-right me-2"></i> Logout
                </a>
              </li>
            </ul>
          </div>
        </div>

        <!-- Main content -->
        <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 mt-4">
          <div
            class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom"
          >
            <h1 class="h2">Parent Information</h1>
            <div class="btn-toolbar mb-2 mb-md-0">
              <div class="dropdown">
                <a
                  class="btn btn-sm btn-outline-secondary dropdown-toggle"
                  href="#"
                  role="button"
                  id="dropdownMenuLink"
                  data-bs-toggle="dropdown"
                  aria-expanded="false"
                >
                  <i class="bi bi-person-circle me-1"></i> ${user.username}
                </a>
                <ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
                  <li>
                    <a class="dropdown-item" href="#"
                      ><i class="bi bi-person me-2"></i> Profile</a
                    >
                  </li>
                  <li>
                    <a class="dropdown-item" href="#"
                      ><i class="bi bi-gear me-2"></i> Settings</a
                    >
                  </li>
                  <li><hr class="dropdown-divider" /></li>
                  <li>
                    <a
                      class="dropdown-item"
                      href="${pageContext.request.contextPath}/logout"
                      ><i class="bi bi-box-arrow-right me-2"></i> Logout</a
                    >
                  </li>
                </ul>
              </div>
            </div>
          </div>

          <!-- Alerts -->
          <c:if test="${not empty error}">
            <div
              class="alert alert-danger alert-dismissible fade show"
              role="alert"
            >
              ${error}
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
                aria-label="Close"
              ></button>
            </div>
          </c:if>
          <c:if test="${not empty message}">
            <div
              class="alert alert-success alert-dismissible fade show"
              role="alert"
            >
              ${message}
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
                aria-label="Close"
              ></button>
            </div>
          </c:if>

          <!-- Parent Information Form -->
          <div class="row justify-content-center">
            <div class="col-md-10">
              <div class="card form-card mb-4">
                <div class="card-header bg-primary text-white">
                  <h5 class="card-title mb-0">
                    <i class="bi bi-people me-2"></i>
                    <c:choose>
                      <c:when test="${empty parent}"
                        >Add Parent Information</c:when
                      >
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
                        <label for="firstName" class="form-label required-field"
                          >First Name</label
                        >
                        <input
                          type="text"
                          class="form-control"
                          id="firstName"
                          name="firstName"
                          value="${parent.firstName}"
                          required
                        />
                        <div class="invalid-feedback">
                          First name is required.
                        </div>
                      </div>
                      <div class="col-md-6">
                        <label for="lastName" class="form-label required-field"
                          >Last Name</label
                        >
                        <input
                          type="text"
                          class="form-control"
                          id="lastName"
                          name="lastName"
                          value="${parent.lastName}"
                          required
                        />
                        <div class="invalid-feedback">
                          Last name is required.
                        </div>
                      </div>
                      <div class="col-md-6">
                        <label for="email" class="form-label">Email</label>
                        <input
                          type="email"
                          class="form-control"
                          id="email"
                          name="email"
                          value="${parent.email}"
                        />
                        <div class="invalid-feedback">
                          Please enter a valid email address.
                        </div>
                      </div>
                      <div class="col-md-6">
                        <label for="phone" class="form-label required-field"
                          >Phone</label
                        >
                        <input
                          type="tel"
                          class="form-control"
                          id="phone"
                          name="phone"
                          value="${parent.phone}"
                          required
                        />
                        <div class="invalid-feedback">
                          Phone number is required.
                        </div>
                      </div>
                      <div class="col-12">
                        <label for="address" class="form-label">Address</label>
                        <textarea
                          class="form-control"
                          id="address"
                          name="address"
                          rows="3"
                        >
${parent.address}</textarea
                        >
                      </div>
                      <div class="col-md-6">
                        <label for="occupation" class="form-label"
                          >Occupation</label
                        >
                        <input
                          type="text"
                          class="form-control"
                          id="occupation"
                          name="occupation"
                          value="${parent.occupation}"
                        />
                      </div>
                      <div class="col-12 mt-4">
                        <div class="d-flex justify-content-between">
                          <button type="submit" class="btn btn-primary">
                            <i class="bi bi-save me-2"></i> Save Parent
                            Information
                          </button>
                          <a
                            href="${pageContext.request.contextPath}/student/dashboard"
                            class="btn btn-outline-secondary"
                          >
                            <i class="bi bi-arrow-left me-2"></i> Back to
                            Dashboard
                          </a>
                        </div>
                      </div>
                    </div>
                  </form>
                </div>
              </div>
            </div>
          </div>

          <!-- Parent-Student Relationship Information -->
          <div class="row justify-content-center mb-4">
            <div class="col-md-10">
              <div class="card">
                <div class="card-header bg-info text-white">
                  <h5 class="card-title mb-0">
                    <i class="bi bi-info-circle me-2"></i> Why Update Parent
                    Information?
                  </h5>
                </div>
                <div class="card-body">
                  <p>
                    Keeping your parent information up-to-date is important for:
                  </p>
                  <ul>
                    <li>Emergency contacts</li>
                    <li>School communications</li>
                    <li>Parent-teacher meetings</li>
                    <li>Report card distributions</li>
                    <li>Permission for school activities</li>
                  </ul>
                  <p class="mb-0">
                    Your parent will receive important notifications from the
                    school. Make sure their contact information is correct and
                    current.
                  </p>
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
    </script>
  </body>
</html>
