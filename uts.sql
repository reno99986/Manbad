-- Users Table (Combining Students and Instructors)
CREATE TABLE Users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone_number VARCHAR(20),
  address VARCHAR(255),
  bio TEXT,
  expertise VARCHAR(255),
  role ENUM('student', 'instructor') NOT NULL,
  createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Courses Table
CREATE TABLE Courses (
  course_id INT AUTO_INCREMENT PRIMARY KEY,
  instructor_id INT,
  course_name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2),
  duration INT,
  FOREIGN KEY (instructor_id) REFERENCES Users(user_id) ON DELETE CASCADE,
  createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
ALTER TABLE Courses ADD COLUMN enrollment_count INT DEFAULT 0;


-- Enrollments Table
CREATE TABLE Enrollments (
  enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  course_id INT,
  enrollment_date DATE,
  completion_status ENUM('ongoing', 'completed', 'dropped'),
  FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON delete cascade
  createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Course_Content Table
CREATE TABLE Course_Content (
  content_id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT,
  content_title VARCHAR(255) NOT NULL,
  content_type ENUM('video', 'article') NOT NULL,
  content_link VARCHAR(255),
  duration INT,
  FOREIGN KEY (course_id) REFERENCES Courses(course_id) on delete cascade,
  createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Assessments Table (New table related to online courses)
CREATE TABLE Assessments (
  assessment_id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT,
  user_id INT,
  score DECIMAL(5, 2),
  date_taken DATE,
  FOREIGN KEY (course_id) REFERENCES Courses(course_id) on delete cascade,
  FOREIGN KEY (user_id) REFERENCES Users(user_id) on delete cascade
);




DELIMITER $$
CREATE DEFINER=`phpmyadmin`@`localhost` FUNCTION `AverageScore`(userId INT) RETURNS decimal(5,2)
    DETERMINISTIC
BEGIN
    DECLARE avgScore DECIMAL(5, 2);
    
    SELECT AVG(score)
    INTO avgScore
    FROM Assessments
    WHERE user_id = userId;
    
    RETURN IFNULL(avgScore, 0);
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`phpmyadmin`@`localhost` FUNCTION `CountCourseEnrollments`(`courseId` INT) RETURNS int
    DETERMINISTIC
BEGIN
  DECLARE enrollment_count INT;

  SELECT COUNT(*)
  INTO enrollment_count
  FROM Enrollments
  WHERE course_id = courseId;
  
  RETURN enrollment_count;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`phpmyadmin`@`localhost` PROCEDURE `AddAssessment`(IN `p_course_id` INT, IN `p_user_id` INT, IN `p_score` DECIMAL(5,2))
BEGIN
    DECLARE existing_assessment INT;

    SELECT COUNT(*) INTO existing_assessment
    FROM Assessments
    WHERE course_id = p_course_id AND user_id = p_user_id;

    IF existing_assessment > 0 THEN
        SELECT 'Assessment already taken by this user for this course.' AS Message;
    ELSE
       
        INSERT INTO Assessments (course_id, user_id, score, date_taken)
        VALUES (p_course_id, p_user_id, p_score, CURDATE());

        SELECT 'Assessment added successfully.' AS Message;
    END IF;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`phpmyadmin`@`localhost` PROCEDURE `CheckCourseContentExists`(IN `p_course_id` INT, IN `p_content_title` VARCHAR(255), OUT `content_exists` BOOLEAN)
BEGIN
    DECLARE v_count INT;
    
    SELECT COUNT(*)
    INTO v_count
    FROM Course_Content
    WHERE course_id = p_course_id AND content_title = p_content_title;

    IF v_count > 0 THEN
        SET content_exists = TRUE;
    ELSE
        SET content_exists = FALSE;
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`phpmyadmin`@`localhost` PROCEDURE `CreateCourse`(IN `p_instructor_id` INT, IN `p_course_name` VARCHAR(255), IN `p_description` TEXT, IN `p_duration` INT)
BEGIN
    DECLARE v_role VARCHAR(20);


    SELECT role INTO v_role FROM Users WHERE user_id = p_instructor_id;
    
    IF v_role != 'instructor' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Only instructors can create courses';
    END IF;

    -- Insert the new course
    INSERT INTO Courses (instructor_id, course_name, description, duration)
    VALUES (p_instructor_id, p_course_name, p_description, p_duration);

    SELECT 'Course created successfully.' AS Message;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`phpmyadmin`@`localhost` PROCEDURE `CreateCourseContent`(IN `p_course_id` INT, IN `p_content_title` VARCHAR(255), IN `p_content_type` ENUM('video','article'), IN `p_content_link` VARCHAR(255))
BEGIN
    DECLARE content_exists BOOLEAN;

    -- Check if content already exists
    CALL CheckCourseContentExists(p_course_id, p_content_title, content_exists);

    IF content_exists THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Content already exists with the same title';
    ELSE
        INSERT INTO Course_Content (course_id, content_title, content_type, content_link)
        VALUES (p_course_id, p_content_title, p_content_type, p_content_link);
    END IF;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`phpmyadmin`@`localhost` PROCEDURE `DeleteCourse`(IN `p_course_id` INT, IN `p_instructor_id` INT)
BEGIN
    DECLARE v_role VARCHAR(20);
    DECLARE v_course_owner INT;

    SELECT role INTO v_role FROM Users WHERE user_id = p_instructor_id;
    
    IF v_role != 'instructor' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Only instructors can delete courses';
    END IF;

    SELECT instructor_id INTO v_course_owner FROM Courses WHERE course_id = p_course_id;
    
    IF v_course_owner != p_instructor_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'You are not the owner of this course';
    END IF;

    DELETE FROM Courses WHERE course_id = p_course_id;

    SELECT 'Course deleted successfully.' AS Message;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`phpmyadmin`@`localhost` PROCEDURE `DeleteCourseContent`(IN `p_content_id` INT)
BEGIN
    DECLARE content_exists BOOLEAN;

    -- Check if the content exists before attempting deletion
    IF EXISTS (SELECT 1 FROM Course_Content WHERE content_id = p_content_id) THEN
        DELETE FROM Course_Content WHERE content_id = p_content_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Content does not exist';
    END IF;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`phpmyadmin`@`localhost` PROCEDURE `DropCourse`(
    IN p_user_id INT,
    IN p_course_id INT
)
BEGIN
    DECLARE existing_enrollment INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        -- Rollback in case of any error
        ROLLBACK;
        SELECT 'An error occurred while dropping the course.' AS message;
    END;

    -- Start the transaction
    START TRANSACTION;

    -- Check if the user is enrolled in the course
    SELECT enrollment_id INTO existing_enrollment
    FROM Enrollments
    WHERE user_id = p_user_id AND course_id = p_course_id;

    -- If no enrollment exists, return an error message
    IF existing_enrollment IS NULL THEN
        ROLLBACK;
        SELECT 'User is not enrolled in the course.' AS message;
    ELSE
        -- Delete the enrollment record
        DELETE FROM Enrollments
        WHERE enrollment_id = existing_enrollment;

        -- Commit the transaction
        COMMIT;

        -- Return success message
        SELECT 'Course dropped successfully.' AS message;
    END IF;

END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`phpmyadmin`@`localhost` PROCEDURE `EnrollUserInCourse`(IN `p_user_id` INT, IN `p_course_id` INT)
BEGIN
    DECLARE existing_enrollment INT;

    SELECT enrollment_id INTO existing_enrollment
    FROM Enrollments
    WHERE user_id = p_user_id AND course_id = p_course_id;

 
    IF existing_enrollment IS NOT NULL THEN
        SELECT 'User is already enrolled in the course.' AS message;
    ELSE
        INSERT INTO Enrollments (user_id, course_id, enrollment_date, completion_status)
        VALUES (p_user_id, p_course_id, CURDATE(), 'ongoing');


        SELECT 'User enrolled successfully.' AS message;
    END IF;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`phpmyadmin`@`localhost` PROCEDURE `GetAssessmentScore`(IN `p_course_id` INT, IN `p_user_id` INT)
BEGIN

    SELECT score, date_taken
    FROM Assessments
    WHERE course_id = p_course_id AND user_id = p_user_id;
END$$
DELIMITER ;



DELIMITER $$
CREATE DEFINER=`phpmyadmin`@`localhost` PROCEDURE `ReadCourseContent`(IN `p_course_id` INT)
BEGIN
    SELECT content_id, content_title, content_type, content_link, duration
    FROM Course_Content
    WHERE course_id = p_course_id;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`phpmyadmin`@`localhost` PROCEDURE `RegisterUser`(IN `p_name` VARCHAR(255), IN `p_password` VARCHAR(255), IN `p_email` VARCHAR(255), IN `p_phone_number` VARCHAR(20), IN `p_address` VARCHAR(255), IN `p_bio` TEXT, IN `p_expertise` VARCHAR(255), IN `p_role` ENUM('student','instructor'))
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SELECT 'Registration failed due to an error.' AS Message;
  END;

  START TRANSACTION;

  IF EXISTS (SELECT 1 FROM Users WHERE email = p_email) THEN
    ROLLBACK;
    SELECT 'Email already registered.' AS Message;
  ELSE

    INSERT INTO Users (name, password, email, phone_number, address, bio, expertise, role)
    VALUES (p_name, p_password, p_email, p_phone_number, p_address, p_bio, p_expertise, p_role);

    COMMIT;
    SELECT 'Registration successful.' AS Message;
  END IF;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`phpmyadmin`@`localhost` PROCEDURE `SearchCourse`(IN `p_course_name` VARCHAR(255))
BEGIN
    SELECT *
    FROM Courses
    WHERE course_name LIKE CONCAT('%', p_course_name, '%');
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`phpmyadmin`@`localhost` PROCEDURE `UpdateAssessmentScore`(IN `p_course_id` INT, IN `p_user_id` INT, IN `p_new_score` DECIMAL(5,2))
BEGIN
    DECLARE existing_assessment INT;

    -- Check if the assessment exists for the user and course
    SELECT COUNT(*) INTO existing_assessment
    FROM Assessments
    WHERE course_id = p_course_id AND user_id = p_user_id;
    
    IF existing_assessment > 0 THEN
        UPDATE Assessments
        SET score = p_new_score, date_taken = CURDATE()  -- Optional: update the date taken
        WHERE course_id = p_course_id AND user_id = p_user_id;

        SELECT 'Assessment score updated successfully.' AS Message;
    ELSE
        -- If the assessment does not exist, return a message
        SELECT 'No existing assessment found for this user in the specified course.' AS Message;
    END IF;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`phpmyadmin`@`localhost` PROCEDURE `UpdateCourse`(IN `p_course_id` INT, IN `p_instructor_id` INT, IN `p_course_name` VARCHAR(255), IN `p_description` TEXT, IN `p_duration` INT)
BEGIN
    DECLARE v_role VARCHAR(20);
    DECLARE v_course_owner INT;

    SELECT role INTO v_role FROM Users WHERE user_id = p_instructor_id;
    
    IF v_role != 'instructor' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Only instructors can update courses';
    END IF;

    SELECT instructor_id INTO v_course_owner FROM Courses WHERE course_id = p_course_id;
    
    IF v_course_owner != p_instructor_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'You are not the owner of this course';
    END IF;

    UPDATE Courses
    SET course_name = p_course_name, 
        description = p_description, 
        duration = p_duration,
        updatedAt = CURRENT_TIMESTAMP
    WHERE course_id = p_course_id;

    SELECT 'Course updated successfully.' AS Message;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`phpmyadmin`@`localhost` PROCEDURE `UpdateCourseContent`(IN `p_content_id` INT, IN `p_course_id` INT, IN `p_content_title` VARCHAR(255), IN `p_content_type` ENUM('video','article'), IN `p_content_link` VARCHAR(255), IN `p_duration` INT)
BEGIN
    DECLARE content_exists BOOLEAN;

    CALL CheckCourseContentExists(p_course_id, p_content_title, content_exists);

    IF content_exists AND (SELECT content_id FROM Course_Content WHERE content_id = p_content_id) IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Another content exists with the same title';
    ELSE

        UPDATE Course_Content
        SET content_title = p_content_title,
            content_type = p_content_type,
            content_link = p_content_link,
            duration = p_duration
        WHERE content_id = p_content_id;
    END IF;
END$$
DELIMITER ;