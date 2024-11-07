CREATE FUNCTION CountCoursesTaken(userId INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE courseCount INT;
    
    SELECT COUNT(*)
    INTO courseCount
    FROM Enrollments
    WHERE user_id = userId;
    
    RETURN courseCount;
END;
