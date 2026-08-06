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

try {
    $stmt = db()->prepare(
        'SELECT
            tr.id,
            tr.name,
            COUNT(DISTINCT tc.id) AS case_count,
            COUNT(DISTINCT CASE
                WHEN tcr.id IS NOT NULL
                 AND tcr.result_status <> "not_tested"
                THEN tc.id
                ELSE NULL
            END) AS completed_count
         FROM test_runs tr
         LEFT JOIN test_scenarios ts
            ON ts.test_run_id = tr.id
         LEFT JOIN test_cases tc
            ON tc.test_scenario_id = ts.id
           AND tc.is_current = 1
           AND tc.is_deleted = 0
         LEFT JOIN test_case_results tcr
            ON tcr.test_case_id = tc.id
           AND tcr.user_id = ?
         WHERE tr.is_active = 1
         GROUP BY tr.id, tr.name, tr.updated_at
         ORDER BY tr.updated_at DESC, tr.id DESC'
    );
    $stmt->execute([(int)$user['id']]);

    json_response([
        'success' => true,
        'test_runs' => $stmt->fetchAll(),
    ]);
} catch (Throwable $exception) {
    json_response([
        'success' => false,
        'message' => '통합테스트 진행명 목록을 불러오지 못했습니다.',
        'error' => $exception->getMessage(),
    ], 500);
}
