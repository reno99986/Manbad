-- Disable foreign key checks to prevent errors during drop
SET FOREIGN_KEY_CHECKS = 0;

-- Drop the tables in order considering dependencies
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Assessments;
DROP TABLE IF EXISTS Course_Content;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Users;

-- Re-enable foreign key checks after dropping tables
SET FOREIGN_KEY_CHECKS = 1;
