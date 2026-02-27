-- 0. Create db if not exists
CREATE DATABASE IF NOT EXISTS attendance_db;
USE attendance_db;

-- 1. Department table (Independent Entity)
CREATE TABLE department (
  dept_id INT PRIMARY KEY AUTO_INCREMENT,
  dept_name VARCHAR(50) NOT NULL UNIQUE,
  location VARCHAR(10),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. Subject table
CREATE TABLE subject (
  sub_code INT PRIMARY KEY AUTO_INCREMENT,
  sub_name VARCHAR(50) NOT NULL UNIQUE,
  credits INT,
  dept_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_subject_dept FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

-- 3. Class table
CREATE TABLE class (
  class_id INT PRIMARY KEY AUTO_INCREMENT,
  year_of_study INT NOT NULL,
  division CHAR(1) NOT NULL,
  dept_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_class_dept FOREIGN KEY (dept_id) REFERENCES department(dept_id),
  UNIQUE(year_of_study, division, dept_id)
);

-- 4. Professor table
CREATE table professor (
  prof_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  title VARCHAR(20),
  dept_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_professor_dept FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

-- 5. Student table
CREATE TABLE student (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  roll_no INT NOT NULL,
  name VARCHAR(50) NOT NULL,
  batch_no CHAR(2) NOT NULL,
  class_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_student_class FOREIGN KEY (class_id) REFERENCES class(class_id),
  UNIQUE(roll_no, class_id)
);

-- 6. Attendance_Session table
CREATE TABLE attendance_session (
  session_id INT PRIMARY KEY AUTO_INCREMENT,
  session_type ENUM('Lecture', 'Lab') NOT NULL,
  batch_no CHAR(2),
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  prof_id INT,
  sub_code INT,
  class_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_sess_prof FOREIGN KEY (prof_id) REFERENCES professor(prof_id),
  CONSTRAINT fk_sess_sub FOREIGN KEY (sub_code) REFERENCES subject(sub_code),
  CONSTRAINT fk_sess_class FOREIGN KEY (class_id) REFERENCES class(class_id),
  CONSTRAINT chk_time CHECK ( end_time > start_time )
);

-- 7. Attendance_Record table
CREATE TABLE attendance_record (
  record_id INT PRIMARY KEY AUTO_INCREMENT,
  status ENUM('Present', 'Absent', 'Late') NOT NULL,
  session_id INT,
  student_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_rec_sess FOREIGN KEY (session_id) REFERENCES attendance_session(session_id),
  CONSTRAINT fk_rec_student FOREIGN KEY (student_id) REFERENCES student(student_id),
  UNIQUE(session_id, student_id)
);
