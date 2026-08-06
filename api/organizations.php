<?php

declare(strict_types=1);

require_once __DIR__ . '/bootstrap.php';

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'GET') {
    json_response([
        'success' => false,
        'message' => 'GET method is required.',
    ], 405);
}

try {
    $stmt = db()->query('SELECT id, name FROM organizations ORDER BY name ASC');

    json_response([
        'success' => true,
        'organizations' => $stmt->fetchAll(),
    ]);
} catch (Throwable $exception) {
    json_response([
        'success' => false,
        'message' => '소속 목록을 불러오지 못했습니다.',
        'error' => $exception->getMessage(),
    ], 500);
}
