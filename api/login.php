<?php

declare(strict_types=1);

require_once __DIR__ . '/bootstrap.php';

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
    json_response([
        'success' => false,
        'message' => 'POST method is required.',
    ], 405);
}

$input = json_input();
$loginId = trim((string)($input['login_id'] ?? ''));
$password = (string)($input['password'] ?? '');
$rememberMe = (bool)($input['remember_me'] ?? false);

if ($loginId === '' || $password === '') {
    json_response([
        'success' => false,
        'message' => '아이디와 비밀번호를 입력해주세요.',
    ], 422);
}

try {
    $stmt = db()->prepare(
        'SELECT u.id, u.organization_id, u.name, u.login_id, u.password_hash, o.name AS organization
         FROM users u
         INNER JOIN organizations o ON o.id = u.organization_id
         WHERE u.login_id = ?'
    );
    $stmt->execute([$loginId]);
    $user = $stmt->fetch();

    if ($user === false || !password_verify($password, $user['password_hash'])) {
        json_response([
            'success' => false,
            'message' => '아이디 또는 비밀번호가 올바르지 않습니다.',
        ], 401);
    }

    start_app_session($rememberMe);
    session_regenerate_id(true);

    $_SESSION['user'] = user_payload($user);

    clear_remember_token();

    if ($rememberMe) {
        issue_remember_token((int)$user['id']);
    }

    json_response([
        'success' => true,
        'message' => '로그인되었습니다.',
        'user' => $_SESSION['user'],
    ]);
} catch (Throwable $exception) {
    json_response([
        'success' => false,
        'message' => '로그인 처리 중 오류가 발생했습니다.',
        'error' => $exception->getMessage(),
    ], 500);
}
