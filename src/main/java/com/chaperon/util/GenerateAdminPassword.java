package com.chaperon.util;

public class GenerateAdminPassword {

    public static void main(String[] args) {

        String password = "admin123";

        String hash =
                PasswordUtil.hashPassword(password);

        System.out.println(hash);
    }
}