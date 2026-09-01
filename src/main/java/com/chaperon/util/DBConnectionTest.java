package com.chaperon.util;

import java.sql.Connection;

public class DBConnectionTest {

    public static void main(String[] args) {

        try (
            Connection connection =
                DBConnection.getConnection()
        ) {

            if (connection != null) {

                System.out.println(
                    "CHAPERON DATABASE CONNECTED SUCCESSFULLY"
                );

                System.out.println(
                    "Database Name: "
                    + connection.getCatalog()
                );
            }

        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}