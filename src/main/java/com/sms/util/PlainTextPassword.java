package com.sms.util;

/**
 * Utility class for handling plain text passwords
 */
public class PlainTextPassword {
    
    /**
     * Return the password as is (no hashing)
     * @param plainPassword the plain text password
     * @return the same password (no hashing)
     */
    public static String getPassword(String plainPassword) {
        return plainPassword; // No hashing, return as is
    }
    
    /**
     * Verify if the plain password matches the stored password
     * @param plainPassword the plain text password
     * @param storedPassword the stored password
     * @return true if the password matches, false otherwise
     */
    public static boolean checkPassword(String plainPassword, String storedPassword) {
        return plainPassword.equals(storedPassword); // Simple string comparison
    }
} 