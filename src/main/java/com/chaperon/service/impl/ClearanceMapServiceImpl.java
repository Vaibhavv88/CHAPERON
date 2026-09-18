package com.chaperon.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;

import com.chaperon.dao.ClearanceMapDAO;
import com.chaperon.dao.impl.ClearanceMapDAOImpl;
import com.chaperon.model.ClearanceApplicationMap;
import com.chaperon.service.ClearanceMapService;

public class ClearanceMapServiceImpl
        implements ClearanceMapService {

    private final ClearanceMapDAO clearanceMapDAO;

    public ClearanceMapServiceImpl() {
        clearanceMapDAO =
                new ClearanceMapDAOImpl();
    }

    @Override
    public long saveOrUpdateMap(
            ClearanceApplicationMap clearanceMap)
            throws SQLException {

        validateMap(clearanceMap);

        boolean existingMap =
                clearanceMapDAO.mapExists(
                        clearanceMap
                                .getClearanceApplicationId());

        if (existingMap) {

            boolean updated =
                    clearanceMapDAO.updateMap(
                            clearanceMap);

            if (!updated) {
                throw new SQLException(
                        "Project map could not be updated.");
            }

            ClearanceApplicationMap savedMap =
                    clearanceMapDAO
                            .getMapByApplicationId(
                                    clearanceMap
                                            .getClearanceApplicationId());

            if (savedMap == null) {
                throw new SQLException(
                        "Updated project map could not be retrieved.");
            }

            return savedMap.getClearanceMapId();
        }

        return clearanceMapDAO.saveMap(
                clearanceMap);
    }

    @Override
    public ClearanceApplicationMap getMapByApplicationId(
            long clearanceApplicationId)
            throws SQLException {

        if (clearanceApplicationId <= 0) {
            throw new IllegalArgumentException(
                    "A valid clearance application ID is required.");
        }

        return clearanceMapDAO
                .getMapByApplicationId(
                        clearanceApplicationId);
    }

    @Override
    public boolean deleteMap(
            long clearanceApplicationId)
            throws SQLException {

        if (clearanceApplicationId <= 0) {
            throw new IllegalArgumentException(
                    "A valid clearance application ID is required.");
        }

        return clearanceMapDAO
                .deleteMap(
                        clearanceApplicationId);
    }

    private void validateMap(
            ClearanceApplicationMap clearanceMap) {

        if (clearanceMap == null) {
            throw new IllegalArgumentException(
                    "Project map information is required.");
        }

        if (clearanceMap.getClearanceApplicationId()
                <= 0) {

            throw new IllegalArgumentException(
                    "A valid clearance application ID is required.");
        }

        if (clearanceMap.getUploadedByUserId()
                <= 0) {

            throw new IllegalArgumentException(
                    "Map uploader information is required.");
        }

        BigDecimal latitude =
                clearanceMap.getCentreLatitude();

        BigDecimal longitude =
                clearanceMap.getCentreLongitude();

        if (latitude == null
                || longitude == null) {

            throw new IllegalArgumentException(
                    "Please select the project location on the map.");
        }

        BigDecimal minimumLatitude =
                new BigDecimal("-90");

        BigDecimal maximumLatitude =
                new BigDecimal("90");

        if (latitude.compareTo(minimumLatitude) < 0
                || latitude.compareTo(maximumLatitude) > 0) {

            throw new IllegalArgumentException(
                    "Latitude must be between -90 and 90.");
        }

        BigDecimal minimumLongitude =
                new BigDecimal("-180");

        BigDecimal maximumLongitude =
                new BigDecimal("180");

        if (longitude.compareTo(minimumLongitude) < 0
                || longitude.compareTo(maximumLongitude) > 0) {

            throw new IllegalArgumentException(
                    "Longitude must be between -180 and 180.");
        }

        BigDecimal calculatedArea =
                clearanceMap
                        .getCalculatedAreaHectares();

        if (calculatedArea != null
                && calculatedArea.compareTo(
                        BigDecimal.ZERO) < 0) {

            throw new IllegalArgumentException(
                    "Calculated project area cannot be negative.");
        }

        if (isBlank(clearanceMap.getMapName())) {
            clearanceMap.setMapName(
                    "Project Boundary");
        }

        if (isBlank(clearanceMap.getMapType())) {
            clearanceMap.setMapType(
                    "PROJECT_BOUNDARY");
        }

        if (isBlank(
                clearanceMap.getBoundarySource())) {

            clearanceMap.setBoundarySource(
                    "DRAWN_ON_MAP");
        }

        if (isBlank(
                clearanceMap.getValidationStatus())) {

            clearanceMap.setValidationStatus(
                    "PENDING");
        }
    }

    private boolean isBlank(String value) {
        return value == null
                || value.trim().isEmpty();
    }
}