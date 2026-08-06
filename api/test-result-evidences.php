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
$testCaseId = (int)($_GET['test_case_id'] ?? 0);

if ($testCaseId < 1) {
    json_response([
        'success' => false,
        'message' => '테스트 케이스를 선택해주세요.',
    ], 422);
}

try {
    $pdo = db();

    $resultStmt = $pdo->prepare(
        'SELECT id, result_status, actual_result
         FROM test_case_results
         WHERE test_case_id = ?
           AND user_id = ?'
    );
    $resultStmt->execute([$testCaseId, (int)$user['id']]);
    $result = $resultStmt->fetch();

    if ($result === false) {
        json_response([
            'success' => true,
            'evidence' => null,
            'images' => [],
        ]);
    }

    $historyStmt = $pdo->prepare(
        'SELECT MAX(test_case_result_history_id)
         FROM test_case_result_evidences
         WHERE test_case_result_id = ?'
    );
    $historyStmt->execute([(int)$result['id']]);
    $historyId = $historyStmt->fetchColumn();

    if ($historyId === false || $historyId === null) {
        json_response([
            'success' => true,
            'evidence' => [
                'result_status' => $result['result_status'],
                'memo' => $result['actual_result'],
                'estimate_number' => '',
                'target_login_id' => '',
            ],
            'images' => [],
        ]);
    }

    $stmt = $pdo->prepare(
        'SELECT
            id,
            result_status,
            source_type,
            estimate_number,
            target_login_id,
            memo,
            original_filename,
            stored_filename,
            file_path,
            mime_type,
            file_size_bytes,
            image_width,
            image_height,
            created_at
         FROM test_case_result_evidences
         WHERE test_case_result_id = ?
           AND test_case_result_history_id = ?
         ORDER BY id ASC'
    );
    $stmt->execute([(int)$result['id'], (int)$historyId]);
    $rows = $stmt->fetchAll();
    $first = $rows[0] ?? [];

    json_response([
        'success' => true,
        'evidence' => [
            'result_status' => $first['result_status'] ?? $result['result_status'],
            'memo' => $first['memo'] ?? $result['actual_result'],
            'estimate_number' => $first['estimate_number'] ?? '',
            'target_login_id' => $first['target_login_id'] ?? '',
        ],
        'images' => array_values(array_filter(array_map(
            static function (array $row): ?array {
                if (($row['file_path'] ?? '') === '') {
                    return null;
                }

                return [
                    'id' => (int)$row['id'],
                    'source_type' => $row['source_type'],
                    'name' => $row['original_filename'] ?: $row['stored_filename'],
                    'file_path' => $row['file_path'],
                    'mime_type' => $row['mime_type'],
                    'size' => (int)$row['file_size_bytes'],
                    'width' => $row['image_width'] === null ? null : (int)$row['image_width'],
                    'height' => $row['image_height'] === null ? null : (int)$row['image_height'],
                ];
            },
            $rows
        ))),
    ]);
} catch (Throwable $exception) {
    json_response([
        'success' => false,
        'message' => '증빙 내용을 불러오지 못했습니다.',
        'error' => $exception->getMessage(),
    ], 500);
}
