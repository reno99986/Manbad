CREATE FUNCTION AverageScore(userId INT) 
RETURNS DECIMAL(5, 2)
DETERMINISTIC
BEGIN
    DECLARE avgScore DECIMAL(5, 2);
    
    SELECT AVG(score)
    INTO avgScore
    FROM Assessments
    WHERE user_id = userId;
    
    RETURN IFNULL(avgScore, 0);
END;


