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

try {
    $stmt = db()->query(
        'SELECT id, name
         FROM test_runs
         WHERE is_active = 1
         ORDER BY updated_at DESC, id DESC'
    );

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
