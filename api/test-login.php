<?php

declare(strict_types=1);

require_once __DIR__ . '/bootstrap.php';

$method = $_SERVER['REQUEST_METHOD'] ?? '';

if ($method === 'GET') {
    try {
        $stmt = db()->query(
            'SELECT u.id, u.organization_id, u.name, u.login_id, o.name AS organization
             FROM users u
             INNER JOIN organizations o ON o.id = u.organization_id
             ORDER BY o.name ASC, u.name ASC, u.login_id ASC'
        );
        $users = array_map(
            static fn (array $user): array => user_payload($user),
            $stmt->fetchAll()
        );

        json_response([
            'success' => true,
            'users' => $users,
        ]);
    } catch (Throwable $exception) {
        json_response([
            'success' => false,
            'message' => '테스트 계정 목록을 불러오는 중 오류가 발생했습니다.',
            'error' => $exception->getMessage(),
        ], 500);
    }
}

if ($method !== 'POST') {
    json_response([
        'success' => false,
        'message' => 'GET or POST method is required.',
    ], 405);
}

$input = json_input();
$userId = (int)($input['user_id'] ?? 0);
$loginId = trim((string)($input['login_id'] ?? ''));

if ($userId < 1 && $loginId === '') {
    json_response([
        'success' => false,
        'message' => '로그인할 계정을 선택해주세요.',
    ], 422);
}

try {
    if ($userId > 0) {
        $stmt = db()->prepare(
            'SELECT u.id, u.organization_id, u.name, u.login_id, o.name AS organization
             FROM users u
             INNER JOIN organizations o ON o.id = u.organization_id
             WHERE u.id = ?'
        );
        $stmt->execute([$userId]);
    } else {
        $stmt = db()->prepare(
            'SELECT u.id, u.organization_id, u.name, u.login_id, o.name AS organization
             FROM users u
             INNER JOIN organizations o ON o.id = u.organization_id
             WHERE u.login_id = ?'
        );
        $stmt->execute([$loginId]);
    }

    $user = $stmt->fetch();

    if ($user === false) {
        json_response([
            'success' => false,
            'message' => '계정을 찾을 수 없습니다.',
        ], 404);
    }

    start_app_session(false);
    session_regenerate_id(true);

    $_SESSION['user'] = user_payload($user);
    clear_remember_token();

    json_response([
        'success' => true,
        'message' => '테스트 계정으로 로그인되었습니다.',
        'user' => $_SESSION['user'],
    ]);
} catch (Throwable $exception) {
    json_response([
        'success' => false,
        'message' => '테스트 로그인 처리 중 오류가 발생했습니다.',
        'error' => $exception->getMessage(),
    ], 500);
}
