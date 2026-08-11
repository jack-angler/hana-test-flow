CREATE TABLE IF NOT EXISTS defects (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    test_case_result_id BIGINT UNSIGNED NOT NULL,
    test_case_result_history_id BIGINT UNSIGNED NULL,
    test_case_id BIGINT UNSIGNED NOT NULL,
    reporter_user_id BIGINT UNSIGNED NOT NULL,
    reporter_organization_id BIGINT UNSIGNED NOT NULL,
    result_status ENUM('failed', 'improvement', 'not_available') NOT NULL,
    status ENUM('received', 'assigned', 'action_completed', 'tester_confirmation_pending', 'verification_completed') NOT NULL DEFAULT 'received',
    title VARCHAR(255) NOT NULL,
    description TEXT NULL,
    assignee_user_id BIGINT UNSIGNED NULL,
    assigned_by_user_id BIGINT UNSIGNED NULL,
    assigned_at DATETIME NULL,
    action_memo TEXT NULL,
    action_completed_by_user_id BIGINT UNSIGNED NULL,
    action_completed_at DATETIME NULL,
    verified_by_user_id BIGINT UNSIGNED NULL,
    verified_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_defects_result (test_case_result_id),
    KEY idx_defects_case_id (test_case_id),
    KEY idx_defects_reporter_user_id (reporter_user_id),
    KEY idx_defects_reporter_org_status (reporter_organization_id, status),
    KEY idx_defects_assignee_status (assignee_user_id, status),
    KEY idx_defects_result_status (result_status),
    CONSTRAINT fk_defects_result
        FOREIGN KEY (test_case_result_id)
        REFERENCES test_case_results (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_defects_history
        FOREIGN KEY (test_case_result_history_id)
        REFERENCES test_case_result_histories (id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    CONSTRAINT fk_defects_case
        FOREIGN KEY (test_case_id)
        REFERENCES test_cases (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_defects_reporter_user
        FOREIGN KEY (reporter_user_id)
        REFERENCES users (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_defects_reporter_organization
        FOREIGN KEY (reporter_organization_id)
        REFERENCES organizations (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_defects_assignee_user
        FOREIGN KEY (assignee_user_id)
        REFERENCES users (id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    CONSTRAINT fk_defects_assigned_by_user
        FOREIGN KEY (assigned_by_user_id)
        REFERENCES users (id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    CONSTRAINT fk_defects_action_completed_by_user
        FOREIGN KEY (action_completed_by_user_id)
        REFERENCES users (id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    CONSTRAINT fk_defects_verified_by_user
        FOREIGN KEY (verified_by_user_id)
        REFERENCES users (id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS defect_actions (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    defect_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    action_type ENUM('received', 'assigned', 'action_completed', 'verification_completed', 'comment') NOT NULL,
    from_status ENUM('received', 'assigned', 'action_completed', 'tester_confirmation_pending', 'verification_completed') NULL,
    to_status ENUM('received', 'assigned', 'action_completed', 'tester_confirmation_pending', 'verification_completed') NULL,
    comment TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_defect_actions_defect_id (defect_id),
    KEY idx_defect_actions_user_id (user_id),
    KEY idx_defect_actions_created_at (created_at),
    CONSTRAINT fk_defect_actions_defect
        FOREIGN KEY (defect_id)
        REFERENCES defects (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_defect_actions_user
        FOREIGN KEY (user_id)
        REFERENCES users (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS defect_action_images (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    defect_action_id BIGINT UNSIGNED NOT NULL,
    defect_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    source_type ENUM('file', 'clipboard') NOT NULL DEFAULT 'file',
    original_filename VARCHAR(255) NULL,
    stored_filename VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    file_size_bytes BIGINT UNSIGNED NOT NULL DEFAULT 0,
    image_width INT UNSIGNED NULL,
    image_height INT UNSIGNED NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_defect_action_images_action_id (defect_action_id),
    KEY idx_defect_action_images_defect_id (defect_id),
    KEY idx_defect_action_images_user_id (user_id),
    CONSTRAINT fk_defect_action_images_action
        FOREIGN KEY (defect_action_id)
        REFERENCES defect_actions (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_defect_action_images_defect
        FOREIGN KEY (defect_id)
        REFERENCES defects (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_defect_action_images_user
        FOREIGN KEY (user_id)
        REFERENCES users (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS defect_status_histories (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    defect_id BIGINT UNSIGNED NOT NULL,
    changed_by_user_id BIGINT UNSIGNED NOT NULL,
    from_status ENUM('received', 'assigned', 'action_completed', 'tester_confirmation_pending', 'verification_completed') NULL,
    to_status ENUM('received', 'assigned', 'action_completed', 'tester_confirmation_pending', 'verification_completed') NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_defect_status_histories_defect_id (defect_id),
    KEY idx_defect_status_histories_user_id (changed_by_user_id),
    KEY idx_defect_status_histories_created_at (created_at),
    CONSTRAINT fk_defect_status_histories_defect
        FOREIGN KEY (defect_id)
        REFERENCES defects (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_defect_status_histories_user
        FOREIGN KEY (changed_by_user_id)
        REFERENCES users (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
