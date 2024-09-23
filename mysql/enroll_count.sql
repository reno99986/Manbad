
CREATE TRIGGER after_enrollment_insert
AFTER INSERT ON Enrollments
FOR EACH ROW
BEGIN
  UPDATE Courses
  SET enrollment_count = enrollment_count + 1
  WHERE course_id = NEW.course_id;
END


CREATE TRIGGER after_enrollment_delete
AFTER DELETE ON Enrollments
FOR EACH ROW
BEGIN
  UPDATE Courses
  SET enrollment_count = enrollment_count - 1
  WHERE course_id = OLD.course_id;
END