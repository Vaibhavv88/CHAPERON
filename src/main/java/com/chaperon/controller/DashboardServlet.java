package com.chaperon.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.chaperon.dao.ApplicationDAO;
import com.chaperon.dao.ApprovalDAO;

import com.chaperon.dao.impl.ApplicationDAOImpl;
import com.chaperon.dao.impl.ApprovalDAOImpl;

import com.chaperon.dto.ApplicationView;

import com.chaperon.model.Application;
import com.chaperon.model.Approval;
import com.chaperon.model.NextAction;

import com.chaperon.service.NextActionService;
import com.chaperon.service.SLAService;

import com.chaperon.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/entrepreneur/dashboard")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    private NextActionService nextActionService;

    private ApplicationDAO applicationDAO;

    private ApprovalDAO approvalDAO;

    private SLAService slaService;


    @Override
    public void init() throws ServletException {

        nextActionService =
                new NextActionService();

        applicationDAO =
                new ApplicationDAOImpl();

        approvalDAO =
                new ApprovalDAOImpl();

        slaService =
                new SLAService();
    }


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {


        HttpSession session =
                request.getSession(false);


        /*
         * =====================================================
         * SESSION CHECK
         * =====================================================
         */

        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }


        try {


            long userId =
                    ((Number)
                            session.getAttribute(
                                    "userId"
                            )
                    ).longValue();


            /*
             * =================================================
             * NEXT BEST ACTION
             * =================================================
             */

            loadNextBestAction(
                    request,
                    userId
            );


            /*
             * =================================================
             * DASHBOARD MAIN COUNTS
             * =================================================
             */

            int recommendedApprovals =
                    getRecommendedApprovalCount(
                            userId
                    );


            int activeApplications =
                    getActiveApplicationCount(
                            userId
                    );


            int pendingActions =
                    getPendingActionCount(
                            userId
                    );


            int approvedLicences =
                    getApprovedLicenceCount(
                            userId
                    );


            request.setAttribute(
                    "recommendedApprovalsCount",
                    recommendedApprovals
            );


            request.setAttribute(
                    "activeApplicationsCount",
                    activeApplications
            );


            request.setAttribute(
                    "pendingActionsCount",
                    pendingActions
            );


            request.setAttribute(
                    "approvedLicencesCount",
                    approvedLicences
            );


            /*
             * =================================================
             * APPLICATION STATUS COUNTS
             * =================================================
             */

            request.setAttribute(
                    "draftApplicationsCount",
                    getApplicationStatusCount(
                            userId,
                            "DRAFT"
                    )
            );


            request.setAttribute(
                    "submittedApplicationsCount",
                    getApplicationStatusCount(
                            userId,
                            "SUBMITTED"
                    )
            );


            request.setAttribute(
                    "underReviewApplicationsCount",
                    getApplicationStatusCount(
                            userId,
                            "UNDER_REVIEW"
                    )
            );


            request.setAttribute(
                    "approvedApplicationsCount",
                    getApplicationStatusCount(
                            userId,
                            "APPROVED"
                    )
            );


            request.setAttribute(
                    "rejectedApplicationsCount",
                    getApplicationStatusCount(
                            userId,
                            "REJECTED"
                    )
            );


            /*
             * =================================================
             * ATTENTION REQUIRED COUNTS
             * =================================================
             */

            request.setAttribute(
                    "openQueriesCount",
                    getOpenQueryCount(
                            userId
                    )
            );


            request.setAttribute(
                    "scheduledInspectionsCount",
                    getScheduledInspectionCount(
                            userId
                    )
            );


            request.setAttribute(
                    "pendingRenewalsCount",
                    getPendingRenewalCount(
                            userId
                    )
            );


            request.setAttribute(
                    "documentIssuesCount",
                    getDocumentIssueCount(
                            userId
                    )
            );


            /*
             * =================================================
             * ALL ACTIVE APPLICATIONS
             *
             * NEW:
             * Dashboard now receives every active application,
             * not just one NextAction application.
             * =================================================
             */

            List<ApplicationView>
                    activeApplicationList =
                    loadActiveApplications(
                            userId
                    );


            request.setAttribute(
                    "activeApplicationList",
                    activeApplicationList
            );


            /*
             * =================================================
             * SLA DATA FOR ACTIVE APPLICATIONS
             * =================================================
             */

            loadActiveApplicationSLAData(
                    request,
                    activeApplicationList
            );


            /*
             * =================================================
             * RECENT APPLICATIONS
             *
             * Existing dashboard functionality preserved.
             * =================================================
             */

            List<ApplicationView>
                    recentApplications =
                    loadRecentApplications(
                            userId
                    );


            request.setAttribute(
                    "recentApplications",
                    recentApplications
            );


            /*
             * =================================================
             * OPEN DASHBOARD JSP
             * =================================================
             */

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/dashboard.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (SQLException e) {


            log(
                    "Unable to load entrepreneur dashboard",
                    e
            );


            response.sendError(
                    HttpServletResponse
                            .SC_INTERNAL_SERVER_ERROR,
                    "Unable to load dashboard."
            );


        } catch (ClassCastException e) {


            log(
                    "Invalid user session data",
                    e
            );


            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );
        }
    }


    /*
     * =========================================================
     * NEXT BEST ACTION
     * =========================================================
     */

    private void loadNextBestAction(
            HttpServletRequest request,
            long userId
    ) {


        try {


            NextAction nextAction =
                    nextActionService
                            .getNextAction(
                                    userId
                            );


            request.setAttribute(
                    "nextAction",
                    nextAction
            );


        } catch (SQLException e) {


            /*
             * Next Action failure should not crash
             * the complete entrepreneur dashboard.
             */

            log(
                    "Unable to calculate next best action",
                    e
            );


            request.setAttribute(
                    "nextActionError",
                    "Unable to calculate your next best action right now."
            );
        }
    }


    /*
     * =========================================================
     * RECOMMENDED APPROVAL COUNT
     * =========================================================
     */

    private int getRecommendedApprovalCount(
            long userId
    ) throws SQLException {


        String sql = """
                SELECT
                    COUNT(DISTINCT ba.approval_id) AS total

                FROM business_approvals ba

                INNER JOIN businesses b
                    ON b.business_id = ba.business_id

                WHERE b.user_id = ?
                """;


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    connection.prepareStatement(
                            sql
                    )
        ) {


            ps.setLong(
                    1,
                    userId
            );


            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {


                if (rs.next()) {

                    return rs.getInt(
                            "total"
                    );
                }
            }
        }


        return 0;
    }


    /*
     * =========================================================
     * ACTIVE APPLICATION COUNT
     * =========================================================
     */

    private int getActiveApplicationCount(
            long userId
    ) throws SQLException {


        String sql = """
                SELECT
                    COUNT(*) AS total

                FROM applications

                WHERE user_id = ?

                  AND current_status NOT IN (
                      'APPROVED',
                      'REJECTED'
                  )
                """;


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    connection.prepareStatement(
                            sql
                    )
        ) {


            ps.setLong(
                    1,
                    userId
            );


            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {


                if (rs.next()) {

                    return rs.getInt(
                            "total"
                    );
                }
            }
        }


        return 0;
    }


    /*
     * =========================================================
     * APPROVED LICENCE COUNT
     * =========================================================
     */

    private int getApprovedLicenceCount(
            long userId
    ) throws SQLException {


        String sql = """
                SELECT
                    COUNT(*) AS total

                FROM applications

                WHERE user_id = ?

                  AND current_status = 'APPROVED'
                """;


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    connection.prepareStatement(
                            sql
                    )
        ) {


            ps.setLong(
                    1,
                    userId
            );


            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {


                if (rs.next()) {

                    return rs.getInt(
                            "total"
                    );
                }
            }
        }


        return 0;
    }


    /*
     * =========================================================
     * APPLICATION STATUS COUNT
     * =========================================================
     */

    private int getApplicationStatusCount(
            long userId,
            String status
    ) throws SQLException {


        String sql = """
                SELECT
                    COUNT(*) AS total

                FROM applications

                WHERE user_id = ?
                  AND current_status = ?
                """;


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    connection.prepareStatement(
                            sql
                    )
        ) {


            ps.setLong(
                    1,
                    userId
            );


            ps.setString(
                    2,
                    status
            );


            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {


                if (rs.next()) {

                    return rs.getInt(
                            "total"
                    );
                }
            }
        }


        return 0;
    }


    /*
     * =========================================================
     * OPEN OFFICER QUERY COUNT
     * =========================================================
     */

    private int getOpenQueryCount(
            long userId
    ) throws SQLException {


        String sql = """
                SELECT
                    COUNT(*) AS total

                FROM application_queries q

                INNER JOIN applications a
                    ON a.application_id =
                       q.application_id

                WHERE a.user_id = ?

                  AND q.status = 'OPEN'
                """;


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    connection.prepareStatement(
                            sql
                    )
        ) {


            ps.setLong(
                    1,
                    userId
            );


            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {


                if (rs.next()) {

                    return rs.getInt(
                            "total"
                    );
                }
            }
        }


        return 0;
    }


    /*
     * =========================================================
     * SCHEDULED INSPECTION COUNT
     * =========================================================
     */

    private int getScheduledInspectionCount(
            long userId
    ) throws SQLException {


        String sql = """
                SELECT
                    COUNT(*) AS total

                FROM inspections i

                INNER JOIN applications a
                    ON a.application_id =
                       i.application_id

                WHERE a.user_id = ?

                  AND i.status IN (
                      'SCHEDULED',
                      'RESCHEDULED'
                  )
                """;


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    connection.prepareStatement(
                            sql
                    )
        ) {


            ps.setLong(
                    1,
                    userId
            );


            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {


                if (rs.next()) {

                    return rs.getInt(
                            "total"
                    );
                }
            }
        }


        return 0;
    }


    /*
     * =========================================================
     * PENDING RENEWAL COUNT
     *
     * Correct relationship:
     *
     * renewal_reminders.certificate_id
     *              ↓
     * approval_certificates.certificate_id
     *              ↓
     * approval_certificates.application_id
     *              ↓
     * applications.application_id
     *
     * =========================================================
     */

    private int getPendingRenewalCount(
            long userId
    ) throws SQLException {


        String sql = """
                SELECT
                    COUNT(*) AS total

                FROM renewal_reminders rr

                INNER JOIN approval_certificates ac
                    ON ac.certificate_id =
                       rr.certificate_id

                INNER JOIN applications a
                    ON a.application_id =
                       ac.application_id

                WHERE a.user_id = ?

                  AND rr.status = 'PENDING'
                """;


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    connection.prepareStatement(
                            sql
                    )
        ) {


            ps.setLong(
                    1,
                    userId
            );


            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {


                if (rs.next()) {

                    return rs.getInt(
                            "total"
                    );
                }
            }
        }


        return 0;
    }


    /*
     * =========================================================
     * DOCUMENT ISSUE COUNT
     * =========================================================
     */

    private int getDocumentIssueCount(
            long userId
    ) throws SQLException {


        String sql = """
                SELECT
                    COUNT(*) AS total

                FROM documents

                WHERE user_id = ?

                  AND verification_status IN (
                      'REJECTED',
                      'EXPIRED'
                  )
                """;


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    connection.prepareStatement(
                            sql
                    )
        ) {


            ps.setLong(
                    1,
                    userId
            );


            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {


                if (rs.next()) {

                    return rs.getInt(
                            "total"
                    );
                }
            }
        }


        return 0;
    }


    /*
     * =========================================================
     * TOTAL PENDING ACTION COUNT
     * =========================================================
     */

    private int getPendingActionCount(
            long userId
    ) throws SQLException {


        int openQueries =
                getOpenQueryCount(
                        userId
                );


        int draftApplications =
                getApplicationStatusCount(
                        userId,
                        "DRAFT"
                );


        int scheduledInspections =
                getScheduledInspectionCount(
                        userId
                );


        int pendingRenewals =
                getPendingRenewalCount(
                        userId
                );


        int documentIssues =
                getDocumentIssueCount(
                        userId
                );


        return openQueries
                + draftApplications
                + scheduledInspections
                + pendingRenewals
                + documentIssues;
    }


    /*
     * =========================================================
     * ALL ACTIVE APPLICATIONS
     *
     * NEW METHOD
     *
     * Loads every non-terminal application
     * belonging to the entrepreneur.
     *
     * APPROVED and REJECTED are not active.
     * =========================================================
     */

    private List<ApplicationView> loadActiveApplications(
            long userId
    ) throws SQLException {


        List<Application> applications =
                applicationDAO.findByUserId(
                        userId
                );


        List<ApplicationView>
                activeViews =
                new ArrayList<>();


        if (applications == null ||
            applications.isEmpty()) {

            return activeViews;
        }


        for (Application appRow : applications) {


            if (appRow == null) {
                continue;
            }


            String applicationStatus =
                    appRow.getCurrentStatus();


            if ("APPROVED"
                    .equalsIgnoreCase(
                            applicationStatus
                    ) ||
                "REJECTED"
                    .equalsIgnoreCase(
                            applicationStatus
                    )) {

                continue;
            }


            Approval approval =
                    approvalDAO
                            .findApprovalById(
                                    appRow
                                            .getApprovalId()
                            );


            String approvalName =
                    "Approval";


            String approvalCode =
                    "";


            String departmentName =
                    "Department not available";


            if (approval != null) {


                if (approval.getApprovalName()
                        != null) {

                    approvalName =
                            approval
                                    .getApprovalName();
                }


                if (approval.getApprovalCode()
                        != null) {

                    approvalCode =
                            approval
                                    .getApprovalCode();
                }


                if (approval.getDepartmentName()
                        != null) {

                    departmentName =
                            approval
                                    .getDepartmentName();
                }
            }


            ApplicationView view =
                    new ApplicationView(
                            appRow,
                            approvalName,
                            approvalCode,
                            departmentName
                    );


            activeViews.add(
                    view
            );
        }


        return activeViews;
    }


    /*
     * =========================================================
     * SLA DATA FOR ACTIVE APPLICATIONS
     *
     * NEW METHOD
     *
     * JSP can use application_id as map key.
     *
     * Example:
     *
     * activeApplicationSlaStatus.get(applicationId)
     * activeApplicationSlaLabel.get(applicationId)
     * activeApplicationSlaMessage.get(applicationId)
     * activeApplicationSlaProgress.get(applicationId)
     * activeApplicationSlaDaysRemaining.get(applicationId)
     *
     * =========================================================
     */

    private void loadActiveApplicationSLAData(
            HttpServletRequest request,
            List<ApplicationView>
                    activeApplicationList
    ) {


        Map<Long, String>
                statusMap =
                new LinkedHashMap<>();


        Map<Long, String>
                labelMap =
                new LinkedHashMap<>();


        Map<Long, String>
                messageMap =
                new LinkedHashMap<>();


        Map<Long, Integer>
                progressMap =
                new LinkedHashMap<>();


        Map<Long, Long>
                daysRemainingMap =
                new LinkedHashMap<>();


        if (activeApplicationList != null) {


            for (ApplicationView view
                    : activeApplicationList) {


                if (view == null ||
                    view.getApplication() == null) {

                    continue;
                }


                Application appRow =
                        view.getApplication();


                long applicationId =
                        appRow.getApplicationId();


                String slaStatus =
                        slaService
                                .getSLAStatus(
                                        appRow
                                );


                String slaLabel =
                        slaService
                                .getSLAStatusLabel(
                                        slaStatus
                                );


                String slaMessage =
                        slaService
                                .getDeadlineMessage(
                                        appRow
                                );


                int slaProgress =
                        slaService
                                .getSLAProgressPercentage(
                                        appRow
                                );


                long daysRemaining =
                        slaService
                                .getDaysRemaining(
                                        appRow
                                );


                statusMap.put(
                        applicationId,
                        slaStatus
                );


                labelMap.put(
                        applicationId,
                        slaLabel
                );


                messageMap.put(
                        applicationId,
                        slaMessage
                );


                progressMap.put(
                        applicationId,
                        slaProgress
                );


                daysRemainingMap.put(
                        applicationId,
                        daysRemaining
                );
            }
        }


        request.setAttribute(
                "activeApplicationSlaStatus",
                statusMap
        );


        request.setAttribute(
                "activeApplicationSlaLabel",
                labelMap
        );


        request.setAttribute(
                "activeApplicationSlaMessage",
                messageMap
        );


        request.setAttribute(
                "activeApplicationSlaProgress",
                progressMap
        );


        request.setAttribute(
                "activeApplicationSlaDaysRemaining",
                daysRemainingMap
        );
    }


    /*
     * =========================================================
     * RECENT APPLICATIONS
     *
     * Existing functionality preserved.
     * Dashboard only needs latest five.
     * =========================================================
     */

    private List<ApplicationView>
            loadRecentApplications(
                    long userId
            ) throws SQLException {


        List<Application> applications =
                applicationDAO.findByUserId(
                        userId
                );


        List<ApplicationView>
                recentViews =
                new ArrayList<>();


        if (applications == null ||
            applications.isEmpty()) {

            return recentViews;
        }


        /*
         * Existing dashboard behavior:
         * only latest five applications.
         */

        int maximum =
                Math.min(
                        applications.size(),
                        5
                );


        for (
            int i = 0;
            i < maximum;
            i++
        ) {


            Application appRow =
                    applications.get(i);


            Approval approval =
                    approvalDAO
                            .findApprovalById(
                                    appRow
                                            .getApprovalId()
                            );


            String approvalName =
                    "Approval";


            String approvalCode =
                    "";


            String departmentName =
                    "Department not available";


            if (approval != null) {


                if (approval.getApprovalName()
                        != null) {

                    approvalName =
                            approval
                                    .getApprovalName();
                }


                if (approval.getApprovalCode()
                        != null) {

                    approvalCode =
                            approval
                                    .getApprovalCode();
                }


                if (approval.getDepartmentName()
                        != null) {

                    departmentName =
                            approval
                                    .getDepartmentName();
                }
            }


            ApplicationView view =
                    new ApplicationView(
                            appRow,
                            approvalName,
                            approvalCode,
                            departmentName
                    );


            recentViews.add(
                    view
            );
        }


        return recentViews;
    }
}