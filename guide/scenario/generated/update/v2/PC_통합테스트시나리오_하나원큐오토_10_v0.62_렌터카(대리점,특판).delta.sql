START TRANSACTION;

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @test_run_name = '렌터카(대리점,특판)';

SELECT id INTO @test_run_id FROM test_runs WHERE name = @test_run_name;

SET @scenario_code = 'SN-LR-500';
SET @scenario_name = '장기렌터카_대리점출고,';
INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)
VALUES (@test_run_id, @scenario_code, @scenario_name, 1)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    updated_at = CURRENT_TIMESTAMP;

SET @scenario_code = 'SN-LR-600';
SET @scenario_name = '장기렌터카_대리점출고, 발주완료 14일 초과시';
INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)
VALUES (@test_run_id, @scenario_code, @scenario_name, 2)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    updated_at = CURRENT_TIMESTAMP;

SET @scenario_code = 'SN-LR-700';
SET @scenario_name = '장기렌터카_특판출고';
INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)
VALUES (@test_run_id, @scenario_code, @scenario_name, 3)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    updated_at = CURRENT_TIMESTAMP;

SET @scenario_code = 'SN-LR-800';
SET @scenario_name = '장기렌터카_특판출고, 발주완료 14일 초과시';
INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)
VALUES (@test_run_id, @scenario_code, @scenario_name, 4)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    updated_at = CURRENT_TIMESTAMP;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-549';
SET @content_hash = '085ad4fa270b2ea29d81316b1afc088902e4adf7a45a9083b132aff4ac4265a0';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    1
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-550';
SET @content_hash = 'ceb557337eb52b9a2bc48bf972b99f045ceb83ff9cdff19e921edce47a9764aa';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    2
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-551';
SET @content_hash = 'ebed92eb77ca2fb71d914e365666402d423ccdc615ee479f803b35084cfbb8d5';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    3
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-552';
SET @content_hash = '3de4231d35120e7069d0edb353fd7c76dc53bfdea777a6f8cdc5063c8a688c0e';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    4
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-553';
SET @content_hash = '41b5e186a36bcb367305ad1a358747547b1890a228726e5500afa17b3c19644e';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    5
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-554';
SET @content_hash = '0db070a9f9f36ec3da230ef0e407d462e6f9e518b9a241cdfc5cf27811044769';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    6
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-555';
SET @content_hash = '1acf53d2bb09a9e2b503abb6f9bd2a60fd1fda10cb999a04a75a165de03269da';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    7
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-556';
SET @content_hash = 'eda95d697706f80079ef9bc0003e04a660d1c10f1fbd3a5a8be31a4a80e47af0';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    8
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-557';
SET @content_hash = '2b053b32a93d8dc3d6a7ebb0dd6362aeff3731866ae33d2deecfdbf6be26d094';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    9
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-558';
SET @content_hash = '2ae6c3a18ed8ce4f7a0a85c4a95664262ac7a9e0168f6b671a188970834900f6';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    10
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-559';
SET @content_hash = '0c533e182c708961c8997a035f50bc323ee881749c8dbf8e231d16b10c9c33dd';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    11
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-560';
SET @content_hash = 'f3c9f49364558175fadf078c3a096eb829a229845e78e18a082250d4b7936a17';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    12
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-561';
SET @content_hash = '3fb4a038c751e23abf769707e409e52f74671fa5b3c6d1a7d86a55394ade0ae3';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    13
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-562';
SET @content_hash = 'b72e4d854c9ea6f69b57158eb0edce56fb9cd3d0147175fc558d11e6a526c9e4';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    14
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-563';
SET @content_hash = '266fec3089c2e13821089b9723edf35797555c504528227c0f3e10a3d11d77d7';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    15
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-564';
SET @content_hash = '5f67a7958fb6ea21a4aaa2325cf7a625eef1c566e290f8c00c682ab764db084d';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    16
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-565';
SET @content_hash = '56cbed8368d91308500692823ec541cda4feb5bb294de9ac680a31fe31d3d2a0';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    17
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-566';
SET @content_hash = '18802ba71332275e8fbbfcf58611db97b0bf2c986558a6d9f3c2a84a9cef164b';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    18
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-567';
SET @content_hash = '2579c9b7f4f5c6cede4e83a3b042b5e145d02e3b48712ffcbd4eb02807932dd7';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    19
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-568';
SET @content_hash = 'c2b5cd200dba56944641f42a14ea3317b6d65a889e8a05dee4d06d2670834272';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    20
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-569';
SET @content_hash = 'b4587140e4176bab40b13c9a9336ad09dc12463f8819cb0e5a7279870be9f660';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    21
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-662';
SET @content_hash = '5028e9d3287406eff0a5d757e5c509ceb305552a05fc00a5ce75fd41a5452f30';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    22
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-663';
SET @content_hash = '066721d6ea14cd314b20aa685f706b918e6ff08bca554d916f395cd14420660f';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    23
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-664';
SET @content_hash = 'd71240f3e298388a368bd1eee11507015541e235ead0b90fe5033b6c02a37c33';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    24
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-665';
SET @content_hash = 'b6777fbec926bdd9f2e4a458001375a2ca5d992c4d70ddcea02b2dcc3c3ef6e1';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    25
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-666';
SET @content_hash = 'c34eb707f537902f4c363dd18f33a6293031d4dc7d14b583f3d938535834e976';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    26
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-667';
SET @content_hash = 'df2cc5819352b58afa668ca8e836d8ded038652c95ba251f49980818cb5e0c0c';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    27
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-668';
SET @content_hash = 'e7400679269fb3c81e559a36ddb152eacd7de2604135d67d24a2d7a272be7eee';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    28
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-669';
SET @content_hash = 'a0d3338dedd9a18e9e0cd8210541cb291f65d4286f0fb5d84b54bdbd3208bb7e';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    29
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-670';
SET @content_hash = '7b00429360463554844c6ed4e0c6132cd3c45924b6d31041b2da95f0475072c2';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    30
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-671';
SET @content_hash = '27b6665a56027e0d6ac0cc523c77616588627b00889a523a68644a5d4e08b708';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    31
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-672';
SET @content_hash = '7b3c805952f83d584884555702c4242881e330dcc6bfd5947139011241d92ad6';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    32
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-673';
SET @content_hash = 'df2929812da73cbc78f7ace1e6d44aceab64526fbdcca1b876f81ae007845aac';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    33
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-674';
SET @content_hash = '6179be79ac384fc2e6e3c16ef58d6a6e95b1c692188fcab0bd2ea847d6a570c2';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    34
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-675';
SET @content_hash = '4afbb200e26cba109e8007383b6e2c06032ec40448a36ed6b87eb7b6dd0f92fc';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    35
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-676';
SET @content_hash = '338e78364cf49f736e6f5c88cd6470e948a9634d94474ade41c1007f180169ef';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    36
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-677';
SET @content_hash = 'c0d372dbb50a0c5101308c15e90f7f3775df371165481f4bf20a8b4245067233';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    37
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-678';
SET @content_hash = 'fc41b8503c91ecd2d767db2740c1c1ab5222be66e17e0b7badb9bd699bbd5cde';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    38
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-679';
SET @content_hash = '83f608aba0918782ce878f2998bef4d97b5f745693d0fb7c9c20caca3bc90812';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    39
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-680';
SET @content_hash = '693ae6f7ab636f43e77036c1e5fe02122304bb308bc88bbb4f26ba79f57f19cc';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    40
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-681';
SET @content_hash = '8856850f57d59a47ec3b0a58b78017d89b93d33ce1c3ae98d7288f6f880c0cfb';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    41
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-682';
SET @content_hash = '4882fdad789a79353f78f7f09c8e99def5b0003d49435ed9773c63fa4937af9b';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    42
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-750';
SET @content_hash = '1c4ac5017b9271c419e3c340a77428a431cf490c70985f8eaebf83256bb37765';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    43
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-751';
SET @content_hash = '3cb6e4c933348e86c8b448e408b3ba833decded96e5c4bc0a29a4036be2bf2fa';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    44
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-752';
SET @content_hash = '78cd1979d7e462814614cd036cc7bbc5ba2aa2142fe7540998ea8a509f4c7231';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    45
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-753';
SET @content_hash = 'baebaa46dfdc1a37564b4122c24f03f99576378d04f16259cdbf1463aa94932f';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    46
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-754';
SET @content_hash = 'cfa4cd5cda53ff95cc0995518934ebf7ef88a05f6ccd6acec7a7943a774240b6';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    47
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-755';
SET @content_hash = '547cadeec7eb9e55d0e9a4c4333178d8d45a393ea022401c13a9c6ad34274e86';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    48
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-756';
SET @content_hash = 'c8d6a9698299683f5130102f981265dbe18317d1255648641c8c74f2e331954f';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    49
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-757';
SET @content_hash = 'edc3877d4412d6b9f76f450a5bb29a5647c0ef1e99c0a841502f25367c504a34';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    50
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-758';
SET @content_hash = '9ea2eab92742380051517d9b51e590de229b57e68016aaaae86c1c61587e3a06';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    51
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-759';
SET @content_hash = 'f3f3b06380a063067d9bd83347ac26edf259efca35de883d5855c045c3d2f483';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    52
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-760';
SET @content_hash = 'dee49e97c1e23bed8efd63ff6da7ab16a812e80d5295aec3352c125579d7168a';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    53
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-761';
SET @content_hash = 'cb59f02e3f94a7ebbbeb891314ce39411cdd1a091be2b6c146336cc7f6c247d7';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    54
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-762';
SET @content_hash = 'c316cbfa015b67ab4f7888806d94b9834c43f90cbeab3410d92c8265a29f4edc';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    55
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-763';
SET @content_hash = '3f5c109c1bba638817f3e7c081bcd206fec6f583c31fc6817429f6a06abb554e';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    56
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-764';
SET @content_hash = '3f66cd44b11b7a0969b2ad4e535cd70d49f3d3c0c3a38f8f97104b1095f99521';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    57
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-765';
SET @content_hash = '6bb5e4cf9a1670a59b8afc6f945fb071e2335e808c3d06f1e14882f628fd2b06';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    58
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-766';
SET @content_hash = 'b6040b097ca1d8ac3733ddaed1f5c137ddbcd7da26fc5deb2a4b7ad0ca7be2d6';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    59
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-767';
SET @content_hash = 'bf0810e554396bf23059c0271505a57b117a775ff243d23eb967d83e168a1f62';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    60
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-768';
SET @content_hash = 'd8ce4ab5689e75492e1c5a79ee5c318dd0cc5a915edbff37d36bcd599272072a';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    61
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-769';
SET @content_hash = '2769cdeace66b48b42520ae29b8fc6c12544c442bd54bb8ad9ae94a42ae9daa7';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    62
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-770';
SET @content_hash = '25e2bd84417faea6b07a473a31b3e9830649669c182121d25b09f7e5fdcca99c';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    63
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-862';
SET @content_hash = 'df17a7f680dadbcf0770154f4f3a7ce5d98d63563551a5b8a6e9e246f99fe1ad';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    64
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-863';
SET @content_hash = '66534a2418eba94ddb308478df3311239a3e6793b33462fe45c503bcfcb18e5e';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    65
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-864';
SET @content_hash = '1e4df7e6828c293b8e060ea0ca89574896ce2d726e5c74332e424abb3ace7046';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    66
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-865';
SET @content_hash = 'f715deeafcdafea60d8c51eb5019e6878f56073c89f1d2e5f7054327c0dd2e7e';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    67
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-866';
SET @content_hash = '118e76700554d9f623195917c6d6a1afd3049137aeb8ebf28ddc2eb307d48757';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    68
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-867';
SET @content_hash = 'b77d63552fb1772adc6c4d6263b785ce7c0f18c0c1578c9ffbf08b6de56a474e';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    69
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-868';
SET @content_hash = 'e0e198210fcb5fcd9d52337695f3af86f86c2bd01b6cf3f8af7dd1b4d3f00c52';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    70
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-869';
SET @content_hash = 'b762ad032d74ba643e12ce662edd87bc3ea0e698b9e5cadd012140d3f39a6cc0';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    71
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-870';
SET @content_hash = '729940dab9baf269ea6efc231143a734e18b6ecc3a6758b74d95e145b5da0366';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    72
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-871';
SET @content_hash = 'ddffc9be2e55a5e81f241f7964c8574dd9147522efc0b9fd2efd5dda605d03be';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    73
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-872';
SET @content_hash = 'a39bc10660620ed6d7b528a7783037395e39c2e25b5b7dc12de999a377f879f4';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    74
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-873';
SET @content_hash = 'd5621daf3acb718943965cfd63041b720c691b065fcf81638936feb729984d49';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    75
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-874';
SET @content_hash = 'ff7342e6efcfa3ecafefda6e4dd401d51c505a84bb932bcd28a5dd35d8e89a6f';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    76
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-875';
SET @content_hash = 'd481537d701651e6d8e510f412b272f571a98e577a6a5c54f47890a8b9203208';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    77
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-876';
SET @content_hash = '812ed0f5437ea961cf58c4f31f951be816211db995e17abd44bac9d89258a2bf';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    78
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-877';
SET @content_hash = '62f3e5611860b332c2ae8e03e468e86ed1116a91ece2b221058054dff1a5b276';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    79
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-878';
SET @content_hash = '3790cb0e2082bcebcdd9ac296dbf430adf780ee311a1f41c401e8e95795cd825';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    80
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-879';
SET @content_hash = '31ea50f2c64f6c5cd0e0baffe7088bc2ec6690e41d3fbec373890873a375b147';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    81
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-880';
SET @content_hash = '36d96ca13e4a35c5fa9c29452faa42fd16eff98ca152f5e722ffb3ca7c1cd751';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    82
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-881';
SET @content_hash = 'ccf7617a582d9239ea90ded566181631ffebb56dd97f078f4cfbfc630a98e9e3';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    83
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-882';
SET @content_hash = 'cbe0899117b4eecf173d8d329117018cb2fa9d5da3b9a6b1fd561d4e04bc36d8';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    84
WHERE @same_current_count = 0;

COMMIT;
