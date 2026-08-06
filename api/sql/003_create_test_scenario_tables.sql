CREATE TABLE IF NOT EXISTS test_runs (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    description TEXT NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_test_runs_name (name),
    KEY idx_test_runs_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS test_scenarios (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    test_run_id BIGINT UNSIGNED NOT NULL,
    scenario_code VARCHAR(80) NOT NULL,
    name VARCHAR(200) NOT NULL,
    sort_order INT UNSIGNED NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_test_scenarios_run_code (test_run_id, scenario_code),
    KEY idx_test_scenarios_test_run_id (test_run_id),
    CONSTRAINT fk_test_scenarios_run
        FOREIGN KEY (test_run_id)
        REFERENCES test_runs (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS test_cases (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    test_scenario_id BIGINT UNSIGNED NOT NULL,
    scenario_menu VARCHAR(200) NULL,
    scenario_code VARCHAR(80) NOT NULL,
    case_code VARCHAR(80) NOT NULL,
    version_no INT UNSIGNED NOT NULL DEFAULT 1,
    name VARCHAR(200) NOT NULL,
    location VARCHAR(255) NULL,
    precondition TEXT NULL,
    test_steps TEXT NULL,
    expected_result TEXT NULL,
    content_hash CHAR(64) NULL,
    is_current TINYINT(1) NOT NULL DEFAULT 1,
    is_deleted TINYINT(1) NOT NULL DEFAULT 0,
    deleted_at DATETIME NULL,
    sort_order INT UNSIGNED NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_test_cases_scenario_case_version (test_scenario_id, case_code, version_no),
    KEY idx_test_cases_scenario_id (test_scenario_id),
    KEY idx_test_cases_scenario_code (scenario_code),
    KEY idx_test_cases_case_code (case_code),
    KEY idx_test_cases_current (test_scenario_id, is_current, is_deleted),
    KEY idx_test_cases_deleted (is_deleted, deleted_at),
    CONSTRAINT fk_test_cases_scenario
        FOREIGN KEY (test_scenario_id)
        REFERENCES test_scenarios (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
