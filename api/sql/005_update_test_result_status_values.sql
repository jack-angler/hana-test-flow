ALTER TABLE test_case_results
    MODIFY result_status ENUM('not_tested', 'passed', 'failed', 'improvement', 'not_available')
    NOT NULL DEFAULT 'not_tested';

ALTER TABLE test_case_result_histories
    MODIFY result_status ENUM('not_tested', 'passed', 'failed', 'improvement', 'not_available')
    NOT NULL;
