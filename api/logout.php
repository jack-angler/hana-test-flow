<?php

declare(strict_types=1);

require_once __DIR__ . '/bootstrap.php';

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
    json_response([
        'success' => false,
        'message' => 'POST method is required.',
    ], 405);
}

start_app_session();
clear_remember_token();
$_SESSION = [];

if (ini_get('session.use_cookies')) {
    $params = session_get_cookie_params();
    setcookie(session_name(), '', time() - 42000, $params['path'], $params['domain'] ?? '', $params['secure'], $params['httponly']);
}

session_destroy();

json_response([
    'success' => true,
    'message' => '로그아웃되었습니다.',
]);
