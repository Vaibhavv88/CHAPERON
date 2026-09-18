package com.chaperon.dao;

import java.sql.SQLException;
import java.util.List;

import com.chaperon.model.GisFeature;
import com.chaperon.model.GisLayer;

public interface GisLayerDAO {

    long saveLayer(
            GisLayer gisLayer
    ) throws SQLException;

    boolean updateLayer(
            GisLayer gisLayer
    ) throws SQLException;

    boolean updateLayerStatus(
            long gisLayerId,
            boolean active
    ) throws SQLException;

    GisLayer findLayerById(
            long gisLayerId
    ) throws SQLException;

    GisLayer findLayerByCode(
            String layerCode
    ) throws SQLException;

    List<GisLayer> findAllLayers()
            throws SQLException;

    List<GisLayer> findActiveLayers()
            throws SQLException;

    List<GisLayer> findApplicableLayers(
            String stateName,
            String districtName
    ) throws SQLException;

    long saveFeature(
            GisFeature gisFeature
    ) throws SQLException;

    int saveFeatures(
            List<GisFeature> gisFeatures
    ) throws SQLException;

    GisFeature findFeatureById(
            long gisFeatureId
    ) throws SQLException;

    List<GisFeature> findFeaturesByLayerId(
            long gisLayerId
    ) throws SQLException;

    List<GisFeature> findActiveFeaturesByLayerId(
            long gisLayerId
    ) throws SQLException;

    boolean updateFeatureStatus(
            long gisFeatureId,
            boolean active
    ) throws SQLException;

    int countFeaturesByLayerId(
            long gisLayerId
    ) throws SQLException;

    boolean layerCodeExists(
            String layerCode
    ) throws SQLException;

    boolean featureCodeExists(
            long gisLayerId,
            String featureCode
    ) throws SQLException;
}