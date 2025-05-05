<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Doctor Dashboard - School Management System</title>

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
      body {
        font-family: 'Poppins', sans-serif;
        background-color: #f8f9fc;
      }
      
      .stats-card {
        border-radius: 0.75rem;
        padding: 1.5rem;
        margin-bottom: 1.5rem;
        box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        transition: transform 0.3s ease;
        border: none;
        height: 100%;
      }
      
      .stats-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 0.3rem 2rem rgba(0, 0, 0, 0.1);
      }

      .quick-action {
        text-align: center;
        padding: 1.5rem;
        border-radius: 0.75rem;
        transition: all 0.3s ease;
        margin-bottom: 1rem;
        border: none;
        box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        height: 100%;
      }

      .quick-action:hover {
        transform: translateY(-5px);
        box-shadow: 0 0.3rem 2rem rgba(0, 0, 0, 0.1);
      }

      .card {
        box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        border-radius: 0.75rem;
        overflow: hidden;
        border: none;
        margin-bottom: 1.5rem;
      }

      .card-header {
        background-color: white;
        border-bottom: 1px solid #e9ecef;
        padding: 1rem 1.5rem;
        font-weight: 500;
      }
      
      .announcement-card {
        transition: transform 0.3s;
        border-radius: 0.75rem;
        border: none;
        box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        height: 100%;
        margin-bottom: 1rem;
      }
      
      .announcement-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 0.3rem 2rem rgba(0, 0, 0, 0.1);
      }
      
      .profile-img {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        object-fit: cover;
      }
      
      .progress {
        height: 8px;
        border-radius: 4px;
      }
      
      .doctor-sidebar {
        background-color: #4e73df;
        background-image: linear-gradient(180deg, #4e73df 10%, #224abe 100%);
        background-size: cover;
        box-shadow: 0 .15rem 1.75rem 0 rgba(58, 59, 69, .15);
      }
      
      .doctor-sidebar .nav-item .nav-link {
        padding: 0.85rem 1.5rem;
        color: rgba(255, 255, 255, 0.8);
        font-weight: 500;
        display: flex;
        align-items: center;
      }
      
      .doctor-sidebar .nav-item .nav-link:hover {
        color: #fff;
      }
      
      .doctor-sidebar .nav-item .nav-link.active {
        color: #fff;
        font-weight: 600;
        background-color: rgba(255, 255, 255, 0.1);
        border-radius: 0.5rem;
      }
      
      .breadcrumb {
        background-color: transparent;
        padding: 0;
      }
      
      .breadcrumb-item a {
        color: #4e73df;
        text-decoration: none;
      }
      
      .page-title {
        font-weight: 600;
        color: #5a5c69;
        margin-bottom: 1rem;
      }
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
        <!-- Include Doctor Sidebar -->
        <jsp:include page="/WEB-INF/includes/doctor-sidebar.jsp" />

        <!-- Main Content -->
        <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
          <!-- Breadcrumb -->
          <nav aria-label="breadcrumb" class="mt-3">
            <ol class="breadcrumb">
              <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/dashboard">Home</a>
              </li>
              <li class="breadcrumb-item active" aria-current="page">
                Doctor Dashboard
              </li>
            </ol>
          </nav>

          <div class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center">
            <h1 class="page-title">Doctor Dashboard</h1>
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
                    <c:when test="${not empty user.imageLink}">
                      <img src="${user.imageLink}" alt="${user.username}" class="profile-img me-2">
                    </c:when>
                    <c:otherwise>
                      <i class="bi bi-person-circle me-1"></i>
                    </c:otherwise>
                  </c:choose>
                  <span>Dr. ${sessionScope.user.username}</span>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenuLink">
                  <li>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/doctor/profile">
                      <i class="bi bi-person me-2"></i> Profile
                    </a>
                  </li>
                  <li><hr class="dropdown-divider" /></li>
                  <li>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                      <i class="bi bi-box-arrow-right me-2"></i> Logout
                    </a>
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

          <!-- Stats Cards -->
          <div class="row mb-4">
            <div class="col-md-4 mb-3">
              <div class="content-card h-100">
                <div class="card-body p-4">
                  <div class="d-flex justify-content-between mb-3">
                    <div class="bg-primary bg-opacity-10 p-3 rounded">
                      <i class="bi bi-calendar-check text-primary" style="font-size: 1.8rem;"></i>
                    </div>
                    <h2 class="text-primary mb-0">${todayAppointments}</h2>
                  </div>
                  <h5 class="text-muted mb-3">Today's Appointments</h5>
                  <div class="progress">
                    <div class="progress-bar bg-primary" role="progressbar" style="width: ${(todayAppointments / 10) * 100}%;"></div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-3">
              <div class="content-card h-100">
                <div class="card-body p-4">
                  <div class="d-flex justify-content-between mb-3">
                    <div class="bg-success bg-opacity-10 p-3 rounded">
                      <i class="bi bi-hospital text-success" style="font-size: 1.8rem;"></i>
                    </div>
                    <h2 class="text-success mb-0">15</h2>
                  </div>
                  <h5 class="text-muted mb-3">Health Checkups</h5>
                  <div class="progress">
                    <div class="progress-bar bg-success" role="progressbar" style="width: 75%;"></div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-3">
              <div class="content-card h-100">
                <div class="card-body p-4">
                  <div class="d-flex justify-content-between mb-3">
                    <div class="bg-warning bg-opacity-10 p-3 rounded">
                      <i class="bi bi-clipboard2-pulse text-warning" style="font-size: 1.8rem;"></i>
                    </div>
                    <h2 class="text-warning mb-0">8</h2>
                  </div>
                  <h5 class="text-muted mb-3">Pending Reports</h5>
                  <div class="progress">
                    <div class="progress-bar bg-warning" role="progressbar" style="width: 40%;"></div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Quick Actions Row -->
          <h4 class="mb-3">Quick Actions</h4>
          <div class="row mb-4">
            <div class="col-md-3 mb-3">
              <div class="content-card text-center h-100">
                <div class="card-body p-4">
                  <div class="bg-primary bg-opacity-10 p-3 rounded mx-auto mb-3" style="width: 60px; height: 60px; display: flex; align-items: center; justify-content: center;">
                    <i class="bi bi-plus-circle text-primary" style="font-size: 1.8rem;"></i>
                  </div>
                  <h5 class="mb-2">Schedule Appointment</h5>
                  <p class="text-muted small mb-3">Create a new appointment with a student</p>
                  <a href="${pageContext.request.contextPath}/doctor/appointments/new" class="btn btn-sm btn-primary">Create</a>
                </div>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="content-card text-center h-100">
                <div class="card-body p-4">
                  <div class="bg-success bg-opacity-10 p-3 rounded mx-auto mb-3" style="width: 60px; height: 60px; display: flex; align-items: center; justify-content: center;">
                    <i class="bi bi-file-medical text-success" style="font-size: 1.8rem;"></i>
                  </div>
                  <h5 class="mb-2">Create Report</h5>
                  <p class="text-muted small mb-3">Generate a new medical report</p>
                  <a href="${pageContext.request.contextPath}/doctor/health-reports/new" class="btn btn-sm btn-success">Create</a>
                </div>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="content-card text-center h-100">
                <div class="card-body p-4">
                  <div class="bg-info bg-opacity-10 p-3 rounded mx-auto mb-3" style="width: 60px; height: 60px; display: flex; align-items: center; justify-content: center;">
                    <i class="bi bi-search text-info" style="font-size: 1.8rem;"></i>
                  </div>
                  <h5 class="mb-2">Find Student</h5>
                  <p class="text-muted small mb-3">Search for student health records</p>
                  <a href="${pageContext.request.contextPath}/doctor/students" class="btn btn-sm btn-info">Search</a>
                </div>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="content-card text-center h-100">
                <div class="card-body p-4">
                  <div class="bg-secondary bg-opacity-10 p-3 rounded mx-auto mb-3" style="width: 60px; height: 60px; display: flex; align-items: center; justify-content: center;">
                    <i class="bi bi-clipboard-data text-secondary" style="font-size: 1.8rem;"></i>
                  </div>
                  <h5 class="mb-2">Analytics</h5>
                  <p class="text-muted small mb-3">View health trends and insights</p>
                  <a href="${pageContext.request.contextPath}/doctor/analytics" class="btn btn-sm btn-secondary">View</a>
                </div>
              </div>
            </div>
          </div>

          <!-- Upcoming Appointments and Recent Announcements row -->
          <div class="row">
            <!-- Upcoming Appointments -->
            <div class="col-md-7 mb-4">
              <div class="content-card h-100">
                <div class="card-header d-flex justify-content-between align-items-center">
                  <h5 class="mb-0">
                    <i class="bi bi-calendar me-2 text-primary"></i>
                    Upcoming Appointments
                  </h5>
                  <a href="${pageContext.request.contextPath}/doctor/appointments" class="btn btn-sm btn-outline-primary">View All</a>
                </div>
                <div class="card-body p-0">
                  <div class="list-group list-group-flush">
                    <!-- Sample appointments, replace with actual data -->
                    <div class="list-group-item p-3 border-0">
                      <div class="d-flex justify-content-between align-items-center">
                        <div class="d-flex align-items-center">
                          <div class="bg-primary bg-opacity-10 p-2 rounded-circle me-3">
                            <i class="bi bi-person text-primary"></i>
                          </div>
                          <div>
                            <h6 class="mb-0">John Smith</h6>
                            <small class="text-muted">General Checkup</small>
                          </div>
                        </div>
                        <div class="text-end">
                          <span class="badge bg-primary">9:30 AM Today</span>
                        </div>
                      </div>
                    </div>
                    <div class="list-group-item p-3 border-0">
                      <div class="d-flex justify-content-between align-items-center">
                        <div class="d-flex align-items-center">
                          <div class="bg-primary bg-opacity-10 p-2 rounded-circle me-3">
                            <i class="bi bi-person text-primary"></i>
                          </div>
                          <div>
                            <h6 class="mb-0">Emily Johnson</h6>
                            <small class="text-muted">Follow-up Visit</small>
                          </div>
                        </div>
                        <div class="text-end">
                          <span class="badge bg-primary">11:00 AM Today</span>
                        </div>
                      </div>
                    </div>
                    <div class="list-group-item p-3 border-0">
                      <div class="d-flex justify-content-between align-items-center">
                        <div class="d-flex align-items-center">
                          <div class="bg-warning bg-opacity-10 p-2 rounded-circle me-3">
                            <i class="bi bi-person text-warning"></i>
                          </div>
                          <div>
                            <h6 class="mb-0">Michael Brown</h6>
                            <small class="text-muted">Vaccination</small>
                          </div>
                        </div>
                        <div class="text-end">
                          <span class="badge bg-warning">2:15 PM Today</span>
                        </div>
                      </div>
                    </div>
                    <div class="list-group-item p-3 border-0">
                      <div class="d-flex justify-content-between align-items-center">
                        <div class="d-flex align-items-center">
                          <div class="bg-info bg-opacity-10 p-2 rounded-circle me-3">
                            <i class="bi bi-person text-info"></i>
                          </div>
                          <div>
                            <h6 class="mb-0">Sarah Wilson</h6>
                            <small class="text-muted">Annual Physical</small>
                          </div>
                        </div>
                        <div class="text-end">
                          <span class="badge bg-info">10:00 AM Tomorrow</span>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Recent Announcements -->
            <div class="col-md-5 mb-4">
              <div class="content-card h-100">
                <div class="card-header d-flex justify-content-between align-items-center">
                  <h5 class="mb-0">
                    <i class="bi bi-megaphone me-2 text-primary"></i>
                    Recent Announcements
                  </h5>
                </div>
                <div class="card-body">
                  <c:choose>
                    <c:when test="${not empty announcements}">
                      <c:forEach var="announcement" items="${announcements}">
                        <div class="announcement-card mb-3">
                          <div class="card-body p-3">
                            <div class="d-flex justify-content-between">
                              <h6 class="card-title">${announcement.title}</h6>
                              <span class="badge bg-light text-dark">
                                <fmt:formatDate value="${announcement.createdAt}" pattern="MMM dd"/>
                              </span>
                            </div>
                            <p class="card-text small text-muted">${announcement.content}</p>
                            <div class="d-flex align-items-center mt-3">
                              <small class="text-muted">By: ${announcement.createdBy}</small>
                            </div>
                          </div>
                        </div>
                      </c:forEach>
                    </c:when>
                    <c:otherwise>
                      <div class="text-center py-5">
                        <i class="bi bi-info-circle text-muted mb-3" style="font-size: 2rem;"></i>
                        <p class="mb-0">No announcements available</p>
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

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      document.addEventListener('DOMContentLoaded', function() {
        // Add animation to cards
        const cards = document.querySelectorAll('.content-card');
        cards.forEach((card, index) => {
          card.style.opacity = '0';
          card.style.transform = 'translateY(20px)';
          card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
          setTimeout(() => {
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
          }, 100 * index);
        });
      });
    </script>
  </body>
</html>
