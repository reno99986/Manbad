
CREATE FUNCTION GetStudentAverageScore(p_user_id INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
  DECLARE avg_score DECIMAL(5,2);

  SELECT AVG(score) INTO avg_score
  FROM Assessments
  WHERE user_id = p_user_id;

  RETURN IFNULL(avg_score, 0);
END
