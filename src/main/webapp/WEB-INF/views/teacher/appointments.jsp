<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Teacher Appointments - School Management System</title>
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
    <!-- DataTables CSS -->
    <link
      rel="stylesheet"
      href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css"
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
        .appointment-card {
            border-radius: 12px;
            transition: all 0.3s ease;
            border: none;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.08);
        }
        
        .appointment-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 1rem 2rem rgba(0, 0, 0, 0.12);
        }
        
        .appointment-header {
            border-radius: 12px 12px 0 0;
            padding: 15px 20px;
        }
        
        .status-badge {
            font-size: 0.8rem;
            padding: 0.35em 0.65em;
            border-radius: 50rem;
        }
        
        .btn-icon {
            width: 38px;
            height: 38px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            margin-right: 0.5rem;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Include Teacher Sidebar -->
            <jsp:include page="/WEB-INF/includes/teacher-sidebar.jsp" />

            <!-- Main content -->
            <div class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <!-- Breadcrumb -->
                <nav aria-label="breadcrumb" class="mt-3">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/teacher/dashboard">Dashboard</a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page">
                            Appointments
                        </li>
                    </ol>
                </nav>

                <div class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center">
                    <h1 class="page-title">My Appointments</h1>
                    <div class="btn-toolbar">
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#newAppointmentModal">
                            <i class="bi bi-plus-circle me-2"></i> Schedule Appointment
                        </button>
                    </div>
                </div>

                <!-- Success/Error messages -->
                <c:if test="${not empty param.success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>
                        <c:choose>
                            <c:when test="${param.success eq 'created'}">Appointment has been successfully scheduled!</c:when>
                            <c:when test="${param.success eq 'updated'}">Appointment status has been updated!</c:when>
                            <c:otherwise>Operation completed successfully!</c:otherwise>
                        </c:choose>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Filter options -->
                <div class="row mb-4">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-4 mb-3 mb-md-0">
                                        <label for="filterStatus" class="form-label">Filter by Status</label>
                                        <select id="filterStatus" class="form-select">
                                            <option value="all">All Statuses</option>
                                            <option value="pending">Pending</option>
                                            <option value="confirmed">Confirmed</option>
                                            <option value="cancelled">Cancelled</option>
                                            <option value="completed">Completed</option>
                                        </select>
                                    </div>
                                    <div class="col-md-4 mb-3 mb-md-0">
                                        <label for="filterDate" class="form-label">Filter by Date</label>
                                        <select id="filterDate" class="form-select">
                                            <option value="all">All Dates</option>
                                            <option value="today">Today</option>
                                            <option value="tomorrow">Tomorrow</option>
                                            <option value="thisWeek">This Week</option>
                                            <option value="nextWeek">Next Week</option>
                                            <option value="thisMonth">This Month</option>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <label for="searchAppointment" class="form-label">Search</label>
                                        <input type="text" id="searchAppointment" class="form-control" placeholder="Search appointments...">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Appointments List -->
                <div class="row" id="appointmentsList">
                    <c:set var="foundAppointments" value="false" />
                    <c:forEach items="${appointments}" var="appointment">
                        <c:if test="${appointment.teacherId == teacherId || appointment.staffId == teacherId && appointment.staffType == 'teacher'}">
                            <c:set var="foundAppointments" value="true" />
                            <div class="col-md-6 col-lg-4 mb-4">
                                <div class="card appointment-card">
                                    <div class="appointment-header bg-${appointment.status eq 'pending' ? 'warning' : 
                                                                appointment.status eq 'confirmed' ? 'primary' : 
                                                                appointment.status eq 'completed' ? 'success' : 
                                                                appointment.status eq 'cancelled' ? 'danger' : 'secondary'} 
                                                                bg-opacity-25">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <h5 class="mb-0 text-${appointment.status eq 'pending' ? 'warning' : 
                                                                appointment.status eq 'confirmed' ? 'primary' : 
                                                                appointment.status eq 'completed' ? 'success' : 
                                                                appointment.status eq 'cancelled' ? 'danger' : 'secondary'}">
                                                ${appointment.title != null ? appointment.title : appointment.purpose}
                                            </h5>
                                            <span class="status-badge bg-${appointment.status eq 'pending' ? 'warning' : 
                                                                appointment.status eq 'confirmed' ? 'primary' : 
                                                                appointment.status eq 'completed' ? 'success' : 
                                                                appointment.status eq 'cancelled' ? 'danger' : 'secondary'}">
                                                ${appointment.status}
                                            </span>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <p class="text-muted mb-3">
                                            <i class="bi bi-calendar-event me-2"></i>
                                            <fmt:formatDate value="${appointment.appointmentDate}" pattern="EEE, MMM d, yyyy" />
                                            <br/>
                                            <i class="bi bi-clock me-2"></i>
                                            <fmt:formatDate value="${appointment.appointmentTime != null ? appointment.appointmentTime : appointment.appointmentDate}" pattern="h:mm a" />
                                        </p>
                                        
                                        <div class="mb-3">
                                            <strong>Student: </strong>
                                            <span>${appointment.studentName}</span>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <strong>Parent: </strong>
                                            <span>${appointment.parentName}</span>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <strong>Purpose: </strong>
                                            <p>${appointment.description != null ? appointment.description : appointment.purpose}</p>
                                        </div>
                                        
                                        <c:if test="${not empty appointment.notes}">
                                            <div class="mb-3">
                                                <strong>Notes: </strong>
                                                <p>${appointment.notes}</p>
                                            </div>
                                        </c:if>
                                        
                                        <!-- Update status buttons -->
                                        <div class="d-flex mt-4">
                                            <form action="${pageContext.request.contextPath}/teacher/appointments" method="post" class="me-2">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="appointmentId" value="${appointment.appointmentId != null ? appointment.appointmentId : appointment.id}">
                                                <input type="hidden" name="status" value="confirmed">
                                                <button type="submit" class="btn btn-outline-primary btn-sm" ${appointment.status eq 'confirmed' || appointment.status eq 'completed' || appointment.status eq 'cancelled' ? 'disabled' : ''}>
                                                    <i class="bi bi-check-circle me-1"></i> Confirm
                                                </button>
                                            </form>
                                            
                                            <form action="${pageContext.request.contextPath}/teacher/appointments" method="post" class="me-2">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="appointmentId" value="${appointment.appointmentId != null ? appointment.appointmentId : appointment.id}">
                                                <input type="hidden" name="status" value="completed">
                                                <button type="submit" class="btn btn-outline-success btn-sm" ${appointment.status eq 'completed' || appointment.status eq 'cancelled' ? 'disabled' : ''}>
                                                    <i class="bi bi-check-all me-1"></i> Complete
                                                </button>
                                            </form>
                                            
                                            <form action="${pageContext.request.contextPath}/teacher/appointments" method="post">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="appointmentId" value="${appointment.appointmentId != null ? appointment.appointmentId : appointment.id}">
                                                <input type="hidden" name="status" value="cancelled">
                                                <button type="submit" class="btn btn-outline-danger btn-sm" ${appointment.status eq 'completed' || appointment.status eq 'cancelled' ? 'disabled' : ''}>
                                                    <i class="bi bi-x-circle me-1"></i> Cancel
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                    
                    <!-- No Appointments Message -->
                    <c:if test="${!foundAppointments}">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-body text-center py-5">
                                    <i class="bi bi-calendar-x text-muted" style="font-size: 3rem;"></i>
                                    <h4 class="mt-3 text-muted">No Appointments Found</h4>
                                    <p class="text-muted">You don't have any appointments scheduled.</p>
                                    <button class="btn btn-primary mt-3" data-bs-toggle="modal" data-bs-target="#newAppointmentModal">
                                        <i class="bi bi-plus-circle me-2"></i> Schedule New Appointment
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- New Appointment Modal -->
                <div class="modal fade" id="newAppointmentModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Schedule New Appointment</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <form action="${pageContext.request.contextPath}/teacher/appointments" method="post">
                                <input type="hidden" name="action" value="create">
                                <div class="modal-body">
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="appointmentDate" class="form-label">Date</label>
                                            <input type="date" class="form-control" id="appointmentDate" name="appointmentDate" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="appointmentTime" class="form-label">Time</label>
                                            <input type="time" class="form-control" id="appointmentTime" name="appointmentTime" required>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="purpose" class="form-label">Purpose</label>
                                        <input type="text" class="form-control" id="purpose" name="purpose" placeholder="Brief description of appointment purpose" required>
                                    </div>
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="studentId" class="form-label">Student</label>
                                            <select class="form-select" id="studentId" name="studentId" required>
                                                <option value="">Select Student</option>
                                                <!-- This would ideally be populated from the database -->
                                                <c:forEach items="${students}" var="student">
                                                    <option value="${student.id}">${student.firstName} ${student.lastName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="parentId" class="form-label">Parent</label>
                                            <select class="form-select" id="parentId" name="parentId" required>
                                                <option value="">Select Parent</option>
                                                <!-- This would ideally be populated from the database -->
                                                <c:forEach items="${parents}" var="parent">
                                                    <option value="${parent.id}">${parent.firstName} ${parent.lastName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="notes" class="form-label">Notes (Optional)</label>
                                        <textarea class="form-control" id="notes" name="notes" rows="3"></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                    <button type="submit" class="btn btn-primary">Schedule Appointment</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Custom JS -->
    <script>
        $(document).ready(function() {
            // Filter functionality
            $("#filterStatus, #filterDate").on("change", filterAppointments);
            $("#searchAppointment").on("keyup", filterAppointments);
            
            function filterAppointments() {
                var statusFilter = $("#filterStatus").val();
                var dateFilter = $("#filterDate").val();
                var searchText = $("#searchAppointment").val().toLowerCase();
                
                $("#appointmentsList .appointment-card").parent().each(function() {
                    var card = $(this);
                    var status = card.find(".status-badge").text().trim().toLowerCase();
                    var title = card.find(".appointment-header h5").text().trim().toLowerCase();
                    var date = card.find(".card-body p:first").text().trim().toLowerCase();
                    var student = card.find(".card-body div:contains('Student:')").text().trim().toLowerCase();
                    var parent = card.find(".card-body div:contains('Parent:')").text().trim().toLowerCase();
                    var purpose = card.find(".card-body div:contains('Purpose:')").text().trim().toLowerCase();
                    
                    var statusMatch = statusFilter === "all" || status === statusFilter;
                    var dateMatch = true; // Would need additional logic for date filtering
                    var searchMatch = !searchText || 
                                     title.includes(searchText) || 
                                     student.includes(searchText) || 
                                     parent.includes(searchText) || 
                                     purpose.includes(searchText);
                    
                    if (statusMatch && dateMatch && searchMatch) {
                        card.show();
                    } else {
                        card.hide();
                    }
                });
            }
        });
    </script>
</body>
</html> 