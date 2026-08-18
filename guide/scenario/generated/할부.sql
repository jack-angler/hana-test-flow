START TRANSACTION;

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @test_run_name = '할부';

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

SET @scenario_code = 'SN-IF-500';
SET @scenario_name = '할부-제휴';
INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)
VALUES (@test_run_id, @scenario_code, @scenario_name, 1)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    sort_order = VALUES(sort_order),
    updated_at = CURRENT_TIMESTAMP;

SET @scenario_code = 'SN-IF-600';
SET @scenario_name = '할부-비제휴';
INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)
VALUES (@test_run_id, @scenario_code, @scenario_name, 2)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    sort_order = VALUES(sort_order),
    updated_at = CURRENT_TIMESTAMP;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-500';
SET @content_hash = 'eec35e35738359bbfd3b66b714dff33b2e578f574dc25e1ed8bc3c82b2b91409';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부-가견적',
    '-',
    '로그인',
    '하나원큐오토>수입차할부론 메뉴명 선택하여 새 견적을 진행한다',
    '견적 진행시,
고객 구분 : 개인/ 개인사업자 / 법인 사업자 중 선택
오토할부 / 제휴사 있음',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-501';
SET @case_code = 'CASE-IF-501';
SET @content_hash = 'c46cc492b3dcdcf260394b6d589e985c92b169cec6bbfa9d2404201bd966f538';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부-가견적',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-502';
SET @content_hash = '5a242b1e650cefb50f2ed1c9ef72eb1bf4462378698ce5644e8636a42e3a50e6';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부-견적',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-503';
SET @content_hash = '5868a81a5be474a018734555119538376df4967a87c38fa499eb4b364b268699';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부-견적',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-504';
SET @content_hash = 'ef9a9b33e4234c05d5661f34438dc3370084ca3ff925eb67ef7ef3cc15270a1d';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부-견적',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-505';
SET @content_hash = 'ab9b4889afd68c287c610c65c8b05a0339909353f52cffe6cf4b3671fd3e1041';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부-견적',
    '-',
    '현황 : 견적, 동의완료,',
    '견적 동의완료 케이스 - 신용조회 완료 상태일 경우',
    '[상세조회] 버튼 클릭하여, 
해당 정보 확인과 하단에 재견적, 견적서 발송, 견적서 보기, 심사신청 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-506';
SET @content_hash = 'cf9f958e4d1e74d63ee0eefcab1cec6cb11930890caa9583a3778ab0d6566d90';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부-견적',
    '-',
    '현황 : 견적, 동의완료,',
    '[심사신청] 버튼을 클릭한다.',
    '캐피탈 심사신청'' 팝업이 출력한다.
팝업 내 심사 대상을 체크하여 심사 신청을 한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-507';
SET @content_hash = '8034a74e1ef579d4415e72dea7dd0ccec138ca77468d109268dd4d0ba4dd4e55';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
    '-',
    '현황 : 심사, 승인',
    '심사 상태 값 : 자동 승인, 
승인 된 상태 ''승인'' 노출',
    '재견적 / 견적서 발송 / 견적서 보기 / 서류추가등록 / 품의등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-508';
SET @content_hash = 'de0db4ebfbbd75b203a5df93811fa4116e43b6690c8b2b0c8877426aa45dab96';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
    '-',
    '현황 : 심사, 상담중',
    '심사 상태 값 : 자동 승인 외 건은 ''상담중'' 노출',
    '재견적 / 견적서 발송 / 견적서 보기 /서류등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-509';
SET @content_hash = '81aebedaff69d1cde4b03d407c2e875d833081942350cf8eac4640217046d722';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
    '-',
    '현황 : 심사, 부결',
    '심사 상태 값 : 시스템 거절 건은 ''부결'' 노출',
    '재견적 / 견적서 발송 / 견적서 보기 /서류등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-510';
SET @content_hash = 'c0260f5575cb846c0686bd1f8878f51e6786d9644d2dc07859b0b3f332129132';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-511';
SET @content_hash = 'b1772adc8bebe26db1f48f70ec13a00a8017b4ac1d880c00303de53dd9d3d63b';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
    '-',
    '현황 : 심사, 배정
개인',
    '계약자 정보 확인',
    '성명, 생년월일, 진행일정, 상품명',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-512';
SET @content_hash = '20277b55296f907a78cb2c172501bb3990985848df908348d2f285983b6a01ad';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
    '-',
    '현황 : 심사, 배정
개인사업자',
    '계약자 정보 확인',
    '회사명,대표자 성함, 대표자 생년월일, 사업자번호',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-513';
SET @content_hash = '5be0ce1f916b167701cbcb9538573e3d9b735b6d05f6062e0f4a520848893cee';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
    '-',
    '현황 : 심사, 배정
법인사업자',
    '계약자 정보 확인',
    '회사명,대표자 성함, 사업자번호, 법인등록번호, 연대보증인성함, 연대보증인 생년월일',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-514';
SET @content_hash = 'c8c671265e93fe3db594420f4e04b3060b671a1849dcca8ef44c2e9b7f5fb9f7';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
    '-',
    '현황 : 심사, 승인
할부(오토할부) – 수입차- 제휴',
    '노출 정보 확인',
    '판매점 정보((브랜드, 딜러사 전시장(판매대리점), 판매사원)
영업사원정보 (영업사원)
차량대금 송금계좌 (지급처, 계좌번호)
서류등록',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-515';
SET @content_hash = 'cb1e5a7b6fa49cb376cc0eaff138148a2e344b7dd4f7d17776d1645af58baae2';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
    '-',
    '현황 : 심사, 승인
할부(오토할부) – 수입차- 제휴',
    '수입차 제휴사인 경우, 딜러사 항목',
    '견적에서 선택한 제휴사를 디폴트로 노출(변경불가)',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-516';
SET @content_hash = '46ef30a3e274dfa6a14077c76294f609fc44fa51a41f6c0f3cccba5f67f8e782';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
    '-',
    '현황 : 심사, 승인
 수입차- 제휴',
    '수입차 제휴사인 경우 → 전시장(판매대리점) 에 검색을 선택하고  [판매점 조회 팝업] 화면에  검색어를 입력 후 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 딜러사 속하는 전시장 리스트 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-517';
SET @content_hash = '93e4337a2be3dde4f6bb73c42ed981a7ce844b2a6d8841cc56895a2330a8adb2';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-518';
SET @content_hash = 'c6427ba6a48b060b9fa94808b7ce7bc679af14fbc6151c77b8ab6a2b5a3b8aff';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-519';
SET @content_hash = 'd5a586d1b4de8f8acb5c95418763f0904bcbb1fa077eaad7894e5b46a3fed74a';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-520';
SET @content_hash = 'f67bf21b07091a35f9a98b369ac711b34e67d5060b66b0a031a48bcbe66b7dbe';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-521';
SET @content_hash = '4545f2df32b6b1c6136301dd2a0c478d26dbb70d1246f447f6528672b78a666b';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-522';
SET @content_hash = '0c16e7ad3e3983a20d25ab0dcdebc5d8e5cae63a1b7698e166d43d09da828a2e';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-523';
SET @content_hash = 'a925270ce7e534cb953171c3d51a1a996433446dc5ee2b30b70cc51d20502a01';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
    '-',
    '현황 : 심사, 승인
할부(오토할부) – 수입차- 제휴',
    '차량대금(계약금)송금계좌 ''지급처'' 항목 선택',
    '판매대리점(가상)(디폴트), 판매대리점 중  선택',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-524';
SET @content_hash = '461a29374cd2f5ae7ee6728dab70fb5e66170910b0ac4236abdc81ad3088ea34';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-525';
SET @content_hash = '82df449a63ca2583cbdcaa4ae255f5f0579be8e3c1649f641c90e70cc80ef84e';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-526';
SET @content_hash = '645c73104e5a6224fbfebcd64a8a5b605d0dc79cd0239620a6b697a42cff226a';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-527';
SET @content_hash = '2c07f01686dbe90f2db1a22aa67955f6880edcdd6533dda848fd88a536aece3c';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-528';
SET @content_hash = 'b48f0a5c1009e530138fa2ad6bd891d64cdce1ececb4c2f80c30e6fae6c8b50b';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-529';
SET @content_hash = 'e651d42ab9444506eeb08942e767408761508d1b8bcbcfa83a1618732fc8a937';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-530';
SET @content_hash = '815b36f18b78bed45c1ba061889be2255bc517a7a0759c54ffdb2bc9b3e66f95';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-531';
SET @content_hash = 'fd23785b2074c37e246d97140b2c26a39f25d7383cbe80698854577e9c217011';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-532';
SET @content_hash = '1d207f4c65eb92e5de90b757faf2f1c59d6bb5cc1e3e7d5032c85fa178d2334a';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-533';
SET @content_hash = '461b1d4bc9ddae298954a6a336c896bd5df11ad96ebdb71b15ec4c0d278006c1';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-534';
SET @content_hash = '123e267457dab51c9aa2a59e23121a8dffdeed25ccbb3cd82323d89d39db68f7';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_품의',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-535';
SET @content_hash = '8977325de3f21fa0a872a1584844a6956c387d61bbafdd34b4109b044bf44bb7';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_품의',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-536';
SET @content_hash = 'e87b7c88c0dc7678097ba9f56403dc97ca35e23a3cafd19190cf3f4051c14b62';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_품의',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-537';
SET @content_hash = '323887e218e4f0edecb74c59b82ec00fe9b20a426beea9567fdf003b19d72d9a';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_품의',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-538';
SET @content_hash = '96577417ebb3b3c1c3365e7c59add419ea651c39a63a0a6694ca6f2aeb2970e0';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_품의',
    '-',
    '현황 : 품의, 품의 확정
법인사업자',
    '법인사업자의 경우,',
    '견적서 보기 / 서류추가 등록/연대보증계약서 다운  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-539';
SET @content_hash = 'e7fd63974fe7b45c2a0f7f58e5e203a016bb2cd4310142b259f3ed7e5bb8b8f0';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_품의',
    '-',
    '현황 : 품의, 품의 확정
법인사업자',
    '연대보증계약서 다운 버튼 클릭시,',
    '연대보증계약서 다운  pdf 파일 다운',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-540';
SET @content_hash = 'd542290b8a6c6dc9a5291607081f15a70dc9c7a68ca667a8864661ea90418d0d';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_품의',
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

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-541';
SET @content_hash = '34c94adbbdf8821cf8260b0777e044ec8346a82408f37e0ee0cdc411c945595d';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_인도',
    '-',
    '현황: 인도, 송금완료',
    '하나인 - "대금지급등록 완료" 처리 시',
    '서류 등록 / 견적서 보기 /차량번호 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-542';
SET @content_hash = 'd5af50bfafc6b4610e9277676cbbd0ae3f7f3e8a9280e7fd3b2aac88f702a1d2';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_인도',
    '-',
    '현황: 인도, 송금완료',
    '[차량번호 등록] 버튼을 클릭한다.',
    '[차량번호 등록] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-543';
SET @content_hash = 'd3cfdbe5b51c87279220997c5fb52bb29b75fcc211bb4372ad4bc5847b69af59';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_인도',
    '-',
    '현황: 인도, 송금완료',
    '[차량번호 등록] 화면에서 차량번호를 입력 후 [확인] 버튼을 클릭한다.',
    '차량번호가 입력된 상태로 비활성화 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-544';
SET @content_hash = 'fec38c3e462ee3810b65154d192cfed5a82a64b41ff7eede0147932e315f1f8a';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_인도',
    '-',
    '현황: 인도, 송금완료',
    '[차량번호 등록] 화면에서 [확인] 버튼을 클릭한다.',
    '차량번호가 등록된다. [차량번호 등록] 화면이 닫힌다. [차량번호 등록] 버튼이 [번호등록 완료] 버튼으로 바뀐다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-545';
SET @content_hash = '591479ead1417ce0a12ee6df56f6c865fe852de5fb84ff2614a99948ae5be98f';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_인도',
    '-',
    '현황: 인도, 실행완료',
    '하나인 - 대금지급등록 후 "실행" 버튼 눌러서 
채권번호 "L" 채번 시',
    '[차량번호 등록] 후 [번호등록 완료]로 변경',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-600';
SET @content_hash = '5c137545a001c1c30f4c665deeef0e6eee5b43c535e3e3219592084f57676a72';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부-가견적',
    '-',
    '로그인',
    '하나원큐오토>수입차할부론 메뉴명 선택하여 새 견적을 진행한다',
    '견적 진행시,
고객 구분 : 개인/ 개인사업자 / 법인 사업자 중 선택
오토론 / 비제휴사 (견적에서 제휴사 미선택)',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-601';
SET @content_hash = 'aa9b4041871a72cb1f834f248ee54c6909ccfe2eff148b5076f6318ef7ac0985';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부-가견적',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-602';
SET @content_hash = '8bd48c74543aa25ac61aaf89ed5bdd8f3564aa31afe1ba19a9a516dad59dfeee';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부-견적',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-603';
SET @content_hash = '884957222348d03c64e2844173014d86906527ce6759f5dc6e9639defa7fd9fe';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부-견적',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-604';
SET @content_hash = '3a5acd8fe4ffb300a129ceb39fa9cd605433342acd7183a142176acd4df7bff7';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부-견적',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-605';
SET @content_hash = '9967b7289e32dadb7ebe9111f61f876fa61c94cea59910c23e0bf591775e0aa8';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부-견적',
    '-',
    '현황 : 견적, 동의완료,',
    '견적 동의완료 케이스 - 신용조회 완료 상태일 경우',
    '[상세조회] 버튼 클릭하여, 
해당 정보 확인과 하단에 재견적, 견적서 발송, 견적서 보기, 심사신청 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-606';
SET @content_hash = '91cbf22111992d9f610e402ff0b60a02c9084fed376c5935314f7e28a24e3dda';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부-견적',
    '-',
    '현황 : 견적, 동의완료,',
    '[심사신청] 버튼을 클릭한다.',
    '캐피탈 심사신청'' 팝업이 출력한다.
팝업 내 심사 대상을 체크하여 심사 신청을 한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-607';
SET @content_hash = '1f5fb3df2eda6fca2fa7e1c7fdc2b346dd89441418311ed92a1ac8829a818bbd';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
    '-',
    '현황 : 심사, 승인',
    '심사 상태 값 : 자동 승인, 
승인 된 상태 ''승인'' 노출',
    '재견적 / 견적서 발송 / 견적서 보기 / 서류추가등록 / 품의등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-608';
SET @content_hash = '34f2e9bd7cf51d20030acfc662b54194927f9a6badda0c6e7de9d362c2063e86';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-609';
SET @content_hash = 'be890eb0174dac13b5d6712cce56ab6297c297077dd18c4d55fe57327532523a';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-610';
SET @content_hash = '3627dc85c58aa903dc5ad0ddf4937c2bb1eab371da37dfcdfc74cb00592b3693';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-611';
SET @content_hash = 'f7478bf00279658e5499f762e8f3c8f70717febd34ecb7cab8abf113885e0c74';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-612';
SET @content_hash = 'b6db9a2c7b1c8661de7bd4a5a41436b2c79538b84dabac0290573bd220719697';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-613';
SET @content_hash = 'e9314459be279cdf01d10d79906ec28ff220622cd6a7eb1d816dd41259549b04';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-614';
SET @content_hash = 'a6c1b8d27a852c7de71e8dec8fdefeacb4aa4a5e5fcd41884667bc40b7b7c700';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
    '-',
    '현황 : 심사, 승인
할부(오토론) – 수입차-비제휴',
    '노출 정보 확인',
    '판매점 정보(브랜드, 딜러사, 전시장(판매대리점), 판매사원)
영업사원정보 (영업사원)
차량대금 송금계좌 (지급처, 계좌번호)
서류등록',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-615';
SET @content_hash = '1a5810b0e570babc8a6d0a7d4ce681470ec00fad396a3fe854e0697041a79146';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
    '-',
    '현황 : 심사, 승인
 수입차- 비제휴',
    '(견적에서 제휴사 미선택 시), 
딜러사 영역 활성화, 검색 버튼 클릭',
    '판매점 조회 팝업 출력 후 , 비제휴 딜러사만 리스트되어 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-616';
SET @content_hash = 'dc5a38a749e00987b9d01564ee7478564a43a674f4c8668fda4300e6a7cf3a36';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
    '-',
    '현황 : 심사, 승인 
수입차-비제휴',
    '수입차- 경우 → 전시장(판매대리점) 조회 영역',
    '판매점 조회 팝업 출력 후 , 수입차 비제휴 딜러사만 리스트되어 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-617';
SET @content_hash = '1315b4dfef90b77d15d400718a1ff50bdc7c92ae7ae682304e2d66b5f653a3d3';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-618';
SET @content_hash = 'c96ac0560213a02fb0cf526e5611a4291c5af33638b1e610163706eaf9770ed1';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-619';
SET @content_hash = '34e828a90238f3191bbf56060f271642607834c22a1a1aaeb071162d68dcf349';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-620';
SET @content_hash = 'a2b519a59d13a7eabbe7d2e6acb2bd756f3ca84bf09ea43c0bd326c9dbc8087e';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-621';
SET @content_hash = '257cbc4441225dce89fcff4b180c9bf2c98e446fd9a0c9ff266d258816444c46';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-622';
SET @content_hash = 'd1155dcb90a5fb3c44ab9c9ff853f4abca67dd8c77bb4636604b5ac311371ca0';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
    '-',
    '현황 : 심사, 승인
할부(오토론) – 수입차-비제휴',
    '차량대금(계약금)송금계좌 ''지급처'' 항목 선택',
    '판매사(가상)(디폴트), 고객(가상)  중  선택',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-623';
SET @content_hash = '27d44bca4e8c0fa27e8d68858ad56c52509f49d003b09f010afe7ac89d1de6e4';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-624';
SET @content_hash = '335f4baa3b41411bbefe2aa4a85ecc0463bcf94c4385c0fceb0b433126f4f28b';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-625';
SET @content_hash = '670679d29a46d0c72f63685522002c00732139b8bc80c3700e4908f3d6cc8a1e';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-626';
SET @content_hash = '47d3a6c2f8d04757c9a82e2019fb192b5b0cacde6117bc7671ec75a08d5f0c47';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-627';
SET @content_hash = '7b0bc153d303be3f54cbf0cbfd36b7b462c4c468a489b4231fe8136fad53f5b8';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-628';
SET @content_hash = 'f089870e45dc88a6f59038beddc7f0b46f7c4578633751e097e0b3c07521b55e';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-629';
SET @content_hash = '5afe4c083756d3aecdc0f9bec4476e0f4192ab1151a7768ea8470828824eb400';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-630';
SET @content_hash = '213a4e752f7915ecfd9b8a2b18764581ed0190dc7e208d17a3497aee4061c411';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-631';
SET @content_hash = '67a64a9c8562f9ee67cbbb9b7b1ca9183fb6691f5ba9691e8d723e641fe055a3';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-632';
SET @content_hash = 'ad1f7d3cd938234aaf4e1201556cada39821283403ec703bda2c23f79f4cdb58';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_심사',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-633';
SET @content_hash = '269ab25919d01259e405814746847890e8d6ac17c842202f47e6db9a2dfbe0bc';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_품의',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-634';
SET @content_hash = 'a534eccb430a938229245939367ad971cfa2ddfaeddd6b510c1f4c54d498cde8';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_품의',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-635';
SET @content_hash = 'fa1001e6dd952e44a75b0e29ebfad0abfb59671c7f5a30e745b42bc460404f10';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_품의',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-636';
SET @content_hash = '607a2c5e97e62c384c2b990a76491e40a3e81e3a9e261802ceafaebb96e0637a';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_품의',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-637';
SET @content_hash = '1ddb728d89d85c1fc68f6aeec96d35b4e2ef395e327411c09ee9fdbd271f1f0c';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_품의',
    '-',
    '현황 : 품의, 품의 확정
법인사업자',
    '법인사업자의 경우,',
    '견적서 보기 / 서류추가 등록/연대보증계약서 다운  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-638';
SET @content_hash = '6d6b3b90708261431072e5f36c081ae66e6e89e1caf42aeddcd6b2fdb713447a';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_품의',
    '-',
    '현황 : 품의, 품의 확정
법인사업자',
    '연대보증계약서 다운 버튼 클릭시,',
    '연대보증계약서 다운  pdf 파일 다운',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-639';
SET @content_hash = 'f0d4999586d1564f21ed3ff32967f4bd4c985d2b9d80f08b862b6bbc5d6741b4';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_품의',
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

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-640';
SET @content_hash = '1a9c9fa12b42d2391780e17d32e62979f5dad8cc73f4b755e8b697df62495f31';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_인도',
    '-',
    '현황: 인도, 송금완료',
    '하나인 - "대금지급등록 완료" 처리 시',
    '서류 등록 / 견적서 보기 /차량번호 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-641';
SET @content_hash = '12949e1e023c7d2cc552c50238710fac59b3ee7811aedcdfdb67188ad29f1c31';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_인도',
    '-',
    '현황: 인도, 송금완료',
    '[차량번호 등록] 버튼을 클릭한다.',
    '[차량번호 등록] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-642';
SET @content_hash = '318c038a71996a9b506a86aa10b63f492922406f83de0150dfca50cef25cc300';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_인도',
    '-',
    '현황: 인도, 송금완료',
    '[차량번호 등록] 화면에서 차량번호를 입력 후 [확인] 버튼을 클릭한다.',
    '차량번호가 입력된 상태로 비활성화 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-643';
SET @content_hash = '690c7fa5db1deeeba5ed44889187d356044f3f4e6b86295ec9acd7ba0df154c7';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_인도',
    '-',
    '현황: 인도, 송금완료',
    '[차량번호 등록] 화면에서 [확인] 버튼을 클릭한다.',
    '차량번호가 등록된다. [차량번호 등록] 화면이 닫힌다. [차량번호 등록] 버튼이 [번호등록 완료] 버튼으로 바뀐다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-644';
SET @content_hash = 'a63852519d56c3e741035f2dc15642a024cf40175e0d4b605f1553284d0a3b5e';
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
    '할부',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '할부_인도',
    '-',
    '현황: 인도, 실행완료',
    '하나인 - 대금지급등록 후 "실행" 버튼 눌러서 
채권번호 "L" 채번 시',
    '[차량번호 등록] 후 [번호등록 완료]로 변경',
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

