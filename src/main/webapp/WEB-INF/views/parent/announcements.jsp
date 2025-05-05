<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Announcements - School Management System</title>
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
      .announcement-card {
        transition: transform 0.2s;
        border-radius: var(--border-radius);
        border: none;
        box-shadow: var(--card-shadow);
        margin-bottom: 1.5rem;
      }

      .announcement-card:hover {
        transform: translateY(-3px);
        box-shadow: var(--hover-shadow);
      }

      .announcement-date {
        font-size: 0.85rem;
        color: #6c757d;
      }

      .target-badge {
        font-size: 0.75rem;
        padding: 0.25rem 0.5rem;
        border-radius: 15px;
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
        <!-- Include Parent Sidebar -->
        <jsp:include page="/WEB-INF/includes/parent-sidebar.jsp" />

        <!-- Main content -->
        <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
          <!-- Breadcrumb -->
          <nav aria-label="breadcrumb" class="mt-3">
            <ol class="breadcrumb">
              <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/parent/dashboard">Dashboard</a>
              </li>
              <li class="breadcrumb-item active" aria-current="page">
                Announcements
              </li>
            </ol>
          </nav>

          <div class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center">
            <h1 class="page-title">Announcements</h1>
            <div class="btn-toolbar">
              <div class="dropdown">
                <button
                  class="btn btn-outline-secondary dropdown-toggle"
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
                      <c:choose>
                        <c:when test="${user.role eq 'parent'}">
                          <i class="bi bi-people me-1"></i>
                        </c:when>
                        <c:otherwise>
                          <i class="bi bi-person-circle me-1"></i>
                        </c:otherwise>
                      </c:choose>
                    </c:otherwise>
                  </c:choose>
                  ${user.username}
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

          <!-- Announcements Header -->
          <div class="row mb-4">
            <div class="col-md-12">
              <div class="content-card">
                <div class="card-body">
                  <div class="d-flex justify-content-between align-items-center">
                    <div>
                      <h5 class="mb-1">School Announcements</h5>
                      <p class="text-muted mb-0">Stay updated with the latest announcements from the school</p>
                    </div>
                    <div>
                      <div class="dropdown">
                        <button
                          class="btn btn-sm btn-outline-secondary dropdown-toggle"
                          type="button"
                          id="filterDropdown"
                          data-bs-toggle="dropdown"
                          aria-expanded="false"
                        >
                          <i class="bi bi-funnel me-1"></i> Filter
                        </button>
                        <ul class="dropdown-menu" aria-labelledby="filterDropdown">
                          <li><a class="dropdown-item" href="#">All Announcements</a></li>
                          <li><a class="dropdown-item" href="#">School Events</a></li>
                          <li><a class="dropdown-item" href="#">Academic Updates</a></li>
                          <li><a class="dropdown-item" href="#">Extracurricular</a></li>
                        </ul>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Announcements -->
          <div class="row">
            <div class="col-md-12">
              <!-- Announcement Cards -->
              <c:forEach items="${announcements}" var="announcement">
                <div class="announcement-card">
                  <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                      <div>
                        <span class="badge ${announcement.type eq 'URGENT' ? 'bg-danger' : (announcement.type eq 'EVENT' ? 'bg-success' : (announcement.type eq 'ACADEMIC' ? 'bg-primary' : 'bg-info'))} me-2">
                          ${announcement.type}
                        </span>
                        <span class="target-badge bg-light text-dark border">
                          <i class="bi bi-people me-1"></i> ${announcement.targetAudience}
                        </span>
                      </div>
                      <div class="announcement-date">
                        <i class="bi bi-calendar-event me-1"></i> 
                        <fmt:formatDate value="${announcement.createdAt}" pattern="MMMM dd, yyyy" />
                      </div>
                    </div>
                    <h5>${announcement.title}</h5>
                    <p class="text-muted">
                      ${announcement.content}
                    </p>
                    <div class="d-flex justify-content-between align-items-center mt-3">
                      <div>
                        <span class="text-muted small">
                          <i class="bi bi-person-circle me-1"></i> 
                          Posted by: ${announcement.authorName}
                        </span>
                      </div>
                      <c:if test="${not empty announcement.attachment}">
                        <a href="${announcement.attachment}" class="btn btn-sm btn-outline-primary">
                          <i class="bi bi-file-earmark me-1"></i> View Attachment
                        </a>
                      </c:if>
                    </div>
                  </div>
                </div>
              </c:forEach>

              <!-- Sample announcements if the list is empty -->
              <c:if test="${empty announcements}">
                <div class="announcement-card">
                  <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                      <div>
                        <span class="badge bg-danger me-2">URGENT</span>
                        <span class="target-badge bg-light text-dark border">
                          <i class="bi bi-people me-1"></i> All Parents
                        </span>
                      </div>
                      <div class="announcement-date">
                        <i class="bi bi-calendar-event me-1"></i> May 15, 2023
                      </div>
                    </div>
                    <h5>Parent-Teacher Meeting</h5>
                    <p class="text-muted">
                      Dear Parents, the upcoming parent-teacher meeting is scheduled for June 5th. 
                      Please make sure to attend as we will be discussing important academic matters and the progress of your children.
                    </p>
                    <div class="d-flex justify-content-between align-items-center mt-3">
                      <div>
                        <span class="text-muted small">
                          <i class="bi bi-person-circle me-1"></i> 
                          Posted by: Principal Johnson
                        </span>
                      </div>
                      <a href="#" class="btn btn-sm btn-outline-primary">
                        <i class="bi bi-file-earmark me-1"></i> View Details
                      </a>
                    </div>
                  </div>
                </div>

                <div class="announcement-card">
                  <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                      <div>
                        <span class="badge bg-success me-2">EVENT</span>
                        <span class="target-badge bg-light text-dark border">
                          <i class="bi bi-people me-1"></i> All Parents and Students
                        </span>
                      </div>
                      <div class="announcement-date">
                        <i class="bi bi-calendar-event me-1"></i> May 10, 2023
                      </div>
                    </div>
                    <h5>Annual Sports Day</h5>
                    <p class="text-muted">
                      The annual sports day will be held on June 15th. All students are encouraged to participate.
                      Parents are invited to attend and cheer for their children. Various sports competitions will be held.
                    </p>
                    <div class="d-flex justify-content-between align-items-center mt-3">
                      <div>
                        <span class="text-muted small">
                          <i class="bi bi-person-circle me-1"></i> 
                          Posted by: Sports Department
                        </span>
                      </div>
                      <a href="#" class="btn btn-sm btn-outline-primary">
                        <i class="bi bi-file-earmark me-1"></i> View Schedule
                      </a>
                    </div>
                  </div>
                </div>

                <div class="announcement-card">
                  <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                      <div>
                        <span class="badge bg-primary me-2">ACADEMIC</span>
                        <span class="target-badge bg-light text-dark border">
                          <i class="bi bi-people me-1"></i> Parents of Grade 10
                        </span>
                      </div>
                      <div class="announcement-date">
                        <i class="bi bi-calendar-event me-1"></i> May 5, 2023
                      </div>
                    </div>
                    <h5>End of Term Exams Schedule</h5>
                    <p class="text-muted">
                      The end of term exams for grade 10 will start from June 20th. Please ensure your children are well prepared.
                      The detailed schedule has been attached. Contact the respective subject teachers for any clarifications.
                    </p>
                    <div class="d-flex justify-content-between align-items-center mt-3">
                      <div>
                        <span class="text-muted small">
                          <i class="bi bi-person-circle me-1"></i> 
                          Posted by: Academic Department
                        </span>
                      </div>
                      <a href="#" class="btn btn-sm btn-outline-primary">
                        <i class="bi bi-file-earmark me-1"></i> View Schedule
                      </a>
                    </div>
                  </div>
                </div>
              </c:if>

              <!-- Pagination -->
              <nav aria-label="Announcements pagination" class="mt-4">
                <ul class="pagination justify-content-center">
                  <li class="page-item disabled">
                    <a class="page-link" href="#" tabindex="-1" aria-disabled="true">Previous</a>
                  </li>
                  <li class="page-item active" aria-current="page">
                    <a class="page-link" href="#">1</a>
                  </li>
                  <li class="page-item"><a class="page-link" href="#">2</a></li>
                  <li class="page-item"><a class="page-link" href="#">3</a></li>
                  <li class="page-item">
                    <a class="page-link" href="#">Next</a>
                  </li>
                </ul>
              </nav>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html> 