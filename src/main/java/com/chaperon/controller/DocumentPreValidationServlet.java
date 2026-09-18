package com.chaperon.controller;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Files;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.imageio.ImageIO;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;

import com.chaperon.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/document-pre-validation")
public class DocumentPreValidationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /*
     * Maximum text we inspect from a PDF.
     * Enough for validation without keeping huge content in memory.
     */
    private static final int MAX_TEXT_LENGTH = 30000;

    /*
     * Minimum useful file size.
     * Tiny files are usually empty/corrupt placeholders.
     */
    private static final long MIN_FILE_SIZE_BYTES = 1024;

    /*
     * PAN pattern:
     * ABCDE1234F
     */
    private static final Pattern PAN_PATTERN =
            Pattern.compile(
                    "\\b[A-Z]{5}[0-9]{4}[A-Z]\\b"
            );

    /*
     * GSTIN-like format:
     * 2 digits + PAN + entity/check characters.
     */
    private static final Pattern GST_PATTERN =
            Pattern.compile(
                    "\\b[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z][A-Z0-9][Zz][A-Z0-9]\\b",
                    Pattern.CASE_INSENSITIVE
            );

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        /*
         * ============================================================
         * SESSION CHECK
         * ============================================================
         */
        if (session == null
                || session.getAttribute("userId") == null
                || session.getAttribute("userRole") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }

        String userRole =
                String.valueOf(
                        session.getAttribute("userRole")
                );

        if (!"ENTREPRENEUR"
                .equalsIgnoreCase(userRole)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "This page is only available for entrepreneurs."
            );

            return;
        }

        try {

            long userId =
                    ((Number)
                    session.getAttribute("userId"))
                    .longValue();

            long businessId =
                    getBusinessId(
                            userId
                    );

            if (businessId <= 0) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/entrepreneur/business-onboarding"
                );

                return;
            }

            /*
             * ========================================================
             * LOAD + ACTUALLY INSPECT FILES
             * ========================================================
             */
            List<Map<String, Object>> documents =
                    loadAndValidateDocuments(
                            businessId
                    );

            ValidationSummary summary =
                    analyseDocuments(
                            documents
                    );

            /*
             * AI only receives non-sensitive summary signals.
             * Raw PAN/Aadhaar/document contents are NOT sent.
             */
            String aiExplanation =
                    generateAIExplanation(
                            summary,
                            documents
                    );

            request.setAttribute(
                    "documents",
                    documents
            );

            request.setAttribute(
                    "totalDocuments",
                    summary.totalDocuments
            );

            request.setAttribute(
                    "readyDocuments",
                    summary.readyDocuments
            );

            request.setAttribute(
                    "warningDocuments",
                    summary.warningDocuments
            );

            request.setAttribute(
                    "riskDocuments",
                    summary.riskDocuments
            );

            request.setAttribute(
                    "overallScore",
                    summary.overallScore
            );

            request.setAttribute(
                    "overallStatus",
                    summary.overallStatus
            );

            request.setAttribute(
                    "aiExplanation",
                    aiExplanation
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/document-pre-validation.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to validate documents.",
                    e
            );
        }
    }


    /*
     * ================================================================
     * BUSINESS
     * ================================================================
     */

    private long getBusinessId(
            long userId)
            throws SQLException {

        String sql =
                "SELECT business_id " +
                "FROM businesses " +
                "WHERE user_id = ? " +
                "ORDER BY business_id DESC " +
                "LIMIT 1";

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setLong(
                    1,
                    userId
            );

            try (
                    ResultSet resultSet =
                            statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    return resultSet.getLong(
                            "business_id"
                    );
                }
            }
        }

        return 0;
    }


    /*
     * ================================================================
     * DOCUMENT LOADING
     * ================================================================
     */

    private List<Map<String, Object>>
            loadAndValidateDocuments(
            long businessId)
            throws SQLException {

        String sql =
                "SELECT " +
                "document_id, " +
                "document_type, " +
                "file_path, " +
                "verification_status, " +
                "upload_date, " +
                "expiry_date " +
                "FROM documents " +
                "WHERE business_id = ? " +
                "ORDER BY upload_date DESC, document_id DESC";

        List<Map<String, Object>> documents =
                new ArrayList<>();

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setLong(
                    1,
                    businessId
            );

            try (
                    ResultSet resultSet =
                            statement.executeQuery()
            ) {

                while (resultSet.next()) {

                    long documentId =
                            resultSet.getLong(
                                    "document_id"
                            );

                    String documentType =
                            resultSet.getString(
                                    "document_type"
                            );

                    String filePath =
                            resultSet.getString(
                                    "file_path"
                            );

                    String verificationStatus =
                            resultSet.getString(
                                    "verification_status"
                            );

                    Date uploadDate =
                            resultSet.getDate(
                                    "upload_date"
                            );

                    Date expiryDate =
                            resultSet.getDate(
                                    "expiry_date"
                            );

                    DocumentCheck check =
                            validateDocument(
                                    businessId,
                                    documentType,
                                    filePath,
                                    verificationStatus,
                                    expiryDate
                            );

                    Map<String, Object> row =
                            new HashMap<>();

                    row.put(
                            "documentId",
                            documentId
                    );

                    row.put(
                            "documentType",
                            documentType
                    );

                    row.put(
                            "filePath",
                            filePath
                    );

                    row.put(
                            "verificationStatus",
                            verificationStatus
                    );

                    row.put(
                            "uploadDate",
                            uploadDate
                    );

                    row.put(
                            "expiryDate",
                            expiryDate
                    );

                    row.put(
                            "validationStatus",
                            check.status
                    );

                    row.put(
                            "validationMessage",
                            check.message
                    );

                    row.put(
                            "validationScore",
                            check.score
                    );

                    row.put(
                            "contentVerified",
                            check.contentVerified
                    );

                    documents.add(row);
                }
            }
        }

        return documents;
    }


    /*
     * ================================================================
     * MAIN DOCUMENT VALIDATION
     * ================================================================
     */

    private DocumentCheck validateDocument(
            long businessId,
            String documentType,
            String filePath,
            String verificationStatus,
            Date expiryDate) {

        int score = 100;

        boolean contentVerified = false;

        List<String> issues =
                new ArrayList<>();

        List<String> positives =
                new ArrayList<>();


        /*
         * ============================================================
         * 1. DATABASE FILE REFERENCE
         * ============================================================
         */
        if (filePath == null
                || filePath.isBlank()) {

            return new DocumentCheck(
                    15,
                    "RISK",
                    "Uploaded file reference is missing. Upload the document again.",
                    false
            );
        }


        /*
         * ============================================================
         * 2. RESOLVE ACTUAL PHYSICAL FILE
         * ============================================================
         */
        File file =
                resolveDocumentFile(
                        businessId,
                        filePath
                );

        if (file == null
                || !file.exists()
                || !file.isFile()) {

            return new DocumentCheck(
                    20,
                    "RISK",
                    "The document record exists, but the actual uploaded file could not be found on the server.",
                    false
            );
        }


        /*
         * ============================================================
         * 3. FILE SIZE
         * ============================================================
         */
        long fileSize =
                file.length();

        if (fileSize <= 0) {

            return new DocumentCheck(
                    10,
                    "RISK",
                    "The uploaded file is empty.",
                    false
            );
        }

        if (fileSize < MIN_FILE_SIZE_BYTES) {

            score -= 25;

            issues.add(
                    "The file is unusually small and may be incomplete."
            );
        } else {

            positives.add(
                    "Physical file is available."
            );
        }


        /*
         * ============================================================
         * 4. REAL MIME TYPE
         * ============================================================
         */
        String detectedMime =
                detectMimeType(
                        file
                );

        String lowerName =
                file.getName()
                        .toLowerCase(
                                Locale.ROOT
                        );

        boolean pdf =
                lowerName.endsWith(".pdf");

        boolean image =
                lowerName.endsWith(".jpg")
                ||
                lowerName.endsWith(".jpeg")
                ||
                lowerName.endsWith(".png");


        if (!pdf && !image) {

            score -= 50;

            issues.add(
                    "Unsupported document format. Use PDF, JPG, JPEG or PNG."
            );
        }


        if (detectedMime != null
                && !detectedMime.isBlank()) {

            boolean validMime =
                    detectedMime.equalsIgnoreCase(
                            "application/pdf"
                    )
                    ||
                    detectedMime.equalsIgnoreCase(
                            "image/jpeg"
                    )
                    ||
                    detectedMime.equalsIgnoreCase(
                            "image/png"
                    );

            if (!validMime) {

                score -= 20;

                issues.add(
                        "The detected file type does not match the supported document formats."
                );
            }
        }


        /*
         * ============================================================
         * 5. EXISTING VERIFICATION STATUS
         * ============================================================
         */
        if (verificationStatus != null) {

            if ("REJECTED"
                    .equalsIgnoreCase(
                            verificationStatus)) {

                score -= 50;

                issues.add(
                        "This document was previously rejected during verification."
                );
            }

            if ("EXPIRED"
                    .equalsIgnoreCase(
                            verificationStatus)) {

                score -= 50;

                issues.add(
                        "This document is marked as expired."
                );
            }

            if ("VERIFIED"
                    .equalsIgnoreCase(
                            verificationStatus)) {

                positives.add(
                        "Previously verified document."
                );
            }
        }


        /*
         * ============================================================
         * 6. EXPIRY CHECK
         * ============================================================
         */
        if (expiryDate != null) {

            LocalDate today =
                    LocalDate.now();

            LocalDate expiry =
                    expiryDate.toLocalDate();

            long daysRemaining =
                    ChronoUnit.DAYS.between(
                            today,
                            expiry
                    );

            if (daysRemaining < 0) {

                score -= 50;

                issues.add(
                        "The document expired "
                        + Math.abs(daysRemaining)
                        + " day(s) ago."
                );

            } else if (daysRemaining <= 7) {

                score -= 30;

                issues.add(
                        "The document expires in only "
                        + daysRemaining
                        + " day(s)."
                );

            } else if (daysRemaining <= 30) {

                score -= 15;

                issues.add(
                        "The document will expire within "
                        + daysRemaining
                        + " day(s)."
                );

            } else {

                positives.add(
                        "Document validity is currently active."
                );
            }
        }


        /*
         * ============================================================
         * 7. ACTUAL PDF CONTENT CHECK
         * ============================================================
         */
        if (pdf) {

            try {

                String extractedText =
                        extractPdfText(
                                file
                        );

                if (extractedText == null
                        || extractedText.isBlank()) {

                    score -= 25;

                    issues.add(
                            "No readable text could be extracted from the PDF. It may be scanned, blank or image-only."
                    );

                } else {

                    positives.add(
                            "PDF content is readable."
                    );

                    ContentValidationResult
                            contentResult =
                            validateContentByDocumentType(
                                    documentType,
                                    extractedText
                            );

                    score +=
                            contentResult.scoreAdjustment;

                    contentVerified =
                            contentResult.contentVerified;

                    if (contentResult.message != null
                            &&
                            !contentResult.message.isBlank()) {

                        if (contentResult.contentVerified) {

                            positives.add(
                                    contentResult.message
                            );

                        } else {

                            issues.add(
                                    contentResult.message
                            );
                        }
                    }
                }

            } catch (Exception e) {

                score -= 30;

                issues.add(
                        "The PDF could not be read correctly and may be damaged or encrypted."
                );
            }
        }


        /*
         * ============================================================
         * 8. ACTUAL IMAGE STRUCTURE CHECK
         * ============================================================
         */
        if (image) {

            ImageValidationResult
                    imageResult =
                    validateImage(
                            file
                    );

            score +=
                    imageResult.scoreAdjustment;

            if (imageResult.valid) {

                positives.add(
                        imageResult.message
                );

            } else {

                issues.add(
                        imageResult.message
                );
            }

            /*
             * We intentionally do not claim semantic content validation
             * because image OCR/AI document contents are not being sent.
             */
            contentVerified = false;

            score -= 10;

            issues.add(
                    "Image quality was checked, but text/content requires document verification."
            );
        }


        /*
         * ============================================================
         * 9. FINAL SCORE
         * ============================================================
         */
        if (score > 100) {
            score = 100;
        }

        if (score < 0) {
            score = 0;
        }


        /*
         * Never show perfect 100 if document semantics were not checked.
         */
        if (!contentVerified
                && score > 85) {

            score = 85;
        }


        String status;

        if (score >= 85
                && issues.isEmpty()) {

            status = "READY";

        } else if (score >= 60) {

            status = "WARNING";

        } else {

            status = "RISK";
        }


        /*
         * Even score 85 with semantic uncertainty should be WARNING,
         * not READY.
         */
        if (!contentVerified
                && "READY".equals(status)) {

            status = "WARNING";
        }


        String message =
                buildValidationMessage(
                        positives,
                        issues
                );


        return new DocumentCheck(
                score,
                status,
                message,
                contentVerified
        );
    }


    /*
     * ================================================================
     * FILE RESOLUTION
     * ================================================================
     */

    private File resolveDocumentFile(
            long businessId,
            String storedPath) {

        if (storedPath == null
                || storedPath.isBlank()) {

            return null;
        }


        /*
         * 1. Stored path may already be absolute.
         */
        File direct =
                new File(
                        storedPath
                );

        if (direct.exists()) {
            return direct;
        }


        /*
         * 2. Original CHAPERON upload location:
         *
         * user.home/
         * CHAPERON_UPLOADS/
         * business_<id>/
         */
        String fileName =
                new File(
                        storedPath
                ).getName();

        File originalUploadLocation =
                new File(
                        System.getProperty(
                                "user.home"
                        )
                        + File.separator
                        + "CHAPERON_UPLOADS"
                        + File.separator
                        + "business_"
                        + businessId
                        + File.separator
                        + fileName
                );

        if (originalUploadLocation.exists()) {

            return originalUploadLocation;
        }


        /*
         * 3. Handle stored relative path.
         */
        File userHomeRelative =
                new File(
                        System.getProperty(
                                "user.home"
                        ),
                        storedPath
                );

        if (userHomeRelative.exists()) {

            return userHomeRelative;
        }


        return originalUploadLocation;
    }


    /*
     * ================================================================
     * MIME
     * ================================================================
     */

    private String detectMimeType(
            File file) {

        try {

            return Files.probeContentType(
                    file.toPath()
            );

        } catch (IOException e) {

            return null;
        }
    }


    /*
     * ================================================================
     * PDFBOX CONTENT EXTRACTION
     * ================================================================
     */

    private String extractPdfText(
            File file)
            throws IOException {

        try (
                PDDocument document =
                        Loader.loadPDF(file)
        ) {

            if (document.isEncrypted()) {

                return "";
            }

            PDFTextStripper stripper =
                    new PDFTextStripper();

            String text =
                    stripper.getText(
                            document
                    );

            if (text == null) {

                return "";
            }

            text =
                    text.trim();

            if (text.length()
                    > MAX_TEXT_LENGTH) {

                text =
                        text.substring(
                                0,
                                MAX_TEXT_LENGTH
                        );
            }

            return text;
        }
    }


    /*
     * ================================================================
     * DOCUMENT-TYPE-SPECIFIC CONTENT VALIDATION
     * ================================================================
     */

    private ContentValidationResult
            validateContentByDocumentType(
            String documentType,
            String content) {

        if (content == null
                || content.isBlank()) {

            return new ContentValidationResult(
                    -20,
                    false,
                    "Document content could not be validated."
            );
        }


        String type =
                documentType == null
                        ? ""
                        : documentType
                        .trim()
                        .toUpperCase(
                                Locale.ROOT
                        );

        String upper =
                content.toUpperCase(
                        Locale.ROOT
                );


        /*
         * ============================================================
         * PAN
         * ============================================================
         */
        if ("PAN".equals(type)) {

            Matcher matcher =
                    PAN_PATTERN.matcher(
                            upper
                    );

            if (matcher.find()) {

                return new ContentValidationResult(
                        0,
                        true,
                        "PAN-format identifier detected in the document."
                );
            }

            return new ContentValidationResult(
                    -35,
                    false,
                    "Expected PAN-format identifier was not detected in the readable PDF content."
            );
        }


        /*
         * ============================================================
         * GST
         * ============================================================
         */
        if ("GST".equals(type)
                ||
                "GST_CERTIFICATE".equals(type)) {

            Matcher matcher =
                    GST_PATTERN.matcher(
                            upper
                    );

            if (matcher.find()
                    ||
                    containsAny(
                            upper,
                            "GSTIN",
                            "GOODS AND SERVICES TAX"
                    )) {

                return new ContentValidationResult(
                        0,
                        true,
                        "GST registration signals were detected."
                );
            }

            return new ContentValidationResult(
                    -30,
                    false,
                    "Expected GST registration information was not clearly detected."
            );
        }


        /*
         * ============================================================
         * BUSINESS REGISTRATION
         * ============================================================
         */
        if ("BUSINESS_REGISTRATION"
                .equals(type)) {

            if (containsAny(
                    upper,
                    "CERTIFICATE OF INCORPORATION",
                    "REGISTRATION CERTIFICATE",
                    "MINISTRY OF CORPORATE AFFAIRS",
                    "REGISTERED",
                    "COMPANY",
                    "LLP"
            )) {

                return new ContentValidationResult(
                        0,
                        true,
                        "Business registration-related content was detected."
                );
            }

            return new ContentValidationResult(
                    -25,
                    false,
                    "The readable content does not clearly show common business registration signals."
            );
        }


        /*
         * ============================================================
         * BUILDING PLAN
         * ============================================================
         */
        if ("BUILDING_PLAN"
                .equals(type)) {

            if (containsAny(
                    upper,
                    "BUILDING PLAN",
                    "SITE PLAN",
                    "FLOOR PLAN",
                    "LAYOUT",
                    "AREA",
                    "DRAWING"
            )) {

                return new ContentValidationResult(
                        0,
                        true,
                        "Building/site plan-related content was detected."
                );
            }

            return new ContentValidationResult(
                    -20,
                    false,
                    "Expected building plan or site plan signals were not clearly detected."
            );
        }


        /*
         * ============================================================
         * FACTORY LAYOUT
         * ============================================================
         */
        if ("FACTORY_LAYOUT"
                .equals(type)) {

            if (containsAny(
                    upper,
                    "FACTORY",
                    "LAYOUT",
                    "MACHINERY",
                    "SHOP FLOOR",
                    "PRODUCTION",
                    "PLANT"
            )) {

                return new ContentValidationResult(
                        0,
                        true,
                        "Factory/layout-related content was detected."
                );
            }

            return new ContentValidationResult(
                    -20,
                    false,
                    "The readable content does not clearly contain factory-layout signals."
            );
        }


        /*
         * ============================================================
         * FIRE LAYOUT
         * ============================================================
         */
        if ("FIRE_LAYOUT"
                .equals(type)) {

            if (containsAny(
                    upper,
                    "FIRE",
                    "EXIT",
                    "EXTINGUISHER",
                    "HYDRANT",
                    "SPRINKLER",
                    "EMERGENCY"
            )) {

                return new ContentValidationResult(
                        0,
                        true,
                        "Fire-safety layout signals were detected."
                );
            }

            return new ContentValidationResult(
                    -25,
                    false,
                    "Expected fire-safety or emergency-layout information was not clearly detected."
            );
        }


        /*
         * ============================================================
         * LAND DOCUMENT
         * ============================================================
         */
        if ("LAND_DOCUMENT"
                .equals(type)
                ||
                "PREMISES_PROOF"
                .equals(type)) {

            if (containsAny(
                    upper,
                    "LEASE",
                    "DEED",
                    "PROPERTY",
                    "LAND",
                    "PREMISES",
                    "OWNER",
                    "TENANT",
                    "REGISTRATION"
            )) {

                return new ContentValidationResult(
                        0,
                        true,
                        "Land/premises-related content was detected."
                );
            }

            return new ContentValidationResult(
                    -20,
                    false,
                    "Expected land, lease or premises-related information was not clearly detected."
            );
        }


        /*
         * ============================================================
         * WATER TEST
         * ============================================================
         */
        if ("WATER_TEST_REPORT"
                .equals(type)) {

            if (containsAny(
                    upper,
                    "WATER",
                    "TEST REPORT",
                    "PH",
                    "TDS",
                    "LABORATORY",
                    "SAMPLE"
            )) {

                return new ContentValidationResult(
                        0,
                        true,
                        "Water-testing report signals were detected."
                );
            }

            return new ContentValidationResult(
                    -25,
                    false,
                    "Expected water-test or laboratory information was not detected."
            );
        }


        /*
         * ============================================================
         * POLLUTION DOCUMENT
         * ============================================================
         */
        if ("POLLUTION_DOCUMENT"
                .equals(type)
                ||
                "ENVIRONMENT_REPORT"
                .equals(type)) {

            if (containsAny(
                    upper,
                    "POLLUTION",
                    "ENVIRONMENT",
                    "EMISSION",
                    "EFFLUENT",
                    "WASTE",
                    "CONSENT"
            )) {

                return new ContentValidationResult(
                        0,
                        true,
                        "Environmental/pollution-related content was detected."
                );
            }

            return new ContentValidationResult(
                    -20,
                    false,
                    "Environmental or pollution-related information was not clearly detected."
            );
        }


        /*
         * ============================================================
         * BOILER
         * ============================================================
         */
        if ("BOILER_DETAILS"
                .equals(type)
                ||
                "BOILER_CERTIFICATE"
                .equals(type)) {

            if (containsAny(
                    upper,
                    "BOILER",
                    "PRESSURE",
                    "STEAM",
                    "CERTIFICATE",
                    "INSPECTION"
            )) {

                return new ContentValidationResult(
                        0,
                        true,
                        "Boiler-related regulatory content was detected."
                );
            }

            return new ContentValidationResult(
                    -25,
                    false,
                    "Expected boiler-related information was not clearly detected."
            );
        }


        /*
         * ============================================================
         * EMPLOYEE DETAILS
         * ============================================================
         */
        if ("EMPLOYEE_DETAILS"
                .equals(type)) {

            if (containsAny(
                    upper,
                    "EMPLOYEE",
                    "WORKER",
                    "STAFF",
                    "DESIGNATION",
                    "SALARY",
                    "EMPLOYMENT"
            )) {

                return new ContentValidationResult(
                        0,
                        true,
                        "Employee-related information was detected."
                );
            }

            return new ContentValidationResult(
                    -20,
                    false,
                    "Expected employee or workforce information was not clearly detected."
            );
        }


        /*
         * ============================================================
         * MACHINERY DETAILS
         * ============================================================
         */
        if ("MACHINERY_DETAILS"
                .equals(type)) {

            if (containsAny(
                    upper,
                    "MACHINE",
                    "MACHINERY",
                    "CAPACITY",
                    "EQUIPMENT",
                    "POWER",
                    "HP",
                    "KW"
            )) {

                return new ContentValidationResult(
                        0,
                        true,
                        "Machinery/equipment information was detected."
                );
            }

            return new ContentValidationResult(
                    -20,
                    false,
                    "Expected machinery or equipment information was not clearly detected."
            );
        }


        /*
         * ============================================================
         * ELECTRICAL
         * ============================================================
         */
        if ("ELECTRICAL_LAYOUT"
                .equals(type)
                ||
                "ELECTRICITY_DOCUMENT"
                .equals(type)
                ||
                "TEST_CERTIFICATE"
                .equals(type)) {

            if (containsAny(
                    upper,
                    "ELECTRICAL",
                    "ELECTRICITY",
                    "VOLTAGE",
                    "LOAD",
                    "KW",
                    "KVA",
                    "TEST CERTIFICATE"
            )) {

                return new ContentValidationResult(
                        0,
                        true,
                        "Electrical-related information was detected."
                );
            }

            return new ContentValidationResult(
                    -20,
                    false,
                    "Expected electrical or test information was not clearly detected."
            );
        }


        /*
         * ============================================================
         * PROJECT REPORT
         * ============================================================
         */
        if ("PROJECT_REPORT"
                .equals(type)) {

            if (containsAny(
                    upper,
                    "PROJECT",
                    "INVESTMENT",
                    "CAPACITY",
                    "EMPLOYMENT",
                    "PROCESS",
                    "COST"
            )) {

                return new ContentValidationResult(
                        0,
                        true,
                        "Project-report information was detected."
                );
            }

            return new ContentValidationResult(
                    -20,
                    false,
                    "Expected project-report information was not clearly detected."
            );
        }


        /*
         * ============================================================
         * GENERIC READABLE DOCUMENT
         * ============================================================
         */

        int wordCount =
                countWords(
                        content
                );

        if (wordCount >= 20) {

            return new ContentValidationResult(
                    -5,
                    false,
                    "The PDF contains readable content, but this document type does not yet have a specialised semantic validator."
            );
        }


        return new ContentValidationResult(
                -20,
                false,
                "Very little readable content was detected in the document."
        );
    }


    private boolean containsAny(
            String content,
            String... values) {

        if (content == null) {

            return false;
        }

        for (String value : values) {

            if (value != null
                    &&
                    content.contains(
                            value.toUpperCase(
                                    Locale.ROOT
                            )
                    )) {

                return true;
            }
        }

        return false;
    }


    private int countWords(
            String content) {

        if (content == null
                ||
                content.isBlank()) {

            return 0;
        }

        return content
                .trim()
                .split("\\s+")
                .length;
    }


    /*
     * ================================================================
     * IMAGE VALIDATION
     * ================================================================
     */

    private ImageValidationResult validateImage(
            File file) {

        try {

            BufferedImage image =
                    ImageIO.read(
                            file
                    );

            if (image == null) {

                return new ImageValidationResult(
                        -50,
                        false,
                        "The image could not be decoded and may be corrupt."
                );
            }


            int width =
                    image.getWidth();

            int height =
                    image.getHeight();


            if (width <= 0
                    || height <= 0) {

                return new ImageValidationResult(
                        -50,
                        false,
                        "Invalid image dimensions detected."
                );
            }


            if (width < 600
                    ||
                    height < 600) {

                return new ImageValidationResult(
                        -20,
                        false,
                        "Image resolution is low ("
                        + width
                        + "×"
                        + height
                        + "). Text may be difficult to verify."
                );
            }


            if (width < 1000
                    ||
                    height < 1000) {

                return new ImageValidationResult(
                        -5,
                        true,
                        "Image is readable, but higher resolution may improve verification."
                );
            }


            return new ImageValidationResult(
                    0,
                    true,
                    "Image file is readable with adequate resolution."
            );


        } catch (IOException e) {

            return new ImageValidationResult(
                    -50,
                    false,
                    "Unable to read the uploaded image."
            );
        }
    }


    /*
     * ================================================================
     * MESSAGE
     * ================================================================
     */

    private String buildValidationMessage(
            List<String> positives,
            List<String> issues) {

        StringBuilder message =
                new StringBuilder();


        if (issues != null
                &&
                !issues.isEmpty()) {

            message.append(
                    String.join(
                            " ",
                            issues
                    )
            );
        }


        if ((issues == null
                || issues.isEmpty())
                &&
                positives != null
                &&
                !positives.isEmpty()) {

            message.append(
                    String.join(
                            " ",
                            positives
                    )
            );
        }


        if (message.length() == 0) {

            return "Document requires manual review.";
        }


        return message
                .toString()
                .trim();
    }


    /*
     * ================================================================
     * OVERALL SUMMARY
     * ================================================================
     */

    private ValidationSummary analyseDocuments(
            List<Map<String, Object>> documents) {

        ValidationSummary summary =
                new ValidationSummary();


        if (documents == null
                ||
                documents.isEmpty()) {

            summary.totalDocuments = 0;
            summary.readyDocuments = 0;
            summary.warningDocuments = 0;
            summary.riskDocuments = 0;
            summary.overallScore = 0;
            summary.overallStatus =
                    "NO DOCUMENTS";

            return summary;
        }


        int totalScore = 0;


        for (Map<String, Object> document
                : documents) {

            String status =
                    String.valueOf(
                            document.get(
                                    "validationStatus"
                            )
                    );

            int score =
                    ((Number)
                    document.get(
                            "validationScore"
                    ))
                    .intValue();

            totalScore += score;

            summary.totalDocuments++;


            if ("READY"
                    .equalsIgnoreCase(status)) {

                summary.readyDocuments++;

            } else if ("WARNING"
                    .equalsIgnoreCase(status)) {

                summary.warningDocuments++;

            } else {

                summary.riskDocuments++;
            }
        }


        summary.overallScore =
                totalScore
                /
                summary.totalDocuments;


        if (summary.riskDocuments > 0
                &&
                summary.overallScore < 70) {

            summary.overallStatus =
                    "HIGH RISK";

        } else if (summary.warningDocuments > 0
                ||
                summary.riskDocuments > 0) {

            summary.overallStatus =
                    "REVIEW REQUIRED";

        } else if (summary.overallScore >= 85) {

            summary.overallStatus =
                    "READY";

        } else {

            summary.overallStatus =
                    "REVIEW REQUIRED";
        }


        return summary;
    }


    /*
     * ================================================================
     * AI GUIDANCE
     * ================================================================
     */

    private String generateAIExplanation(
            ValidationSummary summary,
            List<Map<String, Object>> documents) {

        String fallback =
                buildFallbackExplanation(
                        summary
                );


        String apiKey =
                System.getenv(
                        "GEMINI_API_KEY"
                );


        if (apiKey == null
                ||
                apiKey.isBlank()) {

            return fallback;
        }


        String model =
                System.getenv(
                        "GEMINI_MODEL"
                );


        if (model == null
                ||
                model.isBlank()) {

            model =
                    "gemini-2.5-flash";
        }


        try {

            /*
             * Only validation metadata is included here.
             * Raw document text is intentionally NOT included.
             */
            StringBuilder signalSummary =
                    new StringBuilder();


            if (documents != null) {

                for (Map<String, Object> document
                        : documents) {

                    signalSummary
                            .append(
                                    "Document type: "
                            )
                            .append(
                                    document.get(
                                            "documentType"
                                    )
                            )
                            .append(
                                    ", validation status: "
                            )
                            .append(
                                    document.get(
                                            "validationStatus"
                                    )
                            )
                            .append(
                                    ", score: "
                            )
                            .append(
                                    document.get(
                                            "validationScore"
                                    )
                            )
                            .append(
                                    ". "
                            );
                }
            }


            String prompt =
                    "You are CHAPERON, a regulatory guidance assistant. "
                    + "Provide a short pre-submission document readiness explanation. "
                    + "Do not claim legal validity, authenticity, approval, or guaranteed acceptance. "
                    + "Use maximum 4 short sentences. "
                    + "Tell the entrepreneur what needs attention first. "
                    + "Total documents: "
                    + summary.totalDocuments
                    + ", ready: "
                    + summary.readyDocuments
                    + ", warnings: "
                    + summary.warningDocuments
                    + ", risks: "
                    + summary.riskDocuments
                    + ", overall score: "
                    + summary.overallScore
                    + "/100. "
                    + signalSummary;


            String requestJson =
                    "{"
                    + "\"contents\":[{"
                    + "\"parts\":[{"
                    + "\"text\":\""
                    + escapeJson(prompt)
                    + "\""
                    + "}]"
                    + "}]"
                    + "}";


            String url =
                    "https://generativelanguage.googleapis.com/v1beta/models/"
                    + model
                    + ":generateContent?key="
                    + apiKey;


            HttpRequest httpRequest =
                    HttpRequest
                            .newBuilder()
                            .uri(
                                    URI.create(url)
                            )
                            .header(
                                    "Content-Type",
                                    "application/json"
                            )
                            .POST(
                                    HttpRequest
                                            .BodyPublishers
                                            .ofString(
                                                    requestJson
                                            )
                            )
                            .build();


            HttpClient client =
                    HttpClient
                            .newBuilder()
                            .build();


            HttpResponse<String> httpResponse =
                    client.send(
                            httpRequest,
                            HttpResponse
                                .BodyHandlers
                                .ofString()
                    );


            if (httpResponse.statusCode() < 200
                    ||
                    httpResponse.statusCode() >= 300) {

                return fallback;
            }


            String extracted =
                    extractGeminiText(
                            httpResponse.body()
                    );


            if (extracted == null
                    ||
                    extracted.isBlank()) {

                return fallback;
            }


            return extracted;


        } catch (Exception e) {

            return fallback;
        }
    }


    private String buildFallbackExplanation(
            ValidationSummary summary) {

        if (summary.totalDocuments == 0) {

            return "No uploaded documents are available for pre-validation. Upload the documents required for your approval journey first.";
        }


        if (summary.riskDocuments > 0) {

            return summary.riskDocuments
                    + " document(s) contain high-risk validation signals. "
                    + "Review unreadable, expired, rejected, missing or mismatched documents before submission.";
        }


        if (summary.warningDocuments > 0) {

            return summary.warningDocuments
                    + " document(s) require review before submission. "
                    + "CHAPERON detected content, quality or validity signals that should be checked.";
        }


        return "No major machine-detectable issue was found in the currently analysed documents. Final document acceptance remains with the concerned authority.";
    }


    /*
     * ================================================================
     * GEMINI RESPONSE
     * ================================================================
     */

    private String extractGeminiText(
            String responseBody) {

        if (responseBody == null
                ||
                responseBody.isBlank()) {

            return null;
        }


        String marker =
                "\"text\":";


        int position =
                responseBody.indexOf(
                        marker
                );


        if (position < 0) {

            return null;
        }


        int startQuote =
                responseBody.indexOf(
                        '"',
                        position
                        + marker.length()
                );


        if (startQuote < 0) {

            return null;
        }


        StringBuilder value =
                new StringBuilder();


        boolean escaped =
                false;


        for (
                int i = startQuote + 1;
                i < responseBody.length();
                i++
        ) {

            char character =
                    responseBody.charAt(i);


            if (escaped) {

                switch (character) {

                    case 'n':
                    case 'r':
                    case 't':
                        value.append(' ');
                        break;

                    case '"':
                        value.append('"');
                        break;

                    case '\\':
                        value.append('\\');
                        break;

                    default:
                        value.append(character);
                }

                escaped = false;

                continue;
            }


            if (character == '\\') {

                escaped = true;

                continue;
            }


            if (character == '"') {

                break;
            }


            value.append(
                    character
            );
        }


        return value
                .toString()
                .trim();
    }


    private String escapeJson(
            String text) {

        if (text == null) {

            return "";
        }


        return text
                .replace(
                        "\\",
                        "\\\\"
                )
                .replace(
                        "\"",
                        "\\\""
                )
                .replace(
                        "\n",
                        "\\n"
                )
                .replace(
                        "\r",
                        "\\r"
                );
    }


    /*
     * ================================================================
     * RESULT CLASSES
     * ================================================================
     */

    private static class DocumentCheck {

        private final int score;

        private final String status;

        private final String message;

        private final boolean contentVerified;


        private DocumentCheck(
                int score,
                String status,
                String message,
                boolean contentVerified) {

            this.score =
                    score;

            this.status =
                    status;

            this.message =
                    message;

            this.contentVerified =
                    contentVerified;
        }
    }


    private static class ContentValidationResult {

        private final int scoreAdjustment;

        private final boolean contentVerified;

        private final String message;


        private ContentValidationResult(
                int scoreAdjustment,
                boolean contentVerified,
                String message) {

            this.scoreAdjustment =
                    scoreAdjustment;

            this.contentVerified =
                    contentVerified;

            this.message =
                    message;
        }
    }


    private static class ImageValidationResult {

        private final int scoreAdjustment;

        private final boolean valid;

        private final String message;


        private ImageValidationResult(
                int scoreAdjustment,
                boolean valid,
                String message) {

            this.scoreAdjustment =
                    scoreAdjustment;

            this.valid =
                    valid;

            this.message =
                    message;
        }
    }


    private static class ValidationSummary {

        private int totalDocuments;

        private int readyDocuments;

        private int warningDocuments;

        private int riskDocuments;

        private int overallScore;

        private String overallStatus;
    }
}