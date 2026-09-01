package com.chaperon.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    private PasswordUtil() {
    }

    public static String hashPassword(String plainPassword) {

        return BCrypt.hashpw(
                plainPassword,
                BCrypt.gensalt(12)
        );
    }

    public static boolean checkPassword(
            String plainPassword,
            String hashedPassword) {

        if (plainPassword == null ||
            hashedPassword == null ||
            hashedPassword.isBlank()) {

            return false;
        }

        try {

            return BCrypt.checkpw(
                    plainPassword,
                    hashedPassword
            );

        } catch (IllegalArgumentException e) {

            return false;
        }
    }
}
