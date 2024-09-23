INSERT INTO `Users` (`user_id`, `name`, `password`, `email`, `phone_number`, `address`, `bio`, `expertise`, `role`) VALUES
(1, 'Alice Johnson', 'password123', 'alice@example.com', '555-1234', '123 Main St', 'Expert in Mathematics', 'Mathematics', 'instructor'),
(2, 'Bob Smith', 'password123', 'bob@example.com', '555-2345', '456 Oak Ave', 'Physics specialist', 'Physics', 'instructor'),
(3, 'Charlie Brown', 'password123', 'charlie@example.com', '555-3456', '789 Pine Rd', NULL, NULL, 'student'),
(4, 'Diana Prince', 'password123', 'diana@example.com', '555-4567', '101 Maple Blvd', NULL, NULL, 'student'),
(5, 'Ethan Hunt', 'password123', 'ethan@example.com', '555-5678', '202 Birch Ln', NULL, NULL, 'student'),
(6, 'Fiona Gallagher', 'password123', 'fiona@example.com', '555-6789', '303 Cedar Dr', NULL, NULL, 'student'),
(7, 'George Miller', 'password123', 'george@example.com', '555-7890', '404 Elm St', 'Chemistry enthusiast', 'Chemistry', 'instructor'),
(8, 'Hannah Lee', 'password123', 'hannah@example.com', '555-8901', '505 Spruce Ct', 'Music Theory expert', 'Music Theory', 'instructor'),
(9, 'Ian Malcolm', 'password123', 'ian@example.com', '555-9012', '606 Willow Way', 'Biology researcher', 'Biology', 'instructor'),
(10, 'Jack Sparrow', 'password123', 'jack@example.com', '555-0123', '707 Aspen Pl', NULL, NULL, 'student');

INSERT INTO `Courses` (`course_id`, `instructor_id`, `course_name`, `description`, `price`, `duration`) VALUES
(1, 1, 'Calculus I', 'Introduction to Calculus', 100.00, 30),
(2, 2, 'Physics Fundamentals', 'Basics of Physics', 120.00, 45),
(3, 7, 'Organic Chemistry', 'Study of organic compounds', 150.00, 40),
(4, 8, 'Music Theory Basics', 'Fundamentals of Music Theory', 80.00, 25),
(5, 9, 'Introduction to Biology', 'Basics of Biology', 90.00, 35),
(6, 1, 'Advanced Algebra', 'In-depth Algebra concepts', 110.00, 30),
(7, 2, 'Astronomy 101', 'Introduction to Astronomy', 130.00, 50),
(8, 7, 'Inorganic Chemistry', 'Study of inorganic compounds', 140.00, 40),
(9, 8, 'Composition Techniques', 'Learn music composition', 95.00, 20),
(10, 9, 'Genetics', 'Basics of Genetics', 85.00, 30);

INSERT INTO `Enrollments` (`enrollment_id`, `user_id`, `course_id`, `enrollment_date`, `completion_status`) VALUES
(1, 3, 1, '2023-01-10', 'ongoing'),
(2, 4, 2, '2023-01-15', 'completed'),
(3, 5, 3, '2023-02-20', 'dropped'),
(4, 6, 4, '2023-03-05', 'ongoing'),
(5, 10, 5, '2023-03-25', 'completed'),
(6, 3, 6, '2023-04-10', 'ongoing'),
(7, 4, 7, '2023-04-20', 'dropped'),
(8, 5, 8, '2023-05-15', 'ongoing'),
(9, 6, 9, '2023-05-25', 'completed'),
(10, 10, 10, '2023-06-01', 'ongoing');


INSERT INTO `Course_Content` (`content_id`, `course_id`, `content_title`, `content_type`, `content_link`, `duration`) VALUES
(1, 1, 'Limits and Continuity', 'video', 'http://example.com/calculus1', 60),
(2, 2, 'Newtonian Mechanics', 'video', 'http://example.com/physics1', 45),
(3, 3, 'Hydrocarbons', 'article', 'http://example.com/chemistry1', NULL),
(4, 4, 'Musical Notation', 'video', 'http://example.com/music1', 35),
(5, 5, 'Cell Structure', 'article', 'http://example.com/biology1', NULL),
(6, 6, 'Polynomial Functions', 'video', 'http://example.com/algebra1', 50),
(7, 7, 'Solar System Overview', 'video', 'http://example.com/astronomy1', 70),
(8, 8, 'Periodic Table', 'quiz', NULL, NULL),
(9, 9, 'Melody Creation', 'video', 'http://example.com/composition1', 40),
(10, 10, 'DNA Replication', 'article', 'http://example.com/genetics1', NULL);

INSERT INTO `Assessments` (`assessment_id`, `course_id`, `user_id`, `assessment_type`, `score`, `date_taken`) VALUES
(1, 1, 3, 'quiz', 85.00, '2023-01-20'),
(2, 2, 4, 'assignment', 90.00, '2023-01-25'),
(3, 3, 5, 'project', 70.00, '2023-02-25'),
(4, 4, 6, 'quiz', 88.00, '2023-03-15'),
(5, 5, 10, 'assignment', 92.00, '2023-03-30'),
(6, 6, 3, 'quiz', 80.00, '2023-04-20'),
(7, 7, 4, 'assignment', 75.00, '2023-04-25'),
(8, 8, 5, 'project', 65.00, '2023-05-20'),
(9, 9, 6, 'quiz', 95.00, '2023-05-30'),
(10, 10, 10, 'assignment', 85.00, '2023-06-10');



