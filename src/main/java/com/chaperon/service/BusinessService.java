package com.chaperon.service;

import java.sql.SQLException;

import com.chaperon.model.Business;

public interface BusinessService {

	long createBusiness(Business business) throws SQLException;

	Business getBusinessByUserId(long userId) throws SQLException;

	Business getBusinessById(long businessId) throws SQLException;

	boolean updateBusiness(Business business) throws SQLException;

	boolean hasBusiness(long userId) throws SQLException;

	boolean completeOnboarding(
	        long userId,
	        long businessId
	) throws SQLException;

}