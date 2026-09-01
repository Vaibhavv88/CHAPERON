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

    @Override
    public void init() throws ServletException {

        documentDAO =
                new DocumentDAOImpl();

        businessService =
                new BusinessServiceImpl();
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

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

        long userId =
                ((Number) session
                        .getAttribute("userId"))
                        .longValue();

        String documentType =
                request.getParameter("documentType");

        Part filePart =
                request.getPart("documentFile");

        if (documentType == null ||
            documentType.isBlank()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Document type is required."
            );

            return;
        }

        if (filePart == null ||
            filePart.getSize() <= 0) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Please select a file."
            );

            return;
        }

        String originalFileName =
                filePart.getSubmittedFileName();

        if (originalFileName == null ||
            originalFileName.isBlank()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid file."
            );

            return;
        }

        String extension =
                getExtension(
                        originalFileName
                );

        if (!isAllowedExtension(
                extension
        )) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Only PDF, JPG, JPEG and PNG files are allowed."
            );

            return;
        }

        try {

            Business business =
                    businessService
                            .getBusinessByUserId(
                                    userId
                            );

            if (business == null) {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Business profile not found."
                );

                return;
            }

            long businessId =
                    business.getBusinessId();

            String storedFileName =
                    UUID.randomUUID()
                    .toString()
                    + "."
                    + extension;

            String uploadRoot =
                    System.getProperty(
                            "user.home"
                    )
                    + File.separator
                    + "CHAPERON_UPLOADS"
                    + File.separator
                    + "business_"
                    + businessId;

            File uploadDirectory =
                    new File(
                            uploadRoot
                    );

            if (!uploadDirectory.exists()) {

                boolean created =
                        uploadDirectory.mkdirs();

                if (!created &&
                    !uploadDirectory.exists()) {

                    throw new IOException(
                            "Unable to create upload directory."
                    );
                }
            }

            Path destination =
                    Path.of(
                            uploadRoot,
                            storedFileName
                    );

            Files.copy(
                    filePart.getInputStream(),
                    destination,
                    StandardCopyOption.REPLACE_EXISTING
            );

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

            long documentId =
                    documentDAO.save(
                            document
                    );

            if (documentId <= 0) {

                Files.deleteIfExists(
                        destination
                );

                response.sendError(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Document metadata could not be saved."
                );

                return;
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur/documents?uploaded=1"
            );

        } catch (SQLException e) {

            log(
                    "Unable to save uploaded document",
                    e
            );

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to save document."
            );
        }
    }

    private String getExtension(
            String fileName
    ) {

        int lastDot =
                fileName.lastIndexOf('.');

        if (lastDot == -1 ||
            lastDot == fileName.length() - 1) {

            return "";
        }

        return fileName
                .substring(
                        lastDot + 1
                )
                .toLowerCase();
    }

    private boolean isAllowedExtension(
            String extension
    ) {

        return "pdf".equals(extension)
                || "jpg".equals(extension)
                || "jpeg".equals(extension)
                || "png".equals(extension);
    }
}