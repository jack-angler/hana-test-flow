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

$scenarioId = (int)($_GET['scenario_id'] ?? 0);

if ($scenarioId < 1) {
    json_response([
        'success' => false,
        'message' => '시나리오를 선택해주세요.',
    ], 422);
}

try {
    $stmt = db()->prepare(
        'SELECT
            tc.id,
            tc.scenario_menu,
            tc.scenario_code,
            tc.case_code,
            tc.version_no,
            tc.name,
            tc.location,
            tc.precondition,
            tc.test_steps,
            tc.expected_result,
            COALESCE(tcr.result_status, "not_tested") AS result_status,
            tcr.actual_result,
            tcr.defect_summary,
            tcr.tested_at
         FROM test_cases tc
         LEFT JOIN test_case_results tcr
            ON tcr.test_case_id = tc.id
           AND tcr.user_id = ?
         WHERE tc.test_scenario_id = ?
           AND tc.is_current = 1
           AND tc.is_deleted = 0
         ORDER BY tc.sort_order ASC, tc.id ASC'
    );
    $stmt->execute([(int)$user['id'], $scenarioId]);

    json_response([
        'success' => true,
        'test_cases' => $stmt->fetchAll(),
    ]);
} catch (Throwable $exception) {
    json_response([
        'success' => false,
        'message' => '케이스 목록을 불러오지 못했습니다.',
        'error' => $exception->getMessage(),
    ], 500);
}
