CREATE PROCEDURE AddAssessment(IN p_course_id INT, IN p_user_id INT, IN p_score DECIMAL(5, 2))
BEGIN
    DECLARE existing_assessment INT;

    -- Check if the user has already taken the assessment for the given course
    SELECT COUNT(*) INTO existing_assessment
    FROM Assessments
    WHERE course_id = p_course_id AND user_id = p_user_id;

    -- If the assessment exists, exit the procedure and inform the user
    IF existing_assessment > 0 THEN
        SELECT 'Assessment already taken by this user for this course.' AS Message;
    ELSE
        -- If not taken, insert the new assessment
        INSERT INTO Assessments (course_id, user_id, score, date_taken)
        VALUES (p_course_id, p_user_id, p_score, CURDATE());

        SELECT 'Assessment added successfully.' AS Message;
    END IF;
END;
