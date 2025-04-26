package com.sms.controller.teacher;

import com.sms.dao.CourseMaterialDAO;
import com.sms.dao.impl.CourseMaterialDAOImpl;
import com.sms.model.CourseMaterial;
import com.sms.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DownloadMaterialServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(DownloadMaterialServlet.class.getName());
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"teacher".equals(user.getRole()) && !"student".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String materialIdParam = request.getParameter("id");
        if (materialIdParam == null || materialIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Material ID is required");
            return;
        }

        try {
            int materialId = Integer.parseInt(materialIdParam);
            CourseMaterialDAO materialDAO = new CourseMaterialDAOImpl();
            CourseMaterial material = materialDAO.getCourseMaterialById(materialId);

            if (material == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Material not found");
                return;
            }

            // If it's a URL link (like YouTube), redirect to it
            if (material.getFileUrl() != null && material.getFileUrl().startsWith("http")) {
                response.sendRedirect(material.getFileUrl());
                return;
            }

            // Get the physical file path
            String applicationPath = request.getServletContext().getRealPath("");
            Path filePath = Paths.get(applicationPath, material.getFileUrl());
            File downloadFile = filePath.toFile();

            if (!downloadFile.exists()) {
                LOGGER.log(Level.WARNING, "File not found: " + filePath);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
                return;
            }

            // Get file name for download
            String fileName = material.getTitle();
            if (material.getFileUrl().contains(".")) {
                String extension = material.getFileUrl().substring(material.getFileUrl().lastIndexOf("."));
                if (!fileName.endsWith(extension)) {
                    fileName += extension;
                }
            }

            // Set the content type based on file type
            String contentType = determineContentType(material.getFileType(), downloadFile);
            response.setContentType(contentType);

            // Set the response headers for download
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            response.setHeader("Content-Length", String.valueOf(downloadFile.length()));

            // Stream the file to the client
            try (FileInputStream inStream = new FileInputStream(downloadFile);
                 OutputStream outStream = response.getOutputStream()) {
                
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = inStream.read(buffer)) != -1) {
                    outStream.write(buffer, 0, bytesRead);
                }
            }

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid material ID: " + materialIdParam, e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid material ID");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error downloading material", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error downloading material: " + e.getMessage());
        }
    }

    private String determineContentType(String materialType, File file) {
        // First, try to determine content type from the file
        try {
            String mimeType = Files.probeContentType(file.toPath());
            if (mimeType != null) {
                return mimeType;
            }
        } catch (IOException e) {
            LOGGER.log(Level.WARNING, "Could not determine file type", e);
        }

        // If file probing fails, use material type and file extension as fallback
        String fileName = file.getName().toLowerCase();
        if (fileName.endsWith(".pdf")) {
            return "application/pdf";
        } else if (fileName.endsWith(".doc") || fileName.endsWith(".docx")) {
            return "application/msword";
        } else if (fileName.endsWith(".ppt") || fileName.endsWith(".pptx")) {
            return "application/vnd.ms-powerpoint";
        } else if (fileName.endsWith(".xls") || fileName.endsWith(".xlsx")) {
            return "application/vnd.ms-excel";
        } else if (fileName.endsWith(".zip")) {
            return "application/zip";
        } else if (fileName.endsWith(".rar")) {
            return "application/x-rar-compressed";
        } else if (fileName.endsWith(".mp4")) {
            return "video/mp4";
        } else if (fileName.endsWith(".mp3")) {
            return "audio/mpeg";
        } else if (fileName.endsWith(".txt")) {
            return "text/plain";
        }

        // Default content type
        return "application/octet-stream";
    }
} 