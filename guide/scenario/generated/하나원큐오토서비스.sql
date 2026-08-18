START TRANSACTION;

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @test_run_name = '하나원큐오토서비스';

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

SET @scenario_code = 'SN-SE-100';
SET @scenario_name = '하나원큐오토 서비스 진입';
INSERT INTO test_scenarios (test_run_id, scenario_code, name, sort_order)
VALUES (@test_run_id, @scenario_code, @scenario_name, 1)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    sort_order = VALUES(sort_order),
    updated_at = CURRENT_TIMESTAMP;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-001';
SET @content_hash = '771b043a9f317351dc0156ac3c6d32c794dd7cedbb1da1de2cce2d5bb9f9650d';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '내정보',
    'GNB> 하나원큐오토서비스> 내정보',
    '일반사용자, 권한 사용자 모두',
    'GNB메뉴> 하나원큐오토 서비스를 선택 > 내정보 메뉴 클릭',
    '내정보 이름 , 등록ID, 휴대폰 번호, 소속사 항목 출력',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-002';
SET @content_hash = 'e06e680fe6c91dc9d4137f5059efffddec1060fd11c2d5c2dd55bf0f049297c7';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '내정보',
    'GNB> 하나원큐오토서비스> 내정보',
    '일반사용자, 권한 사용자 모두',
    '로그아웃버튼 클릭',
    '로그아웃 하시겠습니까? 취소 / 확인 팝업 출력.
로그아웃 시 PC Web 메인화면으로 이동',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-003';
SET @content_hash = '7d27fb0dc6c4b671321435a551ceea9274e83ad486409c96b324540baa1e1d7f';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '차량/저당 미등록 채권',
    'GNB> 하나원큐오토서비스> 차량/저당 미등록 채권',
    '일반 사용자 로그인',
    'GNB메뉴> 하나원큐오토 서비스를 선택 >''차량/저당 미등록 채권'' 메뉴 클릭',
    '실행(송금) 후 5영업일 초과하여 미등록건 노출
AG가 진행한 채권에 대해서만 노출, 
등록기한이 초과된 건에 대해서는 미노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-004';
SET @content_hash = '9239e2e2bfde12357e0a6814bc2ff504ce5b28d95f276cec935cba0faa31c793';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '차량/저당 미등록 채권',
    'GNB> 하나원큐오토서비스> 차량/저당 미등록 채권',
    '일반 사용자 로그인',
    'GNB메뉴> 하나원큐오토 서비스를 선택 >''차량/저당 미등록 채권'' 메뉴 클릭,
조회 값이 없을 경우,',
    '''미등록 채권이 없습니다'' 문구 출력',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-005';
SET @content_hash = 'a9fd40eece5f53f8497b0782495c375d13d244b557793cdf228583f3aab58ddd';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '차량/저당 미등록 채권',
    'GNB> 하나원큐오토서비스> 차량/저당 미등록 채권',
    '일반 사용자 로그인',
    'GNB메뉴> 하나원큐오토 서비스를 선택 >''차량/저당 미등록 채권'' 메뉴 클릭,
조회 값이 있을 경우,',
    '손님명, 채권번호, 실행일자, 등록기한, 상품명 정보 출력',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-006';
SET @content_hash = '1ab43300294208b981e89bd61402b7ca193a7b3c0f5fd2fc2ce5c07ba40ab752';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 목록',
    'GNB> 하나원큐오토서비스> 공지사항',
    '일반 사용자 로그인',
    '공지사항 목록 화면 진입',
    '[글쓰기] 버튼이 노출되지 않음',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-007';
SET @content_hash = '1ef4ffbd87f821cd51e2a1731320ef92abba99e1072c9dbd83093b7cea20181a';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 목록',
    'GNB> 하나원큐오토서비스> 공지사항',
    '관리자 로그인',
    '공지사항 목록 화면 진입',
    '관리자 권한 보유 시, [글쓰기] 버튼이 우측 상단에 정상 노출됨',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-008';
SET @content_hash = '025799cb30cc9ec8451487818d9f2720cef94d39a1fd576fc924c270881226e6';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 목록',
    'GNB> 하나원큐오토서비스> 공지사항',
    '게시글 존재',
    '공지사항 목록 화면 진입',
    '게시글 번호, 중요 아이콘, 제목, 작성일자(YYYY.MM.DD), 조회수가 정상 노출됨',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-009';
SET @content_hash = 'b343b64dd2a299761de7549d1fe997487eb84a4a8a78c3967e7cd2f621e1b06d';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 목록',
    'GNB> 하나원큐오토서비스> 공지사항',
    '15개 이상 게시글 존재',
    '1. 목록 하단 페이징 영역 확인
2. 페이지 번호 및 이전/다음(<, >) 클릭',
    '1. 1페이지당 15개씩 정렬 노출
2. 선택한 페이지로 정상 이동하며 이전/다음 버튼 동작',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-010';
SET @content_hash = '14220be3d70aa13d00b6db5cbe2820a4bad1375183a86af109d0cad02fc03ad5';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 목록',
    'GNB> 하나원큐오토서비스> 공지사항',
    '중요/일반 게시글 혼재',
    '게시글 목록 확인',
    '1. 중요 설정 게시글(북마크 아이콘 표시, 최신순)
2. 일반 게시글(최신순) 순으로 상단 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-011';
SET @content_hash = 'ba48560eb6b20d7bda02659f0a820a12dbe23ae85b8b7115644c11e72d2af321';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 목록',
    'GNB> 하나원큐오토서비스> 공지사항',
    '일반사용자, 권한 사용자 모두',
    '목록 확인',
    '관리자가 [노출중지] 처리한 게시글은 목록에 노출되지 않음',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-012';
SET @content_hash = 'be2ec6640a9341f4663259cdccafa63f1d236d6cfef107e01b0a7a8deb20ca01';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 목록',
    'GNB> 하나원큐오토서비스> 공지사항',
    '목록 화면',
    '검색 드롭다운 클릭',
    '''전체'', ''제목'', ''내용'' 선택 옵션이 정상 노출됨',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-013';
SET @content_hash = '0123614387947d3c9bdf8b3c406cb93cba735a0d0e090cdc9f87d22d56a4ab52';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 목록',
    'GNB> 하나원큐오토서비스> 공지사항',
    '목록 화면',
    '검색 구분을 ''제목 또는 내용'' 선택 후 검색어 입력 및 돋보기 아이콘/Enter키 입력',
    '제목 또는 내용에 검색어가 포함된 게시글이 모두 결과로 노출됨',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-014';
SET @content_hash = '277c91d76c8ea0eafd87bc559371477a52f2a35c5dec17dce7a270d3d0cf3039';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 목록',
    'GNB> 하나원큐오토서비스> 공지사항',
    '목록 화면',
    '검색어 1글자 입력 후 [검색] 클릭',
    '"검색어는 두 글자 이상 입력해주세요." 팝업 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-015';
SET @content_hash = '2e1efdb1c5a6b11a0505ae422ec0c1b603300fb591f97df6f5aaba4488b1dc2c';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 목록',
    'GNB> 하나원큐오토서비스> 공지사항',
    '목록 화면',
    '존재하지 않는 검색어로 검색',
    '"검색된 결과가 없습니다." 안내 문구 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-016';
SET @content_hash = '72db4f39b18c1ecaedee2e36c28661174609ad17567e4ff64af21895aadabdc4';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 상세',
    'GNB> 하나원큐오토서비스> 공지사항',
    '일반 사용자 로그인',
    '게시글 상세 진입',
    '하단에 [목록] 버튼만 노출되고 [수정하기] 버튼은 노출되지 않음',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-017';
SET @content_hash = 'cf621f46b649323beb8b75354e497ea7575308f001dd31440cdcec2af81103fd';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 상세',
    'GNB> 하나원큐오토서비스> 공지사항',
    '관리자 로그인',
    '게시글 상세 진입',
    '하단 우측에 [수정하기] 버튼이 정상 노출됨',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-018';
SET @content_hash = '9b18ecedc3c68620bc9f912fe138967375cb89206cf689cd651ca0c080bc3413';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 상세',
    'GNB> 하나원큐오토서비스> 공지사항',
    '관리자 로그인',
    '상단 중요 아이콘(북마크) 클릭',
    '"정말로 중요로 지정하시겠습니까?" 팝업 노출 후 [예] 클릭 시 중요 게시글로 지정',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-019';
SET @content_hash = '5ff16181af55c36c8452dbd391cb8cea3c23961256788b42e85c534c5d8731ac';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 상세',
    'GNB> 하나원큐오토서비스> 공지사항',
    '관리자 로그인',
    '지정되어 있는 중요 아이콘 클릭',
    '"정말로 중요를 해제하시겠습니까?" 팝업 노출 후 [예] 클릭 시 중요 지정 해제',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-020';
SET @content_hash = '6ab42b53362669e1e274a2af1a675c33dcdf0f509aea68ae7de7d094661b027d';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 상세',
    'GNB> 하나원큐오토서비스> 공지사항',
    '이미지 첨부글 상세 진입',
    '본문 하단 첨부파일 영역 확인',
    '파일명, 이미지 설명 문구, 하단 이미지 미리보기 영역(Img 영역)이 정상 표시됨',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-021';
SET @content_hash = 'e11f4562cdd67bbe5cf9d3111f23014753b5ef93f92d8a847dd4c113749cb264';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 상세',
    'GNB> 하나원큐오토서비스> 공지사항',
    '문서 첨부글 상세 진입',
    '1. 첨부파일 목록 확인
2. 파일명 클릭 (.docx, .pdf 등)',
    '1. 문서는 미리보기 영역 없이 파일명만 표시됨
2. 파일 클릭 시 다운로드가 정상 수행됨',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-022';
SET @content_hash = '01f13626b79f5295ed79565fc7498f0845f945c40ee0cc9da015dd379f16ab09';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 상세',
    'GNB> 하나원큐오토서비스> 공지사항',
    '상세 화면',
    '[목록] 버튼 클릭',
    '공지사항 목록 화면으로 정상 이동',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-023';
SET @content_hash = '5199b5207e29ab4db540ec0f0c094c24919e52d585e286ca50d244731cd044df';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 상세',
    'GNB> 하나원큐오토서비스> 공지사항',
    '관리자 로그인',
    '[수정하기] 버튼 클릭',
    '수정권한(관리자)이 없을 경우 미노출 
글쓰기 화면으로 이동',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-024';
SET @content_hash = 'e687649e6c98a4dee5faf6b687da86149501172f3fcfc1fb7991edc2bda4f0e4';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 상세',
    'GNB> 하나원큐오토서비스> 공지사항',
    '관리자 로그인',
    '[삭제하기] 버튼 클릭',
    '삭제권한(관리자)이 없을 경우 미노출 
삭제 확인 얼럿 출력
[삭제] 버튼 클릭시 해당 글 히든 처리',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-025';
SET @content_hash = '87b002206c8d48049dd6d3928112cdccaa0bd46d9cd12c28d78cf5c231a31be0';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 글쓰기/수정',
    'GNB> 하나원큐오토서비스> 공지사항',
    '글쓰기 화면 진입',
    '노출 여부 라디오 버튼 확인',
    '표시'' 라디오 버튼이 기본 선택(디폴트)되어 있음',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-026';
SET @content_hash = 'e39d94da8d65ffde162d12d3c50b13a63277b989400c075fd26b3dff0fd19c4f';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 글쓰기/수정',
    'GNB> 하나원큐오토서비스> 공지사항',
    '글쓰기 화면',
    '제목 미입력 상태로 [등록하기] 클릭',
    '"제목을 입력해주세요" 경고 얼럿 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-027';
SET @content_hash = '12bdc6d4f26a5149d7ce1809b02678ed685db852f92a03cc45760b6a47c8d5c8';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 글쓰기/수정',
    'GNB> 하나원큐오토서비스> 공지사항',
    '글쓰기 화면',
    '제목 입력, 내용 미입력 상태로 [등록하기] 클릭',
    '"내용을 입력해주세요" 경고 얼럿 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-028';
SET @content_hash = 'a2c26c80ffb97e0f1299126454188f17044a352b1434144d435aae3d71f4cb7c';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 글쓰기/수정',
    'GNB> 하나원큐오토서비스> 공지사항',
    '글쓰기 화면',
    '1. 하단 안내 문구 확인
2. JPG, JPEG, PNG, GIF 외 파일 첨부 시도',
    '1. 버튼 아래 '' 이미지파일은 JPG, JPEG, PNG, GIF 형식만 가능합니다.'' 문구 항상 노출
2. 불가능한 확장자 시 ''파일형식에 맞지 않습니다.'' 팝업 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-029';
SET @content_hash = 'bdc5e93d3d7a29acb81d2de52eb25007fb7e452b3ce3ba8c15a4b3ca6248931c';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 글쓰기/수정',
    'GNB> 하나원큐오토서비스> 공지사항',
    '글쓰기 화면',
    '이미지 또는 일반 파일 각각 3개 이상 첨부 시도',
    '이미지/파일 각각 최대 2개까지만 등록 가능하며 한도 초과 시 버튼 비활성화',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-030';
SET @content_hash = 'c9a94386b881848d968180f277da6fc7252d3ac42fcb07d78f7042f72e8b92c8';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 글쓰기/수정',
    'GNB> 하나원큐오토서비스> 공지사항',
    '파일 첨부 완료 상태',
    '첨부 파일 오른쪽 [x] 버튼 클릭',
    '선택한 첨부 파일이 목록에서 개별 삭제됨',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-031';
SET @content_hash = 'dc8949547f985012cb9a1749959a861250e88a548cb9ad6795cecbf2a22b3df2';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 글쓰기/수정',
    'GNB> 하나원큐오토서비스> 공지사항',
    '이미지 파일 첨부 상태',
    '이미지 설명 입력란에 텍스트 입력 및 100자 초과 시도',
    '최대 100자까지만 입력 가능하며 아래 글자 수 카운터(0/100)가 실시간 업데이트됨',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-032';
SET @content_hash = '2d6a4030b82efab9033b3510462bf9327fa030d019876018508c517fcf7ef7c4';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 글쓰기/수정',
    'GNB> 하나원큐오토서비스> 공지사항',
    '관리자 로그인',
    '모든 항목 정상 입력 후 [등록하기] 클릭',
    '"글 등록이 완료되었습니다." 팝업 노출 후 확인 클릭 시 목록 화면으로 이동',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-033';
SET @content_hash = 'b0f7d444c93196caa29c2b35c5263dad1ed67b7f964f2520eab4876c42444ef2';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '공지사항 글쓰기/수정',
    'GNB> 하나원큐오토서비스> 공지사항',
    '기존 게시글 수정 진입',
    '항목 수정 후 [수정완료] 클릭',
    '"글 수정이 완료되었습니다." 팝업 노출 후 확인 클릭 시 목록 화면으로 이동',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-034';
SET @content_hash = '790857ef473f391792bf3dc3a5fa6687158bc0414eb30c1d3946f3df7d6f60e1';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '이용약관',
    'GNB> 하나원큐오토서비스> 이용약관',
    '일반사용자, 권한 사용자 모두',
    'GNB메뉴> 하나원큐오토 서비스를 선택 > 이용약관 메뉴 클릭',
    '이용약관 내용을 확인할 수 있다',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-035';
SET @content_hash = '8c37a527d9c915738613adb37561ffcec6cca533da06af7d3be4173f36779b26';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _이용현황',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    'GNB메뉴> 하나원큐오토 서비스를 선택 > 관리자 메뉴 클릭',
    '관리자 메뉴의 ''이용현황'' 탭이 디폴트로 선택되어 확인할 수 있다',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-036';
SET @content_hash = 'a5151b1828e185d6e6dc92ec4a86438617bf841f27948b6affaa1e6013c05ec9';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _이용현황',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '내 권한이 ''관리자''인 경우',
    '관리자의 경우 권한 : 관리자 4개 메뉴 모두 노출
이용현황 ｜ 관리지정 ｜ 기본설정 ｜ 팝업/보조금',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-037';
SET @content_hash = '284cc00a0098eb92f9aaa8e70d0d28ba10ffbe706cc0e040d01ae66caec7f0ca';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _이용현황',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '이용현황 조회',
    '현황조회  
상품구분 디폴트 : 하나원큐오토 
조회조건 디폴트 : 전체',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-038';
SET @content_hash = '6a4f7910f743273723039ec1035028015cb76e2b2ff0df2d55bad9b3402aada5';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _관리지정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    'GNB메뉴> 하나원큐오토 서비스를 선택 > 관리자_ 관리지정 탭 클릭',
    '관리 지정 화면 출력',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-039';
SET @content_hash = '6b5f7daf495eb8842a42c65aa09b29e895f1643166d35780fc3d040242e1defa';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _관리지정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '아이디/이름 검색',
    '아이디, 이름 둘중 하나만 입력해도 검색 가능',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-040';
SET @content_hash = '3b72f946baad0a60146f5712224e05932392dae237a35d27b93db60bbba3fdc9';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _관리지정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '검색한 후 계정 값 노출',
    '검색 이후 계정 아이디 값 표시',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-041';
SET @content_hash = 'eab96ea9cca1ecdfa2282a8485794f147feb779a415406d57884643866bdd445';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _관리지정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '검색한 계정 아이디에 원하는 권한을 선택한다.',
    '선택한 권한을 저장하려면 권한 지정 버튼을 클릭한다.
권한 지정 클릭시 얼럿 출력 -> 예 누르면 권한 지정 완료',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-042';
SET @content_hash = 'd6ed1e2139a85e385461287344ee499ea94adc49f38891684b9e7ebd6ca601cb';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _관리지정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '권한 중 ''관리자 권한'' 항목은 관리자에 따라 노출된다.',
    '관리자 권한을 선택 할 수 없는 일반 관리자일 경우 해당 항목 숨김처리되어 보이지 않는다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-043';
SET @content_hash = '8d3954b9619139637239dab7f5610c3e36c9f66505723020719aa72228625fe0';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _관리지정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '초기화 버튼 클릭시',
    '설정된 체크값이 모두 해제 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-044';
SET @content_hash = '74580a3c41c9e43c545f570980ce8b31f4f14f5a64b0cf7362543070832c8304';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _관리지정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '권한 유저 선택시, 관리자 권한의 ID 리스트 목록이 출력된다.',
    '관리자 권한의 아이디/성명/권한명 출력된다',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-045';
SET @content_hash = 'a21f568f90b6227c3befdd88f1fa72a7ccea23c0513c4a7d802239aa3c0925a6';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _관리지정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '[X]를 누를 경우, 권한 회수 얼럿 출력',
    '예 클릭시 권한 이 회수 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-046';
SET @content_hash = '711f7f643da405f48bb1c4684507bf08c3a809f910da1284cfb105395cbb3060';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    'GNB메뉴> 하나원큐오토 서비스를 선택 > 관리자_ 기본설정 탭 클릭',
    '기본설정 화면 출력',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-047';
SET @content_hash = '5846ea2b830d8d8e4c90d35fedd773537b7d83b2ad0cc210f6931bcb44c3b61d';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '브랜드 셀렉트 박스 선택시',
    '고유번호 + 브랜드명 선택 후, 셀렉트 박스 하단에 고유번호 자동 출력',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-048';
SET @content_hash = '4edac5eb579e077cb49ed63cdbc96b9387e51d7bca4d857c0c1db099c64483eb';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '브랜드 선택 항목의 하단 
[렌터카숨김] 버튼  클릭시, 해당 항목의 렌터카숨김 설정 탭에   바로 추가',
    '렌트 숨김 설정 탭에 브랜드 숨김에 항목 추가',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-049';
SET @content_hash = 'f1cf81047b32b40ce40e880dc672abe63d2e5f6a80ea9c0351694cc5186e9904';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '모델 셀렉트 박스 선택시',
    '고유번호 +모델명선택 후, 셀렉트 박스 하단에 고유번호 자동 출력',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-050';
SET @content_hash = '36573179bad2b30244648c0103bfe3105023d290a210c84f97ed4191db852972';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '모델 선택 항목의 하단 
[렌터카숨김] 버튼  클릭시, 해당 항목의 렌터카숨김 설정 탭에   바로 추가',
    '렌트 숨김 설정 탭에 모델 숨김에 항목 추가',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-051';
SET @content_hash = '794c35be492bd4eff135b37a83260ad770994bd97fd62c0e45decc3e5bb0b6c7';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '모델 선택 항목의 하단 
[렌터카프로모션] 버튼  클릭시, 해당 항목의 렌터카숨김 설정 탭에   바로 추가',
    '렌터카 이벤트 설정에 프로모션 대상 항목으로 추가된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-052';
SET @content_hash = '501bb914b150745c8ca903268c0d978cb1405a0662467eb3cdb38cc56fc08adf';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '라인업 셀렉트 박스 선택시',
    '고유번호 + 라인업 선택 후, 셀렉트 박스 하단에 고유번호 자동 출력',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-053';
SET @content_hash = '1251b1325e7f0ec650646736d14054a405b1e931343581a4c37b83b929685333';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '라인업 선택 항목의 하단 
[렌터카숨김] 버튼  클릭시, 해당 항목의 렌터카 숨김 설정 탭에   바로 추가',
    '렌트 숨김 설정 탭에 라인업 숨김에 항목 추가',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-054';
SET @content_hash = '8061f30267cb7e2c4a595956b0daacf3a0c4173829716df0452d1eb336e53413';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '트림 셀렉트 박스 선택시',
    '고유번호 + 트림선택 후, 셀렉트 박스 하단에 고유번호 자동 출력',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-055';
SET @content_hash = '1111cc8bda88a233a5b052ee84a6059e71caec9e28955cf3cd380a6c7444f669';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '트림 선택 항목의 하단 
[렌터카숨김] 버튼  클릭시, 해당 항목의 렌터카 숨김 설정 탭에   바로 추가',
    '렌트 숨김 설정 탭에 트림 숨김에 항목 추가',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-056';
SET @content_hash = '5381fe0489433d792d3bd8b2405ba1d839ba5b5188f242133db8f68040f50d19';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '브랜드 셀렉트 박스 선택시',
    '고유번호 + 브랜드명 선택 후, 셀렉트 박스 하단에 고유번호 자동 출력',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-057';
SET @content_hash = '0b8c25614134792344363f581f0603f80a1e794171d6245656915786dd69481f';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '브랜드 선택 항목의 하단 
[리스숨김] 버튼  클릭시, 해당 항목의 리스숨김 설정 탭에   바로 추가',
    '리스 숨김 설정 탭에 브랜드 숨김에 항목 추가',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-058';
SET @content_hash = '828a052da8f80167c3109d996a09de54d23330a4895a584f050fae871582d112';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '모델 셀렉트 박스 선택시',
    '고유번호 +모델명선택 후, 셀렉트 박스 하단에 고유번호 자동 출력',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-059';
SET @content_hash = '3db36a939e4001631518dbe0de42f08b508400d71e8b7150179847992ac7efa7';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '모델 선택 항목의 하단 
[리스숨김] 버튼  클릭시, 해당 항목의 리스숨김 설정 탭에   바로 추가',
    '리스 숨김 설정 탭에 모델 숨김에 항목 추가',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-060';
SET @content_hash = '597bf3e4d4acb06706c528749ffed7d64e8ec520aa71a8ba751e9adea9fa7596';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '라인업 셀렉트 박스 선택시',
    '고유번호 + 라인업 선택 후, 셀렉트 박스 하단에 고유번호 자동 출력',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-061';
SET @content_hash = '4b8051842dc52a4c39cf19e945929f61db7030e9bf012e91c878a1c1ddb06f2a';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '라인업 선택 항목의 하단 
[리스숨김] 버튼  클릭시, 해당 항목의 리스 숨김 설정 탭에   바로 추가',
    '리스 숨김 설정 탭에 라인업 숨김에 항목 추가',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-062';
SET @content_hash = '8d835c8e15098ecd0d783a5d5103b887a02551e3fbbb3f7bcdc2aace9093224f';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '트림 셀렉트 박스 선택시',
    '고유번호 + 트림선택 후, 셀렉트 박스 하단에 고유번호 자동 출력',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-063';
SET @content_hash = 'c27ed45361728767ca61c8f95dd305d8b1eecb865558f36d43549193fbbea8dc';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '트림 선택 항목의 하단 
[리스숨김] 버튼  클릭시, 해당 항목의 리스 숨김 설정 탭에   바로 추가',
    '리스 숨김 설정 탭에 트림 숨김에 항목 추가',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-064';
SET @content_hash = '5092dfbab57a74005da04c1d619dac6c8cc1b07732b5503f6661171dd59c740a';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '브랜드 셀렉트 박스 선택시',
    '고유번호 + 브랜드명 선택 후, 셀렉트 박스 하단에 고유번호 자동 출력',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-065';
SET @content_hash = '02c6616968bd07ce7143bede1dd5b36c388c45b83eb727153928077ccb29cf8b';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '브랜드 선택 항목의 하단 
[할부숨김] 버튼  클릭시, 해당 항목의 리스숨김 설정 탭에   바로 추가',
    '할부 숨김 설정 탭에 브랜드 숨김에 항목 추가',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-066';
SET @content_hash = 'c083950bde8f239c51f5ab89b8c7d356a3c3f56bc0c53a5adffc08b124e081cd';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '모델 셀렉트 박스 선택시',
    '고유번호 +모델명선택 후, 셀렉트 박스 하단에 고유번호 자동 출력',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-067';
SET @content_hash = '930e519bbbda0bb521a64f208d05840ae074f4d40fba5ac490a97e0dab3b6f7d';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '모델 선택 항목의 하단 
[할부숨김] 버튼  클릭시, 해당 항목의 리스숨김 설정 탭에   바로 추가',
    '할부 숨김 설정 탭에 모델 숨김에 항목 추가',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-068';
SET @content_hash = 'd40425cc5544c6a1e64b5c0458c4fc35203091572f09ad89834ba6c86f6097bf';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '라인업 셀렉트 박스 선택시',
    '고유번호 + 라인업 선택 후, 셀렉트 박스 하단에 고유번호 자동 출력',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-069';
SET @content_hash = '8630fd55147da24170fee6731acb4376c6661657a27671aa07f1d36daa982dba';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '라인업 선택 항목의 하단 
[할부숨김] 버튼  클릭시, 해당 항목의 리스 숨김 설정 탭에   바로 추가',
    '할부 숨김 설정 탭에 라인업 숨김에 항목 추가',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-070';
SET @content_hash = '69f28a6b3cd5b3717843cc130902c9cf3ec3c7782830ccbd1bc69dd6968f660b';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '트림 셀렉트 박스 선택시',
    '고유번호 + 트림선택 후, 셀렉트 박스 하단에 고유번호 자동 출력',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-071';
SET @content_hash = '94f0504b26a3bc56e597463d793350cf6d102a496b8fab6d23f61bf1014f98ce';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '트림 선택 항목의 하단 
[할부숨김] 버튼  클릭시, 해당 항목의 리스 숨김 설정 탭에   바로 추가',
    '할부 숨김 설정 탭에 트림 숨김에 항목 추가',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-072';
SET @content_hash = 'a65897ac339cb347b4aea0292f58ea10775833c093f564bcadbba340f74a7357';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '설정 저장 버튼 클릭',
    '변경된 사항이 있는 경우 얼럿출력 - 저장 
해당 저장 된 사항이 반영되었는지 견적화면에서 확인한다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-073';
SET @content_hash = '7b44d66a49eb130b93494b0b2f12cdaf88ba10694ab021bd3549cfd54eded44c';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자 _기본 설정',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '렌터카 숨김 설정/리스숨김설정/할부숨김설정 에서 추가된 항목을 삭제하고 싶은 경우',
    '활성화된 항목을 클릭-> 비활성화 처리후 얼럿 출력, 
설정 저장 시 비활성화된 항목은 숨김설정 항목에서 삭제됨.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-074';
SET @content_hash = '8fd74aa5562b4b4cb56b8bd902d8a1b393f8d0fdf32fbc2e9059bd92895c026f';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자_팝업/보조금',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    'GNB메뉴> 하나원큐오토 서비스를 선택 > 관리자 메뉴 -  팝업/보조금 클릭',
    '관리자 메뉴의 ''팝업/보조금'' 탭을 선택하여 화면을 확인할 수 있다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-075';
SET @content_hash = '8d10bb8bef1abe03cfddcdb09a01632add34a42f02f51a032ded4715df6a2d38';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자_팝업/보조금',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '전기차 보조금 지원지역 설정을 할 경우,',
    '견적산출화면에서 ‘보조금지원지역’ 노출 여부를 지정할 수 있다.
[설정 저장] 버튼 클릭시 변경값 유무 체크하여 얼럿이 출력된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-076';
SET @content_hash = '1c6df77dad9bf4203b30c197ca46eb247526258fb6253d12eeef6662d68ab500';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자_팝업/보조금',
    'GNB> 하나원큐오토서비스> 관리자',
    '기존 저장된 상태 유지 (변경값 없음)',
    '[설정 저장] 버튼 클릭, 변경사항이 없을경우',
    '''변경된 내용이 없습니다. 설정 값을 확인해주세요.'' 알림 팝업 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-077';
SET @content_hash = 'fc283ce2003bfb4d5479afb5d7e662045f49d5cbce8ea3bde41a5211e2e7f85d';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자_팝업/보조금',
    'GNB> 하나원큐오토서비스> 관리자',
    '체크박스 1개 이상 변경 (변경값 발생)',
    '[설정 저장] 버튼 클릭, 변경사항이 있을경우',
    '1. ''설정 값을 저장하시겠습니까?'' 컨펌창 노출
2. [예] 클릭 시 ''설정 값을 저장하였습니다.'' 알림 노출 후 저장됨',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-078';
SET @content_hash = 'bc8ce326db11101e4322f8d0a20f712e8cc1350105fba24913ec0b43222bc86f';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자_팝업/보조금',
    'GNB> 하나원큐오토서비스> 관리자',
    '관리자 로그인',
    '팝업 목록 출력 상태 확인',
    '화면명, 팝업 제목, 노출여부, 노출 기기나, 페이지, 최종 수정일, 최종수정자, 팝업 , 수정 항목으로 목록이 출력된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-079';
SET @content_hash = 'eb60598a7d45bbcb72002f8c6d85580cc7a13de713d7c6bef14a8b54622208cf';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자_팝업/보조금',
    'GNB> 하나원큐오토서비스> 관리자',
    '목록 화면',
    '[팝업 보기] 버튼 클릭시',
    '팝업 미리볼 수 있도록 노출 된다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-080';
SET @content_hash = '3df334995196e1dd8a98b8ca0331bbe2fa57194067a7ba4f72c353c3afaafb94';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자_팝업/보조금',
    'GNB> 하나원큐오토서비스> 관리자',
    '목록 화면',
    '[수정] 클릭시',
    '팝업/보조금 관리(수정)팝업이 출력되고 수정이 가능하다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-081';
SET @content_hash = '3d0d564aad694a6cfd0e53a9cbb87bd5820d20f69f3465d781ba7032c293f884';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자_팝업 수정',
    'GNB> 하나원큐오토서비스> 관리자',
    '팝업 수정 진입',
    '1. 제목에 60자 이상 입력 시도',
    '한글 기준 제목 최대 60자, 까지만 입력 가능함
목록화면에서 제목 2줄까지 노출 가능.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-082';
SET @content_hash = '0c4dd26317cb0ca8e40e3c92c7c329f0f0031209046198fcd8be86854c4c26ca';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자_팝업 수정',
    'GNB> 하나원큐오토서비스> 관리자',
    '팝업 수정 진입',
    '내용 입력란에 엔터키를 활용하여 15줄 이상 텍스트 입력',
    '내용이 길어질 경우 내부 스크롤바가 생성됨',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-083';
SET @content_hash = '8eb5feb40d2f7396af1591aaa18fe21d90aae8cc55eddd488d279e82f354323b';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자_팝업 수정',
    'GNB> 하나원큐오토서비스> 관리자',
    '팝업 수정 진입',
    '팝업 노출 기간 : 달력 아이콘 클릭하여 시작일/종료일 지정',
    'AS-IS 캘린더 컴포넌트가 정상 호출되며 기간 설정이 가능함',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-084';
SET @content_hash = '9479074a9a1a6d2c1cc3b57b1c1f0b9ee650b517f03510e587cca49c4b685b9c';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자_팝업 수정',
    'GNB> 하나원큐오토서비스> 관리자',
    '팝업 수정 진입',
    '견적 설정 ''이용가능'' 선택시,',
    '1. 팝업에 [계속하기]버튼이 노출
2. 견적 화면 진입 가능',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-085';
SET @content_hash = 'd20c5db3caca0e95b6ff28adda3db88d97a7a9b6b398e4701090c7e42eec69c9';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자_팝업 수정',
    'GNB> 하나원큐오토서비스> 관리자',
    '팝업 수정 진입',
    '견적 설정 ''차단'' 선택시,',
    '1.팝업에 [확인]버튼이 노출
2, 팝업을 닫으면 홈(현황 조회) 페이지로 이동합니다.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-086';
SET @content_hash = '4aea16b232add536a01f010a367bff28e29afa477fa88dbf1978fcf58313af06';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자_팝업 수정',
    'GNB> 하나원큐오토서비스> 관리자',
    '팝업 수정 진입',
    '오늘 하루 보지 않기 버튼 사용 선택시',
    '1.팝업 내에 [√]오늘하루보지 않기 선택 버튼 노출됨.
2. 해당 항목 저장 이후, 팝업이 출력되는 페이지 진입시, 
팝업 내 오늘 하루보지 않기 버튼 클릭시, 하루동안 팝업 뜨지 않음.',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-087';
SET @content_hash = '90c276d635d47bbc62cc3e1bb4b0c94b8143c087c1427693496712ff4a04527e';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자_팝업 수정',
    'GNB> 하나원큐오토서비스> 관리자',
    '팝업 수정 진입',
    '서브팝업 내용 영역에 텍스트 입력 후 굵게(B), 기울임(I), 밑줄(U), 정렬(Align) 툴바 클릭',
    '웹 에디터 기능이 정상 작동하며, PC에서도 동일하게 스타일이 적용되는지 확인',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-088';
SET @content_hash = 'cc1c866b440920b0ff7538545372187956411f1f6cb295616e23581b362ec86c';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자_팝업 수정',
    'GNB> 하나원큐오토서비스> 관리자',
    '팝업 수정 진입',
    '하단 [미리보기] 버튼 클릭',
    '현재 작성/수정한 내용이 실제 팝업으로 표시됨
팝업 내 하단에 회사 CI 이미지가 항상 정상적으로 출력됨',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-089';
SET @content_hash = '42f3797760315eb75fee907e127c4df734a1d4353e55f79b32c04b19b7f4a0ee';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자_팝업 수정',
    'GNB> 하나원큐오토서비스> 관리자',
    '팝업 수정 진입',
    '하단 [수정취소] 버튼 클릭',
    '수정 내용을 저장하지 않고 팝업 모달이 즉시 종료됨',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-090';
SET @content_hash = '614af9831881be4b3dbb3c136ecaf862038995687ef0396cc9ebf7fad0614210';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자_팝업 수정',
    'GNB> 하나원큐오토서비스> 관리자',
    '기존 내용 유지 (변경값 없음)',
    '[저장하기] 버튼 클릭, 변경사항이 없을경우',
    '변경된 내용이 없습니다. 다시 한번 확인해주세요.'' 알림 팝업 노출',
    @content_hash,
    1,
    0,
    @sort_order
FROM DUAL
WHERE @same_current_count = 0;

SET @scenario_code = 'SN-SE-100';
SET @case_code = 'CASE-SE-091';
SET @content_hash = '4cb435f64f67ab11edb0b019af4993e148cc6bf397035e2254622a4563fcd402';
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
    '하나원큐오토 서비스',
    @scenario_code,
    @case_code,
    @prev_version_no + 1,
    '관리자_팝업 수정',
    'GNB> 하나원큐오토서비스> 관리자',
    '제목, 내용, 설정 중 1개 이상 수정',
    '[저장하기] 버튼 클릭, 변경사항이 있을경우',
    '1. ''내용을 저장하시겠습니까?''  팝업 노출
2. [예] 클릭 시 ''내용을 저장하였습니다.'' 노출
3. 팝업 모달 종료 및 리스트 갱신',
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

