-- Users Table (Combining Students and Instructors)
CREATE TABLE Users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone_number VARCHAR(20),
  address VARCHAR(255),
  bio TEXT,
  expertise VARCHAR(255),
  role ENUM('student', 'instructor') NOT NULL
);

-- Courses Table
CREATE TABLE Courses (
  course_id INT AUTO_INCREMENT PRIMARY KEY,
  instructor_id INT,
  course_name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2),
  duration INT,
  FOREIGN KEY (instructor_id) REFERENCES Users(user_id)
);
ALTER TABLE Courses ADD COLUMN enrollment_count INT DEFAULT 0;


-- Enrollments Table
CREATE TABLE Enrollments (
  enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  course_id INT,
  enrollment_date DATE,
  completion_status ENUM('ongoing', 'completed', 'dropped'),
  FOREIGN KEY (user_id) REFERENCES Users(user_id),
  FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Course_Content Table
CREATE TABLE Course_Content (
  content_id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT,
  content_title VARCHAR(255) NOT NULL,
  content_type ENUM('video', 'article', 'quiz') NOT NULL,
  content_link VARCHAR(255),
  duration INT,
  FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Assessments Table (New table related to online courses)
CREATE TABLE Assessments (
  assessment_id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT,
  user_id INT,
  assessment_type ENUM('quiz', 'assignment', 'project') NOT NULL,
  score DECIMAL(5, 2),
  date_taken DATE,
  FOREIGN KEY (course_id) REFERENCES Courses(course_id),
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
  
  
  
  -- Sessions Table
CREATE TABLE Sessions (
  session_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  session_token VARCHAR(255) UNIQUE NOT NULL,
  login_time DATETIME DEFAULT CURRENT_TIMESTAMP,
  logout_time DATETIME,
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

  
);