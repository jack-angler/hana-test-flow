<?php

declare(strict_types=1);

require_once __DIR__ . '/bootstrap.php';

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'GET') {
    json_response([
        'success' => false,
        'message' => 'GET method is required.',
    ], 405);
}

require_user();

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
            COUNT(tc.id) AS case_count
         FROM test_scenarios ts
         LEFT JOIN test_cases tc
            ON tc.test_scenario_id = ts.id
           AND tc.is_current = 1
           AND tc.is_deleted = 0
         WHERE ts.test_run_id = ?
         GROUP BY ts.id, ts.scenario_code, ts.name, ts.sort_order
         ORDER BY ts.sort_order ASC, ts.id ASC'
    );
    $stmt->execute([$testRunId]);

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
