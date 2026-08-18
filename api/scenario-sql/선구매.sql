START TRANSACTION;

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @test_run_name = '선구매';

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

SET @scenario_code = 'SN-PO-500';
SET @scenario_name = '선구매';
INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)
VALUES (@test_run_id, @scenario_code, @scenario_name, 1)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    sort_order = VALUES(sort_order),
    updated_at = CURRENT_TIMESTAMP;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-500';
SET @content_hash = '1e250cfae3da1e717017bf94c80e0d68f3b5166a2f779d56582742e411356299';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_가견적',
    '-',
    '로그인',
    '하나원큐오토> 선구매 메뉴명 선택하여 새 견적을 진행한다',
    '견적 진행시, 
차종 국산차 또는 수입차 선택
고객 구분 : 개인, 개인사업자, 법인 사업자 중 선택',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-501';
SET @content_hash = 'd806dce80a9da5038dcff15d493295dfead67bfade24b60194da333e8463bf80';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_가견적',
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

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-502';
SET @content_hash = '6d571e430c3716227f5d7c06d4bb48290fa34ba61ca5b699ca3073475f090bea';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_견적',
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

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-503';
SET @content_hash = '95e338b9d7a6edea7cbb9d8b58ae94ba88b4ac162f8a62e395349f6508d31e2f';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_견적',
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

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-504';
SET @content_hash = '0b94fa1cd26d80985f8c4bb69b9762a233009dbeaa682146e149dfbdbe999d08';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_견적',
    '-',
    '현황 : 견적, 동의완료,',
    '견적 동의완료 케이스 - 신용조회 완료 상태일 경우',
    '[상세조회] 버튼 클릭하여, 
해당 정보 확인과 하단에 재견적, 견적서 발송, 견적서 보기, 운전자격검증, 심사신청 버튼 유무를 확인한다.
운전자격검증 버튼은 렌터카, 신용조회동의완료, 개인, 개인사업자만 노출된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-505';
SET @content_hash = '2d7ba0f8150d71f10aa458cc6fe178a17577356fbdd18e1045fabf641b36c325';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_견적',
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

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-506';
SET @content_hash = '9a81c5c04d8405a5434d75d3c9b681f9c9172c3cc53fe37eff056f037ddc85e2';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 승인',
    '심사 상태 값 : 자동 승인, 
승인 된 상태 ''승인'' 노출',
    '재견적 / 견적서 발송 / 견적서 보기 / 서류등록 / 발주요청 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-507';
SET @content_hash = '42a9f7792c10f1a46f1ebd75c9255c8fc251ba49520ff9526c58effe04c1621c';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
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

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-508';
SET @content_hash = '35f0a4920f478bc0df8e362445d8ee2e154347427b93e1ffa3c62e6c8f67821b';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
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

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-509';
SET @content_hash = '27a4e9917a9d09366de0672a2c2f0a646e667a17c24e5bc0687c17d50c5bfeea';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 발주요청
렌터카(특판출고)',
    '[발주요청] 버튼 클릭한다.
심사 상태 값 : “승인“ 상태에서 “발주요청” 완료의 경우',
    '발주 요청 진행 팝업 → 발주요청 완료 얼럿 내, 확인 버튼 클릭시
''발주요청'' 버튼  →  ''발주요청 완료'' 로 버튼명이 변경되고 버튼 비활성화 

▶ 견적서 보기 / 서류추가등록 / 발주요청완료(비활성화) 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-510';
SET @content_hash = 'e79604833e31e80c303a636f55ced6463c8a54af0b7770cbbc01fdaab8a2df35';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 발주완료
렌터카(특판출고)',
    '하나인 - 통합발주관리 "발주완료" 상태의 경우',
    '견적서 보기 / 서류추가등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-511';
SET @content_hash = 'e1768ea48e0162a8a5c33a0c9af46c084398501f26008b5b7e63d51dc1ba9286';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정
렌터카(특판출고)',
    '하나인 - 통합발주관리  "배정" 상태의 경우',
    '견적서 보기 / 서류추가 등록 / 품의등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-512';
SET @content_hash = '02a21b3df967f6e69583a06231b7122bf0673c75fb4eff60340fa18f95d05891';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정',
    '[품의등록] 버튼을 클릭한다.',
    '[품의등록] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-513';
SET @content_hash = '72e77d92fad09012c1bf1f6f1572df8d8a784bfd84c7a3623040cccfc0b11ef8';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
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

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-514';
SET @content_hash = '962d36cda6e3236a404c4193f3d0a7de70fe5e034acee383ee103a9a0f1e8390';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
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

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-515';
SET @content_hash = '797f197ddd615d622429de9e0859d925d20dbb2fefa8dc2058b74174dacae051';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
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

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-516';
SET @content_hash = '78672050adc31526a3c20d6ad9f544673ca071eb1fd95fc647d5f76e1c05ac7c';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정
국산차',
    '노출항목 확인',
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

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-517';
SET @content_hash = '02baddb7164d43838d17fd498aee83f2c0bc341094f512b509997ee2dc675aed';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정
수입차',
    '노출항목 확인',
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

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-518';
SET @content_hash = '595b33635e3c608e3afc4c623bc79724767896582525fef6a41ca9d5d4a91e1f';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정
국산차',
    '[품의등록] 화면에서  판매점 정보를 확인하기 위해 판매 대리점 검색을 진행 한다.',
    '[판매점 조회 팝업] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-519';
SET @content_hash = 'c39893e5a8b5a9e03a1b93582b73f0d2072bcd0d81fb1ee95ed2034fe0a3f79f';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정
국산차',
    '조회 결과가 있을 경우 → [판매점 조회 팝업] 화면에 검색 조건을 선택하고 검색어를 입력 후 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 결과가 조회된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-520';
SET @content_hash = '8140f30f5031817936e8410cb37cf83ccc09c20f22f07ff0a006435c5a1fc70a';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정
국산차',
    '조회 결과가 없을 경우 → [판매점 조회 팝업] 화면에 검색 조건을 선택하고 검색어를 입력 후 [조회] 버튼을 클릭한다.',
    '조회결과가 없을 경우, 조회결과 영역에 ''검새 결과가 없습니다'' 문구가 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-521';
SET @content_hash = '065ed4b88bb1f9afc16241963e3fca5d1c97c15931859c4a4a9a5a18e87eb5aa';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정
국산차',
    '[판매점 조회 팝업] 화면에 검색 결과를 클릭한다.',
    '[판매점 조회 팝업] 화면이 닫히며, [품의등록] 화면에서 선택값이 판매대리점 영역에 반영된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-522';
SET @content_hash = '4bd939a968848d4abbdc6fdf4c3f992b01a938b66957052667fd78f81dc05e49';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정
국산차',
    '[품의등록] 화면에서 판매사원 [검색]버튼을 클릭한다.',
    '[판매사원 조회 팝업] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-523';
SET @content_hash = '282ee4f2ae8feb076a7488c015ea2863f174cc6d7667fcfb782e3f220b478a7b';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정
국산차',
    '조회 결과가 있을 경우 → [판매사원 조회 팝업] 화면에서 조회조건 조회 값을 입력하여 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 결과가 조회된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-524';
SET @content_hash = '134adb7a461f8107c336edcad51445504acddd4d8de8adc1be3960be47ab923d';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정
국산차',
    '조회 결과가 없을 경우 → [판매사원 조회 팝업] 화면에서 조회조건 조회 값을 입력하여 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 ''검새 결과가 없습니다'' 문구가 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-525';
SET @content_hash = 'bf55b876558439b5767ebd9c0955b74ef2d0caf74ae07ab45e7538fdaccc2402';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정
국산차',
    '[판매사원 조회 팝업] 화면에 검색 결과를 클릭한다.',
    '[판매사원 조회 팝업] 화면이 닫히며, [품의등록] 화면에서 선택값이 판매사원 영역에 반영된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-526';
SET @content_hash = '3dfba81d156d242c554e1bf6ec90157304add059425e2fa7bd2342bb3e9e1c0a';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정
수입차-제휴사',
    '제휴사인 경우, 딜러사 항목',
    '견적에서 선택한 제휴사를 디폴트로 노출(변경불가)',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-527';
SET @content_hash = '013a1f433f9da6e4f432e59306117e2394b9f2c489fe1e4c2a232b4d23006458';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정
수입차-비제휴사',
    '수입차 비제휴사 경우(견적에서 제휴사 미선택 시) → 딜러사 항목 활성화 [검색]버튼 클릭시',
    '판매점 조회 팝업 출력 후 , 비제휴 딜러사만 리스트되어 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-528';
SET @content_hash = 'ee262df8aee15c09eca2055283307964bb64e24a7a037b49159d4fd4ff439e15';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정
수입차-비제휴사',
    '수입차- 경우 → 전시장(판매대리점) 조회 영역',
    '판매점 조회 팝업 출력 후 , 수입차 비제휴 딜러사만 리스트되어 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-529';
SET @content_hash = '0bbadf136c9940fa734c37744ec983ddb79a6da5e6655efdfe92684d46e29d50';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정
수입차-제휴사',
    '수입차인 경우 → 전시장(판매대리점) 에 검색을 선택하고  [판매점 조회 팝업] 화면에  검색어를 입력 후 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 딜러사 속하는 전시장 리스트 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-530';
SET @content_hash = '471bc25b33190fdef077023acec069c6643c54955832be828694ebac3f100596';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정
수입차-제휴사',
    '전시장(판매대리점) [검색] 버튼 클릭, [판매점 조회 팝업] 화면에 검색 조건을 선택하고 검색어를 입력 후 [조회] 버튼을 클릭한다.',
    '검색 결과가 없는 경우 조회결과 영역에 ''검색 결과가 없습니다'' 문구가 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-531';
SET @content_hash = 'e42efc750860c70b33d919069e158c17726f0224f27148b2df95d06247b11e71';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정
수입차-제휴사',
    '[판매점 조회 팝업] 화면에 검색 결과를 클릭한다.',
    '[판매점 조회 팝업] 화면이 닫히며, [품의등록] 화면에서 선택값이 판매대리점 영역에 반영된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-532';
SET @content_hash = 'bee5cce78c5f770a0cc4932bb89d459064f641b00fc8f00a3d77baf9ee3c1967';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정',
    '[품의등록] 화면에서 은행 영역을 클릭한다.',
    '[은행 선택] 영역이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-533';
SET @content_hash = 'f423acf16f9f27b8046b2bb7a4ca9dc0dfa28afc5869279f96479cc8fd4e9fa6';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정',
    '[은행 선택] 화면에서 은행을 선택한다.',
    '[은행 선택] 영역이 닫히면서 차량대금 송금(선택) 은행 정보영역에 선택값이 반영된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-534';
SET @content_hash = '483e752450ae7d2d7e8a836e637fe56336d4fcc22fc9f8cef6437a34d54f7d53';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정',
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

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-535';
SET @content_hash = 'f885e24a3207794971b8dc8bcc6725bfbd00ac431e337e2c210d2e29131383f3';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정',
    '렌터카인 경우 ''차량 인도 정보 입력'' 항목이 있다. 
[입력하기] 버튼 클릭한다.',
    '[입력하기] 버튼 클릭시, 인도 요청 정보 입력 팝업 출력한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-536';
SET @content_hash = 'a2a6513a8d47a347458c0c73243e78079567f1209df1ebb0de9ef613162aeac1';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정',
    '[인도요청 정보입력] 화면에서 정보를 입력한다.',
    '정보가 정상적으로 노출(측후면선팅, 측후면 선팅 투과율, 전면 선팅, 전면선팅 투과율 등)된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-537';
SET @content_hash = '4e546b091cbad0d3e4e8d0ada58a755bbdaa8a7e3406c4cd798298199599e143';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정',
    '번호판 요청사항 인풋필드에 정보를 입력한다.',
    '정보가 정상 입력된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-538';
SET @content_hash = 'a14e10d4c65130ed6bf16cfd15a7a1bd274b1df7ad97a304b485ea3d0def901b';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정',
    '요청 번호를 선택한다. (디폴트 : 무관)',
    '무관, 하 허 호 중에 선택 가능하다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-539';
SET @content_hash = '4ee5f6e6193708df6674cf7d99610273970656fb5a6cc6a1e528124c22f034ea';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정',
    '인도지 담당자, 연락처, 인도지 주소, 비고 입력한다.',
    '인풋필드에 입력가능하고, 필수값은 반드시 모두 입력한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-540';
SET @content_hash = '11d807b6c8a177d1889f986616baa0c8a6fa93c056e120316a9bb1d885347476';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정',
    '[인도요청 정보입력] 화면에서 인도지 주소 [검색] 버튼을 클릭한다.',
    '[주소 검색] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-541';
SET @content_hash = '454e901c0df9fc492bacfd49a27aca51aae6f13ba89273c0534f51fa82835e77';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정',
    '[인도요청 정보입력] 화면에서 [다음] 버튼을 클릭한다.',
    '''인도지 정보가 등록되었습니다'' 얼럿 출력한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-542';
SET @content_hash = '1a560d44adb4357b4fba4e67885d1989d8c3ab0dda4d07bb32852825e390ccd0';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정',
    '''인도지 정보가 등록되었습니다'' 얼럿에서 [확인] 버튼 클릭시',
    '[인도요청 정보입력] 창이 닫히고, [품의등록] 화면으로 돌아온다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-543';
SET @content_hash = '08897597af58fa193060fe6716ef847997517c9801766c6bfcb2430555b0490c';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정',
    '[서류등록] 버튼을 클릭한다.',
    '[손님서류등록] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-544';
SET @content_hash = '8c825863e1fd21d7def86261ea0d42a694425806c0177ddb29092ef808afa035';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정',
    '[손님서류등록] 팝업에서 [파일을 첨부해주세요 +] 버튼을 클릭한다.',
    '파일 첨부 상세페이지로 이동한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-545';
SET @content_hash = 'd4039d9eb38ea6675c442b1de124efb92836cc387cc8e0b4036a15ec2eb46406';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정',
    '[파일 업로드] 화면에서 이미지/PDF를 첨부한다',
    '첨부된 파일명이 리스트업 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-546';
SET @content_hash = '7c9f1d97fbf81a8b01fa88f55581f7eb3fb8de93a7c1f0d986ade121ae4e333d';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정',
    '[파일 업로드] 화면에서 첨부된 파일명 우측 옆 [x]버튼을 클릭한다.',
    '업로드한 파일이 삭제된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-547';
SET @content_hash = 'a6b82a25548f63b39b8c5416fc08c0952eb5d16893d25e7b767a1712b3b479cb';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정',
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

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-548';
SET @content_hash = '0626ac60fc03e9f266f07588fddc5aef63f0116c795291a406b5c886281bbfe0';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정',
    '첨부한 파일이 있는 경우 → [손님서류등록] 팝업의 [다운로드] 버튼을 클릭한다.',
    '해당 파일을 다운로드하여 확인할 수 있다. (최대 5분 소요)',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-549';
SET @content_hash = 'f205595c2f7b8b72193d2daaa76f6f4abb937bb6ac6acb1d5427e000a63b0394';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정',
    '[손님서류등록] 팝업의 [저장] 버튼을 클릭한다.',
    '팝업창이 닫힌다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-550';
SET @content_hash = '42cb268d03495ebf8f5b3b01f7aead2f61d672e4da06baa139ebe006466d768a';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_심사',
    '-',
    '현황 : 심사, 배정',
    '[품의등록] 화면에서 정보 입력 완료 → [품의등록 요청] 버튼을 클릭한다.',
    '[품의등록] 완료시, 완료 얼럿이 출력한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-551';
SET @content_hash = 'faafdf87fd4db6a1fa6cb3b957b943ff545b0b0957a28d4e420a3c69aecfdbf0';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_품의',
    '-',
    '현황 : 품의, 품의요청',
    '심사"상태의 품의등록 완료 시 상태이며,
하나인 - 품의등록 "저장" 버튼 미실행 단계',
    '견적서 발송 / 견적서 보기 / 서류추가 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-552';
SET @content_hash = '1513e2a932c160e4b23d8ebb67f5c1b56eb98fad8e12360686d89d5510d75df5';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_품의',
    '-',
    '현황 : 품의, 품의요청',
    '견적 상태 : 품의요청 → [견적서 발송] 버튼을 클릭한다.',
    '[견적서 발송] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-553';
SET @content_hash = '744f24e95ccf2187e81872ec30991d43609662abd84925f2f5c7ce20897bab93';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_품의',
    '-',
    '현황 : 품의, 품의요청',
    '견적 상태 : 품의요청 → [견적서 보기] 버튼을 클릭한다.',
    '[견적서 보기] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-554';
SET @content_hash = 'c3024aac07d6f8551ee7e71678e477936b3c8e7a23ac2750d15a8807ab2aff6c';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_품의',
    '-',
    '현황 : 품의, 품의확정',
    '하나인 - 품의등록 "저장" 버튼 실행 하면',
    '견적서 보기 / 서류추가 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-555';
SET @content_hash = '67d921eb76f1da6ec2a9435f95d9d19ea120cedd766f610c2af49c04d528773c';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_품의',
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

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-556';
SET @content_hash = 'd7de5fc125fe09d984a2c97f8156be4b31f951e326a2e829dd314b585c92a4ed';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_품의',
    '-',
    '현황 : 품의, 품의 확정
법인사업자',
    '연대보증계약서 다운 버튼 클릭시,',
    '연대보증계약서  pdf 파일 다운로드가 정상적으로 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-557';
SET @content_hash = 'aad8dc05dedcdc549373fe7359e98b9ec46a42b4545f3c3c34893d3662ac9b27';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_품의',
    '-',
    '현황 : 품의, 품의확정',
    '[견적서 보기] 버튼을 클릭한다.',
    '[견적서 보기] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-558';
SET @content_hash = '2f11d1716f094d081c696049be2f9a15cf9471642fd068a446413b9daef13148';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_인도',
    '-',
    '현황: 인도, 송금완료',
    '하나인 - "선급완료" 처리 시',
    '견적서 보기  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-559';
SET @content_hash = 'c3658c6510f253da2517ebb627bdabcfad0df87f883ee19e6c6d2fbb3877af1c';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_인도',
    '-',
    '현황: 인도, 센터입고',
    '하나인 - "선급완료" 처리 후 “센터입고” 시',
    '견적서 보기/  인도요청  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-560';
SET @content_hash = '13c194680de0d0271f50d90fc73e84925422c952b9b3323450cce25fb2658fb8';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_인도',
    '-',
    '현황: 인도,  센터입고',
    '[견적서 보기] 버튼을 클릭한다.',
    '[견적서 보기] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-561';
SET @content_hash = '356f674e37bd7cc1c3f4d0e19af64e397edc659b7e8b4aa7b1601bc46174a0ad';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_인도',
    '-',
    '현황: 인도, 센터입고',
    '서류 등록시',
    '[인도요청] 버튼 활성화',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-562';
SET @content_hash = 'eaa8a7ed33bdd7bf834c250f8de9b123009d9fd919cee71f21842f0b3d9dad82';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_인도',
    '-',
    '현황: 인도, 센터입고',
    '[인도요청] 버튼을 클릭한다.',
    '[인도요청 정보입력] 화면 출력한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-563';
SET @content_hash = 'cebd0d5abc8df95437d78c45881f7ac999407260a718cf9d6c3f59b4a1d3666a';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_인도',
    '-',
    '현황: 인도, 센터입고',
    '[인도요청 정보입력] 화면에서 정보를 입력한다.',
    '정보가 정상적으로 노출, 입력된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-564';
SET @content_hash = 'b92d5460ef42b847559eabdd5d6d09af42ea1557b3ffbcead8e51c98d2b7b596';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_인도',
    '-',
    '현황: 인도, 센터입고',
    '인도지 담당자, 연락처, 인도지 주소, 비고 입력한다.',
    '필수값*은 반드시 모두 입력한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-565';
SET @content_hash = 'b9bac41371e8e3b8522962dd8ea29a58705750ffb17cbc55afa199db769b1cd1';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_인도',
    '-',
    '현황: 인도, 센터입고',
    '[인도요청 정보입력] 화면에서 인도지 주소 [검색] 버튼을 클릭한다.',
    '[주소 검색] 팝업 호출 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-566';
SET @content_hash = 'd768b87ec5c00d0ae6f50223475fc5172e94e7b72acfa22a3974af80a0bf1538';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_인도',
    '-',
    '현황: 인도, 센터입고',
    '[인도요청 정보입력] 화면에서 하단 [인도요청] 버튼을 클릭한다.',
    '안내 알럿을 표시하고 [인도요청 정보입력] 화면이 닫힌다. 
송금완료 견적의 [인도요청] 버튼이 [인도요청 완료] 버튼으로 변경된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-567';
SET @content_hash = 'e620a801de8e8bdcb76b81490fdd262d71aae6c4b41fcc82bcd679e8a5591de7';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_인도',
    '-',
    '현황: 인도, 센터입고',
    '[인도요청 정보입력] 화면에서 하단 [취소] 버튼을 클릭한다.',
    '취소시, 작성되는 내용 저장되지 않고 이전 화면으로 이동한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-568';
SET @content_hash = 'fb400a3775f0d59dfe8a4fb3202402b028c9b51945a1116403fdaf3072017ebe';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_인도',
    '-',
    '현황: 인도, 실행완료',
    '하나인 - "실행" 버튼 눌러서 채권번호 "L" 채번 시',
    '견적서 보기 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-569';
SET @content_hash = '5782e6b39d4abea876a5c283c97c9b943a0b442309350903d94265f50f682c64';
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
    '선구매',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '선구매_인도',
    '-',
    '현황: 인도, 실행완료',
    '[견적서 보기] 버튼을 클릭한다.',
    '[견적서 보기] 팝업이 표시된다.',
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

