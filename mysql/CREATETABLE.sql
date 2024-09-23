CREATE TABLE `userData` (
  `userID` int PRIMARY KEY,
  `name` varchar(255),
  `email` varchar(255),
  `password` varchar(255)
);

CREATE TABLE `Instructors` (
  `instructor_id` int PRIMARY KEY AUTO_INCREMENT,
  `UserID` int,
  `bio` text,
  `expertise` varchar(255)
);

CREATE TABLE `Courses` (
  `course_id` int PRIMARY KEY AUTO_INCREMENT,
  `instructor_id` int,
  `course_name` varchar(255),
  `description` text,
  `price` decimal(10,2),
  `duration` int
);

CREATE TABLE `Students` (
  `student_id` int PRIMARY KEY AUTO_INCREMENT,
  `UserID` int,
  `phone_number` varchar(20),
  `address` varchar(255)
);

CREATE TABLE `Enrollments` (
  `enrollment_id` int PRIMARY KEY AUTO_INCREMENT,
  `student_id` int,
  `course_id` int,
  `enrollment_date` date,
  `completion_status` enum('ongoing','completed','dropped')
);

CREATE TABLE `Course_Content` (
  `content_id` int PRIMARY KEY AUTO_INCREMENT,
  `course_id` int,
  `content_title` varchar(255),
  `content_type` enum('video','article','quiz'),
  `content_link` varchar(255),
  `duration` int
);

ALTER TABLE `Instructors` ADD FOREIGN KEY (`UserID`) REFERENCES `userData` (`userID`);

ALTER TABLE `Courses` ADD FOREIGN KEY (`instructor_id`) REFERENCES `Instructors` (`instructor_id`);

ALTER TABLE `Students` ADD FOREIGN KEY (`UserID`) REFERENCES `userData` (`userID`);

ALTER TABLE `Enrollments` ADD FOREIGN KEY (`student_id`) REFERENCES `Students` (`student_id`);

ALTER TABLE `Enrollments` ADD FOREIGN KEY (`course_id`) REFERENCES `Courses` (`course_id`);

ALTER TABLE `Course_Content` ADD FOREIGN KEY (`course_id`) REFERENCES `Courses` (`course_id`);
