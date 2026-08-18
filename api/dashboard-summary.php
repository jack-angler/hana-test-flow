<?php

declare(strict_types=1);

require_once __DIR__ . '/bootstrap.php';

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'GET') {
    json_response([
        'success' => false,
        'message' => 'GET method is required.',
    ], 405);
}

$user = require_user();

if (($user['role'] ?? '') !== 'admin') {
    json_response([
        'success' => false,
        'message' => '관리자만 대시보드 요약을 볼 수 있습니다.',
    ], 403);
}

try {
    $pdo = db();

    json_response([
        'success' => true,
        'summary' => [
            'overview' => dashboard_overview($pdo),
            'result_counts' => dashboard_result_counts($pdo),
            'defect_counts' => dashboard_defect_counts($pdo),
            'organization_progress' => dashboard_organization_progress($pdo),
            'scenario_quality' => dashboard_scenario_quality($pdo),
            'run_progress' => dashboard_run_progress($pdo),
            'defect_action_progress' => dashboard_defect_action_progress($pdo),
        ],
    ]);
} catch (Throwable $exception) {
    json_response([
        'success' => false,
        'message' => '대시보드 요약을 불러오지 못했습니다.',
        'error' => $exception->getMessage(),
    ], 500);
}

function dashboard_overview(PDO $pdo): array
{
    $resultFilter = result_aggregation_filter('tcr');
    $caseCount = (int)$pdo->query(
        'SELECT COUNT(*)
         FROM test_cases
         WHERE is_current = 1
           AND is_deleted = 0'
    )->fetchColumn();

    $testedCaseCount = (int)$pdo->query(
        'SELECT COUNT(DISTINCT tcr.test_case_id)
         FROM test_case_results tcr
         WHERE tcr.result_status <> "not_tested"' . $resultFilter
    )->fetchColumn();

    $resultCount = (int)$pdo->query(
        'SELECT COUNT(*)
         FROM test_case_results tcr
         WHERE tcr.result_status <> "not_tested"' . $resultFilter
    )->fetchColumn();

    $passedCount = (int)$pdo->query(
        'SELECT COUNT(*)
         FROM test_case_results tcr
         WHERE tcr.result_status = "passed"' . $resultFilter
    )->fetchColumn();

    $defectCount = (int)$pdo->query('SELECT COUNT(*) FROM defects')->fetchColumn();
    $verifiedDefectCount = (int)$pdo->query(
        'SELECT COUNT(*)
         FROM defects
         WHERE status = "verification_completed"'
    )->fetchColumn();

    return [
        'case_count' => $caseCount,
        'tested_case_count' => $testedCaseCount,
        'case_progress_percent' => percent($testedCaseCount, $caseCount),
        'result_count' => $resultCount,
        'passed_count' => $passedCount,
        'success_percent' => percent($passedCount, $resultCount),
        'defect_count' => $defectCount,
        'verified_defect_count' => $verifiedDefectCount,
        'defect_process_percent' => percent($verifiedDefectCount, $defectCount),
    ];
}

function dashboard_result_counts(PDO $pdo): array
{
    $resultFilter = result_aggregation_filter('tcr');
    $stmt = $pdo->query(
        'SELECT tcr.result_status, COUNT(*) AS count
         FROM test_case_results tcr
         WHERE tcr.result_status <> "not_tested"' . $resultFilter . '
         GROUP BY tcr.result_status'
    );

    return keyed_counts($stmt->fetchAll(), 'result_status');
}

function dashboard_defect_counts(PDO $pdo): array
{
    $statusSql = dashboard_defect_status_sql('d');
    $stmt = $pdo->query(
        'SELECT
            ' . $statusSql . ' AS status,
            COUNT(*) AS count
         FROM defects d
         GROUP BY ' . $statusSql
    );

    return keyed_counts($stmt->fetchAll(), 'status');
}

function dashboard_organization_progress(PDO $pdo): array
{
    $resultFilter = result_aggregation_filter('tcr');
    $stmt = $pdo->query(
        'SELECT
            o.id,
            o.name,
            COUNT(DISTINCT tcr.id) AS result_count,
            COUNT(DISTINCT CASE WHEN tcr.result_status = "passed" THEN tcr.id ELSE NULL END) AS passed_count,
            COUNT(DISTINCT d.id) AS defect_count,
            COUNT(DISTINCT CASE WHEN d.status = "verification_completed" THEN d.id ELSE NULL END) AS verified_defect_count
         FROM organizations o
         LEFT JOIN test_case_results tcr
            ON tcr.organization_id = o.id
           AND tcr.result_status <> "not_tested"' . $resultFilter . '
         LEFT JOIN defects d
            ON d.reporter_organization_id = o.id
         GROUP BY o.id, o.name
         HAVING result_count > 0 OR defect_count > 0
         ORDER BY result_count DESC, defect_count DESC, o.id ASC'
    );

    return array_map(
        static function (array $row): array {
            $resultCount = (int)$row['result_count'];
            $defectCount = (int)$row['defect_count'];
            $passedCount = (int)$row['passed_count'];
            $verifiedDefectCount = (int)$row['verified_defect_count'];

            return [
                'id' => (int)$row['id'],
                'name' => $row['name'],
                'result_count' => $resultCount,
                'passed_count' => $passedCount,
                'success_percent' => percent($passedCount, $resultCount),
                'defect_count' => $defectCount,
                'verified_defect_count' => $verifiedDefectCount,
                'defect_process_percent' => percent($verifiedDefectCount, $defectCount),
            ];
        },
        $stmt->fetchAll()
    );
}

function dashboard_scenario_quality(PDO $pdo): array
{
    $resultFilter = result_aggregation_filter('tcr');
    $stmt = $pdo->query(
        'SELECT
            ts.id,
            tr.name AS test_run_name,
            ts.name,
            COUNT(DISTINCT tc.id) AS case_count,
            COUNT(DISTINCT tcr.id) AS result_count,
            COUNT(DISTINCT CASE WHEN tcr.result_status = "passed" THEN tcr.id ELSE NULL END) AS passed_count,
            COUNT(DISTINCT d.id) AS defect_count
         FROM test_scenarios ts
         INNER JOIN test_runs tr ON tr.id = ts.test_run_id
         LEFT JOIN test_cases tc
            ON tc.test_scenario_id = ts.id
           AND tc.is_current = 1
           AND tc.is_deleted = 0
         LEFT JOIN test_case_results tcr
            ON tcr.test_case_id = tc.id
           AND tcr.result_status <> "not_tested"' . $resultFilter . '
         LEFT JOIN defects d
            ON d.test_case_id = tc.id
         GROUP BY ts.id, tr.id, tr.name, ts.name, ts.sort_order
         ORDER BY tr.updated_at DESC, tr.id DESC, ts.sort_order ASC, ts.id ASC'
    );

    return array_map(
        static function (array $row): array {
            $resultCount = (int)$row['result_count'];
            $passedCount = (int)$row['passed_count'];

            return [
                'id' => (int)$row['id'],
                'test_run_name' => $row['test_run_name'],
                'name' => $row['name'],
                'case_count' => (int)$row['case_count'],
                'result_count' => $resultCount,
                'passed_count' => $passedCount,
                'success_percent' => percent($passedCount, $resultCount),
                'defect_count' => (int)$row['defect_count'],
            ];
        },
        $stmt->fetchAll()
    );
}

function dashboard_run_progress(PDO $pdo): array
{
    $runs = [];

    foreach (dashboard_run_progress_rows($pdo) as $row) {
        $runId = (int)$row['run_id'];
        $caseCount = (int)$row['case_count'];
        $allCompletedCaseCount = (int)$row['all_completed_case_count'];
        $newCarCompletedCaseCount = (int)$row['new_car_completed_case_count'];
        $branchCompletedCaseCount = (int)$row['branch_completed_case_count'];

        if (!isset($runs[$runId])) {
            $runs[$runId] = [
                'id' => $runId,
                'name' => $row['run_name'],
                'total' => empty_run_progress_total(),
            ];
        }

        $scenarioCompletedCount = $caseCount > 0 && $allCompletedCaseCount >= $caseCount ? 1 : 0;

        $runs[$runId]['total']['scenario_count']++;
        $runs[$runId]['total']['completed_scenario_count'] += $scenarioCompletedCount;
        $runs[$runId]['total']['incomplete_scenario_count'] += 1 - $scenarioCompletedCount;
        $runs[$runId]['total']['case_count'] += $caseCount;
        $runs[$runId]['total']['all_completed_case_count'] += $allCompletedCaseCount;
        $runs[$runId]['total']['new_car_completed_case_count'] += $newCarCompletedCaseCount;
        $runs[$runId]['total']['branch_completed_case_count'] += $branchCompletedCaseCount;
    }

    return [
        'runs' => array_values(array_map(
            static fn (array $run): array => finalize_run_progress($run),
            $runs
        )),
        'total' => finalize_run_progress([
            'id' => 0,
            'name' => '계',
            'total' => array_reduce(
                $runs,
                static function (array $carry, array $run): array {
                    foreach ($carry as $key => $value) {
                        if (str_ends_with($key, '_percent')) {
                            continue;
                        }

                        $carry[$key] = $value + (int)($run['total'][$key] ?? 0);
                    }

                    return $carry;
                },
                empty_run_progress_total()
            ),
        ])['total'],
    ];
}

function dashboard_run_progress_rows(PDO $pdo): array
{
    $resultFilter = result_aggregation_filter('tcr');
    $stmt = $pdo->query(
        "SELECT
            tr.id AS run_id,
            tr.name AS run_name,
            ts.id AS scenario_id,
            ts.name AS scenario_name,
            COUNT(DISTINCT tc.id) AS case_count,
            COUNT(DISTINCT CASE
                WHEN tcr.id IS NOT NULL
                 AND tcr.organization_id <> 900
                THEN tc.id
                ELSE NULL
            END) AS all_completed_case_count,
            COUNT(DISTINCT CASE
                WHEN tcr.id IS NOT NULL
                 AND tcr.organization_id = 100
                THEN tc.id
                ELSE NULL
            END) AS new_car_completed_case_count,
            COUNT(DISTINCT CASE
                WHEN tcr.id IS NOT NULL
                 AND tcr.organization_id NOT IN (100, 900)
                THEN tc.id
                ELSE NULL
            END) AS branch_completed_case_count
         FROM test_runs tr
         LEFT JOIN test_scenarios ts
            ON ts.test_run_id = tr.id
         LEFT JOIN test_cases tc
            ON tc.test_scenario_id = ts.id
           AND tc.is_current = 1
           AND tc.is_deleted = 0
         LEFT JOIN test_case_results tcr
            ON tcr.test_case_id = tc.id
           AND tcr.result_status <> 'not_tested'" . $resultFilter . "
         WHERE tr.is_active = 1
           AND ts.id IS NOT NULL
         GROUP BY tr.id, tr.name, tr.updated_at, ts.id, ts.name, ts.sort_order
         ORDER BY tr.updated_at DESC, tr.id DESC, ts.sort_order ASC, ts.id ASC"
    );

    return $stmt->fetchAll();
}

function empty_run_progress_total(): array
{
    return [
        'scenario_count' => 0,
        'completed_scenario_count' => 0,
        'incomplete_scenario_count' => 0,
        'scenario_percent' => 0,
        'case_count' => 0,
        'all_completed_case_count' => 0,
        'all_case_percent' => 0,
        'new_car_completed_case_count' => 0,
        'new_car_case_percent' => 0,
        'branch_completed_case_count' => 0,
        'branch_case_percent' => 0,
    ];
}

function finalize_run_progress(array $run): array
{
    $run['total']['scenario_percent'] = percent(
        (int)$run['total']['completed_scenario_count'],
        (int)$run['total']['scenario_count'],
    );
    $run['total']['all_case_percent'] = percent(
        (int)$run['total']['all_completed_case_count'],
        (int)$run['total']['case_count'],
    );
    $run['total']['new_car_case_percent'] = percent(
        (int)$run['total']['new_car_completed_case_count'],
        (int)$run['total']['case_count'],
    );
    $run['total']['branch_case_percent'] = percent(
        (int)$run['total']['branch_completed_case_count'],
        (int)$run['total']['case_count'],
    );

    return $run;
}

function dashboard_defect_action_progress(PDO $pdo): array
{
    $runs = [];

    foreach (dashboard_defect_action_progress_rows($pdo) as $row) {
        $run = [
            'id' => (int)$row['run_id'],
            'name' => $row['run_name'],
            'failed_count' => (int)$row['failed_count'],
            'improvement_count' => (int)$row['improvement_count'],
            'non_defect_count' => (int)$row['non_defect_count'],
            'total_count' => (int)$row['total_count'],
            'not_started_count' => (int)$row['not_started_count'],
            'in_progress_count' => (int)$row['in_progress_count'],
            'action_completed_count' => (int)$row['action_completed_count'],
            'action_percent' => percent((int)$row['action_completed_count'], (int)$row['total_count']),
            'verification_target_count' => (int)$row['action_completed_count'],
            'verified_count' => (int)$row['verified_count'],
            'verification_percent' => percent((int)$row['verified_count'], (int)$row['action_completed_count']),
        ];

        $runs[] = $run;
    }

    return [
        'runs' => $runs,
        'total' => finalize_defect_action_total(array_reduce(
            $runs,
            static function (array $carry, array $run): array {
                foreach ($carry as $key => $value) {
                    if (str_ends_with($key, '_percent')) {
                        continue;
                    }

                    $carry[$key] = $value + (int)($run[$key] ?? 0);
                }

                return $carry;
            },
            empty_defect_action_total()
        )),
    ];
}

function dashboard_defect_action_progress_rows(PDO $pdo): array
{
    $statusSql = dashboard_defect_status_sql('d');
    $stmt = $pdo->query(
        'SELECT
            COALESCE(tr.id, 0) AS run_id,
            COALESCE(tr.name, "기타") AS run_name,
            COUNT(DISTINCT CASE WHEN d.result_status = "failed" THEN d.id ELSE NULL END) AS failed_count,
            COUNT(DISTINCT CASE WHEN d.result_status = "improvement" THEN d.id ELSE NULL END) AS improvement_count,
            COUNT(DISTINCT CASE WHEN d.result_status = "not_available" THEN d.id ELSE NULL END) AS non_defect_count,
            COUNT(DISTINCT d.id) AS total_count,
            COUNT(DISTINCT CASE WHEN ' . $statusSql . ' = "received" THEN d.id ELSE NULL END) AS not_started_count,
            COUNT(DISTINCT CASE WHEN ' . $statusSql . ' = "assigned" THEN d.id ELSE NULL END) AS in_progress_count,
            COUNT(DISTINCT CASE WHEN ' . $statusSql . ' IN ("tester_confirmation_pending", "verification_completed") THEN d.id ELSE NULL END) AS action_completed_count,
            COUNT(DISTINCT CASE WHEN ' . $statusSql . ' = "verification_completed" THEN d.id ELSE NULL END) AS verified_count
         FROM defects d
         LEFT JOIN test_cases tc
            ON tc.id = d.test_case_id
           AND tc.is_current = 1
           AND tc.is_deleted = 0
         LEFT JOIN test_scenarios ts ON ts.id = tc.test_scenario_id
         LEFT JOIN test_runs tr ON tr.id = ts.test_run_id AND tr.is_active = 1
         GROUP BY COALESCE(tr.id, 0), COALESCE(tr.name, "기타"), COALESCE(tr.updated_at, "1970-01-01")
         ORDER BY COALESCE(tr.updated_at, "1970-01-01") DESC, COALESCE(tr.id, 0) DESC'
    );

    return $stmt->fetchAll();
}

function empty_defect_action_total(): array
{
    return [
        'failed_count' => 0,
        'improvement_count' => 0,
        'non_defect_count' => 0,
        'total_count' => 0,
        'not_started_count' => 0,
        'in_progress_count' => 0,
        'action_completed_count' => 0,
        'action_percent' => 0,
        'verification_target_count' => 0,
        'verified_count' => 0,
        'verification_percent' => 0,
    ];
}

function finalize_defect_action_total(array $total): array
{
    $total['action_percent'] = percent(
        (int)$total['action_completed_count'],
        (int)$total['total_count'],
    );
    $total['verification_percent'] = percent(
        (int)$total['verified_count'],
        (int)$total['action_completed_count'],
    );

    return $total;
}

function keyed_counts(array $rows, string $key): array
{
    $counts = [];

    foreach ($rows as $row) {
        $counts[(string)$row[$key]] = (int)$row['count'];
    }

    return $counts;
}

function dashboard_defect_status_sql(string $alias): string
{
    return 'CASE
        WHEN ' . $alias . '.status = "verification_completed"
            THEN "verification_completed"
        WHEN ' . $alias . '.status IN ("action_completed", "tester_confirmation_pending")
            THEN "tester_confirmation_pending"
        WHEN ' . $alias . '.verified_at IS NOT NULL
            THEN "verification_completed"
        WHEN ' . $alias . '.action_completed_at IS NOT NULL
            THEN "tester_confirmation_pending"
        WHEN ' . $alias . '.assignee_user_id IS NOT NULL
            THEN "assigned"
        WHEN ' . $alias . '.status = "assigned"
            THEN "assigned"
        WHEN ' . $alias . '.status = "received"
            THEN "received"
        ELSE "received"
    END';
}

function result_aggregation_filter(string $alias): string
{
    $excludedLoginIds = result_aggregation_excluded_login_ids();

    if ($excludedLoginIds === []) {
        return '';
    }

    $quotedLoginIds = array_map(
        static fn (string $loginId): string => "'" . str_replace("'", "''", $loginId) . "'",
        $excludedLoginIds
    );

    return ' AND NOT EXISTS (
            SELECT 1
            FROM users result_user
            WHERE result_user.id = ' . $alias . '.user_id
              AND result_user.login_id IN (' . implode(', ', $quotedLoginIds) . ')
        )';
}

function percent(int $value, int $total): int
{
    if ($total < 1) {
        return 0;
    }

    return min(100, max(0, (int)round(($value / $total) * 100)));
}

