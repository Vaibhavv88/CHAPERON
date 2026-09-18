package com.chaperon.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Locale;

import com.chaperon.service.ChatbotService;
import com.chaperon.service.impl.ChatbotServiceImpl;
import com.chaperon.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cera/chat")
public class CeraChatServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ChatbotService chatbotService =
            new ChatbotServiceImpl();


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        response.getWriter().write(
                "{"
                + "\"status\":\"online\","
                + "\"name\":\"CERA\","
                + "\"message\":\"CHAPERON Regulatory Assistant is ready.\""
                + "}"
        );
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");


        String message =
                request.getParameter("message");


        if (message == null
                || message.isBlank()) {

            sendJson(
                    response,
                    false,
                    "Please type a question first."
            );

            return;
        }


        message = message.trim();


        if (message.length() > 2000) {

            sendJson(
                    response,
                    false,
                    "Your question is too long. Please ask a shorter question."
            );

            return;
        }


        HttpSession session =
                request.getSession(false);


        /*
         * ============================================================
         * LOGGED-IN ENTREPRENEUR:
         * FIRST TRY DIRECT DATABASE ANSWER
         * ============================================================
         */

        if (session != null
                && session.getAttribute("userId") != null
                && session.getAttribute("userRole") != null
                && "ENTREPRENEUR".equalsIgnoreCase(
                        String.valueOf(
                                session.getAttribute("userRole")
                        )
                )) {

            long userId =
                    ((Number)
                    session.getAttribute("userId"))
                    .longValue();


            try {

                String directAnswer =
                        getDirectDatabaseAnswer(
                                userId,
                                message
                        );


                if (directAnswer != null
                        && !directAnswer.isBlank()) {

                    sendJson(
                            response,
                            true,
                            directAnswer
                    );

                    return;
                }

            } catch (Exception e) {

                System.out.println(
                        "================ CERA DIRECT DB ERROR ================"
                );

                e.printStackTrace();

                System.out.println(
                        "======================================================"
                );
            }
        }


        /*
         * ============================================================
         * GENERAL QUESTION -> GEMINI
         * ============================================================
         */

        String userContext =
                buildGeneralContext(
                        session
                );


        String answer =
                chatbotService.askCera(
                        message,
                        userContext
                );


        sendJson(
                response,
                true,
                answer
        );
    }


    /*
     * ================================================================
     * DIRECT DATABASE QUESTION ROUTER
     * ================================================================
     */

    private String getDirectDatabaseAnswer(
            long userId,
            String message)
            throws SQLException {

        String q =
                message.toLowerCase(
                        Locale.ROOT
                );


        /*
         * ACTIVE APPLICATION COUNT
         */
        if (
                containsAny(
                        q,
                        "active application",
                        "active applications",
                        "kitni application active",
                        "kitni applications active",
                        "meri active application",
                        "meri active applications"
                )
        ) {

            return getActiveApplicationCount(
                    userId
            );
        }


        /*
         * APPROVED APPLICATION COUNT
         */
        if (
                containsAny(
                        q,
                        "approved application",
                        "approved applications",
                        "kitni approved",
                        "approved licence",
                        "approved license",
                        "approved licenses",
                        "approved licences"
                )
        ) {

            return getApprovedApplicationCount(
                    userId
            );
        }


        /*
         * DRAFT APPLICATION COUNT
         */
        if (
                containsAny(
                        q,
                        "draft application",
                        "draft applications",
                        "kitni draft"
                )
        ) {

            return getDraftApplicationCount(
                    userId
            );
        }


        /*
         * FIRE NOC STATUS
         */
        if (
                q.contains("fire noc")
                &&
                containsAny(
                        q,
                        "status",
                        "kaha",
                        "kahaan",
                        "stage",
                        "progress"
                )
        ) {

            return getApplicationStatusByApproval(
                    userId,
                    "FIRE_NOC",
                    "Fire NOC"
            );
        }


        /*
         * FSSAI STATUS
         */
        if (
                q.contains("fssai")
                &&
                containsAny(
                        q,
                        "status",
                        "kaha",
                        "kahaan",
                        "stage",
                        "progress"
                )
        ) {

            return getApplicationStatusByApproval(
                    userId,
                    "FSSAI",
                    "FSSAI Registration / License"
            );
        }


        /*
         * FACTORY LICENCE STATUS
         */
        if (
                (q.contains("factory license")
                        || q.contains("factory licence"))
                &&
                containsAny(
                        q,
                        "status",
                        "kaha",
                        "kahaan",
                        "stage",
                        "progress"
                )
        ) {

            return getApplicationStatusByApproval(
                    userId,
                    "FACTORY_LICENSE",
                    "Factory License"
            );
        }


        /*
         * POLLUTION CONSENT STATUS
         */
        if (
                q.contains("pollution")
                &&
                containsAny(
                        q,
                        "status",
                        "kaha",
                        "kahaan",
                        "stage",
                        "progress"
                )
        ) {

            return getApplicationStatusByApproval(
                    userId,
                    "POLLUTION_CONSENT",
                    "Pollution Consent"
            );
        }


        /*
         * BOILER STATUS
         */
        if (
                q.contains("boiler")
                &&
                containsAny(
                        q,
                        "status",
                        "kaha",
                        "kahaan",
                        "stage",
                        "progress"
                )
        ) {

            return getApplicationStatusByApproval(
                    userId,
                    "BOILER_REG",
                    "Boiler Registration"
            );
        }


        /*
         * OFFICER QUERY
         */
        if (
                containsAny(
                        q,
                        "officer query",
                        "officer queries",
                        "query pending",
                        "pending query",
                        "koi query",
                        "queries pending"
                )
        ) {

            return getPendingOfficerQueries(
                    userId
            );
        }


        /*
         * DOCUMENT PROBLEMS
         */
        if (
                containsAny(
                        q,
                        "document problem",
                        "document issue",
                        "documents problem",
                        "documents issue",
                        "rejected document",
                        "expired document",
                        "mere documents me",
                        "meri document"
                )
        ) {

            return getDocumentProblems(
                    userId
            );
        }


        /*
         * INSPECTIONS
         */
        if (
                containsAny(
                        q,
                        "inspection",
                        "inspection pending",
                        "inspection scheduled",
                        "meri inspection"
                )
        ) {

            return getInspectionStatus(
                    userId
            );
        }


        /*
         * RECOMMENDED APPROVALS
         */
        if (
                containsAny(
                        q,
                        "mere approval",
                        "meri approvals",
                        "recommended approval",
                        "recommended approvals",
                        "kaunse approval",
                        "kaun sa approval",
                        "which approvals"
                )
        ) {

            return getRecommendedApprovals(
                    userId
            );
        }


        /*
         * NEXT STEP
         */
        if (
                containsAny(
                        q,
                        "next step",
                        "ab kya karu",
                        "ab kya karna",
                        "mujhe kya karna",
                        "what should i do next",
                        "what do i do next"
                )
        ) {

            return getNextStep(
                    userId
            );
        }


        /*
         * MY APPLICATIONS SUMMARY
         */
        if (
                containsAny(
                        q,
                        "meri applications",
                        "my applications",
                        "application summary",
                        "applications batao"
                )
        ) {

            return getApplicationSummary(
                    userId
            );
        }


        return null;
    }


    /*
     * ================================================================
     * ACTIVE APPLICATION COUNT
     * ================================================================
     */

    private String getActiveApplicationCount(
            long userId)
            throws SQLException {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM applications " +
                "WHERE user_id = ? " +
                "AND UPPER(current_status) NOT IN " +
                "('DRAFT','APPROVED','REJECTED')";


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
                    ResultSet rs =
                            statement.executeQuery()
            ) {

                if (rs.next()) {

                    int count =
                            rs.getInt("total");


                    if (count == 0) {

                        return "Aapki abhi koi active application nahi hai.";
                    }


                    return "Aapki "
                            + count
                            + " active application"
                            + (count == 1 ? " hai." : "s hain.")
                            + " Aap Applications section me unka live status dekh sakte hain.";
                }
            }
        }


        return "Main abhi active applications ka count confirm nahi kar pa raha hoon.";
    }


    /*
     * ================================================================
     * APPROVED COUNT
     * ================================================================
     */

    private String getApprovedApplicationCount(
            long userId)
            throws SQLException {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM applications " +
                "WHERE user_id = ? " +
                "AND UPPER(current_status) = 'APPROVED'";


        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setLong(1, userId);


            try (
                    ResultSet rs =
                            statement.executeQuery()
            ) {

                if (rs.next()) {

                    int count =
                            rs.getInt("total");


                    if (count == 0) {

                        return "Aapki abhi koi approved application nahi hai.";
                    }


                    return "Aapki "
                            + count
                            + " application"
                            + (count == 1 ? " approve ho chuki hai." : "s approve ho chuki hain.")
                            + " Approved licence/certificate details Applications section me dekh sakte hain.";
                }
            }
        }


        return "Approved applications ka count abhi confirm nahi ho pa raha hai.";
    }


    /*
     * ================================================================
     * DRAFT COUNT
     * ================================================================
     */

    private String getDraftApplicationCount(
            long userId)
            throws SQLException {

        String sql =
                "SELECT COUNT(*) AS total " +
                "FROM applications " +
                "WHERE user_id = ? " +
                "AND UPPER(current_status) = 'DRAFT'";


        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setLong(1, userId);


            try (
                    ResultSet rs =
                            statement.executeQuery()
            ) {

                if (rs.next()) {

                    int count =
                            rs.getInt("total");


                    if (count == 0) {

                        return "Aapki koi draft application pending nahi hai.";
                    }


                    return "Aapki "
                            + count
                            + " draft application"
                            + (count == 1 ? " hai." : "s hain.")
                            + " Applications section kholkar readiness check karke submit kar sakte hain.";
                }
            }
        }


        return "Draft applications ka data abhi confirm nahi ho pa raha hai.";
    }


    /*
     * ================================================================
     * APPLICATION STATUS BY APPROVAL
     * ================================================================
     */

    private String getApplicationStatusByApproval(
            long userId,
            String approvalCode,
            String displayName)
            throws SQLException {

        String sql =
                "SELECT " +
                "ap.application_number, " +
                "ap.current_status, " +
                "ap.expected_completion_date, " +
                "ap.risk_level " +
                "FROM applications ap " +
                "INNER JOIN approvals a " +
                "ON ap.approval_id = a.approval_id " +
                "WHERE ap.user_id = ? " +
                "AND UPPER(a.approval_code) = ? " +
                "ORDER BY ap.updated_at DESC, ap.application_id DESC " +
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

            statement.setString(
                    2,
                    approvalCode.toUpperCase(
                            Locale.ROOT
                    )
            );


            try (
                    ResultSet rs =
                            statement.executeQuery()
            ) {

                if (rs.next()) {

                    String status =
                            safe(
                                    rs.getString(
                                            "current_status"
                                    )
                            );

                    String applicationNumber =
                            safe(
                                    rs.getString(
                                            "application_number"
                                    )
                            );

                    String expectedDate =
                            safe(
                                    rs.getString(
                                            "expected_completion_date"
                                    )
                            );


                    StringBuilder answer =
                            new StringBuilder();


                    answer.append(
                            "Aapki "
                    );

                    answer.append(
                            displayName
                    );

                    answer.append(
                            " application ka current status "
                    );

                    answer.append(
                            status
                    );

                    answer.append(
                            " hai."
                    );


                    answer.append(
                            " Application No: "
                    );

                    answer.append(
                            applicationNumber
                    );

                    answer.append(
                            "."
                    );


                    if (!"Not available"
                            .equals(expectedDate)) {

                        answer.append(
                                " Expected completion date: "
                        );

                        answer.append(
                                expectedDate
                        );

                        answer.append(
                                "."
                        );
                    }


                    answer.append(
                            " Detailed timeline ke liye Applications section open karein."
                    );


                    return answer.toString();
                }
            }
        }


        return displayName
                + " ke liye mujhe aapke account me koi application record nahi mila. "
                + "Approval Roadmap me check karein ki ye approval aapke business ke liye recommended hai ya nahi.";
    }


    /*
     * ================================================================
     * PENDING OFFICER QUERIES
     * ================================================================
     */

    private String getPendingOfficerQueries(
            long userId)
            throws SQLException {

        String sql =
                "SELECT " +
                "q.query_description, " +
                "q.response_deadline, " +
                "a.approval_name " +
                "FROM application_queries q " +
                "INNER JOIN applications ap " +
                "ON q.application_id = ap.application_id " +
                "INNER JOIN approvals a " +
                "ON ap.approval_id = a.approval_id " +
                "WHERE ap.user_id = ? " +
                "AND UPPER(q.status) = 'OPEN' " +
                "ORDER BY q.raised_date DESC";


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
                    ResultSet rs =
                            statement.executeQuery()
            ) {

                int count = 0;

                StringBuilder details =
                        new StringBuilder();


                while (rs.next()) {

                    count++;


                    if (count <= 3) {

                        details.append(
                                "\n"
                        );

                        details.append(
                                count
                        );

                        details.append(
                                ". "
                        );

                        details.append(
                                safe(
                                        rs.getString(
                                                "approval_name"
                                        )
                                )
                        );

                        details.append(
                                " — "
                        );

                        details.append(
                                safe(
                                        rs.getString(
                                                "query_description"
                                        )
                                )
                        );


                        String deadline =
                                safe(
                                        rs.getString(
                                                "response_deadline"
                                        )
                                );


                        if (!"Not available"
                                .equals(deadline)) {

                            details.append(
                                    " (Deadline: "
                            );

                            details.append(
                                    deadline
                            );

                            details.append(
                                    ")"
                            );
                        }
                    }
                }


                if (count == 0) {

                    return "Aapki abhi koi OPEN officer query pending nahi hai.";
                }


                return "Aapki "
                        + count
                        + " officer quer"
                        + (count == 1 ? "y" : "ies")
                        + " pending "
                        + (count == 1 ? "hai:" : "hain:")
                        + details
                        + "\nApplications section me jaakar response submit karein.";
            }
        }
    }


    /*
     * ================================================================
     * DOCUMENT PROBLEMS
     * ================================================================
     */

    private String getDocumentProblems(
            long userId)
            throws SQLException {

        String sql =
                "SELECT " +
                "d.document_type, " +
                "d.verification_status, " +
                "d.expiry_date " +
                "FROM documents d " +
                "INNER JOIN businesses b " +
                "ON d.business_id = b.business_id " +
                "WHERE b.user_id = ? " +
                "AND (" +
                "UPPER(d.verification_status) IN ('REJECTED','EXPIRED') " +
                "OR (d.expiry_date IS NOT NULL AND d.expiry_date < CURDATE())" +
                ") " +
                "ORDER BY d.upload_date DESC";


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
                    ResultSet rs =
                            statement.executeQuery()
            ) {

                int count = 0;

                StringBuilder details =
                        new StringBuilder();


                while (rs.next()) {

                    count++;


                    if (count <= 5) {

                        details.append("\n");

                        details.append(count);

                        details.append(". ");

                        details.append(
                                safe(
                                        rs.getString(
                                                "document_type"
                                        )
                                )
                        );

                        details.append(
                                " — "
                        );

                        details.append(
                                safe(
                                        rs.getString(
                                                "verification_status"
                                        )
                                )
                        );
                    }
                }


                if (count == 0) {

                    return "Mujhe aapke Document Vault me koi rejected ya expired document nahi mila.";
                }


                return "Aapke "
                        + count
                        + " document"
                        + (count == 1 ? " me issue mila:" : "s me issues mile:")
                        + details
                        + "\nDocument Vault me jaakar inhe review/re-upload karein.";
            }
        }
    }


    /*
     * ================================================================
     * INSPECTION STATUS
     * ================================================================
     */

    private String getInspectionStatus(
            long userId)
            throws SQLException {

        String sql =
                "SELECT " +
                "a.approval_name, " +
                "i.inspection_type, " +
                "i.inspection_date, " +
                "i.inspection_time, " +
                "i.status, " +
                "i.result " +
                "FROM inspections i " +
                "INNER JOIN applications ap " +
                "ON i.application_id = ap.application_id " +
                "INNER JOIN approvals a " +
                "ON ap.approval_id = a.approval_id " +
                "WHERE ap.user_id = ? " +
                "ORDER BY i.inspection_date DESC, i.inspection_id DESC " +
                "LIMIT 5";


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
                    ResultSet rs =
                            statement.executeQuery()
            ) {

                if (!rs.next()) {

                    return "Aapke account me abhi koi inspection record nahi mila.";
                }


                StringBuilder answer =
                        new StringBuilder();


                answer.append(
                        "Aapki latest inspections:\n"
                );


                int number = 1;


                do {

                    answer.append(
                            number
                    );

                    answer.append(
                            ". "
                    );

                    answer.append(
                            safe(
                                    rs.getString(
                                            "approval_name"
                                    )
                            )
                    );

                    answer.append(
                            " — "
                    );

                    answer.append(
                            safe(
                                    rs.getString(
                                            "status"
                                    )
                            )
                    );

                    answer.append(
                            ", Date: "
                    );

                    answer.append(
                            safe(
                                    rs.getString(
                                            "inspection_date"
                                    )
                            )
                    );


                    String result =
                            safe(
                                    rs.getString(
                                            "result"
                                    )
                            );


                    if (!"Not available"
                            .equals(result)) {

                        answer.append(
                                ", Result: "
                        );

                        answer.append(
                                result
                        );
                    }


                    answer.append("\n");

                    number++;

                } while (
                        number <= 5
                        && rs.next()
                );


                answer.append(
                        "Full details ke liye Inspections section open karein."
                );


                return answer.toString();
            }
        }
    }


    /*
     * ================================================================
     * RECOMMENDED APPROVALS
     * ================================================================
     */

    private String getRecommendedApprovals(
            long userId)
            throws SQLException {

        long businessId =
                getLatestBusinessId(
                        userId
                );


        if (businessId <= 0) {

            return "Pehle apna Business Profile complete karein. Uske baad CHAPERON aapke business ke liye customised approvals generate karega.";
        }


        String sql =
                "SELECT " +
                "a.approval_name, " +
                "ba.current_status " +
                "FROM business_approvals ba " +
                "INNER JOIN approvals a " +
                "ON ba.approval_id = a.approval_id " +
                "WHERE ba.business_id = ? " +
                "AND a.active = 1 " +
                "ORDER BY a.approval_name";


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
                    ResultSet rs =
                            statement.executeQuery()
            ) {

                StringBuilder answer =
                        new StringBuilder();

                int count = 0;


                while (rs.next()) {

                    count++;


                    answer.append(
                            "\n"
                    );

                    answer.append(
                            count
                    );

                    answer.append(
                            ". "
                    );

                    answer.append(
                            safe(
                                    rs.getString(
                                            "approval_name"
                                    )
                            )
                    );

                    answer.append(
                            " — "
                    );

                    answer.append(
                            safe(
                                    rs.getString(
                                            "current_status"
                                    )
                            )
                    );
                }


                if (count == 0) {

                    return "Abhi aapke business ke liye koi generated approval recommendation nahi mili. Approval Roadmap generate karein.";
                }


                return "Aapke current CHAPERON roadmap me "
                        + count
                        + " approval"
                        + (count == 1 ? " hai:" : "s hain:")
                        + answer
                        + "\nDetailed requirements ke liye Approval Roadmap open karein.";
            }
        }
    }


    /*
     * ================================================================
     * APPLICATION SUMMARY
     * ================================================================
     */

    private String getApplicationSummary(
            long userId)
            throws SQLException {

        String sql =
                "SELECT " +
                "a.approval_name, " +
                "ap.current_status " +
                "FROM applications ap " +
                "INNER JOIN approvals a " +
                "ON ap.approval_id = a.approval_id " +
                "WHERE ap.user_id = ? " +
                "ORDER BY ap.updated_at DESC " +
                "LIMIT 10";


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
                    ResultSet rs =
                            statement.executeQuery()
            ) {

                StringBuilder answer =
                        new StringBuilder();

                int count = 0;


                while (rs.next()) {

                    count++;

                    answer.append("\n");

                    answer.append(count);

                    answer.append(". ");

                    answer.append(
                            safe(
                                    rs.getString(
                                            "approval_name"
                                    )
                            )
                    );

                    answer.append(
                            " — "
                    );

                    answer.append(
                            safe(
                                    rs.getString(
                                            "current_status"
                                    )
                            )
                    );
                }


                if (count == 0) {

                    return "Aapne abhi koi application create nahi ki hai. Approval Roadmap se required approval select karke application start kar sakte hain.";
                }


                return "Aapki recent applications:"
                        + answer;
            }
        }
    }


    /*
     * ================================================================
     * NEXT STEP ENGINE FOR CERA
     * ================================================================
     */

    private String getNextStep(
            long userId)
            throws SQLException {

        long businessId =
                getLatestBusinessId(
                        userId
                );


        /*
         * NO BUSINESS
         */
        if (businessId <= 0) {

            return "Aapka next step hai Business Profile complete karna. Dashboard → My Business me jaakar onboarding complete karein.";
        }


        /*
         * 1. OPEN OFFICER QUERY
         */
        String openQuerySql =
                "SELECT " +
                "a.approval_name, " +
                "q.response_deadline " +
                "FROM application_queries q " +
                "INNER JOIN applications ap " +
                "ON q.application_id = ap.application_id " +
                "INNER JOIN approvals a " +
                "ON ap.approval_id = a.approval_id " +
                "WHERE ap.user_id = ? " +
                "AND UPPER(q.status) = 'OPEN' " +
                "ORDER BY q.raised_date ASC " +
                "LIMIT 1";


        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(
                                openQuerySql
                        )
        ) {

            statement.setLong(
                    1,
                    userId
            );


            try (
                    ResultSet rs =
                            statement.executeQuery()
            ) {

                if (rs.next()) {

                    return "Aapka sabse important next step officer query ka response dena hai. "
                            + safe(
                                    rs.getString(
                                            "approval_name"
                                    )
                            )
                            + " application par OPEN query hai. Applications section me jaakar reply karein.";
                }
            }
        }


        /*
         * 2. DOCUMENT ISSUE
         */
        String documentSql =
                "SELECT d.document_type " +
                "FROM documents d " +
                "WHERE d.business_id = ? " +
                "AND (" +
                "UPPER(d.verification_status) IN ('REJECTED','EXPIRED') " +
                "OR (d.expiry_date IS NOT NULL AND d.expiry_date < CURDATE())" +
                ") " +
                "ORDER BY d.upload_date DESC " +
                "LIMIT 1";


        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(
                                documentSql
                        )
        ) {

            statement.setLong(
                    1,
                    businessId
            );


            try (
                    ResultSet rs =
                            statement.executeQuery()
            ) {

                if (rs.next()) {

                    return "Aapka next step Document Vault me "
                            + safe(
                                    rs.getString(
                                            "document_type"
                                    )
                            )
                            + " document ka issue fix karna hai. Rejected/expired document ko review karke zarurat ho to re-upload karein.";
                }
            }
        }


        /*
         * 3. DRAFT APPLICATION
         */
        String draftSql =
                "SELECT a.approval_name " +
                "FROM applications ap " +
                "INNER JOIN approvals a " +
                "ON ap.approval_id = a.approval_id " +
                "WHERE ap.user_id = ? " +
                "AND UPPER(ap.current_status) = 'DRAFT' " +
                "ORDER BY ap.updated_at ASC " +
                "LIMIT 1";


        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(
                                draftSql
                        )
        ) {

            statement.setLong(
                    1,
                    userId
            );


            try (
                    ResultSet rs =
                            statement.executeQuery()
            ) {

                if (rs.next()) {

                    return "Aapka next step "
                            + safe(
                                    rs.getString(
                                            "approval_name"
                                    )
                            )
                            + " ki draft application complete karna hai. Required documents/readiness check karke submit karein.";
                }
            }
        }


        /*
         * 4. SCHEDULED INSPECTION
         */
        String inspectionSql =
                "SELECT " +
                "a.approval_name, " +
                "i.inspection_date " +
                "FROM inspections i " +
                "INNER JOIN applications ap " +
                "ON i.application_id = ap.application_id " +
                "INNER JOIN approvals a " +
                "ON ap.approval_id = a.approval_id " +
                "WHERE ap.user_id = ? " +
                "AND UPPER(i.status) IN ('SCHEDULED','RESCHEDULED') " +
                "ORDER BY i.inspection_date ASC " +
                "LIMIT 1";


        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(
                                inspectionSql
                        )
        ) {

            statement.setLong(
                    1,
                    userId
            );


            try (
                    ResultSet rs =
                            statement.executeQuery()
            ) {

                if (rs.next()) {

                    return "Aapko upcoming "
                            + safe(
                                    rs.getString(
                                            "approval_name"
                                    )
                            )
                            + " inspection ke liye prepare karna chahiye. Inspection date "
                            + safe(
                                    rs.getString(
                                            "inspection_date"
                                    )
                            )
                            + " hai. Inspections section me details check karein.";
                }
            }
        }


        /*
         * 5. REQUIRED NOT-STARTED APPROVAL
         */
        String approvalSql =
                "SELECT a.approval_name " +
                "FROM business_approvals ba " +
                "INNER JOIN approvals a " +
                "ON ba.approval_id = a.approval_id " +
                "WHERE ba.business_id = ? " +
                "AND (ba.current_status IS NULL " +
                "OR UPPER(ba.current_status) = 'NOT_STARTED') " +
                "AND a.active = 1 " +
                "ORDER BY a.approval_id " +
                "LIMIT 1";


        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(
                                approvalSql
                        )
        ) {

            statement.setLong(
                    1,
                    businessId
            );


            try (
                    ResultSet rs =
                            statement.executeQuery()
            ) {

                if (rs.next()) {

                    return "Aapka next recommended step "
                            + safe(
                                    rs.getString(
                                            "approval_name"
                                    )
                            )
                            + " start karna hai. Approval Roadmap open karke required documents aur eligibility check karein.";
                }
            }
        }


        return "Abhi koi urgent pending action detect nahi hua. Aap Applications section me active applications track karein aur Compliance section me upcoming obligations check karte rahein.";
    }


    /*
     * ================================================================
     * LATEST BUSINESS
     * ================================================================
     */

    private long getLatestBusinessId(
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
                    ResultSet rs =
                            statement.executeQuery()
            ) {

                if (rs.next()) {

                    return rs.getLong(
                            "business_id"
                    );
                }
            }
        }


        return 0;
    }


    /*
     * ================================================================
     * GENERAL GEMINI CONTEXT
     * ================================================================
     */

    private String buildGeneralContext(
            HttpSession session) {

        if (session == null
                || session.getAttribute("userId") == null
                || session.getAttribute("userRole") == null) {

            return """
                    The user is a public visitor on CHAPERON.

                    Help them understand:
                    - CHAPERON website navigation
                    - industrial approvals
                    - licences and NOCs
                    - required documents
                    - application workflow
                    - inspections
                    - compliance
                    - renewals
                    - government schemes

                    This is general guidance only.
                    Do not claim access to private account data.
                    """;
        }


        String role =
                String.valueOf(
                        session.getAttribute(
                                "userRole"
                        )
                );


        if ("ENTREPRENEUR"
                .equalsIgnoreCase(role)) {

            return """
                    The user is a logged-in CHAPERON entrepreneur.

                    For account-specific facts, CHAPERON uses direct database queries.

                    You are currently being asked a general question.

                    Help the entrepreneur understand:
                    - how CHAPERON works
                    - industrial approvals
                    - licences
                    - NOCs
                    - documents
                    - application workflow
                    - officer queries
                    - inspections
                    - compliance
                    - renewals
                    - schemes

                    If asked for a personal status that is not supplied,
                    do not invent it.

                    Give short practical guidance.
                    """;
        }


        if ("OFFICER"
                .equalsIgnoreCase(role)) {

            return """
                    The user is a logged-in CHAPERON government officer.

                    Help with:
                    - application review
                    - document verification
                    - queries
                    - inspections
                    - SLA monitoring
                    - approval and rejection workflow
                    """;
        }


        if ("ADMIN"
                .equalsIgnoreCase(role)) {

            return """
                    The user is a logged-in CHAPERON administrator.

                    Help with CHAPERON administration:
                    departments, officers, approvals, rules,
                    schemes, users, applications and analytics.
                    """;
        }


        return "The user is using CHAPERON.";
    }


    /*
     * ================================================================
     * HELPERS
     * ================================================================
     */

    private boolean containsAny(
            String text,
            String... values) {

        if (text == null) {

            return false;
        }


        for (String value : values) {

            if (value != null
                    && text.contains(
                            value.toLowerCase(
                                    Locale.ROOT
                            )
                    )) {

                return true;
            }
        }


        return false;
    }


    private String safe(
            String value) {

        if (value == null
                || value.isBlank()) {

            return "Not available";
        }


        return value
                .replace("\n", " ")
                .replace("\r", " ")
                .trim();
    }


    private void sendJson(
            HttpServletResponse response,
            boolean success,
            String answer)
            throws IOException {

        response.getWriter().write(
                "{"
                + "\"success\":"
                + success
                + ","
                + "\"answer\":\""
                + escapeJson(answer)
                + "\""
                + "}"
        );
    }


    private String escapeJson(
            String text) {

        if (text == null) {

            return "";
        }


        return text
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}