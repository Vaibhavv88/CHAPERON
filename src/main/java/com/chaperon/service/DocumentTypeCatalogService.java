package com.chaperon.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Set;

import com.chaperon.util.DBConnection;

public class DocumentTypeCatalogService {

    /*
     * Normal approval document requirements.
     *
     * JOIN intentionally removed so that every active document
     * requirement is loaded even if approval master data contains
     * an unexpected active-status value.
     */
    private static final String INDUSTRIAL_DOCUMENT_SQL =
            "SELECT DISTINCT document_type " +
            "FROM approval_document_requirements " +
            "WHERE active = 1 " +
            "AND document_type IS NOT NULL " +
            "AND TRIM(document_type) <> '' " +
            "ORDER BY document_type";

    /*
     * Applicant-side unified clearance requirements.
     */
    private static final String CLEARANCE_DOCUMENT_SQL =
            "SELECT DISTINCT " +
            "ct.clearance_name, " +
            "cr.requirement_name " +
            "FROM clearance_requirements cr " +
            "JOIN clearance_types ct " +
            "ON ct.clearance_type_id = cr.clearance_type_id " +
            "WHERE cr.active = 1 " +
            "AND ct.active = 1 " +
            "AND UPPER(cr.responsible_role) = 'APPLICANT' " +
            "AND cr.requirement_name IS NOT NULL " +
            "AND TRIM(cr.requirement_name) <> '' " +
            "ORDER BY ct.clearance_name, cr.requirement_name";

    /*
     * Guaranteed fallback types.
     *
     * These options remain available even if a database query
     * fails or a requirement has not yet been inserted.
     */
    private static final Map<String, String>
            CORE_DOCUMENTS =
            new LinkedHashMap<>();

    private static final Map<String, String>
            INDUSTRIAL_FALLBACK_DOCUMENTS =
            new LinkedHashMap<>();

    static {

        /*
         * Core business documents.
         */
        add(
                CORE_DOCUMENTS,
                "PAN",
                "PAN"
        );

        add(
                CORE_DOCUMENTS,
                "AADHAAR",
                "Aadhaar"
        );

        add(
                CORE_DOCUMENTS,
                "ID_PROOF",
                "Identity Proof"
        );

        add(
                CORE_DOCUMENTS,
                "ADDRESS_PROOF",
                "Address Proof"
        );

        add(
                CORE_DOCUMENTS,
                "BUSINESS_REGISTRATION",
                "Business Registration"
        );

        add(
                CORE_DOCUMENTS,
                "BUSINESS_ADDRESS_PROOF",
                "Business Address Proof"
        );

        add(
                CORE_DOCUMENTS,
                "CONSTITUTION_PROOF",
                "Business Constitution Proof"
        );

        add(
                CORE_DOCUMENTS,
                "AUTHORIZED_SIGNATORY_PROOF",
                "Authorized Signatory Proof"
        );

        add(
                CORE_DOCUMENTS,
                "AUTHORIZATION",
                "Authorization Letter"
        );

        add(
                CORE_DOCUMENTS,
                "BANK_PROOF",
                "Bank Proof"
        );

        add(
                CORE_DOCUMENTS,
                "PREMISES_PROOF",
                "Premises Proof"
        );

        add(
                CORE_DOCUMENTS,
                "LAND_DOCUMENT",
                "Land Document"
        );

        add(
                CORE_DOCUMENTS,
                "GST_DETAILS",
                "GST Details"
        );

        add(
                CORE_DOCUMENTS,
                "GST_CERTIFICATE",
                "GST Certificate"
        );

        add(
                CORE_DOCUMENTS,
                "UDYAM_CERTIFICATE",
                "Udyam / MSME Certificate"
        );

        /*
         * Factory and manufacturing.
         */
        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "FACTORY_LAYOUT",
                "Factory Layout"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "MACHINERY_DETAILS",
                "Machinery Details"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "PROCESS_FLOW",
                "Process Flow"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "PRODUCT_DETAILS",
                "Product Details"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "PROJECT_REPORT",
                "Project Report"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "PROJECT_DETAILS",
                "Project Details"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "TECHNICAL_STAFF_DETAILS",
                "Technical Staff Details"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "TECHNICAL_SPECIFICATION",
                "Technical Specification"
        );

        /*
         * Building.
         */
        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "BUILDING_PLAN",
                "Building Plan"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "SITE_PLAN",
                "Site Plan"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "LAYOUT_PLAN",
                "Layout Plan"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "STRUCTURAL_DRAWING",
                "Structural Drawing"
        );

        /*
         * Boiler registration.
         */
        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "BOILER_DETAILS",
                "Boiler Details"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "INSTALLATION_DETAILS",
                "Installation Details"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "TEST_CERTIFICATE",
                "Test Certificate"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "BOILER_CERTIFICATE",
                "Boiler Certificate"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "BOILER_DRAWING",
                "Boiler Drawing"
        );

        /*
         * Electrical safety.
         */
        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "ELECTRICAL_LAYOUT",
                "Electrical Layout"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "ELECTRICITY_DOCUMENT",
                "Electricity Document"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "ELECTRICAL_TEST_CERTIFICATE",
                "Electrical Test Certificate"
        );

        /*
         * Fire NOC.
         */
        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "FIRE_LAYOUT",
                "Fire Layout"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "FIRE_FIGHTING_EQUIPMENT_DETAILS",
                "Fire-Fighting Equipment Details"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "FIRE_SAFETY_PLAN",
                "Fire Safety Plan"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "FIRE_NOC_COPY",
                "Fire NOC Copy"
        );

        /*
         * FSSAI.
         */
        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "FORM_B",
                "Form B"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "FOOD_PRODUCT_LIST",
                "Food Product List"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "WATER_ANALYSIS_REPORT",
                "Water Analysis Report"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "FSMS_PLAN",
                "Food Safety Management System Plan"
        );

        /*
         * Pollution, CTE and CTO.
         */
        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "POLLUTION_DOCUMENT",
                "Pollution Document"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "ENVIRONMENT_REPORT",
                "Environment Report"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "CTE_CERTIFICATE",
                "Consent to Establish Certificate"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "POLLUTION_CONTROL_DETAILS",
                "Pollution-Control Details"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "WASTE_EFFLUENT_DETAILS",
                "Waste and Effluent Details"
        );

        /*
         * Groundwater NOC.
         */
        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "WATER_ABSTRACTION_DETAILS",
                "Water Abstraction Details"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "WATER_REQUIREMENT",
                "Water Requirement"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "GROUNDWATER_NOC",
                "Groundwater NOC"
        );

        /*
         * Hazardous waste.
         */
        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "WASTE_DETAILS",
                "Waste Details"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "WASTE_MANAGEMENT_PLAN",
                "Waste Management Plan"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "HAZARDOUS_WASTE_DETAILS",
                "Hazardous Waste Details"
        );

        /*
         * Legal metrology.
         */
        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "COMMODITY_DETAILS",
                "Commodity Details"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "SAMPLE_LABEL",
                "Sample Product Label"
        );

        /*
         * Plastic EPR.
         */
        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "COMPANY_DETAILS",
                "Company Details"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "PACKAGING_QUANTITY",
                "Packaging Quantity"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "PLASTIC_PACKAGING_DETAILS",
                "Plastic Packaging Details"
        );

        /*
         * Labour and establishments.
         */
        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "EMPLOYEE_DETAILS",
                "Employee Details"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "LABOUR_DOCUMENT",
                "Labour Document"
        );

        /*
         * General supporting documents.
         */
        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "SUPPORTING_DOCUMENT",
                "Supporting Document"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "UNDERTAKING",
                "Undertaking"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "DECLARATION",
                "Declaration"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "AFFIDAVIT",
                "Affidavit"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "NOC",
                "No Objection Certificate"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "CERTIFICATE",
                "Other Certificate"
        );

        add(
                INDUSTRIAL_FALLBACK_DOCUMENTS,
                "OTHER",
                "Other Document"
        );
    }

    public Map<String, Map<String, String>>
            getGroupedDocumentTypes()
            throws SQLException {

        Map<String, Map<String, String>>
                groups =
                new LinkedHashMap<>();

        groups.put(
                "Core Business Documents",
                new LinkedHashMap<>(
                        CORE_DOCUMENTS
                )
        );

        /*
         * Start with fallback options.
         */
        Map<String, String>
                industrialDocuments =
                new LinkedHashMap<>(
                        INDUSTRIAL_FALLBACK_DOCUMENTS
                );

        /*
         * Merge exact current database types.
         */
        loadIndustrialDocuments(
                industrialDocuments
        );

        groups.put(
                "Industrial Approval Documents",
                industrialDocuments
        );

        /*
         * Environmental, Forest, Wildlife and CRZ groups.
         */
        loadClearanceDocuments(
                groups
        );

        return groups;
    }

    public Set<String> getAllowedDocumentTypes()
            throws SQLException {

        Set<String> allowedTypes =
                new LinkedHashSet<>();

        Map<String, Map<String, String>> groups =
                getGroupedDocumentTypes();

        for (Map<String, String> options
                : groups.values()) {

            if (options != null) {

                allowedTypes.addAll(
                        options.keySet()
                );
            }
        }

        return allowedTypes;
    }

    public boolean isAllowedDocumentType(
            String documentType
    ) throws SQLException {

        String normalized =
                normalizeDocumentCode(
                        documentType
                );

        return normalized != null
                && !normalized.isBlank()
                && getAllowedDocumentTypes()
                        .contains(normalized);
    }

    private void loadIndustrialDocuments(
            Map<String, String>
                    industrialDocuments
    ) throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            INDUSTRIAL_DOCUMENT_SQL
                    );

            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            while (resultSet.next()) {

                String documentType =
                        normalizeDocumentCode(
                                resultSet.getString(
                                        "document_type"
                                )
                        );

                if (documentType == null ||
                        documentType.isBlank()) {

                    continue;
                }

                industrialDocuments.putIfAbsent(
                        documentType,
                        createReadableLabel(
                                documentType
                        )
                );
            }
        }
    }

    private void loadClearanceDocuments(
            Map<String, Map<String, String>>
                    groups
    ) throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            CLEARANCE_DOCUMENT_SQL
                    );

            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            while (resultSet.next()) {

                String clearanceName =
                        resultSet.getString(
                                "clearance_name"
                        );

                String requirementName =
                        resultSet.getString(
                                "requirement_name"
                        );

                if (clearanceName == null ||
                        clearanceName.isBlank() ||
                        requirementName == null ||
                        requirementName.isBlank()) {

                    continue;
                }

                String groupName =
                        clearanceName.trim()
                                + " Documents";

                Map<String, String> options =
                        groups.computeIfAbsent(
                                groupName,
                                ignored ->
                                        new LinkedHashMap<>()
                        );

                String documentCode =
                        normalizeDocumentCode(
                                requirementName
                        );

                if (documentCode == null ||
                        documentCode.isBlank()) {

                    continue;
                }

                options.putIfAbsent(
                        documentCode,
                        requirementName.trim()
                );
            }
        }
    }

    public String normalizeDocumentCode(
            String value
    ) {

        if (value == null) {
            return null;
        }

        String normalized =
                value.trim()
                        .toUpperCase()
                        .replace('&', ' ')
                        .replace('/', ' ')
                        .replace('-', ' ')
                        .replaceAll(
                                "[^A-Z0-9 ]",
                                " "
                        )
                        .replaceAll(
                                "\\s+",
                                "_"
                        )
                        .replaceAll(
                                "_+",
                                "_"
                        );

        while (normalized.startsWith("_")) {

            normalized =
                    normalized.substring(1);
        }

        while (normalized.endsWith("_")) {

            normalized =
                    normalized.substring(
                            0,
                            normalized.length() - 1
                    );
        }

        if (normalized.length() > 100) {

            normalized =
                    normalized.substring(
                            0,
                            100
                    );
        }

        return normalized;
    }

    public String createReadableLabel(
            String documentCode
    ) {

        if (documentCode == null ||
                documentCode.isBlank()) {

            return "Document";
        }

        String[] words =
                documentCode
                        .toLowerCase()
                        .split("_");

        StringBuilder label =
                new StringBuilder();

        for (String word : words) {

            if (word.isBlank()) {
                continue;
            }

            if (label.length() > 0) {
                label.append(' ');
            }

            if ("pan".equals(word)) {

                label.append("PAN");

            } else if ("gst".equals(word)) {

                label.append("GST");

            } else if ("fssai".equals(word)) {

                label.append("FSSAI");

            } else if ("noc".equals(word)) {

                label.append("NOC");

            } else if ("cte".equals(word)) {

                label.append("CTE");

            } else if ("cto".equals(word)) {

                label.append("CTO");

            } else if ("eia".equals(word)) {

                label.append("EIA");

            } else if ("crz".equals(word)) {

                label.append("CRZ");

            } else if ("kml".equals(word)) {

                label.append("KML");

            } else if ("dgps".equals(word)) {

                label.append("DGPS");

            } else if ("npv".equals(word)) {

                label.append("NPV");

            } else if ("msme".equals(word)) {

                label.append("MSME");

            } else {

                label.append(
                        Character.toUpperCase(
                                word.charAt(0)
                        )
                );

                if (word.length() > 1) {

                    label.append(
                            word.substring(1)
                    );
                }
            }
        }

        return label.toString();
    }

    private static void add(
            Map<String, String> map,
            String documentCode,
            String displayName
    ) {

        map.put(
                documentCode,
                displayName
        );
    }
}