package com.chaperon.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.chaperon.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/profile")
public class EntrepreneurProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    private static final String FIND_USER =
            "SELECT " +
            "user_id, " +
            "full_name, " +
            "email, " +
            "mobile, " +
            "role, " +
            "created_at, " +
            "last_login, " +
            "profile_completed " +
            "FROM users " +
            "WHERE user_id = ? " +
            "LIMIT 1";


    private static final String UPDATE_USER =
            "UPDATE users " +
            "SET full_name = ?, " +
            "mobile = ? " +
            "WHERE user_id = ? " +
            "AND role = 'ENTREPRENEUR'";


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);


        /*
         * =========================================
         * 1. SESSION CHECK
         * =========================================
         */
        if (session == null ||
            session.getAttribute("userId") == null ||
            session.getAttribute("userRole") == null ||
            !"ENTREPRENEUR".equalsIgnoreCase(
                    String.valueOf(
                            session.getAttribute("userRole")
                    )
            )) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }


        long userId =
                ((Number)
                session.getAttribute("userId"))
                .longValue();


        /*
         * =========================================
         * 2. LOAD PROFILE
         * =========================================
         */
        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            FIND_USER
                    )
        ) {

            statement.setLong(
                    1,
                    userId
            );


            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (!resultSet.next()) {

                    response.sendError(
                            HttpServletResponse.SC_NOT_FOUND,
                            "User profile not found."
                    );

                    return;
                }


                /*
                 * =================================
                 * SEND DATA TO JSP
                 * =================================
                 */

                request.setAttribute(
                        "profileUserId",
                        resultSet.getLong(
                                "user_id"
                        )
                );


                request.setAttribute(
                        "profileFullName",
                        resultSet.getString(
                                "full_name"
                        )
                );


                request.setAttribute(
                        "profileEmail",
                        resultSet.getString(
                                "email"
                        )
                );


                request.setAttribute(
                        "profileMobile",
                        resultSet.getString(
                                "mobile"
                        )
                );


                request.setAttribute(
                        "profileRole",
                        resultSet.getString(
                                "role"
                        )
                );


                request.setAttribute(
                        "profileCreatedAt",
                        resultSet.getTimestamp(
                                "created_at"
                        )
                );


                request.setAttribute(
                        "profileLastLogin",
                        resultSet.getTimestamp(
                                "last_login"
                        )
                );


                request.setAttribute(
                        "profileCompleted",
                        resultSet.getBoolean(
                                "profile_completed"
                        )
                );
            }


            /*
             * =========================================
             * 3. OPEN JSP
             * =========================================
             */
            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/profile.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (SQLException e) {

            log(
                    "Unable to load entrepreneur profile.",
                    e
            );


            response.sendError(
                    HttpServletResponse
                            .SC_INTERNAL_SERVER_ERROR,
                    "Unable to load profile."
            );
        }
    }



    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding(
                "UTF-8"
        );


        HttpSession session =
                request.getSession(false);


        /*
         * =========================================
         * 1. SESSION CHECK
         * =========================================
         */
        if (session == null ||
            session.getAttribute("userId") == null ||
            session.getAttribute("userRole") == null ||
            !"ENTREPRENEUR".equalsIgnoreCase(
                    String.valueOf(
                            session.getAttribute("userRole")
                    )
            )) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }


        long userId =
                ((Number)
                session.getAttribute("userId"))
                .longValue();



        /*
         * =========================================
         * 2. FORM DATA
         * =========================================
         */
        String fullName =
                request.getParameter(
                        "fullName"
                );


        String mobile =
                request.getParameter(
                        "mobile"
                );


        /*
         * =========================================
         * 3. VALIDATION
         * =========================================
         */
        if (fullName == null ||
            fullName.isBlank()) {

            redirectWithMessage(
                    request,
                    response,
                    "Full name is required."
            );

            return;
        }


        fullName =
                fullName.trim();


        if (fullName.length() < 2 ||
            fullName.length() > 150) {

            redirectWithMessage(
                    request,
                    response,
                    "Full name must be between 2 and 150 characters."
            );

            return;
        }


        if (mobile == null ||
            mobile.isBlank()) {

            redirectWithMessage(
                    request,
                    response,
                    "Mobile number is required."
            );

            return;
        }


        mobile =
                mobile.trim();


        /*
         * Indian mobile number:
         * 10 digits starting with 6/7/8/9
         */
        if (!mobile.matches(
                "^[6-9][0-9]{9}$"
        )) {

            redirectWithMessage(
                    request,
                    response,
                    "Please enter a valid 10-digit mobile number."
            );

            return;
        }



        /*
         * =========================================
         * 4. UPDATE PROFILE
         * =========================================
         */
        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            UPDATE_USER
                    )
        ) {

            statement.setString(
                    1,
                    fullName
            );


            statement.setString(
                    2,
                    mobile
            );


            statement.setLong(
                    3,
                    userId
            );


            int updatedRows =
                    statement.executeUpdate();


            if (updatedRows != 1) {

                response.sendError(
                        HttpServletResponse.SC_CONFLICT,
                        "Profile could not be updated."
                );

                return;
            }


            /*
             * =========================================
             * 5. UPDATE SESSION NAME
             * =========================================
             */
            session.setAttribute(
                    "userName",
                    fullName
            );


            /*
             * =========================================
             * 6. SUCCESS
             * =========================================
             */
            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur/profile"
                    + "?success=profile-updated"
            );


        } catch (SQLException e) {

            log(
                    "Unable to update entrepreneur profile.",
                    e
            );


            response.sendError(
                    HttpServletResponse
                            .SC_INTERNAL_SERVER_ERROR,
                    "Unable to update profile."
            );
        }
    }



    /*
     * =============================================
     * REDIRECT WITH MESSAGE
     * =============================================
     */
    private void redirectWithMessage(
            HttpServletRequest request,
            HttpServletResponse response,
            String message
    ) throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/entrepreneur/profile"
                + "?message="
                + java.net.URLEncoder.encode(
                        message,
                        java.nio.charset.StandardCharsets.UTF_8
                )
        );
    }
}