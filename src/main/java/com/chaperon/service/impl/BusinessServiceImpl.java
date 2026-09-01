package com.chaperon.service.impl;

import java.sql.SQLException;

import com.chaperon.dao.BusinessDAO;
import com.chaperon.dao.impl.BusinessDAOImpl;
import com.chaperon.model.Business;
import com.chaperon.service.BusinessService;

import com.chaperon.dao.OnboardingProgressDAO;
import com.chaperon.dao.impl.OnboardingProgressDAOImpl;
public class BusinessServiceImpl implements BusinessService {

    private final BusinessDAO businessDAO;
	private OnboardingProgressDAOImpl onboardingProgressDAO;

    public BusinessServiceImpl() {

        this.businessDAO =
                new BusinessDAOImpl();

        this.onboardingProgressDAO =
                new OnboardingProgressDAOImpl();
    }
    @Override
    public boolean completeOnboarding(
            long userId,
            long businessId
    ) throws SQLException {

        if (userId <= 0 ||
            businessId <= 0) {

            return false;
        }

        return onboardingProgressDAO.markCompleted(
                userId,
                businessId
        );
    }
    @Override
    public long createBusiness(Business business)
            throws SQLException {

        if (business == null) {
            return -1;
        }

        if (business.getUserId() <= 0) {
            return -1;
        }

        if (business.getBusinessName() == null ||
            business.getBusinessName().isBlank()) {

            return -1;
        }

        return businessDAO.createBusiness(business);
    }

    @Override
    public Business getBusinessByUserId(long userId)
            throws SQLException {

        if (userId <= 0) {
            return null;
        }

        return businessDAO.findByUserId(userId);
    }

    @Override
    public Business getBusinessById(long businessId)
            throws SQLException {

        if (businessId <= 0) {
            return null;
        }

        return businessDAO.findByBusinessId(businessId);
    }

    @Override
    public boolean updateBusiness(Business business)
            throws SQLException {

        if (business == null) {
            return false;
        }

        if (business.getBusinessId() <= 0) {
            return false;
        }

        return businessDAO.updateBusiness(business);
    }

    @Override
    public boolean hasBusiness(long userId)
            throws SQLException {

        if (userId <= 0) {
            return false;
        }

        return businessDAO.businessExistsForUser(userId);
    }
}