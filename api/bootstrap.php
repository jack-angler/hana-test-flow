<?php

declare(strict_types=1);

$config = require __DIR__ . '/config.php';

function app_config(?string $key = null): mixed
{
    global $config;

    if ($key === null) {
        return $config;
    }

    return $config[$key] ?? null;
}

function apply_cors(): void
{
    $origin = $_SERVER['HTTP_ORIGIN'] ?? '';
    $allowedOrigins = app_config('cors')['allowed_origins'] ?? [];

    if ($origin !== '' && in_array($origin, $allowedOrigins, true)) {
        header("Access-Control-Allow-Origin: {$origin}");
        header('Vary: Origin');
    }

    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Allow-Headers: Content-Type, Authorization');
    header('Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, OPTIONS');

    if (($_SERVER['REQUEST_METHOD'] ?? '') === 'OPTIONS') {
        http_response_code(204);
        exit;
    }
}

function json_response(array $payload, int $status = 200): never
{
    http_response_code($status);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

function json_input(): array
{
    $raw = file_get_contents('php://input');

    if ($raw === false || trim($raw) === '') {
        return [];
    }

    $decoded = json_decode($raw, true);

    if (!is_array($decoded)) {
        json_response([
            'success' => false,
            'message' => 'Invalid JSON request body.',
        ], 400);
    }

    return $decoded;
}

function user_role(string $loginId, int $organizationId): string
{
    if ($loginId === 'admin') {
        return 'admin';
    }

    if ($organizationId === 900) {
        return 'project';
    }

    return 'tester';
}

function is_secure_request(): bool
{
    return (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off');
}

function start_app_session(bool $persistent = false): void
{
    if (session_status() === PHP_SESSION_ACTIVE) {
        return;
    }

    $lifetime = 0;
    $isSecure = is_secure_request();

    if ($persistent) {
        $sessionDays = app_config('auth')['session_days'] ?? 30;
        $lifetime = 60 * 60 * 24 * (int)$sessionDays;
    }

    session_set_cookie_params([
        'lifetime' => $lifetime,
        'path' => '/',
        'secure' => $isSecure,
        'httponly' => true,
        'samesite' => $isSecure ? 'None' : 'Lax',
    ]);

    session_start();
}

function remember_cookie_name(): string
{
    return 'hana_test_flow_remember';
}

function remember_cookie_options(int $expires): array
{
    return [
        'expires' => $expires,
        'path' => '/',
        'secure' => is_secure_request(),
        'httponly' => true,
        'samesite' => is_secure_request() ? 'None' : 'Lax',
    ];
}

function user_agent_hash(): string
{
    return hash('sha256', $_SERVER['HTTP_USER_AGENT'] ?? '');
}

function user_payload(array $user): array
{
    return [
        'id' => (int)$user['id'],
        'organization_id' => (int)$user['organization_id'],
        'organization' => $user['organization'],
        'name' => $user['name'],
        'login_id' => $user['login_id'],
        'role' => user_role($user['login_id'], (int)$user['organization_id']),
    ];
}

function issue_remember_token(int $userId): void
{
    $selector = bin2hex(random_bytes(16));
    $token = bin2hex(random_bytes(32));
    $tokenHash = hash('sha256', $token);
    $rememberDays = app_config('auth')['remember_days'] ?? 30;
    $expires = time() + (60 * 60 * 24 * (int)$rememberDays);
    $expiresAt = date('Y-m-d H:i:s', $expires);

    $stmt = db()->prepare(
        'INSERT INTO remember_tokens (user_id, selector, token_hash, user_agent_hash, expires_at)
         VALUES (?, ?, ?, ?, ?)'
    );
    $stmt->execute([$userId, $selector, $tokenHash, user_agent_hash(), $expiresAt]);

    setcookie(remember_cookie_name(), "{$selector}:{$token}", remember_cookie_options($expires));
}

function clear_remember_token(): void
{
    $cookie = $_COOKIE[remember_cookie_name()] ?? '';
    $parts = explode(':', $cookie, 2);

    if (count($parts) === 2) {
        db()->prepare('DELETE FROM remember_tokens WHERE selector = ?')->execute([$parts[0]]);
    }

    setcookie(remember_cookie_name(), '', remember_cookie_options(time() - 3600));
}

function try_remember_login(): ?array
{
    $cookie = $_COOKIE[remember_cookie_name()] ?? '';
    $parts = explode(':', $cookie, 2);

    if (count($parts) !== 2) {
        return null;
    }

    [$selector, $token] = $parts;

    if (!ctype_xdigit($selector) || strlen($selector) !== 32 || !ctype_xdigit($token) || strlen($token) !== 64) {
        clear_remember_token();
        return null;
    }

    $stmt = db()->prepare(
        'SELECT rt.id, rt.user_id, rt.token_hash, rt.user_agent_hash, rt.expires_at,
                u.organization_id, u.name, u.login_id, o.name AS organization
         FROM remember_tokens rt
         INNER JOIN users u ON u.id = rt.user_id
         INNER JOIN organizations o ON o.id = u.organization_id
         WHERE rt.selector = ?'
    );
    $stmt->execute([$selector]);
    $rememberToken = $stmt->fetch();

    if ($rememberToken === false) {
        clear_remember_token();
        return null;
    }

    if (strtotime($rememberToken['expires_at']) <= time()) {
        clear_remember_token();
        return null;
    }

    if (!hash_equals($rememberToken['user_agent_hash'], user_agent_hash())) {
        clear_remember_token();
        return null;
    }

    if (!hash_equals($rememberToken['token_hash'], hash('sha256', $token))) {
        db()->prepare('DELETE FROM remember_tokens WHERE user_id = ?')->execute([(int)$rememberToken['user_id']]);
        clear_remember_token();
        return null;
    }

    db()->prepare('DELETE FROM remember_tokens WHERE id = ?')->execute([(int)$rememberToken['id']]);

    start_app_session(true);
    session_regenerate_id(true);

    $_SESSION['user'] = user_payload([
        'id' => (int)$rememberToken['user_id'],
        'organization_id' => (int)$rememberToken['organization_id'],
        'organization' => $rememberToken['organization'],
        'name' => $rememberToken['name'],
        'login_id' => $rememberToken['login_id'],
    ]);

    issue_remember_token((int)$rememberToken['user_id']);

    return $_SESSION['user'];
}

function session_user(): ?array
{
    start_app_session();

    $user = $_SESSION['user'] ?? try_remember_login();

    if (is_array($user)) {
        $user['role'] = user_role((string)$user['login_id'], (int)$user['organization_id']);
        $_SESSION['user'] = $user;
    }

    return $user;
}

function require_user(): array
{
    $user = session_user();

    if ($user === null) {
        json_response([
            'success' => false,
            'message' => '로그인이 필요합니다.',
        ], 401);
    }

    return $user;
}

function db(): PDO
{
    static $pdo = null;

    if ($pdo instanceof PDO) {
        return $pdo;
    }

    $database = app_config('database');
    $dsn = sprintf(
        'mysql:host=%s;dbname=%s;charset=%s',
        $database['host'],
        $database['name'],
        $database['charset']
    );

    $pdo = new PDO($dsn, $database['user'], $database['password'], [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ]);

    return $pdo;
}

apply_cors();
