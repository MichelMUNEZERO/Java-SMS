package com.sms.util;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.Part;

/**
 * Utility class for handling file uploads
 */
public class FileUpload {
    
    private static final String UPLOAD_DIRECTORY = "images";
    
    /**
     * Upload a file to the server
     * @param request the HTTP request
     * @param paramName the name of the file input parameter
     * @return the path to the uploaded file, or null if upload failed
     */
    public static String uploadFile(HttpServletRequest request, String paramName) {
        try {
            // Get the file part from the request
            Part filePart = request.getPart(paramName);
            
            // If no file was selected, return null
            if (filePart == null || filePart.getSize() == 0) {
                return null;
            }
            
            // Get content type and validate image type
            String contentType = filePart.getContentType();
            if (!contentType.startsWith("image/")) {
                return null;
            }
            
            // Create a unique file name
            String fileName = UUID.randomUUID().toString() + getFileExtension(filePart);
            
            // Get the absolute path to the upload directory
            String uploadPath = request.getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
            
            // Create the upload directory if it doesn't exist
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            
            // Write the file to the upload directory
            filePart.write(uploadPath + File.separator + fileName);
            
            // Return the relative path of the file
            return UPLOAD_DIRECTORY + "/" + fileName;
        } catch (IOException | ServletException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Get the file extension from a Part object
     * @param part the Part object
     * @return the file extension (including the dot)
     */
    private static String getFileExtension(Part part) {
        String submittedFileName = part.getSubmittedFileName();
        return submittedFileName.substring(submittedFileName.lastIndexOf('.'));
    }
} 