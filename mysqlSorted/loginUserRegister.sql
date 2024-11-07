
CREATE PROCEDURE LoginUser(
  IN p_email VARCHAR(255),
  IN p_password VARCHAR(255)
)
BEGIN
  DECLARE v_user_id INT;
  DECLARE v_stored_password VARCHAR(255);
  DECLARE v_session_token VARCHAR(255);
  DECLARE v_role ENUM('student', 'instructor');

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    -- Rollback transaction on error
    ROLLBACK;
    SELECT 'Login failed due to an error.' AS Message;
  END;

  START TRANSACTION;

  -- Retrieve user credentials
  SELECT user_id, password, role INTO v_user_id, v_stored_password, v_role
  FROM Users
  WHERE email = p_email;

  IF v_user_id IS NULL THEN
    ROLLBACK;
    SELECT 'Invalid email or password.' AS Message;
  ELSE
    -- Verify password
    IF v_stored_password = p_password THEN
      -- Generate session token
      SET v_session_token = UUID();

      -- Insert session record
      INSERT INTO Sessions (user_id, session_token)
      VALUES (v_user_id, v_session_token);

      COMMIT;
      SELECT 'Login successful.' AS Message, v_session_token AS SessionToken, v_role AS UserRole;
    ELSE
      ROLLBACK;
      SELECT 'Invalid email or password.' AS Message;
    END IF;
  END IF;
END