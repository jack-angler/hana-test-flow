<?php

declare(strict_types=1);

require_once __DIR__ . '/bootstrap.php';

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'GET') {
    json_response([
        'success' => false,
        'message' => 'GET method is required.',
    ], 405);
}

$user = require_user();

$testRunId = (int)($_GET['test_run_id'] ?? 0);

if ($testRunId < 1) {
    json_response([
        'success' => false,
        'message' => '통합테스트 진행명을 선택해주세요.',
    ], 422);
}

try {
    $stmt = db()->prepare(
        'SELECT
            ts.id,
            ts.scenario_code,
            ts.name,
            COUNT(DISTINCT tc.id) AS case_count,
            COUNT(DISTINCT CASE
                WHEN tcr.id IS NOT NULL
                 AND tcr.result_status <> "not_tested"
                THEN tc.id
                ELSE NULL
            END) AS completed_count
         FROM test_scenarios ts
         LEFT JOIN test_cases tc
            ON tc.test_scenario_id = ts.id
           AND tc.is_current = 1
           AND tc.is_deleted = 0
         LEFT JOIN test_case_results tcr
            ON tcr.test_case_id = tc.id
           AND tcr.user_id = ?
         WHERE ts.test_run_id = ?
         GROUP BY ts.id, ts.scenario_code, ts.name, ts.sort_order
         ORDER BY ts.sort_order ASC, ts.id ASC'
    );
    $stmt->execute([(int)$user['id'], $testRunId]);

    json_response([
        'success' => true,
        'scenarios' => $stmt->fetchAll(),
    ]);
} catch (Throwable $exception) {
    json_response([
        'success' => false,
        'message' => '시나리오 목록을 불러오지 못했습니다.',
        'error' => $exception->getMessage(),
    ], 500);
}
