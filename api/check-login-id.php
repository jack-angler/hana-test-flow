<?php

declare(strict_types=1);

require_once __DIR__ . '/bootstrap.php';

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'GET') {
    json_response([
        'success' => false,
        'message' => 'GET method is required.',
    ], 405);
}

$loginId = trim((string)($_GET['login_id'] ?? ''));

if ($loginId === '') {
    json_response([
        'success' => false,
        'message' => '아이디를 입력해주세요.',
    ], 422);
}

if (mb_strlen($loginId) > 60) {
    json_response([
        'success' => false,
        'message' => '아이디는 60자 이하로 입력해주세요.',
    ], 422);
}

try {
    $stmt = db()->prepare('SELECT id FROM users WHERE login_id = ?');
    $stmt->execute([$loginId]);
    $isAvailable = $stmt->fetch() === false;

    json_response([
        'success' => true,
        'available' => $isAvailable,
        'message' => $isAvailable ? '사용 가능한 아이디입니다.' : '이미 사용 중인 아이디입니다.',
    ]);
} catch (Throwable $exception) {
    json_response([
        'success' => false,
        'message' => '아이디 중복검사 중 오류가 발생했습니다.',
        'error' => $exception->getMessage(),
    ], 500);
}
