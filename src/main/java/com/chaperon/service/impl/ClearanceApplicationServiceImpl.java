package com.chaperon.service.impl;

import java.sql.SQLException;
import java.time.Year;
import java.util.List;
import java.util.Set;

import com.chaperon.dao.BusinessDAO;
import com.chaperon.dao.ClearanceApplicationDAO;
import com.chaperon.dao.ClearanceApplicationRequirementDAO;
import com.chaperon.dao.ClearanceRequirementDAO;
import com.chaperon.dao.ClearanceStatusHistoryDAO;
import com.chaperon.dao.ClearanceTypeDAO;
import com.chaperon.dao.DocumentDAO;
import com.chaperon.dao.impl.BusinessDAOImpl;
import com.chaperon.dao.impl.ClearanceApplicationDAOImpl;
import com.chaperon.dao.impl.ClearanceApplicationRequirementDAOImpl;
import com.chaperon.dao.impl.ClearanceRequirementDAOImpl;
import com.chaperon.dao.impl.ClearanceStatusHistoryDAOImpl;
import com.chaperon.dao.impl.ClearanceTypeDAOImpl;
import com.chaperon.dao.impl.DocumentDAOImpl;
import com.chaperon.model.Business;
import com.chaperon.model.ClearanceApplication;
import com.chaperon.model.ClearanceApplicationRequirement;
import com.chaperon.model.ClearanceRequirement;
import com.chaperon.model.ClearanceStatusHistory;
import com.chaperon.model.ClearanceType;
import com.chaperon.model.Document;
import com.chaperon.service.ClearanceApplicationService;

public class ClearanceApplicationServiceImpl
        implements ClearanceApplicationService {

    private static final Set<String> VALID_STATUSES = Set.of(
            "DRAFT",
            "SUBMITTED",
            "UNDER_SCRUTINY",
            "QUERY_RAISED",
            "APPLICANT_RESPONDED",
            "SITE_INSPECTION_PENDING",
            "SITE_INSPECTION_COMPLETED",
            "COMMITTEE_REVIEW",
            "FINAL_REVIEW",
            "APPROVED",
            "REJECTED",
            "WITHDRAWN"
    );

    private static final Set<String> VALID_ROLES = Set.of(
            "ENTREPRENEUR",
            "OFFICER",
            "ADMIN",
            "COMMITTEE",
            "SYSTEM"
    );

    private static final Set<String> VERIFICATION_STATUSES = Set.of(
            "UNDER_VERIFICATION",
            "VERIFIED",
            "REJECTED"
    );

    private final ClearanceTypeDAO clearanceTypeDAO;
    private final ClearanceRequirementDAO clearanceRequirementDAO;
    private final ClearanceApplicationDAO clearanceApplicationDAO;
    private final ClearanceApplicationRequirementDAO applicationRequirementDAO;
    private final ClearanceStatusHistoryDAO statusHistoryDAO;
    private final BusinessDAO businessDAO;
    private final DocumentDAO documentDAO;

    public ClearanceApplicationServiceImpl() {
        this.clearanceTypeDAO = new ClearanceTypeDAOImpl();
        this.clearanceRequirementDAO = new ClearanceRequirementDAOImpl();
        this.clearanceApplicationDAO = new ClearanceApplicationDAOImpl();
        this.applicationRequirementDAO =
                new ClearanceApplicationRequirementDAOImpl();
        this.statusHistoryDAO = new ClearanceStatusHistoryDAOImpl();
        this.businessDAO = new BusinessDAOImpl();
        this.documentDAO = new DocumentDAOImpl();
    }

    @Override
    public List<ClearanceType> getActiveClearanceTypes()
            throws SQLException {

        return clearanceTypeDAO.findAllActive();
    }

    @Override
    public List<ClearanceRequirement> getActiveRequirements(
            long clearanceTypeId
    ) throws SQLException {

        if (clearanceTypeId <= 0) {
            throw new IllegalArgumentException("Invalid clearance type.");
        }

        return clearanceRequirementDAO.findActiveByClearanceTypeId(
                clearanceTypeId
        );
    }

    @Override
    public long createDraft(ClearanceApplication application)
            throws SQLException {

        validateDraft(application);
        validateBusinessOwnership(
                application.getBusinessId(),
                application.getUserId()
        );

        ClearanceType clearanceType = clearanceTypeDAO.findById(
                application.getClearanceTypeId()
        );
        if (clearanceType == null || !clearanceType.isActive()) {
            throw new IllegalArgumentException("Clearance type is unavailable.");
        }

        application.setCurrentStatus("DRAFT");
        application.setApplicationNumber(null);
        application.setAssignedOfficerId(null);

        long applicationId = clearanceApplicationDAO.createApplication(
                application
        );
        if (applicationId <= 0) {
            return 0;
        }

        applicationRequirementDAO.initializeRequirements(
                applicationId,
                application.getClearanceTypeId()
        );

        createHistory(
                applicationId,
                null,
                "DRAFT",
                application.getUserId(),
                "ENTREPRENEUR",
                "Clearance application draft created."
        );

        return applicationId;
    }

    @Override
    public boolean updateDraft(ClearanceApplication application)
            throws SQLException {

        validateDraft(application);
        if (application.getClearanceApplicationId() <= 0) {
            throw new IllegalArgumentException("Invalid application.");
        }

        if (!clearanceApplicationDAO.belongsToUser(
                application.getClearanceApplicationId(),
                application.getUserId()
        )) {
            throw new SecurityException("Application access denied.");
        }

        validateBusinessOwnership(
                application.getBusinessId(),
                application.getUserId()
        );

        ClearanceApplication existing = clearanceApplicationDAO.findById(
                application.getClearanceApplicationId()
        );
        if (existing == null || !"DRAFT".equals(existing.getCurrentStatus())) {
            throw new IllegalStateException("Only draft applications can be edited.");
        }

        if (existing.getClearanceTypeId() != application.getClearanceTypeId()) {
            throw new IllegalStateException(
                    "Clearance type cannot be changed after draft creation."
            );
        }

        return clearanceApplicationDAO.updateApplication(application);
    }

    @Override
    public boolean submitApplication(
            long clearanceApplicationId,
            long entrepreneurUserId
    ) throws SQLException {

        ClearanceApplication application = getApplicationForUser(
                clearanceApplicationId,
                entrepreneurUserId
        );

        if (!"DRAFT".equals(application.getCurrentStatus())) {
            throw new IllegalStateException("Application is not in draft status.");
        }
        if (!application.isApplicantDeclaration()) {
            throw new IllegalStateException("Applicant declaration is required.");
        }

        int readiness = calculateReadinessPercentage(clearanceApplicationId);
        if (readiness < 100) {
            throw new IllegalStateException(
                    "Upload all mandatory applicant documents before submission."
            );
        }

        ClearanceType clearanceType = clearanceTypeDAO.findById(
                application.getClearanceTypeId()
        );
        String applicationNumber = generateApplicationNumber(
                clearanceType,
                clearanceApplicationId
        );

        boolean submitted = clearanceApplicationDAO.submitApplication(
                clearanceApplicationId,
                applicationNumber
        );

        if (submitted) {
            createHistory(
                    clearanceApplicationId,
                    "DRAFT",
                    "SUBMITTED",
                    entrepreneurUserId,
                    "ENTREPRENEUR",
                    "Application submitted by entrepreneur."
            );
        }

        return submitted;
    }

    @Override
    public ClearanceApplication getApplicationForUser(
            long clearanceApplicationId,
            long entrepreneurUserId
    ) throws SQLException {

        if (!clearanceApplicationDAO.belongsToUser(
                clearanceApplicationId,
                entrepreneurUserId
        )) {
            throw new SecurityException("Application access denied.");
        }

        ClearanceApplication application = clearanceApplicationDAO.findById(
                clearanceApplicationId
        );
        if (application == null) {
            throw new IllegalArgumentException("Application not found.");
        }

        return application;
    }

    @Override
    public List<ClearanceApplication> getApplicationsForUser(long userId)
            throws SQLException {

        return clearanceApplicationDAO.findByUserId(userId);
    }

    @Override
    public List<ClearanceApplication> getApplicationsForOfficer(
            long officerUserId
    ) throws SQLException {

        return clearanceApplicationDAO.findByAssignedOfficerId(officerUserId);
    }

    @Override
    public List<ClearanceApplication> getAllApplications()
            throws SQLException {

        return clearanceApplicationDAO.findAll();
    }

    @Override
    public List<ClearanceApplicationRequirement> getApplicationChecklist(
            long clearanceApplicationId
    ) throws SQLException {

        return applicationRequirementDAO.findByApplicationId(
                clearanceApplicationId
        );
    }

    @Override
    public int calculateReadinessPercentage(long clearanceApplicationId)
            throws SQLException {

        int total = applicationRequirementDAO.countMandatoryApplicable(
                clearanceApplicationId
        );
        if (total == 0) {
            return 100;
        }

        int provided = applicationRequirementDAO.countProvidedMandatory(
                clearanceApplicationId
        );

        return Math.min(100, (provided * 100) / total);
    }

    @Override
    public boolean attachRequirementDocument(
            long clearanceApplicationId,
            long applicationRequirementId,
            long documentId,
            long entrepreneurUserId,
            String applicantRemarks
    ) throws SQLException {

        ClearanceApplication application = getApplicationForUser(
                clearanceApplicationId,
                entrepreneurUserId
        );
        if (!"DRAFT".equals(application.getCurrentStatus()) &&
            !"QUERY_RAISED".equals(application.getCurrentStatus())) {
            throw new IllegalStateException(
                    "Documents cannot be changed in the current status."
            );
        }

        ClearanceApplicationRequirement requirement =
                applicationRequirementDAO.findById(applicationRequirementId);
        if (requirement == null ||
            requirement.getClearanceApplicationId() != clearanceApplicationId) {
            throw new SecurityException("Requirement access denied.");
        }

        if (!documentBelongsToBusiness(
                documentId,
                application.getBusinessId(),
                entrepreneurUserId
        )) {
            throw new SecurityException("Document access denied.");
        }

        return applicationRequirementDAO.attachDocument(
                applicationRequirementId,
                documentId,
                entrepreneurUserId,
                applicantRemarks
        );
    }

    @Override
    public boolean verifyRequirement(
            long applicationRequirementId,
            String requirementStatus,
            long officerUserId,
            String officerRemarks
    ) throws SQLException {

        String normalizedStatus = normalize(requirementStatus);
        if (!VERIFICATION_STATUSES.contains(normalizedStatus)) {
            throw new IllegalArgumentException("Invalid verification status.");
        }

        ClearanceApplicationRequirement requirement =
                applicationRequirementDAO.findById(applicationRequirementId);
        if (requirement == null) {
            throw new IllegalArgumentException("Requirement not found.");
        }

        ClearanceApplication application = clearanceApplicationDAO.findById(
                requirement.getClearanceApplicationId()
        );
        if (application == null ||
            application.getAssignedOfficerId() == null ||
            application.getAssignedOfficerId() != officerUserId) {
            throw new SecurityException("Officer is not assigned to this application.");
        }

        return applicationRequirementDAO.updateVerification(
                applicationRequirementId,
                normalizedStatus,
                officerUserId,
                officerRemarks
        );
    }

    @Override
    public boolean assignOfficer(
            long clearanceApplicationId,
            long officerUserId,
            long adminUserId
    ) throws SQLException {

        if (officerUserId <= 0 || adminUserId <= 0) {
            throw new IllegalArgumentException("Invalid user ID.");
        }

        ClearanceApplication application = clearanceApplicationDAO.findById(
                clearanceApplicationId
        );
        if (application == null) {
            throw new IllegalArgumentException("Application not found.");
        }

        boolean assigned = clearanceApplicationDAO.assignOfficer(
                clearanceApplicationId,
                officerUserId
        );

        if (assigned) {
            createHistory(
                    clearanceApplicationId,
                    application.getCurrentStatus(),
                    application.getCurrentStatus(),
                    adminUserId,
                    "ADMIN",
                    "Application assigned to officer ID " + officerUserId + "."
            );
        }

        return assigned;
    }

    @Override
    public boolean changeStatus(
            long clearanceApplicationId,
            String newStatus,
            long changedByUserId,
            String changedByRole,
            String remarks,
            String rejectionReason
    ) throws SQLException {

        String normalizedStatus = normalize(newStatus);
        String normalizedRole = normalize(changedByRole);

        if (!VALID_STATUSES.contains(normalizedStatus)) {
            throw new IllegalArgumentException("Invalid application status.");
        }
        if (!VALID_ROLES.contains(normalizedRole)) {
            throw new IllegalArgumentException("Invalid user role.");
        }

        ClearanceApplication application = clearanceApplicationDAO.findById(
                clearanceApplicationId
        );
        if (application == null) {
            throw new IllegalArgumentException("Application not found.");
        }

        validateActorAccess(application, changedByUserId, normalizedRole);
        validateStatusTransition(
                application.getCurrentStatus(),
                normalizedStatus,
                normalizedRole
        );

        if ("REJECTED".equals(normalizedStatus) &&
            (rejectionReason == null || rejectionReason.isBlank())) {
            throw new IllegalArgumentException("Rejection reason is required.");
        }

        boolean updated = clearanceApplicationDAO.updateStatus(
                clearanceApplicationId,
                normalizedStatus,
                remarks,
                rejectionReason
        );

        if (updated) {
            createHistory(
                    clearanceApplicationId,
                    application.getCurrentStatus(),
                    normalizedStatus,
                    changedByUserId,
                    normalizedRole,
                    remarks
            );
        }

        return updated;
    }

    @Override
    public List<ClearanceStatusHistory> getTimeline(
            long clearanceApplicationId
    ) throws SQLException {

        return statusHistoryDAO.findByApplicationId(clearanceApplicationId);
    }

    private void validateDraft(ClearanceApplication application) {
        if (application == null || application.getUserId() <= 0 ||
            application.getBusinessId() <= 0 ||
            application.getClearanceTypeId() <= 0) {
            throw new IllegalArgumentException("Invalid application details.");
        }
        if (isBlank(application.getProjectTitle()) ||
            isBlank(application.getState()) ||
            isBlank(application.getDistrict())) {
            throw new IllegalArgumentException(
                    "Project title, state and district are required."
            );
        }
    }

    private void validateBusinessOwnership(long businessId, long userId)
            throws SQLException {

        Business business = businessDAO.findByBusinessId(businessId);
        if (business == null || business.getUserId() != userId) {
            throw new SecurityException("Business access denied.");
        }
    }

    private boolean documentBelongsToBusiness(
            long documentId,
            long businessId,
            long userId
    ) throws SQLException {

        List<Document> documents = documentDAO.findByBusinessId(businessId);
        for (Document document : documents) {
            if (document.getDocumentId() == documentId &&
                document.getUserId() == userId &&
                document.isActive()) {
                return true;
            }
        }
        return false;
    }

    private void validateActorAccess(
            ClearanceApplication application,
            long changedByUserId,
            String changedByRole
    ) {
        if ("ENTREPRENEUR".equals(changedByRole) &&
            application.getUserId() != changedByUserId) {
            throw new SecurityException("Application access denied.");
        }

        if ("OFFICER".equals(changedByRole) &&
            (application.getAssignedOfficerId() == null ||
             application.getAssignedOfficerId() != changedByUserId)) {
            throw new SecurityException("Officer is not assigned to this application.");
        }
    }

    private void validateStatusTransition(
            String oldStatus,
            String newStatus,
            String changedByRole
    ) {
        if (oldStatus.equals(newStatus)) {
            throw new IllegalStateException("Application already has this status.");
        }
        if ("APPROVED".equals(oldStatus) ||
            "REJECTED".equals(oldStatus) ||
            "WITHDRAWN".equals(oldStatus)) {
            throw new IllegalStateException("Finalized application cannot be changed.");
        }
        if ("SUBMITTED".equals(newStatus)) {
            throw new IllegalStateException("Use the submit operation.");
        }
        if ("WITHDRAWN".equals(newStatus) &&
            !"ENTREPRENEUR".equals(changedByRole)) {
            throw new SecurityException("Only entrepreneur can withdraw application.");
        }
        if ("APPROVED".equals(newStatus) &&
            !("ADMIN".equals(changedByRole) ||
              "COMMITTEE".equals(changedByRole))) {
            throw new SecurityException("Only final authority can approve clearance.");
        }
    }

    private String generateApplicationNumber(
            ClearanceType clearanceType,
            long clearanceApplicationId
    ) {
        String code = clearanceType == null
                ? "CLR"
                : clearanceType.getClearanceCode();

        return String.format(
                "CHP-%s-%d-%06d",
                code,
                Year.now().getValue(),
                clearanceApplicationId
        );
    }

    private void createHistory(
            long applicationId,
            String oldStatus,
            String newStatus,
            Long userId,
            String role,
            String remarks
    ) throws SQLException {

        ClearanceStatusHistory history = new ClearanceStatusHistory();
        history.setClearanceApplicationId(applicationId);
        history.setOldStatus(oldStatus);
        history.setNewStatus(newStatus);
        history.setChangedByUserId(userId);
        history.setChangedByRole(role);
        history.setRemarks(remarks);

        statusHistoryDAO.createHistory(history);
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim().toUpperCase();
    }

    private boolean isBlank(String value) {
        return value == null || value.isBlank();
    }
}
