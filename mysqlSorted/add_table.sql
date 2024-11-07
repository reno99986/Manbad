CREATE TABLE Users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone_number VARCHAR(20),
  address VARCHAR(255),
  bio TEXT,
  expertise VARCHAR(255),
  role ENUM('student', 'instructor') NOT NULL,
  createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Courses Table
CREATE TABLE Courses (
  course_id INT AUTO_INCREMENT PRIMARY KEY,
  instructor_id INT,
  course_name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2),
  duration INT,
  FOREIGN KEY (instructor_id) REFERENCES Users(user_id) ON DELETE CASCADE,
  createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


-- Enrollments Table
CREATE TABLE Enrollments (
  enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  course_id INT,
  enrollment_date DATE,
  completion_status ENUM('ongoing', 'completed', 'dropped'),
  FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON delete cascade
  createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Course_Content Table
CREATE TABLE Course_Content (
  content_id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT,
  content_type ENUM('video', 'article') NOT NULL,
  content_title VARCHAR(255) NOT NULL,
  createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

CREATE TABLE Video_Content (
  content_id INT PRIMARY KEY,
  content_link VARCHAR(255),
  FOREIGN KEY (content_id) REFERENCES Course_Content(content_id) ON DELETE CASCADE
);

CREATE TABLE Article_Content (
  content_id INT PRIMARY KEY,
  content_link VARCHAR(255),
  content_text TEXT,
  FOREIGN KEY (content_id) REFERENCES Course_Content(content_id) ON DELETE CASCADE
);








-- Assessments Table (New table related to online courses)
CREATE TABLE Assessments (
  assessment_id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT,
  user_id INT,
  score DECIMAL(5, 2),
  date_taken DATE,
  FOREIGN KEY (course_id) REFERENCES Courses(course_id) on delete cascade,
  FOREIGN KEY (user_id) REFERENCES Users(user_id) on delete cascade
);
  
  
CREATE TABLE Quiz (
  quiz_id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT,
  quiz_title VARCHAR(255) NOT NULL,
  quiz_content JSON,
  FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
  createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
