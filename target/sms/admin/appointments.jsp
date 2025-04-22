<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments - School Management System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .sidebar {
            min-height: 100vh;
            background-color: #343a40;
            color: #fff;
            padding-top: 20px;
        }
        .sidebar-heading {
            padding: 15px;
            font-size: 1.2rem;
            text-align: center;
            border-bottom: 1px solid #495057;
        }
        .sidebar-menu {
            padding: 0;
            list-style: none;
        }
        .sidebar-menu li {
            margin: 0;
            padding: 0;
        }
        .sidebar-menu li a {
            display: block;
            padding: 15px;
            color: #adb5bd;
            text-decoration: none;
            transition: all 0.3s;
        }
        .sidebar-menu li a:hover, .sidebar-menu li a.active {
            background-color: #495057;
            color: #fff;
        }
        .sidebar-menu li a i {
            margin-right: 10px;
        }
        .main-content {
            padding: 20px;
        }
        .table-responsive {
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 5px;
            background-color: #fff;
        }
        .status-scheduled {
            background-color: #ffc107;
            color: #212529;
        }
        .status-completed {
            background-color: #28a745;
            color: #fff;
        }
        .status-cancelled {
            background-color: #dc3545;
            color: #fff;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/includes/admin-sidebar.jsp">
                <jsp:param name="active" value="appointments"/>
            </jsp:include>
            
            <!-- Main Content -->
            <div class="col-md-10 main-content">
                <div class="row mb-4">
                    <div class="col-md-8">
                        <h2>Appointments</h2>
                        <p>Manage school appointments and requests.</p>
                    </div>
                    <div class="col-md-4 text-right">
                        <a href="${pageContext.request.contextPath}/admin/appointments/new" class="btn btn-primary">
                            <i class="fas fa-plus-circle"></i> New Appointment
                        </a>
                    </div>
                </div>
                
                <!-- Appointment Status Filter -->
                <div class="row mb-4">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Filter Appointments</h5>
                                <div class="btn-group" role="group">
                                    <button type="button" class="btn btn-outline-primary active" data-filter="all">All</button>
                                    <button type="button" class="btn btn-outline-warning" data-filter="Scheduled">Scheduled</button>
                                    <button type="button" class="btn btn-outline-success" data-filter="Completed">Completed</button>
                                    <button type="button" class="btn btn-outline-danger" data-filter="Cancelled">Cancelled</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Appointments Table -->
                <div class="row">
                    <div class="col-md-12">
                        <div class="table-responsive">
                            <table class="table table-striped appointment-table">
                                <thead class="thead-dark">
                                    <tr>
                                        <th>Date & Time</th>
                                        <th>Purpose</th>
                                        <th>Requested By</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty appointments}">
                                            <tr>
                                                <td colspan="5" class="text-center">No appointments found</td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="appointment" items="${appointments}">
                                                <tr data-status="${appointment.status}">
                                                    <td><fmt:formatDate value="${appointment.date}" pattern="MMM d, yyyy h:mm a" /></td>
                                                    <td>${appointment.purpose}</td>
                                                    <td>${appointment.responsibleName}</td>
                                                    <td>
                                                        <span class="badge 
                                                            <c:choose>
                                                                <c:when test="${appointment.status eq 'Scheduled'}">status-scheduled</c:when>
                                                                <c:when test="${appointment.status eq 'Completed'}">status-completed</c:when>
                                                                <c:when test="${appointment.status eq 'Cancelled'}">status-cancelled</c:when>
                                                            </c:choose>">
                                                            ${appointment.status}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/admin/appointments/view/${appointment.id}" class="btn btn-sm btn-info">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        
                                                        <!-- Dropdown for status update -->
                                                        <div class="btn-group">
                                                            <button type="button" class="btn btn-sm btn-secondary dropdown-toggle" data-toggle="dropdown">
                                                                <i class="fas fa-edit"></i>
                                                            </button>
                                                            <div class="dropdown-menu">
                                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/appointments/update/${appointment.id}?status=Scheduled">
                                                                    <i class="fas fa-clock text-warning"></i> Mark as Scheduled
                                                                </a>
                                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/appointments/update/${appointment.id}?status=Completed">
                                                                    <i class="fas fa-check text-success"></i> Mark as Completed
                                                                </a>
                                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/appointments/update/${appointment.id}?status=Cancelled">
                                                                    <i class="fas fa-times text-danger"></i> Mark as Cancelled
                                                                </a>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Filter appointments by status
            $('button[data-filter]').click(function() {
                $(this).addClass('active').siblings().removeClass('active');
                var filter = $(this).data('filter');
                
                if (filter === 'all') {
                    $('.appointment-table tbody tr').show();
                } else {
                    $('.appointment-table tbody tr').hide();
                    $('.appointment-table tbody tr[data-status="' + filter + '"]').show();
                }
            });
        });
    </script>
</body>
</html> 