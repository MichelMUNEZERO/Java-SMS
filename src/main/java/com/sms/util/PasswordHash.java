package com.sms.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for handling password hashing and verification
 */
public class PasswordHash {
    
    /**
     * Hash a password using BCrypt
     * @param plainPassword the plain text password
     * @return the hashed password
     */
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(10));
    }
    
    /**
     * Verify if the plain password matches the hashed password
     * @param plainPassword the plain text password
     * @param hashedPassword the hashed password
     * @return true if the password matches, false otherwise
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
} 