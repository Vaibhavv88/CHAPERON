package com.chaperon.service;

import java.util.List;

import com.chaperon.model.DocumentReadiness;
import com.chaperon.model.SubmissionRiskResult;

public class SubmissionRiskService {


    /*
     * =========================================================
     * RISK LEVELS
     * =========================================================
     */

    public static final String LOW =
            "LOW";

    public static final String MEDIUM =
            "MEDIUM";

    public static final String HIGH =
            "HIGH";


    /*
     * =========================================================
     * MAIN ANALYSIS METHOD
     * =========================================================
     */

    public SubmissionRiskResult analyzeRisk(
            int readinessPercentage,
            List<DocumentReadiness> documentReadinessList,
            boolean profileComplete
    ) {

        SubmissionRiskResult result =
                new SubmissionRiskResult();


        /*
         * -----------------------------------------------------
         * NORMALIZE READINESS
         * -----------------------------------------------------
         */

        if (readinessPercentage < 0) {
            readinessPercentage = 0;
        }

        if (readinessPercentage > 100) {
            readinessPercentage = 100;
        }


        result.setReadinessPercentage(
                readinessPercentage
        );

        result.setProfileComplete(
                profileComplete
        );


        /*
         * -----------------------------------------------------
         * DOCUMENT COUNTERS
         * -----------------------------------------------------
         */

        int totalMandatory = 0;

        int readyMandatory = 0;

        int missingMandatory = 0;

        int rejectedMandatory = 0;

        int expiredMandatory = 0;


        /*
         * -----------------------------------------------------
         * ANALYSE DOCUMENTS
         * -----------------------------------------------------
         */

        if (documentReadinessList != null) {

            for (
                DocumentReadiness document
                : documentReadinessList
            ) {

                if (document == null) {
                    continue;
                }


                if (!document.isMandatory()) {
                    continue;
                }


                totalMandatory++;


                String status =
                        document.getStatus();


                String documentName =
                        document.getDocumentType();


                if (documentName == null ||
                    documentName.isBlank()) {

                    documentName =
                            "Required document";
                }


                if (status == null ||
                    status.isBlank()) {

                    missingMandatory++;

                    result.addRiskReason(
                            documentName
                            + " is not available."
                    );

                    result.addRecommendation(
                            "Upload "
                            + documentName
                            + " before submission."
                    );

                    continue;
                }


                if ("READY".equalsIgnoreCase(
                        status
                )) {

                    readyMandatory++;

                    continue;
                }


                if ("MISSING".equalsIgnoreCase(
                        status
                )) {

                    missingMandatory++;

                    result.addRiskReason(
                            documentName
                            + " is missing."
                    );

                    result.addRecommendation(
                            "Upload "
                            + documentName
                            + "."
                    );

                    continue;
                }


                if ("REJECTED".equalsIgnoreCase(
                        status
                )) {

                    rejectedMandatory++;

                    result.addRiskReason(
                            documentName
                            + " has been rejected."
                    );

                    result.addRecommendation(
                            "Replace the rejected "
                            + documentName
                            + " with a valid document."
                    );

                    continue;
                }


                if ("EXPIRED".equalsIgnoreCase(
                        status
                )) {

                    expiredMandatory++;

                    result.addRiskReason(
                            documentName
                            + " has expired."
                    );

                    result.addRecommendation(
                            "Upload a valid renewed copy of "
                            + documentName
                            + "."
                    );

                    continue;
                }


                /*
                 * Any unknown status should not silently
                 * be considered fully safe.
                 */

                result.addRiskReason(
                        documentName
                        + " requires verification."
                );

                result.addRecommendation(
                        "Review "
                        + documentName
                        + " before submission."
                );
            }
        }


        /*
         * -----------------------------------------------------
         * STORE COUNTS
         * -----------------------------------------------------
         */

        result.setTotalMandatoryDocuments(
                totalMandatory
        );

        result.setReadyMandatoryDocuments(
                readyMandatory
        );

        result.setMissingMandatoryDocuments(
                missingMandatory
        );

        result.setRejectedMandatoryDocuments(
                rejectedMandatory
        );

        result.setExpiredMandatoryDocuments(
                expiredMandatory
        );


        /*
         * =====================================================
         * RISK SCORE
         * =====================================================
         *
         * Higher score = higher submission risk.
         *
         * Profile incomplete       = +40
         * Missing mandatory doc    = +20 each
         * Rejected mandatory doc   = +30 each
         * Expired mandatory doc    = +30 each
         *
         * Readiness:
         *
         * < 50%                    = +30
         * 50 - 79%                 = +20
         * 80 - 99%                 = +10
         * 100%                     = +0
         *
         * Maximum score = 100
         * =====================================================
         */

        int riskScore = 0;


        /*
         * Business profile
         */

        if (!profileComplete) {

            riskScore += 40;

            result.addRiskReason(
                    "Business profile is incomplete."
            );

            result.addRecommendation(
                    "Complete the business profile "
                    + "before submitting the application."
            );
        }


        /*
         * Missing documents
         */

        riskScore +=
                missingMandatory * 20;


        /*
         * Rejected documents
         */

        riskScore +=
                rejectedMandatory * 30;


        /*
         * Expired documents
         */

        riskScore +=
                expiredMandatory * 30;


        /*
         * Readiness penalty
         */

        if (readinessPercentage < 50) {

            riskScore += 30;

        } else if (
                readinessPercentage < 80
        ) {

            riskScore += 20;

        } else if (
                readinessPercentage < 100
        ) {

            riskScore += 10;
        }


        /*
         * Maximum 100
         */

        if (riskScore > 100) {

            riskScore = 100;
        }


        result.setRiskScore(
                riskScore
        );


        /*
         * =====================================================
         * RISK LEVEL
         * =====================================================
         *
         * 0 - 24   = LOW
         * 25 - 59  = MEDIUM
         * 60 - 100 = HIGH
         * =====================================================
         */

        String riskLevel;


        if (riskScore >= 60) {

            riskLevel = HIGH;

        } else if (riskScore >= 25) {

            riskLevel = MEDIUM;

        } else {

            riskLevel = LOW;
        }


        result.setRiskLevel(
                riskLevel
        );


        /*
         * =====================================================
         * SAFE TO SUBMIT
         * =====================================================
         *
         * This does NOT replace statutory approval.
         *
         * It only tells the entrepreneur whether
         * CHAPERON has detected obvious pre-submission
         * problems.
         * =====================================================
         */

        boolean safeToSubmit =

                profileComplete
                &&
                missingMandatory == 0
                &&
                rejectedMandatory == 0
                &&
                expiredMandatory == 0
                &&
                readinessPercentage == 100;


        result.setSafeToSubmit(
                safeToSubmit
        );


        /*
         * =====================================================
         * SUMMARY
         * =====================================================
         */

        if (HIGH.equals(
                riskLevel
        )) {

            result.setSummary(
                    "High submission risk detected. "
                    + "Resolve the identified issues "
                    + "before submitting this application."
            );

        } else if (
                MEDIUM.equals(
                        riskLevel
                )
        ) {

            result.setSummary(
                    "Some submission issues require "
                    + "attention before proceeding."
            );

        } else {

            if (safeToSubmit) {

                result.setSummary(
                        "Your application appears ready "
                        + "for submission based on the "
                        + "available CHAPERON checks."
                );

            } else {

                result.setSummary(
                        "Submission risk is currently low, "
                        + "but review the remaining guidance "
                        + "before proceeding."
                );
            }
        }


        /*
         * If no risk reason exists,
         * show positive guidance.
         */

        if (result.getRiskReasons().isEmpty()) {

            result.addRiskReason(
                    "No major pre-submission issue "
                    + "was detected."
            );
        }


        if (result.getRecommendations().isEmpty()) {

            result.addRecommendation(
                    "Review the application details once "
                    + "before final submission."
            );
        }


        return result;
    }
}