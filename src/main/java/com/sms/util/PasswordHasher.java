package com.sms.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Utility class for hashing and verifying passwords
 */
public class PasswordHasher {
    
    private static final String ALGORITHM = "SHA-256";
    private static final int SALT_LENGTH = 16;
    
    /**
     * Hash a password using SHA-256 with a random salt
     * @param password the password to hash
     * @return the hashed password with salt prepended
     */
    public static String hashPassword(String password) {
        try {
            // Generate a random salt
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);
            
            // Hash the password with the salt
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            md.update(salt);
            byte[] hashedPassword = md.digest(password.getBytes());
            
            // Combine salt and hashed password
            byte[] combined = new byte[salt.length + hashedPassword.length];
            System.arraycopy(salt, 0, combined, 0, salt.length);
            System.arraycopy(hashedPassword, 0, combined, salt.length, hashedPassword.length);
            
            // Encode as Base64 string
            return Base64.getEncoder().encodeToString(combined);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
    
    /**
     * Check if a password matches a hashed password
     * @param password the plain text password to check
     * @param hashedPassword the hashed password to check against
     * @return true if the password matches, false otherwise
     */
    public static boolean checkPassword(String password, String hashedPassword) {
        try {
            // Decode the hashed password
            byte[] combined = Base64.getDecoder().decode(hashedPassword);
            
            // Extract the salt
            byte[] salt = new byte[SALT_LENGTH];
            System.arraycopy(combined, 0, salt, 0, SALT_LENGTH);
            
            // Hash the password with the extracted salt
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            md.update(salt);
            byte[] hashedBytes = md.digest(password.getBytes());
            
            // Compare the hashed bytes
            for (int i = 0; i < hashedBytes.length; i++) {
                if (hashedBytes[i] != combined[SALT_LENGTH + i]) {
                    return false;
                }
            }
            
            return true;
        } catch (Exception e) {
            // If any error occurs, return false
            return false;
        }
    }
    
    /**
     * Generate a random password
     * @param length the length of the password
     * @return a random password
     */
    public static String generateRandomPassword(int length) {
        final String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+";
        SecureRandom random = new SecureRandom();
        StringBuilder password = new StringBuilder(length);
        
        for (int i = 0; i < length; i++) {
            int randomIndex = random.nextInt(CHARACTERS.length());
            password.append(CHARACTERS.charAt(randomIndex));
        }
        
        return password.toString();
    }
} 