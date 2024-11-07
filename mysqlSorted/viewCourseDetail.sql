CREATE VIEW Course_Details AS
SELECT 
    C.course_id,
    C.course_name,
    C.description,
    C.price,
    C.duration,
    U.user_id AS instructor_id,
    U.name AS instructor_name,
    U.expertise AS instructor_expertise,
    U.bio AS instructor_bio
FROM 
    Courses C
JOIN 
    Users U ON C.instructor_id = U.user_id
WHERE 
    U.role = 'instructor';
   
   SELECT *from Course_Details
