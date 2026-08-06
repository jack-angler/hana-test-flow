ALTER TABLE test_case_result_evidences
    ADD COLUMN IF NOT EXISTS estimate_number VARCHAR(100) NULL AFTER source_type,
    ADD COLUMN IF NOT EXISTS target_login_id VARCHAR(100) NULL AFTER estimate_number,
    MODIFY stored_filename VARCHAR(255) NULL,
    MODIFY file_path VARCHAR(500) NULL,
    MODIFY mime_type VARCHAR(100) NULL,
    MODIFY file_size_bytes BIGINT UNSIGNED NULL;
