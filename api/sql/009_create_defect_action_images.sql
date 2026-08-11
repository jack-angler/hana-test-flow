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
