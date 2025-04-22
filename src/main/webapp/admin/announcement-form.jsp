<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${announcement == null ? "Create" : "Edit"} Announcement - School Management System</title>
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
        .card {
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/includes/admin-sidebar.jsp">
                <jsp:param name="active" value="announcements"/>
            </jsp:include>
            
            <!-- Main Content -->
            <div class="col-md-10 main-content">
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h2>${announcement == null ? "Create New" : "Edit"} Announcement</h2>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/announcements">Announcements</a></li>
                                <li class="breadcrumb-item active">${announcement == null ? "Create" : "Edit"}</li>
                            </ol>
                        </nav>
                    </div>
                </div>
                
                <!-- Announcement Form -->
                <div class="row">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/admin/announcements" method="post">
                                    <input type="hidden" name="action" value="${announcement == null ? 'create' : 'update'}">
                                    <c:if test="${announcement != null}">
                                        <input type="hidden" name="id" value="${announcement.announcementId}">
                                    </c:if>
                                    
                                    <div class="form-group">
                                        <label for="targetGroup">Target Group</label>
                                        <select class="form-control" id="targetGroup" name="targetGroup" required>
                                            <option value="">-- Select Target Group --</option>
                                            <option value="All" ${announcement != null && announcement.targetGroup == 'All' ? 'selected' : ''}>All</option>
                                            <option value="Teachers" ${announcement != null && announcement.targetGroup == 'Teachers' ? 'selected' : ''}>Teachers</option>
                                            <option value="Students" ${announcement != null && announcement.targetGroup == 'Students' ? 'selected' : ''}>Students</option>
                                            <option value="Parents" ${announcement != null && announcement.targetGroup == 'Parents' ? 'selected' : ''}>Parents</option>
                                        </select>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="message">Announcement Message</label>
                                        <textarea class="form-control" id="message" name="message" rows="6" required>${announcement != null ? announcement.message : ''}</textarea>
                                    </div>
                                    
                                    <div class="form-group">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save"></i> ${announcement == null ? 'Create' : 'Update'} Announcement
                                        </button>
                                        <a href="${pageContext.request.contextPath}/admin/announcements" class="btn btn-secondary">
                                            <i class="fas fa-times"></i> Cancel
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html> 