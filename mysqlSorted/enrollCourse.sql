
CREATE PROCEDURE EnrollUserInCourse(IN p_user_id INT, IN p_course_id INT)
BEGIN
    DECLARE existing_enrollment INT;
    
    -- Check if the user is already enrolled in the course
    SELECT enrollment_id INTO existing_enrollment
    FROM Enrollments
    WHERE user_id = p_user_id AND course_id = p_course_id;

    -- If the enrollment exists, exit the procedure
    IF existing_enrollment IS NOT NULL THEN
        SELECT 'User is already enrolled in the course.' AS message;
    ELSE
        -- If the user is not enrolled, insert a new enrollment
        INSERT INTO Enrollments (user_id, course_id, enrollment_date, completion_status)
        VALUES (p_user_id, p_course_id, CURDATE(), 'ongoing');

        -- Update the enrollment count in the Courses table
        UPDATE Courses
        SET enrollment_count = enrollment_count + 1
        WHERE course_id = p_course_id;

        SELECT 'User enrolled successfully.' AS message;
    END IF;
END 