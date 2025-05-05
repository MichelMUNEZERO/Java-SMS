#!/bin/bash

# This script removes the Settings link from admin JSP files in the School Management System

# List of all admin JSP files to be updated
FILES=(
  "src/main/webapp/admin/announcements.jsp"
  "src/main/webapp/admin/nurse_details.jsp"
  "src/main/webapp/admin/view_student_health.jsp"
  "src/main/webapp/admin/students.jsp"
  "src/main/webapp/admin/teachers.jsp"
  "src/main/webapp/admin/student_form.jsp"
  "src/main/webapp/admin/parent_form.jsp"
  "src/main/webapp/admin/parent_details.jsp"
  "src/main/webapp/admin/parents.jsp"
  "src/main/webapp/admin/nurse_form.jsp"
  "src/main/webapp/admin/nurses.jsp"
  "src/main/webapp/admin/teachers/add_teacher.jsp"
  "src/main/webapp/admin/teachers/view_teacher.jsp"
  "src/main/webapp/admin/teachers/list_teachers.jsp"
  "src/main/webapp/admin/doctor_form.jsp"
  "src/main/webapp/admin/teachers/edit_teacher.jsp"
  "src/main/webapp/admin/doctor_details.jsp"
  "src/main/webapp/admin/doctors.jsp"
  "src/main/webapp/admin/announcement_form.jsp"
  "src/main/webapp/admin/announcement_details.jsp"
)

# Loop through all files and remove the Settings link
for file in "${FILES[@]}"; do
  if [ -f "$file" ]; then
    echo "Processing $file..."
    # Use sed to remove the Settings link (from <li class="nav-item"> to </li>)
    sed -i '/<li class="nav-item">\s*<a\s*class="nav-link text-white"\s*href="${pageContext.request.contextPath}\/admin\/settings">/,/<\/li>/d' "$file"
  else
    echo "File not found: $file"
  fi
done

echo "Completed removing Settings links from admin JSP files" 