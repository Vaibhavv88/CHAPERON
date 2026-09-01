package com.chaperon.util;

public class PasswordUtilTest {

    public static void main(String[] args) {

        String password = "demo123";

        String hash = PasswordUtil.hashPassword(password);

        System.out.println("Hash: " + hash);

        System.out.println(
                "Correct Password: "
                + PasswordUtil.checkPassword("demo123", hash)
        );

        System.out.println(
                "Wrong Password: "
                + PasswordUtil.checkPassword("wrong123", hash)
        );
    }
}