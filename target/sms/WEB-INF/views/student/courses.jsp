<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Courses - School Management System</title>
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
      .course-card {
        transition: transform 0.3s;
        border-radius: var(--border-radius);
        border: none;
        box-shadow: var(--card-shadow);
        height: 100%;
      }
      .course-card:hover {
        transform: translateY(-5px);
        box-shadow: var(--hover-shadow);
      }
      .card-icon {
        font-size: 2.5rem;
        margin-bottom: 0.5rem;
      }
      .course-badge {
        font-size: 0.85rem;
        padding: 0.5em 1em;
        margin-bottom: 1rem;
      }
      .profile-img {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        object-fit: cover;
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
                My Courses
              </li>
            </ol>
          </nav>

          <div class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center">
            <h1 class="page-title">My Courses</h1>
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
                    <a class="dropdown-item" href="#"
                      ><i class="bi bi-person me-2"></i> Profile</a
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
          
          <!-- Search and Filter Section -->
          <div class="content-card mb-4">
            <div class="card-body">
              <div class="row align-items-center">
                <div class="col-md-8">
                  <div class="input-group">
                    <span class="input-group-text bg-light border-0">
                      <i class="bi bi-search text-muted"></i>
                    </span>
                    <input type="text" id="courseSearch" class="form-control border-0 bg-light" placeholder="Search courses...">
                  </div>
                </div>
                <div class="col-md-4 text-md-end mt-3 mt-md-0">
                  <div class="btn-group">
                    <button type="button" class="btn btn-outline-primary">
                      <i class="bi bi-funnel me-2"></i> Filter
                    </button>
                    <button type="button" class="btn btn-outline-primary">
                      <i class="bi bi-sort-alpha-down me-2"></i> Sort
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Course List -->
          <div class="row">
            <c:choose>
              <c:when test="${empty courses}">
                <div class="col-12">
                  <div class="content-card">
                    <div class="card-body text-center py-5">
                      <i class="bi bi-journal-x text-muted" style="font-size: 4rem;"></i>
                      <h4 class="mt-3">No Courses Available</h4>
                      <p class="text-muted">You are not enrolled in any courses yet.</p>
                    </div>
                  </div>
                </div>
              </c:when>
              <c:otherwise>
                <c:forEach var="course" items="${courses}">
                  <div class="col-md-4 mb-4">
                    <div class="course-card">
                      <div class="card-body p-4">
                        <div class="d-flex justify-content-between mb-3">
                          <div class="bg-primary bg-opacity-10 p-3 rounded">
                            <i class="bi bi-book text-primary" style="font-size: 1.8rem;"></i>
                          </div>
                          <span class="badge bg-primary rounded-pill course-badge">
                            ${course.credits} Credits
                          </span>
                        </div>
                        <h5 class="card-title mb-1 fw-bold">${course.courseCode}</h5>
                        <h6 class="card-subtitle mb-3 text-muted">
                          ${course.courseName}
                        </h6>
                        <p class="card-text text-muted small">${course.description}</p>
                        
                        <div class="d-flex justify-content-between align-items-center mt-4">
                          <div class="small text-muted">
                            <i class="bi bi-calendar-event me-1"></i> Term: Spring 2023
                          </div>
                          <div class="text-primary fw-medium small">
                            <i class="bi bi-circle-fill me-1 text-success"></i> Active
                          </div>
                        </div>
                      </div>
                      <div class="card-footer bg-white py-3">
                        <div class="d-grid">
                          <a
                            href="${pageContext.request.contextPath}/student/course-details?id=${course.id}"
                            class="btn btn-primary btn-sm"
                          >
                            <i class="bi bi-eye me-1"></i> View Details
                          </a>
                        </div>
                      </div>
                    </div>
                  </div>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </div>

          <!-- Course Information Section -->
          <div class="row mt-4 mb-4">
            <div class="col-md-12">
              <div class="content-card">
                <div class="card-header bg-white d-flex align-items-center">
                  <i class="bi bi-info-circle text-primary me-2 fs-5"></i>
                  <h5 class="card-title mb-0">Course Information</h5>
                </div>
                <div class="card-body">
                  <div class="row">
                    <div class="col-md-8">
                      <p>
                        As a student, you can access detailed information about each
                        of your enrolled courses. Each course may include:
                      </p>
                      <div class="d-flex flex-wrap gap-3 mb-3">
                        <div class="bg-light rounded p-3 d-flex align-items-center">
                          <i class="bi bi-file-earmark-text text-primary me-2"></i>
                          <span>Course materials</span>
                        </div>
                        <div class="bg-light rounded p-3 d-flex align-items-center">
                          <i class="bi bi-calendar-check text-primary me-2"></i>
                          <span>Assignments</span>
                        </div>
                        <div class="bg-light rounded p-3 d-flex align-items-center">
                          <i class="bi bi-pencil-square text-primary me-2"></i>
                          <span>Quizzes and exams</span>
                        </div>
                        <div class="bg-light rounded p-3 d-flex align-items-center">
                          <i class="bi bi-graph-up text-primary me-2"></i>
                          <span>Grades</span>
                        </div>
                      </div>
                      <p class="mb-0">
                        Click on "View Details" for any course to access these resources.
                      </p>
                    </div>
                    <div class="col-md-4 d-flex align-items-center justify-content-center">
                      <div class="text-center">
                        <div class="bg-primary bg-opacity-10 p-4 rounded-circle mb-3 mx-auto">
                          <i class="bi bi-book-half text-primary" style="font-size: 3rem;"></i>
                        </div>
                        <h5 class="mb-0">Need Help?</h5>
                        <p class="small text-muted">Contact your course instructor</p>
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
        // Course search functionality
        const searchInput = document.getElementById('courseSearch');
        if (searchInput) {
          searchInput.addEventListener('keyup', function() {
            const searchTerm = this.value.toLowerCase();
            const courseCards = document.querySelectorAll('.course-card');
            
            courseCards.forEach(card => {
              const title = card.querySelector('.card-title').textContent.toLowerCase();
              const subtitle = card.querySelector('.card-subtitle').textContent.toLowerCase();
              const description = card.querySelector('.card-text').textContent.toLowerCase();
              
              if (title.includes(searchTerm) || subtitle.includes(searchTerm) || description.includes(searchTerm)) {
                card.closest('.col-md-4').style.display = 'block';
              } else {
                card.closest('.col-md-4').style.display = 'none';
              }
            });
          });
        }
        
        // Add animation to course cards
        const cards = document.querySelectorAll('.course-card');
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
