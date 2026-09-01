CREATE DATABASE IF NOT EXISTS chaperon_db;

USE chaperon_db;

CREATE TABLE IF NOT EXISTS users (
    user_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    mobile VARCHAR(15),
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(30) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    profile_completed BOOLEAN DEFAULT FALSE,
    account_status VARCHAR(20) DEFAULT 'ACTIVE'
);

CREATE TABLE IF NOT EXISTS businesses (
    business_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    business_name VARCHAR(200),
    business_constitution VARCHAR(50),
    business_activity VARCHAR(50),
    industry VARCHAR(100),
    state VARCHAR(100),
    district VARCHAR(100),
    taluka VARCHAR(100),
    industrial_area VARCHAR(150),
    pin_code VARCHAR(10),
    project_stage VARCHAR(50),
    investment_amount DECIMAL(15,2),
    employee_count INT,
    land_area DECIMAL(12,2),
    built_up_area DECIMAL(12,2),
    power_requirement DECIMAL(12,2),
    water_requirement DECIMAL(12,2),
    pollution_category VARCHAR(20),
    hazardous_material BOOLEAN DEFAULT FALSE,
    boiler_used BOOLEAN DEFAULT FALSE,
    industrial_waste BOOLEAN DEFAULT FALSE,
    groundwater_required BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_business_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS business_onboarding_progress (
    progress_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    business_id BIGINT,
    current_step INT DEFAULT 1,
    completion_percentage INT DEFAULT 0,
    profile_completed BOOLEAN DEFAULT FALSE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE(user_id),

    CONSTRAINT fk_progress_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_progress_business
        FOREIGN KEY (business_id)
        REFERENCES businesses(business_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS departments (
    department_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(200) NOT NULL,
    department_code VARCHAR(30) NOT NULL UNIQUE,
    description TEXT,
    contact_email VARCHAR(150),
    contact_phone VARCHAR(20),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS officers (
    officer_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL UNIQUE,
    department_id BIGINT NOT NULL,
    designation VARCHAR(100),
    employee_code VARCHAR(50) UNIQUE,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_officer_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_officer_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

CREATE TABLE IF NOT EXISTS approvals (
    approval_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    approval_name VARCHAR(200) NOT NULL,
    approval_code VARCHAR(50) NOT NULL UNIQUE,
    department_id BIGINT NOT NULL,
    description TEXT,
    minimum_processing_days INT,
    maximum_processing_days INT,
    sla_days INT,
    validity_type VARCHAR(40),
    validity_value INT,
    renewal_required BOOLEAN DEFAULT FALSE,
    renewal_before_days INT,
    inspection_required BOOLEAN DEFAULT FALSE,
    official_reference_url VARCHAR(500),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_approval_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

CREATE TABLE IF NOT EXISTS approval_rules (
    rule_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    approval_id BIGINT NOT NULL,
    rule_name VARCHAR(200),
    industry VARCHAR(100),
    business_activity VARCHAR(50),
    project_stage VARCHAR(50),
    pollution_category VARCHAR(20),
    state VARCHAR(100),
    minimum_employee_count INT,
    maximum_employee_count INT,
    minimum_investment DECIMAL(15,2),
    maximum_investment DECIMAL(15,2),
    hazardous_material_required BOOLEAN,
    boiler_required BOOLEAN,
    groundwater_required BOOLEAN,
    industrial_waste_required BOOLEAN,
    priority VARCHAR(20) DEFAULT 'MEDIUM',
    recommendation_reason TEXT,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_rule_approval
        FOREIGN KEY (approval_id)
        REFERENCES approvals(approval_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS approval_document_requirements (
    requirement_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    approval_id BIGINT NOT NULL,
    document_type VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    mandatory BOOLEAN DEFAULT TRUE,
    active BOOLEAN DEFAULT TRUE,

    CONSTRAINT fk_document_requirement_approval
        FOREIGN KEY (approval_id)
        REFERENCES approvals(approval_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS business_approvals (
    business_approval_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    business_id BIGINT NOT NULL,
    approval_id BIGINT NOT NULL,
    priority VARCHAR(20) DEFAULT 'MEDIUM',
    recommendation_reason TEXT,
    current_status VARCHAR(30) DEFAULT 'NOT_STARTED',
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(business_id, approval_id),

    CONSTRAINT fk_businessapproval_business
        FOREIGN KEY (business_id)
        REFERENCES businesses(business_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_businessapproval_approval
        FOREIGN KEY (approval_id)
        REFERENCES approvals(approval_id)
);

CREATE TABLE IF NOT EXISTS documents (
    document_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    business_id BIGINT NOT NULL,
    document_type VARCHAR(100) NOT NULL,
    original_file_name VARCHAR(255),
    stored_file_name VARCHAR(255),
    file_path VARCHAR(500) NOT NULL,
    file_size BIGINT,
    file_extension VARCHAR(20),
    verification_status VARCHAR(30) DEFAULT 'UPLOADED',
    verification_remarks TEXT,
    verified_by BIGINT,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expiry_date DATE,
    active BOOLEAN DEFAULT TRUE,

    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (business_id) REFERENCES businesses(business_id)
        ON DELETE CASCADE,
    FOREIGN KEY (verified_by) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS applications (
    application_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    application_number VARCHAR(80) NOT NULL UNIQUE,
    user_id BIGINT NOT NULL,
    business_id BIGINT NOT NULL,
    approval_id BIGINT NOT NULL,
    department_id BIGINT NOT NULL,
    assigned_officer_id BIGINT,
    previous_application_id BIGINT,
    submission_date TIMESTAMP NULL,
    current_status VARCHAR(40) DEFAULT 'DRAFT',
    sla_days INT,
    expected_completion_date DATE,
    risk_level VARCHAR(20) DEFAULT 'LOW',
    officer_remarks TEXT,
    rejection_reason TEXT,
    can_reapply BOOLEAN DEFAULT TRUE,
    rejected_by BIGINT,
    rejected_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (business_id) REFERENCES businesses(business_id),
    FOREIGN KEY (approval_id) REFERENCES approvals(approval_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (assigned_officer_id) REFERENCES officers(officer_id),
    FOREIGN KEY (previous_application_id) REFERENCES applications(application_id),
    FOREIGN KEY (rejected_by) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS application_documents (
    application_document_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    application_id BIGINT NOT NULL,
    document_id BIGINT NOT NULL,
    attached_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(application_id, document_id),

    FOREIGN KEY (application_id)
        REFERENCES applications(application_id)
        ON DELETE CASCADE,

    FOREIGN KEY (document_id)
        REFERENCES documents(document_id)
);

CREATE TABLE IF NOT EXISTS application_status_history (
    history_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    application_id BIGINT NOT NULL,
    old_status VARCHAR(40),
    new_status VARCHAR(40) NOT NULL,
    changed_by BIGINT,
    changed_by_role VARCHAR(30),
    remarks TEXT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (application_id)
        REFERENCES applications(application_id)
        ON DELETE CASCADE,

    FOREIGN KEY (changed_by)
        REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS application_queries (
    query_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    application_id BIGINT NOT NULL,
    officer_id BIGINT NOT NULL,
    query_description TEXT NOT NULL,
    raised_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    response_deadline DATE,
    status VARCHAR(20) DEFAULT 'OPEN',
    resolved_at TIMESTAMP NULL,

    FOREIGN KEY (application_id)
        REFERENCES applications(application_id)
        ON DELETE CASCADE,

    FOREIGN KEY (officer_id)
        REFERENCES officers(officer_id)
);

CREATE TABLE IF NOT EXISTS query_responses (
    response_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    query_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    response_text TEXT NOT NULL,
    supporting_document_id BIGINT,
    responded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (query_id)
        REFERENCES application_queries(query_id)
        ON DELETE CASCADE,

    FOREIGN KEY (user_id)
        REFERENCES users(user_id),

    FOREIGN KEY (supporting_document_id)
        REFERENCES documents(document_id)
);

CREATE TABLE IF NOT EXISTS inspections (
    inspection_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    application_id BIGINT NOT NULL,
    inspection_type VARCHAR(100),
    department_id BIGINT NOT NULL,
    inspector_id BIGINT,
    inspection_date DATE NOT NULL,
    inspection_time TIME,
    location VARCHAR(500),
    remarks TEXT,
    status VARCHAR(30) DEFAULT 'SCHEDULED',
    result VARCHAR(30),
    inspection_notes TEXT,
    recommendation TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (application_id)
        REFERENCES applications(application_id)
        ON DELETE CASCADE,

    FOREIGN KEY (department_id)
        REFERENCES departments(department_id),

    FOREIGN KEY (inspector_id)
        REFERENCES officers(officer_id)
);

CREATE TABLE IF NOT EXISTS approval_certificates (
    certificate_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    application_id BIGINT NOT NULL UNIQUE,
    approval_number VARCHAR(100) NOT NULL UNIQUE,
    approved_by BIGINT NOT NULL,
    approval_date DATE NOT NULL,
    valid_from DATE,
    valid_until DATE,
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (application_id)
        REFERENCES applications(application_id),

    FOREIGN KEY (approved_by)
        REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS compliance_records (
    compliance_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    business_id BIGINT NOT NULL,
    approval_id BIGINT NOT NULL,
    certificate_id BIGINT,
    compliance_name VARCHAR(200) NOT NULL,
    due_date DATE,
    status VARCHAR(30) DEFAULT 'UPCOMING',
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (business_id)
        REFERENCES businesses(business_id),

    FOREIGN KEY (approval_id)
        REFERENCES approvals(approval_id),

    FOREIGN KEY (certificate_id)
        REFERENCES approval_certificates(certificate_id)
);

CREATE TABLE IF NOT EXISTS renewal_reminders (
    reminder_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    certificate_id BIGINT NOT NULL,
    reminder_days_before INT NOT NULL,
    reminder_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING',
    notified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (certificate_id)
        REFERENCES approval_certificates(certificate_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS government_schemes (
    scheme_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    scheme_name VARCHAR(250) NOT NULL,
    department_id BIGINT,
    description TEXT,
    eligibility TEXT,
    benefit TEXT,
    deadline DATE,
    official_information_url VARCHAR(500),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

CREATE TABLE IF NOT EXISTS scheme_rules (
    scheme_rule_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    scheme_id BIGINT NOT NULL,
    industry VARCHAR(100),
    business_type VARCHAR(100),
    state VARCHAR(100),
    project_stage VARCHAR(50),
    minimum_investment DECIMAL(15,2),
    maximum_investment DECIMAL(15,2),
    match_percentage INT DEFAULT 80,
    recommendation_reason TEXT,
    active BOOLEAN DEFAULT TRUE,

    FOREIGN KEY (scheme_id)
        REFERENCES government_schemes(scheme_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS notifications (
    notification_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    application_id BIGINT,
    notification_type VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    action_url VARCHAR(500),
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    FOREIGN KEY (application_id)
        REFERENCES applications(application_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS grievances (
    grievance_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    application_id BIGINT,
    category VARCHAR(100),
    subject VARCHAR(250) NOT NULL,
    description TEXT NOT NULL,
    priority VARCHAR(20) DEFAULT 'MEDIUM',
    status VARCHAR(30) DEFAULT 'SUBMITTED',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL,
    resolution_remarks TEXT,

    FOREIGN KEY (user_id)
        REFERENCES users(user_id),

    FOREIGN KEY (application_id)
        REFERENCES applications(application_id)
);

CREATE TABLE IF NOT EXISTS audit_logs (
    audit_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT,
    user_role VARCHAR(30),
    action VARCHAR(200) NOT NULL,
    application_id BIGINT,
    description TEXT,
    ip_address VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
        REFERENCES users(user_id),

    FOREIGN KEY (application_id)
        REFERENCES applications(application_id)
);