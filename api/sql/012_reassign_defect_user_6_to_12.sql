-- Move defect registration/processing ownership from users.id = 6 to users.id = 12.
-- Scope:
--   1) defects where user 6 is reporter/assignee/actor
--   2) defect action histories/images where user 6 is actor
--   3) evidences attached to defects reported by user 6
--
-- Note:
--   test_case_results.user_id has UNIQUE(test_case_id, user_id), so it is not
--   changed by default. See the optional guarded section at the bottom.

START TRANSACTION;

SET @from_user_id := 6;
SET @to_user_id := 12;

-- Safety check: target user must exist.
SELECT
    CASE
        WHEN EXISTS (SELECT 1 FROM users WHERE id = @to_user_id)
            THEN 'OK: target user exists'
        ELSE 'ERROR: target user does not exist'
    END AS target_user_check;

-- Keep the original defect set before reporter_user_id changes.
CREATE TEMPORARY TABLE tmp_reassign_defect_ids (
    id BIGINT UNSIGNED NOT NULL PRIMARY KEY
) ENGINE=Memory;

INSERT IGNORE INTO tmp_reassign_defect_ids (id)
SELECT id
FROM defects
WHERE reporter_user_id = @from_user_id
   OR assignee_user_id = @from_user_id
   OR assigned_by_user_id = @from_user_id
   OR action_completed_by_user_id = @from_user_id
   OR verified_by_user_id = @from_user_id;

-- Defect master.
UPDATE defects
SET
    reporter_user_id = CASE WHEN reporter_user_id = @from_user_id THEN @to_user_id ELSE reporter_user_id END,
    assignee_user_id = CASE WHEN assignee_user_id = @from_user_id THEN @to_user_id ELSE assignee_user_id END,
    assigned_by_user_id = CASE WHEN assigned_by_user_id = @from_user_id THEN @to_user_id ELSE assigned_by_user_id END,
    action_completed_by_user_id = CASE WHEN action_completed_by_user_id = @from_user_id THEN @to_user_id ELSE action_completed_by_user_id END,
    verified_by_user_id = CASE WHEN verified_by_user_id = @from_user_id THEN @to_user_id ELSE verified_by_user_id END
WHERE id IN (SELECT id FROM tmp_reassign_defect_ids);

-- Defect processing history.
UPDATE defect_actions
SET user_id = @to_user_id
WHERE user_id = @from_user_id
  AND defect_id IN (SELECT id FROM tmp_reassign_defect_ids);

UPDATE defect_status_histories
SET changed_by_user_id = @to_user_id
WHERE changed_by_user_id = @from_user_id
  AND defect_id IN (SELECT id FROM tmp_reassign_defect_ids);

UPDATE defect_action_images
SET user_id = @to_user_id
WHERE user_id = @from_user_id
  AND defect_id IN (SELECT id FROM tmp_reassign_defect_ids);

-- Test-result evidences attached to those defects.
UPDATE test_case_result_evidences e
INNER JOIN defects d
    ON d.test_case_result_id = e.test_case_result_id
SET e.user_id = @to_user_id
WHERE e.user_id = @from_user_id
  AND d.id IN (SELECT id FROM tmp_reassign_defect_ids);

-- Review changed counts before COMMIT.
SELECT 'target defects' AS item, COUNT(*) AS count
FROM tmp_reassign_defect_ids
UNION ALL
SELECT 'defects still referencing user 6', COUNT(*)
FROM defects
WHERE id IN (SELECT id FROM tmp_reassign_defect_ids)
  AND (
      reporter_user_id = @from_user_id
      OR assignee_user_id = @from_user_id
      OR assigned_by_user_id = @from_user_id
      OR action_completed_by_user_id = @from_user_id
      OR verified_by_user_id = @from_user_id
  )
UNION ALL
SELECT 'defect_actions still referencing user 6', COUNT(*)
FROM defect_actions
WHERE user_id = @from_user_id
  AND defect_id IN (SELECT id FROM tmp_reassign_defect_ids)
UNION ALL
SELECT 'defect_status_histories still referencing user 6', COUNT(*)
FROM defect_status_histories
WHERE changed_by_user_id = @from_user_id
  AND defect_id IN (SELECT id FROM tmp_reassign_defect_ids)
UNION ALL
SELECT 'defect_action_images still referencing user 6', COUNT(*)
FROM defect_action_images
WHERE user_id = @from_user_id
  AND defect_id IN (SELECT id FROM tmp_reassign_defect_ids)
UNION ALL
SELECT 'test_case_result_evidences still referencing user 6', COUNT(*)
FROM test_case_result_evidences e
INNER JOIN defects d
    ON d.test_case_result_id = e.test_case_result_id
WHERE e.user_id = @from_user_id
  AND d.id IN (SELECT id FROM tmp_reassign_defect_ids);

DROP TEMPORARY TABLE tmp_reassign_defect_ids;

COMMIT;

-- Optional: also move test execution result ownership.
-- Run only if you intentionally want 수행결과 owner까지 12번으로 바꾸는 경우.
-- This is guarded to avoid UNIQUE(test_case_id, user_id) conflicts.
--
-- START TRANSACTION;
-- SET @from_user_id := 6;
-- SET @to_user_id := 12;
--
-- UPDATE test_case_result_histories h
-- INNER JOIN test_case_results r ON r.id = h.test_case_result_id
-- SET h.user_id = @to_user_id
-- WHERE h.user_id = @from_user_id
--   AND r.user_id = @from_user_id
--   AND NOT EXISTS (
--       SELECT 1
--       FROM test_case_results r2
--       WHERE r2.test_case_id = r.test_case_id
--         AND r2.user_id = @to_user_id
--   );
--
-- UPDATE test_case_results r
-- SET r.user_id = @to_user_id
-- WHERE r.user_id = @from_user_id
--   AND NOT EXISTS (
--       SELECT 1
--       FROM test_case_results r2
--       WHERE r2.test_case_id = r.test_case_id
--         AND r2.user_id = @to_user_id
--   );
--
-- COMMIT;
