ALTER TABLE defects
    MODIFY status ENUM('received', 'assigned', 'action_completed', 'tester_confirmation_pending', 'verification_completed') NOT NULL DEFAULT 'received';

ALTER TABLE defect_actions
    MODIFY from_status ENUM('received', 'assigned', 'action_completed', 'tester_confirmation_pending', 'verification_completed') NULL,
    MODIFY to_status ENUM('received', 'assigned', 'action_completed', 'tester_confirmation_pending', 'verification_completed') NULL;

ALTER TABLE defect_status_histories
    MODIFY from_status ENUM('received', 'assigned', 'action_completed', 'tester_confirmation_pending', 'verification_completed') NULL,
    MODIFY to_status ENUM('received', 'assigned', 'action_completed', 'tester_confirmation_pending', 'verification_completed') NOT NULL;
