<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Assignments - School Management System</title>
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
      .assignment-card {
        transition: transform 0.3s;
        border-radius: var(--border-radius);
        border: none;
        box-shadow: var(--card-shadow);
        height: 100%;
        margin-bottom: 1.5rem;
      }
      .assignment-card:hover {
        transform: translateY(-5px);
        box-shadow: var(--hover-shadow);
      }
      .assignment-header {
        border-bottom: 1px solid rgba(0, 0, 0, 0.1);
        padding-bottom: 15px;
        margin-bottom: 15px;
      }
      .priority-indicator {
        width: 10px;
        height: 10px;
        border-radius: 50%;
        display: inline-block;
        margin-right: 5px;
      }
      .time-remaining {
        font-size: 0.9rem;
      }
      .nav-pills .nav-link {
        color: #495057;
        padding: 0.75rem 1.5rem;
        border-radius: 8px;
        font-weight: 500;
        transition: all 0.3s ease;
      }
      .nav-pills .nav-link.active {
        background-color: var(--primary-color);
        box-shadow: 0 4px 8px rgba(13, 110, 253, 0.3);
      }
      .nav-pills .nav-link:hover:not(.active) {
        background-color: rgba(13, 110, 253, 0.1);
      }
      .status-badge {
        padding: 0.5em 1em;
        border-radius: 30px;
        font-weight: 500;
      }
      .profile-img {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        object-fit: cover;
      }
      .course-icon {
        width: 45px;
        height: 45px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 10px;
        margin-right: 15px;
      }
      .progress {
        height: 8px;
        border-radius: 4px;
      }
      .assignment-description {
        color: #666;
        margin-bottom: 1.5rem;
        overflow: hidden;
        display: -webkit-box;
        -webkit-line-clamp: 3;
        -webkit-box-orient: vertical;
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
                My Assignments
              </li>
            </ol>
          </nav>

          <div class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center">
            <h1 class="page-title">My Assignments</h1>
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
          
          <!-- Assignment Stats Summary -->
          <div class="row mb-4">
            <div class="col-md-4 mb-3">
              <div class="content-card h-100">
                <div class="card-body p-4">
                  <div class="d-flex justify-content-between mb-3">
                    <div class="bg-danger bg-opacity-10 p-3 rounded">
                      <i class="bi bi-hourglass-split text-danger" style="font-size: 1.8rem;"></i>
                    </div>
                    <h2 class="text-danger mb-0">${pendingAssignments.size()}</h2>
                  </div>
                  <h5 class="text-muted mb-3">Pending Assignments</h5>
                  <div class="progress">
                    <div class="progress-bar bg-danger" role="progressbar" style="width: ${(pendingAssignments.size() / 10) * 100}%;"></div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-3">
              <div class="content-card h-100">
                <div class="card-body p-4">
                  <div class="d-flex justify-content-between mb-3">
                    <div class="bg-warning bg-opacity-10 p-3 rounded">
                      <i class="bi bi-calendar-event text-warning" style="font-size: 1.8rem;"></i>
                    </div>
                    <h2 class="text-warning mb-0">${upcomingAssignments.size()}</h2>
                  </div>
                  <h5 class="text-muted mb-3">Upcoming Assignments</h5>
                  <div class="progress">
                    <div class="progress-bar bg-warning" role="progressbar" style="width: ${(upcomingAssignments.size() / 10) * 100}%;"></div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-4 mb-3">
              <div class="content-card h-100">
                <div class="card-body p-4">
                  <div class="d-flex justify-content-between mb-3">
                    <div class="bg-success bg-opacity-10 p-3 rounded">
                      <i class="bi bi-check-circle text-success" style="font-size: 1.8rem;"></i>
                    </div>
                    <h2 class="text-success mb-0">${completedAssignments.size()}</h2>
                  </div>
                  <h5 class="text-muted mb-3">Completed Assignments</h5>
                  <div class="progress">
                    <div class="progress-bar bg-success" role="progressbar" style="width: ${(completedAssignments.size() / 10) * 100}%;"></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Search and Filter Section -->
          <div class="content-card mb-4">
            <div class="card-body p-3">
              <div class="row align-items-center">
                <div class="col-md-7">
                  <div class="input-group">
                    <span class="input-group-text bg-light border-0">
                      <i class="bi bi-search text-muted"></i>
                    </span>
                    <input type="text" id="assignmentSearch" class="form-control border-0 bg-light" placeholder="Search assignments...">
                  </div>
                </div>
                <div class="col-md-5 text-md-end mt-3 mt-md-0">
                  <div class="btn-group">
                    <button type="button" class="btn btn-outline-primary">
                      <i class="bi bi-funnel me-2"></i> Filter
                    </button>
                    <button type="button" class="btn btn-outline-primary">
                      <i class="bi bi-sort-alpha-down me-2"></i> Sort
                    </button>
                    <button type="button" class="btn btn-outline-primary">
                      <i class="bi bi-calendar3 me-2"></i> Calendar
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Assignment Tabs -->
          <ul class="nav nav-pills mb-4" id="assignmentTabs" role="tablist">
            <li class="nav-item" role="presentation">
              <button class="nav-link active" id="pending-tab" data-bs-toggle="pill" data-bs-target="#pending" type="button" role="tab" aria-controls="pending" aria-selected="true">
                <i class="bi bi-hourglass-split me-1"></i> Pending
                <c:if test="${not empty pendingAssignments}">
                  <span class="badge bg-danger rounded-pill">${pendingAssignments.size()}</span>
                </c:if>
              </button>
            </li>
            <li class="nav-item" role="presentation">
              <button class="nav-link" id="upcoming-tab" data-bs-toggle="pill" data-bs-target="#upcoming" type="button" role="tab" aria-controls="upcoming" aria-selected="false">
                <i class="bi bi-calendar-date me-1"></i> Upcoming
                <c:if test="${not empty upcomingAssignments}">
                  <span class="badge bg-info rounded-pill">${upcomingAssignments.size()}</span>
                </c:if>
              </button>
            </li>
            <li class="nav-item" role="presentation">
              <button class="nav-link" id="completed-tab" data-bs-toggle="pill" data-bs-target="#completed" type="button" role="tab" aria-controls="completed" aria-selected="false">
                <i class="bi bi-check-circle me-1"></i> Completed
                <c:if test="${not empty completedAssignments}">
                  <span class="badge bg-success rounded-pill">${completedAssignments.size()}</span>
                </c:if>
              </button>
            </li>
          </ul>

          <div class="tab-content" id="assignmentTabsContent">
            <!-- Pending Assignments -->
            <div class="tab-pane fade show active" id="pending" role="tabpanel" aria-labelledby="pending-tab">
              <div class="row">
                <c:choose>
                  <c:when test="${empty pendingAssignments}">
                    <div class="col-12">
                      <div class="content-card">
                        <div class="card-body text-center py-5">
                          <i class="bi bi-hourglass text-muted" style="font-size: 4rem;"></i>
                          <h4 class="mt-3">No Pending Assignments</h4>
                          <p class="text-muted">You're all caught up! Check the upcoming tab for future assignments.</p>
                        </div>
                      </div>
                    </div>
                  </c:when>
                  <c:otherwise>
                    <c:forEach var="assignment" items="${pendingAssignments}" varStatus="loop">
                      <div class="col-md-6 assignment-item">
                        <div class="assignment-card">
                          <div class="card-body p-4">
                            <div class="d-flex align-items-start mb-3">
                              <div class="course-icon bg-danger bg-opacity-10">
                                <i class="bi bi-journal-text text-danger"></i>
                              </div>
                              <div>
                                <span class="badge bg-primary rounded-pill mb-1">${assignment.courseCode}</span>
                                <h5 class="mb-0">${assignment.title}</h5>
                                <span class="text-muted small">${assignment.courseName}</span>
                              </div>
                            </div>
                            <p class="assignment-description">${assignment.description}</p>
                            <div class="d-flex justify-content-between align-items-center mb-3">
                              <div class="status-badge bg-danger bg-opacity-10 text-danger">
                                <i class="bi bi-alarm me-1"></i> Due: <fmt:formatDate value="${assignment.dueDate}" pattern="MMM dd, yyyy"/>
                              </div>
                              <span class="badge bg-primary">Max Score: ${assignment.maxScore}</span>
                            </div>
                            <div class="d-grid">
                              <a href="${pageContext.request.contextPath}/student/submission?id=${assignment.id}" class="btn btn-primary">
                                <i class="bi bi-upload me-1"></i> Submit Assignment
                              </a>
                            </div>
                          </div>
                        </div>
                      </div>
                    </c:forEach>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>

            <!-- Upcoming Assignments -->
            <div class="tab-pane fade" id="upcoming" role="tabpanel" aria-labelledby="upcoming-tab">
              <div class="row">
                <c:choose>
                  <c:when test="${empty upcomingAssignments}">
                    <div class="col-12">
                      <div class="content-card">
                        <div class="card-body text-center py-5">
                          <i class="bi bi-calendar-x text-muted" style="font-size: 4rem;"></i>
                          <h4 class="mt-3">No Upcoming Assignments</h4>
                          <p class="text-muted">There are no assignments scheduled for the future.</p>
                        </div>
                      </div>
                    </div>
                  </c:when>
                  <c:otherwise>
                    <c:forEach var="assignment" items="${upcomingAssignments}" varStatus="loop">
                      <div class="col-md-6 assignment-item">
                        <div class="assignment-card">
                          <div class="card-body p-4">
                            <div class="d-flex align-items-start mb-3">
                              <div class="course-icon bg-info bg-opacity-10">
                                <i class="bi bi-journal-text text-info"></i>
                              </div>
                              <div>
                                <span class="badge bg-primary rounded-pill mb-1">${assignment.courseCode}</span>
                                <h5 class="mb-0">${assignment.title}</h5>
                                <span class="text-muted small">${assignment.courseName}</span>
                              </div>
                            </div>
                            <p class="assignment-description">${assignment.description}</p>
                            <div class="d-flex justify-content-between align-items-center mb-3">
                              <div class="status-badge bg-info bg-opacity-10 text-info">
                                <i class="bi bi-calendar me-1"></i> Due: <fmt:formatDate value="${assignment.dueDate}" pattern="MMM dd, yyyy"/>
                              </div>
                              <span class="badge bg-primary">Max Score: ${assignment.maxScore}</span>
                            </div>
                            <div class="d-grid">
                              <button type="button" class="btn btn-outline-secondary" disabled>
                                <i class="bi bi-clock-history me-1"></i> Available Later
                              </button>
                            </div>
                          </div>
                        </div>
                      </div>
                    </c:forEach>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>

            <!-- Completed Assignments -->
            <div class="tab-pane fade" id="completed" role="tabpanel" aria-labelledby="completed-tab">
              <div class="row">
                <c:choose>
                  <c:when test="${empty completedAssignments}">
                    <div class="col-12">
                      <div class="content-card">
                        <div class="card-body text-center py-5">
                          <i class="bi bi-clipboard-x text-muted" style="font-size: 4rem;"></i>
                          <h4 class="mt-3">No Completed Assignments</h4>
                          <p class="text-muted">You haven't completed any assignments yet. Check the pending tab.</p>
                        </div>
                      </div>
                    </div>
                  </c:when>
                  <c:otherwise>
                    <c:forEach var="assignment" items="${completedAssignments}" varStatus="loop">
                      <div class="col-md-6 assignment-item">
                        <div class="assignment-card">
                          <div class="card-body p-4">
                            <div class="d-flex align-items-start mb-3">
                              <div class="course-icon bg-success bg-opacity-10">
                                <i class="bi bi-journal-check text-success"></i>
                              </div>
                              <div>
                                <span class="badge bg-primary rounded-pill mb-1">${assignment.courseCode}</span>
                                <h5 class="mb-0">${assignment.title}</h5>
                                <span class="text-muted small">${assignment.courseName}</span>
                              </div>
                            </div>
                            <p class="assignment-description">${assignment.description}</p>
                            <div class="d-flex justify-content-between align-items-center mb-2">
                              <div class="status-badge bg-success bg-opacity-10 text-success">
                                <i class="bi bi-check-circle me-1"></i> Submitted: <fmt:formatDate value="${assignment.submissionDate}" pattern="MMM dd, yyyy"/>
                              </div>
                              <c:choose>
                                <c:when test="${assignment.score > 0}">
                                  <span class="badge bg-success">Score: ${assignment.score}/${assignment.maxScore}</span>
                                </c:when>
                                <c:otherwise>
                                  <span class="badge bg-warning text-dark">Awaiting Grade</span>
                                </c:otherwise>
                              </c:choose>
                            </div>
                            <c:if test="${assignment.score > 0}">
                              <div class="mb-3">
                                <small class="d-block text-muted mb-1">Performance</small>
                                <div class="progress">
                                  <div class="progress-bar bg-${assignment.percentage >= 90 ? 'success' : (assignment.percentage >= 70 ? 'info' : (assignment.percentage >= 60 ? 'warning' : 'danger'))}" 
                                       role="progressbar" 
                                       style="width: ${assignment.percentage}%;" 
                                       aria-valuenow="${assignment.percentage}" 
                                       aria-valuemin="0" 
                                       aria-valuemax="100">
                                  </div>
                                </div>
                                <div class="d-flex justify-content-between mt-1">
                                  <small>${assignment.percentage}%</small>
                                  <small>${assignment.percentage >= 90 ? 'Excellent' : (assignment.percentage >= 70 ? 'Good' : (assignment.percentage >= 60 ? 'Satisfactory' : 'Needs Improvement'))}</small>
                                </div>
                              </div>
                            </c:if>
                            <div class="d-grid">
                              <a href="${pageContext.request.contextPath}/student/submission?id=${assignment.id}" class="btn btn-outline-primary">
                                <i class="bi bi-eye me-1"></i> View Submission
                              </a>
                            </div>
                          </div>
                        </div>
                      </div>
                    </c:forEach>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>

          <!-- Assignment Tips Card -->
          <div class="row mt-4 mb-4">
            <div class="col-md-12">
              <div class="content-card">
                <div class="card-header bg-white d-flex align-items-center">
                  <i class="bi bi-lightbulb text-primary me-2 fs-5"></i>
                  <h5 class="card-title mb-0">Assignment Tips</h5>
                </div>
                <div class="card-body">
                  <div class="row">
                    <div class="col-md-6">
                      <h6 class="mb-3">
                        <div class="d-flex align-items-center">
                          <div class="bg-success bg-opacity-10 p-2 rounded me-2">
                            <i class="bi bi-check-circle text-success"></i>
                          </div>
                          Submission Guidelines
                        </div>
                      </h6>
                      <div class="ps-4">
                        <div class="d-flex align-items-center mb-2">
                          <i class="bi bi-arrow-right-short text-primary me-2"></i>
                          <span>Always submit assignments before the due date</span>
                        </div>
                        <div class="d-flex align-items-center mb-2">
                          <i class="bi bi-arrow-right-short text-primary me-2"></i>
                          <span>Follow the file format requirements specified in the assignment</span>
                        </div>
                        <div class="d-flex align-items-center mb-2">
                          <i class="bi bi-arrow-right-short text-primary me-2"></i>
                          <span>Ensure your name and student ID are included in your submissions</span>
                        </div>
                        <div class="d-flex align-items-center mb-2">
                          <i class="bi bi-arrow-right-short text-primary me-2"></i>
                          <span>Double-check your work before submitting</span>
                        </div>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <h6 class="mb-3">
                        <div class="d-flex align-items-center">
                          <div class="bg-warning bg-opacity-10 p-2 rounded me-2">
                            <i class="bi bi-exclamation-triangle text-warning"></i>
                          </div>
                          Common Mistakes to Avoid
                        </div>
                      </h6>
                      <div class="ps-4">
                        <div class="d-flex align-items-center mb-2">
                          <i class="bi bi-arrow-right-short text-primary me-2"></i>
                          <span>Missing the submission deadline</span>
                        </div>
                        <div class="d-flex align-items-center mb-2">
                          <i class="bi bi-arrow-right-short text-primary me-2"></i>
                          <span>Not answering all questions or requirements</span>
                        </div>
                        <div class="d-flex align-items-center mb-2">
                          <i class="bi bi-arrow-right-short text-primary me-2"></i>
                          <span>Plagiarism or unauthorized collaboration</span>
                        </div>
                        <div class="d-flex align-items-center mb-2">
                          <i class="bi bi-arrow-right-short text-primary me-2"></i>
                          <span>Incorrect file format or corrupted files</span>
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
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
      document.addEventListener('DOMContentLoaded', function() {
        // Search functionality
        const searchInput = document.getElementById('assignmentSearch');
        if (searchInput) {
          searchInput.addEventListener('keyup', function() {
            const searchTerm = this.value.toLowerCase();
            const assignmentItems = document.querySelectorAll('.assignment-item');
            
            assignmentItems.forEach(item => {
              const title = item.querySelector('h5').textContent.toLowerCase();
              const description = item.querySelector('.assignment-description').textContent.toLowerCase();
              const courseName = item.querySelector('.text-muted.small').textContent.toLowerCase();
              
              if (title.includes(searchTerm) || description.includes(searchTerm) || courseName.includes(searchTerm)) {
                item.style.display = 'block';
              } else {
                item.style.display = 'none';
              }
            });
          });
        }
        
        // Add animation to cards
        const cards = document.querySelectorAll('.assignment-card, .content-card');
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
