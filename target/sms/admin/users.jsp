<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - School Management System</title>
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
        .table-img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }
        .action-btns a {
            margin-right: 5px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 sidebar">
                <div class="sidebar-heading">
                    <i class="fas fa-school"></i> SMS Admin
                </div>
                <ul class="sidebar-menu">
                    <li><a href="dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="users.jsp" class="active"><i class="fas fa-users"></i> Users</a></li>
                    <li><a href="teachers.jsp"><i class="fas fa-chalkboard-teacher"></i> Teachers</a></li>
                    <li><a href="students.jsp"><i class="fas fa-user-graduate"></i> Students</a></li>
                    <li><a href="parents.jsp"><i class="fas fa-user-friends"></i> Parents</a></li>
                    <li><a href="courses.jsp"><i class="fas fa-book"></i> Courses</a></li>
                    <li><a href="announcements.jsp"><i class="fas fa-bullhorn"></i> Announcements</a></li>
                    <li><a href="reports.jsp"><i class="fas fa-chart-bar"></i> Reports</a></li>
                    <li><a href="../logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                </ul>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 main-content">
                <div class="row mb-4">
                    <div class="col-md-8">
                        <h2>User Management</h2>
                        <p>Manage all users in the system.</p>
                    </div>
                    <div class="col-md-4 text-right">
                        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#addUserModal">
                            <i class="fas fa-plus"></i> Add New User
                        </button>
                    </div>
                </div>
                
                <!-- Success or Error Messages -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${successMessage}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </c:if>
                
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${errorMessage}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </c:if>
                
                <!-- Users Table -->
                <div class="card">
                    <div class="card-header">
                        <div class="row">
                            <div class="col-md-6">
                                <h5>All Users</h5>
                            </div>
                            <div class="col-md-6">
                                <input type="text" class="form-control" id="searchInput" placeholder="Search users...">
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover" id="usersTable">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Profile</th>
                                        <th>Username</th>
                                        <th>User Type</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Placeholder data - would be populated by UserServlet in a real implementation -->
                                    <tr>
                                        <td>1</td>
                                        <td><img src="../images/default-user.png" alt="Profile" class="table-img"></td>
                                        <td>admin</td>
                                        <td><span class="badge badge-primary">Admin</span></td>
                                        <td class="action-btns">
                                            <a href="#" class="btn btn-sm btn-info" data-toggle="modal" data-target="#editUserModal">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="#" class="btn btn-sm btn-danger" data-toggle="modal" data-target="#deleteUserModal">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>2</td>
                                        <td><img src="../images/default-user.png" alt="Profile" class="table-img"></td>
                                        <td>teacher1</td>
                                        <td><span class="badge badge-warning">Teacher</span></td>
                                        <td class="action-btns">
                                            <a href="#" class="btn btn-sm btn-info" data-toggle="modal" data-target="#editUserModal">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="#" class="btn btn-sm btn-danger" data-toggle="modal" data-target="#deleteUserModal">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>3</td>
                                        <td><img src="../images/default-user.png" alt="Profile" class="table-img"></td>
                                        <td>student1</td>
                                        <td><span class="badge badge-success">Student</span></td>
                                        <td class="action-btns">
                                            <a href="#" class="btn btn-sm btn-info" data-toggle="modal" data-target="#editUserModal">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="#" class="btn btn-sm btn-danger" data-toggle="modal" data-target="#deleteUserModal">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>4</td>
                                        <td><img src="../images/default-user.png" alt="Profile" class="table-img"></td>
                                        <td>parent1</td>
                                        <td><span class="badge badge-danger">Parent</span></td>
                                        <td class="action-btns">
                                            <a href="#" class="btn btn-sm btn-info" data-toggle="modal" data-target="#editUserModal">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="#" class="btn btn-sm btn-danger" data-toggle="modal" data-target="#deleteUserModal">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Add User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1" role="dialog" aria-labelledby="addUserModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addUserModalLabel">Add New User</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <form action="../admin/UserServlet" method="post" enctype="multipart/form-data">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="form-group">
                            <label for="username">Username</label>
                            <input type="text" class="form-control" id="username" name="username" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="userType">User Type</label>
                            <select class="form-control" id="userType" name="userType" required>
                                <option value="">Select user type</option>
                                <option value="Admin">Admin</option>
                                <option value="Teacher">Teacher</option>
                                <option value="Student">Student</option>
                                <option value="Parent">Parent</option>
                                <option value="Staff">Staff</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="profileImage">Profile Image</label>
                            <input type="file" class="form-control-file" id="profileImage" name="profileImage" accept="image/*">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add User</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Edit User Modal -->
    <div class="modal fade" id="editUserModal" tabindex="-1" role="dialog" aria-labelledby="editUserModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editUserModalLabel">Edit User</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <form action="../admin/UserServlet" method="post" enctype="multipart/form-data">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="userId" id="editUserId" value="">
                        
                        <div class="form-group">
                            <label for="editUsername">Username</label>
                            <input type="text" class="form-control" id="editUsername" name="username" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="editPassword">Password (leave blank to keep current)</label>
                            <input type="password" class="form-control" id="editPassword" name="password">
                        </div>
                        
                        <div class="form-group">
                            <label for="editUserType">User Type</label>
                            <select class="form-control" id="editUserType" name="userType" required>
                                <option value="Admin">Admin</option>
                                <option value="Teacher">Teacher</option>
                                <option value="Student">Student</option>
                                <option value="Parent">Parent</option>
                                <option value="Staff">Staff</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="editProfileImage">Profile Image</label>
                            <input type="file" class="form-control-file" id="editProfileImage" name="profileImage" accept="image/*">
                            <small class="form-text text-muted">Leave blank to keep current image</small>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update User</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Delete User Modal -->
    <div class="modal fade" id="deleteUserModal" tabindex="-1" role="dialog" aria-labelledby="deleteUserModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteUserModalLabel">Confirm Delete</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this user? This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <form action="../admin/UserServlet" method="post">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="userId" id="deleteUserId" value="">
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        // Search functionality
        $(document).ready(function() {
            $("#searchInput").on("keyup", function() {
                var value = $(this).val().toLowerCase();
                $("#usersTable tbody tr").filter(function() {
                    $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
                });
            });
        });
        
        // Set user ID when delete modal is shown
        $('#deleteUserModal').on('show.bs.modal', function (event) {
            var button = $(event.relatedTarget);
            var userId = button.closest('tr').find('td:first').text();
            $('#deleteUserId').val(userId);
        });
        
        // Set user data when edit modal is shown
        $('#editUserModal').on('show.bs.modal', function (event) {
            var button = $(event.relatedTarget);
            var row = button.closest('tr');
            var userId = row.find('td:eq(0)').text();
            var username = row.find('td:eq(2)').text();
            var userType = row.find('td:eq(3)').text().trim();
            
            $('#editUserId').val(userId);
            $('#editUsername').val(username);
            $('#editUserType').val(userType);
        });
    </script>
</body>
</html> 