-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: chaperon_db
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `chaperon_db`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `chaperon_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `chaperon_db`;

--
-- Table structure for table `application_documents`
--

DROP TABLE IF EXISTS `application_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_documents` (
  `application_document_id` bigint NOT NULL AUTO_INCREMENT,
  `application_id` bigint NOT NULL,
  `document_id` bigint NOT NULL,
  `attached_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`application_document_id`),
  UNIQUE KEY `application_id` (`application_id`,`document_id`),
  KEY `fk_appdocument_document` (`document_id`),
  CONSTRAINT `fk_appdocument_application` FOREIGN KEY (`application_id`) REFERENCES `applications` (`application_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_appdocument_document` FOREIGN KEY (`document_id`) REFERENCES `documents` (`document_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_documents`
--

LOCK TABLES `application_documents` WRITE;
/*!40000 ALTER TABLE `application_documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `application_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `application_queries`
--

DROP TABLE IF EXISTS `application_queries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_queries` (
  `query_id` bigint NOT NULL AUTO_INCREMENT,
  `application_id` bigint NOT NULL,
  `raised_by_officer_id` bigint NOT NULL,
  `query_description` text NOT NULL,
  `raised_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `response_deadline` date DEFAULT NULL,
  `status` varchar(20) DEFAULT 'OPEN',
  `entrepreneur_response` text,
  `responded_at` timestamp NULL DEFAULT NULL,
  `resolved_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`query_id`),
  KEY `idx_query_application` (`application_id`),
  KEY `fk_query_officer_profile` (`raised_by_officer_id`),
  CONSTRAINT `fk_query_application` FOREIGN KEY (`application_id`) REFERENCES `applications` (`application_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_query_officer_profile` FOREIGN KEY (`raised_by_officer_id`) REFERENCES `officer_profiles` (`officer_profile_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_queries`
--

LOCK TABLES `application_queries` WRITE;
/*!40000 ALTER TABLE `application_queries` DISABLE KEYS */;
INSERT INTO `application_queries` VALUES (1,1,1,'noting','2026-08-30 04:19:11','2026-08-31','RESOLVED','I have reviewed the officer query and updated the requested information.\r\nPlease review my application again.','2026-08-30 04:35:16','2026-08-30 04:41:58','2026-08-30 04:41:58');
/*!40000 ALTER TABLE `application_queries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `application_status_history`
--

DROP TABLE IF EXISTS `application_status_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_status_history` (
  `history_id` bigint NOT NULL AUTO_INCREMENT,
  `application_id` bigint NOT NULL,
  `old_status` varchar(40) DEFAULT NULL,
  `new_status` varchar(40) NOT NULL,
  `changed_by` bigint DEFAULT NULL,
  `changed_by_role` varchar(30) DEFAULT NULL,
  `remarks` text,
  `changed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`history_id`),
  KEY `fk_history_application` (`application_id`),
  KEY `fk_history_user` (`changed_by`),
  CONSTRAINT `fk_history_application` FOREIGN KEY (`application_id`) REFERENCES `applications` (`application_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_history_user` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_status_history`
--

LOCK TABLES `application_status_history` WRITE;
/*!40000 ALTER TABLE `application_status_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `application_status_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications`
--

DROP TABLE IF EXISTS `applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `applications` (
  `application_id` bigint NOT NULL AUTO_INCREMENT,
  `application_number` varchar(80) NOT NULL,
  `user_id` bigint NOT NULL,
  `business_id` bigint NOT NULL,
  `approval_id` bigint NOT NULL,
  `department_id` bigint NOT NULL,
  `assigned_officer_id` bigint DEFAULT NULL,
  `previous_application_id` bigint DEFAULT NULL,
  `submission_date` timestamp NULL DEFAULT NULL,
  `current_status` varchar(40) DEFAULT 'DRAFT',
  `sla_days` int DEFAULT NULL,
  `expected_completion_date` date DEFAULT NULL,
  `risk_level` varchar(20) DEFAULT 'LOW',
  `officer_remarks` text,
  `rejection_reason` text,
  `can_reapply` tinyint(1) DEFAULT '1',
  `rejected_by` bigint DEFAULT NULL,
  `rejected_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`application_id`),
  UNIQUE KEY `application_number` (`application_number`),
  KEY `fk_application_approval` (`approval_id`),
  KEY `fk_previous_application` (`previous_application_id`),
  KEY `fk_application_rejected_by` (`rejected_by`),
  KEY `idx_application_user` (`user_id`),
  KEY `idx_application_business` (`business_id`),
  KEY `idx_application_status` (`current_status`),
  KEY `idx_application_officer` (`assigned_officer_id`),
  KEY `idx_application_department` (`department_id`),
  CONSTRAINT `fk_application_approval` FOREIGN KEY (`approval_id`) REFERENCES `approvals` (`approval_id`),
  CONSTRAINT `fk_application_business` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`),
  CONSTRAINT `fk_application_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`),
  CONSTRAINT `fk_application_officer_profile` FOREIGN KEY (`assigned_officer_id`) REFERENCES `officer_profiles` (`officer_profile_id`),
  CONSTRAINT `fk_application_rejected_by` FOREIGN KEY (`rejected_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_application_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_previous_application` FOREIGN KEY (`previous_application_id`) REFERENCES `applications` (`application_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications`
--

LOCK TABLES `applications` WRITE;
/*!40000 ALTER TABLE `applications` DISABLE KEYS */;
INSERT INTO `applications` VALUES (1,'CHP-FSSAI-2026-303120',1,1,1,1,1,NULL,'2026-08-28 15:43:17','APPROVED',30,'2026-09-27','LOW','Application documents and officer query response have been reviewed successfully. The application satisfies the applicable requirements.',NULL,1,NULL,NULL,'2026-08-28 15:18:23','2026-08-30 04:55:55'),(2,'CHP-FACTORYLICENSE-2026-318294',1,1,5,5,5,NULL,'2026-08-28 15:52:00','REJECTED',45,'2026-10-12','LOW','Application reviewed. Mandatory documentation requirements are not fully satisfied.','Incomplete Documentation: Required supporting documents are incomplete. Please provide the missing documents before submitting a new application.',1,7,'2026-08-30 05:06:23','2026-08-28 15:51:58','2026-08-30 05:06:23'),(3,'CHP-FIRENOC-2026-346157',1,1,2,2,2,NULL,'2026-08-30 05:55:49','APPROVED',30,'2026-09-29','LOW','good',NULL,1,NULL,NULL,'2026-08-30 05:55:46','2026-08-30 06:32:50'),(4,'CHP-FSSAI-2026-434449',1,1,1,1,NULL,NULL,NULL,'DRAFT',30,NULL,'LOW',NULL,NULL,1,NULL,NULL,'2026-08-30 08:27:14','2026-08-30 08:27:14'),(5,'CHP-FIRENOC-2026-218545',1,1,2,2,2,NULL,'2026-08-30 08:40:26','REJECTED',30,'2026-09-29','LOW','kjhkgb','Failed Inspection: jgfvg',1,4,'2026-08-31 07:28:41','2026-08-30 08:40:18','2026-08-31 07:28:41'),(6,'CHP-FSSAI-2026-251860',10,3,1,1,1,NULL,'2026-08-31 16:04:15','REJECTED',30,'2026-09-30','LOW','no','Eligibility Not Met: nothing',1,3,'2026-08-31 16:10:49','2026-08-31 16:04:11','2026-08-31 16:10:49'),(7,'CHP-FSSAI-2026-041604',10,3,1,1,1,NULL,'2026-08-31 16:38:46','APPROVED',30,'2026-09-30','LOW','good',NULL,1,NULL,NULL,'2026-08-31 16:17:21','2026-08-31 16:39:26'),(8,'CHP-POLLUTIONCONSENT-2026-126822',11,4,3,3,NULL,NULL,'2026-09-01 07:02:25','SUBMITTED',45,'2026-10-16','LOW',NULL,NULL,1,NULL,NULL,'2026-09-01 07:02:06','2026-09-01 07:02:25');
/*!40000 ALTER TABLE `applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `approval_certificates`
--

DROP TABLE IF EXISTS `approval_certificates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `approval_certificates` (
  `certificate_id` bigint NOT NULL AUTO_INCREMENT,
  `application_id` bigint NOT NULL,
  `approval_number` varchar(100) NOT NULL,
  `approved_by` bigint NOT NULL,
  `approval_date` date NOT NULL,
  `valid_from` date DEFAULT NULL,
  `valid_until` date DEFAULT NULL,
  `remarks` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`certificate_id`),
  UNIQUE KEY `application_id` (`application_id`),
  UNIQUE KEY `approval_number` (`approval_number`),
  KEY `fk_certificate_approver` (`approved_by`),
  CONSTRAINT `fk_certificate_application` FOREIGN KEY (`application_id`) REFERENCES `applications` (`application_id`),
  CONSTRAINT `fk_certificate_approver` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `approval_certificates`
--

LOCK TABLES `approval_certificates` WRITE;
/*!40000 ALTER TABLE `approval_certificates` DISABLE KEYS */;
INSERT INTO `approval_certificates` VALUES (1,1,'CHP-FSSAI-2026-000001',3,'2026-08-30','2026-08-30',NULL,'Application documents and officer query response have been reviewed successfully. The application satisfies the applicable requirements.','2026-08-30 04:55:55'),(2,3,'CHP-FIRENOC-2026-000003',4,'2026-08-30','2026-08-30',NULL,'good','2026-08-30 06:32:50'),(3,7,'CHP-FSSAI-2026-000007',3,'2026-08-31','2026-08-31',NULL,'good','2026-08-31 16:39:26');
/*!40000 ALTER TABLE `approval_certificates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `approval_document_requirements`
--

DROP TABLE IF EXISTS `approval_document_requirements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `approval_document_requirements` (
  `requirement_id` bigint NOT NULL AUTO_INCREMENT,
  `approval_id` bigint NOT NULL,
  `document_type` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `mandatory` tinyint(1) DEFAULT '1',
  `active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`requirement_id`),
  KEY `fk_document_requirement_approval` (`approval_id`),
  CONSTRAINT `fk_document_requirement_approval` FOREIGN KEY (`approval_id`) REFERENCES `approvals` (`approval_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `approval_document_requirements`
--

LOCK TABLES `approval_document_requirements` WRITE;
/*!40000 ALTER TABLE `approval_document_requirements` DISABLE KEYS */;
INSERT INTO `approval_document_requirements` VALUES (1,1,'PAN','PAN of applicant or business',1,1),(2,1,'BUSINESS_REGISTRATION','Business registration proof',1,1),(3,1,'FACTORY_LAYOUT','Applicable manufacturing or premises layout',1,1),(4,2,'PAN','Applicant PAN document',1,1),(5,2,'BUILDING_PLAN','Building plan',1,1),(6,2,'FIRE_LAYOUT','Fire safety layout',1,1),(7,5,'PAN','PAN document',1,1),(8,5,'BUSINESS_REGISTRATION','Business registration document',1,1),(9,5,'FACTORY_LAYOUT','Factory layout document',1,1),(10,5,'LAND_DOCUMENT','Land or premises document',1,1);
/*!40000 ALTER TABLE `approval_document_requirements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `approval_rules`
--

DROP TABLE IF EXISTS `approval_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `approval_rules` (
  `rule_id` bigint NOT NULL AUTO_INCREMENT,
  `approval_id` bigint NOT NULL,
  `rule_name` varchar(200) DEFAULT NULL,
  `industry` varchar(100) DEFAULT NULL,
  `business_activity` varchar(50) DEFAULT NULL,
  `project_stage` varchar(50) DEFAULT NULL,
  `pollution_category` varchar(20) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `minimum_employee_count` int DEFAULT NULL,
  `maximum_employee_count` int DEFAULT NULL,
  `minimum_investment` decimal(15,2) DEFAULT NULL,
  `maximum_investment` decimal(15,2) DEFAULT NULL,
  `hazardous_material_required` tinyint(1) DEFAULT NULL,
  `boiler_required` tinyint(1) DEFAULT NULL,
  `groundwater_required` tinyint(1) DEFAULT NULL,
  `industrial_waste_required` tinyint(1) DEFAULT NULL,
  `priority` varchar(20) DEFAULT 'MEDIUM',
  `recommendation_reason` text,
  `active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`rule_id`),
  KEY `fk_rule_approval` (`approval_id`),
  CONSTRAINT `fk_rule_approval` FOREIGN KEY (`approval_id`) REFERENCES `approvals` (`approval_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `approval_rules`
--

LOCK TABLES `approval_rules` WRITE;
/*!40000 ALTER TABLE `approval_rules` DISABLE KEYS */;
INSERT INTO `approval_rules` VALUES (1,1,'Food Manufacturing FSSAI Rule','Food Processing','Manufacturing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'HIGH','Your business is involved in food processing and manufacturing activities.',1,'2026-08-27 06:59:12','2026-08-28 07:33:54'),(2,5,'Food Manufacturing Factory Rule','Food Processing','Manufacturing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'HIGH','Manufacturing activities may require applicable factory-related approvals.',1,'2026-08-27 06:59:23','2026-08-28 07:33:54'),(3,2,'Food Manufacturing Fire Safety','Food Processing','Manufacturing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'HIGH','Industrial premises may require applicable fire safety clearance.',1,'2026-08-27 06:59:49','2026-08-28 07:33:54'),(4,3,'Chemical Pollution Rule','Chemical','Manufacturing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'HIGH','Chemical manufacturing may require environmental consent depending on operations and pollution category.',1,'2026-08-27 06:59:57','2026-08-28 07:33:54'),(5,5,'Chemical Factory Rule','Chemical','Manufacturing',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'HIGH','Manufacturing operations may require applicable factory licensing.',1,'2026-08-27 07:00:47','2026-08-28 07:33:54'),(6,6,'Boiler Usage Rule',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,'HIGH','You indicated that your business uses a boiler.',1,'2026-08-27 07:00:56','2026-08-28 07:33:54');
/*!40000 ALTER TABLE `approval_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `approvals`
--

DROP TABLE IF EXISTS `approvals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `approvals` (
  `approval_id` bigint NOT NULL AUTO_INCREMENT,
  `approval_name` varchar(200) NOT NULL,
  `approval_code` varchar(50) NOT NULL,
  `department_id` bigint NOT NULL,
  `description` text,
  `minimum_processing_days` int DEFAULT NULL,
  `maximum_processing_days` int DEFAULT NULL,
  `sla_days` int DEFAULT NULL,
  `validity_type` varchar(40) DEFAULT NULL,
  `validity_value` int DEFAULT NULL,
  `renewal_required` tinyint(1) DEFAULT '0',
  `renewal_before_days` int DEFAULT NULL,
  `inspection_required` tinyint(1) DEFAULT '0',
  `official_reference_url` varchar(500) DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`approval_id`),
  UNIQUE KEY `approval_code` (`approval_code`),
  KEY `fk_approval_department` (`department_id`),
  CONSTRAINT `fk_approval_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `approvals`
--

LOCK TABLES `approvals` WRITE;
/*!40000 ALTER TABLE `approvals` DISABLE KEYS */;
INSERT INTO `approvals` VALUES (1,'FSSAI Registration / License','FSSAI',1,'Food safety related registration or licence for applicable food businesses.',7,30,30,'CONFIGURABLE',NULL,1,30,0,NULL,1,'2026-08-27 06:58:40','2026-08-27 06:58:40'),(2,'Fire NOC','FIRE_NOC',2,'Fire safety clearance for applicable premises and operations.',7,30,30,'CONFIGURABLE',NULL,1,30,1,NULL,1,'2026-08-27 06:58:40','2026-08-27 06:58:40'),(3,'Pollution Consent','POLLUTION_CONSENT',3,'Environmental consent for applicable industrial operations.',15,45,45,'CONFIGURABLE',NULL,1,60,1,NULL,1,'2026-08-27 06:58:40','2026-08-27 06:58:40'),(4,'Labour Registration','LABOUR_REG',4,'Applicable labour and employment related registration.',7,30,30,'CONFIGURABLE',NULL,1,30,0,NULL,1,'2026-08-27 06:58:40','2026-08-27 06:58:40'),(5,'Factory License','FACTORY_LICENSE',5,'Factory related licensing for applicable manufacturing units.',15,45,45,'CONFIGURABLE',NULL,1,60,1,NULL,1,'2026-08-27 06:58:40','2026-08-27 06:58:40'),(6,'Boiler Registration','BOILER_REG',6,'Registration and inspection requirements for applicable boiler installations.',15,45,45,'CONFIGURABLE',NULL,1,60,1,NULL,1,'2026-08-27 06:58:40','2026-08-27 06:58:40');
/*!40000 ALTER TABLE `approvals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `audit_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `user_role` varchar(30) DEFAULT NULL,
  `action` varchar(200) NOT NULL,
  `application_id` bigint DEFAULT NULL,
  `description` text,
  `ip_address` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`audit_id`),
  KEY `fk_audit_user` (`user_id`),
  KEY `fk_audit_application` (`application_id`),
  CONSTRAINT `fk_audit_application` FOREIGN KEY (`application_id`) REFERENCES `applications` (`application_id`),
  CONSTRAINT `fk_audit_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business_approvals`
--

DROP TABLE IF EXISTS `business_approvals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `business_approvals` (
  `business_approval_id` bigint NOT NULL AUTO_INCREMENT,
  `business_id` bigint NOT NULL,
  `approval_id` bigint NOT NULL,
  `requirement_status` varchar(20) NOT NULL DEFAULT 'REQUIRED',
  `priority_level` varchar(20) DEFAULT 'MEDIUM',
  `reason_text` text,
  `current_status` varchar(30) DEFAULT 'NOT_STARTED',
  `mandatory` tinyint(1) NOT NULL DEFAULT '1',
  `generated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`business_approval_id`),
  UNIQUE KEY `business_id` (`business_id`,`approval_id`),
  KEY `fk_businessapproval_approval` (`approval_id`),
  CONSTRAINT `fk_businessapproval_approval` FOREIGN KEY (`approval_id`) REFERENCES `approvals` (`approval_id`),
  CONSTRAINT `fk_businessapproval_business` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_approvals`
--

LOCK TABLES `business_approvals` WRITE;
/*!40000 ALTER TABLE `business_approvals` DISABLE KEYS */;
INSERT INTO `business_approvals` VALUES (1,1,1,'REQUIRED','HIGH','Your business is involved in food processing and manufacturing activities.','NOT_STARTED',1,'2026-08-28 07:17:22','2026-08-28 07:17:22'),(2,1,5,'REQUIRED','HIGH','Manufacturing activities may require applicable factory-related approvals.','NOT_STARTED',1,'2026-08-28 07:17:22','2026-08-28 07:17:22'),(3,1,2,'REQUIRED','HIGH','Industrial premises may require applicable fire safety clearance.','NOT_STARTED',1,'2026-08-28 07:17:22','2026-08-28 07:17:22'),(4,1,6,'REQUIRED','HIGH','You indicated that your business uses a boiler.','NOT_STARTED',1,'2026-08-28 07:17:22','2026-08-28 07:17:22'),(5,3,1,'REQUIRED','HIGH','Your business is involved in food processing and manufacturing activities.','NOT_STARTED',1,'2026-08-31 07:04:59','2026-08-31 07:04:59'),(6,3,5,'REQUIRED','HIGH','Manufacturing activities may require applicable factory-related approvals.','NOT_STARTED',1,'2026-08-31 07:05:00','2026-08-31 07:05:00'),(7,3,2,'REQUIRED','HIGH','Industrial premises may require applicable fire safety clearance.','NOT_STARTED',1,'2026-08-31 07:05:00','2026-08-31 07:05:00'),(8,3,6,'REQUIRED','HIGH','You indicated that your business uses a boiler.','NOT_STARTED',1,'2026-08-31 07:05:00','2026-08-31 07:05:00'),(9,4,3,'REQUIRED','HIGH','Chemical manufacturing may require environmental consent depending on operations and pollution category.','NOT_STARTED',1,'2026-09-01 07:00:42','2026-09-01 07:00:42'),(10,4,5,'REQUIRED','HIGH','Manufacturing operations may require applicable factory licensing.','NOT_STARTED',1,'2026-09-01 07:00:42','2026-09-01 07:00:42'),(11,4,6,'REQUIRED','HIGH','You indicated that your business uses a boiler.','NOT_STARTED',1,'2026-09-01 07:00:42','2026-09-01 07:00:42'),(12,5,1,'REQUIRED','HIGH','Your business is involved in food processing and manufacturing activities.','NOT_STARTED',1,'2026-09-01 07:08:22','2026-09-01 07:08:22'),(13,5,5,'REQUIRED','HIGH','Manufacturing activities may require applicable factory-related approvals.','NOT_STARTED',1,'2026-09-01 07:08:22','2026-09-01 07:08:22'),(14,5,2,'REQUIRED','HIGH','Industrial premises may require applicable fire safety clearance.','NOT_STARTED',1,'2026-09-01 07:08:22','2026-09-01 07:08:22'),(15,5,6,'REQUIRED','HIGH','You indicated that your business uses a boiler.','NOT_STARTED',1,'2026-09-01 07:08:22','2026-09-01 07:08:22');
/*!40000 ALTER TABLE `business_approvals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business_onboarding_progress`
--

DROP TABLE IF EXISTS `business_onboarding_progress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `business_onboarding_progress` (
  `progress_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `business_id` bigint DEFAULT NULL,
  `current_step` int DEFAULT '1',
  `completion_percentage` int DEFAULT '0',
  `profile_completed` tinyint(1) DEFAULT '0',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`progress_id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `fk_progress_business` (`business_id`),
  CONSTRAINT `fk_progress_business` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_progress_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_onboarding_progress`
--

LOCK TABLES `business_onboarding_progress` WRITE;
/*!40000 ALTER TABLE `business_onboarding_progress` DISABLE KEYS */;
INSERT INTO `business_onboarding_progress` VALUES (1,1,1,5,100,1,'2026-08-28 05:48:38'),(23,2,2,5,100,1,'2026-08-28 16:34:26'),(25,10,3,5,100,1,'2026-08-31 07:04:53'),(27,11,4,5,100,1,'2026-09-01 06:58:36'),(29,12,5,5,100,1,'2026-09-01 07:08:20');
/*!40000 ALTER TABLE `business_onboarding_progress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `businesses`
--

DROP TABLE IF EXISTS `businesses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `businesses` (
  `business_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `business_name` varchar(200) DEFAULT NULL,
  `business_constitution` varchar(50) DEFAULT NULL,
  `business_activity` varchar(50) DEFAULT NULL,
  `industry` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `district` varchar(100) DEFAULT NULL,
  `taluka` varchar(100) DEFAULT NULL,
  `industrial_area` varchar(150) DEFAULT NULL,
  `pin_code` varchar(10) DEFAULT NULL,
  `project_stage` varchar(50) DEFAULT NULL,
  `investment_amount` decimal(15,2) DEFAULT NULL,
  `employee_count` int DEFAULT NULL,
  `land_area` decimal(12,2) DEFAULT NULL,
  `built_up_area` decimal(12,2) DEFAULT NULL,
  `power_requirement` decimal(12,2) DEFAULT NULL,
  `water_requirement` decimal(12,2) DEFAULT NULL,
  `pollution_category` varchar(20) DEFAULT NULL,
  `hazardous_material` tinyint(1) DEFAULT '0',
  `boiler_used` tinyint(1) DEFAULT '0',
  `industrial_waste` tinyint(1) DEFAULT '0',
  `groundwater_required` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`business_id`),
  KEY `idx_business_user` (`user_id`),
  KEY `idx_business_industry` (`industry`),
  CONSTRAINT `fk_business_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `businesses`
--

LOCK TABLES `businesses` WRITE;
/*!40000 ALTER TABLE `businesses` DISABLE KEYS */;
INSERT INTO `businesses` VALUES (1,1,'ABC Foods Pvt Ltd','LLP','Service','Automobile','Uttar Pradesh','gorakhpur','gorakhpur','gida','273165','Ready to Operate',10.00,10,500.00,2400.00,1000.00,100.00,'Orange',0,0,0,1,'2026-08-27 17:15:22','2026-08-28 16:28:16'),(2,2,'visnile pvt limted','Startup','Service','Other','Uttar Pradesh','gorakhpur','gorakhpur','gida','272165','Planning',0.00,1,0.00,0.00,0.00,0.00,'Green',0,0,1,0,'2026-08-28 16:33:10','2026-08-30 03:48:58'),(3,10,'ABC Foods Pvt Ltd','Private Limited','Manufacturing','Construction','Uttar Pradesh','gorakhpur','gorakhpur','gida','417472','Planning',20.00,200,24.00,205.00,514.00,6476.00,'Orange',1,0,1,1,'2026-08-31 07:03:25','2026-08-31 07:13:35'),(4,11,'xyz','Startup','Manufacturing','Chemical','Maharashtra','palghar','palghar','virar','321456','Operational',18.00,10,2008.00,2026.00,18.00,8.01,'I DON\'T KNOW',1,1,1,1,'2026-09-01 06:53:37','2026-09-01 07:00:40'),(5,12,'abc','Startup','Manufacturing','Food Processing','Uttar Pradesh','gorakhpur','gorakhpur','gida','234156','Ready to Operate',18.00,25,35.00,347.00,12.00,289.97,'Orange',1,1,1,1,'2026-09-01 07:07:05','2026-09-01 07:08:20');
/*!40000 ALTER TABLE `businesses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `compliance_records`
--

DROP TABLE IF EXISTS `compliance_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compliance_records` (
  `compliance_id` bigint NOT NULL AUTO_INCREMENT,
  `business_id` bigint NOT NULL,
  `approval_id` bigint NOT NULL,
  `certificate_id` bigint DEFAULT NULL,
  `compliance_name` varchar(200) NOT NULL,
  `due_date` date DEFAULT NULL,
  `status` varchar(30) DEFAULT 'UPCOMING',
  `remarks` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`compliance_id`),
  KEY `fk_compliance_business` (`business_id`),
  KEY `fk_compliance_approval` (`approval_id`),
  KEY `fk_compliance_certificate` (`certificate_id`),
  CONSTRAINT `fk_compliance_approval` FOREIGN KEY (`approval_id`) REFERENCES `approvals` (`approval_id`),
  CONSTRAINT `fk_compliance_business` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`),
  CONSTRAINT `fk_compliance_certificate` FOREIGN KEY (`certificate_id`) REFERENCES `approval_certificates` (`certificate_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compliance_records`
--

LOCK TABLES `compliance_records` WRITE;
/*!40000 ALTER TABLE `compliance_records` DISABLE KEYS */;
/*!40000 ALTER TABLE `compliance_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `department_id` bigint NOT NULL AUTO_INCREMENT,
  `department_name` varchar(200) NOT NULL,
  `department_code` varchar(30) NOT NULL,
  `description` text,
  `contact_email` varchar(150) DEFAULT NULL,
  `contact_phone` varchar(20) DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`department_id`),
  UNIQUE KEY `department_code` (`department_code`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,'Food Safety Department','FOOD','Handles food safety related approvals and registrations',NULL,NULL,1,'2026-08-27 06:57:42'),(2,'Fire Safety Department','FIRE','Handles fire safety approvals and inspections',NULL,NULL,1,'2026-08-27 06:57:42'),(3,'Pollution Control Department','POLLUTION','Handles environmental and pollution related approvals',NULL,NULL,1,'2026-08-27 06:57:42'),(4,'Labour Department','LABOUR','Handles labour and employment related registrations',NULL,NULL,1,'2026-08-27 06:57:42'),(5,'Industries Department','INDUSTRIES','Handles industrial licensing and related approvals',NULL,NULL,1,'2026-08-27 06:57:42'),(6,'Boiler Department','BOILER','Handles boiler registration and inspection related approvals',NULL,NULL,1,'2026-08-27 06:57:42');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `documents`
--

DROP TABLE IF EXISTS `documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documents` (
  `document_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `business_id` bigint NOT NULL,
  `document_type` varchar(100) NOT NULL,
  `original_file_name` varchar(255) DEFAULT NULL,
  `stored_file_name` varchar(255) DEFAULT NULL,
  `file_path` varchar(500) NOT NULL,
  `file_size` bigint DEFAULT NULL,
  `file_extension` varchar(20) DEFAULT NULL,
  `verification_status` varchar(30) DEFAULT 'UPLOADED',
  `verification_remarks` text,
  `verified_by` bigint DEFAULT NULL,
  `upload_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `expiry_date` date DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`document_id`),
  KEY `fk_document_user` (`user_id`),
  KEY `fk_document_verifier` (`verified_by`),
  KEY `idx_document_business` (`business_id`),
  KEY `idx_document_type` (`document_type`),
  CONSTRAINT `fk_document_business` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_document_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_document_verifier` FOREIGN KEY (`verified_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documents`
--

LOCK TABLES `documents` WRITE;
/*!40000 ALTER TABLE `documents` DISABLE KEYS */;
INSERT INTO `documents` VALUES (1,1,1,'PAN','MLT-U-1-ONE-SHOT-Notes.pdf','3f0409e8-c812-4ca2-872a-72488813c5f4.pdf','C:\\Users\\acer\\CHAPERON_UPLOADS\\business_1\\3f0409e8-c812-4ca2-872a-72488813c5f4.pdf',1548862,'pdf','UPLOADED',NULL,NULL,'2026-08-28 14:51:33',NULL,1),(2,1,1,'BUSINESS_REGISTRATION','MLT-U-2-ONE-SHOT-Notes.pdf','9f0bb016-b147-4a69-87bf-a3b09ed78427.pdf','C:\\Users\\acer\\CHAPERON_UPLOADS\\business_1\\9f0bb016-b147-4a69-87bf-a3b09ed78427.pdf',1340100,'pdf','UPLOADED',NULL,NULL,'2026-08-28 14:54:43',NULL,1),(3,1,1,'FACTORY_LAYOUT','MLT-U-4-ONE-SHOT-Notes.pdf','ef03cd01-d768-4778-88b1-1c6b70f52b87.pdf','C:\\Users\\acer\\CHAPERON_UPLOADS\\business_1\\ef03cd01-d768-4778-88b1-1c6b70f52b87.pdf',5913628,'pdf','UPLOADED',NULL,NULL,'2026-08-28 15:18:11',NULL,1),(4,1,1,'LAND_DOCUMENT','MLT-U-5-ONE-SHOT-Notes.pdf','6df4a257-5348-4077-b218-7bbd229bd1a6.pdf','C:\\Users\\acer\\CHAPERON_UPLOADS\\business_1\\6df4a257-5348-4077-b218-7bbd229bd1a6.pdf',2228664,'pdf','UPLOADED',NULL,NULL,'2026-08-28 15:51:47',NULL,1),(5,1,1,'BUILDING_PLAN','Hackathon_Team_Responsibilities_6_Members.pdf','edc3f0b3-b289-4a1c-a9cc-7a9bf1cb395a.pdf','C:\\Users\\acer\\CHAPERON_UPLOADS\\business_1\\edc3f0b3-b289-4a1c-a9cc-7a9bf1cb395a.pdf',3991667,'pdf','UPLOADED',NULL,NULL,'2026-08-30 05:55:11',NULL,1),(6,1,1,'FIRE_LAYOUT','SIH26130_Team_Responsibilities.pdf','d8ad90a4-c0fb-4327-bb20-cb57d99fe408.pdf','C:\\Users\\acer\\CHAPERON_UPLOADS\\business_1\\d8ad90a4-c0fb-4327-bb20-cb57d99fe408.pdf',298135,'pdf','UPLOADED',NULL,NULL,'2026-08-30 05:55:33',NULL,1),(7,10,3,'PAN','Hackathon Team Formation Form (Responses) - Form responses 1.pdf','3e6fdd2a-aa34-46a4-9e0b-f1a4d1fad13b.pdf','C:\\Users\\acer\\CHAPERON_UPLOADS\\business_3\\3e6fdd2a-aa34-46a4-9e0b-f1a4d1fad13b.pdf',14257,'pdf','UPLOADED',NULL,NULL,'2026-08-31 09:05:18',NULL,1),(8,10,3,'BUSINESS_REGISTRATION','Hackathon_Team_Responsibilities_6_Members.pdf','2f2c1ee6-a8a7-49fa-b226-1842c6762afc.pdf','C:\\Users\\acer\\CHAPERON_UPLOADS\\business_3\\2f2c1ee6-a8a7-49fa-b226-1842c6762afc.pdf',3991667,'pdf','UPLOADED',NULL,NULL,'2026-08-31 09:05:37',NULL,1),(9,10,3,'FACTORY_LAYOUT','SIH26130_Team_Responsibilities.pdf','29c2a8d2-f2e8-4b26-aa05-557597923e41.pdf','C:\\Users\\acer\\CHAPERON_UPLOADS\\business_3\\29c2a8d2-f2e8-4b26-aa05-557597923e41.pdf',298135,'pdf','UPLOADED',NULL,NULL,'2026-08-31 09:05:48',NULL,1),(10,11,4,'PAN','WhatsApp Image 2026-09-01 at 10.23.19 AM.jpeg','228d44d5-19d1-4fd4-a8a2-d8f299c47b85.jpeg','C:\\Users\\acer\\CHAPERON_UPLOADS\\business_4\\228d44d5-19d1-4fd4-a8a2-d8f299c47b85.jpeg',68515,'jpeg','UPLOADED',NULL,NULL,'2026-09-01 07:03:43',NULL,1);
/*!40000 ALTER TABLE `documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `government_schemes`
--

DROP TABLE IF EXISTS `government_schemes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `government_schemes` (
  `scheme_id` bigint NOT NULL AUTO_INCREMENT,
  `scheme_name` varchar(250) NOT NULL,
  `department_id` bigint DEFAULT NULL,
  `description` text,
  `eligibility` text,
  `benefit` text,
  `deadline` date DEFAULT NULL,
  `official_information_url` varchar(500) DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`scheme_id`),
  KEY `fk_scheme_department` (`department_id`),
  CONSTRAINT `fk_scheme_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `government_schemes`
--

LOCK TABLES `government_schemes` WRITE;
/*!40000 ALTER TABLE `government_schemes` DISABLE KEYS */;
INSERT INTO `government_schemes` VALUES (1,'PM Monday Survival Yojana (PMSY)',NULL,'☕ 2 free chai\r\n😴 30-minute official nap allowance\r\n📚 First lecture/meeting mein “camera off, brain loading” permission\r\n💰 8 AM se pehle bulane wale teacher/boss par ₹500 “emotional damage tax”\r\n🎁 100% attendance walon ko month-end par 1 guilt-free holiday','no',NULL,'2026-09-01',NULL,1,'2026-08-31 16:29:51','2026-08-31 16:29:51');
/*!40000 ALTER TABLE `government_schemes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grievances`
--

DROP TABLE IF EXISTS `grievances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grievances` (
  `grievance_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `application_id` bigint DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `subject` varchar(250) NOT NULL,
  `description` text NOT NULL,
  `priority` varchar(20) DEFAULT 'MEDIUM',
  `status` varchar(30) DEFAULT 'SUBMITTED',
  `created_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `resolved_at` timestamp NULL DEFAULT NULL,
  `resolution_remarks` text,
  PRIMARY KEY (`grievance_id`),
  KEY `fk_grievance_user` (`user_id`),
  KEY `fk_grievance_application` (`application_id`),
  CONSTRAINT `fk_grievance_application` FOREIGN KEY (`application_id`) REFERENCES `applications` (`application_id`),
  CONSTRAINT `fk_grievance_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grievances`
--

LOCK TABLES `grievances` WRITE;
/*!40000 ALTER TABLE `grievances` DISABLE KEYS */;
/*!40000 ALTER TABLE `grievances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inspections`
--

DROP TABLE IF EXISTS `inspections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inspections` (
  `inspection_id` bigint NOT NULL AUTO_INCREMENT,
  `application_id` bigint NOT NULL,
  `inspection_type` varchar(100) DEFAULT NULL,
  `department_id` bigint NOT NULL,
  `officer_profile_id` bigint DEFAULT NULL,
  `inspection_date` date NOT NULL,
  `inspection_time` time DEFAULT NULL,
  `location` varchar(500) DEFAULT NULL,
  `remarks` text,
  `status` varchar(30) DEFAULT 'SCHEDULED',
  `result` varchar(30) DEFAULT NULL,
  `inspection_notes` text,
  `recommendation` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`inspection_id`),
  KEY `fk_inspection_department` (`department_id`),
  KEY `idx_inspection_application` (`application_id`),
  KEY `fk_inspection_officer_profile` (`officer_profile_id`),
  CONSTRAINT `fk_inspection_application` FOREIGN KEY (`application_id`) REFERENCES `applications` (`application_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_inspection_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`),
  CONSTRAINT `fk_inspection_officer_profile` FOREIGN KEY (`officer_profile_id`) REFERENCES `officer_profiles` (`officer_profile_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inspections`
--

LOCK TABLES `inspections` WRITE;
/*!40000 ALTER TABLE `inspections` DISABLE KEYS */;
INSERT INTO `inspections` VALUES (1,3,'Site Inspection',2,2,'2026-08-31','11:00:00','Applicant Business Premises','Verify premises and compliance requirements.','COMPLETED','PASSED','non','onno','2026-08-30 05:59:29','2026-08-30 06:30:45');
/*!40000 ALTER TABLE `inspections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `notification_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `application_id` bigint DEFAULT NULL,
  `notification_type` varchar(50) NOT NULL,
  `title` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `action_url` varchar(500) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_id`),
  KEY `fk_notification_application` (`application_id`),
  KEY `idx_notification_user` (`user_id`),
  KEY `idx_notification_read` (`is_read`),
  CONSTRAINT `fk_notification_application` FOREIGN KEY (`application_id`) REFERENCES `applications` (`application_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_notification_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,10,6,'APPLICATION_REJECTED','Application Rejected','Your application CHP-FSSAI-2026-251860 has been rejected. Please review the rejection reason and next steps.','/entrepreneur/application-details?id=6',0,'2026-08-31 16:10:49'),(2,10,7,'APPLICATION_APPROVED','Application Approved','Congratulations. Your application CHP-FSSAI-2026-041604 has been approved. You can now view your approval certificate.','/entrepreneur/application-details?id=7',0,'2026-08-31 16:39:26');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `officer_profiles`
--

DROP TABLE IF EXISTS `officer_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `officer_profiles` (
  `officer_profile_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `department_id` bigint NOT NULL,
  `designation` varchar(100) DEFAULT NULL,
  `employee_code` varchar(50) DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`officer_profile_id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `employee_code` (`employee_code`),
  KEY `fk_officer_profiles_department` (`department_id`),
  CONSTRAINT `fk_officer_profiles_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`),
  CONSTRAINT `fk_officer_profiles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `officer_profiles`
--

LOCK TABLES `officer_profiles` WRITE;
/*!40000 ALTER TABLE `officer_profiles` DISABLE KEYS */;
INSERT INTO `officer_profiles` VALUES (1,3,1,'Approval Officer','FOOD-OFF-001',1,'2026-08-29 12:24:14','2026-08-29 12:24:14'),(2,4,2,'Approval Officer','FIRE-OFF-001',1,'2026-08-29 12:28:46','2026-08-29 12:28:46'),(3,5,3,'Approval Officer','POLLUTION-OFF-001',1,'2026-08-29 12:28:46','2026-08-29 12:28:46'),(4,6,4,'Approval Officer','LABOUR-OFF-001',1,'2026-08-29 12:28:46','2026-08-29 12:28:46'),(5,7,5,'Approval Officer','INDUSTRIES-OFF-001',1,'2026-08-29 12:28:46','2026-08-29 12:28:46'),(6,8,6,'Approval Officer','BOILER-OFF-001',1,'2026-08-29 12:28:48','2026-08-29 12:28:48');
/*!40000 ALTER TABLE `officer_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `officers`
--

DROP TABLE IF EXISTS `officers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `officers` (
  `officer_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `department_id` bigint NOT NULL,
  `designation` varchar(100) DEFAULT NULL,
  `employee_code` varchar(50) DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`officer_id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `employee_code` (`employee_code`),
  KEY `fk_officer_department` (`department_id`),
  CONSTRAINT `fk_officer_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`),
  CONSTRAINT `fk_officer_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `officers`
--

LOCK TABLES `officers` WRITE;
/*!40000 ALTER TABLE `officers` DISABLE KEYS */;
/*!40000 ALTER TABLE `officers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `query_responses`
--

DROP TABLE IF EXISTS `query_responses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `query_responses` (
  `response_id` bigint NOT NULL AUTO_INCREMENT,
  `query_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `response_text` text NOT NULL,
  `supporting_document_id` bigint DEFAULT NULL,
  `responded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`response_id`),
  KEY `fk_response_query` (`query_id`),
  KEY `fk_response_user` (`user_id`),
  KEY `fk_response_document` (`supporting_document_id`),
  CONSTRAINT `fk_response_document` FOREIGN KEY (`supporting_document_id`) REFERENCES `documents` (`document_id`),
  CONSTRAINT `fk_response_query` FOREIGN KEY (`query_id`) REFERENCES `application_queries` (`query_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_response_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `query_responses`
--

LOCK TABLES `query_responses` WRITE;
/*!40000 ALTER TABLE `query_responses` DISABLE KEYS */;
/*!40000 ALTER TABLE `query_responses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `renewal_reminders`
--

DROP TABLE IF EXISTS `renewal_reminders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `renewal_reminders` (
  `reminder_id` bigint NOT NULL AUTO_INCREMENT,
  `certificate_id` bigint NOT NULL,
  `reminder_days_before` int NOT NULL,
  `reminder_date` date NOT NULL,
  `status` varchar(20) DEFAULT 'PENDING',
  `notified` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`reminder_id`),
  KEY `fk_renewal_certificate` (`certificate_id`),
  CONSTRAINT `fk_renewal_certificate` FOREIGN KEY (`certificate_id`) REFERENCES `approval_certificates` (`certificate_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `renewal_reminders`
--

LOCK TABLES `renewal_reminders` WRITE;
/*!40000 ALTER TABLE `renewal_reminders` DISABLE KEYS */;
/*!40000 ALTER TABLE `renewal_reminders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scheme_rules`
--

DROP TABLE IF EXISTS `scheme_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scheme_rules` (
  `scheme_rule_id` bigint NOT NULL AUTO_INCREMENT,
  `scheme_id` bigint NOT NULL,
  `industry` varchar(100) DEFAULT NULL,
  `business_type` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `project_stage` varchar(50) DEFAULT NULL,
  `minimum_investment` decimal(15,2) DEFAULT NULL,
  `maximum_investment` decimal(15,2) DEFAULT NULL,
  `match_percentage` int DEFAULT '80',
  `recommendation_reason` text,
  `active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`scheme_rule_id`),
  KEY `fk_scheme_rule_scheme` (`scheme_id`),
  CONSTRAINT `fk_scheme_rule_scheme` FOREIGN KEY (`scheme_id`) REFERENCES `government_schemes` (`scheme_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scheme_rules`
--

LOCK TABLES `scheme_rules` WRITE;
/*!40000 ALTER TABLE `scheme_rules` DISABLE KEYS */;
/*!40000 ALTER TABLE `scheme_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` bigint NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `mobile` varchar(15) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` varchar(30) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_login` timestamp NULL DEFAULT NULL,
  `profile_completed` tinyint(1) DEFAULT '0',
  `account_status` varchar(20) DEFAULT 'ACTIVE',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_users_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Vaibhav Verma','vaibhavv88744@gmail.com','8874478230','$2a$12$Gdjck1DtxEfHE9ygW6SHDee9Sg4RupRCExEiJtjCDf3nB2AJiPJ1m','ENTREPRENEUR','2026-08-27 09:10:23','2026-08-31 10:37:14',1,'ACTIVE'),(2,'Vaibhav verma','vaibhavv8874@gmail.com','8874478231','$2a$12$XfdO9mnaWUVvG3OYZ5PoBucT55oCJkedztD5hW/SjPU/oi8.c3AL6','ENTREPRENEUR','2026-08-28 16:32:10','2026-08-31 07:23:09',1,'INACTIVE'),(3,'Food Safety Officer','food.officer@chaperon.gov','9999999999','$2a$12$Gdjck1DtxEfHE9ygW6SHDee9Sg4RupRCExEiJtjCDf3nB2AJiPJ1m','OFFICER','2026-08-29 12:23:19','2026-09-01 15:32:28',1,'ACTIVE'),(4,'Fire Safety Officer','fire.officer@chaperon.gov','9999999998','$2a$12$Gdjck1DtxEfHE9ygW6SHDee9Sg4RupRCExEiJtjCDf3nB2AJiPJ1m','OFFICER','2026-08-29 12:28:00','2026-09-01 09:49:41',1,'ACTIVE'),(5,'Pollution Control Officer','pollution.officer@chaperon.gov','9999999997','$2a$12$Gdjck1DtxEfHE9ygW6SHDee9Sg4RupRCExEiJtjCDf3nB2AJiPJ1m','OFFICER','2026-08-29 12:28:00',NULL,1,'ACTIVE'),(6,'Labour Officer','labour.officer@chaperon.gov','9999999996','$2a$12$Gdjck1DtxEfHE9ygW6SHDee9Sg4RupRCExEiJtjCDf3nB2AJiPJ1m','OFFICER','2026-08-29 12:28:00',NULL,1,'ACTIVE'),(7,'Industries Officer','industries.officer@chaperon.gov','9999999995','$2a$12$Gdjck1DtxEfHE9ygW6SHDee9Sg4RupRCExEiJtjCDf3nB2AJiPJ1m','OFFICER','2026-08-29 12:28:00','2026-08-31 07:07:25',1,'ACTIVE'),(8,'Boiler Officer','boiler.officer@chaperon.gov','9999999994','$2a$12$Gdjck1DtxEfHE9ygW6SHDee9Sg4RupRCExEiJtjCDf3nB2AJiPJ1m','OFFICER','2026-08-29 12:28:07',NULL,1,'ACTIVE'),(9,'CHAPERON Administrator','admin@chaperon.gov','9999999999','$2a$12$cFRDlZnhvOiH6zJsroGJcunGbZ9f0BNwUj4foIthFUFlcU2gRvvUi','ADMIN','2026-08-30 08:59:29','2026-09-01 15:53:46',1,'ACTIVE'),(10,'Shlok Gupta','shlok09042007@gmail.com','9415690977','$2a$12$QH9hGERmouFRQDUvwhiFwu1qL.RJGsRp89eBHbAX1e7/9TVoG9TbG','ENTREPRENEUR','2026-08-31 07:02:14','2026-09-01 15:42:45',1,'ACTIVE'),(11,'Anushka','srivastavamaira110@gmail.com','9889563834','$2a$12$Z35CJ1ySHemxOb6iWJHYqOR.R4Sapt1HjxBTilZ0/yhtzxApYTF1S','ENTREPRENEUR','2026-09-01 06:52:51','2026-09-01 07:15:58',1,'ACTIVE'),(12,'atulya','atulya335@gmail.com','9208750146','$2a$12$QbbGThEGNn6Lts2X8FVze.aMO6khC3tHQpwDAyrZr/F7W8gn/54aa','ENTREPRENEUR','2026-09-01 07:06:44','2026-09-01 15:21:43',1,'ACTIVE');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'chaperon_db'
--

--
-- Dumping routines for database 'chaperon_db'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-01 22:15:04
