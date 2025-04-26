package com.sms.controller.teacher;

import com.sms.dao.CourseDAO;
import com.sms.dao.CourseMaterialDAO;
import com.sms.dao.impl.CourseMaterialDAOImpl;
import com.sms.dao.impl.CourseDAOImpl;
import com.sms.model.Course;
import com.sms.model.CourseMaterial;
import com.sms.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Timestamp;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB
    maxFileSize = 1024 * 1024 * 50,       // 50 MB
    maxRequestSize = 1024 * 1024 * 100    // 100 MB
)
public class CourseMaterialsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(CourseMaterialsServlet.class.getName());
    private static final String UPLOAD_DIRECTORY = "course-materials";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"teacher".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String courseIdParam = request.getParameter("id");
        if (courseIdParam == null || courseIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/teacher/courses");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdParam);
            CourseDAO courseDAO = new CourseDAOImpl();
            Course course = courseDAO.getCourseById(courseId);

            if (course == null) {
                response.sendRedirect(request.getContextPath() + "/teacher/courses");
                return;
            }

            // Check if the teacher is assigned to this course
            if (course.getTeacherId() != user.getUserId()) {
                response.sendRedirect(request.getContextPath() + "/teacher/courses");
                return;
            }

            CourseMaterialDAO materialDAO = new CourseMaterialDAOImpl();
            List<CourseMaterial> materials = materialDAO.getMaterialsByCourseId(courseId);

            request.setAttribute("courseDetails", course);
            request.setAttribute("courseMaterials", materials);
            request.getRequestDispatcher("/WEB-INF/views/teacher/course-materials.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid course ID format: " + courseIdParam, e);
            response.sendRedirect(request.getContextPath() + "/teacher/courses");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading course materials", e);
            request.setAttribute("errorMessage", "Error loading course materials: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"teacher".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String courseIdParam = request.getParameter("courseId");

        if (courseIdParam == null || courseIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/teacher/courses");
            return;
        }

        int courseId;
        try {
            courseId = Integer.parseInt(courseIdParam);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid course ID format: " + courseIdParam, e);
            response.sendRedirect(request.getContextPath() + "/teacher/courses");
            return;
        }

        CourseDAO courseDAO = new CourseDAOImpl();
        Course course = courseDAO.getCourseById(courseId);

        // Check if the teacher is assigned to this course
        if (course == null || course.getTeacherId() != user.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/teacher/courses");
            return;
        }

        CourseMaterialDAO materialDAO = new CourseMaterialDAOImpl();

        // Handle different actions (upload, delete)
        if ("upload".equals(action)) {
            uploadMaterial(request, response, courseId, user.getUserId());
        } else if ("delete".equals(action)) {
            deleteMaterial(request, response, courseId, user.getUserId());
        } else {
            response.sendRedirect(request.getContextPath() + "/teacher/course-materials?id=" + courseId);
        }
    }

    private void uploadMaterial(HttpServletRequest request, HttpServletResponse response, int courseId, int teacherId) 
            throws ServletException, IOException {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String type = request.getParameter("type");
        String link = request.getParameter("link");

        if (title == null || title.trim().isEmpty() || type == null || type.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Title and type are required");
            response.sendRedirect(request.getContextPath() + "/teacher/course-materials?id=" + courseId + "&error=missing_fields");
            return;
        }

        CourseMaterial material = new CourseMaterial();
        material.setCourseId(courseId);
        material.setTitle(title);
        material.setDescription(description);
        material.setFileType(type);
        material.setUploadedBy(teacherId);
        material.setUploadDate(new Timestamp(System.currentTimeMillis()));

        // For video content, store the link
        if ("VIDEO".equals(type)) {
            if (link == null || link.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/teacher/course-materials?id=" + courseId + "&error=missing_link");
                return;
            }
            material.setFileUrl(link);
        } else {
            // For file uploads, process the file
            Part filePart = request.getPart("file");
            if (filePart == null || filePart.getSize() == 0) {
                response.sendRedirect(request.getContextPath() + "/teacher/course-materials?id=" + courseId + "&error=missing_file");
                return;
            }

            // Create upload directory if it doesn't exist
            String applicationPath = request.getServletContext().getRealPath("");
            String uploadPath = applicationPath + File.separator + UPLOAD_DIRECTORY;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            // Generate unique file name to prevent overwriting
            String originalFileName = filePart.getSubmittedFileName();
            String fileExtension = "";
            if (originalFileName.contains(".")) {
                fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
            }
            String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
            String filePath = uploadPath + File.separator + uniqueFileName;

            // Save the file
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
            }

            // Store the file URL (relative path)
            material.setFileUrl(UPLOAD_DIRECTORY + "/" + uniqueFileName);
        }

        // Save material to database
        try {
            CourseMaterialDAO materialDAO = new CourseMaterialDAOImpl();
            boolean success = materialDAO.createCourseMaterial(material);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/teacher/course-materials?id=" + courseId + "&success=upload");
            } else {
                response.sendRedirect(request.getContextPath() + "/teacher/course-materials?id=" + courseId + "&error=database");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating course material", e);
            response.sendRedirect(request.getContextPath() + "/teacher/course-materials?id=" + courseId + "&error=database");
        }
    }

    private void deleteMaterial(HttpServletRequest request, HttpServletResponse response, int courseId, int teacherId) 
            throws ServletException, IOException {
        String materialIdParam = request.getParameter("materialId");
        if (materialIdParam == null || materialIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/teacher/course-materials?id=" + courseId + "&error=invalid_material");
            return;
        }

        try {
            int materialId = Integer.parseInt(materialIdParam);
            CourseMaterialDAO materialDAO = new CourseMaterialDAOImpl();
            CourseMaterial material = materialDAO.getCourseMaterialById(materialId);

            // Check if material exists and belongs to this teacher and course
            if (material == null || material.getUploadedBy() != teacherId || material.getCourseId() != courseId) {
                response.sendRedirect(request.getContextPath() + "/teacher/course-materials?id=" + courseId + "&error=unauthorized");
                return;
            }

            // If it's a file (not a video link), delete the file from storage
            if (material.getFileUrl() != null && !material.getFileUrl().isEmpty() && !material.getFileUrl().startsWith("http")) {
                String applicationPath = request.getServletContext().getRealPath("");
                Path filePath = Paths.get(applicationPath, material.getFileUrl());
                
                try {
                    Files.deleteIfExists(filePath);
                } catch (IOException e) {
                    // Log the error but continue with database deletion
                    LOGGER.log(Level.WARNING, "Error deleting file: " + filePath, e);
                }
            }

            // Delete from database
            boolean success = materialDAO.deleteCourseMaterial(materialId);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/teacher/course-materials?id=" + courseId + "&success=delete");
            } else {
                response.sendRedirect(request.getContextPath() + "/teacher/course-materials?id=" + courseId + "&error=database");
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid material ID: " + materialIdParam, e);
            response.sendRedirect(request.getContextPath() + "/teacher/course-materials?id=" + courseId + "&error=invalid_material");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting course material", e);
            response.sendRedirect(request.getContextPath() + "/teacher/course-materials?id=" + courseId + "&error=database");
        }
    }
} 