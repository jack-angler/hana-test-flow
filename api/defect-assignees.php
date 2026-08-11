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

if (($user['role'] ?? '') !== 'admin') {
    json_response([
        'success' => false,
        'message' => '담당자 목록은 관리자만 조회할 수 있습니다.',
    ], 403);
}

try {
    $stmt = db()->prepare(
        'SELECT id, name, login_id
         FROM users
         WHERE organization_id = ?
         ORDER BY name ASC, login_id ASC'
    );
    $stmt->execute([900]);

    json_response([
        'success' => true,
        'assignees' => $stmt->fetchAll(),
    ]);
} catch (Throwable $exception) {
    json_response([
        'success' => false,
        'message' => '담당자 목록을 불러오지 못했습니다.',
        'error' => $exception->getMessage(),
    ], 500);
}
