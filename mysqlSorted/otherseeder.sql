INSERT INTO Courses (course_name, instructor_id, description, price, duration) VALUES
('Introduction to Programming', 6, 'Learn the basics of programming with hands-on examples.', 100.00, 30),
('Advanced Python', 7, 'Master Python with advanced topics like concurrency and networking.', 150.00, 45),
('Web Development 101', 9, 'Build responsive websites using HTML, CSS, and JavaScript.', 120.00, 40),
('Data Science with Python', 6, 'Learn how to use Python for data analysis and visualization.', 200.00, 60),
('Machine Learning Basics', 7, 'Get started with machine learning algorithms and models.', 250.00, 50),
('Frontend Web Development', 9, 'Learn to build beautiful web interfaces using modern frameworks.', 180.00, 55),
('Mobile App Development', 6, 'Create mobile apps with native and cross-platform frameworks.', 300.00, 70),
('DevOps Fundamentals', 7, 'Understand the essentials of DevOps and CI/CD pipelines.', 220.00, 50),
('Cloud Computing with AWS', 9, 'Learn cloud computing concepts and AWS services.', 280.00, 60),
('Cybersecurity Basics', 6, 'Learn the fundamentals of cybersecurity and network protection.', 170.00, 45);


INSERT INTO Enrollments (user_id, course_id, enrollment_date, completion_status) VALUES
(1, 1, '2024-01-15', 'ongoing'),
(2, 2, '2024-01-16', 'ongoing'),
(3, 3, '2024-01-17', 'ongoing'),
(4, 4, '2024-01-18', 'ongoing'),
(5, 5, '2024-01-19', 'ongoing'),
(8, 6, '2024-01-20', 'ongoing'),
(1, 7, '2024-01-21', 'ongoing'),
(2, 8, '2024-01-22', 'ongoing'),
(3, 9, '2024-01-23', 'ongoing'),
(4, 10, '2024-01-24', 'ongoing');


INSERT INTO Course_Content (course_id, content_title, content_type, content_link, duration) VALUES
(1, 'Introduction Video', 'video', 'link_to_intro_video', 10),
(2, 'Python Basics', 'article', 'link_to_python_basics', 20),
(3, 'HTML and CSS', 'video', 'link_to_html_css', 30),
(4, 'Data Visualization', 'quiz', 'link_to_data_quiz', 15),
(5, 'Linear Regression', 'video', 'link_to_regression_video', 40),
(6, 'CSS Frameworks', 'article', 'link_to_css_frameworks', 25),
(7, 'App Architecture', 'video', 'link_to_app_architecture', 50),
(8, 'CI/CD Pipelines', 'video', 'link_to_cicd_pipelines', 35),
(9, 'AWS Services Overview', 'article', 'link_to_aws_services', 45),
(10, 'Network Security Basics', 'quiz', 'link_to_security_quiz', 30);


INSERT INTO Assessments (course_id, user_id, assessment_type, score, date_taken) VALUES
(1, 1, 'quiz', 85.50, '2024-02-01'),
(2, 2, 'assignment', 90.00, '2024-02-02'),
(3, 3, 'project', 88.00, '2024-02-03'),
(4, 4, 'quiz', 92.50, '2024-02-04'),
(5, 5, 'assignment', 75.50, '2024-02-05'),
(6, 8, 'quiz', 89.00, '2024-02-06'),
(7, 1, 'project', 95.00, '2024-02-07'),
(8, 2, 'quiz', 85.00, '2024-02-08'),
(9, 3, 'assignment', 91.00, '2024-02-09'),
(10, 4, 'quiz', 93.00, '2024-02-10');
