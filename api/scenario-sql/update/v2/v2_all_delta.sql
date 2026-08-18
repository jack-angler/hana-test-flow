-- ============================================================================
-- Source: PC_통합테스트시나리오_하나원큐오토_10_v0.62_렌터카(대리점,특판).delta.sql
-- ============================================================================
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

-- ============================================================================
-- Source: PC_통합테스트시나리오_하나원큐오토_11_v0.64_리스(운용, 금융, 중고차, 시승차).delta.sql
-- ============================================================================
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

-- ============================================================================
-- Source: PC_통합테스트시나리오_하나원큐오토_12_v0.62_선구매.delta.sql
-- ============================================================================
START TRANSACTION;

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @test_run_name = '선구매';

SELECT id INTO @test_run_id FROM test_runs WHERE name = @test_run_name;

SET @scenario_code = 'SN-PO-500';
SET @scenario_name = '선구매';
INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)
VALUES (@test_run_id, @scenario_code, @scenario_name, 1)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    updated_at = CURRENT_TIMESTAMP;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-549';
SET @content_hash = 'f205595c2f7b8b72193d2daaa76f6f4abb937bb6ac6acb1d5427e000a63b0394';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    1
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-550';
SET @content_hash = '42cb268d03495ebf8f5b3b01f7aead2f61d672e4da06baa139ebe006466d768a';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    2
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-551';
SET @content_hash = 'faafdf87fd4db6a1fa6cb3b957b943ff545b0b0957a28d4e420a3c69aecfdbf0';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    3
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-552';
SET @content_hash = '1513e2a932c160e4b23d8ebb67f5c1b56eb98fad8e12360686d89d5510d75df5';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    4
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-553';
SET @content_hash = '744f24e95ccf2187e81872ec30991d43609662abd84925f2f5c7ce20897bab93';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    5
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-554';
SET @content_hash = 'c3024aac07d6f8551ee7e71678e477936b3c8e7a23ac2750d15a8807ab2aff6c';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    6
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-555';
SET @content_hash = '67d921eb76f1da6ec2a9435f95d9d19ea120cedd766f610c2af49c04d528773c';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    7
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-556';
SET @content_hash = 'd7de5fc125fe09d984a2c97f8156be4b31f951e326a2e829dd314b585c92a4ed';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    8
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-557';
SET @content_hash = 'aad8dc05dedcdc549373fe7359e98b9ec46a42b4545f3c3c34893d3662ac9b27';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    9
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-558';
SET @content_hash = '2f11d1716f094d081c696049be2f9a15cf9471642fd068a446413b9daef13148';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    10
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-559';
SET @content_hash = 'c3658c6510f253da2517ebb627bdabcfad0df87f883ee19e6c6d2fbb3877af1c';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    11
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-560';
SET @content_hash = '13c194680de0d0271f50d90fc73e84925422c952b9b3323450cce25fb2658fb8';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    12
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-561';
SET @content_hash = '356f674e37bd7cc1c3f4d0e19af64e397edc659b7e8b4aa7b1601bc46174a0ad';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    13
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-562';
SET @content_hash = 'eaa8a7ed33bdd7bf834c250f8de9b123009d9fd919cee71f21842f0b3d9dad82';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    14
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-563';
SET @content_hash = 'cebd0d5abc8df95437d78c45881f7ac999407260a718cf9d6c3f59b4a1d3666a';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    15
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-564';
SET @content_hash = 'b92d5460ef42b847559eabdd5d6d09af42ea1557b3ffbcead8e51c98d2b7b596';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    16
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-565';
SET @content_hash = 'b9bac41371e8e3b8522962dd8ea29a58705750ffb17cbc55afa199db769b1cd1';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    17
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-566';
SET @content_hash = 'd768b87ec5c00d0ae6f50223475fc5172e94e7b72acfa22a3974af80a0bf1538';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    18
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-567';
SET @content_hash = 'e620a801de8e8bdcb76b81490fdd262d71aae6c4b41fcc82bcd679e8a5591de7';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    19
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-568';
SET @content_hash = 'fb400a3775f0d59dfe8a4fb3202402b028c9b51945a1116403fdaf3072017ebe';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    20
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-569';
SET @content_hash = '5782e6b39d4abea876a5c283c97c9b943a0b442309350903d94265f50f682c64';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    21
WHERE @same_current_count = 0;

COMMIT;

-- ============================================================================
-- Source: PC_통합테스트시나리오_하나원큐오토_13_v0.63_할부.delta.sql
-- ============================================================================
START TRANSACTION;

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @test_run_name = '할부';

SELECT id INTO @test_run_id FROM test_runs WHERE name = @test_run_name;

SET @scenario_code = 'SN-IF-500';
SET @scenario_name = '할부-제휴';
INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)
VALUES (@test_run_id, @scenario_code, @scenario_name, 1)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    updated_at = CURRENT_TIMESTAMP;

SET @scenario_code = 'SN-IF-600';
SET @scenario_name = '할부-비제휴';
INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)
VALUES (@test_run_id, @scenario_code, @scenario_name, 2)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    updated_at = CURRENT_TIMESTAMP;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-532';
SET @content_hash = '1d207f4c65eb92e5de90b757faf2f1c59d6bb5cc1e3e7d5032c85fa178d2334a';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    1
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-533';
SET @content_hash = '461b1d4bc9ddae298954a6a336c896bd5df11ad96ebdb71b15ec4c0d278006c1';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    2
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-534';
SET @content_hash = '123e267457dab51c9aa2a59e23121a8dffdeed25ccbb3cd82323d89d39db68f7';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    3
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-535';
SET @content_hash = '8977325de3f21fa0a872a1584844a6956c387d61bbafdd34b4109b044bf44bb7';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    4
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-536';
SET @content_hash = 'e87b7c88c0dc7678097ba9f56403dc97ca35e23a3cafd19190cf3f4051c14b62';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    5
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-537';
SET @content_hash = '323887e218e4f0edecb74c59b82ec00fe9b20a426beea9567fdf003b19d72d9a';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    6
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-538';
SET @content_hash = '96577417ebb3b3c1c3365e7c59add419ea651c39a63a0a6694ca6f2aeb2970e0';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    7
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-539';
SET @content_hash = 'e7fd63974fe7b45c2a0f7f58e5e203a016bb2cd4310142b259f3ed7e5bb8b8f0';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    8
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-540';
SET @content_hash = 'd542290b8a6c6dc9a5291607081f15a70dc9c7a68ca667a8864661ea90418d0d';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    9
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-541';
SET @content_hash = '34c94adbbdf8821cf8260b0777e044ec8346a82408f37e0ee0cdc411c945595d';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    10
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-542';
SET @content_hash = 'd5af50bfafc6b4610e9277676cbbd0ae3f7f3e8a9280e7fd3b2aac88f702a1d2';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    11
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-543';
SET @content_hash = 'd3cfdbe5b51c87279220997c5fb52bb29b75fcc211bb4372ad4bc5847b69af59';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    12
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-544';
SET @content_hash = 'fec38c3e462ee3810b65154d192cfed5a82a64b41ff7eede0147932e315f1f8a';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    13
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-545';
SET @content_hash = '591479ead1417ce0a12ee6df56f6c865fe852de5fb84ff2614a99948ae5be98f';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    14
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-631';
SET @content_hash = '67a64a9c8562f9ee67cbbb9b7b1ca9183fb6691f5ba9691e8d723e641fe055a3';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    15
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-632';
SET @content_hash = 'ad1f7d3cd938234aaf4e1201556cada39821283403ec703bda2c23f79f4cdb58';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    16
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-633';
SET @content_hash = '269ab25919d01259e405814746847890e8d6ac17c842202f47e6db9a2dfbe0bc';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    17
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-634';
SET @content_hash = 'a534eccb430a938229245939367ad971cfa2ddfaeddd6b510c1f4c54d498cde8';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    18
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-635';
SET @content_hash = 'fa1001e6dd952e44a75b0e29ebfad0abfb59671c7f5a30e745b42bc460404f10';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    19
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-636';
SET @content_hash = '607a2c5e97e62c384c2b990a76491e40a3e81e3a9e261802ceafaebb96e0637a';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    20
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-637';
SET @content_hash = '1ddb728d89d85c1fc68f6aeec96d35b4e2ef395e327411c09ee9fdbd271f1f0c';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    21
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-638';
SET @content_hash = '6d6b3b90708261431072e5f36c081ae66e6e89e1caf42aeddcd6b2fdb713447a';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    22
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-639';
SET @content_hash = 'f0d4999586d1564f21ed3ff32967f4bd4c985d2b9d80f08b862b6bbc5d6741b4';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    23
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-640';
SET @content_hash = '1a9c9fa12b42d2391780e17d32e62979f5dad8cc73f4b755e8b697df62495f31';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    24
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-641';
SET @content_hash = '12949e1e023c7d2cc552c50238710fac59b3ee7811aedcdfdb67188ad29f1c31';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    25
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-642';
SET @content_hash = '318c038a71996a9b506a86aa10b63f492922406f83de0150dfca50cef25cc300';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    26
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-643';
SET @content_hash = '690c7fa5db1deeeba5ed44889187d356044f3f4e6b86295ec9acd7ba0df154c7';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    27
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-644';
SET @content_hash = 'a63852519d56c3e741035f2dc15642a024cf40175e0d4b605f1553284d0a3b5e';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
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
    28
WHERE @same_current_count = 0;

COMMIT;

