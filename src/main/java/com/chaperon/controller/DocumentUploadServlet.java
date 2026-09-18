package com.chaperon.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;
import java.util.UUID;

import com.chaperon.dao.DocumentDAO;
import com.chaperon.dao.impl.DocumentDAOImpl;
import com.chaperon.model.Business;
import com.chaperon.model.Document;
import com.chaperon.service.BusinessService;
import com.chaperon.service.DocumentTypeCatalogService;
import com.chaperon.service.impl.BusinessServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/entrepreneur/document-upload")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 10 * 1024 * 1024,
        maxRequestSize = 12 * 1024 * 1024
)
public class DocumentUploadServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private DocumentDAO documentDAO;
    private BusinessService businessService;
    private DocumentTypeCatalogService documentTypeCatalogService;

    @Override
    public void init() throws ServletException {

        documentDAO =
                new DocumentDAOImpl();

        businessService =
                new BusinessServiceImpl();

        documentTypeCatalogService =
                new DocumentTypeCatalogService();
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        /*
         * ==========================================
         * SESSION VALIDATION
         * ==========================================
         */
        HttpSession session =
                request.getSession(false);

        if (session == null ||
                session.getAttribute("userId") == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/entrepreneur-login"
            );
            return;
        }

        Object userIdObject =
                session.getAttribute("userId");

        if (!(userIdObject instanceof Number)) {

            session.invalidate();

            response.sendRedirect(
                    request.getContextPath()
                            + "/entrepreneur-login"
            );
            return;
        }

        long userId =
                ((Number) userIdObject)
                        .longValue();

        /*
         * ==========================================
         * ROLE VALIDATION
         * ==========================================
         */
        Object userRoleObject =
                session.getAttribute("userRole");

        if (userRoleObject != null) {

            String userRole =
                    String.valueOf(userRoleObject);

            if (!"ENTREPRENEUR"
                    .equalsIgnoreCase(userRole)) {

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "Entrepreneur access is required."
                );
                return;
            }
        }

        /*
         * ==========================================
         * DOCUMENT TYPE
         * ==========================================
         *
         * No hardcoded allowed-document Set is used.
         *
         * This supports:
         * - INSTALLATION_DETAILS
         * - TEST_CERTIFICATE
         * - FORM_B
         * - CTE_CERTIFICATE
         * - Future Admin-added document types
         */
        String documentType =
                documentTypeCatalogService
                        .normalizeDocumentCode(
                                request.getParameter(
                                        "documentType"
                                )
                        );

        if (documentType == null ||
                documentType.isBlank()) {

            redirectWithError(
                    request,
                    response,
                    "type-required"
            );
            return;
        }

        /*
         * Only safe uppercase document codes are accepted.
         *
         * Examples:
         * PAN
         * INSTALLATION_DETAILS
         * TEST_CERTIFICATE
         */
        if (!documentType.matches(
                "^[A-Z0-9][A-Z0-9_]{0,99}$"
        )) {

            redirectWithError(
                    request,
                    response,
                    "invalid-type"
            );
            return;
        }

        /*
         * ==========================================
         * MULTIPART FILE
         * ==========================================
         */
        Part filePart;

        try {

            filePart =
                    request.getPart(
                            "documentFile"
                    );

        } catch (IllegalStateException exception) {

            redirectWithError(
                    request,
                    response,
                    "file-too-large"
            );
            return;

        } catch (ServletException exception) {

            log(
                    "Unable to read multipart request.",
                    exception
            );

            redirectWithError(
                    request,
                    response,
                    "invalid-upload"
            );
            return;
        }

        if (filePart == null ||
                filePart.getSize() <= 0) {

            redirectWithError(
                    request,
                    response,
                    "file-required"
            );
            return;
        }

        /*
         * ==========================================
         * ORIGINAL FILE NAME
         * ==========================================
         */
        String originalFileName =
                getSafeFileName(
                        filePart.getSubmittedFileName()
                );

        if (originalFileName == null ||
                originalFileName.isBlank()) {

            redirectWithError(
                    request,
                    response,
                    "invalid-file"
            );
            return;
        }

        /*
         * ==========================================
         * FILE EXTENSION
         * ==========================================
         */
        String extension =
                getExtension(
                        originalFileName
                );

        if (!isAllowedExtension(extension)) {

            redirectWithError(
                    request,
                    response,
                    "invalid-extension"
            );
            return;
        }

        /*
         * ==========================================
         * CONTENT TYPE
         * ==========================================
         */
        String contentType =
                filePart.getContentType();

        if (!isAllowedContentType(contentType)) {

            redirectWithError(
                    request,
                    response,
                    "invalid-content"
            );
            return;
        }

        Path destination = null;

        try {

            /*
             * ======================================
             * LOAD BUSINESS
             * ======================================
             */
            Business business =
                    businessService
                            .getBusinessByUserId(
                                    userId
                            );

            if (business == null) {

                redirectWithError(
                        request,
                        response,
                        "business-not-found"
                );
                return;
            }

            long businessId =
                    business.getBusinessId();

            /*
             * ======================================
             * GENERATE STORED FILE NAME
             * ======================================
             */
            String storedFileName =
                    UUID.randomUUID()
                            .toString()
                            + "."
                            + extension;

            /*
             * ======================================
             * UPLOAD DIRECTORY
             * ======================================
             */
            String uploadRoot =
                    System.getProperty(
                            "user.home"
                    )
                            + File.separator
                            + "CHAPERON_UPLOADS"
                            + File.separator
                            + "business_"
                            + businessId;

            Path uploadDirectory =
                    Path.of(uploadRoot);

            Files.createDirectories(
                    uploadDirectory
            );

            destination =
                    uploadDirectory.resolve(
                            storedFileName
                    );

            /*
             * ======================================
             * SAVE PHYSICAL FILE
             * ======================================
             */
            try (
                var inputStream =
                        filePart.getInputStream()
            ) {

                Files.copy(
                        inputStream,
                        destination,
                        StandardCopyOption.REPLACE_EXISTING
                );
            }

            /*
             * ======================================
             * CREATE DOCUMENT MODEL
             * ======================================
             */
            Document document =
                    new Document();

            document.setUserId(
                    userId
            );

            document.setBusinessId(
                    businessId
            );

            document.setDocumentType(
                    documentType
            );

            document.setOriginalFileName(
                    originalFileName
            );

            document.setStoredFileName(
                    storedFileName
            );

            document.setFilePath(
                    destination.toString()
            );

            document.setFileSize(
                    filePart.getSize()
            );

            document.setFileExtension(
                    extension
            );

            /*
             * ======================================
             * SAVE DOCUMENT METADATA
             * ======================================
             */
            long documentId =
                    documentDAO.save(
                            document
                    );

            if (documentId <= 0) {

                Files.deleteIfExists(
                        destination
                );

                redirectWithError(
                        request,
                        response,
                        "save-failed"
                );
                return;
            }

            /*
             * ======================================
             * SUCCESS
             * ======================================
             */
            response.sendRedirect(
                    request.getContextPath()
                            + "/entrepreneur/documents"
                            + "?uploaded=1"
            );

        } catch (SQLException exception) {

            deleteUploadedFile(
                    destination
            );

            log(
                    "Unable to save document metadata. "
                            + "User ID: "
                            + userId
                            + ", Document type: "
                            + documentType,
                    exception
            );

            redirectWithError(
                    request,
                    response,
                    "database"
            );

        } catch (IOException exception) {

            deleteUploadedFile(
                    destination
            );

            log(
                    "Unable to save document file. "
                            + "User ID: "
                            + userId
                            + ", Document type: "
                            + documentType,
                    exception
            );

            redirectWithError(
                    request,
                    response,
                    "storage"
            );
        }
    }

    /*
     * ==============================================
     * ERROR REDIRECT
     * ==============================================
     */
    private void redirectWithError(
            HttpServletRequest request,
            HttpServletResponse response,
            String errorCode
    ) throws IOException {

        response.sendRedirect(
                request.getContextPath()
                        + "/entrepreneur/documents"
                        + "?error="
                        + errorCode
        );
    }

    /*
     * ==============================================
     * DELETE INCOMPLETE UPLOAD
     * ==============================================
     */
    private void deleteUploadedFile(
            Path destination
    ) {

        if (destination == null) {
            return;
        }

        try {

            Files.deleteIfExists(
                    destination
            );

        } catch (IOException exception) {

            log(
                    "Unable to delete incomplete file: "
                            + destination,
                    exception
            );
        }
    }

    /*
     * ==============================================
     * SAFE ORIGINAL FILE NAME
     * ==============================================
     */
    private String getSafeFileName(
            String submittedFileName
    ) {

        if (submittedFileName == null ||
                submittedFileName.isBlank()) {

            return null;
        }

        return Path.of(
                submittedFileName
        )
                .getFileName()
                .toString();
    }

    /*
     * ==============================================
     * FILE EXTENSION
     * ==============================================
     */
    private String getExtension(
            String fileName
    ) {

        if (fileName == null ||
                fileName.isBlank()) {

            return "";
        }

        int lastDot =
                fileName.lastIndexOf('.');

        if (lastDot < 0 ||
                lastDot == fileName.length() - 1) {

            return "";
        }

        return fileName
                .substring(lastDot + 1)
                .toLowerCase();
    }

    /*
     * ==============================================
     * ALLOWED EXTENSIONS
     * ==============================================
     */
    private boolean isAllowedExtension(
            String extension
    ) {

        return "pdf".equals(extension)
                || "jpg".equals(extension)
                || "jpeg".equals(extension)
                || "png".equals(extension);
    }

    /*
     * ==============================================
     * ALLOWED MIME TYPES
     * ==============================================
     */
    private boolean isAllowedContentType(
            String contentType
    ) {

        if (contentType == null ||
                contentType.isBlank()) {

            return false;
        }

        return "application/pdf"
                .equalsIgnoreCase(contentType)

                || "image/jpeg"
                .equalsIgnoreCase(contentType)

                || "image/png"
                .equalsIgnoreCase(contentType);
    }
}