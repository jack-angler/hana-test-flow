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

function result_aggregation_excluded_login_ids(): array
{
    return ['P260513'];
}

function can_submit_test_result(array $user): bool
{
    return ($user['role'] ?? '') === 'tester'
        || in_array((string)($user['login_id'] ?? ''), result_aggregation_excluded_login_ids(), true);
}

function notify_new_defect(PDO $pdo, int $defectId): void
{
    $recipients = app_config('mail')['defect_recipients'] ?? [];

    if (!is_array($recipients) || $recipients === []) {
        return;
    }

    $stmt = $pdo->prepare(
        'SELECT
            d.id,
            d.result_status,
            d.defect_source,
            d.manual_location,
            d.title,
            d.description,
            d.created_at,
            reporter.name AS reporter_name,
            reporter.login_id AS reporter_login_id,
            reporter_org.name AS reporter_organization,
            tc.case_code,
            tc.name AS case_name,
            ts.name AS scenario_name,
            tr.name AS test_run_name
         FROM defects d
         INNER JOIN users reporter ON reporter.id = d.reporter_user_id
         INNER JOIN organizations reporter_org ON reporter_org.id = d.reporter_organization_id
         LEFT JOIN test_cases tc ON tc.id = d.test_case_id
         LEFT JOIN test_scenarios ts ON ts.id = tc.test_scenario_id
         LEFT JOIN test_runs tr ON tr.id = ts.test_run_id
         WHERE d.id = ?'
    );
    $stmt->execute([$defectId]);
    $defect = $stmt->fetch();

    if ($defect === false) {
        return;
    }

    $resultLabels = [
        'failed' => '실패',
        'improvement' => '개선',
        'not_available' => '테스트불가',
    ];
    $sourceLabel = ((string)($defect['defect_source'] ?? 'test_case')) === 'manual'
        ? '직접 등록'
        : '테스트 케이스';
    $caseLabel = ((string)($defect['defect_source'] ?? 'test_case')) === 'manual'
        ? ((string)($defect['manual_location'] ?? '') ?: '테스트 케이스 외')
        : sprintf(
            '%s / %s / %s',
            (string)($defect['test_run_name'] ?? '-'),
            (string)($defect['scenario_name'] ?? '-'),
            trim(sprintf('%s %s', (string)($defect['case_code'] ?? ''), (string)($defect['case_name'] ?? ''))) ?: '-'
        );
    $subject = sprintf('[하나원큐오토 통합테스트] 결함 #%d 접수/재접수', $defectId);
    $body = implode("\n", [
        '결함이 접수 또는 재접수되었습니다.',
        '',
        '결함 ID: #' . $defectId,
        '구분: ' . $sourceLabel,
        '결과: ' . ($resultLabels[(string)$defect['result_status']] ?? (string)$defect['result_status']),
        '제목: ' . (string)$defect['title'],
        '대상: ' . $caseLabel,
        '등록자: ' . (string)$defect['reporter_organization'] . ' / ' . (string)$defect['reporter_name'] . ' (' . (string)$defect['reporter_login_id'] . ')',
        '접수일시: ' . (string)$defect['created_at'],
        '',
        '내용:',
        (string)($defect['description'] ?? '-'),
    ]);

    send_app_mail($recipients, $subject, $body);
}

function send_app_mail(array $recipients, string $subject, string $body): void
{
    $validRecipients = array_values(array_filter(
        array_map('trim', $recipients),
        static fn (string $email): bool => filter_var($email, FILTER_VALIDATE_EMAIL) !== false
    ));

    if ($validRecipients === []) {
        return;
    }

    $mailConfig = app_config('mail') ?? [];
    $from = (string)($mailConfig['from'] ?? 'no-reply@example.com');
    $fromName = (string)($mailConfig['from_name'] ?? 'Hana Test Flow');
    $encodedFromName = function_exists('mb_encode_mimeheader')
        ? mb_encode_mimeheader($fromName, 'UTF-8')
        : $fromName;
    $encodedSubject = function_exists('mb_encode_mimeheader')
        ? mb_encode_mimeheader($subject, 'UTF-8')
        : $subject;
    $headers = [
        'MIME-Version: 1.0',
        'Content-Type: text/plain; charset=UTF-8',
        'From: ' . $encodedFromName . ' <' . $from . '>',
    ];

    foreach ($validRecipients as $recipient) {
        @mail($recipient, $encodedSubject, $body, implode("\r\n", $headers));
    }
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
