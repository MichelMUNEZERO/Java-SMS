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
    <!-- Custom CSS -->
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />
    <style>
      .assignment-card {
        transition: transform 0.3s;
        border-radius: 10px;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        margin-bottom: 20px;
      }
      .assignment-card:hover {
        transform: translateY(-5px);
      }
      .assignment-header {
        border-bottom: 1px solid rgba(0, 0, 0, 0.1);
        padding-bottom: 10px;
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
      .nav-pills .nav-link.active {
        background-color: #0d6efd;
      }
      .nav-pills .nav-link {
        color: #495057;
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
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/student/courses"
                >
                  <i class="bi bi-book me-2"></i> My Courses
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
                  href="${pageContext.request.contextPath}/student/grades"
                >
                  <i class="bi bi-card-checklist me-2"></i> Grades
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link active text-white"
                  href="${pageContext.request.contextPath}/student/assignments"
                >
                  <i class="bi bi-file-earmark-text me-2"></i> Assignments
                </a>
              </li>
              <li class="nav-item">
                <a
                  class="nav-link text-white"
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
            <h1 class="h2">My Assignments</h1>
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

          <!-- Assignment Tabs -->
          <ul class="nav nav-pills mb-4" id="assignmentTabs" role="tablist">
            <li class="nav-item" role="presentation">
              <button
                class="nav-link active"
                id="pending-tab"
                data-bs-toggle="pill"
                data-bs-target="#pending"
                type="button"
                role="tab"
                aria-controls="pending"
                aria-selected="true"
              >
                <i class="bi bi-hourglass-split me-1"></i> Pending
                <c:if test="${not empty pendingAssignments}">
                  <span class="badge bg-danger"
                    >${pendingAssignments.size()}</span
                  >
                </c:if>
              </button>
            </li>
            <li class="nav-item" role="presentation">
              <button
                class="nav-link"
                id="upcoming-tab"
                data-bs-toggle="pill"
                data-bs-target="#upcoming"
                type="button"
                role="tab"
                aria-controls="upcoming"
                aria-selected="false"
              >
                <i class="bi bi-calendar-date me-1"></i> Upcoming
                <c:if test="${not empty upcomingAssignments}">
                  <span class="badge bg-info"
                    >${upcomingAssignments.size()}</span
                  >
                </c:if>
              </button>
            </li>
            <li class="nav-item" role="presentation">
              <button
                class="nav-link"
                id="completed-tab"
                data-bs-toggle="pill"
                data-bs-target="#completed"
                type="button"
                role="tab"
                aria-controls="completed"
                aria-selected="false"
              >
                <i class="bi bi-check-circle me-1"></i> Completed
                <c:if test="${not empty completedAssignments}">
                  <span class="badge bg-success"
                    >${completedAssignments.size()}</span
                  >
                </c:if>
              </button>
            </li>
          </ul>

          <div class="tab-content" id="assignmentTabsContent">
            <!-- Pending Assignments -->
            <div
              class="tab-pane fade show active"
              id="pending"
              role="tabpanel"
              aria-labelledby="pending-tab"
            >
              <div class="row">
                <c:choose>
                  <c:when test="${empty pendingAssignments}">
                    <div class="col-12">
                      <div class="alert alert-info" role="alert">
                        <i class="bi bi-info-circle me-2"></i> You have no
                        pending assignments.
                      </div>
                    </div>
                  </c:when>
                  <c:otherwise>
                    <c:forEach
                      var="assignment"
                      items="${pendingAssignments}"
                      varStatus="loop"
                    >
                      <div class="col-md-6">
                        <div class="card assignment-card">
                          <div class="card-body">
                            <div
                              class="assignment-header d-flex justify-content-between align-items-start"
                            >
                              <div>
                                <span class="badge bg-primary mb-1"
                                  >${assignment.courseCode}</span
                                >
                                <h5 class="card-title">${assignment.title}</h5>
                              </div>
                              <div class="text-end">
                                <div class="time-remaining text-danger">
                                  <i class="bi bi-alarm"></i>
                                  <fmt:formatDate
                                    value="${assignment.dueDate}"
                                    pattern="MMM dd, yyyy"
                                  />
                                </div>
                                <div>
                                  <small class="text-muted"
                                    >Max Score: ${assignment.maxScore}</small
                                  >
                                </div>
                              </div>
                            </div>
                            <p class="card-text">${assignment.description}</p>
                            <div
                              class="d-flex justify-content-between align-items-center"
                            >
                              <span class="text-muted"
                                >${assignment.courseName}</span
                              >
                              <a
                                href="${pageContext.request.contextPath}/student/submission?id=${assignment.id}"
                                class="btn btn-primary btn-sm"
                              >
                                <i class="bi bi-upload me-1"></i> Submit
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
            <div
              class="tab-pane fade"
              id="upcoming"
              role="tabpanel"
              aria-labelledby="upcoming-tab"
            >
              <div class="row">
                <c:choose>
                  <c:when test="${empty upcomingAssignments}">
                    <div class="col-12">
                      <div class="alert alert-info" role="alert">
                        <i class="bi bi-info-circle me-2"></i> You have no
                        upcoming assignments.
                      </div>
                    </div>
                  </c:when>
                  <c:otherwise>
                    <c:forEach
                      var="assignment"
                      items="${upcomingAssignments}"
                      varStatus="loop"
                    >
                      <div class="col-md-6">
                        <div class="card assignment-card">
                          <div class="card-body">
                            <div
                              class="assignment-header d-flex justify-content-between align-items-start"
                            >
                              <div>
                                <span class="badge bg-primary mb-1"
                                  >${assignment.courseCode}</span
                                >
                                <h5 class="card-title">${assignment.title}</h5>
                              </div>
                              <div class="text-end">
                                <div class="time-remaining text-info">
                                  <i class="bi bi-calendar"></i>
                                  <fmt:formatDate
                                    value="${assignment.dueDate}"
                                    pattern="MMM dd, yyyy"
                                  />
                                </div>
                                <div>
                                  <small class="text-muted"
                                    >Max Score: ${assignment.maxScore}</small
                                  >
                                </div>
                              </div>
                            </div>
                            <p class="card-text">${assignment.description}</p>
                            <div
                              class="d-flex justify-content-between align-items-center"
                            >
                              <span class="text-muted"
                                >${assignment.courseName}</span
                              >
                              <button
                                type="button"
                                class="btn btn-outline-secondary btn-sm"
                                disabled
                              >
                                <i class="bi bi-clock-history me-1"></i> Coming
                                Soon
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
            <div
              class="tab-pane fade"
              id="completed"
              role="tabpanel"
              aria-labelledby="completed-tab"
            >
              <div class="row">
                <c:choose>
                  <c:when test="${empty completedAssignments}">
                    <div class="col-12">
                      <div class="alert alert-info" role="alert">
                        <i class="bi bi-info-circle me-2"></i> You have no
                        completed assignments.
                      </div>
                    </div>
                  </c:when>
                  <c:otherwise>
                    <c:forEach
                      var="assignment"
                      items="${completedAssignments}"
                      varStatus="loop"
                    >
                      <div class="col-md-6">
                        <div class="card assignment-card">
                          <div class="card-body">
                            <div
                              class="assignment-header d-flex justify-content-between align-items-start"
                            >
                              <div>
                                <span class="badge bg-primary mb-1"
                                  >${assignment.courseCode}</span
                                >
                                <h5 class="card-title">${assignment.title}</h5>
                              </div>
                              <div class="text-end">
                                <div class="text-success">
                                  <i class="bi bi-check-circle"></i> Completed
                                </div>
                                <div>
                                  <small class="text-muted"
                                    >Submitted:
                                    <fmt:formatDate
                                      value="${assignment.submissionDate}"
                                      pattern="MMM dd, yyyy"
                                  /></small>
                                </div>
                              </div>
                            </div>
                            <p class="card-text">${assignment.description}</p>
                            <div
                              class="d-flex justify-content-between align-items-center"
                            >
                              <span class="text-muted"
                                >${assignment.courseName}</span
                              >
                              <div>
                                <c:choose>
                                  <c:when test="${assignment.score > 0}">
                                    <span class="text-success me-2">
                                      <i class="bi bi-award"></i> Score:
                                      ${assignment.score}/${assignment.maxScore}
                                      (${assignment.percentage}%)
                                    </span>
                                  </c:when>
                                  <c:otherwise>
                                    <span class="text-warning me-2">
                                      <i class="bi bi-hourglass-split"></i>
                                      Awaiting Grading
                                    </span>
                                  </c:otherwise>
                                </c:choose>
                                <a
                                  href="${pageContext.request.contextPath}/student/submission?id=${assignment.id}"
                                  class="btn btn-outline-primary btn-sm"
                                >
                                  <i class="bi bi-eye me-1"></i> View
                                </a>
                              </div>
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
              <div class="card">
                <div class="card-header bg-info text-white">
                  <h5 class="card-title mb-0">
                    <i class="bi bi-lightbulb me-2"></i> Assignment Tips
                  </h5>
                </div>
                <div class="card-body">
                  <div class="row">
                    <div class="col-md-6">
                      <h6>
                        <i class="bi bi-check-circle-fill text-success me-2"></i
                        >Submission Guidelines
                      </h6>
                      <ul>
                        <li>Always submit assignments before the due date</li>
                        <li>
                          Follow the file format requirements specified in the
                          assignment
                        </li>
                        <li>
                          Ensure your name and student ID are included in your
                          submissions
                        </li>
                        <li>Double-check your work before submitting</li>
                      </ul>
                    </div>
                    <div class="col-md-6">
                      <h6>
                        <i
                          class="bi bi-exclamation-triangle-fill text-warning me-2"
                        ></i
                        >Common Mistakes to Avoid
                      </h6>
                      <ul>
                        <li>Missing the submission deadline</li>
                        <li>Not answering all questions or requirements</li>
                        <li>Plagiarism or unauthorized collaboration</li>
                        <li>Incorrect file format or corrupted files</li>
                      </ul>
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
  </body>
</html>
