package com.chaperon.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.chaperon.dao.BusinessDAO;
import com.chaperon.model.Business;
import com.chaperon.util.DBConnection;

public class BusinessDAOImpl implements BusinessDAO {

    private static final String INSERT_BUSINESS =
            "INSERT INTO businesses " +
            "(user_id, business_name, business_constitution, " +
            "business_activity, industry, state, district, taluka, " +
            "industrial_area, pin_code, project_stage, investment_amount, " +
            "annual_turnover, interstate_supply, employee_count, land_area, built_up_area, power_requirement, " +
            "water_requirement, pollution_category, hazardous_material, " +
            "boiler_used, industrial_waste, groundwater_required, handles_personal_data, " +
            "seeks_stpi_benefits, located_in_sez, cert_in_applicable, " +
            "seeks_trademark_protection, seeks_software_copyright) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String FIND_BY_USER_ID =
            "SELECT * FROM businesses WHERE user_id = ? ORDER BY business_id DESC LIMIT 1";

    private static final String FIND_BY_BUSINESS_ID =
            "SELECT * FROM businesses WHERE business_id = ?";

    private static final String BUSINESS_EXISTS =
            "SELECT business_id FROM businesses WHERE user_id = ? LIMIT 1";

    private static final String UPDATE_BUSINESS =
            "UPDATE businesses SET " +
            "business_name = ?, " +
            "business_constitution = ?, " +
            "business_activity = ?, " +
            "industry = ?, " +
            "state = ?, " +
            "district = ?, " +
            "taluka = ?, " +
            "industrial_area = ?, " +
            "pin_code = ?, " +
            "project_stage = ?, " +
            "investment_amount = ?, " +
            "annual_turnover = ?, " +
            "interstate_supply = ?, " +
            "employee_count = ?, " +
            "land_area = ?, " +
            "built_up_area = ?, " +
            "power_requirement = ?, " +
            "water_requirement = ?, " +
            "pollution_category = ?, " +
            "hazardous_material = ?, " +
            "boiler_used = ?, " +
            "industrial_waste = ?, " +
            "groundwater_required = ?, " +
            "handles_personal_data = ?, " +
            "seeks_stpi_benefits = ?, " +
            "located_in_sez = ?, " +
            "cert_in_applicable = ?, " +
            "seeks_trademark_protection = ?, " +
            "seeks_software_copyright = ? " +
            "WHERE business_id = ?";

    @Override
    public long createBusiness(Business business)
            throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();

            PreparedStatement preparedStatement =
                    connection.prepareStatement(
                            INSERT_BUSINESS,
                            Statement.RETURN_GENERATED_KEYS
                    )
        ) {

            setBusinessParametersForInsert(
                    preparedStatement,
                    business
            );

            int rowsAffected =
                    preparedStatement.executeUpdate();

            if (rowsAffected == 0) {
                return -1;
            }

            try (
                ResultSet generatedKeys =
                        preparedStatement.getGeneratedKeys()
            ) {

                if (generatedKeys.next()) {
                    return generatedKeys.getLong(1);
                }
            }

            return -1;
        }
    }

    @Override
    public Business findByUserId(long userId)
            throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();

            PreparedStatement preparedStatement =
                    connection.prepareStatement(
                            FIND_BY_USER_ID
                    )
        ) {

            preparedStatement.setLong(
                    1,
                    userId
            );

            try (
                ResultSet resultSet =
                        preparedStatement.executeQuery()
            ) {

                if (resultSet.next()) {
                    return mapResultSetToBusiness(
                            resultSet
                    );
                }
            }
        }

        return null;
    }

    @Override
    public Business findByBusinessId(long businessId)
            throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();

            PreparedStatement preparedStatement =
                    connection.prepareStatement(
                            FIND_BY_BUSINESS_ID
                    )
        ) {

            preparedStatement.setLong(
                    1,
                    businessId
            );

            try (
                ResultSet resultSet =
                        preparedStatement.executeQuery()
            ) {

                if (resultSet.next()) {
                    return mapResultSetToBusiness(
                            resultSet
                    );
                }
            }
        }

        return null;
    }

    @Override
    public boolean updateBusiness(Business business)
            throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();

            PreparedStatement preparedStatement =
                    connection.prepareStatement(
                            UPDATE_BUSINESS
                    )
        ) {

            int index = 1;

            preparedStatement.setString(
                    index++,
                    business.getBusinessName()
            );

            preparedStatement.setString(
                    index++,
                    business.getBusinessConstitution()
            );

            preparedStatement.setString(
                    index++,
                    business.getBusinessActivity()
            );

            preparedStatement.setString(
                    index++,
                    business.getIndustry()
            );

            preparedStatement.setString(
                    index++,
                    business.getState()
            );

            preparedStatement.setString(
                    index++,
                    business.getDistrict()
            );

            preparedStatement.setString(
                    index++,
                    business.getTaluka()
            );

            preparedStatement.setString(
                    index++,
                    business.getIndustrialArea()
            );

            preparedStatement.setString(
                    index++,
                    business.getPinCode()
            );

            preparedStatement.setString(
                    index++,
                    business.getProjectStage()
            );

            preparedStatement.setBigDecimal(
                    index++,
                    business.getInvestmentAmount()
            );

            preparedStatement.setBigDecimal(index++, business.getAnnualTurnover());
            preparedStatement.setBoolean(index++, business.isInterstateSupply());

            preparedStatement.setInt(
                    index++,
                    business.getEmployeeCount()
            );

            preparedStatement.setBigDecimal(
                    index++,
                    business.getLandArea()
            );

            preparedStatement.setBigDecimal(
                    index++,
                    business.getBuiltUpArea()
            );

            preparedStatement.setBigDecimal(
                    index++,
                    business.getPowerRequirement()
            );

            preparedStatement.setBigDecimal(
                    index++,
                    business.getWaterRequirement()
            );

            preparedStatement.setString(
                    index++,
                    business.getPollutionCategory()
            );

            preparedStatement.setBoolean(
                    index++,
                    business.isHazardousMaterial()
            );

            preparedStatement.setBoolean(
                    index++,
                    business.isBoilerUsed()
            );

            preparedStatement.setBoolean(
                    index++,
                    business.isIndustrialWaste()
            );

            preparedStatement.setBoolean(
                    index++,
                    business.isGroundwaterRequired()
            );

            preparedStatement.setBoolean(index++, business.isHandlesPersonalData());
            preparedStatement.setBoolean(index++, business.isSeeksStpiBenefits());
            preparedStatement.setBoolean(index++, business.isLocatedInSez());
            preparedStatement.setBoolean(index++, business.isCertInApplicable());
            preparedStatement.setBoolean(index++, business.isSeeksTrademarkProtection());
            preparedStatement.setBoolean(index++, business.isSeeksSoftwareCopyright());

            preparedStatement.setLong(
                    index,
                    business.getBusinessId()
            );

            int rowsAffected =
                    preparedStatement.executeUpdate();

            return rowsAffected > 0;
        }
    }

    @Override
    public boolean businessExistsForUser(long userId)
            throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();

            PreparedStatement preparedStatement =
                    connection.prepareStatement(
                            BUSINESS_EXISTS
                    )
        ) {

            preparedStatement.setLong(
                    1,
                    userId
            );

            try (
                ResultSet resultSet =
                        preparedStatement.executeQuery()
            ) {

                return resultSet.next();
            }
        }
    }

    private void setBusinessParametersForInsert(
            PreparedStatement preparedStatement,
            Business business
    ) throws SQLException {

        int index = 1;

        preparedStatement.setLong(
                index++,
                business.getUserId()
        );

        preparedStatement.setString(
                index++,
                business.getBusinessName()
        );

        preparedStatement.setString(
                index++,
                business.getBusinessConstitution()
        );

        preparedStatement.setString(
                index++,
                business.getBusinessActivity()
        );

        preparedStatement.setString(
                index++,
                business.getIndustry()
        );

        preparedStatement.setString(
                index++,
                business.getState()
        );

        preparedStatement.setString(
                index++,
                business.getDistrict()
        );

        preparedStatement.setString(
                index++,
                business.getTaluka()
        );

        preparedStatement.setString(
                index++,
                business.getIndustrialArea()
        );

        preparedStatement.setString(
                index++,
                business.getPinCode()
        );

        preparedStatement.setString(
                index++,
                business.getProjectStage()
        );

        preparedStatement.setBigDecimal(
                index++,
                business.getInvestmentAmount()
        );

        preparedStatement.setBigDecimal(index++, business.getAnnualTurnover());
        preparedStatement.setBoolean(index++, business.isInterstateSupply());

        preparedStatement.setInt(
                index++,
                business.getEmployeeCount()
        );

        preparedStatement.setBigDecimal(
                index++,
                business.getLandArea()
        );

        preparedStatement.setBigDecimal(
                index++,
                business.getBuiltUpArea()
        );

        preparedStatement.setBigDecimal(
                index++,
                business.getPowerRequirement()
        );

        preparedStatement.setBigDecimal(
                index++,
                business.getWaterRequirement()
        );

        preparedStatement.setString(
                index++,
                business.getPollutionCategory()
        );

        preparedStatement.setBoolean(
                index++,
                business.isHazardousMaterial()
        );

        preparedStatement.setBoolean(
                index++,
                business.isBoilerUsed()
        );

        preparedStatement.setBoolean(
                index++,
                business.isIndustrialWaste()
        );

        preparedStatement.setBoolean(
                index++,
                business.isGroundwaterRequired()
        );

        preparedStatement.setBoolean(index++, business.isHandlesPersonalData());
        preparedStatement.setBoolean(index++, business.isSeeksStpiBenefits());
        preparedStatement.setBoolean(index++, business.isLocatedInSez());
        preparedStatement.setBoolean(index++, business.isCertInApplicable());
        preparedStatement.setBoolean(index++, business.isSeeksTrademarkProtection());
        preparedStatement.setBoolean(index, business.isSeeksSoftwareCopyright());
    }

    private Business mapResultSetToBusiness(
            ResultSet resultSet
    ) throws SQLException {

        Business business = new Business();

        business.setBusinessId(
                resultSet.getLong(
                        "business_id"
                )
        );

        business.setUserId(
                resultSet.getLong(
                        "user_id"
                )
        );

        business.setBusinessName(
                resultSet.getString(
                        "business_name"
                )
        );

        business.setBusinessConstitution(
                resultSet.getString(
                        "business_constitution"
                )
        );

        business.setBusinessActivity(
                resultSet.getString(
                        "business_activity"
                )
        );

        business.setIndustry(
                resultSet.getString(
                        "industry"
                )
        );

        business.setState(
                resultSet.getString(
                        "state"
                )
        );

        business.setDistrict(
                resultSet.getString(
                        "district"
                )
        );

        business.setTaluka(
                resultSet.getString(
                        "taluka"
                )
        );

        business.setIndustrialArea(
                resultSet.getString(
                        "industrial_area"
                )
        );

        business.setPinCode(
                resultSet.getString(
                        "pin_code"
                )
        );

        business.setProjectStage(
                resultSet.getString(
                        "project_stage"
                )
        );

        business.setInvestmentAmount(
                resultSet.getBigDecimal(
                        "investment_amount"
                )
        );

        business.setAnnualTurnover(resultSet.getBigDecimal("annual_turnover"));
        business.setInterstateSupply(resultSet.getBoolean("interstate_supply"));

        business.setEmployeeCount(
                resultSet.getInt(
                        "employee_count"
                )
        );

        business.setLandArea(
                resultSet.getBigDecimal(
                        "land_area"
                )
        );

        business.setBuiltUpArea(
                resultSet.getBigDecimal(
                        "built_up_area"
                )
        );

        business.setPowerRequirement(
                resultSet.getBigDecimal(
                        "power_requirement"
                )
        );

        business.setWaterRequirement(
                resultSet.getBigDecimal(
                        "water_requirement"
                )
        );

        business.setPollutionCategory(
                resultSet.getString(
                        "pollution_category"
                )
        );

        business.setHazardousMaterial(
                resultSet.getBoolean(
                        "hazardous_material"
                )
        );

        business.setBoilerUsed(
                resultSet.getBoolean(
                        "boiler_used"
                )
        );

        business.setIndustrialWaste(
                resultSet.getBoolean(
                        "industrial_waste"
                )
        );

        business.setGroundwaterRequired(
                resultSet.getBoolean(
                        "groundwater_required"
                )
        );

        business.setHandlesPersonalData(resultSet.getBoolean("handles_personal_data"));
        business.setSeeksStpiBenefits(resultSet.getBoolean("seeks_stpi_benefits"));
        business.setLocatedInSez(resultSet.getBoolean("located_in_sez"));
        business.setCertInApplicable(resultSet.getBoolean("cert_in_applicable"));
        business.setSeeksTrademarkProtection(resultSet.getBoolean("seeks_trademark_protection"));
        business.setSeeksSoftwareCopyright(resultSet.getBoolean("seeks_software_copyright"));

        business.setCreatedAt(
                resultSet.getTimestamp(
                        "created_at"
                )
        );

        business.setUpdatedAt(
                resultSet.getTimestamp(
                        "updated_at"
                )
        );

        return business;
    }
}
