CREATE TABLE IF NOT EXISTS remember_tokens (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id BIGINT UNSIGNED NOT NULL,
    selector CHAR(32) NOT NULL,
    token_hash CHAR(64) NOT NULL,
    user_agent_hash CHAR(64) NOT NULL,
    expires_at DATETIME NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_used_at DATETIME NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_remember_tokens_selector (selector),
    KEY idx_remember_tokens_user_id (user_id),
    KEY idx_remember_tokens_expires_at (expires_at),
    CONSTRAINT fk_remember_tokens_user
        FOREIGN KEY (user_id)
        REFERENCES users (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
