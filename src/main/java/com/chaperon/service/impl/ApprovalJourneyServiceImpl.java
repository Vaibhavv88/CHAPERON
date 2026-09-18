package com.chaperon.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.chaperon.dao.ApprovalDependencyDAO;
import com.chaperon.dao.impl.ApprovalDependencyDAOImpl;
import com.chaperon.model.ApprovalDependency;
import com.chaperon.service.ApprovalJourneyService;

public class ApprovalJourneyServiceImpl
        implements ApprovalJourneyService {

    private final ApprovalDependencyDAO
            approvalDependencyDAO;


    /*
     * ============================================================
     * CONSTRUCTOR
     * ============================================================
     */
    public ApprovalJourneyServiceImpl() {

        this.approvalDependencyDAO =
                new ApprovalDependencyDAOImpl();
    }


    /*
     * ============================================================
     * GET COMPLETE BUSINESS JOURNEY
     * ============================================================
     */
    @Override
    public List<ApprovalDependency> getBusinessJourney(
            long businessId)
            throws SQLException {

        if (businessId <= 0) {

            return new ArrayList<>();
        }

        return approvalDependencyDAO
                .findByBusinessId(businessId);
    }


    /*
     * ============================================================
     * GET PARALLEL APPROVAL RELATIONSHIPS
     * ============================================================
     */
    @Override
    public List<ApprovalDependency> getParallelApprovals(
            long businessId)
            throws SQLException {

        List<ApprovalDependency> journey =
                getBusinessJourney(businessId);

        List<ApprovalDependency> parallel =
                new ArrayList<>();

        for (ApprovalDependency dependency : journey) {

            if (dependency.getDependencyType() == null) {

                continue;
            }

            if ("PARALLEL".equalsIgnoreCase(
                    dependency.getDependencyType())) {

                parallel.add(dependency);
            }
        }

        return parallel;
    }


    /*
     * ============================================================
     * GET CONDITIONAL APPROVAL RELATIONSHIPS
     * ============================================================
     */
    @Override
    public List<ApprovalDependency> getConditionalApprovals(
            long businessId)
            throws SQLException {

        List<ApprovalDependency> journey =
                getBusinessJourney(businessId);

        List<ApprovalDependency> conditional =
                new ArrayList<>();

        for (ApprovalDependency dependency : journey) {

            if (dependency.getDependencyType() == null) {

                continue;
            }

            if ("CONDITIONAL".equalsIgnoreCase(
                    dependency.getDependencyType())) {

                conditional.add(dependency);
            }
        }

        return conditional;
    }


    /*
     * ============================================================
     * GET DEPENDENT / PREREQUISITE RELATIONSHIPS
     * ============================================================
     *
     * This keeps the code flexible.
     *
     * If later database contains:
     *
     * PREREQUISITE
     * DEPENDENT
     * SEQUENTIAL
     *
     * then CHAPERON can identify them without
     * changing the complete architecture.
     * ============================================================
     */
    @Override
    public List<ApprovalDependency> getDependentApprovals(
            long businessId)
            throws SQLException {

        List<ApprovalDependency> journey =
                getBusinessJourney(businessId);

        List<ApprovalDependency> dependent =
                new ArrayList<>();

        for (ApprovalDependency dependency : journey) {

            String type =
                    dependency.getDependencyType();

            if (type == null) {

                continue;
            }

            if (
                "PREREQUISITE".equalsIgnoreCase(type)
                ||
                "DEPENDENT".equalsIgnoreCase(type)
                ||
                "SEQUENTIAL".equalsIgnoreCase(type)
            ) {

                dependent.add(dependency);
            }
        }

        return dependent;
    }


    /*
     * ============================================================
     * ENTREPRENEUR FRIENDLY MESSAGE
     * ============================================================
     */
    @Override
    public String getRelationshipMessage(
            ApprovalDependency dependency) {

        if (dependency == null) {

            return "Approval relationship information is unavailable.";
        }

        String approvalName =
                safe(
                    dependency.getApprovalName(),
                    "This approval"
                );

        String relatedApprovalName =
                safe(
                    dependency.getDependsOnApprovalName(),
                    "the related approval"
                );

        String type =
                dependency.getDependencyType();

        String condition =
                dependency.getConditionDescription();


        /*
         * PARALLEL
         */
        if ("PARALLEL".equalsIgnoreCase(type)) {

            return approvalName
                    + " and "
                    + relatedApprovalName
                    + " may be processed in parallel, "
                    + "which can help reduce waiting time.";
        }


        /*
         * CONDITIONAL
         */
        if ("CONDITIONAL".equalsIgnoreCase(type)) {

            if (condition != null
                    && !condition.isBlank()) {

                return relatedApprovalName
                        + " may become relevant for "
                        + approvalName
                        + " when this condition applies: "
                        + condition;
            }

            return relatedApprovalName
                    + " may be required depending on "
                    + "your business configuration.";
        }


        /*
         * PREREQUISITE
         */
        if ("PREREQUISITE".equalsIgnoreCase(type)) {

            return relatedApprovalName
                    + " should be completed before proceeding with "
                    + approvalName
                    + ".";
        }


        /*
         * SEQUENTIAL
         */
        if ("SEQUENTIAL".equalsIgnoreCase(type)) {

            return approvalName
                    + " is part of a sequential approval journey "
                    + "related to "
                    + relatedApprovalName
                    + ".";
        }


        /*
         * DEPENDENT
         */
        if ("DEPENDENT".equalsIgnoreCase(type)) {

            return approvalName
                    + " is linked with "
                    + relatedApprovalName
                    + " in your regulatory journey.";
        }


        /*
         * DEFAULT
         */
        return approvalName
                + " is related to "
                + relatedApprovalName
                + ".";
    }


    /*
     * ============================================================
     * SMALL HELPER
     * ============================================================
     */
    private String safe(
            String value,
            String fallback) {

        if (value == null
                || value.isBlank()) {

            return fallback;
        }

        return value;
    }
}