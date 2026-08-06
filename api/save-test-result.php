<?php

declare(strict_types=1);

require_once __DIR__ . '/bootstrap.php';

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
    json_response([
        'success' => false,
        'message' => 'POST method is required.',
    ], 405);
}

$user = require_user();
$input = json_input();

$testCaseId = (int)($input['test_case_id'] ?? 0);
$resultStatus = trim((string)($input['result_status'] ?? ''));
$actualResult = trim((string)($input['actual_result'] ?? ''));
$defectSummary = trim((string)($input['defect_summary'] ?? ''));
$allowedStatuses = ['passed', 'failed', 'improvement', 'not_available'];

if ($testCaseId < 1 || !in_array($resultStatus, $allowedStatuses, true)) {
    json_response([
        'success' => false,
        'message' => '테스트 결과를 선택해주세요.',
    ], 422);
}

try {
    $pdo = db();
    $pdo->beginTransaction();

    $caseStmt = $pdo->prepare('SELECT id FROM test_cases WHERE id = ? AND is_current = 1 AND is_deleted = 0');
    $caseStmt->execute([$testCaseId]);

    if ($caseStmt->fetch() === false) {
        $pdo->rollBack();
        json_response([
            'success' => false,
            'message' => '선택한 테스트 케이스를 찾을 수 없습니다.',
        ], 422);
    }

    $resultStmt = $pdo->prepare(
        'INSERT INTO test_case_results (
            test_case_id, user_id, organization_id, result_status,
            actual_result, defect_summary, tested_at
         ) VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)
         ON DUPLICATE KEY UPDATE
            organization_id = VALUES(organization_id),
            result_status = VALUES(result_status),
            actual_result = VALUES(actual_result),
            defect_summary = VALUES(defect_summary),
            tested_at = CURRENT_TIMESTAMP,
            updated_at = CURRENT_TIMESTAMP'
    );
    $resultStmt->execute([
        $testCaseId,
        (int)$user['id'],
        (int)$user['organization_id'],
        $resultStatus,
        $actualResult === '' ? null : $actualResult,
        $defectSummary === '' ? null : $defectSummary,
    ]);

    $idStmt = $pdo->prepare('SELECT id FROM test_case_results WHERE test_case_id = ? AND user_id = ?');
    $idStmt->execute([$testCaseId, (int)$user['id']]);
    $resultId = (int)$idStmt->fetchColumn();

    $historyStmt = $pdo->prepare(
        'INSERT INTO test_case_result_histories (
            test_case_result_id, test_case_id, user_id, organization_id,
            result_status, actual_result, defect_summary
         ) VALUES (?, ?, ?, ?, ?, ?, ?)'
    );
    $historyStmt->execute([
        $resultId,
        $testCaseId,
        (int)$user['id'],
        (int)$user['organization_id'],
        $resultStatus,
        $actualResult === '' ? null : $actualResult,
        $defectSummary === '' ? null : $defectSummary,
    ]);

    $pdo->commit();

    json_response([
        'success' => true,
        'message' => '테스트 결과가 저장되었습니다.',
        'result' => [
            'test_case_id' => $testCaseId,
            'result_status' => $resultStatus,
        ],
    ]);
} catch (Throwable $exception) {
    if (isset($pdo) && $pdo instanceof PDO && $pdo->inTransaction()) {
        $pdo->rollBack();
    }

    json_response([
        'success' => false,
        'message' => '테스트 결과 저장 중 오류가 발생했습니다.',
        'error' => $exception->getMessage(),
    ], 500);
}
