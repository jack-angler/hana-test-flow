ALTER TABLE defects
    MODIFY test_case_result_id BIGINT UNSIGNED NULL,
    MODIFY test_case_id BIGINT UNSIGNED NULL,
    ADD COLUMN defect_source ENUM('test_case', 'manual') NOT NULL DEFAULT 'test_case' AFTER result_status,
    ADD COLUMN manual_location VARCHAR(255) NULL AFTER defect_source,
    ADD KEY idx_defects_source (defect_source);
