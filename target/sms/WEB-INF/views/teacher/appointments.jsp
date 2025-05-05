<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Teacher Appointments</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container mt-4">
        <h1>My Appointments</h1>
        
        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        
        <!-- New Appointment Button -->
        <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#newAppointmentModal">
            Schedule New Appointment
        </button>
        
        <!-- Appointments List -->
        <div class="appointments-list">
            <c:forEach items="${appointments}" var="appointment">
                <div class="card mb-3">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">${appointment.title}</h5>
                        <span class="badge ${appointment.status == 'Scheduled' ? 'bg-primary' : 
                                           appointment.status == 'Completed' ? 'bg-success' : 
                                           appointment.status == 'Cancelled' ? 'bg-danger' : 'bg-secondary'}">
                            ${appointment.status}
                        </span>
                    </div>
                    <div class="card-body">
                        <p class="card-text">${appointment.description}</p>
                        <p class="card-text">
                            <strong>Date:</strong> 
                            <fmt:formatDate value="${appointment.appointmentDate}" pattern="yyyy-MM-dd HH:mm" />
                        </p>
                        
                        <!-- Status Update Form -->
                        <form action="${pageContext.request.contextPath}/teacher/appointments" method="post" class="mt-3">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                            <div class="btn-group">
                                <button type="submit" name="status" value="Scheduled" class="btn btn-sm btn-outline-primary">Scheduled</button>
                                <button type="submit" name="status" value="Completed" class="btn btn-sm btn-outline-success">Completed</button>
                                <button type="submit" name="status" value="Cancelled" class="btn btn-sm btn-outline-danger">Cancelled</button>
                            </div>
                        </form>
                    </div>
                </div>
            </c:forEach>
            
            <!-- No Appointments Message -->
            <c:if test="${empty appointments}">
                <div class="alert alert-info">
                    No appointments scheduled.
                </div>
            </c:if>
        </div>
        
        <!-- New Appointment Modal -->
        <div class="modal fade" id="newAppointmentModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Schedule New Appointment</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/teacher/appointments" method="post">
                        <input type="hidden" name="action" value="create">
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="title" class="form-label">Title</label>
                                <input type="text" class="form-control" id="title" name="title" required>
                            </div>
                            <div class="mb-3">
                                <label for="description" class="form-label">Description</label>
                                <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                            </div>
                            <div class="mb-3">
                                <label for="appointmentDate" class="form-label">Date and Time</label>
                                <input type="datetime-local" class="form-control" id="appointmentDate" name="appointmentDate" required>
                            </div>
                            <div class="mb-3">
                                <label for="studentId" class="form-label">Student ID</label>
                                <input type="number" class="form-control" id="studentId" name="studentId" required>
                            </div>
                            <div class="mb-3">
                                <label for="parentId" class="form-label">Parent ID</label>
                                <input type="number" class="form-control" id="parentId" name="parentId" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <button type="submit" class="btn btn-primary">Schedule Appointment</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 