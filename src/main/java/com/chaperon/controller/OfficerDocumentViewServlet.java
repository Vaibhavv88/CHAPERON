package com.chaperon.controller;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
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

@WebServlet("/officer/document-view")
public class OfficerDocumentViewServlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /*
     * =====================================================
     * SECURE DOCUMENT QUERY
     *
     * The document is returned only when:
     *
     * 1. Application exists
     * 2. Document belongs to same business
     * 3. Document is required for that approval
     * 4. Document is active
     * =====================================================
     */
    private static final String FIND_DOCUMENT =
            "SELECT " +
            "d.document_id, " +
            "d.business_id, " +
            "d.document_type, " +
            "d.original_file_name, " +
            "d.stored_file_name, " +
            "d.file_path, " +
            "d.file_extension, " +
            "d.file_size, " +
            "d.verification_status, " +

            "ap.application_id, " +
            "ap.department_id, " +
            "ap.assigned_officer_id " +

            "FROM documents d " +

            "JOIN applications ap " +
            "ON ap.business_id = d.business_id " +

            "JOIN approval_document_requirements adr " +
            "ON adr.approval_id = ap.approval_id " +
            "AND adr.document_type = d.document_type " +
            "AND adr.active = 1 " +

            "WHERE d.document_id = ? " +
            "AND ap.application_id = ? " +
            "AND d.active = 1 " +

            "LIMIT 1";

    /*
     * =====================================================
     * GET
     * =====================================================
     */
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        /*
         * =================================================
         * 1. OFFICER SESSION CHECK
         * =================================================
         */
        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null ||
            session.getAttribute("userRole") == null ||
            session.getAttribute("departmentId") == null ||
            session.getAttribute("officerProfileId") == null ||
            !"OFFICER".equalsIgnoreCase(
                    String.valueOf(
                            session.getAttribute(
                                    "userRole"
                            )
                    )
            )) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/officer-login"
            );

            return;
        }

        /*
         * =================================================
         * 2. PARAMETERS
         * =================================================
         */
        String applicationIdText =
                request.getParameter(
                        "applicationId"
                );

        String documentIdText =
                request.getParameter(
                        "documentId"
                );

        if (applicationIdText == null ||
            applicationIdText.isBlank() ||
            documentIdText == null ||
            documentIdText.isBlank()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Application ID and Document ID are required."
            );

            return;
        }

        try {

            long applicationId =
                    Long.parseLong(
                            applicationIdText
                    );

            long documentId =
                    Long.parseLong(
                            documentIdText
                    );

            long officerDepartmentId =
                    ((Number)
                    session.getAttribute(
                            "departmentId"
                    ))
                    .longValue();

            long officerProfileId =
                    ((Number)
                    session.getAttribute(
                            "officerProfileId"
                    ))
                    .longValue();

            /*
             * =================================================
             * 3. LOAD DOCUMENT + APPLICATION SECURITY DATA
             * =================================================
             */
            try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(
                                FIND_DOCUMENT
                        )
            ) {

                statement.setLong(
                        1,
                        documentId
                );

                statement.setLong(
                        2,
                        applicationId
                );

                try (
                    ResultSet resultSet =
                            statement.executeQuery()
                ) {

                    /*
                     * =========================================
                     * DOCUMENT NOT FOUND / NOT APPLICABLE
                     * =========================================
                     */
                    if (!resultSet.next()) {

                        response.sendError(
                                HttpServletResponse.SC_NOT_FOUND,
                                "Document not found for this application."
                        );

                        return;
                    }

                    /*
                     * =========================================
                     * DEPARTMENT SECURITY
                     * =========================================
                     */
                    long applicationDepartmentId =
                            resultSet.getLong(
                                    "department_id"
                            );

                    if (applicationDepartmentId
                            != officerDepartmentId) {

                        response.sendError(
                                HttpServletResponse.SC_FORBIDDEN,
                                "You are not authorized to view this document."
                        );

                        return;
                    }

                    /*
                     * =========================================
                     * ASSIGNED OFFICER SECURITY
                     *
                     * If application has a specific assigned
                     * officer, only that officer can view it.
                     * =========================================
                     */
                    long assignedOfficerId =
                            resultSet.getLong(
                                    "assigned_officer_id"
                            );

                    if (!resultSet.wasNull() &&
                        assignedOfficerId
                                != officerProfileId) {

                        response.sendError(
                                HttpServletResponse.SC_FORBIDDEN,
                                "This application is assigned to another officer."
                        );

                        return;
                    }

                    /*
                     * =========================================
                     * FILE INFORMATION
                     * =========================================
                     */
                    String filePath =
                            resultSet.getString(
                                    "file_path"
                            );

                    String originalFileName =
                            resultSet.getString(
                                    "original_file_name"
                            );

                    String fileExtension =
                            resultSet.getString(
                                    "file_extension"
                            );

                    if (filePath == null ||
                        filePath.isBlank()) {

                        response.sendError(
                                HttpServletResponse.SC_NOT_FOUND,
                                "Document file path is not available."
                        );

                        return;
                    }

                    /*
                     * =========================================
                     * PHYSICAL FILE
                     * =========================================
                     */
                    File documentFile =
                            new File(
                                    filePath
                            );

                    if (!documentFile.exists() ||
                        !documentFile.isFile()) {

                        response.sendError(
                                HttpServletResponse.SC_NOT_FOUND,
                                "Uploaded document file could not be found."
                        );

                        return;
                    }

                    /*
                     * =========================================
                     * MIME TYPE
                     * =========================================
                     */
                    String contentType =
                            getContentType(
                                    fileExtension
                            );

                    response.setContentType(
                            contentType
                    );

                    /*
                     * =========================================
                     * INLINE DISPLAY
                     *
                     * PDF opens in browser PDF viewer.
                     * JPG/JPEG/PNG opens as image.
                     * =========================================
                     */
                    String safeFileName =
                            sanitizeFileName(
                                    originalFileName
                            );

                    response.setHeader(
                            "Content-Disposition",
                            "inline; filename=\""
                            + safeFileName
                            + "\""
                    );

                    response.setHeader(
                            "X-Content-Type-Options",
                            "nosniff"
                    );

                    response.setContentLengthLong(
                            documentFile.length()
                    );

                    /*
                     * =========================================
                     * STREAM FILE
                     * =========================================
                     */
                    try (
                        BufferedInputStream input =
                                new BufferedInputStream(
                                        new FileInputStream(
                                                documentFile
                                        )
                                );

                        OutputStream output =
                                response.getOutputStream()
                    ) {

                        byte[] buffer =
                                new byte[8192];

                        int bytesRead;

                        while (
                            (bytesRead =
                                    input.read(
                                            buffer
                                    )) != -1
                        ) {

                            output.write(
                                    buffer,
                                    0,
                                    bytesRead
                            );
                        }

                        output.flush();
                    }
                }
            }

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid application or document ID."
            );

        } catch (SQLException e) {

            log(
                    "Unable to open officer document.",
                    e
            );

            response.sendError(
                    HttpServletResponse
                            .SC_INTERNAL_SERVER_ERROR,
                    "Unable to load document."
            );
        }
    }

    /*
     * =====================================================
     * MIME TYPE
     * =====================================================
     */
    private String getContentType(
            String extension
    ) {

        if (extension == null) {

            return "application/octet-stream";
        }

        String normalized =
                extension
                        .trim()
                        .toLowerCase();

        switch (normalized) {

            case "pdf":
                return "application/pdf";

            case "jpg":
            case "jpeg":
                return "image/jpeg";

            case "png":
                return "image/png";

            default:
                return "application/octet-stream";
        }
    }

    /*
     * =====================================================
     * SAFE FILE NAME
     * =====================================================
     */
    private String sanitizeFileName(
            String fileName
    ) {

        if (fileName == null ||
            fileName.isBlank()) {

            return "document";
        }

        return fileName
                .replace(
                        "\"",
                        ""
                )
                .replace(
                        "\r",
                        ""
                )
                .replace(
                        "\n",
                        ""
                );
    }
}