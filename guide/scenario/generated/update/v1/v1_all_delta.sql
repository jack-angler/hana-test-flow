-- ============================================================================
-- Source: PC_통합테스트시나리오_하나원큐오토_10_v0.61_렌터카(대리점,특판).delta.sql
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
SET @case_code = 'CASE-LR-525';
SET @content_hash = '14ef927b626362698e7546817a52716f760e2bfdd69bc8731f075d493f116eb9';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    1
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-547';
SET @content_hash = 'd5f2e3c2e25858251e5cf52f2aeda6ba81bf1a5f1da813e2c02f3d6c75c18a87';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    2
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-548';
SET @content_hash = 'b9701932554fc99b35c302ce6b268d36a64ba2cce97740249e5702de7464a15a';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    3
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-500';
SET @case_code = 'CASE-LR-549';
SET @content_hash = 'db9f71f69407a6ab709166ce792aaa6248f46262b5d054f059a7a3db4427899b';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    '필수파일 모두 첨부한 경우 → [고객서류등록] 팝업의 [저장] 버튼을 클릭한다.',
    '팝업창이 닫힌다.',
    @content_hash,
    1,
    0,
    4
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-638';
SET @content_hash = '8c1db8ecdf3d53913bd46d8ead29e2111f26cfba40f10325e6b5596700765f06';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    5
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-656';
SET @content_hash = '744a2d09c08d5ef2fa6e60977ef13e8c532db3e358fc80c5df42bf82ddb80b75';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    6
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-657';
SET @content_hash = 'c28ebf5a5b10f8401670ba243cc55152ff14ce1e5993373b3f72c90b5b1d669d';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    7
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-660';
SET @content_hash = '1e97a3d5f14d13145b0995469ac0408efb59559eb2d2f728e8ed5117e0c0cc40';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    8
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-661';
SET @content_hash = '3780496caf923642918f49360fc86f2ce500214f31ecb29b5bc4edf30c49e1f3';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    9
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-662';
SET @content_hash = '8694c154ea44144f4f465e11cb95789487dadfdee1b33d4a28901a569d60f323';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    '필수파일 모두 첨부한 경우 → [손님서류등록] 팝업의 [저장] 버튼을 클릭한다.',
    '팝업창이 닫힌다.',
    @content_hash,
    1,
    0,
    10
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-600';
SET @case_code = 'CASE-LR-663';
SET @content_hash = 'f8934f715ebcef7f2979b55d2fbb9aed838c3ff2fc20b38e40033a7a8c7d41e2';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    '필수파일 첨부 못한 경우 → [손님서류등록] 팝업의 [저장] 버튼을 클릭한다.',
    '필수파일 미등록 시 얼럿 메시지 호출된다.',
    @content_hash,
    1,
    0,
    11
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-726';
SET @content_hash = 'cec18d23cfd1cd7d79163409e1938d0d2a69be12f21018ac4d5b36145bd8d73c';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    12
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-744';
SET @content_hash = 'de2d78262a81bcc89ff5e01db4c2cfc981ae2f311d4ed7ec02ff874ab5ed6003';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    13
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-745';
SET @content_hash = 'e750c130efa291d7297e73613a6e255bf577b996432071ec338f3ab9c6ca8d2b';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    14
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-748';
SET @content_hash = '55dfc85a7e3f9c79a870307ccb73bcfef3ec26dba05db0f55a3aa1d4a153cff3';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    15
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-749';
SET @content_hash = '8c579a300e0477c0f44312ae4e3796cd3ccca10f9dab6c08b5a8ce303749d625';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    16
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-750';
SET @content_hash = 'fe0ee744aa14e78189661f96d1dc4816a8bd1a66648438228ba28d779da9a233';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    '필수파일 모두 첨부한 경우 → [손님서류등록] 팝업의 [저장] 버튼을 클릭한다.',
    '팝업창이 닫힌다.',
    @content_hash,
    1,
    0,
    17
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-700';
SET @case_code = 'CASE-LR-751';
SET @content_hash = '672034d3330f3390b4b2ad10658faf6e58e27415bff329fbf6ddb03e96eab815';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    '필수파일 첨부 못한 경우 → [손님서류등록] 팝업의 [저장] 버튼을 클릭한다.',
    '필수파일 미등록 시 얼럿 메시지 호출된다.',
    @content_hash,
    1,
    0,
    18
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-838';
SET @content_hash = '662ca8abe578764abcd624a65d0e9e4d929baf72c2a255246b5a9936932f10e2';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    19
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-843';
SET @content_hash = 'd07d98c28172893d1c0e8d397ea381c243f2ff3bd919e5ec49382ab8a655409c';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    20
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-856';
SET @content_hash = '001626ea53717931080464f56dff83b9b4b84fbba830210dabac4e635933ede1';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    21
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-857';
SET @content_hash = 'f97fcc73e497822a393207bd5f8e470ae1d7f190931a2fcc74707d3a60039e26';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    22
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-860';
SET @content_hash = '776eeaf29f3a39f14027df3c3a8467400cd4ce6ff490d932e4c5743c517bd57c';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    23
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-861';
SET @content_hash = '203dc45ff5f809e096336e42bd6820fbee53fa5c883458dd1b7b793c6d7d68d9';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    24
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-862';
SET @content_hash = '243a4ab79c0e0f71c77bb9ac4690f7ecbb44e5d1187d6a3cf72b73c4bfd9476b';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    '필수파일 모두 첨부한 경우 → [손님서류등록] 팝업의 [저장] 버튼을 클릭한다.',
    '팝업창이 닫힌다.',
    @content_hash,
    1,
    0,
    25
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-LR-800';
SET @case_code = 'CASE-LR-863';
SET @content_hash = '5a1c9efec007f079257fc65a7996d815e01b26875c2b5ad37471e9c6839f4e73';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    '필수파일 첨부 못한 경우 → [손님서류등록] 팝업의 [저장] 버튼을 클릭한다.',
    '필수파일 미등록 시 얼럿 메시지 호출된다.',
    @content_hash,
    1,
    0,
    26
WHERE @same_current_count = 0;

COMMIT;

-- ============================================================================
-- Source: PC_통합테스트시나리오_하나원큐오토_11_v0.63_리스(운용, 금융, 중고차, 시승차).delta.sql
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

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-618';
SET @content_hash = '73c36768b6914cd72fc8a9ea390b1cfc1ddf5dc19f3afa5d7f98a76f93e6f306';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    1
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-632';
SET @content_hash = '3d7fe169b70a4e3250f8b54581f45662da835d24e5366bd84d34bc2d9fbd6a85';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    2
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-633';
SET @content_hash = 'f5077e4e08f291bff8a2f67e78a3e8d719b5a67f26b215076ac51f5cd5251f17';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    3
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-600';
SET @case_code = 'CASE-NW-634';
SET @content_hash = 'f64a53da6ba7e00001324c0dbe61ef4224efd6bbe3f581ead93e1832f980b13d';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    '필수파일 모두 첨부한 경우 → [손님서류등록] 팝업의 [저장] 버튼을 클릭한다.',
    '팝업창이 닫힌다.',
    @content_hash,
    1,
    0,
    4
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-529';
SET @content_hash = 'a6fba17947ec78588a91368237992afcfa3894e9b3162fb2bc168929a2dac612';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    5
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-530';
SET @content_hash = 'ee6f2c2c750560cfd0b4a3f23819803b42c1c8757ea2a7eda73386aa2970cd26';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    6
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-NW-500';
SET @case_code = 'CASE-NW-531';
SET @content_hash = '31806ee6367995451f36f865f0367685f273b14ac8ee5520aa2e0c6c38977b29';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    '필수파일 모두 첨부한 경우 → [손님서류등록] 팝업의 [저장] 버튼을 클릭한다.',
    '팝업창이 닫힌다.',
    @content_hash,
    1,
    0,
    7
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-515';
SET @content_hash = '1059145096f0f3a31b6106909c64b67fcf570cdf7d25651c2263fc97550c9d94';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    8
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-529';
SET @content_hash = '3e22a6489f0bb34f4d3da6e7d04a9a349163af072cb1ddd3d6df713b9760f511';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    9
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-530';
SET @content_hash = '83d17ffee6acddb393aa0464c3266c1718942fd6ced07007fb7c0b5b351c635b';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    10
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-DM-500';
SET @case_code = 'CASE-DM-531';
SET @content_hash = '27b41f94bc9473dae42e9532a48f4c4fdc53e1608719be75d369bc3e03a90c82';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND @prev_version_no > 0;

INSERT INTO test_cases (
    test_scenario_id, scenario_menu, scenario_code, case_code, version_no,
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
    '필수파일 모두 첨부한 경우 → [손님서류등록] 팝업의 [저장] 버튼을 클릭한다.',
    '팝업창이 닫힌다.',
    @content_hash,
    1,
    0,
    11
WHERE @same_current_count = 0;

COMMIT;

-- ============================================================================
-- Source: PC_통합테스트시나리오_하나원큐오토_12_v0.61_선구매.delta.sql
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
SET @case_code = 'CASE-PO-529';
SET @content_hash = '0bbadf136c9940fa734c37744ec983ddb79a6da5e6655efdfe92684d46e29d50';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    1
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-543';
SET @content_hash = '08897597af58fa193060fe6716ef847997517c9801766c6bfcb2430555b0490c';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    2
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-544';
SET @content_hash = '8c825863e1fd21d7def86261ea0d42a694425806c0177ddb29092ef808afa035';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    3
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-547';
SET @content_hash = 'a6b82a25548f63b39b8c5416fc08c0952eb5d16893d25e7b767a1712b3b479cb';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    4
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-548';
SET @content_hash = '0626ac60fc03e9f266f07588fddc5aef63f0116c795291a406b5c886281bbfe0';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    5
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-549';
SET @content_hash = '1e31dcb11571b182299410fb0fa4eeacb5e9b1112d8009d8b3e71b5463169160';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    '필수파일 모두 첨부한 경우 → [손님서류등록] 팝업의 [저장] 버튼을 클릭한다.',
    '팝업창이 닫힌다.',
    @content_hash,
    1,
    0,
    6
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-PO-500';
SET @case_code = 'CASE-PO-550';
SET @content_hash = '660b88c1bfb782320ee70916a19e0557e35dc6dd7d866179fb7bf4180079e898';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    '필수파일 첨부 못한 경우 → [손님서류등록] 팝업의 [저장] 버튼을 클릭한다.',
    '필수파일 미등록 시 얼럿 메시지 호출된다.',
    @content_hash,
    1,
    0,
    7
WHERE @same_current_count = 0;

COMMIT;

-- ============================================================================
-- Source: PC_통합테스트시나리오_하나원큐오토_13_v0.62_할부.delta.sql
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
SET @case_code = 'CASE-IF-516';
SET @content_hash = '46ef30a3e274dfa6a14077c76294f609fc44fa51a41f6c0f3cccba5f67f8e782';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    1
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-530';
SET @content_hash = '815b36f18b78bed45c1ba061889be2255bc517a7a0759c54ffdb2bc9b3e66f95';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    2
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-531';
SET @content_hash = 'fd23785b2074c37e246d97140b2c26a39f25d7383cbe80698854577e9c217011';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    3
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-500';
SET @case_code = 'CASE-IF-532';
SET @content_hash = '3f8ed38645f9534c036bf5d907822f21292cffaca95890661e4bd2901be6d944';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    '필수파일 모두 첨부한 경우 → [손님서류등록] 팝업의 [저장] 버튼을 클릭한다.',
    '팝업창이 닫힌다.',
    @content_hash,
    1,
    0,
    4
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-629';
SET @content_hash = '5afe4c083756d3aecdc0f9bec4476e0f4192ab1151a7768ea8470828824eb400';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    5
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-630';
SET @content_hash = '213a4e752f7915ecfd9b8a2b18764581ed0190dc7e208d17a3497aee4061c411';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    6
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-IF-600';
SET @case_code = 'CASE-IF-631';
SET @content_hash = '881cf66f1b02cfdb0349b282ac7e4fb188a48543bb04b77397fdfc542882541f';

SELECT id INTO @test_scenario_id
FROM test_scenarios
WHERE test_run_id = @test_run_id AND scenario_code = @scenario_code;

SELECT COALESCE(MAX(version_no), 0) INTO @prev_version_no
FROM test_cases
WHERE test_scenario_id = @test_scenario_id AND case_code = @case_code;

SELECT COUNT(*) INTO @same_current_count
FROM test_cases
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
  AND is_current = 1
  AND is_deleted = 0
  AND content_hash = @content_hash;

UPDATE test_cases
SET is_current = IF(@same_current_count = 0, 0, is_current),
    updated_at = IF(@same_current_count = 0, CURRENT_TIMESTAMP, updated_at)
WHERE test_scenario_id = @test_scenario_id
  AND case_code = @case_code
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
    '필수파일 모두 첨부한 경우 → [손님서류등록] 팝업의 [저장] 버튼을 클릭한다.',
    '팝업창이 닫힌다.',
    @content_hash,
    1,
    0,
    7
WHERE @same_current_count = 0;

COMMIT;

