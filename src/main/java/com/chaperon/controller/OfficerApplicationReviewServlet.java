package com.chaperon.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.chaperon.model.DocumentReadiness;
import com.chaperon.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/officer/application-review")
public class OfficerApplicationReviewServlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;


    /*
     * ==========================================
     * APPLICATION
     * ==========================================
     */

    private static final String FIND_APPLICATION =

            "SELECT " +

            "ap.application_id, " +
            "ap.application_number, " +
            "ap.user_id, " +
            "ap.business_id, " +
            "ap.approval_id, " +
            "ap.department_id, " +
            "ap.assigned_officer_id, " +
            "ap.submission_date, " +
            "ap.current_status, " +
            "ap.sla_days, " +
            "ap.expected_completion_date, " +
            "ap.risk_level, " +
            "ap.officer_remarks, " +
            "ap.rejection_reason, " +
            "ap.can_reapply, " +
            "ap.created_at, " +

            "u.full_name AS applicant_name, " +
            "u.email AS applicant_email, " +
            "u.mobile AS applicant_mobile, " +

            "b.business_name, " +
            "b.business_constitution, " +
            "b.business_activity, " +
            "b.industry, " +
            "b.state, " +
            "b.district, " +
            "b.taluka, " +
            "b.industrial_area, " +
            "b.pin_code, " +
            "b.project_stage, " +
            "b.investment_amount, " +
            "b.annual_turnover, " +
            "b.interstate_supply, " +
            "b.employee_count, " +
            "b.pollution_category, " +
            "b.hazardous_material, " +
            "b.boiler_used, " +
            "b.industrial_waste, " +
            "b.groundwater_required, " +
            "b.handles_personal_data, " +
            "b.seeks_stpi_benefits, " +
            "b.located_in_sez, " +
            "b.cert_in_applicable, " +
            "b.seeks_trademark_protection, " +
            "b.seeks_software_copyright, " +

            "a.approval_name, " +
            "a.approval_code, " +
            "a.description AS approval_description, " +
            "a.inspection_required, " +
            "a.validity_type, " +
            "a.validity_value, " +
            "a.renewal_required, " +

            "d.department_name " +

            "FROM applications ap " +

            "JOIN users u " +
            "ON ap.user_id = u.user_id " +

            "JOIN businesses b " +
            "ON ap.business_id = b.business_id " +

            "JOIN approvals a " +
            "ON ap.approval_id = a.approval_id " +

            "JOIN departments d " +
            "ON ap.department_id = d.department_id " +

            "WHERE ap.application_id = ? " +

            "LIMIT 1";


    /*
     * ==========================================
     * DOCUMENTS
     * ==========================================
     */

    private static final String FIND_DOCUMENTS =

            "SELECT " +

            "adr.document_type, " +
            "adr.description, " +
            "adr.mandatory, " +

            "doc.document_id, " +
            "doc.original_file_name, " +
            "doc.verification_status " +

            "FROM approval_document_requirements adr " +

            "LEFT JOIN documents doc " +

            "ON doc.document_id = (" +

                "SELECT d2.document_id " +
                "FROM documents d2 " +
                "WHERE d2.business_id = ? " +
                "AND d2.document_type = adr.document_type " +
                "AND d2.active = 1 " +
                "ORDER BY d2.upload_date DESC " +
                "LIMIT 1" +

            ") " +

            "WHERE adr.approval_id = ? " +
            "AND adr.active = 1 " +

            "ORDER BY adr.mandatory DESC, adr.requirement_id";


    /*
     * ==========================================
     * LATEST QUERY
     * ==========================================
     */

    private static final String FIND_LATEST_QUERY =

            "SELECT " +

            "query_id, " +
            "query_description, " +
            "raised_date, " +
            "response_deadline, " +
            "status, " +
            "entrepreneur_response, " +
            "responded_at, " +
            "resolved_at " +

            "FROM application_queries " +

            "WHERE application_id = ? " +

            "ORDER BY query_id DESC " +

            "LIMIT 1";


    /*
     * ==========================================
     * LATEST INSPECTION
     * ==========================================
     */

    private static final String FIND_LATEST_INSPECTION =

            "SELECT " +

            "inspection_id, " +
            "inspection_type, " +
            "department_id, " +
            "officer_profile_id, " +
            "inspection_date, " +
            "inspection_time, " +
            "location, " +
            "remarks, " +
            "status, " +
            "result, " +
            "inspection_notes, " +
            "recommendation, " +
            "created_at, " +
            "updated_at " +

            "FROM inspections " +

            "WHERE application_id = ? " +

            "ORDER BY inspection_id DESC " +

            "LIMIT 1";


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {


        /*
         * ==========================================
         * SESSION
         * ==========================================
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
                            session.getAttribute("userRole")
                    )
            )) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/officer-login"
            );

            return;
        }


        String applicationIdText =
                request.getParameter("id");

        if (applicationIdText == null ||
            applicationIdText.isBlank()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Application ID is required."
            );

            return;
        }


        try {

            long applicationId =
                    Long.parseLong(
                            applicationIdText
                    );

            long officerDepartmentId =
                    ((Number)
                    session.getAttribute(
                            "departmentId"
                    )).longValue();

            long officerProfileId =
                    ((Number)
                    session.getAttribute(
                            "officerProfileId"
                    )).longValue();


            long businessId;
            long approvalId;


            /*
             * ==========================================
             * APPLICATION LOAD
             * ==========================================
             */

            try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(
                                FIND_APPLICATION
                        )
            ) {

                statement.setLong(
                        1,
                        applicationId
                );

                try (
                    ResultSet rs =
                            statement.executeQuery()
                ) {

                    if (!rs.next()) {

                        response.sendError(
                                HttpServletResponse.SC_NOT_FOUND,
                                "Application not found."
                        );

                        return;
                    }


                    long applicationDepartmentId =
                            rs.getLong(
                                    "department_id"
                            );


                    if (applicationDepartmentId
                            != officerDepartmentId) {

                        response.sendError(
                                HttpServletResponse.SC_FORBIDDEN,
                                "You are not authorized to review this application."
                        );

                        return;
                    }


                    long assignedOfficer =
                            rs.getLong(
                                    "assigned_officer_id"
                            );


                    if (!rs.wasNull() &&
                        assignedOfficer
                                != officerProfileId) {

                        response.sendError(
                                HttpServletResponse.SC_FORBIDDEN,
                                "This application is assigned to another officer."
                        );

                        return;
                    }


                    businessId =
                            rs.getLong(
                                    "business_id"
                            );


                    approvalId =
                            rs.getLong(
                                    "approval_id"
                            );


                    /*
                     * Application
                     */

                    request.setAttribute(
                            "applicationId",
                            rs.getLong(
                                    "application_id"
                            )
                    );

                    request.setAttribute(
                            "applicationNumber",
                            rs.getString(
                                    "application_number"
                            )
                    );

                    request.setAttribute(
                            "submissionDate",
                            rs.getTimestamp(
                                    "submission_date"
                            )
                    );

                    request.setAttribute(
                            "currentStatus",
                            rs.getString(
                                    "current_status"
                            )
                    );

                    request.setAttribute(
                            "slaDays",
                            rs.getObject(
                                    "sla_days"
                            )
                    );

                    request.setAttribute(
                            "expectedCompletionDate",
                            rs.getDate(
                                    "expected_completion_date"
                            )
                    );

                    request.setAttribute(
                            "riskLevel",
                            rs.getString(
                                    "risk_level"
                            )
                    );

                    request.setAttribute(
                            "officerRemarks",
                            rs.getString(
                                    "officer_remarks"
                            )
                    );

                    request.setAttribute(
                            "rejectionReason",
                            rs.getString(
                                    "rejection_reason"
                            )
                    );

                    request.setAttribute(
                            "canReapply",
                            rs.getBoolean(
                                    "can_reapply"
                            )
                    );


                    /*
                     * Applicant
                     */

                    request.setAttribute(
                            "applicantName",
                            rs.getString(
                                    "applicant_name"
                            )
                    );

                    request.setAttribute(
                            "applicantEmail",
                            rs.getString(
                                    "applicant_email"
                            )
                    );

                    request.setAttribute(
                            "applicantMobile",
                            rs.getString(
                                    "applicant_mobile"
                            )
                    );


                    /*
                     * Business
                     */

                    request.setAttribute(
                            "businessName",
                            rs.getString(
                                    "business_name"
                            )
                    );

                    request.setAttribute(
                            "businessConstitution",
                            rs.getString(
                                    "business_constitution"
                            )
                    );

                    request.setAttribute(
                            "businessActivity",
                            rs.getString(
                                    "business_activity"
                            )
                    );

                    request.setAttribute(
                            "industry",
                            rs.getString(
                                    "industry"
                            )
                    );

                    request.setAttribute(
                            "state",
                            rs.getString(
                                    "state"
                            )
                    );

                    request.setAttribute(
                            "district",
                            rs.getString(
                                    "district"
                            )
                    );

                    request.setAttribute(
                            "taluka",
                            rs.getString(
                                    "taluka"
                            )
                    );

                    request.setAttribute(
                            "industrialArea",
                            rs.getString(
                                    "industrial_area"
                            )
                    );

                    request.setAttribute(
                            "pinCode",
                            rs.getString(
                                    "pin_code"
                            )
                    );

                    request.setAttribute(
                            "projectStage",
                            rs.getString(
                                    "project_stage"
                            )
                    );

                    request.setAttribute(
                            "investmentAmount",
                            rs.getObject(
                                    "investment_amount"
                            )
                    );

                    request.setAttribute(
                            "annualTurnover",
                            rs.getObject("annual_turnover")
                    );

                    request.setAttribute(
                            "interstateSupply",
                            rs.getBoolean("interstate_supply")
                    );

                    request.setAttribute(
                            "employeeCount",
                            rs.getInt(
                                    "employee_count"
                            )
                    );

                    request.setAttribute(
                            "pollutionCategory",
                            rs.getString(
                                    "pollution_category"
                            )
                    );

                    request.setAttribute(
                            "hazardousMaterial",
                            rs.getBoolean(
                                    "hazardous_material"
                            )
                    );

                    request.setAttribute(
                            "boilerUsed",
                            rs.getBoolean(
                                    "boiler_used"
                            )
                    );

                    request.setAttribute(
                            "industrialWaste",
                            rs.getBoolean(
                                    "industrial_waste"
                            )
                    );

                    request.setAttribute(
                            "groundwaterRequired",
                            rs.getBoolean(
                                    "groundwater_required"
                            )
                    );

                    request.setAttribute(
                            "handlesPersonalData",
                            rs.getBoolean("handles_personal_data")
                    );

                    request.setAttribute(
                            "seeksStpiBenefits",
                            rs.getBoolean("seeks_stpi_benefits")
                    );

                    request.setAttribute(
                            "locatedInSez",
                            rs.getBoolean("located_in_sez")
                    );

                    request.setAttribute(
                            "certInApplicable",
                            rs.getBoolean("cert_in_applicable")
                    );

                    request.setAttribute(
                            "seeksTrademarkProtection",
                            rs.getBoolean("seeks_trademark_protection")
                    );

                    request.setAttribute(
                            "seeksSoftwareCopyright",
                            rs.getBoolean("seeks_software_copyright")
                    );


                    /*
                     * Approval
                     */

                    request.setAttribute(
                            "approvalName",
                            rs.getString(
                                    "approval_name"
                            )
                    );

                    request.setAttribute(
                            "approvalCode",
                            rs.getString(
                                    "approval_code"
                            )
                    );

                    request.setAttribute(
                            "approvalDescription",
                            rs.getString(
                                    "approval_description"
                            )
                    );

                    request.setAttribute(
                            "inspectionRequired",
                            rs.getBoolean(
                                    "inspection_required"
                            )
                    );

                    request.setAttribute(
                            "validityType",
                            rs.getString(
                                    "validity_type"
                            )
                    );

                    request.setAttribute(
                            "validityValue",
                            rs.getObject(
                                    "validity_value"
                            )
                    );

                    request.setAttribute(
                            "renewalRequired",
                            rs.getBoolean(
                                    "renewal_required"
                            )
                    );

                    request.setAttribute(
                            "departmentName",
                            rs.getString(
                                    "department_name"
                            )
                    );
                }
            }


            /*
             * ==========================================
             * DOCUMENTS
             * ==========================================
             */

            List<DocumentReadiness> documents =
                    new ArrayList<>();

            int mandatoryTotal = 0;
            int mandatoryReady = 0;


            try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(
                                FIND_DOCUMENTS
                        )
            ) {

                statement.setLong(
                        1,
                        businessId
                );

                statement.setLong(
                        2,
                        approvalId
                );


                try (
                    ResultSet rs =
                            statement.executeQuery()
                ) {

                    while (rs.next()) {

                        DocumentReadiness document =
                                new DocumentReadiness();

                        document.setDocumentType(
                                rs.getString(
                                        "document_type"
                                )
                        );

                        document.setDescription(
                                rs.getString(
                                        "description"
                                )
                        );

                        boolean mandatory =
                                rs.getBoolean(
                                        "mandatory"
                                );

                        document.setMandatory(
                                mandatory
                        );

                        if (mandatory) {

                            mandatoryTotal++;
                        }

                        long documentId =
                                rs.getLong(
                                        "document_id"
                                );

                        if (rs.wasNull()) {

                            document.setStatus(
                                    "MISSING"
                            );

                        } else {

                            document.setUploadedDocumentId(
                                    documentId
                            );

                            document.setUploadedFileName(
                                    rs.getString(
                                            "original_file_name"
                                    )
                            );

                            String verificationStatus =
                                    rs.getString(
                                            "verification_status"
                                    );

                            if ("REJECTED"
                                    .equalsIgnoreCase(
                                            verificationStatus
                                    )) {

                                document.setStatus(
                                        "REJECTED"
                                );

                            } else if (
                                    "EXPIRED"
                                    .equalsIgnoreCase(
                                            verificationStatus
                                    )
                            ) {

                                document.setStatus(
                                        "EXPIRED"
                                );

                            } else {

                                document.setStatus(
                                        "READY"
                                );

                                if (mandatory) {

                                    mandatoryReady++;
                                }
                            }
                        }

                        documents.add(
                                document
                        );
                    }
                }
            }


            int readinessPercentage;

            if (mandatoryTotal == 0) {

                readinessPercentage =
                        100;

            } else {

                readinessPercentage =
                        (mandatoryReady * 100)
                        / mandatoryTotal;
            }


            request.setAttribute(
                    "documents",
                    documents
            );

            request.setAttribute(
                    "readinessPercentage",
                    readinessPercentage
            );


            /*
             * ==========================================
             * QUERY
             * ==========================================
             */

            loadLatestQuery(
                    applicationId,
                    request
            );


            /*
             * ==========================================
             * INSPECTION
             * ==========================================
             */

            loadLatestInspection(
                    applicationId,
                    request
            );


            /*
             * ==========================================
             * JSP
             * ==========================================
             */

            request.getRequestDispatcher(
                    "/WEB-INF/views/officer/officer-application-review.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid application ID."
            );

        } catch (SQLException e) {

            log(
                    "Unable to load officer application review.",
                    e
            );

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load application review."
            );
        }
    }


    /*
     * ==========================================
     * QUERY LOAD
     * ==========================================
     */

    private void loadLatestQuery(
            long applicationId,
            HttpServletRequest request
    ) throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            FIND_LATEST_QUERY
                    )
        ) {

            statement.setLong(
                    1,
                    applicationId
            );

            try (
                ResultSet rs =
                        statement.executeQuery()
            ) {

                if (rs.next()) {

                    request.setAttribute(
                            "queryId",
                            rs.getLong(
                                    "query_id"
                            )
                    );

                    request.setAttribute(
                            "queryDescription",
                            rs.getString(
                                    "query_description"
                            )
                    );

                    request.setAttribute(
                            "queryRaisedDate",
                            rs.getTimestamp(
                                    "raised_date"
                            )
                    );

                    request.setAttribute(
                            "queryResponseDeadline",
                            rs.getDate(
                                    "response_deadline"
                            )
                    );

                    request.setAttribute(
                            "queryStatus",
                            rs.getString(
                                    "status"
                            )
                    );

                    request.setAttribute(
                            "entrepreneurResponse",
                            rs.getString(
                                    "entrepreneur_response"
                            )
                    );

                    request.setAttribute(
                            "queryRespondedAt",
                            rs.getTimestamp(
                                    "responded_at"
                            )
                    );

                    request.setAttribute(
                            "queryResolvedAt",
                            rs.getTimestamp(
                                    "resolved_at"
                            )
                    );

                } else {

                    request.setAttribute(
                            "queryId",
                            null
                    );
                }
            }
        }
    }


    /*
     * ==========================================
     * INSPECTION LOAD
     * ==========================================
     */

    private void loadLatestInspection(
            long applicationId,
            HttpServletRequest request
    ) throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            FIND_LATEST_INSPECTION
                    )
        ) {

            statement.setLong(
                    1,
                    applicationId
            );

            try (
                ResultSet rs =
                        statement.executeQuery()
            ) {

                if (rs.next()) {

                    request.setAttribute(
                            "inspectionId",
                            rs.getLong(
                                    "inspection_id"
                            )
                    );

                    request.setAttribute(
                            "inspectionType",
                            rs.getString(
                                    "inspection_type"
                            )
                    );

                    request.setAttribute(
                            "inspectionDate",
                            rs.getDate(
                                    "inspection_date"
                            )
                    );

                    request.setAttribute(
                            "inspectionTime",
                            rs.getTime(
                                    "inspection_time"
                            )
                    );

                    request.setAttribute(
                            "inspectionLocation",
                            rs.getString(
                                    "location"
                            )
                    );

                    request.setAttribute(
                            "inspectionRemarks",
                            rs.getString(
                                    "remarks"
                            )
                    );

                    request.setAttribute(
                            "inspectionStatus",
                            rs.getString(
                                    "status"
                            )
                    );

                    request.setAttribute(
                            "inspectionResult",
                            rs.getString(
                                    "result"
                            )
                    );

                    request.setAttribute(
                            "inspectionNotes",
                            rs.getString(
                                    "inspection_notes"
                            )
                    );

                    request.setAttribute(
                            "inspectionRecommendation",
                            rs.getString(
                                    "recommendation"
                            )
                    );

                } else {

                    request.setAttribute(
                            "inspectionId",
                            null
                    );
                }
            }
        }
    }
}
