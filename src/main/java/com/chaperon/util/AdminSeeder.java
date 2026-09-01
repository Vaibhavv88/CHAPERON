package com.chaperon.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AdminSeeder {

    public static void main(String[] args) {

        String email = "admin@chaperon.gov";
        String password = "Admin@123";
        String fullName = "CHAPERON Administrator";
        String mobile = "9999999999";

        String checkSql =
                "SELECT user_id FROM users WHERE email = ?";

        String insertSql =
                "INSERT INTO users " +
                "(full_name, email, mobile, password_hash, role, account_status, profile_completed) " +
                "VALUES (?, ?, ?, ?, 'ADMIN', 'ACTIVE', 1)";

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement checkStatement =
                    connection.prepareStatement(checkSql)
        ) {

            checkStatement.setString(
                    1,
                    email
            );

            try (
                ResultSet resultSet =
                        checkStatement.executeQuery()
            ) {

                if (resultSet.next()) {

                    System.out.println(
                            "Admin user already exists."
                    );

                    return;
                }
            }


            String hashedPassword =
                    PasswordUtil.hashPassword(
                            password
                    );


            try (
                PreparedStatement insertStatement =
                        connection.prepareStatement(insertSql)
            ) {

                insertStatement.setString(
                        1,
                        fullName
                );

                insertStatement.setString(
                        2,
                        email
                );

                insertStatement.setString(
                        3,
                        mobile
                );

                insertStatement.setString(
                        4,
                        hashedPassword
                );


                int rows =
                        insertStatement.executeUpdate();


                if (rows > 0) {

                    System.out.println(
                            "================================="
                    );

                    System.out.println(
                            "ADMIN CREATED SUCCESSFULLY"
                    );

                    System.out.println(
                            "Email    : " + email
                    );

                    System.out.println(
                            "Password : " + password
                    );

                    System.out.println(
                            "================================="
                    );

                } else {

                    System.out.println(
                            "Admin could not be created."
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }
    }
}