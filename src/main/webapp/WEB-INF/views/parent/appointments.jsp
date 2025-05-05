<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Book Appointments - School Management System</title>
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
      .appointment-card {
        transition: transform 0.2s;
        border-radius: var(--border-radius);
        border: none;
        box-shadow: var(--card-shadow);
        margin-bottom: 1.5rem;
      }

      .appointment-card:hover {
        transform: translateY(-3px);
        box-shadow: var(--hover-shadow);
      }

      .status-badge {
        font-size: 0.75rem;
        padding: 0.25rem 0.5rem;
        border-radius: 15px;
      }

      .time-slot {
        display: inline-block;
        padding: 0.5rem 0.75rem;
        margin: 0.25rem;
        border-radius: var(--border-radius);
        background-color: #f8f9fa;
        border: 1px solid #dee2e6;
        cursor: pointer;
        transition: all 0.2s;
      }

      .time-slot:hover {
        background-color: #e9ecef;
      }

      .time-slot.selected {
        background-color: var(--primary-color);
        color: white;
        border-color: var(--primary-color);
      }

      .time-slot.unavailable {
        background-color: #f8f9fa;
        color: #adb5bd;
        border-color: #dee2e6;
        cursor: not-allowed;
        text-decoration: line-through;
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
                <a href="${pageContext.request.contextPath}/parent/dashboard"
                  >Dashboard</a
                >
              </li>
              <li class="breadcrumb-item active" aria-current="page">
                Book Appointments
              </li>
            </ol>
          </nav>

          <div
            class="page-header d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center"
          >
            <h1 class="page-title">Book Appointments</h1>
            <div class="btn-toolbar">
              <div class="dropdown">
                <button
                  class="btn btn-outline-secondary dropdown-toggle"
                  type="button"
                  id="dropdownMenuLink"
                  data-bs-toggle="dropdown"
                  aria-expanded="false"
                >
                  <i class="bi bi-person-circle me-1"></i> ${user.username}
                </button>
                <ul
                  class="dropdown-menu dropdown-menu-end"
                  aria-labelledby="dropdownMenuLink"
                >
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

          <!-- Status Messages -->
          <c:if test="${not empty sessionScope.successMessage}">
            <div
              class="alert alert-success alert-dismissible fade show"
              role="alert"
            >
              <i class="bi bi-check-circle me-2"></i>
              ${sessionScope.successMessage}
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
                aria-label="Close"
              ></button>
            </div>
            <c:remove var="successMessage" scope="session" />
          </c:if>
          
          <c:if test="${not empty sessionScope.errorMessage}">
            <div
              class="alert alert-danger alert-dismissible fade show"
              role="alert"
            >
              <i class="bi bi-exclamation-triangle me-2"></i>
              ${sessionScope.errorMessage}
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
                aria-label="Close"
              ></button>
            </div>
            <c:remove var="errorMessage" scope="session" />
          </c:if>

          <!-- Book Appointment Form -->
          <div class="row mb-4">
            <div class="col-md-12">
              <div class="content-card">
                <div class="card-header">
                  <h5 class="mb-0">Schedule a New Appointment</h5>
                </div>
                <div class="card-body">
                  <form
                    action="${pageContext.request.contextPath}/parent/appointments"
                    method="post"
                    class="row g-3"
                  >
                    <div class="col-md-6">
                      <label for="staffType" class="form-label"
                        >Staff Type</label
                      >
                      <select
                        id="staffType"
                        name="staffType"
                        class="form-select"
                        required
                        onchange="loadStaffMembers()"
                      >
                        <option value="">Select Staff Type</option>
                        <option value="teacher">Teacher</option>
                        <option value="admin">Administrator</option>
                        <option value="doctor">Doctor</option>
                        <option value="nurse">Nurse</option>
                      </select>
                    </div>
                    
                    <div class="col-md-6">
                      <label for="staffMember" class="form-label"
                        >Staff Member</label
                      >
                      <select
                        id="staffMember"
                        name="staffMember"
                        class="form-select"
                        required
                      >
                        <option value="">Select Staff Member</option>
                      </select>
                    </div>
                    
                    <div class="col-md-6">
                      <label for="appointmentDate" class="form-label"
                        >Date</label
                      >
                      <input
                        type="date"
                        class="form-control"
                        id="appointmentDate"
                        name="appointmentDate"
                        min="${currentDate}"
                        required
                      />
                    </div>

                    <div class="col-md-6">
                      <label for="childSelect" class="form-label"
                        >Select Child</label
                      >
                      <select
                        id="childSelect"
                        name="childId"
                        class="form-select"
                        required
                      >
                        <option value="">Select Child</option>
                        <c:forEach items="${children}" var="child">
                          <option value="${child.id}">
                            ${child.name} (Grade ${child.grade})
                          </option>
                        </c:forEach>
                        <c:if test="${empty children}">
                          <option value="1">Jane Doe (Grade 10)</option>
                          <option value="2">Tom Doe (Grade 8)</option>
                        </c:if>
                      </select>
                    </div>
                    
                    <div class="col-12">
                      <label class="form-label">Available Time Slots</label>
                      <div id="timeSlots" class="d-flex flex-wrap">
                        <div class="time-slot">9:00 AM</div>
                        <div class="time-slot">9:30 AM</div>
                        <div class="time-slot">10:00 AM</div>
                        <div class="time-slot">10:30 AM</div>
                        <div class="time-slot unavailable">11:00 AM</div>
                        <div class="time-slot">11:30 AM</div>
                        <div class="time-slot">12:00 PM</div>
                        <div class="time-slot unavailable">12:30 PM</div>
                        <div class="time-slot">1:00 PM</div>
                        <div class="time-slot">1:30 PM</div>
                        <div class="time-slot">2:00 PM</div>
                        <div class="time-slot">2:30 PM</div>
                        <div class="time-slot">3:00 PM</div>
                        <div class="time-slot unavailable">3:30 PM</div>
                    </div>
                      <input
                        type="hidden"
                        id="appointmentTime"
                        name="appointmentTime"
                        required
                      />
                    </div>
                    
                    <div class="col-12">
                      <label for="purpose" class="form-label"
                        >Purpose of Meeting</label
                      >
                      <textarea
                        class="form-control"
                        id="purpose"
                        name="purpose"
                        rows="3"
                        required
                      ></textarea>
                    </div>
                    
                    <div class="col-12 mt-4">
                      <button type="submit" class="btn btn-primary">
                        <i class="bi bi-calendar-plus me-2"></i> Schedule
                        Appointment
                      </button>
                      <button type="reset" class="btn btn-outline-secondary">
                        <i class="bi bi-x-circle me-2"></i> Reset
                      </button>
                    </div>
                  </form>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Upcoming Appointments -->
          <div class="row mb-4">
            <div class="col-md-12">
              <div class="content-card">
                <div
                  class="card-header d-flex justify-content-between align-items-center"
                >
                  <h5 class="mb-0">Your Appointments</h5>
                  <div class="btn-group btn-group-sm" role="group">
                    <button
                      type="button"
                      class="btn btn-outline-primary active"
                      id="upcomingBtn"
                    >
                      Upcoming
                    </button>
                    <button
                      type="button"
                      class="btn btn-outline-primary"
                      id="pastBtn"
                    >
                      Past
                    </button>
                  </div>
                </div>
                <div class="card-body p-0">
                  <div id="upcomingAppointments">
                    <div class="table-responsive">
                      <table class="table table-hover mb-0">
                        <thead>
                          <tr>
                            <th>Date & Time</th>
                            <th>Staff Member</th>
                            <th>Child</th>
                            <th>Purpose</th>
                            <th>Status</th>
                            <th>Actions</th>
                          </tr>
                        </thead>
                        <tbody>
                          <c:forEach
                            items="${upcomingAppointments}"
                            var="appointment"
                          >
                            <tr>
                              <td>
                                <div class="d-flex align-items-center">
                                  <div
                                    class="bg-primary bg-opacity-10 text-primary p-2 rounded me-2"
                                  >
                                    <i class="bi bi-calendar2"></i>
                                  </div>
                                  <div>
                                    <div>
                                      <fmt:formatDate
                                        value="${appointment.date}"
                                        pattern="MMM dd, yyyy"
                                      />
                                    </div>
                                    <div class="text-muted small">
                                      ${appointment.time}
                                    </div>
                                  </div>
                                </div>
                              </td>
                              <td>${appointment.staffName}</td>
                              <td>${appointment.childName}</td>
                              <td>${appointment.purpose}</td>
                              <td>
                                <span
                                  class="badge ${appointment.status eq 'CONFIRMED' ? 'bg-success' : (appointment.status eq 'PENDING' ? 'bg-warning text-dark' : 'bg-danger')}"
                                >
                                  ${appointment.status}
                                </span>
                              </td>
                              <td>
                                <div class="btn-group btn-group-sm">
                                  <button
                                    type="button"
                                    class="btn btn-outline-primary"
                                    onclick="viewDetails(${appointment.id})"
                                    data-bs-toggle="modal"
                                    data-bs-target="#appointmentDetailsModal"
                                  >
                                    <i class="bi bi-eye"></i>
                                  </button>
                                  <c:if
                                    test="${appointment.status eq 'PENDING'}"
                                  >
                                    <button
                                      type="button"
                                      class="btn btn-outline-danger"
                                      onclick="cancelAppointment(${appointment.id})"
                                    >
                                      <i class="bi bi-x-circle"></i>
                                    </button>
                                  </c:if>
                                </div>
                              </td>
                            </tr>
                          </c:forEach>
                          <c:if test="${empty upcomingAppointments}">
                            <tr>
                              <td colspan="6" class="text-center py-4">
                                <i
                                  class="bi bi-calendar2-x text-muted"
                                  style="font-size: 2rem"
                                ></i>
                                <p class="mt-2 text-muted">
                                  No upcoming appointments
                                </p>
                              </td>
                            </tr>
                          </c:if>
                        </tbody>
                      </table>
                    </div>
                  </div>
                  <div id="pastAppointments" style="display: none">
                    <div class="table-responsive">
                      <table class="table table-hover mb-0">
                        <thead>
                          <tr>
                            <th>Date & Time</th>
                            <th>Staff Member</th>
                            <th>Child</th>
                            <th>Purpose</th>
                            <th>Status</th>
                            <th>Actions</th>
                          </tr>
                        </thead>
                        <tbody>
                          <c:forEach
                            items="${pastAppointments}"
                            var="appointment"
                          >
                            <tr>
                              <td>
                                <div class="d-flex align-items-center">
                                  <div
                                    class="bg-secondary bg-opacity-10 text-secondary p-2 rounded me-2"
                                  >
                                    <i class="bi bi-calendar2-check"></i>
                                  </div>
                                  <div>
                                    <div>
                                      <fmt:formatDate
                                        value="${appointment.date}"
                                        pattern="MMM dd, yyyy"
                                      />
                                    </div>
                                    <div class="text-muted small">
                                      ${appointment.time}
                                    </div>
                                  </div>
                                </div>
                              </td>
                              <td>${appointment.staffName}</td>
                              <td>${appointment.childName}</td>
                              <td>${appointment.purpose}</td>
                              <td>
                                <span
                                  class="badge ${appointment.status eq 'COMPLETED' ? 'bg-info' : (appointment.status eq 'CANCELLED' ? 'bg-danger' : 'bg-secondary')}"
                                >
                                  ${appointment.status}
                                </span>
                              </td>
                              <td>
                                <button
                                  type="button"
                                  class="btn btn-sm btn-outline-primary"
                                  onclick="viewDetails(${appointment.id})"
                                  data-bs-toggle="modal"
                                  data-bs-target="#appointmentDetailsModal"
                                >
                                  <i class="bi bi-eye"></i> View
                                </button>
                              </td>
                            </tr>
                          </c:forEach>
                          <c:if test="${empty pastAppointments}">
                            <tr>
                              <td colspan="6" class="text-center py-4">
                                <i
                                  class="bi bi-calendar2-x text-muted"
                                  style="font-size: 2rem"
                                ></i>
                                <p class="mt-2 text-muted">
                                  No past appointments
                                </p>
                              </td>
                            </tr>
                          </c:if>
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Appointment Details Modal -->
    <div class="modal fade" id="appointmentDetailsModal" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Appointment Details</h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <div id="appointmentDetails">
              <!-- Will be populated dynamically -->
            </div>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
            >
              Close
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <script>
      // Time slots selection
      document
        .querySelectorAll(".time-slot:not(.unavailable)")
        .forEach((slot) => {
          slot.addEventListener("click", function () {
            document
              .querySelectorAll(".time-slot")
              .forEach((s) => s.classList.remove("selected"));
            this.classList.add("selected");
            document.getElementById("appointmentTime").value = this.textContent;
          });
        });

      // Toggle between upcoming and past appointments
      document
        .getElementById("upcomingBtn")
        .addEventListener("click", function () {
          document.getElementById("upcomingAppointments").style.display =
            "block";
          document.getElementById("pastAppointments").style.display = "none";
          this.classList.add("active");
          document.getElementById("pastBtn").classList.remove("active");
        });

      document.getElementById("pastBtn").addEventListener("click", function () {
        document.getElementById("upcomingAppointments").style.display = "none";
        document.getElementById("pastAppointments").style.display = "block";
        this.classList.add("active");
        document.getElementById("upcomingBtn").classList.remove("active");
      });

      // Load staff members based on selected type
      function loadStaffMembers() {
        const staffType = document.getElementById("staffType").value;
        const staffMemberSelect = document.getElementById("staffMember");

        // Clear existing options
        staffMemberSelect.innerHTML =
          '<option value="">Select Staff Member</option>';

        if (staffType === "teacher") {
          // Add teachers
          const teachers = [
            { id: 1, name: "Mrs. Johnson (Mathematics)" },
            { id: 2, name: "Mr. Smith (Science)" },
            { id: 3, name: "Ms. Davis (English)" },
            { id: 4, name: "Mr. Wilson (History)" },
          ];

          teachers.forEach((teacher) => {
            const option = document.createElement("option");
            option.value = teacher.id;
            option.textContent = teacher.name;
            staffMemberSelect.appendChild(option);
          });
        } else if (staffType === "admin") {
          // Add administrators
          const admins = [
            { id: 5, name: "Principal Edwards" },
            { id: 6, name: "Vice Principal Martinez" },
            { id: 7, name: "Dean Roberts" },
          ];

          admins.forEach((admin) => {
            const option = document.createElement("option");
            option.value = admin.id;
            option.textContent = admin.name;
            staffMemberSelect.appendChild(option);
          });
        } else if (staffType === "doctor") {
          // Add doctors
          const doctors = [
            { id: 8, name: "Dr. Collins" },
            { id: 9, name: "Dr. Peterson" },
          ];

          doctors.forEach((doctor) => {
            const option = document.createElement("option");
            option.value = doctor.id;
            option.textContent = doctor.name;
            staffMemberSelect.appendChild(option);
          });
        } else if (staffType === "nurse") {
          // Add nurses
          const nurses = [
            { id: 10, name: "Nurse Adams" },
            { id: 11, name: "Nurse Thompson" },
          ];

          nurses.forEach((nurse) => {
            const option = document.createElement("option");
            option.value = nurse.id;
            option.textContent = nurse.name;
            staffMemberSelect.appendChild(option);
          });
        }
      }

      // View appointment details
      function viewDetails(appointmentId) {
        // In a real application, you would fetch appointment details using AJAX
        const details = {
          id: appointmentId,
          date: "May 25, 2023",
          time: "10:00 AM",
          staffName: "Mrs. Johnson (Mathematics)",
          childName: "Jane Doe",
          purpose: "Discuss recent test performance and improvement strategies",
          status: "CONFIRMED",
          notes: "Please bring your child's recent test papers.",
        };

        let statusClass = "";
        switch (details.status) {
          case "CONFIRMED":
            statusClass = "bg-success";
            break;
          case "PENDING":
            statusClass = "bg-warning text-dark";
            break;
          case "CANCELLED":
            statusClass = "bg-danger";
            break;
          case "COMPLETED":
            statusClass = "bg-info";
            break;
          default:
            statusClass = "bg-secondary";
        }

        // Populate modal with appointment details
        document.getElementById("appointmentDetails").innerHTML = `
          <div class="text-center mb-3">
            <span class="badge ${statusClass} p-2 fs-6">${details.status}</span>
          </div>
          <div class="d-flex mb-3">
            <div class="bg-primary bg-opacity-10 text-primary p-3 rounded">
              <i class="bi bi-calendar2-date fs-3"></i>
            </div>
            <div class="ms-3">
              <h6 class="mb-1">Date & Time</h6>
              <p class="mb-0">${details.date} at ${details.time}</p>
            </div>
          </div>
          <div class="d-flex mb-3">
            <div class="bg-success bg-opacity-10 text-success p-3 rounded">
              <i class="bi bi-person-badge fs-3"></i>
            </div>
            <div class="ms-3">
              <h6 class="mb-1">Staff Member</h6>
              <p class="mb-0">${details.staffName}</p>
            </div>
          </div>
          <div class="d-flex mb-3">
            <div class="bg-info bg-opacity-10 text-info p-3 rounded">
              <i class="bi bi-person fs-3"></i>
            </div>
            <div class="ms-3">
              <h6 class="mb-1">Child</h6>
              <p class="mb-0">${details.childName}</p>
            </div>
          </div>
          <div class="mb-3">
            <h6 class="mb-1">Purpose</h6>
            <p class="mb-0">${details.purpose}</p>
          </div>
          <div class="mb-0">
            <h6 class="mb-1">Additional Notes</h6>
            <p class="mb-0">${details.notes || "No additional notes"}</p>
          </div>
        `;
      }

      // Cancel appointment
      function cancelAppointment(appointmentId) {
        if (confirm("Are you sure you want to cancel this appointment?")) {
          // In a real application, you would send a request to the server
          alert("Appointment cancelled successfully.");

          // You would then refresh the appointments list or update the UI
        }
      }
    </script>
  </body>
</html> 

        const staffType = document.getElementById('staffType').value;
        const staffSelect = document.getElementById('staffId');
        
        // Clear previous options
        staffSelect.innerHTML = '<option value="">Select Staff Member</option>';
        
        if (staffType === '') {
          staffSelect.disabled = true;
          return;
        }
        
        staffSelect.disabled = false;
        
        // Load appropriate staff options
        if (staffType === 'teacher') {
          <c:forEach var="teacher" items="${teachers}">
            const option = document.createElement('option');
            option.value = ${teacher.teacherId};
            option.textContent = '${teacher.fullName} - ${teacher.subject}';
            staffSelect.appendChild(option);
          </c:forEach>
        } else if (staffType === 'admin') {
          <c:forEach var="admin" items="${adminStaff}">
            const option = document.createElement('option');
            option.value = ${admin.adminId};
            option.textContent = '${admin.fullName} - ${admin.designation}';
            staffSelect.appendChild(option);
          </c:forEach>
        }
      }
      
      // Set minimum date for appointment to today
      document.addEventListener('DOMContentLoaded', function() {
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('appointmentDate').setAttribute('min', today);
      });
    </script>
  </body>
</html> 