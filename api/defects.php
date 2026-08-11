<?php

declare(strict_types=1);

require_once __DIR__ . '/bootstrap.php';

$method = $_SERVER['REQUEST_METHOD'] ?? '';
$user = require_user();

if ($method === 'GET') {
    list_defects($user);
}

if ($method === 'PATCH' || $method === 'POST') {
    update_defect($user);
}

json_response([
    'success' => false,
        'message' => 'GET, POST or PATCH method is required.',
], 405);

function list_defects(array $user): void
{
    try {
        $pdo = db();

        sync_missing_defects($pdo);

        $page = max(1, (int)($_GET['page'] ?? 1));
        $pageSize = min(100, max(1, (int)($_GET['page_size'] ?? 30)));
        $offset = ($page - 1) * $pageSize;
        $statusFilter = normalize_defect_status_filter((string)($_GET['status'] ?? 'all'));
        [$whereSql, $params] = defect_where_clause($user, $statusFilter);
        [$visibilitySql, $visibilityParams] = defect_visibility_clause($user);

        $statusSql = normalized_defect_status_sql();
        $stmt = $pdo->prepare(
            'SELECT
                d.id,
                d.test_case_result_id,
                d.test_case_result_history_id,
                d.test_case_id,
                d.result_status,
                d.defect_source,
                d.manual_location,
                d.status AS raw_status,
                ' . $statusSql . ' AS status,
                d.title,
                d.description,
                d.action_memo,
                d.assigned_at,
                d.action_completed_at,
                d.verified_at,
                d.created_at,
                d.updated_at,
                d.reporter_user_id,
                reporter.name AS reporter_name,
                reporter_org.name AS reporter_organization,
                assignee.id AS assignee_user_id,
                assignee.name AS assignee_name,
                assignee.login_id AS assignee_login_id,
                tc.case_code,
                tc.name AS case_name,
                tc.scenario_menu,
                tc.location,
                tc.precondition,
                tc.test_steps,
                tc.expected_result,
                ts.name AS scenario_name,
                tr.name AS test_run_name
             FROM defects d
             LEFT JOIN test_cases tc ON tc.id = d.test_case_id
             LEFT JOIN test_scenarios ts ON ts.id = tc.test_scenario_id
             LEFT JOIN test_runs tr ON tr.id = ts.test_run_id
             INNER JOIN users reporter ON reporter.id = d.reporter_user_id
             INNER JOIN organizations reporter_org ON reporter_org.id = d.reporter_organization_id
             LEFT JOIN users assignee ON assignee.id = d.assignee_user_id
             ' . $whereSql . '
             ORDER BY
                FIELD(' . $statusSql . ', "received", "assigned", "tester_confirmation_pending", "verification_completed"),
                d.created_at DESC,
                d.id DESC
             LIMIT ' . $pageSize . ' OFFSET ' . $offset
        );
        $stmt->execute($params);
        $defects = $stmt->fetchAll();
        $totalStmt = $pdo->prepare('SELECT COUNT(*) FROM defects d ' . $whereSql);
        $totalStmt->execute($params);
        $total = (int)$totalStmt->fetchColumn();

        json_response([
            'success' => true,
            'defects' => attach_defect_action_images($pdo, attach_defect_evidences($pdo, $defects)),
            'pagination' => [
                'page' => $page,
                'page_size' => $pageSize,
                'total' => $total,
                'has_more' => ($offset + count($defects)) < $total,
                'next_page' => ($offset + count($defects)) < $total ? $page + 1 : null,
            ],
            'counts' => defect_filter_counts($pdo, $user, $visibilitySql, $visibilityParams),
        ]);
    } catch (Throwable $exception) {
        json_response([
            'success' => false,
            'message' => '결함 목록을 불러오지 못했습니다.',
            'error' => $exception->getMessage(),
        ], 500);
    }
}

function normalize_defect_status_filter(string $status): string
{
    $allowed = ['open', 'all', 'received', 'assigned', 'tester_confirmation_pending', 'verification_completed'];

    return in_array($status, $allowed, true) ? $status : 'all';
}

function defect_visibility_clause(array $user): array
{
    if (($user['role'] ?? '') === 'admin') {
        return ['', []];
    }

    return ['WHERE (d.reporter_user_id = ? OR d.assignee_user_id = ?)', [(int)$user['id'], (int)$user['id']]];
}

function normalized_defect_status_sql(string $alias = 'd'): string
{
    return 'CASE
        WHEN ' . $alias . '.status = "verification_completed"
            THEN "verification_completed"
        WHEN ' . $alias . '.status IN ("action_completed", "tester_confirmation_pending")
            THEN "tester_confirmation_pending"
        WHEN ' . $alias . '.status = "assigned"
            THEN "assigned"
        WHEN ' . $alias . '.status = "received"
            THEN "received"
        WHEN ' . $alias . '.verified_at IS NOT NULL
            THEN "verification_completed"
        WHEN ' . $alias . '.action_completed_at IS NOT NULL
            THEN "tester_confirmation_pending"
        WHEN ' . $alias . '.assignee_user_id IS NOT NULL
            THEN "assigned"
        ELSE "received"
    END';
}

function transition_from_status(?string $status): ?string
{
    $allowed = ['received', 'assigned', 'action_completed', 'tester_confirmation_pending', 'verification_completed'];

    return in_array((string)$status, $allowed, true) ? (string)$status : null;
}

function defect_where_clause(array $user, string $statusFilter): array
{
    [$whereSql, $params] = defect_visibility_clause($user);
    $conditions = [];
    $statusSql = normalized_defect_status_sql();

    if ($whereSql !== '') {
        $conditions[] = substr($whereSql, 6);
    }

    if ($statusFilter === 'open') {
        if (($user['role'] ?? '') === 'tester') {
            $conditions[] = 'd.reporter_user_id = ?';
            $params[] = (int)$user['id'];
            $conditions[] = $statusSql . ' = "tester_confirmation_pending"';
        } elseif (($user['role'] ?? '') === 'project') {
            $conditions[] = 'd.assignee_user_id = ?';
            $params[] = (int)$user['id'];
            $conditions[] = $statusSql . ' = "assigned"';
        } else {
            $conditions[] = $statusSql . ' = "received"';
        }
    } elseif ($statusFilter !== 'all') {
        $conditions[] = $statusSql . ' = ?';
        $params[] = $statusFilter;
    }

    return [
        count($conditions) > 0 ? 'WHERE ' . implode(' AND ', $conditions) : '',
        $params,
    ];
}

function defect_filter_counts(PDO $pdo, array $user, string $visibilitySql, array $visibilityParams): array
{
    $statusSql = normalized_defect_status_sql();
    $counts = [
        'open' => defect_filter_count($pdo, $user, 'open'),
        'all' => defect_filter_count($pdo, $user, 'all'),
        'received' => 0,
        'assigned' => 0,
        'tester_confirmation_pending' => 0,
        'verification_completed' => 0,
    ];
    $stmt = $pdo->prepare(
        'SELECT
            ' . $statusSql . ' AS status,
            COUNT(*) AS count
         FROM defects d
         ' . $visibilitySql . '
         GROUP BY ' . $statusSql
    );
    $stmt->execute($visibilityParams);

    foreach ($stmt->fetchAll() as $row) {
        $status = (string)$row['status'];

        if (array_key_exists($status, $counts)) {
            $counts[$status] = (int)$row['count'];
        }
    }

    return $counts;
}

function defect_filter_count(PDO $pdo, array $user, string $statusFilter): int
{
    [$whereSql, $params] = defect_where_clause($user, $statusFilter);
    $stmt = $pdo->prepare('SELECT COUNT(*) FROM defects d ' . $whereSql);
    $stmt->execute($params);

    return (int)$stmt->fetchColumn();
}

function attach_defect_evidences(PDO $pdo, array $defects): array
{
    if (count($defects) === 0) {
        return [];
    }

    $resultIds = array_values(array_unique(array_filter(array_map(
        static fn (array $defect): int => (int)($defect['test_case_result_id'] ?? 0),
        $defects
    ), static fn (int $id): bool => $id > 0)));

    if (count($resultIds) === 0) {
        return array_map(
            static function (array $defect): array {
                $defect['evidence'] = [
                    'result_status' => $defect['result_status'],
                    'estimate_number' => '',
                    'target_login_id' => '',
                    'memo' => $defect['description'] ?? '',
                    'images' => [],
                ];

                return $defect;
            },
            $defects
        );
    }
    $placeholders = implode(',', array_fill(0, count($resultIds), '?'));
    $stmt = $pdo->prepare(
        "SELECT
            tcre.id,
            tcre.test_case_result_id,
            tcre.test_case_result_history_id,
            tcre.result_status,
            tcre.estimate_number,
            tcre.target_login_id,
            tcre.memo,
            tcre.original_filename,
            tcre.stored_filename,
            tcre.file_path,
            tcre.mime_type,
            tcre.file_size_bytes,
            tcre.image_width,
            tcre.image_height,
            tcre.created_at
         FROM test_case_result_evidences tcre
         INNER JOIN (
            SELECT test_case_result_id, MAX(test_case_result_history_id) AS history_id
            FROM test_case_result_evidences
            WHERE test_case_result_id IN ({$placeholders})
            GROUP BY test_case_result_id
         ) latest
            ON latest.test_case_result_id = tcre.test_case_result_id
           AND latest.history_id <=> tcre.test_case_result_history_id
         ORDER BY tcre.test_case_result_id ASC, tcre.id ASC"
    );
    $stmt->execute($resultIds);

    $evidenceMap = [];

    foreach ($stmt->fetchAll() as $row) {
        $resultId = (int)$row['test_case_result_id'];

        if (!isset($evidenceMap[$resultId])) {
            $evidenceMap[$resultId] = [
                'result_status' => $row['result_status'],
                'estimate_number' => $row['estimate_number'] ?? '',
                'target_login_id' => $row['target_login_id'] ?? '',
                'memo' => $row['memo'] ?? '',
                'images' => [],
            ];
        }

        if (($row['file_path'] ?? '') === '') {
            continue;
        }

        $evidenceMap[$resultId]['images'][] = [
            'id' => (int)$row['id'],
            'name' => $row['original_filename'] ?: $row['stored_filename'],
            'file_path' => $row['file_path'],
            'mime_type' => $row['mime_type'],
            'size' => (int)$row['file_size_bytes'],
            'width' => $row['image_width'] === null ? null : (int)$row['image_width'],
            'height' => $row['image_height'] === null ? null : (int)$row['image_height'],
            'created_at' => $row['created_at'],
        ];
    }

    return array_map(
        static function (array $defect) use ($evidenceMap): array {
            $resultId = (int)($defect['test_case_result_id'] ?? 0);
            $defect['evidence'] = $evidenceMap[$resultId] ?? [
                'result_status' => $defect['result_status'],
                'estimate_number' => '',
                'target_login_id' => '',
                'memo' => $defect['description'] ?? '',
                'images' => [],
            ];

            return $defect;
        },
        $defects
    );
}

function attach_defect_action_images(PDO $pdo, array $defects): array
{
    if (count($defects) === 0) {
        return [];
    }

    if (!defect_action_images_table_exists($pdo)) {
        return array_map(
            static function (array $defect): array {
                $defect['action_images'] = [];

                return $defect;
            },
            $defects
        );
    }

    $defectIds = array_values(array_unique(array_map(
        static fn (array $defect): int => (int)$defect['id'],
        $defects
    )));
    $placeholders = implode(',', array_fill(0, count($defectIds), '?'));
    $stmt = $pdo->prepare(
        "SELECT
            dai.id,
            dai.defect_id,
            dai.defect_action_id,
            dai.original_filename,
            dai.stored_filename,
            dai.file_path,
            dai.mime_type,
            dai.file_size_bytes,
            dai.image_width,
            dai.image_height,
            dai.created_at,
            da.action_type,
            da.comment,
            da.created_at AS action_created_at,
            u.name AS user_name
         FROM defect_action_images dai
         INNER JOIN defect_actions da ON da.id = dai.defect_action_id
         INNER JOIN users u ON u.id = dai.user_id
         WHERE dai.defect_id IN ({$placeholders})
         ORDER BY da.created_at DESC, da.id DESC, dai.id ASC"
    );
    $stmt->execute($defectIds);

    $imageMap = [];

    foreach ($stmt->fetchAll() as $row) {
        $defectId = (int)$row['defect_id'];
        $imageMap[$defectId][] = [
            'id' => (int)$row['id'],
            'action_id' => (int)$row['defect_action_id'],
            'name' => $row['original_filename'] ?: $row['stored_filename'],
            'file_path' => $row['file_path'],
            'mime_type' => $row['mime_type'],
            'size' => (int)$row['file_size_bytes'],
            'width' => $row['image_width'] === null ? null : (int)$row['image_width'],
            'height' => $row['image_height'] === null ? null : (int)$row['image_height'],
            'created_at' => $row['created_at'],
            'action_type' => $row['action_type'],
            'action_created_at' => $row['action_created_at'],
            'user_name' => $row['user_name'],
            'comment' => $row['comment'],
        ];
    }

    return array_map(
        static function (array $defect) use ($imageMap): array {
            $defect['action_images'] = $imageMap[(int)$defect['id']] ?? [];

            return $defect;
        },
        $defects
    );
}

function sync_missing_defects(PDO $pdo): void
{
    $insertStmt = $pdo->prepare(
        'INSERT INTO defects (
            test_case_result_id, test_case_result_history_id, test_case_id,
            reporter_user_id, reporter_organization_id, result_status,
            status, title, description
         )
         SELECT
            tcr.id,
            (
                SELECT MAX(tcrh.id)
                FROM test_case_result_histories tcrh
                WHERE tcrh.test_case_result_id = tcr.id
            ),
            tcr.test_case_id,
            tcr.user_id,
            tcr.organization_id,
            tcr.result_status,
            "received",
            CONCAT("[", tc.case_code, "] ", tc.name),
            tcr.actual_result
         FROM test_case_results tcr
         INNER JOIN test_cases tc ON tc.id = tcr.test_case_id
         LEFT JOIN defects d ON d.test_case_result_id = tcr.id
         WHERE tcr.result_status IN ("failed", "improvement", "not_available")
           AND d.id IS NULL'
    );
    $insertStmt->execute();

    $historyStmt = $pdo->prepare(
        'INSERT INTO defect_status_histories (
            defect_id, changed_by_user_id, from_status, to_status
         )
         SELECT d.id, d.reporter_user_id, NULL, "received"
         FROM defects d
         LEFT JOIN defect_status_histories dsh ON dsh.defect_id = d.id
         WHERE dsh.id IS NULL'
    );
    $historyStmt->execute();

    $actionStmt = $pdo->prepare(
        'INSERT INTO defect_actions (
            defect_id, user_id, action_type, from_status, to_status, comment
         )
         SELECT d.id, d.reporter_user_id, "received", NULL, "received", "기존 비성공 테스트 결과에서 결함이 접수되었습니다."
         FROM defects d
         LEFT JOIN defect_actions da ON da.defect_id = d.id
         WHERE da.id IS NULL'
    );
    $actionStmt->execute();
}

function update_defect(array $user): void
{
    $contentType = (string)($_SERVER['CONTENT_TYPE'] ?? $_SERVER['HTTP_CONTENT_TYPE'] ?? '');
    $isMultipart = stripos($contentType, 'multipart/form-data') === 0 || !empty($_POST) || !empty($_FILES);
    $input = $isMultipart ? $_POST : json_input();
    $defectId = (int)($input['defect_id'] ?? 0);
    $action = trim((string)($input['action'] ?? ''));

    if ($action === '') {
        json_response([
            'success' => false,
            'message' => '결함과 처리 작업을 선택해주세요.',
        ], 422);
    }

    try {
        $pdo = db();
        $pdo->beginTransaction();

        if ($action === 'create_manual') {
            create_manual_defect($pdo, $user, $input);
            $pdo->commit();

            json_response([
                'success' => true,
                'message' => '寃고븿???묒닔?섏뿀?듬땲??',
            ]);
        }

        if ($defectId < 1) {
            $pdo->rollBack();
            json_response([
                'success' => false,
                'message' => '寃고븿怨?泥섎━ ?묒뾽???좏깮?댁＜?몄슂.',
            ], 422);
        }

        $stmt = $pdo->prepare(
            'SELECT id, status, reporter_user_id, assignee_user_id, action_completed_at, verified_at
             FROM defects
             WHERE id = ?
             FOR UPDATE'
        );
        $stmt->execute([$defectId]);
        $defect = $stmt->fetch();

        if ($defect === false) {
            $pdo->rollBack();
            json_response([
                'success' => false,
                'message' => '결함을 찾을 수 없습니다.',
            ], 404);
        }

        match ($action) {
            'assign' => assign_defect($pdo, $user, $defect, $input),
            'complete_action' => complete_action($pdo, $user, $defect, $input),
            'reopen_manual' => reopen_manual_defect($pdo, $user, $defect, $input),
            'verify' => verify_defect($pdo, $user, $defect),
            default => json_response([
                'success' => false,
                'message' => '지원하지 않는 처리 작업입니다.',
            ], 422),
        };

        $pdo->commit();

        json_response([
            'success' => true,
            'message' => '결함 상태가 저장되었습니다.',
        ]);
    } catch (Throwable $exception) {
        if (isset($pdo) && $pdo instanceof PDO && $pdo->inTransaction()) {
            $pdo->rollBack();
        }

        json_response([
            'success' => false,
            'message' => '결함 상태 저장 중 오류가 발생했습니다.',
            'error' => $exception->getMessage(),
        ], 500);
    }
}

function create_manual_defect(PDO $pdo, array $user, array $input): void
{
    if (($user['role'] ?? '') !== 'tester') {
        json_response([
            'success' => false,
            'message' => '寃고븿 吏곸젒 ?깅줉???뚯뒪?곕쭔 ?????덉뒿?덈떎.',
        ], 403);
    }

    $resultStatus = (string)($input['result_status'] ?? '');
    $allowedStatuses = ['failed', 'improvement', 'not_available'];

    if (!in_array($resultStatus, $allowedStatuses, true)) {
        json_response([
            'success' => false,
            'message' => '寃고븿 援щ텇???좏깮?댁＜?몄슂.',
        ], 422);
    }

    $title = trim((string)($input['title'] ?? ''));
    $description = trim((string)($input['description'] ?? ''));
    $manualLocation = trim((string)($input['manual_location'] ?? ''));

    if ($title === '' || $description === '') {
        json_response([
            'success' => false,
            'message' => '寃고븿紐낃낵 ?ㅻ챸???낅젰?댁＜?몄슂.',
        ], 422);
    }

    $stmt = $pdo->prepare(
        'INSERT INTO defects (
            test_case_result_id, test_case_result_history_id, test_case_id,
            reporter_user_id, reporter_organization_id, result_status,
            defect_source, manual_location, status, title, description
         ) VALUES (NULL, NULL, NULL, ?, ?, ?, "manual", ?, "received", ?, ?)'
    );
    $stmt->execute([
        (int)$user['id'],
        (int)$user['organization_id'],
        $resultStatus,
        $manualLocation === '' ? null : $manualLocation,
        $title,
        $description,
    ]);

    $defectId = (int)$pdo->lastInsertId();

    insert_defect_status_history($pdo, $defectId, (int)$user['id'], null, 'received');
    $actionId = insert_defect_action($pdo, $defectId, (int)$user['id'], 'received', null, 'received', $description);
    insert_defect_action_images($pdo, [
        'action_id' => $actionId,
        'defect_id' => $defectId,
        'user_id' => (int)$user['id'],
        'source_type' => ((string)($input['source_type'] ?? 'file')) === 'clipboard' ? 'clipboard' : 'file',
    ]);
}

function reopen_manual_defect(PDO $pdo, array $user, array $defect, array $input): void
{
    $isReporter = (int)$defect['reporter_user_id'] === (int)$user['id'];

    if (!$isReporter) {
        json_response([
            'success' => false,
            'message' => '재결함은 결함 등록자만 등록할 수 있습니다.',
        ], 403);

        json_response([
            'success' => false,
            'message' => '?ш껐?⑥쓣 ?깅줉???묒닔?먮쭔 ?????덉뒿?덈떎.',
        ], 403);
    }

    $canReopen =
        in_array((string)$defect['status'], ['action_completed', 'tester_confirmation_pending', 'verification_completed'], true)
        || ($defect['action_completed_at'] ?? null) !== null
        || ($defect['verified_at'] ?? null) !== null;

    if (!$canReopen) {
        json_response([
            'success' => false,
            'message' => '조치완료 또는 확인완료 상태에서만 재결함을 등록할 수 있습니다.',
        ], 422);

        json_response([
            'success' => false,
            'message' => '議곗튂?꾨즺 ?먮뒗 ?뺤씤?湲??곹깭?먯꽌留??ш껐?⑥쓣 ?깅줉?????덉뒿?덈떎.',
        ], 422);
    }

    $resultStatus = (string)($input['result_status'] ?? '');
    $allowedStatuses = ['failed', 'improvement', 'not_available'];

    if (!in_array($resultStatus, $allowedStatuses, true)) {
        json_response([
            'success' => false,
            'message' => '결함 구분을 선택해주세요.',
        ], 422);

        json_response([
            'success' => false,
            'message' => '寃고븿 援щ텇???좏깮?댁＜?몄슂.',
        ], 422);
    }

    $title = trim((string)($input['title'] ?? ''));
    $description = trim((string)($input['description'] ?? ''));
    $manualLocation = trim((string)($input['manual_location'] ?? ''));

    if ($title === '' || $description === '') {
        json_response([
            'success' => false,
            'message' => '결함명과 설명을 입력해주세요.',
        ], 422);

        json_response([
            'success' => false,
            'message' => '寃고븿紐낃낵 ?ㅻ챸???낅젰?댁＜?몄슂.',
        ], 422);
    }

    $rawFromStatus = (string)$defect['status'];
    $allowedTransitionStatuses = ['received', 'assigned', 'action_completed', 'tester_confirmation_pending', 'verification_completed'];
    $fromStatus = in_array($rawFromStatus, $allowedTransitionStatuses, true) ? $rawFromStatus : null;
    $toStatus = ((int)($defect['assignee_user_id'] ?? 0) > 0) ? 'assigned' : 'received';
    $updateStmt = $pdo->prepare(
        'UPDATE defects
         SET result_status = ?,
             defect_source = "manual",
             manual_location = ?,
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
        $resultStatus,
        $manualLocation === '' ? null : $manualLocation,
        $toStatus,
        $title,
        $description,
        (int)$defect['id'],
    ]);

    insert_defect_status_history($pdo, (int)$defect['id'], (int)$user['id'], $fromStatus, $toStatus);
    $actionId = insert_defect_action($pdo, (int)$defect['id'], (int)$user['id'], 'received', $fromStatus, $toStatus, $description);
    insert_defect_action_images($pdo, [
        'action_id' => $actionId,
        'defect_id' => (int)$defect['id'],
        'user_id' => (int)$user['id'],
        'source_type' => ((string)($input['source_type'] ?? 'file')) === 'clipboard' ? 'clipboard' : 'file',
    ]);
}

function assign_defect(PDO $pdo, array $user, array $defect, array $input): void
{
    if (($user['role'] ?? '') !== 'admin') {
        json_response([
            'success' => false,
            'message' => '담당자 지정은 관리자만 할 수 있습니다.',
        ], 403);
    }

    $assigneeUserId = (int)($input['assignee_user_id'] ?? 0);

    if ($assigneeUserId < 1) {
        json_response([
            'success' => false,
            'message' => '처리 담당자를 선택해주세요.',
        ], 422);
    }

    $assigneeStmt = $pdo->prepare(
        'SELECT id
         FROM users
         WHERE id = ?
           AND organization_id = ?'
    );
    $assigneeStmt->execute([$assigneeUserId, 900]);

    if ($assigneeStmt->fetch() === false) {
        json_response([
            'success' => false,
            'message' => '처리 담당자는 organization_id가 900인 사용자 중에서 선택해야 합니다.',
        ], 422);
    }

    $fromStatus = transition_from_status($defect['status'] ?? null) ?? 'received';
    $toStatus = $fromStatus === 'received' ? 'assigned' : $fromStatus;
    $updateStmt = $pdo->prepare(
        'UPDATE defects
         SET assignee_user_id = ?,
             assigned_by_user_id = ?,
             assigned_at = CURRENT_TIMESTAMP,
             status = ?,
             updated_at = CURRENT_TIMESTAMP
         WHERE id = ?'
    );
    $updateStmt->execute([$assigneeUserId, (int)$user['id'], $toStatus, (int)$defect['id']]);

    insert_defect_action($pdo, (int)$defect['id'], (int)$user['id'], 'assigned', $fromStatus, $toStatus, '처리 담당자가 지정되었습니다.');

    if ($toStatus !== $fromStatus) {
        insert_defect_status_history($pdo, (int)$defect['id'], (int)$user['id'], $fromStatus, $toStatus);
    }
}

function complete_action(PDO $pdo, array $user, array $defect, array $input): void
{
    $isAssignee = (int)($defect['assignee_user_id'] ?? 0) === (int)$user['id'];

    if (!$isAssignee) {
        json_response([
            'success' => false,
            'message' => '조치완료는 지정된 처리 담당자만 할 수 있습니다.',
        ], 403);
    }

    if (!in_array((string)$defect['status'], ['assigned', 'action_completed', 'tester_confirmation_pending'], true)) {
        json_response([
            'success' => false,
            'message' => '담당자 지정 후 조치완료할 수 있습니다.',
        ], 422);
    }

    $memo = trim((string)($input['action_memo'] ?? ''));

    if ($memo === '') {
        json_response([
            'success' => false,
            'message' => '조치 내용을 입력해주세요.',
        ], 422);
    }

    $fromStatus = transition_from_status($defect['status'] ?? null) ?? 'assigned';
    $toStatus = 'tester_confirmation_pending';
    $updateStmt = $pdo->prepare(
        'UPDATE defects
         SET status = ?,
             action_memo = ?,
             action_completed_by_user_id = ?,
             action_completed_at = CURRENT_TIMESTAMP,
             updated_at = CURRENT_TIMESTAMP
         WHERE id = ?'
    );
    $updateStmt->execute([$toStatus, $memo, (int)$user['id'], (int)$defect['id']]);

    $actionId = insert_defect_action($pdo, (int)$defect['id'], (int)$user['id'], 'action_completed', $fromStatus, $toStatus, $memo);
    insert_defect_action_images($pdo, [
        'action_id' => $actionId,
        'defect_id' => (int)$defect['id'],
        'user_id' => (int)$user['id'],
        'source_type' => ((string)($input['source_type'] ?? 'file')) === 'clipboard' ? 'clipboard' : 'file',
    ]);

    if ($toStatus !== $fromStatus) {
        insert_defect_status_history($pdo, (int)$defect['id'], (int)$user['id'], $fromStatus, $toStatus);
    }
}

function verify_defect(PDO $pdo, array $user, array $defect): void
{
    $isReporter = (int)$defect['reporter_user_id'] === (int)$user['id'];

    if (!$isReporter) {
        json_response([
            'success' => false,
            'message' => '확인완료는 결함 접수자만 할 수 있습니다.',
        ], 403);
    }

    $canVerify =
        in_array((string)$defect['status'], ['action_completed', 'tester_confirmation_pending'], true)
        || ($defect['action_completed_at'] ?? null) !== null;

    if (!$canVerify) {
        json_response([
            'success' => false,
            'message' => '조치완료 후 확인완료할 수 있습니다.',
        ], 422);
    }

    $fromStatus = transition_from_status($defect['status'] ?? null) ?? 'tester_confirmation_pending';
    $toStatus = 'verification_completed';
    $updateStmt = $pdo->prepare(
        'UPDATE defects
         SET status = ?,
             verified_by_user_id = ?,
             verified_at = CURRENT_TIMESTAMP,
             updated_at = CURRENT_TIMESTAMP
         WHERE id = ?'
    );
    $updateStmt->execute([$toStatus, (int)$user['id'], (int)$defect['id']]);

    insert_defect_action($pdo, (int)$defect['id'], (int)$user['id'], 'verification_completed', $fromStatus, $toStatus, '확인완료 처리되었습니다.');
    insert_defect_status_history($pdo, (int)$defect['id'], (int)$user['id'], $fromStatus, $toStatus);
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
): int {
    $stmt = $pdo->prepare(
        'INSERT INTO defect_actions (
            defect_id, user_id, action_type, from_status, to_status, comment
         ) VALUES (?, ?, ?, ?, ?, ?)'
    );
    $stmt->execute([$defectId, $userId, $actionType, $fromStatus, $toStatus, $comment]);

    return (int)$pdo->lastInsertId();
}

function insert_defect_action_images(PDO $pdo, array $context): void
{
    $files = normalize_uploaded_files($_FILES['action_images'] ?? null);

    if (count($files) === 0) {
        return;
    }

    if (!defect_action_images_table_exists($pdo)) {
        throw new RuntimeException('조치결과 이미지 테이블이 아직 생성되지 않았습니다. api/install.php를 실행해 DB 마이그레이션을 적용해 주세요.');
    }

    foreach ($files as $file) {
        if (($file['error'] ?? UPLOAD_ERR_NO_FILE) === UPLOAD_ERR_NO_FILE) {
            continue;
        }

        if (($file['error'] ?? UPLOAD_ERR_OK) !== UPLOAD_ERR_OK) {
            throw new RuntimeException('이미지 업로드에 실패했습니다.');
        }

        $tmpName = (string)$file['tmp_name'];
        $mimeType = mime_content_type($tmpName) ?: '';
        $allowedMimeTypes = ['image/png', 'image/jpeg', 'image/webp', 'image/gif'];

        if (!in_array($mimeType, $allowedMimeTypes, true)) {
            throw new RuntimeException('이미지 파일만 첨부할 수 있습니다.');
        }

        $imageSize = getimagesize($tmpName);
        $extension = match ($mimeType) {
            'image/png' => 'png',
            'image/jpeg' => 'jpg',
            'image/webp' => 'webp',
            'image/gif' => 'gif',
            default => 'bin',
        };
        $uploadRoot = __DIR__ . '/uploads/defect-action-images';
        $relativeDir = date('Y/m');
        $targetDir = $uploadRoot . '/' . $relativeDir;

        if (!is_dir($targetDir) && !mkdir($targetDir, 0775, true) && !is_dir($targetDir)) {
            throw new RuntimeException('업로드 폴더를 만들 수 없습니다.');
        }

        $storedFilename = bin2hex(random_bytes(16)) . '.' . $extension;
        $targetPath = $targetDir . '/' . $storedFilename;

        if (!move_uploaded_file($tmpName, $targetPath)) {
            throw new RuntimeException('업로드 이미지를 저장하지 못했습니다.');
        }

        $stmt = $pdo->prepare(
            'INSERT INTO defect_action_images (
                defect_action_id, defect_id, user_id, source_type,
                original_filename, stored_filename, file_path, mime_type,
                file_size_bytes, image_width, image_height
             ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
        );
        $stmt->execute([
            $context['action_id'],
            $context['defect_id'],
            $context['user_id'],
            $context['source_type'],
            (string)($file['name'] ?? '') === '' ? null : (string)$file['name'],
            $storedFilename,
            'uploads/defect-action-images/' . $relativeDir . '/' . $storedFilename,
            $mimeType,
            (int)($file['size'] ?? 0),
            is_array($imageSize) ? (int)$imageSize[0] : null,
            is_array($imageSize) ? (int)$imageSize[1] : null,
        ]);
    }
}

function defect_action_images_table_exists(PDO $pdo): bool
{
    $stmt = $pdo->query("SHOW TABLES LIKE 'defect_action_images'");

    return $stmt !== false && $stmt->fetchColumn() !== false;
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
