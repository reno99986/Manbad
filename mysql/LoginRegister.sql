
CREATE PROCEDURE RegisterUser(
  IN p_name VARCHAR(255),
  IN p_password VARCHAR(255),
  IN p_email VARCHAR(255),
  IN p_phone_number VARCHAR(20),
  IN p_address VARCHAR(255),
  IN p_bio TEXT,
  IN p_expertise VARCHAR(255),
  IN p_role ENUM('student', 'instructor')
)
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    -- Rollback transaction on error
    ROLLBACK;
    SELECT 'Registration failed due to an error.' AS Message;
  END;

  START TRANSACTION;

  -- Check if email already exists
  IF EXISTS (SELECT 1 FROM Users WHERE email = p_email) THEN
    ROLLBACK;
    SELECT 'Email already registered.' AS Message;
  ELSE
    -- Hash the password
    SET @hashed_password = SHA2(p_password, 256);

    -- Insert new user
    INSERT INTO Users (name, password, email, phone_number, address, bio, expertise, role)
    VALUES (p_name, @hashed_password, p_email, p_phone_number, p_address, p_bio, p_expertise, p_role);

    COMMIT;
    SELECT 'Registration successful.' AS Message;
  END IF;
END



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
    IF v_stored_password = SHA2(p_password, 256) THEN
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


