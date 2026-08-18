START TRANSACTION;

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @test_run_name = '렌터카(대리점,특판)';

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

SET @scenario_code = 'SN-LR-500';
SET @scenario_name = '장기렌터카_대리점출고,';
INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)
VALUES (@test_run_id, @scenario_code, @scenario_name, 1)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    sort_order = VALUES(sort_order),
    updated_at = CURRENT_TIMESTAMP;

SET @scenario_code = 'SN-LR-600';
SET @scenario_name = '장기렌터카_대리점출고, 발주완료 14일 초과시';
INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)
VALUES (@test_run_id, @scenario_code, @scenario_name, 2)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    sort_order = VALUES(sort_order),
    updated_at = CURRENT_TIMESTAMP;

SET @scenario_code = 'SN-LR-700';
SET @scenario_name = '장기렌터카_특판출고';
INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)
VALUES (@test_run_id, @scenario_code, @scenario_name, 3)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    sort_order = VALUES(sort_order),
    updated_at = CURRENT_TIMESTAMP;

SET @scenario_code = 'SN-LR-800';
SET @scenario_name = '장기렌터카_특판출고, 발주완료 14일 초과시';
INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)
VALUES (@test_run_id, @scenario_code, @scenario_name, 4)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    sort_order = VALUES(sort_order),
    updated_at = CURRENT_TIMESTAMP;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-500';
SET @content_hash = '17bc21a4724bf651fa754fcfee446d96f33a4397056a5d5902eeee967b6369f6';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_가견적',
    '로그인',
    NULL,
    '하나원큐오토>장기렌터카 메뉴명 선택하여 새 견적을 진행한다',
    '견적 진행시, 대리점 출고로 선택, 
고객 구분 : 개인, 개인사업자, 법인 사업자 중 선택',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-501';
SET @content_hash = '3db3135be5ca6d96d0ffd5df6caab3a14458718740eaa9af997928fb588889ad';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_가견적',
    '로그인',
    NULL,
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

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-502';
SET @content_hash = '4bd54be4f4192b87328438f9a61ba4d0696586c234f30f53555646a1320697a2';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
    '현황 : 견적, 동의전',
    NULL,
    '현황조회에 견적 탭 클릭, 진행한 정보가 견적 탭에 있는 것을 확인한다.',
    '견적 확정 - 견적의 초기 상태값은 ''동의전''이다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-503';
SET @content_hash = '2294e6e16d2615d82cbd07f6053d87113e414d80ea9b122e291493428e50ac5b';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
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

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-504';
SET @content_hash = '4b45e5bc32012cc1e505d5e2c1a910b62e03af032193205fee65958f85a8a982';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
    '-',
    '현황 : 견적, 동의완료, 
고객구분 : 개인, 개인사업자',
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

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-505';
SET @content_hash = '10eb17a83d74b334a2264d8efa0532e258b6f9f3a0856c56a72c83b689d204ec';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
    '-',
    '현황 : 견적, 동의완료, 
고객구분 :법인',
    '견적 ''동의완료'' 케이스 - 신용조회 완료 상태일 경우',
    '[상세조회] 버튼 클릭하여, 
해당 정보 확인과 하단에 재견적, 견적서 발송, 견적서 보기, 심사신청 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-506';
SET @content_hash = '1d3668451ccfaf429b47ddc034184185cef9db85b8e4d3bd3de0b485b9b76839';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
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

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-507';
SET @content_hash = 'dba7e828e75e5ae03741f99d294b2408ecbdb2ec1d718ce9875799502289455d';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-508';
SET @content_hash = '8158b6f1c05a69f594f81580e597f362ca87e5a4eab2a9fdcb1f24f695e350fa';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-509';
SET @content_hash = 'c076ca62083cd468e86614f90a17a8b55e92fdbf433725146300ce7990ca6c1b';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-510';
SET @content_hash = '7b3cd9179d7fbe8077b154970bda6440ac99ffecb2651812e6012bb741bb6c72';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 발주요청',
    '[발주요청] 버튼 클릭한다.',
    '발주 요청 진행 팝업 → 발주요청 완료 얼럿 내, 확인 버튼 클릭시
''발주요청'' 버튼  →  ''발주요청 완료'' 로 버튼명이 변경되고 버튼 비활성화 

▶ 견적서 보기 / 서류추가등록 / 발주요청완료(비활성화) 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-511';
SET @content_hash = '523732285e30d040115c4aaccf04d7078abafd59a5683b45427ff916fe696d98';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황 : 품의, 결재완료',
    '하나인 –  ''계약번호''입력 된 상태인 경우
하나인 - 통합발주관리 -> 발주 완료 "결제완료" 상태의 경우',
    '▶ 견적서 보기 / 서류추가등록 / '' 품의등록''  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-512';
SET @content_hash = '9b77e0829697f6506e84b5ab40926ec8e07ffd0a723ae771459ba5f03e32b8c5';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황 : 품의, 결재완료',
    '[품의등록] 버튼을 클릭한다.',
    '[품의등록] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-513';
SET @content_hash = '3a1f751ae177195a651c029e15cecc54a30083c70a1f79b329f8de74fdf5e6e0';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황 : 품의, 결재완료
개인',
    '계약자 정보 확인',
    '성명, 생년월일, 진행일정, 상품명',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-514';
SET @content_hash = 'bcdfd28c29ba616d141efe623fec4bd9d1e0f0f671e156e87dac4a8b1f14e7e4';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황 : 품의, 결재완료
개인사업자',
    '계약자 정보 확인',
    '회사명,대표자 성함, 대표자 생년월일, 사업자번호',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-515';
SET @content_hash = 'b246322fb96218b98bde1b26be7ea7b6f8ccb8ce9e32a17bb99ec88e8d5210fe';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황 : 품의, 결재완료
법인사업자',
    '계약자 정보 확인',
    '회사명,대표자 성함, 사업자번호, 법인등록번호, 연대보증인성함, 연대보증인 생년월일',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-516';
SET @content_hash = 'd70fb7184775a8420b3d9516a147c61297a48f694d88f5bc00afcc572a4025b1';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황 : 품의, 결재완료
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

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-517';
SET @content_hash = '164b0487020ef1d85b1525eb17fa4900cee4f8b63a153c32fab7d78112a493a4';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황 : 품의, 결재완료
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

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-518';
SET @content_hash = '3835ac8e958d247e00df7ca3f8ddc97ff6f743fd168f130821cd38d2c1211540';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료
국산차',
    '[품의등록] 화면에서 '' 판매점 정보를 확인하기 위해 판매 대리점 검색을 진행 한다.',
    '[판매점 조회 팝업] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-519';
SET @content_hash = '153a4dad2d002783fae1d86b5d9a111cfa824c67e62f16f64e2602034e9213f9';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료
국산차',
    '조회 결과가 있을 경우 → [판매점 조회 팝업] 화면에 검색 조건을 선택하고 검색어를 입력 후 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 결과가 조회된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-520';
SET @content_hash = '4062c8b6ed4b701cf4212b47e1b19d8a4e87c522fc630b8c6698b784fa26325d';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료
국산차',
    '조회 결과가 없을 경우 → [판매점 조회 팝업] 화면에 검색 조건을 선택하고 검색어를 입력 후 [조회] 버튼을 클릭한다.',
    '조회결과가 없을 경우, 조회결과 영역에 ''검새 결과가 없습니다'' 문구가 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-521';
SET @content_hash = '15d68424d364d54d7d350ccf9c75732c03134d09d8e9e57537fb84fa2c1c48b4';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료
국산차',
    '[판매점 조회 팝업] 화면에 검색 결과를 클릭한다.',
    '[판매점 조회 팝업] 화면이 닫히며, [품의등록] 화면에서 선택값이 판매대리점 영역에 반영된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-522';
SET @content_hash = '7665f648c1e92ffc502e566fb22a11f02df701660c04c0c38a4884335be0eb13';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료
수입차-제휴사',
    '제휴사인 경우, 딜러사 항목',
    '견적에서 선택한 제휴사를 디폴트로 노출(변경불가)',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-523';
SET @content_hash = '141676b50a20e5ab24b36d06e4ddea1e2ab4dbb781ead5fad85b4de9aec6e246';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료
수입차-비제휴사',
    '수입차 비제휴사 경우(견적에서 제휴사 미선택 시) → 딜러사 항목 활성화 [검색]버튼 클릭시',
    '판매점 조회 팝업 출력 후 , 비제휴 딜러사만 리스트되어 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-524';
SET @content_hash = '1b264c9314112a4db48a580e8d3d7a587df62e2c3b64f8f0602d01bb83a5dae6';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료
수입차-비제휴사',
    '수입차- 경우 → 전시장(판매대리점) 조회 영역',
    '판매점 조회 팝업 출력 후 , 수입차 비제휴 딜러사만 리스트되어 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-525';
SET @content_hash = '14ef927b626362698e7546817a52716f760e2bfdd69bc8731f075d493f116eb9';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료
수입차-제휴사',
    '수입차인 경우 → 전시장(판매대리점) 에 검색을 선택하고  [판매점 조회 팝업] 화면에  검색어를 입력 후 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 딜러사 속하는 전시장 리스트 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-526';
SET @content_hash = 'cca5345003e1cde3dbf0471e000289902463b9016660216ba0ee3d81d7b1f11f';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료
수입차-제휴사',
    '전시장(판매대리점) [검색] 버튼 클릭, [판매점 조회 팝업] 화면에 검색 조건을 선택하고 검색어를 입력 후 [조회] 버튼을 클릭한다.',
    '검색 결과가 없는 경우 조회결과 영역에 ''검색 결과가 없습니다'' 문구가 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-527';
SET @content_hash = '60c7085ce3568c3828fd43db1a883d1c7afe8c853a4fa66ac37d7e06dd8b94be';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료
수입차-제휴사',
    '[판매점 조회 팝업] 화면에 검색 결과를 클릭한다.',
    '[판매점 조회 팝업] 화면이 닫히며, [품의등록] 화면에서 선택값이 판매대리점 영역에 반영된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-528';
SET @content_hash = '41bc65e381636d58c0a5faf14e08ae2172fa85c916a1ae3144bddcf13594916a';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[품의등록] 화면에서 판매사원 [검색]버튼을 클릭한다.',
    '[판매사원 조회 팝업] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-529';
SET @content_hash = '1dee7a4fe20156ba84f54a46fc86a93d2019d73dc8f7a554eee4b743f9c55f31';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '조회 결과가 있을 경우 → [판매사원 조회 팝업] 화면에서 조회조건 조회 값을 입력하여 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 결과가 조회된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-530';
SET @content_hash = '4c5a9b513f2836cf6ab7b46de813c1b39553cf6fa5e2ff1e7a122ff32caad751';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '조회 결과가 없을 경우 → [판매사원 조회 팝업] 화면에서 조회조건 조회 값을 입력하여 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 ''검새 결과가 없습니다'' 문구가 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-531';
SET @content_hash = 'def1d59b919aa609db48cd8abf0a7b28ca67c403b44f7045bddb56333d870fbe';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[판매사원 조회 팝업] 화면에 검색 결과를 클릭한다.',
    '[판매사원 조회 팝업] 화면이 닫히며, [품의등록] 화면에서 선택값이 판매사원 영역에 반영된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-532';
SET @content_hash = 'a7c8b56ef7d3e0d67cfb25263e6c669fa56d3c82103f6b312e6f5bff26124dde';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[품의등록] 화면에서 은행 영역을 클릭한다.',
    '[은행 선택] 영역이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-533';
SET @content_hash = '8036b287481fac35c19f041f55c3d562477cff4891b0eebaaa06b91edc0d2190';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[은행 선택] 화면에서 은행을 선택한다.',
    '[은행 선택] 영역이 닫히면서 차량대금 송금(선택) 은행 정보영역에 선택값이 반영된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-534';
SET @content_hash = '584f7a2d31372f0f536921549e74ba573c1b75650f6096770e3aeff7afeeb93e';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
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

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-535';
SET @content_hash = '3a4132d087be58aed6357a26388b8445e9f6bda47461cbfeb19a67517aec9b10';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '렌터카인 경우 ''차량 인도 정보 입력'' 항목이 있다. 
[입력하기] 버튼 클릭한다.',
    '[입력하기] 버튼 클릭시, 인도 요청 정보 입력 팝업 출력한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-536';
SET @content_hash = '83693f3d5d2b4016567073302b6212247ff3568f70924250e0117d68531b0dbd';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[인도요청 정보입력] 화면에서 정보를 입력한다.',
    '정보가 정상적으로 노출(측후면선팅, 측후면 선팅 투과율, 전면 선팅, 전면선팅 투과율 등)된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-537';
SET @content_hash = '65dcec7fff23a01fad0ef01a99f6be6b035aa4611547e6c1bf6bb3d07d12b8be';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '번호판 요청사항 인풋필드에 정보를 입력한다.',
    '정보가 정상 입력된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-538';
SET @content_hash = 'd6d466bbf20a92a8a82e241403c809e6c0cb9f7bddd9568211db36d722b7284f';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '요청 번호를 선택한다. (디폴트 : 무관)',
    '무관, 하 허 호 중에 선택 가능하다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-539';
SET @content_hash = '07774efabb82cbed75efbf24e0dbf1e388e5537dacf1111a88b78dbac4bd2679';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '인도지 담당자, 연락처, 인도지 주소, 비고 입력한다.',
    '인풋필드에 입력가능하고, 필수값은 반드시 모두 입력한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-540';
SET @content_hash = 'a3ad195df2079d3657308e80d31142b868b6ecc491fd5b3b1aa67c578c18a670';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[인도요청 정보입력] 화면에서 인도지 주소 [검색] 버튼을 클릭한다.',
    '[주소 검색] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-541';
SET @content_hash = 'b8b343e10c7910eb5c29d13efb9971de7e92a60e7ff650311240bbba208c73b2';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[인도요청 정보입력] 화면에서 [다음] 버튼을 클릭한다.',
    '''인도지 정보가 등록되었습니다'' 얼럿 출력한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-542';
SET @content_hash = 'ba367f1369fd99cdb0edf9b6096a76484cb7b891c89e1bc556136df3e04d2f50';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '''인도지 정보가 등록되었습니다'' 얼럿에서 [확인] 버튼 클릭시',
    '[인도요청 정보입력] 창이 닫히고, [품의등록] 화면으로 돌아온다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-543';
SET @content_hash = '3cc9b7ed5926cb0837551e676a7c061cf8cc6e4f10748938f012ed0718585ba6';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[품의등록] 화면에서 [서류등록] 버튼을 클릭한다.',
    '[고객서류등록] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-544';
SET @content_hash = '24e764a2f2aacb497e598ae92eea17badf1624c4fc9415e10e68715efcc71c5c';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[고객서류등록] 팝업에서 [파일을 첨부해주세요 +] 버튼을 클릭한다.',
    '파일 첨부 상세페이지로 이동한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-545';
SET @content_hash = '8d6a26eda510780158b1d2a864b60811fe700f76e6fab2023ae0a35b14b521b1';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[파일 업로드] 화면에서 이미지/PDF를 첨부한다',
    '첨부된 파일명이 리스트업 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-546';
SET @content_hash = 'fed881c544bc3c7dde1748bc3249bf453e668ecb4ba6a06b9f2a19cbea5ebfaa';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[파일 업로드] 화면에서 첨부된 파일명 우측 옆 [x]버튼을 클릭한다.',
    '업로드한 파일이 삭제된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-547';
SET @content_hash = 'd5f2e3c2e25858251e5cf52f2aeda6ba81bf1a5f1da813e2c02f3d6c75c18a87';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
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

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-548';
SET @content_hash = 'b9701932554fc99b35c302ce6b268d36a64ba2cce97740249e5702de7464a15a';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '첨부한 파일이 있는 경우 → [고객서류등록] 팝업의 [다운로드] 버튼을 클릭한다.',
    '해당 파일을 다운로드하여 확인할 수 있다. (최대 5분 소요)',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-549';
SET @content_hash = '085ad4fa270b2ea29d81316b1afc088902e4adf7a45a9083b132aff4ac4265a0';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[고객서류등록] 팝업의 [저장] 버튼을 클릭한다.',
    '팝업창이 닫힌다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-550';
SET @content_hash = 'ceb557337eb52b9a2bc48bf972b99f045ceb83ff9cdff19e921edce47a9764aa';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[품의등록] 화면에서 정보 입력 완료 → [품의등록 요청] 버튼을 클릭한다.',
    '[품의등록] 완료시, 완료 얼럿이 출력한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-551';
SET @content_hash = 'ebed92eb77ca2fb71d914e365666402d423ccdc615ee479f803b35084cfbb8d5';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 품의요청',
    '배정"상태의 품의등록 완료 시 상태이며,
하나인 - 품의등록 "저장" 버튼 미실행 단계',
    '견적서 발송 / 견적서 보기 / 서류추가 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-552';
SET @content_hash = '3de4231d35120e7069d0edb353fd7c76dc53bfdea777a6f8cdc5063c8a688c0e';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 품의요청',
    '견적 상태 : 품의요청 → [견적서 발송] 버튼을 클릭한다.',
    '[견적서 발송] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-553';
SET @content_hash = '41b5e186a36bcb367305ad1a358747547b1890a228726e5500afa17b3c19644e';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 품의요청',
    '견적 상태 : 품의요청 → [견적서 보기] 버튼을 클릭한다.',
    '[견적서 보기] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-554';
SET @content_hash = '0db070a9f9f36ec3da230ef0e407d462e6f9e518b9a241cdfc5cf27811044769';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 품의확정',
    '하나인 - 품의등록 "저장" 버튼 실행 하면',
    '견적서 보기 / 서류추가 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-555';
SET @content_hash = '1acf53d2bb09a9e2b503abb6f9bd2a60fd1fda10cb999a04a75a165de03269da';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 품의확정
법인사업자
1차 제조사+2차외주탁송',
    '하나인 - 품의등록 "저장" 버튼 실행 하면',
    '견적서 보기 / 서류추가 등록 /연대보증계약서 다운 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-556';
SET @content_hash = 'eda95d697706f80079ef9bc0003e04a660d1c10f1fbd3a5a8be31a4a80e47af0';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 품의확정
법인사업자
1차 제조사+2차외주탁송',
    '연대보증계약서 다운 클릭시',
    '연도보증계약서 pdf 파일이 다운로드 된다.
연도보증계약서 pdf 파일을 열면 정상표기 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-557';
SET @content_hash = '2b053b32a93d8dc3d6a7ebb0dd6362aeff3731866ae33d2deecfdbf6be26d094';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 송금완료
제조사탁송',
    '하나인 - "선급완료" 처리 시',
    '견적서 보기/ 서류 등록 / 인도요청  버튼 유무를 확인한다.
- 서류 등록시, [인도요청] 버튼 활성화
- 인도요청 후, [인도요청 완료]로 변경',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-558';
SET @content_hash = '2ae6c3a18ed8ce4f7a0a85c4a95664262ac7a9e0168f6b671a188970834900f6';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 송금완료
외주탁송 / 1+2탁송',
    '하나인 - "선급완료" 처리 시',
    '견적서 보기  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-559';
SET @content_hash = '0c533e182c708961c8997a035f50bc323ee881749c8dbf8e231d16b10c9c33dd';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 센터입고
외주탁송 / 1+2탁송',
    '하나인 - "선급완료" 처리 후 “센터입고” 시',
    '견적서 보기/ 서류 등록 / 인도요청  버튼 유무를 확인한다.
- 서류 등록시, [인도요청] 버튼 활성화
- 인도요청 후, [인도요청 완료]로 변경',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-560';
SET @content_hash = 'f3c9f49364558175fadf078c3a096eb829a229845e78e18a082250d4b7936a17';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 센터입고
외주탁송 / 1+2탁송',
    '[견적서 보기] 버튼을 클릭한다.',
    '[견적서 보기] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-561';
SET @content_hash = '3fb4a038c751e23abf769707e409e52f74671fa5b3c6d1a7d86a55394ade0ae3';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 센터입고
외주탁송 / 1+2탁송',
    '서류 등록 완료시',
    '[인도요청] 버튼 활성화',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-562';
SET @content_hash = 'b72e4d854c9ea6f69b57158eb0edce56fb9cd3d0147175fc558d11e6a526c9e4';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 송금완료',
    '[인도요청] 버튼을 클릭한다.',
    '[인도요청 정보입력] 화면 출력한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-563';
SET @content_hash = '266fec3089c2e13821089b9723edf35797555c504528227c0f3e10a3d11d77d7';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 송금완료',
    '[인도요청 정보입력] 화면에서 정보를 입력한다.',
    '정보가 정상적으로 노출, 입력된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-564';
SET @content_hash = '5f67a7958fb6ea21a4aaa2325cf7a625eef1c566e290f8c00c682ab764db084d';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 송금완료',
    '인도지 담당자, 연락처, 인도지 주소, 비고 입력한다.',
    '필수값*은 반드시 모두 입력한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-565';
SET @content_hash = '56cbed8368d91308500692823ec541cda4feb5bb294de9ac680a31fe31d3d2a0';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 송금완료',
    '[인도요청 정보입력] 화면에서 인도지 주소 [검색] 버튼을 클릭한다.',
    '[주소 검색] 팝업 호출 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-566';
SET @content_hash = '18802ba71332275e8fbbfcf58611db97b0bf2c986558a6d9f3c2a84a9cef164b';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 송금완료',
    '[인도요청 정보입력] 화면에서 하단 [인도요청] 버튼을 클릭한다.',
    '안내 알럿을 표시하고 [인도요청 정보입력] 화면이 닫힌다. 
송금완료 견적의 [인도요청] 버튼이 [인도요청 완료] 버튼으로 변경된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-567';
SET @content_hash = '2579c9b7f4f5c6cede4e83a3b042b5e145d02e3b48712ffcbd4eb02807932dd7';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 송금완료',
    '[인도요청 정보입력] 화면에서 하단 [취소] 버튼을 클릭한다.',
    '취소시, 작성되는 내용 저장되지 않고 이전 화면으로 이동한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-568';
SET @content_hash = 'c2b5cd200dba56944641f42a14ea3317b6d65a889e8a05dee4d06d2670834272';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-569';
SET @content_hash = 'b4587140e4176bab40b13c9a9336ad09dc12463f8819cb0e5a7279870be9f660';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-600';
SET @content_hash = '43fa28711dad233cbc5086bb7e9365b74032d76f55cf6f576a880ebb0a95a2a8';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_가견적',
    '-',
    '로그인',
    '하나원큐오토>장기렌터카 메뉴명 선택하여 새 견적을 진행한다',
    '견적 진행시, 대리점 출고로 선택, 
고객 구분 : 개인, 개인사업자, 법인 사업자 중 선택',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-601';
SET @content_hash = 'b7d89cd26639d80efbdaf77267a33bf96a9f6cab8d12be1359407cbcfb8a2355';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_가견적',
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

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-602';
SET @content_hash = '745fa5b8874ac344ea55d9c0045d94eb64956911931029af9ef3bf745f624a01';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
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

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-603';
SET @content_hash = '36c56695b1f80a1747efb2c8e1ffa9745fbdcf5880b530fb237fae9e99f9c865';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
    '-',
    '현황 : 견적, 동의전',
    '견적 동의전 케이스 -  상세조회 버튼 클릭',
    '[상세조회] 버튼 클릭하여, 
해당 정보 확인과 하단에 재견적, 견적서 발송, 견적서 보기, 신용정보조회 동의 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-604';
SET @content_hash = 'dcdb516020afa85816dbccd3c7c4ce4ea1e3ebe1f21d92d6829e6e20c9c58051';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
    '-',
    '현황 : 견적, 동의완료, 
고객구분 : 개인, 개인사업자',
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

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-605';
SET @content_hash = 'edcfa3e58698d8477802c997ab2df6faac06990209ebd4a17eb4055c781efd75';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
    '-',
    '현황 : 견적, 동의완료, 
고객구분 :법인',
    '견적 ''동의완료'' 케이스 - 신용조회 완료 상태일 경우',
    '[상세조회] 버튼 클릭하여, 
해당 정보 확인과 하단에 재견적, 견적서 발송, 견적서 보기, 심사신청 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-606';
SET @content_hash = '030f1d24840844a0e8262c5204ea9aa8fe07915ec6380453f12b075d2e4e8fe7';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
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

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-607';
SET @content_hash = '1fca0fe92472c6f43322e7a5dfb6b9c57b457e9feaa890462c3af36c530f0125';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-608';
SET @content_hash = 'c47d9239f2f53e67bfdaf3a424c2157b015a09bd3301cc2f98356b321d9e598d';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-609';
SET @content_hash = '78918ca298eabe24499f96cdfbad2aea2782397925fa079be9de7100f6bc9598';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-610';
SET @content_hash = 'e672ae5a823273f563de6c5989b497d82137eaa186ba85f2a9ad430624ca80ff';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 발주요청',
    '[발주요청] 버튼 클릭한다.',
    '발주 요청 진행 팝업 → 발주요청 완료 얼럿 내, 확인 버튼 클릭시
''발주요청'' 버튼  →  ''발주요청 완료'' 로 버튼명이 변경되고 버튼 비활성화 

▶ 견적서 보기 / 서류추가등록 / 발주요청완료(비활성화) 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-611';
SET @content_hash = '827bb04a89480529ba00af25bf0b2b3e4e4503f0830476490885878bf65ee3e8';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황 : 품의, 결재완료',
    '하나인 –  ''계약번호''입력 된 상태인 경우
하나인 - 통합발주관리 -> 발주 완료 "결제완료" 상태의 경우',
    '▶ 견적서 보기 / 서류추가등록 / '' 품의등록''   버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-612';
SET @content_hash = '2b8b0344c505b3bba5efeaef19c8b6351a0c621375e779e0edc4c519999bb605';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황 : 품의, 결재완료
(발주완료 14일 초과)',
    '[품의등록] 버튼을 클릭한다.',
    '견적 만료 알림 얼럿 출력 (발주완료 14일 초과)
- 재견적 진행 > [예] 버튼 클릭시 재 견적 시작',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-613';
SET @content_hash = 'c1ec2455541251ebdb91f8e9f27da09f7adfa9e371fdb585ac05d49614bea65e';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
    '-',
    '재견적 진행
현황 : 가견적,',
    '재견적 진행 
→ 가견적 상태의 상세 조회 화면 하단 버튼',
    '재견적/견적서발송/견적서 보기 /견적 확정 버튼 유무를 확인한다.
견적 확정 이후, 견적 탭으로 정보 승계된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-614';
SET @content_hash = '7d14003f64b641be9a085317d5ba42f56a52d599edc74027f95d838bc2c26318';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
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

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-615';
SET @content_hash = '5019c7e39babc8ff705fc2f954750171f3b6980fde13fd660a0d0dc4a70a291e';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
    '-',
    '현황 : 견적, 동의전',
    '견적 동의전 케이스',
    '[상세조회] 버튼 클릭하여, 
해당 정보 확인과 하단에 재견적, 견적서 발송, 견적서 보기, 신용정보조회 동의 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-616';
SET @content_hash = '47a9158896a0d25c67162f7c8245abf34e62875c5d8412304bd53206306d8cbf';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
    '-',
    '현황 : 견적, 동의완료, 
고객구분 : 개인, 개인사업자',
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

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-617';
SET @content_hash = '500f3874efd8302e51943d4e3e33d86a1a79d8a8983ac5e20c0aef5575660557';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
    '-',
    '현황 : 견적, 동의완료, 
고객구분 :법인',
    '견적 ''동의완료'' 케이스 - 신용조회 완료 상태일 경우',
    '[상세조회] 버튼 클릭하여, 
해당 정보 확인과 하단에 재견적, 견적서 발송, 견적서 보기, 심사신청 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-618';
SET @content_hash = '5cb36e447d43233163c1f564fc551da47f731b339a61a2e7cc82098bc46d1694';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
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

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-619';
SET @content_hash = 'f1b55df5a1933feabf39ed4dd3971dbbcbee209a5e65ecc29b39a4fd21d976be';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 승인',
    '심사 상태 값 : 자동 승인, 
승인 된 상태 ''승인'' 노출',
    '재견적 / 견적서 발송 / 견적서 보기 / 서류등록 / (대체)발주요청 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-620';
SET @content_hash = '489e789926f269a5e44bc3ca0a4a9d7dfecc61286955bb697e3211787859223f';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-621';
SET @content_hash = '0b784e6fb61d5b7e2b2e91338fac4720e74b933e77471e24dd4fe67cb8be8292';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-622';
SET @content_hash = '8172ae9a6eaa5856d2d250479466721c128ab36a8c9cada7e9fdd151ab0c574e';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, (대체)발주요청',
    '[(대체)발주요청] 버튼 클릭한다.',
    '발주 요청 진행 팝업 → 발주요청 완료 얼럿 내, 확인 버튼 클릭시
''(대체)발주요청'' 버튼  → ''발주요청 완료'' 로 버튼명이 변경되고 버튼 비활성화 

▶ 견적서 보기 / 서류추가등록 / 발주요청 완료(비활성화) 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-623';
SET @content_hash = '3cf510017e4d146b64e0d22c94590aed1a4a2e4da35a3370845afa26e2fd3750';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황 : 품의, 대체 취소
(발주완료 14일 초과)',
    '재견적 건 ‘(대체)발주요청‘ 시 
최초 발주건은 상태 값 확인',
    '상태 - ''대체 취소'' 로 바뀌고, 하단 버튼은 [견적서 보기]만 출력된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-624';
SET @content_hash = '1f4e251441969c6709060e90f1feaab687d58c687fbe2e189ad3a2441d0d83df';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황 : 품의, 결재완료',
    '하나인 –  ''계약번호''입력 된 상태인 경우
하나인 - 통합발주관리 -> 발주 완료 "결제완료" 상태의 경우',
    '▶ 견적서 보기 / 서류추가등록 / '' 품의등록''   버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-625';
SET @content_hash = '6006cf96dd2edb06c4454e0adac2f8ac77fa43aebd05ad00ccda21559f4a9f47';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황 : 품의, 결재완료',
    '[품의등록] 버튼을 클릭한다.',
    '[품의등록] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-626';
SET @content_hash = 'fde1ddd9c7dd64707b5cf19328a09d7aafa9d057f0a7f7a13fd614406201380b';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황 : 품의, 결재완료
개인',
    '계약자 정보 확인',
    '성명, 생년월일, 진행일정, 상품명',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-627';
SET @content_hash = 'ee1bafff17452f0e7acef3bafdf4a3e8353fbb936b826568649af184ea271c4a';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황 : 품의, 결재완료
개인사업자',
    '계약자 정보 확인',
    '회사명,대표자 성함, 대표자 생년월일, 사업자번호',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-628';
SET @content_hash = 'cea460bd822c33c7a9999763b5ced7e003281a9eaa4452980b1e84f29815d55d';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황 : 품의, 결재완료
법인사업자',
    '계약자 정보 확인',
    '회사명,대표자 성함, 사업자번호, 법인등록번호, 연대보증인성함, 연대보증인 생년월일',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-629';
SET @content_hash = 'cde0bcd1ba8d49bf4307fc5001c4fb5c3c06000ef15785a8c017f03c846741a2';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황 : 품의, 결재완료
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

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-630';
SET @content_hash = '0bf6830e0cfb20238d6474ae266bb436621143ae82cdb2f3879d7f046435e068';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황 : 품의, 결재완료
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

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-631';
SET @content_hash = '278122283fa8a3a606cab672fc07f57f089174a238f9484b3e2311e1d571a2e3';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료
국산차',
    '[품의등록] 화면에서 '' 판매점 정보를 확인하기 위해 판매 대리점 검색을 진행 한다.',
    '[판매점 조회 팝업] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-632';
SET @content_hash = 'bb5df750f318114f76ef4a61500641db4e7040ce3096b4b362df17aa5d5fb32d';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료
국산차',
    '조회 결과가 있을 경우 → [판매점 조회 팝업] 화면에 검색 조건을 선택하고 검색어를 입력 후 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 결과가 조회된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-633';
SET @content_hash = 'b6f5a31d2035f0631893d2ed79c6e96d6c8bc8d6d114aa0cb989c32cab1d20c1';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료
국산차',
    '조회 결과가 없을 경우 → [판매점 조회 팝업] 화면에 검색 조건을 선택하고 검색어를 입력 후 [조회] 버튼을 클릭한다.',
    '조회결과가 없을 경우, 조회결과 영역에 ''검새 결과가 없습니다'' 문구가 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-634';
SET @content_hash = '680a1bcdbc2e9d8f19d94763c444660ab3b295f4d3c6dbe6d406c24a43ecebb7';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료
국산차',
    '[판매점 조회 팝업] 화면에 검색 결과를 클릭한다.',
    '[판매점 조회 팝업] 화면이 닫히며, [품의등록] 화면에서 선택값이 판매대리점 영역에 반영된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-635';
SET @content_hash = '6d44c1a0a37973041b8384dafc00e0f9cadcf26632b119bcfe5eadc38da14387';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료
수입차-제휴사',
    '제휴사인 경우, 딜러사 항목',
    '견적에서 선택한 제휴사를 디폴트로 노출(변경불가)',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-636';
SET @content_hash = '95d1e9b49f03de893625d3c65d090a9afa277c2e7241c2d5c893fc7cd49da0a6';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료
수입차-비제휴사',
    '수입차 비제휴사 경우(견적에서 제휴사 미선택 시) → 딜러사 항목 활성화 [검색]버튼 클릭시',
    '판매점 조회 팝업 출력 후 , 비제휴 딜러사만 리스트되어 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-637';
SET @content_hash = 'cfebff5a030275e0b176236da786ac6976511a18306bba5cd019812f04a1278d';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료
수입차-비제휴사',
    '수입차- 경우 → 전시장(판매대리점) 조회 영역',
    '판매점 조회 팝업 출력 후 , 수입차 비제휴 딜러사만 리스트되어 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-638';
SET @content_hash = '8c1db8ecdf3d53913bd46d8ead29e2111f26cfba40f10325e6b5596700765f06';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료
수입차-제휴사',
    '수입차인 경우 → 전시장(판매대리점) 에 검색을 선택하고  [판매점 조회 팝업] 화면에  검색어를 입력 후 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 딜러사 속하는 전시장 리스트 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-639';
SET @content_hash = '079765e9aa714be05a4c909efade4c4d8b5ff59d8d859a6bd046d1fcf7ccaf19';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료
수입차-제휴사',
    '전시장(판매대리점) [검색] 버튼 클릭, [판매점 조회 팝업] 화면에 검색 조건을 선택하고 검색어를 입력 후 [조회] 버튼을 클릭한다.',
    '검색 결과가 없는 경우 조회결과 영역에 ''검색 결과가 없습니다'' 문구가 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-640';
SET @content_hash = '8c3c0cd0acf2df4f7208adf7bf4a91b86c104875c83b9ca153a494ffdca6a59d';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료
수입차-제휴사',
    '[판매점 조회 팝업] 화면에 검색 결과를 클릭한다.',
    '[판매점 조회 팝업] 화면이 닫히며, [품의등록] 화면에서 선택값이 판매대리점 영역에 반영된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-641';
SET @content_hash = '43a86145795d95d90b53e9a17b80b45dcf826335c4bc106a45f48829cff406a9';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[품의등록] 화면에서 판매사원 [검색]버튼을 클릭한다.',
    '[판매사원 조회 팝업] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-642';
SET @content_hash = '2c74ce395535c1984bb742a8ef7965871aebe53388ca079ccb7cdf45844bbbaf';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '조회 결과가 있을 경우 → [판매사원 조회 팝업] 화면에서 조회조건 조회 값을 입력하여 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 결과가 조회된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-643';
SET @content_hash = '74d655c522c648d16685e1dd6ab784c75a7dcc5f37dff95941326689fdc9fbc3';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '조회 결과가 없을 경우 → [판매사원 조회 팝업] 화면에서 조회조건 조회 값을 입력하여 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 ''검새 결과가 없습니다'' 문구가 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-644';
SET @content_hash = '69250d1789f4c8858c9a895a582b90dfd70cf3317166c1e9356fe0e2e9b9a958';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[판매사원 조회 팝업] 화면에 검색 결과를 클릭한다.',
    '[판매사원 조회 팝업] 화면이 닫히며, [품의등록] 화면에서 선택값이 판매사원 영역에 반영된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-645';
SET @content_hash = '83a8071356236ff1994d80ff0a44278c3b48acaf25dc235d092e551626d80bb6';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[품의등록] 화면에서 은행 영역을 클릭한다.',
    '[은행 선택] 영역이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-646';
SET @content_hash = '2c453725ed35af55fb54a292a647b457c981e9f9bae1923961fdbd292338237f';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[은행 선택] 화면에서 은행을 선택한다.',
    '[은행 선택] 영역이 닫히면서 차량대금 송금(선택) 은행 정보영역에 선택값이 반영된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-647';
SET @content_hash = '88b0b45d7059ca841bdae094f0392ff34a89b56c430524600bee19b8f2af39c9';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
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

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-648';
SET @content_hash = '333e008c44f01073748de5f2ce6bce7021959f43e51205a0b0f18983ed972709';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '렌터카인 경우 ''차량 인도 정보 입력'' 항목이 있다. 
[입력하기] 버튼 클릭한다.',
    '[입력하기] 버튼 클릭시, 인도 요청 정보 입력 팝업 출력한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-649';
SET @content_hash = '99f258d5552a9192813e9cddc93f60817717be28461d915bc652ff421f561253';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[인도요청 정보입력] 화면에서 정보를 입력한다.',
    '정보가 정상적으로 노출(측후면선팅, 측후면 선팅 투과율, 전면 선팅, 전면선팅 투과율 등)된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-650';
SET @content_hash = '259bc826122522e7cdb58a8e9f2c52942234d73f366126e4ee0037ff3962eddb';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '번호판 요청사항 인풋필드에 정보를 입력한다.',
    '정보가 정상 입력된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-651';
SET @content_hash = '92213765ebb9ac69ae4fe7a65a9f228939745d7498ff77b2b5de77ff8e609f36';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '요청 번호를 선택한다. (디폴트 : 무관)',
    '무관, 하 허 호 중에 선택 가능하다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-652';
SET @content_hash = '43b6f82f621f086c91fecdcc1d210b3647163e571b87240183765abe66256ad2';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '인도지 담당자, 연락처, 인도지 주소, 비고 입력한다.',
    '인풋필드에 입력가능하고, 필수값은 반드시 모두 입력한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-653';
SET @content_hash = 'f8e311e9d26f66fe0ad3f966c69e7bae675a9b1ed8b6ab810abd93e6ecea4dce';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[인도요청 정보입력] 화면에서 인도지 주소 [검색] 버튼을 클릭한다.',
    '[주소 검색] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-654';
SET @content_hash = '43a1b59e054452b3f6649614394630dbeab704c5413223a24de0accc7c786ddf';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[인도요청 정보입력] 화면에서 [다음] 버튼을 클릭한다.',
    '''인도지 정보가 등록되었습니다'' 얼럿 출력한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-655';
SET @content_hash = '32787ce99f56ae409557a5a688804370a03dd4d9fc724fecbd6fa62cdae62ac5';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '''인도지 정보가 등록되었습니다'' 얼럿에서 [확인] 버튼 클릭시',
    '[인도요청 정보입력] 창이 닫히고, [품의등록] 화면으로 돌아온다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-656';
SET @content_hash = '744a2d09c08d5ef2fa6e60977ef13e8c532db3e358fc80c5df42bf82ddb80b75';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[품의등록] 화면에서 [서류등록] 버튼을 클릭한다.',
    '[손님서류등록] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-657';
SET @content_hash = 'c28ebf5a5b10f8401670ba243cc55152ff14ce1e5993373b3f72c90b5b1d669d';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[손님서류등록] 팝업에서 [파일을 첨부해주세요 +] 버튼을 클릭한다.',
    '파일 첨부 상세페이지로 이동한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-658';
SET @content_hash = 'eb4ce7a17910bb8f2fa78ee639c5b3df6c5b5648c4228091fc1a2961e101b1d1';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[파일 업로드] 화면에서 이미지/PDF를 첨부한다',
    '첨부된 파일명이 리스트업 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-659';
SET @content_hash = '42a182c03197da80ac1cdadeaa70b9a14badacb0a7237ac95c202459402c2f0f';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[파일 업로드] 화면에서 첨부된 파일명 우측 옆 [x]버튼을 클릭한다.',
    '업로드한 파일이 삭제된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-660';
SET @content_hash = '1e97a3d5f14d13145b0995469ac0408efb59559eb2d2f728e8ed5117e0c0cc40';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
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

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-661';
SET @content_hash = '3780496caf923642918f49360fc86f2ce500214f31ecb29b5bc4edf30c49e1f3';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '첨부한 파일이 있는 경우 → [손님서류등록] 팝업의 [다운로드] 버튼을 클릭한다.',
    '해당 파일을 다운로드하여 확인할 수 있다. (최대 5분 소요)',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-662';
SET @content_hash = '5028e9d3287406eff0a5d757e5c509ceb305552a05fc00a5ce75fd41a5452f30';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[고객서류등록] 팝업의 [저장] 버튼을 클릭한다.',
    '팝업창이 닫힌다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-663';
SET @content_hash = '066721d6ea14cd314b20aa685f706b918e6ff08bca554d916f395cd14420660f';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 결재완료',
    '[품의등록] 화면에서 정보 입력 완료 → [품의등록 요청] 버튼을 클릭한다.',
    '[품의등록] 완료시, 완료 얼럿이 출력한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-664';
SET @content_hash = 'd71240f3e298388a368bd1eee11507015541e235ead0b90fe5033b6c02a37c33';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 품의요청',
    '배정"상태의 품의등록 완료 시 상태이며,
하나인 - 품의등록 "저장" 버튼 미실행 단계',
    '견적서 발송 / 견적서 보기 / 서류추가 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-665';
SET @content_hash = 'b6777fbec926bdd9f2e4a458001375a2ca5d992c4d70ddcea02b2dcc3c3ef6e1';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 품의요청',
    '견적 상태 : 품의요청 → [견적서 발송] 버튼을 클릭한다.',
    '[견적서 발송] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-666';
SET @content_hash = 'c34eb707f537902f4c363dd18f33a6293031d4dc7d14b583f3d938535834e976';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 품의요청',
    '견적 상태 : 품의요청 → [견적서 보기] 버튼을 클릭한다.',
    '[견적서 보기] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-667';
SET @content_hash = 'df2cc5819352b58afa668ca8e836d8ded038652c95ba251f49980818cb5e0c0c';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 품의확정',
    '하나인 - 품의등록 "저장" 버튼 실행 하면',
    '견적서 보기 / 서류추가 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-668';
SET @content_hash = 'e7400679269fb3c81e559a36ddb152eacd7de2604135d67d24a2d7a272be7eee';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 품의확정
법인사업자
1차 제조사+2차외주탁송',
    '하나인 - 품의등록 "저장" 버튼 실행 하면',
    '견적서 보기 / 서류추가 등록 /연대보증계약서 다운 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-669';
SET @content_hash = 'a0d3338dedd9a18e9e0cd8210541cb291f65d4286f0fb5d84b54bdbd3208bb7e';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 품의확정
법인사업자
1차 제조사+2차외주탁송',
    '연대보증계약서 다운 클릭시',
    '연도보증계약서 pdf 파일이 다운로드 된다.
연도보증계약서 pdf 파일을 열면 정상표기 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-670';
SET @content_hash = '7b00429360463554844c6ed4e0c6132cd3c45924b6d31041b2da95f0475072c2';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 송금완료
제조사탁송',
    '하나인 - "선급완료" 처리 시',
    '견적서 보기/ 서류 등록 / 인도요청  버튼 유무를 확인한다.
- 서류 등록시, [인도요청] 버튼 활성화
- 인도요청 후, [인도요청 완료]로 변경',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-671';
SET @content_hash = '27b6665a56027e0d6ac0cc523c77616588627b00889a523a68644a5d4e08b708';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 송금완료
외주탁송 / 1+2탁송',
    '하나인 - "선급완료" 처리 시',
    '견적서 보기  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-672';
SET @content_hash = '7b3c805952f83d584884555702c4242881e330dcc6bfd5947139011241d92ad6';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 센터입고
외주탁송 / 1+2탁송',
    '하나인 - "선급완료" 처리 후 “센터입고” 시',
    '견적서 보기/ 서류 등록 / 인도요청  버튼 유무를 확인한다.
- 서류 등록시, [인도요청] 버튼 활성화
- 인도요청 후, [인도요청 완료]로 변경',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-673';
SET @content_hash = 'df2929812da73cbc78f7ace1e6d44aceab64526fbdcca1b876f81ae007845aac';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 센터입고
외주탁송 / 1+2탁송',
    '[견적서 보기] 버튼을 클릭한다.',
    '[견적서 보기] 팝업이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-674';
SET @content_hash = '6179be79ac384fc2e6e3c16ef58d6a6e95b1c692188fcab0bd2ea847d6a570c2';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 센터입고
외주탁송 / 1+2탁송',
    '서류 등록 완료시',
    '[인도요청] 버튼 활성화',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-675';
SET @content_hash = '4afbb200e26cba109e8007383b6e2c06032ec40448a36ed6b87eb7b6dd0f92fc';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 송금완료',
    '[인도요청] 버튼을 클릭한다.',
    '[인도요청 정보입력] 화면 출력한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-676';
SET @content_hash = '338e78364cf49f736e6f5c88cd6470e948a9634d94474ade41c1007f180169ef';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 송금완료',
    '[인도요청 정보입력] 화면에서 정보를 입력한다.',
    '정보가 정상적으로 노출, 입력된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-677';
SET @content_hash = 'c0d372dbb50a0c5101308c15e90f7f3775df371165481f4bf20a8b4245067233';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 송금완료',
    '인도지 담당자, 연락처, 인도지 주소, 비고 입력한다.',
    '필수값*은 반드시 모두 입력한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-678';
SET @content_hash = 'fc41b8503c91ecd2d767db2740c1c1ab5222be66e17e0b7badb9bd699bbd5cde';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 송금완료',
    '[인도요청 정보입력] 화면에서 인도지 주소 [검색] 버튼을 클릭한다.',
    '[주소 검색] 팝업 호출 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-679';
SET @content_hash = '83f608aba0918782ce878f2998bef4d97b5f745693d0fb7c9c20caca3bc90812';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 송금완료',
    '[인도요청 정보입력] 화면에서 하단 [인도요청] 버튼을 클릭한다.',
    '안내 알럿을 표시하고 [인도요청 정보입력] 화면이 닫힌다. 
송금완료 견적의 [인도요청] 버튼이 [인도요청 완료] 버튼으로 변경된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-680';
SET @content_hash = '693ae6f7ab636f43e77036c1e5fe02122304bb308bc88bbb4f26ba79f57f19cc';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 송금완료',
    '[인도요청 정보입력] 화면에서 하단 [취소] 버튼을 클릭한다.',
    '취소시, 작성되는 내용 저장되지 않고 이전 화면으로 이동한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-681';
SET @content_hash = '8856850f57d59a47ec3b0a58b78017d89b93d33ce1c3ae98d7288f6f880c0cfb';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-682';
SET @content_hash = '4882fdad789a79353f78f7f09c8e99def5b0003d49435ed9773c63fa4937af9b';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-700';
SET @content_hash = '08d02e72deecf3842c584f28043d3b79044e2a60be56cd35f91dc96e1cc5e1d0';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_가견적',
    '-',
    '로그인',
    '하나원큐오토>장기렌터카 메뉴명 선택하여 새 견적을 진행한다',
    '견적 진행시, 특판 출고로 선택, 
고객 구분 : 개인, 개인사업자, 법인 사업자 중 선택',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-701';
SET @content_hash = '6d7567e71df5388220635b340cbe09b10dc0fc879e614d527b5afa92d55f1172';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_가견적',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-702';
SET @content_hash = 'cefbcf5500f081fc94859c83431d0db4b13fe43f14c45a17c271bebfd195f22a';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-703';
SET @content_hash = '368c6e9a0815bdfc9e9fd404c3f9b04685c39a01c4a7ea274b1b9870c091d0fc';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-704';
SET @content_hash = '818fbf2c9deb47d6fcb5c2856f03174593a6a74c5edee4e5368b7b8404c3baaf';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
    '-',
    '현황 : 견적, 동의완료, 
고객구분 : 개인, 개인사업자',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-705';
SET @content_hash = 'fb22e08564698ae09e091812349ded54cb1959ad8110f9f23c273ab8ff677be3';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
    '-',
    '현황 : 견적, 동의완료, 
고객구분 :법인',
    '견적 ''동의완료'' 케이스 - 신용조회 완료 상태일 경우',
    '[상세조회] 버튼 클릭하여, 
해당 정보 확인과 하단에 재견적, 견적서 발송, 견적서 보기, 심사신청 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-706';
SET @content_hash = '4587556da6896db6939459214d5b671204927e77e47e56c353cdf0f2e3206242';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-707';
SET @content_hash = '61fd43f807b3197504b9e9784a7ef890a712d2c984d0f677abfec0419fab64fa';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-708';
SET @content_hash = '677059fe5505c638d68540ae8556f24689d354dec3f16ba70a1e34acfce29b94';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-709';
SET @content_hash = 'caaa786f7c5d5a5043f964ef575d5a15806a514936e5c11fa633aa7e2efece1b';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-710';
SET @content_hash = '6b9bb15469cf3ba46ba7ad883ebc5f07a3e5422e1271926ddcd97d80cfbcfb17';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 발주요청',
    '[발주요청] 버튼 클릭한다.',
    '발주 요청 진행 팝업 → 발주요청 완료 얼럿 내, 확인 버튼 클릭시
''발주요청'' 버튼  →  ''발주요청 완료'' 로 버튼명이 변경되고 버튼 비활성화 

▶ 견적서 보기 / 서류추가등록 / 발주요청완료(비활성화) 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-711';
SET @content_hash = '8786f3f970c1030e09d38ea5bff15c6be149df3402c502a1a12b7f40191b26ff';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 발주완료',
    '하나인 - 통합발주관리 "발주완료" 상태의 경우',
    '견적서 보기 / 서류추가등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-712';
SET @content_hash = 'ec4a55fff6e95b5e77e82ed8acf711ca47374b6a17c3032f9dc89611a5fb6dbb';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 배정',
    '하나인 - 통합발주관리  "배정" 상태의 경우',
    '재견적 / 견적서 보기 / 서류추가 등록 / 품의등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-713';
SET @content_hash = '933d16e5c8ccf960ee1fdbf3890cdb9488142c73d61a9a0c057c07d123c08a44';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-714';
SET @content_hash = '9a5ac31f424551d02d480db6962f2202fa7787a4622407ed5802f556564ee2a9';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-715';
SET @content_hash = '769aa2d08720dce9a10806db2c01d386f026958faa73393a2a05e8596c6c1aae';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-716';
SET @content_hash = 'c4962fd5f3534ad66e895be2ddf46716afea5a488c7aa3dc2451b9a087655c39';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-717';
SET @content_hash = 'e5df456e3ed8a3bc9c59d33e0f11c83b3826f55d4bb3e4d07c1a44ada35f4954';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-718';
SET @content_hash = '7a5819069042669a4bae211dae103e49552a579a3368b87e1ebf5b9dd04a6d66';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-719';
SET @content_hash = '7a3a647e31e75438fcd95b5e8a462b872ca202a3c7d7932df37ef9666c4a7070';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 배정
국산차',
    '[품의등록] 화면에서  핀매점 정보를 확인하기 위해 판매 대리점 검색을 진행 한다.',
    '[판매점 조회 팝업] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-720';
SET @content_hash = '12e45f404a3e05182ce23dcb5565324a3d128fbbdc4df53669f7c25999936b51';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-721';
SET @content_hash = 'be712dc6fc7aa1a6e2f223ee96cf086ff7f080c7fc325205d969dbd9bce82872';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 배정
국산차',
    '조회 결과가 없을 경우 → [판매점 조회 팝업] 화면에 검색 조건을 선택하고 검색어를 입력 후 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 ''검새 결과가 없습니다'' 문구가 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-722';
SET @content_hash = '00f31cb72f721dbbafba8bbb364566cccc8bb33ce03bbf77896176920dc8d037';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-723';
SET @content_hash = '4b0c41502a3699171d15f1a8fb4d3934e13e8096427a29b38bb6aa73f9c084ac';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-724';
SET @content_hash = '9f86ea4cccfe1bc48b76089f9f3b80a2d25f0862572c1412bd3445f00f1bd5ca';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-725';
SET @content_hash = 'ddd8666f1b68cb71f1a3f14b8d2c0defbf68256d718ea2ba8e1901bf6a31ee04';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-726';
SET @content_hash = 'cec18d23cfd1cd7d79163409e1938d0d2a69be12f21018ac4d5b36145bd8d73c';
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
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-727';
SET @content_hash = '6bc493cb4d849ecb7f705f567c551be35a32512a828de18b9483cb668afec906';
SET @sort_order = 181;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 배정
수입차-제휴사',
    '전시장(판매대리점) [검색] 버튼 클릭, [판매점 조회 팝업] 화면에 검색 조건을 선택하고 검색어를 입력 후 [조회] 버튼을 클릭한다.',
    '검색 결과가 없는 경우, 조회결과 영역에 ''검색 결과가 없습니다'' 문구가 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-728';
SET @content_hash = '7527c3c596c0d04c56386d50a2638dee2b2b634b571898e464a11d6fb727387d';
SET @sort_order = 182;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-729';
SET @content_hash = '8b43a2a5fec50ed59a48c8acd5ccc20051be75be5aa28000db5f49ef2d6cd0f3';
SET @sort_order = 183;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 배정',
    '[품의등록] 화면에서 판매사원 [검색]버튼을 클릭한다.',
    '[판매사원 조회 팝업] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-730';
SET @content_hash = '2105a1d7ba67eb9c7fa19ead4a82c72fa027696f14dc952270d7f5c8922c48b0';
SET @sort_order = 184;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 배정',
    '조회 결과가 있을 경우 → [판매사원 조회 팝업] 화면에서 조회조건 조회 값을 입력하여 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 결과가 조회된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-731';
SET @content_hash = '0875461518356ac25d946795a41e1986b841827de2b0626c48d0b66c568b58cb';
SET @sort_order = 185;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 배정',
    '조회 결과가 없을 경우 → [판매사원 조회 팝업] 화면에서 조회조건 조회 값을 입력하여 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 ''검새 결과가 없습니다'' 문구가 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-732';
SET @content_hash = '714585c50a33e18276dd87c0dbb9228cf7b7f51f794d69e478837ab2fba58dd4';
SET @sort_order = 186;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 배정',
    '[판매사원 조회 팝업] 화면에 검색 결과를 클릭한다.',
    '[판매사원 조회 팝업] 화면이 닫히며, [품의등록] 화면에서 선택값이 판매사원 영역에 반영된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-733';
SET @content_hash = '85b4e1f28d5107d656a3d38b5c4fd36eaffd8c6d64c85a26dcf7fde2bd9df536';
SET @sort_order = 187;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-734';
SET @content_hash = '19a9da795c817e3af6bde7f85ec8ede1abe0cc412da1cd735221fa154c29f027';
SET @sort_order = 188;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-735';
SET @content_hash = '0e137c245396dacf709f1a17345cc225f2c8941b6da8abb5775cc4d58f008e3f';
SET @sort_order = 189;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-736';
SET @content_hash = '9739b29b19eb61438eb3a392629b3a331e332abf1ffab1e2993c933a56c6dbec';
SET @sort_order = 190;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-737';
SET @content_hash = 'dfbc9798fdb76cdebb871caf046d95153970440a40269bc0ce611df61d3f1be1';
SET @sort_order = 191;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-738';
SET @content_hash = '65cb5545795b1e818c90420780e3dd99c23e0a4abf49eca1f391a7fe59189091';
SET @sort_order = 192;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-739';
SET @content_hash = 'fdb18a55228a4ce386b1d7e42b93646175e1e4b2ef6cdb49a35d152c11d5ac0b';
SET @sort_order = 193;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-740';
SET @content_hash = '10bb3247f661e139d992799e109471574c826de6534db80458d1ca9c8e6ca901';
SET @sort_order = 194;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-741';
SET @content_hash = 'e21564b978f561760ae8d6bd856d14963ea2046b80be2479982eaa7c65be4e61';
SET @sort_order = 195;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-742';
SET @content_hash = '3cc599ec677bd7988248419e6babda4cb983eb41ed4c861f75ff6211ea9cc3e7';
SET @sort_order = 196;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-743';
SET @content_hash = '28e9ad8fc95b8c42a19447b3a8af1949ad6caa335bd267938385077a1f92cfcb';
SET @sort_order = 197;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-744';
SET @content_hash = 'de2d78262a81bcc89ff5e01db4c2cfc981ae2f311d4ed7ec02ff874ab5ed6003';
SET @sort_order = 198;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 배정',
    '[품의등록] 화면에서 [서류등록] 버튼을 클릭한다.',
    '[손님서류등록] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-745';
SET @content_hash = 'e750c130efa291d7297e73613a6e255bf577b996432071ec338f3ab9c6ca8d2b';
SET @sort_order = 199;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-746';
SET @content_hash = '0ce2668ab95571a61daecc3ff925c62588a7736b22dce19fda8862ed200fb1d1';
SET @sort_order = 200;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-747';
SET @content_hash = 'a051a83e2b8dd7f736bd52d518bd11b7d299350c360b687bc53ea17b427ea8c2';
SET @sort_order = 201;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-748';
SET @content_hash = '55dfc85a7e3f9c79a870307ccb73bcfef3ec26dba05db0f55a3aa1d4a153cff3';
SET @sort_order = 202;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-749';
SET @content_hash = '8c579a300e0477c0f44312ae4e3796cd3ccca10f9dab6c08b5a8ce303749d625';
SET @sort_order = 203;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-750';
SET @content_hash = '1c4ac5017b9271c419e3c340a77428a431cf490c70985f8eaebf83256bb37765';
SET @sort_order = 204;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 배정',
    '[고객서류등록] 팝업의 [저장] 버튼을 클릭한다.',
    '팝업창이 닫힌다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-751';
SET @content_hash = '3cb6e4c933348e86c8b448e408b3ba833decded96e5c4bc0a29a4036be2bf2fa';
SET @sort_order = 205;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-752';
SET @content_hash = '78cd1979d7e462814614cd036cc7bbc5ba2aa2142fe7540998ea8a509f4c7231';
SET @sort_order = 206;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황 : 품의, 품의요청',
    '배정"상태의 품의등록 완료 시 상태이며,
하나인 - 품의등록 "저장" 버튼 미실행 단계',
    '견적서 발송 / 견적서 보기 / 서류추가 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-753';
SET @content_hash = 'baebaa46dfdc1a37564b4122c24f03f99576378d04f16259cdbf1463aa94932f';
SET @sort_order = 207;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-754';
SET @content_hash = 'cfa4cd5cda53ff95cc0995518934ebf7ef88a05f6ccd6acec7a7943a774240b6';
SET @sort_order = 208;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-755';
SET @content_hash = '547cadeec7eb9e55d0e9a4c4333178d8d45a393ea022401c13a9c6ad34274e86';
SET @sort_order = 209;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-756';
SET @content_hash = 'c8d6a9698299683f5130102f981265dbe18317d1255648641c8c74f2e331954f';
SET @sort_order = 210;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 품의확정
법인사업자',
    '하나인 - 품의등록 "저장" 버튼 실행 하면',
    '견적서 보기 / 서류추가 등록 /연대보증계약서 다운 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-757';
SET @content_hash = 'edc3877d4412d6b9f76f450a5bb29a5647c0ef1e99c0a841502f25367c504a34';
SET @sort_order = 211;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-758';
SET @content_hash = '9ea2eab92742380051517d9b51e590de229b57e68016aaaae86c1c61587e3a06';
SET @sort_order = 212;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-759';
SET @content_hash = 'f3f3b06380a063067d9bd83347ac26edf259efca35de883d5855c045c3d2f483';
SET @sort_order = 213;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 송금완료
외주탁송 / 1+2탁송',
    '하나인 - "선급완료" 처리 시',
    '견적서 보기  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-760';
SET @content_hash = 'dee49e97c1e23bed8efd63ff6da7ab16a812e80d5295aec3352c125579d7168a';
SET @sort_order = 214;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 센터입고
외주탁송 / 1+2탁송',
    '하나인 - "선급완료" 처리 후 “센터입고” 시',
    '견적서 보기/  인도요청  버튼 유무를 확인한다.
- 인도요청 후, [인도요청 완료]로 변경',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-761';
SET @content_hash = 'cb59f02e3f94a7ebbbeb891314ce39411cdd1a091be2b6c146336cc7f6c247d7';
SET @sort_order = 215;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-762';
SET @content_hash = 'c316cbfa015b67ab4f7888806d94b9834c43f90cbeab3410d92c8265a29f4edc';
SET @sort_order = 216;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-763';
SET @content_hash = '3f5c109c1bba638817f3e7c081bcd206fec6f583c31fc6817429f6a06abb554e';
SET @sort_order = 217;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-764';
SET @content_hash = '3f66cd44b11b7a0969b2ad4e535cd70d49f3d3c0c3a38f8f97104b1095f99521';
SET @sort_order = 218;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-765';
SET @content_hash = '6bb5e4cf9a1670a59b8afc6f945fb071e2335e808c3d06f1e14882f628fd2b06';
SET @sort_order = 219;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-766';
SET @content_hash = 'b6040b097ca1d8ac3733ddaed1f5c137ddbcd7da26fc5deb2a4b7ad0ca7be2d6';
SET @sort_order = 220;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-767';
SET @content_hash = 'bf0810e554396bf23059c0271505a57b117a775ff243d23eb967d83e168a1f62';
SET @sort_order = 221;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-768';
SET @content_hash = 'd8ce4ab5689e75492e1c5a79ee5c318dd0cc5a915edbff37d36bcd599272072a';
SET @sort_order = 222;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-769';
SET @content_hash = '2769cdeace66b48b42520ae29b8fc6c12544c442bd54bb8ad9ae94a42ae9daa7';
SET @sort_order = 223;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-770';
SET @content_hash = '25e2bd84417faea6b07a473a31b3e9830649669c182121d25b09f7e5fdcca99c';
SET @sort_order = 224;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-800';
SET @content_hash = '709d49ab0ccb67abc0f8fa19c0dae0204838b79d6f735b11386b0c1043ebbe49';
SET @sort_order = 225;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_가견적',
    '-',
    '로그인',
    '하나원큐오토>장기렌터카 메뉴명 선택하여 새 견적을 진행한다',
    '견적 진행시, 특판 출고로 선택,  고객 구분 : 고객 구분 : 개인, 개인사업자, 법인 사업자 중 선택',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-801';
SET @content_hash = '4a0687859abb8e45610147ab9ccdbb662ef3fb600376539981b50d78276a5680';
SET @sort_order = 226;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_가견적',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-802';
SET @content_hash = '9d1ef30adeda4190bbde037fe8db80eb4bfa171e3b99edaba3fb03536a1d036b';
SET @sort_order = 227;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-803';
SET @content_hash = '5c3e6b86cb2ea4e0553d7a82f18706e9cf591ca144788b29555ca6789a692d06';
SET @sort_order = 228;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
    '-',
    '현황 : 견적, 동의전',
    '견적 동의전 케이스 -  상세조회 버튼 클릭',
    '[상세조회] 버튼 클릭하여, 
해당 정보 확인과 하단에 재견적, 견적서 발송, 견적서 보기, 신용정보조회 동의 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-804';
SET @content_hash = 'c26babb84fefbe04ea8897d5760d05d60d79b01e62d534e88eb7ace128285a4f';
SET @sort_order = 229;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
    '-',
    '현황 : 견적, 동의완료, 
고객구분 : 개인, 개인사업자',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-805';
SET @content_hash = 'bca60972d55c3cdca3f24b7716616d1d7257a40f412702549503b8b996aaa707';
SET @sort_order = 230;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
    '-',
    '현황 : 견적, 동의완료, 
고객구분 :법인',
    '견적 ''동의완료'' 케이스 - 신용조회 완료 상태일 경우',
    '[상세조회] 버튼 클릭하여, 
해당 정보 확인과 하단에 재견적, 견적서 발송, 견적서 보기, 심사신청 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-806';
SET @content_hash = 'fc77d23b36c42467e21678e5fefb083d4ba7ea9e72b87a9fbe993a05f0f1cf87';
SET @sort_order = 231;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-807';
SET @content_hash = 'da9c8b571249106a064754f4efa2e1648489857e3a84604a1e9712cfa37e1959';
SET @sort_order = 232;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-808';
SET @content_hash = '3e6851c44216d889a85291811a84a9121c0a465709a4d4bf73ff5f51df1b6e7e';
SET @sort_order = 233;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-809';
SET @content_hash = '7fc12b7ced6fd412cd1324268012a2e4f2a1291f8f596441bc7618d9be4bacda';
SET @sort_order = 234;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-810';
SET @content_hash = 'cc9f7b989d5f813421b6cd27cf2b5a889411585c722f56712efb98deefd0e1e5';
SET @sort_order = 235;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 발주요청',
    '[발주요청] 버튼 클릭한다.',
    '발주 요청 진행 팝업 → 발주요청 완료 얼럿 내, 확인 버튼 클릭시
''발주요청'' 버튼  →  ''발주요청 완료'' 로 버튼명이 변경되고 버튼 비활성화 

▶ 견적서 보기 / 서류추가등록 / 발주요청완료(비활성화) 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-811';
SET @content_hash = '42abdcbd9310289008e993eff964fb6ac0c84279927f03314fdfbbb04fe5961c';
SET @sort_order = 236;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 발주완료',
    '하나인 - 통합발주관리 "발주완료" 상태의 경우',
    '견적서 보기 / 서류추가등록 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-812';
SET @content_hash = '6c2fc446efb77688b93a308eefb52b0fe2500cdd38b9c5029205aacc5645da0c';
SET @sort_order = 237;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 배정
(발주완료 14일 초과)',
    '하나인 - 통합발주관리  "배정" 상태의 경우',
    '재견적 / 견적서 보기 / 서류추가 등록 버튼 유무를 확인한다.
''▶ 재견적 클릭시 재견적 프로세스 진행  (발주완료 14일 초과하여)',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-813';
SET @content_hash = '1b50a20b953a2dc09449369fb43c4a3afd757df97563c7ecf5e364bfdcf513d7';
SET @sort_order = 238;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
    '-',
    '재견적 진행
현황 : 가견적,',
    '재견적 진행 
→ 가견적 상태의 상세 조회 화면 하단 버튼',
    '재견적/견적서발송/견적서 보기 /견적 확정 버튼 유무를 확인한다.
견적 확정 이후, 견적 탭으로 정보 승계된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-814';
SET @content_hash = '10fce3548b2465a09df6b7bc95d7fb060f3423e8d63c4cc8f5bf9feb92512163';
SET @sort_order = 239;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-815';
SET @content_hash = '6c182ebfc867153cf57afc1bbf94c820d5c67608d56d1bcf5e8f952595180d6d';
SET @sort_order = 240;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
    '-',
    '현황 : 견적, 동의전',
    '견적 동의전 케이스',
    '[상세조회] 버튼 클릭하여, 
해당 정보 확인과 하단에 재견적, 견적서 발송, 견적서 보기, 신용정보조회 동의 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-816';
SET @content_hash = '6f8d2732fe99ec20b22aed6d9428ca5992940f510379d24a7037ec28d15e36b8';
SET @sort_order = 241;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
    '-',
    '현황 : 견적, 동의완료, 
고객구분 : 개인, 개인사업자',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-817';
SET @content_hash = 'eb7b644742dfe4167bec267c73a718b267abdcdb376787af01030dcce9604551';
SET @sort_order = 242;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
    '-',
    '현황 : 견적, 동의완료, 
고객구분 :법인',
    '견적 ''동의완료'' 케이스 - 신용조회 완료 상태일 경우',
    '[상세조회] 버튼 클릭하여, 
해당 정보 확인과 하단에 재견적, 견적서 발송, 견적서 보기, 심사신청 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-818';
SET @content_hash = '261e56d5f6aeb2223022fffbec58bc69bea3f86a2b83d6ba62bf39f8a08252b3';
SET @sort_order = 243;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_견적',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-819';
SET @content_hash = 'd12878eae8a1b6e5ffd425628645e8899d2b307e47ff52236aab154e4719ece6';
SET @sort_order = 244;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 승인',
    '심사 상태 값 : 자동 승인, 
승인 된 상태 ''승인'' 노출',
    '재견적 / 견적서 발송 / 견적서 보기 / 서류등록 / (대체)발주요청 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-820';
SET @content_hash = 'f47703691c4cfa265e28655446f8f9d3c0697016226718fc59b9c32379fac402';
SET @sort_order = 245;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-821';
SET @content_hash = 'c9df26a20a6e36e2a5c998ebbc89fca8d5f3df35bcf3b7d3d8672bc33b1b6894';
SET @sort_order = 246;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-822';
SET @content_hash = 'f170404e0accba123fd8cd672d485a7a9bed97c2ee4458dbc9d532d9e3bc153a';
SET @sort_order = 247;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, (대체)발주요청',
    '[(대체)발주요청] 버튼 클릭한다.',
    '발주 요청 진행 팝업 → 발주요청 완료 얼럿 내, 확인 버튼 클릭시
''(대체)발주요청'' 버튼  → ''발주요청 완료'' 로 버튼명이 변경되고 버튼 비활성화 

▶ 견적서 보기 / 서류추가등록 / 발주요청 완료(비활성화) 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-823';
SET @content_hash = 'c67c49d0621421b0feb79bfa10c04f218ed663345e62943e9ca19ad3320aeb06';
SET @sort_order = 248;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황 : 품의, 대체 취소
(발주완료 14일 초과)',
    '재견적 건 ‘(대체)발주요청‘ 시 
최초 발주건은 상태 값 확인',
    '상태 - ''대체 취소'' 로 바뀌고, 하단 버튼은 [견적서 보기]만 출력된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-824';
SET @content_hash = 'adb0ebe884baa1b7e7478b56a74ae68fa47356627088025f85c2db05caceee6d';
SET @sort_order = 249;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황 : 심사, 배정',
    '하나인 - 통합발주관리  "배정" 상태의 경우',
    '▶ 견적서 보기 / 서류추가등록 / '' 품의등록''   버튼 유무를 확인한다.
(참고:배정(품의등록)→출고요청→결제완료→센터입고)',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-825';
SET @content_hash = '25444a58504c1eded512cc83e86cb1f7f004ac862b37681d9870cdb5ebec35fc';
SET @sort_order = 250;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-826';
SET @content_hash = 'a55ab5d579497863f35e58faa97f03f5fb78c76c385c2f2aa32cc00b39cdecdb';
SET @sort_order = 251;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-827';
SET @content_hash = '1392d751989abf4501101afb3b70633423407e587d4f45624d1598f6875271d9';
SET @sort_order = 252;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-828';
SET @content_hash = '1f5132acebb4458fdc35243a2eb8ce9aef5292be3d236c3d1be7bea3b8768415';
SET @sort_order = 253;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-829';
SET @content_hash = 'deda847785aa3ffca7890080f54289a785f5878b533ea68efd6f82fbb7d5d311';
SET @sort_order = 254;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-830';
SET @content_hash = '9391e7566559a1a7876295c877a4bdbcce9cfb49eed4e5d27842eaf442892b58';
SET @sort_order = 255;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-831';
SET @content_hash = '776e1521a435df797d965245cbeac2920a491703ac3d2950bcdb3a5d60e3d59c';
SET @sort_order = 256;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 배정
국산차',
    '[품의등록] 화면에서  핀매점 정보를 확인하기 위해 판매 대리점 검색을 진행 한다.',
    '[판매점 조회 팝업] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-832';
SET @content_hash = 'b43f6f3dd149373fcb2646a86594c945d6356cdb17a66d35ae3005b0ced194b1';
SET @sort_order = 257;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-833';
SET @content_hash = '401f49abae3e1aa87217fc70cbf45e264cc05f3960f4d93d127777aff1b3b1fc';
SET @sort_order = 258;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 배정
국산차',
    '조회 결과가 없을 경우 → [판매점 조회 팝업] 화면에 검색 조건을 선택하고 검색어를 입력 후 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 ''검새 결과가 없습니다'' 문구가 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-834';
SET @content_hash = '00074599d0bc43ae5bf15e801169516093eb13ac84e6298b0dbf9b2df4d30771';
SET @sort_order = 259;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-835';
SET @content_hash = '84f193848e45d92afa1138cadee144d77bd43b7ded862f5d48b2052f43a5ac29';
SET @sort_order = 260;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-836';
SET @content_hash = '34fa31eb015d1ff906496b377a3cbdd7c2acaa0ba101d5a1ad12024f64103dd1';
SET @sort_order = 261;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-837';
SET @content_hash = '905c0a22fe07846f0e65e87d8bcacbbdb82b0098093397b8d5ec94778c70420e';
SET @sort_order = 262;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-838';
SET @content_hash = '662ca8abe578764abcd624a65d0e9e4d929baf72c2a255246b5a9936932f10e2';
SET @sort_order = 263;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-839';
SET @content_hash = '31baefd5a93913038dee1e4458000eb911c12186148382372647a6e9bf42d460';
SET @sort_order = 264;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 배정
수입차-제휴사',
    '전시장(판매대리점) [검색] 버튼 클릭, [판매점 조회 팝업] 화면에 검색 조건을 선택하고 검색어를 입력 후 [조회] 버튼을 클릭한다.',
    '검색 결과가 없는 경우, 조회결과 영역에 ''검색 결과가 없습니다'' 문구가 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-840';
SET @content_hash = 'a04d9c7456e1d7c699764fc8c52cfdaa6243869a83c4a903b60fc4abf4a20aa6';
SET @sort_order = 265;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-841';
SET @content_hash = 'c96c1be8b2cc59814669b2237d46bd8f31e00eedd907d15b5f2526eb326e065a';
SET @sort_order = 266;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 배정',
    '[품의등록] 화면에서 판매사원 [검색]버튼을 클릭한다.',
    '[판매사원 조회 팝업] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-842';
SET @content_hash = 'f6af944d5daae3210054951c2c6cb92c9f0d976c1719099209f827cc203e2620';
SET @sort_order = 267;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 배정',
    '조회 결과가 있을 경우 → [판매사원 조회 팝업] 화면에서 조회조건 조회 값을 입력하여 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 결과가 조회된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-843';
SET @content_hash = 'd07d98c28172893d1c0e8d397ea381c243f2ff3bd919e5ec49382ab8a655409c';
SET @sort_order = 268;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 배정',
    '조회 결과가 없을 경우 → [판매사원 조회 팝업] 화면에서 조회조건 조회 값을 입력하여 [조회] 버튼을 클릭한다.',
    '조회결과 영역에 ''검색 결과가 없습니다'' 문구가 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-844';
SET @content_hash = '9789baf71c2d3ff73634e1e24765ab8aa3bb19c3a6cd42cddaad3643e2a847a3';
SET @sort_order = 269;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 배정',
    '[판매사원 조회 팝업] 화면에 검색 결과를 클릭한다.',
    '[판매사원 조회 팝업] 화면이 닫히며, [품의등록] 화면에서 선택값이 판매사원 영역에 반영된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-845';
SET @content_hash = 'b438375ad3f6d772f61d66b9bf6cab3613cfc67fbbf8ca17f56d11fd7f659522';
SET @sort_order = 270;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-846';
SET @content_hash = '75e4754f8aed69cf4d60d6d3c2ce27a6f560f071db6aa102cf1867eb1b8d8573';
SET @sort_order = 271;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-847';
SET @content_hash = '87525a099ddec289f83dd1bc53efdd31a6ba01ee830125c41bdfcb5e8ab6f06a';
SET @sort_order = 272;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-848';
SET @content_hash = '883a9abeb4a46bf04232211dc02abd4a9defddf6a9add5815758f6dbc8878bc5';
SET @sort_order = 273;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-849';
SET @content_hash = 'cb9860f7f80d6c4000a01ec1cc44a2a573c53a377de9a20c179b58f39abb9703';
SET @sort_order = 274;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-850';
SET @content_hash = '201310de64004a9236b6def3ac1df997e94c076d7a226775831eb15562ee4b71';
SET @sort_order = 275;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-851';
SET @content_hash = 'e408474f7fc924ea74de7e4ebafbc8a8f9c73c3c8ec97685a7350f4414c2c4b1';
SET @sort_order = 276;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-852';
SET @content_hash = 'd035d108eec8ec6d8bd342fde670667dbb6b22c3ba70198a1fdee72a69687db3';
SET @sort_order = 277;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-853';
SET @content_hash = '3a9cf484540fd1a32a5f426b55dd07e179979f9448244c66a66d26804e87cc9c';
SET @sort_order = 278;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-854';
SET @content_hash = 'c57aef024a487adaac8183370a2d732bc06ad7efbdbe3cc258d41f19cf41b613';
SET @sort_order = 279;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-855';
SET @content_hash = 'ab70ff73e54c94f46a343b52d2a0258f2872ccc52c9ea5d38855437a3fa8e1ba';
SET @sort_order = 280;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-856';
SET @content_hash = '001626ea53717931080464f56dff83b9b4b84fbba830210dabac4e635933ede1';
SET @sort_order = 281;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 배정',
    '[품의등록] 화면에서 [서류등록] 버튼을 클릭한다.',
    '[손님서류등록] 화면이 표시된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-857';
SET @content_hash = 'f97fcc73e497822a393207bd5f8e470ae1d7f190931a2fcc74707d3a60039e26';
SET @sort_order = 282;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-858';
SET @content_hash = 'b867c0bccf51a9c4b3c05ba466bb0340440d1494755fb363e4559e0880a9a812';
SET @sort_order = 283;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-859';
SET @content_hash = 'd1a65186df55792276a22c7b5051f338e02b8de885ab763f600f53bfbfbfa2a2';
SET @sort_order = 284;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-860';
SET @content_hash = '776eeaf29f3a39f14027df3c3a8467400cd4ce6ff490d932e4c5743c517bd57c';
SET @sort_order = 285;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-861';
SET @content_hash = '203dc45ff5f809e096336e42bd6820fbee53fa5c883458dd1b7b793c6d7d68d9';
SET @sort_order = 286;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-862';
SET @content_hash = 'df17a7f680dadbcf0770154f4f3a7ce5d98d63563551a5b8a6e9e246f99fe1ad';
SET @sort_order = 287;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
    '-',
    '현황 : 심사, 배정',
    '[고객서류등록] 팝업의 [저장] 버튼을 클릭한다.',
    '팝업창이 닫힌다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-863';
SET @content_hash = '66534a2418eba94ddb308478df3311239a3e6793b33462fe45c503bcfcb18e5e';
SET @sort_order = 288;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_심사',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-864';
SET @content_hash = '1e4df7e6828c293b8e060ea0ca89574896ce2d726e5c74332e424abb3ace7046';
SET @sort_order = 289;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황 : 품의, 품의요청',
    '배정"상태의 품의등록 완료 시 상태이며,
하나인 - 품의등록 "저장" 버튼 미실행 단계',
    '견적서 발송 / 견적서 보기 / 서류추가 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-865';
SET @content_hash = 'f715deeafcdafea60d8c51eb5019e6878f56073c89f1d2e5f7054327c0dd2e7e';
SET @sort_order = 290;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-866';
SET @content_hash = '118e76700554d9f623195917c6d6a1afd3049137aeb8ebf28ddc2eb307d48757';
SET @sort_order = 291;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-867';
SET @content_hash = 'b77d63552fb1772adc6c4d6263b785ce7c0f18c0c1578c9ffbf08b6de56a474e';
SET @sort_order = 292;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-868';
SET @content_hash = 'e0e198210fcb5fcd9d52337695f3af86f86c2bd01b6cf3f8af7dd1b4d3f00c52';
SET @sort_order = 293;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
    '-',
    '현황: 품의, 품의확정
법인사업자',
    '하나인 - 품의등록 "저장" 버튼 실행 하면',
    '견적서 보기 / 서류추가 등록 /연대보증계약서 다운 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-869';
SET @content_hash = 'b762ad032d74ba643e12ce662edd87bc3ea0e698b9e5cadd012140d3f39a6cc0';
SET @sort_order = 294;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-870';
SET @content_hash = '729940dab9baf269ea6efc231143a734e18b6ecc3a6758b74d95e145b5da0366';
SET @sort_order = 295;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_품의',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-871';
SET @content_hash = 'ddffc9be2e55a5e81f241f7964c8574dd9147522efc0b9fd2efd5dda605d03be';
SET @sort_order = 296;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 송금완료
외주탁송 / 1+2탁송',
    '하나인 - "선급완료" 처리 시',
    '견적서 보기  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-872';
SET @content_hash = 'a39bc10660620ed6d7b528a7783037395e39c2e25b5b7dc12de999a377f879f4';
SET @sort_order = 297;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
    '-',
    '현황: 인도, 센터입고
외주탁송 / 1+2탁송',
    '하나인 - "선급완료" 처리 후 “센터입고” 시',
    '견적서 보기/  인도요청  버튼 유무를 확인한다.
- 인도요청 후, [인도요청 완료]로 변경',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-873';
SET @content_hash = 'd5621daf3acb718943965cfd63041b720c691b065fcf81638936feb729984d49';
SET @sort_order = 298;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-874';
SET @content_hash = 'ff7342e6efcfa3ecafefda6e4dd401d51c505a84bb932bcd28a5dd35d8e89a6f';
SET @sort_order = 299;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-875';
SET @content_hash = 'd481537d701651e6d8e510f412b272f571a98e577a6a5c54f47890a8b9203208';
SET @sort_order = 300;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-876';
SET @content_hash = '812ed0f5437ea961cf58c4f31f951be816211db995e17abd44bac9d89258a2bf';
SET @sort_order = 301;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-877';
SET @content_hash = '62f3e5611860b332c2ae8e03e468e86ed1116a91ece2b221058054dff1a5b276';
SET @sort_order = 302;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-878';
SET @content_hash = '3790cb0e2082bcebcdd9ac296dbf430adf780ee311a1f41c401e8e95795cd825';
SET @sort_order = 303;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-879';
SET @content_hash = '31ea50f2c64f6c5cd0e0baffe7088bc2ec6690e41d3fbec373890873a375b147';
SET @sort_order = 304;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-880';
SET @content_hash = '36d96ca13e4a35c5fa9c29452faa42fd16eff98ca152f5e722ffb3ca7c1cd751';
SET @sort_order = 305;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-881';
SET @content_hash = 'ccf7617a582d9239ea90ded566181631ffebb56dd97f078f4cfbfc630a98e9e3';
SET @sort_order = 306;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-882';
SET @content_hash = 'cbe0899117b4eecf173d8d329117018cb2fa9d5da3b9a6b1fd561d4e04bc36d8';
SET @sort_order = 307;
INSERT IGNORE INTO tmp_import_test_cases (scenario_code, case_code)
VALUES (@scenario_code, @case_code);

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET sort_order = @sort_order,
    updated_at = IF(sort_order <> @sort_order, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND @same_current_count > 0;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
    name, location, precondition, test_steps, expected_result, content_hash,
    is_current, is_deleted, sort_order
)
SELECT
    @test_scenario_id,
    '장기렌터카',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '장기렌터카_인도',
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

