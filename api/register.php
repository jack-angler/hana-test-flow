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

$organizationId = (int)($input['organization_id'] ?? 0);
$name = trim((string)($input['name'] ?? ''));
$loginId = trim((string)($input['login_id'] ?? ''));
$password = (string)($input['password'] ?? '');
$passwordConfirm = (string)($input['password_confirm'] ?? '');

if ($organizationId < 1 || $name === '' || $loginId === '' || $password === '' || $passwordConfirm === '') {
    json_response([
        'success' => false,
        'message' => '소속, 이름, 아이디, 비밀번호를 모두 입력해주세요.',
    ], 422);
}

if (mb_strlen($name) > 50 || mb_strlen($loginId) > 60) {
    json_response([
        'success' => false,
        'message' => '입력 가능한 글자 수를 초과했습니다.',
    ], 422);
}

if (mb_strlen($password) < 4) {
    json_response([
        'success' => false,
        'message' => '비밀번호는 4자 이상 입력해주세요.',
    ], 422);
}

if ($password !== $passwordConfirm) {
    json_response([
        'success' => false,
        'message' => '비밀번호가 일치하지 않습니다.',
    ], 422);
}

try {
    $pdo = db();
    $pdo->beginTransaction();

    $organizationStmt = $pdo->prepare('SELECT id, name FROM organizations WHERE id = ?');
    $organizationStmt->execute([$organizationId]);
    $organization = $organizationStmt->fetch();

    if ($organization === false) {
        $pdo->rollBack();
        json_response([
            'success' => false,
            'message' => '선택한 소속을 찾을 수 없습니다.',
        ], 422);
    }

    $userCheckStmt = $pdo->prepare('SELECT id FROM users WHERE login_id = ?');
    $userCheckStmt->execute([$loginId]);

    if ($userCheckStmt->fetch() !== false) {
        $pdo->rollBack();
        json_response([
            'success' => false,
            'message' => '이미 사용 중인 아이디입니다.',
        ], 409);
    }

    $passwordHash = password_hash($password, PASSWORD_DEFAULT);
    $insertUserStmt = $pdo->prepare(
        'INSERT INTO users (organization_id, name, login_id, password_hash) VALUES (?, ?, ?, ?)'
    );
    $insertUserStmt->execute([$organizationId, $name, $loginId, $passwordHash]);

    $pdo->commit();

    json_response([
        'success' => true,
        'message' => '회원가입이 완료되었습니다.',
        'user' => [
            'id' => (int)$pdo->lastInsertId(),
            'organization_id' => $organizationId,
            'organization' => $organization['name'],
            'name' => $name,
            'login_id' => $loginId,
            'role' => user_role($loginId, $organizationId),
        ],
    ], 201);
} catch (Throwable $exception) {
    if (isset($pdo) && $pdo instanceof PDO && $pdo->inTransaction()) {
        $pdo->rollBack();
    }

    json_response([
        'success' => false,
        'message' => '회원가입 처리 중 오류가 발생했습니다.',
        'error' => $exception->getMessage(),
    ], 500);
}
