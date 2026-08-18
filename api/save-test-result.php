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

if (!can_submit_test_result($user)) {
    json_response([
        'success' => false,
        'message' => '테스터만 테스트 결과를 등록할 수 있습니다.',
    ], 403);
}

$contentType = (string)($_SERVER['CONTENT_TYPE'] ?? $_SERVER['HTTP_CONTENT_TYPE'] ?? '');
$isMultipart = stripos($contentType, 'multipart/form-data') === 0 || !empty($_POST) || !empty($_FILES);
$input = $isMultipart ? $_POST : json_input();

$testCaseId = (int)($input['test_case_id'] ?? 0);
$resultStatus = trim((string)($input['result_status'] ?? ''));
$actualResult = trim((string)($input['actual_result'] ?? ''));
$defectSummary = trim((string)($input['defect_summary'] ?? ''));
$estimateNumber = trim((string)($input['estimate_number'] ?? ''));
$targetLoginId = trim((string)($input['target_login_id'] ?? ''));
$evidenceMemo = trim((string)($input['evidence_memo'] ?? $actualResult));
$submissionMode = trim((string)($input['submission_mode'] ?? 'test'));
$retainedEvidenceIds = evidence_id_list($input['retained_evidence_ids'] ?? []);
$allowedStatuses = ['passed', 'failed', 'improvement', 'not_available'];
$evidenceStatuses = ['failed', 'improvement', 'not_available'];

if ($testCaseId < 1 || !in_array($resultStatus, $allowedStatuses, true)) {
    if ($isMultipart && empty($_POST) && empty($_FILES)) {
        json_response([
            'success' => false,
            'message' => '첨부 용량이 너무 크거나 요청 본문을 읽을 수 없습니다. 이미지를 줄여 다시 저장해 주세요.',
        ], 413);
    }

    json_response([
        'success' => false,
        'message' => '테스트 결과를 선택해주세요.',
    ], 422);
}

try {
    $pdo = db();
    $pdo->beginTransaction();
    $newDefectId = null;

    $caseStmt = $pdo->prepare(
        'SELECT id, case_code, name
         FROM test_cases
         WHERE id = ?
           AND is_current = 1
           AND is_deleted = 0'
    );
    $caseStmt->execute([$testCaseId]);
    $testCase = $caseStmt->fetch();

    if ($testCase === false) {
        $pdo->rollBack();
        json_response([
            'success' => false,
            'message' => '선택한 테스트 케이스를 찾을 수 없습니다.',
        ], 422);
    }

    $resultStmt = $pdo->prepare(
        'INSERT INTO test_case_results (
            test_case_id, user_id, organization_id, result_status,
            actual_result, defect_summary, tested_at
         ) VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)
         ON DUPLICATE KEY UPDATE
            organization_id = VALUES(organization_id),
            result_status = VALUES(result_status),
            actual_result = VALUES(actual_result),
            defect_summary = VALUES(defect_summary),
            tested_at = CURRENT_TIMESTAMP,
            updated_at = CURRENT_TIMESTAMP'
    );
    $resultStmt->execute([
        $testCaseId,
        (int)$user['id'],
        (int)$user['organization_id'],
        $resultStatus,
        $actualResult === '' ? null : $actualResult,
        $defectSummary === '' ? null : $defectSummary,
    ]);

    $idStmt = $pdo->prepare('SELECT id FROM test_case_results WHERE test_case_id = ? AND user_id = ?');
    $idStmt->execute([$testCaseId, (int)$user['id']]);
    $resultId = (int)$idStmt->fetchColumn();

    $historyStmt = $pdo->prepare(
        'INSERT INTO test_case_result_histories (
            test_case_result_id, test_case_id, user_id, organization_id,
            result_status, actual_result, defect_summary
         ) VALUES (?, ?, ?, ?, ?, ?, ?)'
    );
    $historyStmt->execute([
        $resultId,
        $testCaseId,
        (int)$user['id'],
        (int)$user['organization_id'],
        $resultStatus,
        $actualResult === '' ? null : $actualResult,
        $defectSummary === '' ? null : $defectSummary,
    ]);
    $historyId = (int)$pdo->lastInsertId();

    if ($isMultipart && in_array($resultStatus, $evidenceStatuses, true)) {
        ensure_evidence_table_exists($pdo);

        $files = normalize_uploaded_files($_FILES['evidence_images'] ?? null);
        $retainedEvidenceCount = copy_retained_evidences($pdo, [
            'result_id' => $resultId,
            'history_id' => $historyId,
            'case_id' => $testCaseId,
            'user_id' => (int)$user['id'],
            'organization_id' => (int)$user['organization_id'],
            'result_status' => $resultStatus,
            'estimate_number' => $estimateNumber,
            'target_login_id' => $targetLoginId,
            'memo' => $evidenceMemo,
            'retained_ids' => $retainedEvidenceIds,
        ]);

        if ($retainedEvidenceCount === 0 && count($files) === 0) {
            insert_evidence($pdo, [
                'result_id' => $resultId,
                'history_id' => $historyId,
                'case_id' => $testCaseId,
                'user_id' => (int)$user['id'],
                'organization_id' => (int)$user['organization_id'],
                'result_status' => $resultStatus,
                'source_type' => 'file',
                'estimate_number' => $estimateNumber,
                'target_login_id' => $targetLoginId,
                'memo' => $evidenceMemo,
            ]);
        }

        foreach ($files as $file) {
            if (($file['error'] ?? UPLOAD_ERR_NO_FILE) === UPLOAD_ERR_NO_FILE) {
                continue;
            }

            if (($file['error'] ?? UPLOAD_ERR_OK) !== UPLOAD_ERR_OK) {
                throw new RuntimeException('Image upload failed.');
            }

            $tmpName = (string)$file['tmp_name'];
            $mimeType = mime_content_type($tmpName) ?: '';
            $allowedMimeTypes = ['image/png', 'image/jpeg', 'image/webp', 'image/gif'];

            if (!in_array($mimeType, $allowedMimeTypes, true)) {
                throw new RuntimeException('Only image files can be attached.');
            }

            $imageSize = getimagesize($tmpName);
            $extension = match ($mimeType) {
                'image/png' => 'png',
                'image/jpeg' => 'jpg',
                'image/webp' => 'webp',
                'image/gif' => 'gif',
                default => 'bin',
            };
            $uploadRoot = __DIR__ . '/uploads/test-result-evidences';
            $relativeDir = date('Y/m');
            $targetDir = $uploadRoot . '/' . $relativeDir;

            if (!is_dir($targetDir) && !mkdir($targetDir, 0775, true) && !is_dir($targetDir)) {
                throw new RuntimeException('Failed to create upload directory.');
            }

            $storedFilename = bin2hex(random_bytes(16)) . '.' . $extension;
            $targetPath = $targetDir . '/' . $storedFilename;

            if (!move_uploaded_file($tmpName, $targetPath)) {
                throw new RuntimeException('Failed to save uploaded image.');
            }

            insert_evidence($pdo, [
                'result_id' => $resultId,
                'history_id' => $historyId,
                'case_id' => $testCaseId,
                'user_id' => (int)$user['id'],
                'organization_id' => (int)$user['organization_id'],
                'result_status' => $resultStatus,
                'source_type' => ((string)($input['source_type'] ?? 'file')) === 'clipboard' ? 'clipboard' : 'file',
                'estimate_number' => $estimateNumber,
                'target_login_id' => $targetLoginId,
                'memo' => $evidenceMemo,
                'original_filename' => (string)($file['name'] ?? ''),
                'stored_filename' => $storedFilename,
                'file_path' => 'uploads/test-result-evidences/' . $relativeDir . '/' . $storedFilename,
                'mime_type' => $mimeType,
                'file_size_bytes' => (int)($file['size'] ?? 0),
                'image_width' => is_array($imageSize) ? (int)$imageSize[0] : null,
                'image_height' => is_array($imageSize) ? (int)$imageSize[1] : null,
            ]);
        }
    }

    if (in_array($resultStatus, $evidenceStatuses, true)) {
        $newDefectId = upsert_defect($pdo, [
            'result_id' => $resultId,
            'history_id' => $historyId,
            'case_id' => $testCaseId,
            'case_code' => (string)$testCase['case_code'],
            'case_name' => (string)$testCase['name'],
            'user_id' => (int)$user['id'],
            'organization_id' => (int)$user['organization_id'],
            'result_status' => $resultStatus,
            'description' => $evidenceMemo !== '' ? $evidenceMemo : $actualResult,
            'summary' => $defectSummary,
            'force_reopen' => $submissionMode === 'redefect',
        ]);
    }

    $pdo->commit();

    if ($newDefectId !== null) {
        notify_new_defect($pdo, $newDefectId);
    }

    json_response([
        'success' => true,
        'message' => '테스트 결과가 저장되었습니다.',
        'result' => [
            'test_case_id' => $testCaseId,
            'result_status' => $resultStatus,
        ],
    ]);
} catch (Throwable $exception) {
    if (isset($pdo) && $pdo instanceof PDO && $pdo->inTransaction()) {
        $pdo->rollBack();
    }

    json_response([
        'success' => false,
        'message' => '테스트 결과 저장 중 오류가 발생했습니다.',
        'error' => $exception->getMessage(),
    ], 500);
}

function normalize_uploaded_files(?array $files): array
{
    if ($files === null || !isset($files['name'])) {
        return [];
    }

    if (!is_array($files['name'])) {
        return [$files];
    }

    $normalized = [];
    $count = count($files['name']);

    for ($index = 0; $index < $count; $index++) {
        $normalized[] = [
            'name' => $files['name'][$index] ?? '',
            'type' => $files['type'][$index] ?? '',
            'tmp_name' => $files['tmp_name'][$index] ?? '',
            'error' => $files['error'][$index] ?? UPLOAD_ERR_NO_FILE,
            'size' => $files['size'][$index] ?? 0,
        ];
    }

    return $normalized;
}

function upsert_defect(PDO $pdo, array $defect): ?int
{
    $title = trim((string)($defect['summary'] ?? ''));

    if ($title === '') {
        $title = sprintf(
            '[%s] %s',
            (string)$defect['case_code'],
            (string)$defect['case_name']
        );
    }

    $existingStmt = $pdo->prepare(
        'SELECT id, status, assignee_user_id, action_completed_at, verified_at
         FROM defects
         WHERE test_case_result_id = ?'
    );
    $existingStmt->execute([(int)$defect['result_id']]);
    $existing = $existingStmt->fetch();

    if ($existing === false) {
        $insertStmt = $pdo->prepare(
            'INSERT INTO defects (
                test_case_result_id, test_case_result_history_id, test_case_id,
                reporter_user_id, reporter_organization_id, result_status,
                status, title, description
             ) VALUES (?, ?, ?, ?, ?, ?, "received", ?, ?)'
        );
        $insertStmt->execute([
            (int)$defect['result_id'],
            (int)$defect['history_id'],
            (int)$defect['case_id'],
            (int)$defect['user_id'],
            (int)$defect['organization_id'],
            (string)$defect['result_status'],
            $title,
            trim((string)$defect['description']) === '' ? null : trim((string)$defect['description']),
        ]);

        $defectId = (int)$pdo->lastInsertId();
        insert_defect_status_history($pdo, $defectId, (int)$defect['user_id'], null, 'received');
        insert_defect_action($pdo, $defectId, (int)$defect['user_id'], 'received', null, 'received', '결함이 접수되었습니다.');
        return $defectId;
    }

    $rawCurrentStatus = (string)$existing['status'];
    $allowedTransitionStatuses = ['received', 'assigned', 'action_completed', 'tester_confirmation_pending', 'verification_completed'];
    $currentStatus = in_array($rawCurrentStatus, $allowedTransitionStatuses, true) ? $rawCurrentStatus : null;
    $isReopened =
        (bool)($defect['force_reopen'] ?? false)
        || in_array($rawCurrentStatus, ['action_completed', 'tester_confirmation_pending', 'verification_completed'], true)
        || ($existing['action_completed_at'] ?? null) !== null
        || ($existing['verified_at'] ?? null) !== null;
    $nextStatus = $isReopened
        ? (((int)($existing['assignee_user_id'] ?? 0) > 0) ? 'assigned' : 'received')
        : ($currentStatus ?? 'received');
    $description = trim((string)$defect['description']) === '' ? null : trim((string)$defect['description']);

    if ($isReopened) {
        $updateStmt = $pdo->prepare(
            'UPDATE defects
             SET test_case_result_history_id = ?,
                 result_status = ?,
                 status = ?,
                 title = ?,
                 description = ?,
                 action_memo = NULL,
                 action_completed_by_user_id = NULL,
                 action_completed_at = NULL,
                 verified_by_user_id = NULL,
                 verified_at = NULL,
                 updated_at = CURRENT_TIMESTAMP
             WHERE id = ?'
        );
        $updateStmt->execute([
            (int)$defect['history_id'],
            (string)$defect['result_status'],
            $nextStatus,
            $title,
            $description,
            (int)$existing['id'],
        ]);
    } else {
        $updateStmt = $pdo->prepare(
            'UPDATE defects
             SET test_case_result_history_id = ?,
                 result_status = ?,
                 status = ?,
                 title = ?,
                 description = ?,
                 updated_at = CURRENT_TIMESTAMP
             WHERE id = ?'
        );
        $updateStmt->execute([
            (int)$defect['history_id'],
            (string)$defect['result_status'],
            $nextStatus,
            $title,
            $description,
            (int)$existing['id'],
        ]);
    }

    if ($nextStatus !== $currentStatus) {
        insert_defect_status_history($pdo, (int)$existing['id'], (int)$defect['user_id'], $currentStatus, $nextStatus);
        insert_defect_action($pdo, (int)$existing['id'], (int)$defect['user_id'], $nextStatus, $currentStatus, $nextStatus, '재결함으로 다시 등록되어 담당자 지정 상태로 변경되었습니다.');
    }

    return $isReopened ? (int)$existing['id'] : null;
}

function insert_defect_status_history(PDO $pdo, int $defectId, int $userId, ?string $fromStatus, string $toStatus): void
{
    $stmt = $pdo->prepare(
        'INSERT INTO defect_status_histories (
            defect_id, changed_by_user_id, from_status, to_status
         ) VALUES (?, ?, ?, ?)'
    );
    $stmt->execute([$defectId, $userId, $fromStatus, $toStatus]);
}

function insert_defect_action(
    PDO $pdo,
    int $defectId,
    int $userId,
    string $actionType,
    ?string $fromStatus,
    ?string $toStatus,
    ?string $comment
): void {
    $stmt = $pdo->prepare(
        'INSERT INTO defect_actions (
            defect_id, user_id, action_type, from_status, to_status, comment
         ) VALUES (?, ?, ?, ?, ?, ?)'
    );
    $stmt->execute([$defectId, $userId, $actionType, $fromStatus, $toStatus, $comment]);
}

function evidence_id_list(mixed $value): array
{
    if (is_string($value)) {
        $decoded = json_decode($value, true);
        $value = is_array($decoded) ? $decoded : [];
    }

    if (!is_array($value)) {
        return [];
    }

    return array_values(array_unique(array_filter(array_map('intval', $value), static fn (int $id): bool => $id > 0)));
}

function ensure_evidence_table_exists(PDO $pdo): void
{
    $stmt = $pdo->query("SHOW TABLES LIKE 'test_case_result_evidences'");

    if ($stmt === false || $stmt->fetchColumn() === false) {
        throw new RuntimeException('증빙 테이블이 아직 생성되지 않았습니다. api/install.php를 실행해 DB 마이그레이션을 적용해 주세요.');
    }
}

function copy_retained_evidences(PDO $pdo, array $context): int
{
    $retainedIds = $context['retained_ids'] ?? [];

    if (count($retainedIds) === 0) {
        return 0;
    }

    $placeholders = implode(',', array_fill(0, count($retainedIds), '?'));
    $stmt = $pdo->prepare(
        "SELECT
            source_type,
            original_filename,
            stored_filename,
            file_path,
            mime_type,
            file_size_bytes,
            image_width,
            image_height
         FROM test_case_result_evidences
         WHERE id IN ({$placeholders})
           AND test_case_result_id = ?
           AND test_case_id = ?
           AND user_id = ?
           AND organization_id = ?
           AND file_path IS NOT NULL
         ORDER BY id ASC"
    );
    $stmt->execute([
        ...$retainedIds,
        $context['result_id'],
        $context['case_id'],
        $context['user_id'],
        $context['organization_id'],
    ]);

    $count = 0;

    foreach ($stmt->fetchAll() as $row) {
        insert_evidence($pdo, [
            'result_id' => $context['result_id'],
            'history_id' => $context['history_id'],
            'case_id' => $context['case_id'],
            'user_id' => $context['user_id'],
            'organization_id' => $context['organization_id'],
            'result_status' => $context['result_status'],
            'source_type' => $row['source_type'],
            'estimate_number' => $context['estimate_number'],
            'target_login_id' => $context['target_login_id'],
            'memo' => $context['memo'],
            'original_filename' => $row['original_filename'],
            'stored_filename' => $row['stored_filename'],
            'file_path' => $row['file_path'],
            'mime_type' => $row['mime_type'],
            'file_size_bytes' => $row['file_size_bytes'],
            'image_width' => $row['image_width'],
            'image_height' => $row['image_height'],
        ]);
        $count++;
    }

    return $count;
}

function insert_evidence(PDO $pdo, array $evidence): void
{
    $stmt = $pdo->prepare(
        'INSERT INTO test_case_result_evidences (
            test_case_result_id, test_case_result_history_id, test_case_id,
            user_id, organization_id, result_status, source_type,
            estimate_number, target_login_id, memo, original_filename,
            stored_filename, file_path, mime_type, file_size_bytes,
            image_width, image_height
         ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
    );
    $stmt->execute([
        $evidence['result_id'],
        $evidence['history_id'],
        $evidence['case_id'],
        $evidence['user_id'],
        $evidence['organization_id'],
        $evidence['result_status'],
        $evidence['source_type'],
        ($evidence['estimate_number'] ?? '') === '' ? null : $evidence['estimate_number'],
        ($evidence['target_login_id'] ?? '') === '' ? null : $evidence['target_login_id'],
        ($evidence['memo'] ?? '') === '' ? null : $evidence['memo'],
        ($evidence['original_filename'] ?? '') === '' ? null : $evidence['original_filename'],
        $evidence['stored_filename'] ?? null,
        $evidence['file_path'] ?? null,
        $evidence['mime_type'] ?? null,
        $evidence['file_size_bytes'] ?? null,
        $evidence['image_width'] ?? null,
        $evidence['image_height'] ?? null,
    ]);
}
