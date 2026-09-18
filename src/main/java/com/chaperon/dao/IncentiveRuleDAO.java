package com.chaperon.dao;

import java.util.List;

import com.chaperon.model.IncentiveRule;

public interface IncentiveRuleDAO {

    List<IncentiveRule> findActiveRules()
            throws Exception;
}