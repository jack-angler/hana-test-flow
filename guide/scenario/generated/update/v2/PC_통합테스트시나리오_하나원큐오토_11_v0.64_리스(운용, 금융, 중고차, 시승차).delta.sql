START TRANSACTION;

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @test_run_name = '리스(운용, 금융, 중고차, 시승차)';

SELECT id INTO @test_run_id FROM test_runs WHERE name = @test_run_name;

SET @scenario_code = 'SN-NW-500';
SET @scenario_name = '신차리스(운용,금융-국산차)';
INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)
VALUES (@test_run_id, @scenario_code, @scenario_name, 1)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    updated_at = CURRENT_TIMESTAMP;

SET @scenario_code = 'SN-NW-600';
SET @scenario_name = '신차리스(운용,금융-수입차)';
INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)
VALUES (@test_run_id, @scenario_code, @scenario_name, 2)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    updated_at = CURRENT_TIMESTAMP;

SET @scenario_code = 'SN-DM-500';
SET @scenario_name = '리스(시승차-수입차)';
INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)
VALUES (@test_run_id, @scenario_code, @scenario_name, 3)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    updated_at = CURRENT_TIMESTAMP;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-531';
SET @content_hash = '7d4f553e319560395bb145a7302ae164dfaf75bfa6b4889023672efd0a41560e';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    1
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-532';
SET @content_hash = 'b862acbd08cc6e38772aaaa4426837adc091678898d18a64b665a0438ea78f01';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    2
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-533';
SET @content_hash = '0d482f11361c20a9ecc2705f28bfc1ebe2fc0b35cea6a2d16933ae8d227a500a';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    3
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-534';
SET @content_hash = '16672a8beeca90f09c1682a44f09d810e893f20c4d828020870737033246a9a9';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    4
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-535';
SET @content_hash = '3461125667d3b5f16812338b0eb080a99868ce2647a591f707e3392eca6b51ba';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    5
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-536';
SET @content_hash = '3dcdbcf88512e0d435ac18633229440c20f0f7bf20a34197561a7c6f7363d2dd';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    '견적서 발송 / 견적서 보기 / 서류추가 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    6
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-537';
SET @content_hash = '59fb14f2b76c06cd47943a5ae06d9799bdd42679e0f187ff90ef7e5551e48168';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    '견적서 발송 / 견적서 보기 / 서류추가 등록 / 연대보증계약서 다운 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    7
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-538';
SET @content_hash = '34314a448fab2002b8bbb0833b15a5c90621c849a367306733051ed56dd82360';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    8
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-539';
SET @content_hash = '4671b624c76988b1da6e7752d660349792458ec6d4583ab2e2f0872c23d59a5e';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    9
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-540';
SET @content_hash = '7aa9ffb4ebb542912e62cd0d2d2d84c90ac3e934d44c3204ed69676c3e07eda8';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    10
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-541';
SET @content_hash = '88039fb5d39f1761ac5ae2b395c3a22e89c1dade8c6e68bd798e3eca22e8f346';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    11
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-542';
SET @content_hash = 'c0d5772676c62db25a08f2f8b6c2f25b164fa93d6dee67f59b74aff94d3233f8';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    12
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-543';
SET @content_hash = 'df9a4a6711861dd879c004719e7644d2a043846422387626f88af7ae45db443a';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    13
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-544';
SET @content_hash = 'abff1061aa5969495363c028dca10f96f4ec89dece71b9f8f8e89653d79257bb';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    14
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-634';
SET @content_hash = '1518e517c030e69064ab6db183185998d78a8612aadd23bb0cae42cf7be29ce2';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    15
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-635';
SET @content_hash = '862a38247d9802e76e7e9c2d355daedc26e2f62a53f8e69f9c4f71299f35b644';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    16
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-636';
SET @content_hash = '83c1fd3a5f3afdb0156baeffe3029e6352328fd299a95c370c2e8eb4e1159f99';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    17
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-637';
SET @content_hash = '0e719b65c26c6acc8a2ac4c06890f8a5e6319193160ff9a7f9ea7336918142c6';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    18
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-638';
SET @content_hash = '564012087b3eff2300014394387c4e0c9d949547f252a3dcab6f79958a09c085';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    19
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-639';
SET @content_hash = '46c5d8558c061756ed8db828645d0a45c2c4f628be1217d0f73090c731131735';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    '견적서 발송 / 견적서 보기 / 서류추가 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    20
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-640';
SET @content_hash = '9b87dba751e3f823e79c1787d9ec61c0470269123861672fe70f99ecd0cfc54b';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    '견적서 발송 / 견적서 보기 / 서류추가 등록 / 연대보증계약서 다운 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    21
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-641';
SET @content_hash = '8672f78fe37ddb8aa86d3aa2d9e0543f9259aa486746e3956f218554eca6ae50';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    22
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-642';
SET @content_hash = '3bdf65d0241aaedf2f3f2c76bc12745bba8e2b1120ed70c41f5c88c9a649888d';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    23
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-643';
SET @content_hash = 'cd6249763ffdb006240e6a513e2f16d86dadf71eca3f06f126c440e7402eb731';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    24
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-644';
SET @content_hash = '2aeae2e54cf7d503e2903ea8cae09c7d455baaaed20d81bf064595013bc47f4d';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    25
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-645';
SET @content_hash = '1a13d41398a326fcc24c029e168a0f9aa66df78dcc5bd3402b094cf19974211e';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    26
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-646';
SET @content_hash = '635d5b34e58abec9132840eb63692a8fb07180a0dd5bb2999a5a5dc9d47c79a1';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    27
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-647';
SET @content_hash = '75688f713db07247b7550ea7feaca64e678ee643763277b7423c1852b6927a53';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    28
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-530';
SET @content_hash = 'c736128cbe759990dcd66dc61f99a8f38ee882208a2cc481e3cea5bde718fe2a';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    29
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-531';
SET @content_hash = '3c663d17637c4e78c30530cfde63af6d346d7d1d6037a0d47c46b4edfcfdd5f4';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    30
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-532';
SET @content_hash = 'a538d5dd0c06e1df3df04f31a8f240e4496b7fd766afea748e4398b36b4722e1';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    31
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-533';
SET @content_hash = 'e9a1584a3ba00de13f6dd141ef283dbe5b7567bddf979ba83c7e132e2ce04d4b';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    32
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-534';
SET @content_hash = 'f46d3f3572650364c7c83214e39d56681314c9717d426ba50582a6a232129b2c';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    33
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-535';
SET @content_hash = 'c27ab3097d49ba61e81ed08981a68e5d490273ce45699e0b46289b7a5f8b7d08';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    34
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-536';
SET @content_hash = 'de9fc24647fdcb266a6db3244c1009e96585da30dc56dbf0f81b28b7c9f51778';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    '견적서 발송 / 견적서 보기 / 서류추가 등록  버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    35
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-537';
SET @content_hash = 'a5faecc7dc763ee9c04bd204474bb3745ae6b3028d5f0c04e0e7f73e1dc67ba5';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    '견적서 발송 / 견적서 보기 / 서류추가 등록 / 연대보증계약서 다운 버튼 유무를 확인한다.',
    @content_hash,
    1,
    0,
    36
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-538';
SET @content_hash = '26c2f43b09af743da448d3cc66e4ea3bfca52de784525abc716c61db65cda68a';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    37
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-539';
SET @content_hash = '906c9a89df5d51caccf81f520347d1183e1b24fbed6733ec00a4a98ac1b89ace';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    38
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-540';
SET @content_hash = 'd24daea8d17a7ca2736abff66f880fd2a494a134182b8acc21518f474c7ef58d';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    39
WHERE @same_current_count = 0;

COMMIT;
