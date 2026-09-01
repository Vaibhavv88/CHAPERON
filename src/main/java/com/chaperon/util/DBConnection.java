package com.chaperon.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {

    private static final Properties properties = new Properties();

    static {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        }
        catch (ClassNotFoundException e) {

            throw new RuntimeException(
                "MySQL Driver not found",
                e
            );
        }


        try (
            InputStream inputStream =
                DBConnection.class
                    .getClassLoader()
                    .getResourceAsStream("db.properties")
        ) {

            if (inputStream != null) {
                properties.load(inputStream);
            }
        }
        catch (IOException e) {

            throw new RuntimeException(
                "Unable to read db.properties",
                e
            );
        }
    }


    private DBConnection() {
    }


    public static Connection getConnection()
            throws SQLException {

        /*
         * ==========================================
         * RAILWAY DATABASE CONFIGURATION
         * ==========================================
         */

        String railwayHost =
            System.getenv("MYSQLHOST");

        String railwayPort =
            System.getenv("MYSQLPORT");

        String railwayDatabase =
            System.getenv("MYSQLDATABASE");

        String railwayUsername =
            System.getenv("MYSQLUSER");

        String railwayPassword =
            System.getenv("MYSQLPASSWORD");


        /*
         * Railway environment detected
         */

        if (railwayHost != null &&
            !railwayHost.isBlank()) {

            String url =
                "jdbc:mysql://"
                + railwayHost
                + ":"
                + railwayPort
                + "/"
                + railwayDatabase
                + "?useSSL=false"
                + "&allowPublicKeyRetrieval=true"
                + "&serverTimezone=UTC";

            return DriverManager.getConnection(
                url,
                railwayUsername,
                railwayPassword
            );
        }


        /*
         * ==========================================
         * LOCAL DATABASE CONFIGURATION
         * ==========================================
         */

        String url =
            properties.getProperty("db.url");

        String username =
            properties.getProperty("db.username");

        String password =
            properties.getProperty("db.password");


        if (url == null ||
            username == null ||
            password == null) {

            throw new SQLException(
                "Database configuration not found"
            );
        }


        return DriverManager.getConnection(
            url,
            username,
            password
        );
    }
}