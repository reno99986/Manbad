
CREATE FUNCTION CountCourseEnrollments(courseId INT) 
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE enrollment_count INT;
  
  -- Query to count how many users are enrolled in the course
  SELECT COUNT(*)
  INTO enrollment_count
  FROM Enrollments
  WHERE course_id = courseId;
  
  -- Return the count
  RETURN enrollment_count;
END 


