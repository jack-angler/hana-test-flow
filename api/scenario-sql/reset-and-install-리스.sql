START TRANSACTION;

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @test_run_name = '리스(운용, 금융, 중고차, 시승차)';

CREATE TEMPORARY TABLE IF NOT EXISTS tmp_reset_test_runs (
    id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id)
) ENGINE=MEMORY;

CREATE TEMPORARY TABLE IF NOT EXISTS tmp_reset_test_scenarios (
    id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id)
) ENGINE=MEMORY;

CREATE TEMPORARY TABLE IF NOT EXISTS tmp_reset_test_cases (
    id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id)
) ENGINE=MEMORY;

CREATE TEMPORARY TABLE IF NOT EXISTS tmp_reset_test_results (
    id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id)
) ENGINE=MEMORY;

CREATE TEMPORARY TABLE IF NOT EXISTS tmp_reset_defects (
    id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id)
) ENGINE=MEMORY;

TRUNCATE TABLE tmp_reset_test_runs;
TRUNCATE TABLE tmp_reset_test_scenarios;
TRUNCATE TABLE tmp_reset_test_cases;
TRUNCATE TABLE tmp_reset_test_results;
TRUNCATE TABLE tmp_reset_defects;

INSERT IGNORE INTO tmp_reset_test_runs (id)
SELECT id
FROM test_runs
WHERE name = @test_run_name;

INSERT IGNORE INTO tmp_reset_test_scenarios (id)
SELECT ts.id
FROM test_scenarios ts
INNER JOIN tmp_reset_test_runs tr ON tr.id = ts.test_run_id;

INSERT IGNORE INTO tmp_reset_test_cases (id)
SELECT tc.id
FROM test_cases tc
INNER JOIN tmp_reset_test_scenarios ts ON ts.id = tc.test_scenario_id;

INSERT IGNORE INTO tmp_reset_test_results (id)
SELECT tcr.id
FROM test_case_results tcr
INNER JOIN tmp_reset_test_cases tc ON tc.id = tcr.test_case_id;

INSERT IGNORE INTO tmp_reset_defects (id)
SELECT d.id
FROM defects d
LEFT JOIN tmp_reset_test_results tr ON tr.id = d.test_case_result_id
LEFT JOIN tmp_reset_test_cases tc ON tc.id = d.test_case_id
WHERE tr.id IS NOT NULL OR tc.id IS NOT NULL;

DELETE dai
FROM defect_action_images dai
INNER JOIN defect_actions da ON da.id = dai.defect_action_id
INNER JOIN tmp_reset_defects d ON d.id = da.defect_id;

DELETE da
FROM defect_actions da
INNER JOIN tmp_reset_defects d ON d.id = da.defect_id;

DELETE dsh
FROM defect_status_histories dsh
INNER JOIN tmp_reset_defects d ON d.id = dsh.defect_id;

DELETE d
FROM defects d
INNER JOIN tmp_reset_defects td ON td.id = d.id;

DELETE tcre
FROM test_case_result_evidences tcre
INNER JOIN tmp_reset_test_cases tc ON tc.id = tcre.test_case_id;

DELETE tcrh
FROM test_case_result_histories tcrh
INNER JOIN tmp_reset_test_cases tc ON tc.id = tcrh.test_case_id;

DELETE tcr
FROM test_case_results tcr
INNER JOIN tmp_reset_test_cases tc ON tc.id = tcr.test_case_id;

DELETE tc
FROM test_cases tc
INNER JOIN tmp_reset_test_scenarios ts ON ts.id = tc.test_scenario_id;

DELETE ts
FROM test_scenarios ts
INNER JOIN tmp_reset_test_runs tr ON tr.id = ts.test_run_id;

DELETE tr
FROM test_runs tr
INNER JOIN tmp_reset_test_runs t ON t.id = tr.id;

DROP TEMPORARY TABLE IF EXISTS tmp_reset_defects;
DROP TEMPORARY TABLE IF EXISTS tmp_reset_test_results;
DROP TEMPORARY TABLE IF EXISTS tmp_reset_test_cases;
DROP TEMPORARY TABLE IF EXISTS tmp_reset_test_scenarios;
DROP TEMPORARY TABLE IF EXISTS tmp_reset_test_runs;

-- Reinstall lease scenarios.
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @test_run_name = '리스(운용, 금융, 중고차, 시승차)';

INSERT INTO test_runs (name)
VALUES (@test_run_name)
ON DUPLICATE KEY UPDATE
    updated_at = CURRENT_TIMESTAMP;

SELECT id INTO @test_run_id FROM test_runs WHERE name = @test_run_name;

CREATE TEMPORARY TABLE IF NOT EXISTS tmp_import_test_cases (
    scenario_code VARCHAR(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    case_code VARCHAR(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    PRIMARY KEY (scenario_code, case_code)
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

TRUNCATE TABLE tmp_import_test_cases;

SET @scenario_code = 'SN-NW-500';
SET @scenario_name = '신차리스(운용,금융-국산차)';
INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)
VALUES (@test_run_id, @scenario_code, @scenario_name, 1)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    sort_order = VALUES(sort_order),
    updated_at = CURRENT_TIMESTAMP;

SET @scenario_code = 'SN-NW-600';
SET @scenario_name = '신차리스(운용,금융-수입차)';
INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)
VALUES (@test_run_id, @scenario_code, @scenario_name, 2)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    sort_order = VALUES(sort_order),
    updated_at = CURRENT_TIMESTAMP;

SET @scenario_code = 'SN-UL-500';
SET @scenario_name = '중고리스(일반중고)';
INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)
VALUES (@test_run_id, @scenario_code, @scenario_name, 3)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    sort_order = VALUES(sort_order),
    updated_at = CURRENT_TIMESTAMP;

SET @scenario_code = 'SN-UL-600';
SET @scenario_name = '중고리스(인증중고)';
INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)
VALUES (@test_run_id, @scenario_code, @scenario_name, 4)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    sort_order = VALUES(sort_order),
    updated_at = CURRENT_TIMESTAMP;

SET @scenario_code = 'SN-DM-500';
SET @scenario_name = '리스(시승차-수입차)';
INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)
VALUES (@test_run_id, @scenario_code, @scenario_name, 5)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    sort_order = VALUES(sort_order),
    updated_at = CURRENT_TIMESTAMP;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-500';
SET @content_hash = '8946ee1b8f658cc0b56aa2c4e412045b228418fd006ff9664111205f12ae28d7';
SET @sort_order = 1;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_가견적',
    '-',
    '로그인',
    '하나원큐오토>신차리스 메뉴명 선택하여 새 견적을 진행한다',
    '견적 진행시, 
차종 : 국산차 선택
고객 구분 : 개인, 개인사업자, 법인 사업자 중 선택',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-501';
SET @content_hash = '97067790273feae1f17d87658f09d1eab8f05721a85304a9c061f5849140d287';
SET @sort_order = 2;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_가견적',
    '-',
    '로그인',
    '견적 내기 완료후, 견적 확정 버튼 클릭',
    '[견적 확정 팝업] 화면이 표시된다.
상품선택에서 다건의 상품을 중요버튼을 체크해둔 상태라면 견적 선택 영역에서 
견적 확정할 견적을 체크 후 [견적 확정] 버튼을 클릭한다.

안내 알럿이 표시된다. 
견적이 견적 탭으로 이동된다. (현황조회에 있던 정보가 가견적 > 견적 탭으로 이동)',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-502';
SET @content_hash = '68ff93cf4f125ccfffbf5b372e91e3e5875ed4fb0fceeb2e2ee502d28c0e25a5';
SET @sort_order = 3;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의전',
    '현황조회에 견적 탭 클릭, 진행한 정보가 견적 탭에 있는 것을 확인한다.',
    '견적 확정 - 견적의 초기 상태값은 ''동의전''이다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-503';
SET @content_hash = '77230924987e4a0461ef76a93089ac175a44131b29a7ebdad91d8ec62101f4c7';
SET @sort_order = 4;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의전',
    '견적 동의전 케이스 상세조회 버튼 클릭',
    '[상세조회] 버튼 클릭하여, 
해당 정보 확인과 하단에 재견적, 견적서 발송, 견적서 보기, 신용정보조회 동의 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-504';
SET @content_hash = 'ff00ff40a9250de55114b03b1ddac4de862524559a6f287dffd29aa4f34bf8b7';
SET @sort_order = 5;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의전',
    '신용정보조회 동의 클릭',
    '신용조회재요청 으로 버튼명 변경',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-505';
SET @content_hash = 'bae38b403ca7790669b6b60d037d6266cf5f49fe33780a1804d9b6997318b38f';
SET @sort_order = 6;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의완료, 
고객구분 : 개인, 개인사업자,법인',
    '견적 동의완료 케이스 - 신용조회 완료 상태일 경우',
    '[상세조회] 버튼 클릭하여, 
해당 정보 확인과 하단에 재견적, 견적서 발송, 견적서 보기, 심사신청 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-506';
SET @content_hash = 'e0f2da68538d5461d8e72b17e4af94ff37e6dad225072400e77f386a9e3e2aad';
SET @sort_order = 7;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의완료, 
고객구분 : 개인, 개인사업자,법인',
    '[심사신청] 버튼을 클릭한다.',
    '캐피탈 심사신청'' 팝업이 출력한다.
팝업 내 심사 대상을 체크하여 심사 신청을 한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-507';
SET @content_hash = 'fc049051c8137cd28692332c6eb3d161cec3a0e95664fa15151c53613dcf70b7';
SET @sort_order = 8;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '심사 상태 값 : 자동 승인, 
승인 된 상태 ''승인'' 노출',
    '재견적 / 견적서 발송 / 견적서 보기 / 서류등록 / 품의등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-508';
SET @content_hash = '251f6f61cbb7c0d5dd60f3aca6c6008b7a92a9746ccb10f5296ab67d44e9e3d8';
SET @sort_order = 9;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 상담중',
    '심사 상태 값 : 자동 승인 외 건은 ''상담중'' 노출',
    '재견적 / 견적서 발송 / 견적서 보기 / 서류등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-509';
SET @content_hash = 'efacb2a2817328bdc70e3660aa7de8462d2d366f4ae98a9591a198d7bbbd8587';
SET @sort_order = 10;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 부결',
    '심사 상태 값 : 시스템 거절 건은 ''부결'' 노출',
    '재견적 / 견적서 발송 / 견적서 보기 / 서류등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-510';
SET @content_hash = '710d266d7c20472f0cf54f620e5a4b6ce650b3d5e29c9f4042fc9d220db47930';
SET @sort_order = 11;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[품의등록] 버튼을 클릭한다.',
    '[품의등록] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-511';
SET @content_hash = '32b169b60e6dd3576f6865d27f4e84c936abb553cf84eb8b6ac5f732b6a540db';
SET @sort_order = 12;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인 
개인',
    '계약자 정보 확인',
    '성명, 생년월일, 진행일정, 상품명',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-512';
SET @content_hash = 'c34c05c6b03ba7ee71dc8a8791091b4b9d1093d8ccbde4359a9d1e6b9f5c5830';
SET @sort_order = 13;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인
개인사업자',
    '계약자 정보 확인',
    '회사명,대표자 성함, 대표자 생년월일, 사업자번호',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-513';
SET @content_hash = '39314df6ff63a274bb0fe8771c950175b708fb6ffa54db14182cb83226e99871';
SET @sort_order = 14;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인 
법인사업자',
    '계약자 정보 확인',
    '회사명,대표자 성함, 사업자번호, 법인등록번호, 연대보증인성함, 연대보증인 생년월일',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-514';
SET @content_hash = 'd155f99aa19cbf024825ae8dcc365dec736abf87808689c97a74d8784e273a04';
SET @sort_order = 15;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인 , 
신차리스, 국산차',
    '노출 목록 확인',
    '판매점 정보(브랜드, 판매대리점, 판매사원)
영업사원정보 (영업사원)
계약 송금 계좌 (계좌번호)
서류등록',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-515';
SET @content_hash = 'b0d8b11c9172470ab752dfb4907c0d0669a504e30af1835545f4763bf6590389';
SET @sort_order = 16;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '판매대리점 [검색] 버튼 클릭,    [판매점 조회 팝업] 화면에 검색 조건을 선택하고 검색어를 입력 후 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 결과가 조회된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-516';
SET @content_hash = '74ca5c4118aadc77f2749b3f2d777a9f5bcfa7d55ceef7d52eaf522eee0efdb0';
SET @sort_order = 17;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '판매대리점 [검색] 버튼 클릭,   [판매점 조회 팝업] 화면에 검색 조건을 선택하고 검색어를 입력 후 [조회] 버튼을 클릭한다.',
    '검색 결과가 없는 경우, 조회결과 영역에 ''검색 결과가 없습니다'' 문구가 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-517';
SET @content_hash = '0f075c7f619f91527740db281aaa7bb75703acf8919e832f5526080b3ccfc0c8';
SET @sort_order = 18;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[판매점 조회 팝업] 화면에 검색 결과를 클릭한다.',
    '[판매점 조회 팝업] 화면이 닫히며, [품의등록] 화면에서 선택값이 판매대리점 영역에 반영된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-518';
SET @content_hash = 'f7ed87ecb154ad7d89741c19a8acc022a5b5ac323f5adcb89da136af14a5f994';
SET @sort_order = 19;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[품의등록] 화면에서 판매사원 [검색]버튼을 클릭한다.',
    '[판매사원 조회 팝업] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-519';
SET @content_hash = 'f176c72cb71df8846d0a8648dce08160b8c848e08dc9e902523656fd0307b7e1';
SET @sort_order = 20;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '조회 결과가 있을 경우 → [판매사원 조회 팝업] 화면에서 조회조건 조회 값을 입력하여 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 결과가 조회된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-520';
SET @content_hash = '8b26c097eb94f140fe4bb66e801659fffa04b08f276ac31caa7bdeebedadb622';
SET @sort_order = 21;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '조회 결과가 없을 경우 → [판매사원 조회 팝업] 화면에서 조회조건 조회 값을 입력하여 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 ''검색 결과가 없습니다'' 문구가 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-521';
SET @content_hash = '92ddfe9e01c632b76ab4f4c63e7d0e883454457e0daa810170a0f0766153a5ff';
SET @sort_order = 22;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[판매사원 조회 팝업] 화면에 검색 결과를 클릭한다.',
    '[판매사원 조회 팝업] 화면이 닫히며, [품의등록] 화면에서 선택값이 판매사원 영역에 반영된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-522';
SET @content_hash = '8199a257a06e8f61f02a4b1da51a828c73021595e9182fd589a5e82a1c5425d6';
SET @sort_order = 23;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[품의등록] 화면에서 은행 영역을 클릭한다.',
    '[은행 선택] 영역이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-523';
SET @content_hash = '7f8368cc40a34f1b11296808d30e0baabfacbd863dbc4fc8ce06f3f7a998a712';
SET @sort_order = 24;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[은행 선택] 화면에서 은행을 선택한다.',
    '[은행 선택] 영역이 닫히면서 차량대금 송금(선택) 은행 정보영역에 선택값이 반영된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-524';
SET @content_hash = '9251800f97eb82fab8b365390c3461e79959329c7816caade0f925035420cf5c';
SET @sort_order = 25;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[품의등록] 화면에서 계좌를 입력하고 [계좌확인] 버튼을 클릭한다.',
    '계좌 검증을 진행 후 계좌의 예금주명 영역에 예금주를 표시한다.
계좌 번호 확인 성공시→성공 얼럿 출력
계좌 번호 확인 실패시→실패 얼럿 출력',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-525';
SET @content_hash = '58a7014f9819051d4ec2ab2040c168d42fb4a35f6de26289743572def9059def';
SET @sort_order = 26;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[품의등록] 화면에서 [서류등록] 버튼을 클릭한다.',
    '[손님서류등록] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-526';
SET @content_hash = '242390c39a61bc75fe714e36ba00ce74df1e879e32b05be0e89424bfb633d671';
SET @sort_order = 27;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[손님서류등록] 팝업에서 [파일을 첨부해주세요 +] 버튼을 클릭한다.',
    '파일 첨부 상세페이지로 이동한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-527';
SET @content_hash = '954fbb71c79a58f9601cc627e11ac897951c6f9994b977697b7fda8e137b401e';
SET @sort_order = 28;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[파일 업로드] 화면에서 이미지/PDF를 첨부한다',
    '첨부된 파일명이 리스트업 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-528';
SET @content_hash = '81fd6232482d6c40843ebb573ff2ae47c9433717a6ab2c44353391a65108dd21';
SET @sort_order = 29;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[파일 업로드] 화면에서 첨부된 파일명 우측 옆 [x]버튼을 클릭한다.',
    '업로드한 파일이 삭제된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-529';
SET @content_hash = 'a6fba17947ec78588a91368237992afcfa3894e9b3162fb2bc168929a2dac612';
SET @sort_order = 30;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[파일 업로드] 화면에서  [등록] 버튼을 클릭한다.',
    '파일업로드에 성공한 경우 -> 성공 얼럿 출력
파일 업로드 실패한 경우 -> 실패 얼럿 출력
해당 팝업이 닫히고 [손님서류등록] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-530';
SET @content_hash = 'ee6f2c2c750560cfd0b4a3f23819803b42c1c8757ea2a7eda73386aa2970cd26';
SET @sort_order = 31;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '첨부한 파일이 있는 경우 → [손님서류등록] 팝업의 [다운로드] 버튼을 클릭한다.',
    '해당 파일을 다운로드하여 확인할 수 있다. (최대 5분 소요)',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-531';
SET @content_hash = '7d4f553e319560395bb145a7302ae164dfaf75bfa6b4889023672efd0a41560e';
SET @sort_order = 32;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[손님서류등록] 팝업의 [저장] 버튼을 클릭한다.',
    '팝업창이 닫힌다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-532';
SET @content_hash = 'b862acbd08cc6e38772aaaa4426837adc091678898d18a64b665a0438ea78f01';
SET @sort_order = 33;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[품의등록] 화면에서 정보 입력 완료 → [품의등록 요청] 버튼을 클릭한다.',
    '[품의등록] 완료시, 완료 얼럿이 출력한다. 
버튼명 - 품의등록 완료 로 변경',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-533';
SET @content_hash = '0d482f11361c20a9ecc2705f28bfc1ebe2fc0b35cea6a2d16933ae8d227a500a';
SET @sort_order = 34;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의 요청',
    '"심사"상태의 품의등록 완료 시 상태이며
하나인 - 품의등록 "저장" 버튼 미실행 단계',
    '견적서 발송 / 견적서 보기 / 서류추가 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-534';
SET @content_hash = '16672a8beeca90f09c1682a44f09d810e893f20c4d828020870737033246a9a9';
SET @sort_order = 35;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의 요청',
    '견적 상태 : 품의요청 → [견적서 발송] 버튼을 클릭한다.',
    '[견적서 발송] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-535';
SET @content_hash = '3461125667d3b5f16812338b0eb080a99868ce2647a591f707e3392eca6b51ba';
SET @sort_order = 36;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의 요청',
    '견적 상태 : 품의요청 → [견적서 보기] 버튼을 클릭한다.',
    '[견적서 보기] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-536';
SET @content_hash = '2271129937d0e21c424ae8890c67e7a404d6d73aa7d4c0e0a659fa40d5d4d9f8';
SET @sort_order = 37;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의 확정',
    '하나인 - 품의등록 "저장" 버튼 실행 하면',
    '견적서 보기 / 서류추가 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-537';
SET @content_hash = '3967e74797dbb0b086cef5424453dbc77ddf454051633187077f7fd2776e4551';
SET @sort_order = 38;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의 확정
법인사업자',
    '하나인 - 품의등록 "저장" 버튼 실행 하면',
    '견적서 보기 / 서류추가 등록 / 연대보증계약서 다운 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-538';
SET @content_hash = '34314a448fab2002b8bbb0833b15a5c90621c849a367306733051ed56dd82360';
SET @sort_order = 39;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의 확정',
    '[견적서 보기] 버튼을 클릭한다.',
    '[견적서 보기] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-539';
SET @content_hash = '4671b624c76988b1da6e7752d660349792458ec6d4583ab2e2f0872c23d59a5e';
SET @sort_order = 40;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황: 품의, 품의확정
법인사업자',
    '연대보증계약서 다운 클릭시',
    '연도보증계약서 pdf 파일이 다운로드 된다.
연도보증계약서 pdf 파일을 열면 정상표기 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-540';
SET @content_hash = '7aa9ffb4ebb542912e62cd0d2d2d84c90ac3e934d44c3204ed69676c3e07eda8';
SET @sort_order = 41;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_인도',
    '-',
    '현황: 인도, 송금완료
운용리스,금융리스, 중고차',
    '하나인 - "선급완료" 처리 시',
    '서류 등록 / 견적서 보기 /차량번호 등록  버튼 유무를 확인한다.
[차량번호 등록] 후 [번호등록 완료]로 변경',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-541';
SET @content_hash = '88039fb5d39f1761ac5ae2b395c3a22e89c1dade8c6e68bd798e3eca22e8f346';
SET @sort_order = 42;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_인도',
    '-',
    '현황: 인도, 송금완료
운용리스,금융리스, 중고차',
    '[차량번호 등록] 버튼을 클릭한다.',
    '[차량번호 등록] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-542';
SET @content_hash = 'c0d5772676c62db25a08f2f8b6c2f25b164fa93d6dee67f59b74aff94d3233f8';
SET @sort_order = 43;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_인도',
    '-',
    '현황: 인도, 송금완료
운용리스,금융리스',
    '[차량번호 등록] 화면에서 차량번호를 입력 후 [확인] 버튼을 클릭한다.',
    '차량번호가 입력된 상태로 비활성화 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-543';
SET @content_hash = 'df9a4a6711861dd879c004719e7644d2a043846422387626f88af7ae45db443a';
SET @sort_order = 44;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_인도',
    '-',
    '현황: 인도, 송금완료
운용리스,금융리스',
    '[차량번호 등록] 화면에서 [확인] 버튼을 클릭한다.',
    '차량번호가 등록된다. [차량번호 등록] 화면이 닫힌다. [차량번호 등록] 버튼이 [번호등록 완료] 버튼으로 바뀐다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-544';
SET @content_hash = 'abff1061aa5969495363c028dca10f96f4ec89dece71b9f8f8e89653d79257bb';
SET @sort_order = 45;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_인도',
    '-',
    '현황: 인도, 실행완료
운용리스,금융리스',
    '하나인 - "실행" 버튼 눌러서 채권번호 "L" 채번 시',
    '[차량번호 등록] 후 [번호등록 완료]로 변경',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-600';
SET @content_hash = 'b3df933a3552aeee6383e9ed13af09cbbccb16e1fe546bd2f924f5909e21494e';
SET @sort_order = 46;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_가견적',
    '-',
    '로그인',
    '하나원큐오토>신차리스 메뉴명 선택하여 새 견적을 진행한다',
    '견적 진행시, 
차종 : 수입차 선택
고객 구분 : 개인, 개인사업자, 법인 사업자 중 선택',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-601';
SET @content_hash = '1c079e86b8f4a346a4c41bdf828ea593001db13905576eb036e76256a382d83c';
SET @sort_order = 47;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_가견적',
    '-',
    '로그인',
    '견적 내기 완료후, 견적 확정 버튼 클릭',
    '[견적 확정 팝업] 화면이 표시된다.
상품선택에서 다건의 상품을 중요버튼을 체크해둔 상태라면 견적 선택 영역에서 
견적 확정할 견적을 체크 후 [견적 확정] 버튼을 클릭한다.

안내 알럿이 표시된다. 
견적이 견적 탭으로 이동된다. (현황조회에 있던 정보가 가견적 > 견적 탭으로 이동)',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-602';
SET @content_hash = 'afd1e4aa8e9a9f3706d6adcd4d9f678e1d0d170e3895615be7fed04751cf964e';
SET @sort_order = 48;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의전',
    '현황조회에 견적 탭 클릭, 진행한 정보가 견적 탭에 있는 것을 확인한다.',
    '견적 확정 - 견적의 초기 상태값은 ''동의전''이다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-603';
SET @content_hash = '8f938970b2fcaf7afa127ed8c165ff24f1744cf2ba3f4f187b6416117ec2903b';
SET @sort_order = 49;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의전',
    '견적 동의전 케이스 상세조회 버튼 클릭',
    '[상세조회] 버튼 클릭하여, 
해당 정보 확인과 하단에 재견적, 견적서 발송, 견적서 보기, 신용정보조회 동의 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-604';
SET @content_hash = '491756aafd9a5540585284cc9432cd9ccdc6e28cfe922e20121f5de6f7ec8379';
SET @sort_order = 50;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의전',
    '신용정보조회 동의 클릭',
    '신용조회재요청 으로 버튼명 변경',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-605';
SET @content_hash = '4ce6248950f35610e32b48f189840bcd5b69f5f81a95cf24343549c1b904a96c';
SET @sort_order = 51;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의완료, 
고객구분 : 개인, 개인사업자,법인',
    '견적 동의완료 케이스 - 신용조회 완료 상태일 경우',
    '[상세조회] 버튼 클릭하여, 
해당 정보 확인과 하단에 재견적, 견적서 발송, 견적서 보기, 심사신청 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-606';
SET @content_hash = '3630c14b43dbbc6de34220da8b212be7b123ddea2bb6e46c7d7ee83d993d394b';
SET @sort_order = 52;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의완료, 
고객구분 : 개인, 개인사업자,법인',
    '[심사신청] 버튼을 클릭한다.',
    '캐피탈 심사신청'' 팝업이 출력한다.
팝업 내 심사 대상을 체크하여 심사 신청을 한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-607';
SET @content_hash = '8f318ebb3b2de8fce9149edc230c668014bf2f4b2d6d63da1d7c05b93e027a0a';
SET @sort_order = 53;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '심사 상태 값 : 자동 승인, 
승인 된 상태 ''승인'' 노출',
    '재견적 / 견적서 발송 / 견적서 보기 / 서류등록 / 품의등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-608';
SET @content_hash = '5b9345f478cebce1eb7fd2cbdc0b9916cb5594bc7e3224d9cb5512db24c68fa7';
SET @sort_order = 54;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 상담중',
    '심사 상태 값 : 자동 승인 외 건은 ''상담중'' 노출',
    '재견적 / 견적서 발송 / 견적서 보기 / 서류등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-609';
SET @content_hash = '4c4d5534e475b0cb7a297e63e435b3ef98b456758cf335ddb0d5bd185c735b0d';
SET @sort_order = 55;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 부결',
    '심사 상태 값 : 시스템 거절 건은 ''부결'' 노출',
    '재견적 / 견적서 발송 / 견적서 보기 / 서류등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-610';
SET @content_hash = '0863f55c7f59f201d60163f4c4dfba59cfc889f0c0bd28775ce3184c72c256be';
SET @sort_order = 56;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[품의등록] 버튼을 클릭한다.',
    '[품의등록] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-611';
SET @content_hash = 'c6412cccb0b19b1a0192d416d90ffb5a43bc8a8ae132a054b13f64f8941fd1ee';
SET @sort_order = 57;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인 
개인',
    '계약자 정보 확인',
    '성명, 생년월일, 진행일정, 상품명',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-612';
SET @content_hash = '54d3a86a675b1bd4d0ee2aa4bbae65be0c4b503d34c99845f3785216a892fb32';
SET @sort_order = 58;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인
개인사업자',
    '계약자 정보 확인',
    '회사명,대표자 성함, 대표자 생년월일, 사업자번호',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-613';
SET @content_hash = 'a8b2decc9d9797787507acc83fda6a7691ee7c3cbb18e05ab79ac481e78d58d7';
SET @sort_order = 59;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인 
법인사업자',
    '계약자 정보 확인',
    '회사명,대표자 성함, 사업자번호, 법인등록번호, 연대보증인성함, 연대보증인 생년월일',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-614';
SET @content_hash = '41694e8d053d0cfbda6144b2b0b807e50c299410b4d37544acdb8194199ba583';
SET @sort_order = 60;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인 ,
신차리스, 수입차',
    '노출 목록 확인',
    '판매점 정보(브랜드, 딜러사, 전시장(판매대리점), 판매사원)
영업사원정보 (영업사원)
차량대금 송금계좌 (계좌번호)
서류등록',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-615';
SET @content_hash = 'd47256fec81af2a2fa9e88f70b92597c2582b0dde343633e15db77953c587de4';
SET @sort_order = 61;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인 ,
신차리스, 수입차-제휴사',
    '제휴사인 경우, 딜러사 항목',
    '견적에서 선택한 제휴사를 디폴트로 노출(변경불가)',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-616';
SET @content_hash = 'c53fe2d57021735a84264da94a2f8a44a58a078819e1856d0ce67cc280c28f99';
SET @sort_order = 62;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인 ,
신차리스, 수입차-비제휴사',
    '수입차 비제휴사 경우(견적에서 제휴사 미선택 시) → 딜러사 항목 활성화 [검색]버튼 클릭시',
    '판매점 조회 팝업 출력 후 , 비제휴 딜러사만 리스트되어 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-617';
SET @content_hash = 'eb493ccf12df229c57e293e3e8c9e36b1f59e47ab6624931fecc23675bdd9f2c';
SET @sort_order = 63;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인 ,
신차리스, 수입차-비제휴사',
    '수입차 경우 → 전시장(판매대리점) 조회 영역',
    '판매점 조회 팝업 출력 후 , 수입차 비제휴 딜러사만 리스트되어 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-618';
SET @content_hash = '73c36768b6914cd72fc8a9ea390b1cfc1ddf5dc19f3afa5d7f98a76f93e6f306';
SET @sort_order = 64;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인 ,
신차리스, 수입차-제휴사',
    '수입차 경우 → 전시장(판매대리점) 에 검색을 선택하고  [판매점 조회 팝업] 화면에  검색어를 입력 후 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 딜러사 속하는 전시장 리스트 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-619';
SET @content_hash = '8bafc12d2d8f3b1fb3fd8daf6973992764fb2e7631be5bd50e93cf4cefb5e999';
SET @sort_order = 65;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인 ,
신차리스, 수입차-제휴사',
    '전시장(판매대리점) [검색] 버튼 클릭, [판매점 조회 팝업] 화면에 검색 조건을 선택하고 검색어를 입력 후 [조회] 버튼을 클릭한다.',
    '검색 결과가 없는 경우 조회결과 영역에 ''검색 결과가 없습니다'' 문구가 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-620';
SET @content_hash = 'af30798aaefebad567089895d00297edbe45d67503aae3ff72d6941a96004db3';
SET @sort_order = 66;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인 ,
신차리스, 수입차-제휴사',
    '[판매점 조회 팝업] 화면에 검색 결과를 클릭한다.',
    '[판매점 조회 팝업] 화면이 닫히며, [품의등록] 화면에서 선택값이 판매대리점 영역에 반영된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-621';
SET @content_hash = '71cd19d536d31d503cd70dcfcec9b8382954a7a1acaefe7afc846321376ef267';
SET @sort_order = 67;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[품의등록] 화면에서 판매사원 [검색]버튼을 클릭한다.',
    '[판매사원 조회 팝업] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-622';
SET @content_hash = '02fe4b8e78622243e8fd15840e8410adba4ef48ca69f1888c134e311e61d9d85';
SET @sort_order = 68;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '조회 결과가 있을 경우 → [판매사원 조회 팝업] 화면에서 조회조건 조회 값을 입력하여 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 결과가 조회된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-623';
SET @content_hash = 'e26d3d1fbd17ee22bd0747e427b211913f6e2f5faacbba71bf0c43f88111f297';
SET @sort_order = 69;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '조회 결과가 없을 경우 → [판매사원 조회 팝업] 화면에서 조회조건 조회 값을 입력하여 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 ''검새 결과가 없습니다'' 문구가 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-624';
SET @content_hash = '7149b339de2d62f49deb2b8c3de782ceca1c098a1b4efee1aecc6944a6012aba';
SET @sort_order = 70;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[판매사원 조회 팝업] 화면에 검색 결과를 클릭한다.',
    '[판매사원 조회 팝업] 화면이 닫히며, [품의등록] 화면에서 선택값이 판매사원 영역에 반영된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-625';
SET @content_hash = 'b27d11c8849298f0fe99a802ff8111178d6ad147223a0b792503cc3bc631b4b8';
SET @sort_order = 71;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[품의등록] 화면에서 은행 영역을 클릭한다.',
    '[은행 선택] 영역이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-626';
SET @content_hash = '012e804e956dbe95d810a44f2c6646c92cf987ef86df02ae132fb457eb280031';
SET @sort_order = 72;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[은행 선택] 화면에서 은행을 선택한다.',
    '[은행 선택] 영역이 닫히면서 차량대금 송금(선택) 은행 정보영역에 선택값이 반영된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-627';
SET @content_hash = '4bcfd81cebb496bbab8676706fe9e0138513248b240a2d048f2dde009368255d';
SET @sort_order = 73;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[품의등록] 화면에서 계좌를 입력하고 [계좌확인] 버튼을 클릭한다.',
    '계좌 검증을 진행 후 계좌의 예금주명 영역에 예금주를 표시한다.
계좌 번호 확인 성공시→성공 얼럿 출력
계좌 번호 확인 실패시→실패 얼럿 출력',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-628';
SET @content_hash = '37f3eba5b489d08bf9591381c15825b4940299c9c9a039d6c5c1cca9b17c5358';
SET @sort_order = 74;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[품의등록] 화면에서 [서류등록] 버튼을 클릭한다.',
    '[손님서류등록] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-629';
SET @content_hash = 'ce8f5fc0189002deb10d8a94790979e1be919c4a5113a720d212b7a1301a2698';
SET @sort_order = 75;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[손님서류등록] 팝업에서 [파일을 첨부해주세요 +] 버튼을 클릭한다.',
    '파일 첨부 상세페이지로 이동한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-630';
SET @content_hash = '23ea9e586ec722ce8e950e9c4039d8aca63fcc6b1c833a2571ab844571a69822';
SET @sort_order = 76;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[파일 업로드] 화면에서 이미지/PDF를 첨부한다',
    '첨부된 파일명이 리스트업 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-631';
SET @content_hash = '21096cb452832ce968db9642bd23fdb6f3b510d30543e5553d2e6a39e54ed91d';
SET @sort_order = 77;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[파일 업로드] 화면에서 첨부된 파일명 우측 옆 [x]버튼을 클릭한다.',
    '업로드한 파일이 삭제된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-632';
SET @content_hash = '3d7fe169b70a4e3250f8b54581f45662da835d24e5366bd84d34bc2d9fbd6a85';
SET @sort_order = 78;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[파일 업로드] 화면에서  [등록] 버튼을 클릭한다.',
    '파일업로드에 성공한 경우 -> 성공 얼럿 출력
파일 업로드 실패한 경우 -> 실패 얼럿 출력
해당 팝업이 닫히고 [손님서류등록] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-633';
SET @content_hash = 'f5077e4e08f291bff8a2f67e78a3e8d719b5a67f26b215076ac51f5cd5251f17';
SET @sort_order = 79;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '첨부한 파일이 있는 경우 → [손님서류등록] 팝업의 [다운로드] 버튼을 클릭한다.',
    '해당 파일을 다운로드하여 확인할 수 있다. (최대 5분 소요)',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-634';
SET @content_hash = '1518e517c030e69064ab6db183185998d78a8612aadd23bb0cae42cf7be29ce2';
SET @sort_order = 80;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[손님서류등록] 팝업의 [저장] 버튼을 클릭한다.',
    '팝업창이 닫힌다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-635';
SET @content_hash = '862a38247d9802e76e7e9c2d355daedc26e2f62a53f8e69f9c4f71299f35b644';
SET @sort_order = 81;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[품의등록] 화면에서 정보 입력 완료 → [품의등록 요청] 버튼을 클릭한다.',
    '[품의등록] 완료시, 완료 얼럿이 출력한다. 
버튼명 - 품의등록 완료 로 변경',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-636';
SET @content_hash = '83c1fd3a5f3afdb0156baeffe3029e6352328fd299a95c370c2e8eb4e1159f99';
SET @sort_order = 82;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의 요청',
    '"심사"상태의 품의등록 완료 시 상태이며
하나인 - 품의등록 "저장" 버튼 미실행 단계',
    '견적서 발송 / 견적서 보기 / 서류추가 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-637';
SET @content_hash = '0e719b65c26c6acc8a2ac4c06890f8a5e6319193160ff9a7f9ea7336918142c6';
SET @sort_order = 83;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의 요청',
    '견적 상태 : 품의요청 → [견적서 발송] 버튼을 클릭한다.',
    '[견적서 발송] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-638';
SET @content_hash = '564012087b3eff2300014394387c4e0c9d949547f252a3dcab6f79958a09c085';
SET @sort_order = 84;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의 요청',
    '견적 상태 : 품의요청 → [견적서 보기] 버튼을 클릭한다.',
    '[견적서 보기] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-639';
SET @content_hash = '8aaf1d9b69f32aa93a4ed07eb71a9477bf002fa355190038ce123641af7afc03';
SET @sort_order = 85;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의 확정',
    '하나인 - 품의등록 "저장" 버튼 실행 하면',
    '견적서 보기 / 서류추가 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-640';
SET @content_hash = 'bf2f2d68ef0b0729692b92a7d4f750dd3bc777a251c3f5148ee0f7b15bbfaa4e';
SET @sort_order = 86;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의 확정
법인사업자',
    '하나인 - 품의등록 "저장" 버튼 실행 하면',
    '견적서 보기 / 서류추가 등록 / 연대보증계약서 다운 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-641';
SET @content_hash = '8672f78fe37ddb8aa86d3aa2d9e0543f9259aa486746e3956f218554eca6ae50';
SET @sort_order = 87;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의 확정',
    '[견적서 보기] 버튼을 클릭한다.',
    '[견적서 보기] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-642';
SET @content_hash = '3bdf65d0241aaedf2f3f2c76bc12745bba8e2b1120ed70c41f5c88c9a649888d';
SET @sort_order = 88;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황: 품의, 품의확정
법인사업자',
    '연대보증계약서 다운 클릭시',
    '연도보증계약서 pdf 파일이 다운로드 된다.
연도보증계약서 pdf 파일을 열면 정상표기 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-643';
SET @content_hash = 'cd6249763ffdb006240e6a513e2f16d86dadf71eca3f06f126c440e7402eb731';
SET @sort_order = 89;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_인도',
    '-',
    '현황: 인도, 송금완료
운용리스,금융리스, 중고차',
    '하나인 - "선급완료" 처리 시',
    '서류 등록 / 견적서 보기 /차량번호 등록  버튼 유무를 확인한다.
[차량번호 등록] 후 [번호등록 완료]로 변경',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-644';
SET @content_hash = '2aeae2e54cf7d503e2903ea8cae09c7d455baaaed20d81bf064595013bc47f4d';
SET @sort_order = 90;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_인도',
    '-',
    '현황: 인도, 송금완료
운용리스,금융리스, 중고차',
    '[차량번호 등록] 버튼을 클릭한다.',
    '[차량번호 등록] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-645';
SET @content_hash = '1a13d41398a326fcc24c029e168a0f9aa66df78dcc5bd3402b094cf19974211e';
SET @sort_order = 91;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_인도',
    '-',
    '현황: 인도, 송금완료
운용리스,금융리스, 중고차',
    '[차량번호 등록] 화면에서 차량번호를 입력 후 [확인] 버튼을 클릭한다.',
    '차량번호가 입력된 상태로 비활성화 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-646';
SET @content_hash = '635d5b34e58abec9132840eb63692a8fb07180a0dd5bb2999a5a5dc9d47c79a1';
SET @sort_order = 92;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_인도',
    '-',
    '현황: 인도, 송금완료
운용리스,금융리스',
    '[차량번호 등록] 화면에서 [확인] 버튼을 클릭한다.',
    '차량번호가 등록된다. [차량번호 등록] 화면이 닫힌다. [차량번호 등록] 버튼이 [번호등록 완료] 버튼으로 바뀐다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-647';
SET @content_hash = '75688f713db07247b7550ea7feaca64e678ee643763277b7423c1852b6927a53';
SET @sort_order = 93;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_인도',
    '-',
    '현황: 인도, 실행완료
운용리스,금융리스',
    '하나인 - "실행" 버튼 눌러서 채권번호 "L" 채번 시',
    '[차량번호 등록] 후 [번호등록 완료]로 변경',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-500';
SET @case_code = 'CASE-UL-500';
SET @content_hash = 'e04c1368c8fd42107d81f68b340909a5bab892d87a7e5accccce9561ce686694';
SET @sort_order = 94;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_가견적',
    '-',
    '로그인',
    '하나원큐오토>중고리스 메뉴명 선택하여 새 견적을 진행한다',
    '견적 진행시, 
일반중고 선택
차종 : 국산 / 수입 중 선택
고객 구분 : 개인, 개인사업자, 법인 사업자 중 선택',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-500';
SET @case_code = 'CASE-UL-501';
SET @content_hash = 'd787d14623cf29d1299d96e0d4cf0eb9648488e0bc3506510c32e1c86cc27210';
SET @sort_order = 95;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_가견적',
    '-',
    '로그인',
    '견적 내기 완료후, 견적 확정 버튼 클릭',
    '[견적 확정 팝업] 화면이 표시된다.
상품선택에서 다건의 상품을 중요버튼을 체크해둔 상태라면 견적 선택 영역에서 
견적 확정할 견적을 체크 후 [견적 확정] 버튼을 클릭한다.

안내 알럿이 표시된다. 
견적이 견적 탭으로 이동된다. (현황조회에 있던 정보가 가견적 > 견적 탭으로 이동)',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-500';
SET @case_code = 'CASE-UL-502';
SET @content_hash = '5e80e20ff3d0db51d4719f85fa9965e2430f461c60601850304d5969c87b57e7';
SET @sort_order = 96;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의전',
    '현황조회에 견적 탭 클릭, 진행한 정보가 견적 탭에 있는 것을 확인한다.',
    '견적 확정 - 견적의 초기 상태값은 ''동의전''이다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-500';
SET @case_code = 'CASE-UL-503';
SET @content_hash = '465537bb39567f5dae5cd52e030faac6474f36a85cf90713b156f7b03d6727e0';
SET @sort_order = 97;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의전',
    '견적 동의전 케이스 상세조회 버튼 클릭',
    '[상세조회] 버튼 클릭하여, 
해당 정보 확인과 하단에 재견적, 견적서 발송, 견적서 보기, 신용정보조회 동의 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-500';
SET @case_code = 'CASE-UL-504';
SET @content_hash = 'bf9c718a4f1957cdab47346b4d4f0a5019ddfee24e0eb5df3d88004e2a37ae60';
SET @sort_order = 98;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의전',
    '신용정보조회 동의 클릭',
    '신용조회재요청 으로 버튼명 변경',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-500';
SET @case_code = 'CASE-UL-505';
SET @content_hash = '6e46f5cb261d609244610e7130c28c9a88bd55ee9fd2e798c6a1d7852e1466d0';
SET @sort_order = 99;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의완료, 
고객구분 : 개인, 개인사업자,법인',
    '견적 동의완료 케이스 - 신용조회 완료 상태일 경우',
    '[상세조회] 버튼 클릭하여, 
해당 정보 확인과 하단에 재견적, 견적서 발송, 견적서 보기, 심사신청 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-500';
SET @case_code = 'CASE-UL-506';
SET @content_hash = '639612b8106eef35e125b554d52d2c64b5b37c511b44d2b7bcd8d1c6d253a679';
SET @sort_order = 100;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의완료, 
고객구분 : 개인, 개인사업자,법인',
    '[심사신청] 버튼을 클릭한다.',
    '캐피탈 심사신청'' 팝업이 출력한다.
팝업 내 심사 대상을 체크하여 심사 신청을 한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-500';
SET @case_code = 'CASE-UL-507';
SET @content_hash = '4cf939db904aa278ffc3e8aaf90431829403c9ed533ee64ff89378f99c3e0cc9';
SET @sort_order = 101;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '심사 상태 값 : 자동 승인, 
승인 된 상태 ''승인'' 노출',
    '재견적 / 견적서 발송 / 견적서 보기 / 서류등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-500';
SET @case_code = 'CASE-UL-508';
SET @content_hash = '9f60d401628b86cf8bef7b7d46e2f0aad1375791cd2cce721139329fe675fb7a';
SET @sort_order = 102;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 상담중',
    '심사 상태 값 : 자동 승인 외 건은 ''상담중'' 노출',
    '재견적 / 견적서 발송 / 견적서 보기 / 서류등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-500';
SET @case_code = 'CASE-UL-509';
SET @content_hash = 'e44ea5ad13d8b0f7ac72db9546169a40faaf5e16bcf50e8b836df434f8cdf392';
SET @sort_order = 103;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 부결',
    '심사 상태 값 : 시스템 거절 건은 ''부결'' 노출',
    '재견적 / 견적서 발송 / 견적서 보기 / 서류등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-500';
SET @case_code = 'CASE-UL-510';
SET @content_hash = '1b62142ff551e0ee6c6ef6454a15aaa1104f1dea3c69a542d1428cc46131c3c1';
SET @sort_order = 104;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '심사요청 후, 하나인에서 진행',
    '하나인에서 품의 등록 완료 (하나인에서만 진행이 가능)',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-500';
SET @case_code = 'CASE-UL-511';
SET @content_hash = '98b0e7dab7da3b1f4228ada4a41dbd9c8197ce8665c1ad24442290ae5b170ce0';
SET @sort_order = 105;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의요청',
    '"심사"상태의 품의등록 완료 시 상태이며
하나인 - 품의등록 "저장" 버튼 미실행 단계',
    '견적서 발송 / 견적서 보기 / 서류추가 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-500';
SET @case_code = 'CASE-UL-512';
SET @content_hash = '7b1c3df021e6191c39fc2e1ca8f54e4c5a7c684bf10c4f1e777219d5d538bf9a';
SET @sort_order = 106;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의요청',
    '[견적서 발송] 버튼을 클릭한다.',
    '[견적서 발송] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-500';
SET @case_code = 'CASE-UL-513';
SET @content_hash = '56979b6b55f556a533760f01be9c4b18663d28ba0f9084b8192243f5fb623337';
SET @sort_order = 107;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의요청',
    '[견적서 보기] 버튼을 클릭한다.',
    '[견적서 보기] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-500';
SET @case_code = 'CASE-UL-514';
SET @content_hash = '1f29aa930685726e95a7d15865f45db6b92383f6bbe211a3d5d8ab83e5a8cb4c';
SET @sort_order = 108;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의 확정',
    '하나인 - 품의등록 "저장" 버튼 실행 하면',
    '견적서 보기 / 서류추가 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-500';
SET @case_code = 'CASE-UL-515';
SET @content_hash = '6521bd85990cad167a165e21d4421b031f854fe21c9cf6fa4f0cd9b2f170c54b';
SET @sort_order = 109;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의 확정
법인사업자',
    '하나인 - 품의등록 "저장" 버튼 실행 하면',
    '견적서 보기 / 서류추가 등록 / 연대보증계약서 다운 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-500';
SET @case_code = 'CASE-UL-516';
SET @content_hash = '8dc622cd1e433ee0195b2468ef69d37e526d4e06acbc7a8ac23d02769aed7af2';
SET @sort_order = 110;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의 확정',
    '[견적서 보기] 버튼을 클릭한다.',
    '[견적서 보기] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-500';
SET @case_code = 'CASE-UL-517';
SET @content_hash = 'fd410731e9618a6b4cc6197739118f44a8f3f7e946abbb429cb423a52ac586a4';
SET @sort_order = 111;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황: 품의, 품의확정
법인사업자',
    '연대보증계약서 다운 클릭시',
    '연도보증계약서 pdf 파일이 다운로드 된다.
연도보증계약서 pdf 파일을 열면 정상표기 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-500';
SET @case_code = 'CASE-UL-518';
SET @content_hash = '3ced76b3b3fc3b084ab61d6cb40f77604d5f9eec7c421ac3159c84e197f05b4b';
SET @sort_order = 112;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_인도',
    '-',
    '현황: 인도, 송금완료
운용리스,금융리스, 중고차',
    '하나인 - "선급완료" 처리 시',
    '서류 등록 / 견적서 보기 /차량번호 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-500';
SET @case_code = 'CASE-UL-519';
SET @content_hash = 'dee1695b49774aa1763d1980508ec5ba9e9c5495a042543f732d414702f6c3a5';
SET @sort_order = 113;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_인도',
    '-',
    '현황: 인도, 송금완료
운용리스,금융리스, 중고차',
    '[차량번호 등록] 버튼을 클릭한다.',
    '[차량번호 등록] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-500';
SET @case_code = 'CASE-UL-520';
SET @content_hash = '58815b4f3fc2ddd864e964b407529c017e4896b8a702f35aea2abf0dfe52b7d3';
SET @sort_order = 114;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_인도',
    '-',
    '현황: 인도, 송금완료
운용리스,금융리스, 중고차',
    '[차량번호 등록] 화면에서 차량번호를 입력 후 [확인] 버튼을 클릭한다.',
    '차량번호가 입력된 상태로 비활성화 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-500';
SET @case_code = 'CASE-UL-521';
SET @content_hash = 'b7fafe65918a3b81ef1aa382239eedb9e90bbdad1eeee33ea70cd198f1a22caa';
SET @sort_order = 115;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_인도',
    '-',
    '현황: 인도, 송금완료
운용리스,금융리스, 중고차',
    '[차량번호 등록] 화면에서 [확인] 버튼을 클릭한다.',
    '차량번호가 등록된다. [차량번호 등록] 화면이 닫힌다. [차량번호 등록] 버튼이 [번호등록 완료] 버튼으로 바뀐다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-500';
SET @case_code = 'CASE-UL-522';
SET @content_hash = '757487a3720e130a6ae6da608e4538ea2b3fd0e60794b33ad5ea9b585e5d765f';
SET @sort_order = 116;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_인도',
    '-',
    '현황: 인도, 실행완료
운용리스,금융리스, 중고차',
    '하나인 - "실행" 버튼 눌러서 채권번호 "L" 채번 시',
    '[차량번호 등록] 후 [차량번호등록 완료]로 변경',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-600';
SET @case_code = 'CASE-UL-600';
SET @content_hash = '565bd810453dea487bb9b5a2ff93c0da9edf302530c76af7d6ea2521dcfd9986';
SET @sort_order = 117;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_가견적',
    '-',
    '로그인',
    '하나원큐오토>중고리스 메뉴명 선택하여 새 견적을 진행한다',
    '견적 진행시, 
인증중고 선택
차종 : 국산 / 수입 중 선택
고객 구분 : 개인, 개인사업자, 법인 사업자 중 선택',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-600';
SET @case_code = 'CASE-UL-601';
SET @content_hash = '4291ea5a7692d087a53084b46743a44c9f67e7fbd7dfdb8224227edb4311c500';
SET @sort_order = 118;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_가견적',
    '-',
    '로그인',
    '견적 내기 완료후, 견적 확정 버튼 클릭',
    '[견적 확정 팝업] 화면이 표시된다.
상품선택에서 다건의 상품을 중요버튼을 체크해둔 상태라면 견적 선택 영역에서 
견적 확정할 견적을 체크 후 [견적 확정] 버튼을 클릭한다.

안내 알럿이 표시된다. 
견적이 견적 탭으로 이동된다. (현황조회에 있던 정보가 가견적 > 견적 탭으로 이동)',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-600';
SET @case_code = 'CASE-UL-602';
SET @content_hash = 'bb2d77e26d68459c23b73d2c6195872acb5b1d640d4f3777ceb7319dd5101c5d';
SET @sort_order = 119;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의전',
    '현황조회에 견적 탭 클릭, 진행한 정보가 견적 탭에 있는 것을 확인한다.',
    '견적 확정 - 견적의 초기 상태값은 ''동의전''이다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-600';
SET @case_code = 'CASE-UL-603';
SET @content_hash = 'd7e660c7ada89e855067a671f3ee4aef0355f9cd093af346508134e4510b912e';
SET @sort_order = 120;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의전',
    '견적 동의전 케이스 상세조회 버튼 클릭',
    '[상세조회] 버튼 클릭하여, 
해당 정보 확인과 하단에 재견적, 견적서 발송, 견적서 보기, 신용정보조회 동의 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-600';
SET @case_code = 'CASE-UL-604';
SET @content_hash = 'da6a71cbf19f9a8d3e9bba7a1e931f949946046439c8b19ac584363a37ac81e4';
SET @sort_order = 121;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의전',
    '신용정보조회 동의 클릭',
    '신용조회재요청 으로 버튼명 변경',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-600';
SET @case_code = 'CASE-UL-605';
SET @content_hash = '40018af50eaf400211a94fb658cbb2ccf9ea54edef58295e5d295ed90d02b7d7';
SET @sort_order = 122;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의완료, 
고객구분 : 개인, 개인사업자,법인',
    '견적 동의완료 케이스 - 신용조회 완료 상태일 경우',
    '[상세조회] 버튼 클릭하여, 
해당 정보 확인과 하단에 재견적, 견적서 발송, 견적서 보기, 심사신청 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-600';
SET @case_code = 'CASE-UL-606';
SET @content_hash = '7094165a87c7f98d553606b3bb10fe3a745c7f74fc5e5f46e7fe4c7430a00811';
SET @sort_order = 123;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의완료, 
고객구분 : 개인, 개인사업자,법인',
    '[심사신청] 버튼을 클릭한다.',
    '캐피탈 심사신청'' 팝업이 출력한다.
팝업 내 심사 대상을 체크하여 심사 신청을 한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-600';
SET @case_code = 'CASE-UL-607';
SET @content_hash = '4a1a0a1ab8bd1c8009fd577a885b6f0e506108e467ceb158cff1f48834be5b03';
SET @sort_order = 124;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '심사 상태 값 : 자동 승인, 
승인 된 상태 ''승인'' 노출',
    '재견적 / 견적서 발송 / 견적서 보기 / 서류등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-600';
SET @case_code = 'CASE-UL-608';
SET @content_hash = 'e0cb8ec66a815e560038f7151f9e57c9776490c85fc83f8751250046bc5f8bda';
SET @sort_order = 125;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 상담중',
    '심사 상태 값 : 자동 승인 외 건은 ''상담중'' 노출',
    '재견적 / 견적서 발송 / 견적서 보기 / 서류등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-600';
SET @case_code = 'CASE-UL-609';
SET @content_hash = 'bd1ed7dadab42ab140d47dd163dd01296f700a4e03bf6e286735757f40d8e389';
SET @sort_order = 126;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 부결',
    '심사 상태 값 : 시스템 거절 건은 ''부결'' 노출',
    '재견적 / 견적서 발송 / 견적서 보기 / 서류등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-600';
SET @case_code = 'CASE-UL-610';
SET @content_hash = '89d8a62dddb58164190a7f8b85fde4c0568f730f49b2a703060669cd5d09e836';
SET @sort_order = 127;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '심사요청 후, 하나인에서 진행',
    '하나인에서 품의 등록 완료 (하나인에서만 진행이 가능)',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-600';
SET @case_code = 'CASE-UL-611';
SET @content_hash = '6034cbbf16912753ed6925871762cd3f8eb4e420036b3157dd6f25811a75d294';
SET @sort_order = 128;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의요청',
    '"심사"상태의 품의등록 완료 시 상태이며
하나인 - 품의등록 "저장" 버튼 미실행 단계',
    '견적서 발송 / 견적서 보기 / 서류추가 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-600';
SET @case_code = 'CASE-UL-612';
SET @content_hash = 'b8032bea59034efa732dba75b57908aed0c44bfc856ce2f1fe7ec9ea0e556202';
SET @sort_order = 129;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의요청',
    '[견적서 발송] 버튼을 클릭한다.',
    '[견적서 발송] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-600';
SET @case_code = 'CASE-UL-613';
SET @content_hash = 'fdd7331083465b2f9e16bbf3ce463ca5aa506adbf628128ae987e3b2626030f5';
SET @sort_order = 130;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의요청',
    '[견적서 보기] 버튼을 클릭한다.',
    '[견적서 보기] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-600';
SET @case_code = 'CASE-UL-614';
SET @content_hash = '976676a9d5bf3f555ac592c33b388b9375ffa8c80fa4c68523f00abab2d5552e';
SET @sort_order = 131;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의요청',
    '하나인 - 품의등록 "저장" 버튼 실행 하면',
    '견적서 보기 / 서류추가 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-600';
SET @case_code = 'CASE-UL-615';
SET @content_hash = 'e89431da35b059533dae1a2d5e0d847e262b71dcff4a8849d502d87217511ede';
SET @sort_order = 132;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의 확정
법인사업자',
    '하나인 - 품의등록 "저장" 버튼 실행 하면',
    '견적서 보기 / 서류추가 등록 / 연대보증계약서 다운 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-600';
SET @case_code = 'CASE-UL-616';
SET @content_hash = '8caddfb29f5fe5e8b0357eca08f182321ed295391fcf2fc7d1614cf3e938492c';
SET @sort_order = 133;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의 확정',
    '[견적서 보기] 버튼을 클릭한다.',
    '[견적서 보기] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-600';
SET @case_code = 'CASE-UL-617';
SET @content_hash = '6d5d9048eb3a76eb11d5be2a2a12f9e73e46675eb46a8a2e111db89bc7e1fc77';
SET @sort_order = 134;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황: 품의, 품의확정
법인사업자',
    '연대보증계약서 다운 클릭시',
    '연도보증계약서 pdf 파일이 다운로드 된다.
연도보증계약서 pdf 파일을 열면 정상표기 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-600';
SET @case_code = 'CASE-UL-618';
SET @content_hash = '477667ae27c3777aa643e9325cb2d61704ea4b7af3d9cc99537be6739ec0d67a';
SET @sort_order = 135;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_인도',
    '-',
    '현황: 인도, 송금완료
운용리스,금융리스, 중고차',
    '하나인 - "선급완료" 처리 시',
    '서류 등록 / 견적서 보기 /차량번호 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-600';
SET @case_code = 'CASE-UL-619';
SET @content_hash = 'b47f03cbf069e03a3cc8b4199aa5ee54826a2a483cf1b5f80c6a76257fe32cd3';
SET @sort_order = 136;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_인도',
    '-',
    '현황: 인도, 송금완료
운용리스,금융리스, 중고차',
    '[차량번호 등록] 버튼을 클릭한다.',
    '[차량번호 등록] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-600';
SET @case_code = 'CASE-UL-620';
SET @content_hash = '71a476dcfec1b15bc414d712f8b42bd690fe91b08cca2bb95b925fca691e3d76';
SET @sort_order = 137;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_인도',
    '-',
    '현황: 인도, 송금완료
운용리스,금융리스, 중고차',
    '[차량번호 등록] 화면에서 차량번호를 입력 후 [확인] 버튼을 클릭한다.',
    '차량번호가 입력된 상태로 비활성화 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-600';
SET @case_code = 'CASE-UL-621';
SET @content_hash = '627dd33ce2c335539903cf05d0bcfcbfa69e76b7d61f46bbbe9312ed8b09e68a';
SET @sort_order = 138;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_인도',
    '-',
    '현황: 인도, 송금완료
운용리스,금융리스, 중고차',
    '[차량번호 등록] 화면에서 [확인] 버튼을 클릭한다.',
    '차량번호가 등록된다. [차량번호 등록] 화면이 닫힌다. [차량번호 등록] 버튼이 [번호등록 완료] 버튼으로 바뀐다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-UL-600';
SET @case_code = 'CASE-UL-622';
SET @content_hash = '4d8986b05bbe987a7055a57595e7df780acd456e376061bf7a52abd053b56231';
SET @sort_order = 139;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_인도',
    '-',
    '현황: 인도, 실행완료
운용리스,금융리스, 중고차',
    '하나인 - "실행" 버튼 눌러서 채권번호 "L" 채번 시',
    '[차량번호 등록] 후 [차량번호등록 완료]로 변경',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-500';
SET @content_hash = '18803bb272d01958552a5ed7ed1e3a04919e56b09c23bc0813c312a64bd62f0a';
SET @sort_order = 140;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_가견적',
    '-',
    '로그인',
    '하나원큐오토>시승차 메뉴명 선택하여 새 견적을 진행한다',
    '견적 진행시, 
차종 : 수입차 선택
고객 구분 : 개인, 개인사업자, 법인 사업자 중 선택',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-501';
SET @content_hash = 'e8466d5c72f2244ac67a975e5ca6905a1cbe4f7de8f723f8ea92f529eced9ea5';
SET @sort_order = 141;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_가견적',
    '-',
    '로그인',
    '견적 내기 완료후, 견적 확정 버튼 클릭',
    '[견적 확정 팝업] 화면이 표시된다.
상품선택에서 다건의 상품을 중요버튼을 체크해둔 상태라면 견적 선택 영역에서 
견적 확정할 견적을 체크 후 [견적 확정] 버튼을 클릭한다.

안내 알럿이 표시된다. 
견적이 견적 탭으로 이동된다. (현황조회에 있던 정보가 가견적 > 견적 탭으로 이동)',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-502';
SET @content_hash = '6bac6bde4fe549ced3637025ac2875b068bd950ac4ee7d5debc62ee17aa241ad';
SET @sort_order = 142;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의전',
    '현황조회에 견적 탭 클릭, 진행한 정보가 견적 탭에 있는 것을 확인한다.',
    '견적 확정 - 견적의 초기 상태값은 ''동의전''이다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-503';
SET @content_hash = '7cf32372fc5d7e7e261c501e3160870eb80fd427a98b1337d279317de475895d';
SET @sort_order = 143;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의전',
    '견적 동의전 케이스 상세조회 버튼 클릭',
    '[상세조회] 버튼 클릭하여, 
해당 정보 확인과 하단에 재견적, 견적서 발송, 견적서 보기, 신용정보조회 동의 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-504';
SET @content_hash = 'c2cd7e4be730ed95d9b0da6130c547271bd3b4a00c9715d0b4300301de9b01dd';
SET @sort_order = 144;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의전',
    '신용정보조회 동의 클릭',
    '신용조회재요청 으로 버튼명 변경',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-505';
SET @content_hash = '2b60ee7574b05cd44c64333f15a3aa2fa95ef731c9fca56ff02906f735ae8e61';
SET @sort_order = 145;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의완료, 
고객구분 : 개인, 개인사업자,법인',
    '견적 동의완료 케이스 - 신용조회 완료 상태일 경우',
    '[상세조회] 버튼 클릭하여, 
해당 정보 확인과 하단에 재견적, 견적서 발송, 견적서 보기, 심사신청 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-506';
SET @content_hash = '55d2d6a275f347c122c18970624dcad61d3b4a23bdd84baa8881ccc06cf19def';
SET @sort_order = 146;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_견적',
    '-',
    '현황 : 견적, 동의완료, 
고객구분 : 개인, 개인사업자,법인',
    '[심사신청] 버튼을 클릭한다.',
    '캐피탈 심사신청'' 팝업이 출력한다.
팝업 내 심사 대상을 체크하여 심사 신청을 한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-507';
SET @content_hash = '87e1a9d05eacfb52441f8fed0999bc9d90aa44e9b3b94a011fe3663a5d535be2';
SET @sort_order = 147;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '심사 상태 값 : 자동 승인, 
승인 된 상태 ''승인'' 노출',
    '재견적 / 견적서 발송 / 견적서 보기 / 서류등록 / 품의등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-508';
SET @content_hash = '392007e3ceeb8d45a55c27d425850e94502d42ebb2f540531eecc76de7f7ec3e';
SET @sort_order = 148;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 상담중',
    '심사 상태 값 : 자동 승인 외 건은 ''상담중'' 노출',
    '재견적 / 견적서 발송 / 견적서 보기 / 서류등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-509';
SET @content_hash = '1c776da28b68e060ee24f9f233721842c412d65b5b9b5eaca8013aae9d409081';
SET @sort_order = 149;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 부결',
    '심사 상태 값 : 시스템 거절 건은 ''부결'' 노출',
    '재견적 / 견적서 발송 / 견적서 보기 / 서류등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-510';
SET @content_hash = '1666a3b0e05ce574317cd083f7c765ae2c5227d0eb7e0fb5e9ce020c145313f1';
SET @sort_order = 150;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[품의등록] 버튼을 클릭한다.',
    '[품의등록] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-511';
SET @content_hash = '5b88b2ad953bab1877313983e410eb222eff28dc0f8e2f4a3aafc3d8349f3702';
SET @sort_order = 151;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인
시승차, 수입차',
    '노출 목록 확인',
    '판매점 정보브랜드, 딜러사, 전시장(판매대리점), 판매사원
영업사원정보 (영업사원)
차량대금 송금계좌 (계좌번호)
서류등록',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-512';
SET @content_hash = '4873681227328b5a071b94d7ccfa8fedeaf05f1d44160ae2de6e56edb2c2c740';
SET @sort_order = 152;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인 ,
시승차 수입차-제휴사',
    '제휴사인 경우, 딜러사 항목',
    '견적에서 선택한 제휴사를 디폴트로 노출(변경불가)',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-513';
SET @content_hash = '81afb620b12c11d47529c4add275a8015334ac6822883a9d468480078b6cb4e9';
SET @sort_order = 153;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인 ,
시승차, 수입차-비제휴사',
    '수입차 비제휴사 경우(견적에서 제휴사 미선택 시) → 딜러사 항목 활성화 [검색]버튼 클릭시',
    '판매점 조회 팝업 출력 후 , 비제휴 딜러사만 리스트되어 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-514';
SET @content_hash = '13cfd860e7e23a6be8b645e3d714263403f4eab2c8293748a69eb8cbb6628e2a';
SET @sort_order = 154;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인 ,
시승차, 수입차-비제휴사',
    '수입차- 경우 → 전시장(판매대리점) 조회 영역',
    '판매점 조회 팝업 출력 후 , 수입차 비제휴 딜러사만 리스트되어 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-515';
SET @content_hash = '1059145096f0f3a31b6106909c64b67fcf570cdf7d25651c2263fc97550c9d94';
SET @sort_order = 155;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인 ,
시승차, 수입차-제휴사',
    '수입차 경우 → 전시장(판매대리점) 에 검색을 선택하고  [판매점 조회 팝업] 화면에  검색어를 입력 후 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 딜러사 속하는 전시장 리스트 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-516';
SET @content_hash = 'bb66655a2c7d476c5647339b2646e41ccd77f8326ff44ed9f804eedc115a5924';
SET @sort_order = 156;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인 ,
시승차, 수입차-제휴사',
    '전시장(판매대리점) [검색] 버튼 클릭, [판매점 조회 팝업] 화면에 검색 조건을 선택하고 검색어를 입력 후 [조회] 버튼을 클릭한다.',
    '검색 결과가 없는 경우 조회결과 영역에 ''검색 결과가 없습니다'' 문구가 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-517';
SET @content_hash = 'a5000b51934734cb196f34fad786caf04a66f2e699a22e7f30f5284a5ce47666';
SET @sort_order = 157;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[판매점 조회 팝업] 화면에 검색 결과를 클릭한다.',
    '[판매점 조회 팝업] 화면이 닫히며, [품의등록] 화면에서 선택값이 판매대리점 영역에 반영된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-518';
SET @content_hash = '41ffb66cc84234b9619f2561704705d9addc1efdfc028b76a5112863473bd1fe';
SET @sort_order = 158;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[품의등록] 화면에서 판매사원 [검색]버튼을 클릭한다.',
    '[판매사원 조회 팝업] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-519';
SET @content_hash = 'f101b06c9c9e19309b9e88fd58719f67d88f3529929be9aa5e494862b7acf6c9';
SET @sort_order = 159;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '조회 결과가 있을 경우 → [판매사원 조회 팝업] 화면에서 조회조건 조회 값을 입력하여 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 결과가 조회된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-520';
SET @content_hash = '590fa40febeeb1c84f4e21302c537200268be5fff1418ffbdf1ab610091305e5';
SET @sort_order = 160;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '조회 결과가 없을 경우 → [판매사원 조회 팝업] 화면에서 조회조건 조회 값을 입력하여 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 ''검새 결과가 없습니다'' 문구가 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-521';
SET @content_hash = '38296bbd34365c2871f32b7378e56e54b8450032c61fb449c332f44f617d8fb2';
SET @sort_order = 161;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[판매사원 조회 팝업] 화면에 검색 결과를 클릭한다.',
    '[판매사원 조회 팝업] 화면이 닫히며, [품의등록] 화면에서 선택값이 판매사원 영역에 반영된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-522';
SET @content_hash = '4328548ee50b55ca2871a505abad3909b79da7b35dc802cb77e32f2dc4762f01';
SET @sort_order = 162;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[품의등록] 화면에서 은행 영역을 클릭한다.',
    '[은행 선택] 영역이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-523';
SET @content_hash = '2b203a96c5977da85824fdd953401fb4cf739083430ce3d53e392f682488ebab';
SET @sort_order = 163;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[은행 선택] 화면에서 은행을 선택한다.',
    '[은행 선택] 영역이 닫히면서 차량대금 송금(선택) 은행 정보영역에 선택값이 반영된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-524';
SET @content_hash = '168ae8450d00cbd8b9c135a03bb5e15f417c5d42588b9372d1f5aabec6c57be1';
SET @sort_order = 164;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[품의등록] 화면에서 계좌를 입력하고 [계좌확인] 버튼을 클릭한다.',
    '계좌 검증을 진행 후 계좌의 예금주명 영역에 예금주를 표시한다.
계좌 번호 확인 성공시→성공 얼럿 출력
계좌 번호 확인 실패시→실패 얼럿 출력',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-525';
SET @content_hash = '0cace776848bc362e743ba423c918a86d44187a11fd49f901fd43fcfd0fcf756';
SET @sort_order = 165;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[품의등록] 화면에서 [서류등록] 버튼을 클릭한다.',
    '[손님서류등록] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-526';
SET @content_hash = '2650cf0d22b30512e6cd9777e301b7ba94dafb6893ff35f5562ed8d9275e3391';
SET @sort_order = 166;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[손님서류등록] 팝업에서 [파일을 첨부해주세요 +] 버튼을 클릭한다.',
    '파일 첨부 상세페이지로 이동한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-527';
SET @content_hash = 'a573fae352773d5c7c818013d270d9d5376c7802a6795bef751f9fcd7cfb4098';
SET @sort_order = 167;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[파일 업로드] 화면에서 이미지/PDF를 첨부한다',
    '첨부된 파일명이 리스트업 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-528';
SET @content_hash = '525f3d6b773c06660c5c5eae4712416aa5938cc39ffe23b980c18981b3875caa';
SET @sort_order = 168;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[파일 업로드] 화면에서 첨부된 파일명 우측 옆 [x]버튼을 클릭한다.',
    '업로드한 파일이 삭제된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-529';
SET @content_hash = '3e22a6489f0bb34f4d3da6e7d04a9a349163af072cb1ddd3d6df713b9760f511';
SET @sort_order = 169;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[파일 업로드] 화면에서  [등록] 버튼을 클릭한다.',
    '파일업로드에 성공한 경우 -> 성공 얼럿 출력
파일 업로드 실패한 경우 -> 실패 얼럿 출력
해당 팝업이 닫히고 [손님서류등록] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-530';
SET @content_hash = 'c736128cbe759990dcd66dc61f99a8f38ee882208a2cc481e3cea5bde718fe2a';
SET @sort_order = 170;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[손님서류등록] 팝업의 [다운로드] 버튼을 클릭한다.',
    '해당 파일을 다운로드하여 확인할 수 있다. (최대 5분 소요)',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-531';
SET @content_hash = '3c663d17637c4e78c30530cfde63af6d346d7d1d6037a0d47c46b4edfcfdd5f4';
SET @sort_order = 171;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[손님서류등록] 팝업의 [저장] 버튼을 클릭한다.',
    '팝업창이 닫힌다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-532';
SET @content_hash = 'a538d5dd0c06e1df3df04f31a8f240e4496b7fd766afea748e4398b36b4722e1';
SET @sort_order = 172;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_심사',
    '-',
    '현황 : 심사, 승인',
    '[품의등록] 화면에서 정보 입력 완료 → [품의등록 요청] 버튼을 클릭한다.',
    '[품의등록] 완료시, 완료 얼럿이 출력한다. 
버튼명 - 품의등록 완료 로 변경',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-533';
SET @content_hash = 'e9a1584a3ba00de13f6dd141ef283dbe5b7567bddf979ba83c7e132e2ce04d4b';
SET @sort_order = 173;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의요청',
    '"심사"상태의 품의등록 완료 시 상태이며
하나인 - 품의등록 "저장" 버튼 미실행 단계',
    '견적서 발송 / 견적서 보기 / 서류추가 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-534';
SET @content_hash = 'f46d3f3572650364c7c83214e39d56681314c9717d426ba50582a6a232129b2c';
SET @sort_order = 174;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의요청',
    '[견적서 발송] 버튼을 클릭한다.',
    '[견적서 발송] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-535';
SET @content_hash = 'c27ab3097d49ba61e81ed08981a68e5d490273ce45699e0b46289b7a5f8b7d08';
SET @sort_order = 175;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의요청',
    '[견적서 보기] 버튼을 클릭한다.',
    '[견적서 보기] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-536';
SET @content_hash = '83c8a77f527a92deec2a2e8fde3f91dd4f9b3a6fafccd730e25bcf823ab37643';
SET @sort_order = 176;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의 확정',
    '하나인 - 품의등록 "저장" 버튼 실행 하면',
    '견적서 보기 / 서류추가 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-537';
SET @content_hash = 'b2dd92feb830866ba759d488c1e8fc808ce98e1ba8c9be010ee8a9b8f58ff1b7';
SET @sort_order = 177;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의 확정
법인사업자',
    '하나인 - 품의등록 "저장" 버튼 실행 하면',
    '견적서 보기 / 서류추가 등록 / 연대보증계약서 다운 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-538';
SET @content_hash = '26c2f43b09af743da448d3cc66e4ea3bfca52de784525abc716c61db65cda68a';
SET @sort_order = 178;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황 : 품의, 품의 확정',
    '[견적서 보기] 버튼을 클릭한다.',
    '[견적서 보기] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-539';
SET @content_hash = '906c9a89df5d51caccf81f520347d1183e1b24fbed6733ec00a4a98ac1b89ace';
SET @sort_order = 179;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_품의',
    '-',
    '현황: 품의, 품의확정
법인사업자',
    '연대보증계약서 다운 클릭시',
    '연도보증계약서 pdf 파일이 다운로드 된다.
연도보증계약서 pdf 파일을 열면 정상표기 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-540';
SET @content_hash = 'd24daea8d17a7ca2736abff66f880fd2a494a134182b8acc21518f474c7ef58d';
SET @sort_order = 180;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '리스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '리스_인도',
    '-',
    '현황: 인도, 송금완료
시승차',
    '하나인 - "선급완료" 처리 시',
    '서류 등록 / 견적서 보기 버튼 유무를 확인한다.
*시승차는 차량번호 등록할 필요가 없어서 ''차량번호 등록''버튼 없음',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

UPDATE test_cases tc
INNER JOIN test_scenarios ts ON ts.id = tc.test_scenario_id
LEFT JOIN tmp_import_test_cases imported
    ON imported.scenario_code = tc.scenario_code
   AND imported.case_code = tc.case_code
SET tc.is_current = 0,
    tc.is_deleted = 1,
    tc.deleted_at = COALESCE(tc.deleted_at, CURRENT_TIMESTAMP),
    tc.updated_at = CURRENT_TIMESTAMP
WHERE ts.test_run_id = @test_run_id
  AND tc.is_current = 1
  AND tc.is_deleted = 0
  AND imported.case_code IS NULL;

DROP TEMPORARY TABLE IF EXISTS tmp_import_test_cases;

COMMIT;

