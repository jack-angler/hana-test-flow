CREATE TABLE IF NOT EXISTS test_case_results (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    test_case_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    organization_id BIGINT UNSIGNED NOT NULL,
    result_status ENUM('not_tested', 'passed', 'failed', 'improvement', 'not_available') NOT NULL DEFAULT 'not_tested',
    actual_result TEXT NULL,
    defect_summary VARCHAR(500) NULL,
    tested_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_test_case_results_case_user (test_case_id, user_id),
    KEY idx_test_case_results_case_id (test_case_id),
    KEY idx_test_case_results_user_id (user_id),
    KEY idx_test_case_results_org_status (organization_id, result_status),
    KEY idx_test_case_results_status (result_status),
    KEY idx_test_case_results_tested_at (tested_at),
    CONSTRAINT fk_test_case_results_case
        FOREIGN KEY (test_case_id)
        REFERENCES test_cases (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_test_case_results_user
        FOREIGN KEY (user_id)
        REFERENCES users (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_test_case_results_organization
        FOREIGN KEY (organization_id)
        REFERENCES organizations (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS test_case_result_histories (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    test_case_result_id BIGINT UNSIGNED NOT NULL,
    test_case_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    organization_id BIGINT UNSIGNED NOT NULL,
    result_status ENUM('not_tested', 'passed', 'failed', 'improvement', 'not_available') NOT NULL,
    actual_result TEXT NULL,
    defect_summary VARCHAR(500) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_test_case_result_histories_result_id (test_case_result_id),
    KEY idx_test_case_result_histories_case_id (test_case_id),
    KEY idx_test_case_result_histories_user_id (user_id),
    KEY idx_test_case_result_histories_org_id (organization_id),
    CONSTRAINT fk_test_case_result_histories_result
        FOREIGN KEY (test_case_result_id)
        REFERENCES test_case_results (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_test_case_result_histories_case
        FOREIGN KEY (test_case_id)
        REFERENCES test_cases (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_test_case_result_histories_user
        FOREIGN KEY (user_id)
        REFERENCES users (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_test_case_result_histories_organization
        FOREIGN KEY (organization_id)
        REFERENCES organizations (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
