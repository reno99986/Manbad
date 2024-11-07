
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

    -- Insert new user
    INSERT INTO Users (name, password, email, phone_number, address, bio, expertise, role)
    VALUES (p_name, password, p_email, p_phone_number, p_address, p_bio, p_expertise, p_role);

    COMMIT;
    SELECT 'Registration successful.' AS Message;
  END IF;
END