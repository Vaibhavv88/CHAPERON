package com.chaperon.service;

import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

import com.chaperon.model.Application;

public class SLAService {

    public static final String NOT_STARTED = "NOT_STARTED";
    public static final String ON_TRACK = "ON_TRACK";
    public static final String NEAR_DEADLINE = "NEAR_DEADLINE";
    public static final String BREACHED = "BREACHED";
    public static final String COMPLETED = "COMPLETED";


    /*
     * Main method:
     * Directly accepts Application object.
     */
    public String getSLAStatus(Application application) {

        if (application == null) {
            return NOT_STARTED;
        }

        return getSLAStatus(
                application.getCurrentStatus(),
                application.getExpectedCompletionDate()
        );
    }


    /*
     * Calculates SLA status.
     */
    public String getSLAStatus(
            String applicationStatus,
            Date expectedCompletionDate) {

        if (applicationStatus == null ||
            applicationStatus.isBlank()) {

            return NOT_STARTED;
        }

        String status =
                applicationStatus
                        .trim()
                        .toUpperCase();

        /*
         * Draft means SLA has not started.
         */
        if ("DRAFT".equals(status)) {
            return NOT_STARTED;
        }

        /*
         * Final statuses.
         */
        if ("APPROVED".equals(status) ||
            "REJECTED".equals(status)) {

            return COMPLETED;
        }

        /*
         * Submitted application should normally
         * have expected completion date.
         */
        if (expectedCompletionDate == null) {
            return NOT_STARTED;
        }

        LocalDate expectedDate =
                expectedCompletionDate.toLocalDate();

        LocalDate today =
                LocalDate.now();

        long daysRemaining =
                ChronoUnit.DAYS.between(
                        today,
                        expectedDate
                );

        /*
         * Deadline already crossed.
         */
        if (daysRemaining < 0) {
            return BREACHED;
        }

        /*
         * Deadline today or within next 3 days.
         */
        if (daysRemaining <= 3) {
            return NEAR_DEADLINE;
        }

        return ON_TRACK;
    }


    /*
     * Directly calculates remaining SLA days
     * from an Application.
     */
    public long getDaysRemaining(
            Application application) {

        if (application == null) {
            return 0;
        }

        return getDaysRemaining(
                application.getExpectedCompletionDate()
        );
    }


    /*
     * Positive -> days remaining
     * 0        -> deadline today
     * Negative -> overdue
     */
    public long getDaysRemaining(
            Date expectedCompletionDate) {

        if (expectedCompletionDate == null) {
            return 0;
        }

        LocalDate expectedDate =
                expectedCompletionDate.toLocalDate();

        return ChronoUnit.DAYS.between(
                LocalDate.now(),
                expectedDate
        );
    }


    /*
     * Converts technical status into
     * user-friendly text.
     */
    public String getSLAStatusLabel(
            String slaStatus) {

        if (slaStatus == null) {
            return "Not Started";
        }

        switch (slaStatus) {

            case ON_TRACK:
                return "On Track";

            case NEAR_DEADLINE:
                return "Near Deadline";

            case BREACHED:
                return "SLA Breached";

            case COMPLETED:
                return "Completed";

            default:
                return "Not Started";
        }
    }


    /*
     * Direct application version.
     */
    public String getDeadlineMessage(
            Application application) {

        if (application == null) {
            return "SLA information unavailable.";
        }

        return getDeadlineMessage(
                application.getCurrentStatus(),
                application.getExpectedCompletionDate()
        );
    }


    /*
     * Returns deadline message.
     */
    public String getDeadlineMessage(
            String applicationStatus,
            Date expectedCompletionDate) {

        String slaStatus =
                getSLAStatus(
                        applicationStatus,
                        expectedCompletionDate
                );

        if (NOT_STARTED.equals(slaStatus)) {

            return "SLA will start after application submission.";
        }

        if (COMPLETED.equals(slaStatus)) {

            return "Application processing has been completed.";
        }

        long days =
                getDaysRemaining(
                        expectedCompletionDate
                );

        if (days < 0) {

            long overdueDays =
                    Math.abs(days);

            if (overdueDays == 1) {
                return "1 day overdue.";
            }

            return overdueDays +
                    " days overdue.";
        }

        if (days == 0) {
            return "SLA deadline is today.";
        }

        if (days == 1) {
            return "1 day remaining.";
        }

        return days +
                " days remaining.";
    }


    /*
     * Direct Application version.
     */
    public int getSLAProgressPercentage(
            Application application) {

        if (application == null) {
            return 0;
        }

        return getSLAProgressPercentage(
                application.getSubmissionDate(),
                application.getExpectedCompletionDate()
        );
    }


    /*
     * Calculates SLA progress percentage.
     *
     * Example:
     *
     * Submission: 1 Sep
     * Deadline: 21 Sep
     * Today: 11 Sep
     *
     * Total = 20 days
     * Used  = 10 days
     *
     * Progress = 50%
     */
    public int getSLAProgressPercentage(
            Timestamp submissionDate,
            Date expectedCompletionDate) {

        if (submissionDate == null ||
            expectedCompletionDate == null) {

            return 0;
        }

        LocalDate submittedDate =
                submissionDate
                        .toLocalDateTime()
                        .toLocalDate();

        LocalDate expectedDate =
                expectedCompletionDate.toLocalDate();

        LocalDate today =
                LocalDate.now();

        long totalDays =
                ChronoUnit.DAYS.between(
                        submittedDate,
                        expectedDate
                );

        if (totalDays <= 0) {
            return 100;
        }

        long consumedDays =
                ChronoUnit.DAYS.between(
                        submittedDate,
                        today
                );

        if (consumedDays <= 0) {
            return 0;
        }

        int percentage =
                (int) (
                    (consumedDays * 100)
                    / totalDays
                );

        if (percentage > 100) {
            return 100;
        }

        return percentage;
    }


    /*
     * Tells whether the application
     * has breached its SLA.
     */
    public boolean isSLABreached(
            Application application) {

        return BREACHED.equals(
                getSLAStatus(application)
        );
    }


    /*
     * Tells whether SLA deadline
     * is very close.
     */
    public boolean isNearDeadline(
            Application application) {

        return NEAR_DEADLINE.equals(
                getSLAStatus(application)
        );
    }


    /*
     * Determines whether SLA clock
     * should currently be active.
     */
    public boolean isSLAActive(
            Application application) {

        if (application == null ||
            application.getCurrentStatus() == null) {

            return false;
        }

        String status =
                application
                        .getCurrentStatus()
                        .trim()
                        .toUpperCase();

        return !(
                "DRAFT".equals(status) ||
                "APPROVED".equals(status) ||
                "REJECTED".equals(status)
        );
    }
}