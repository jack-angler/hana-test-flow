<?php

declare(strict_types=1);

require_once __DIR__ . '/bootstrap.php';

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
    json_response([
        'success' => false,
        'message' => 'POST method is required.',
    ], 405);
}

$user = require_user();

if (($user['role'] ?? '') !== 'admin') {
    json_response([
        'success' => false,
        'message' => '관리자만 시나리오 SQL을 실행할 수 있습니다.',
    ], 403);
}

set_time_limit(0);

$scenarioRoot = __DIR__ . '/scenario-sql';
$baseFiles = [
    '렌터카(대리점,특판).sql',
    '리스(운용, 금융, 중고차, 시승차).sql',
    '선구매.sql',
    '하나원큐오토서비스.sql',
    '할부.sql',
];
$update = trim((string)($_GET['update'] ?? ''));

if ($update !== '') {
    if (!preg_match('/^v[0-9]+$/', $update)) {
        json_response([
            'success' => false,
            'message' => '지원하지 않는 업데이트 버전입니다.',
        ], 422);
    }

    $files = ["update/{$update}/{$update}_all_delta.sql"];
} else {
    $files = $baseFiles;
}

try {
    $executedFiles = [];

    foreach ($files as $relativeFile) {
        $sqlFile = $scenarioRoot . '/' . $relativeFile;

        if (!is_file($sqlFile)) {
            json_response([
                'success' => false,
                'message' => '시나리오 SQL 파일을 찾을 수 없습니다.',
                'file' => $relativeFile,
            ], 500);
        }

        $sql = file_get_contents($sqlFile);

        if ($sql === false) {
            json_response([
                'success' => false,
                'message' => '시나리오 SQL 파일을 읽을 수 없습니다.',
                'file' => $relativeFile,
            ], 500);
        }

        db()->exec($sql);
        $executedFiles[] = $relativeFile;
    }

    json_response([
        'success' => true,
        'message' => '시나리오 SQL 실행이 완료되었습니다.',
        'mode' => $update === '' ? 'base' : $update,
        'files' => $executedFiles,
    ]);
} catch (Throwable $exception) {
    json_response([
        'success' => false,
        'message' => '시나리오 SQL 실행 중 오류가 발생했습니다.',
        'error' => $exception->getMessage(),
    ], 500);
}
