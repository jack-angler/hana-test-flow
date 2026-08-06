CREATE TABLE IF NOT EXISTS test_case_result_evidences (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    test_case_result_id BIGINT UNSIGNED NOT NULL,
    test_case_result_history_id BIGINT UNSIGNED NULL,
    test_case_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    organization_id BIGINT UNSIGNED NOT NULL,
    result_status ENUM('failed', 'improvement', 'not_available') NOT NULL,
    source_type ENUM('clipboard', 'file') NOT NULL,
    estimate_number VARCHAR(100) NULL,
    target_login_id VARCHAR(100) NULL,
    memo TEXT NULL,
    original_filename VARCHAR(255) NULL,
    stored_filename VARCHAR(255) NULL,
    file_path VARCHAR(500) NULL,
    mime_type VARCHAR(100) NULL,
    file_size_bytes BIGINT UNSIGNED NULL,
    image_width INT UNSIGNED NULL,
    image_height INT UNSIGNED NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_test_case_result_evidences_result_id (test_case_result_id),
    KEY idx_test_case_result_evidences_history_id (test_case_result_history_id),
    KEY idx_test_case_result_evidences_case_id (test_case_id),
    KEY idx_test_case_result_evidences_user_id (user_id),
    KEY idx_test_case_result_evidences_org_status (organization_id, result_status),
    KEY idx_test_case_result_evidences_created_at (created_at),
    CONSTRAINT fk_test_case_result_evidences_result
        FOREIGN KEY (test_case_result_id)
        REFERENCES test_case_results (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_test_case_result_evidences_history
        FOREIGN KEY (test_case_result_history_id)
        REFERENCES test_case_result_histories (id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    CONSTRAINT fk_test_case_result_evidences_case
        FOREIGN KEY (test_case_id)
        REFERENCES test_cases (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_test_case_result_evidences_user
        FOREIGN KEY (user_id)
        REFERENCES users (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_test_case_result_evidences_organization
        FOREIGN KEY (organization_id)
        REFERENCES organizations (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
