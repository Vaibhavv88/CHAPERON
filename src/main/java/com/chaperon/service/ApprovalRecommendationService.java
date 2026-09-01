package com.chaperon.service;

import java.sql.SQLException;
import java.util.List;

import com.chaperon.model.BusinessApproval;

public interface ApprovalRecommendationService {

    List<BusinessApproval> generateRecommendations(
            long userId
    ) throws SQLException;

    List<BusinessApproval> getRecommendations(
            long userId
    ) throws SQLException;
}