-- 0. Database Setup
CREATE DATABASE IF NOT EXISTS attendance_db;
USE attendance_db;

-- 1. Master Tables
CREATE TABLE department (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE batch (
    batch_id VARCHAR(5) PRIMARY KEY,
    batch_name VARCHAR(20) NOT NULL
);

-- 2. Supporting Tables
CREATE TABLE subject (
    sub_code INT PRIMARY KEY AUTO_INCREMENT,
    sub_name VARCHAR(50) NOT NULL UNIQUE,
    credits INT,
    dept_id INT,
    CONSTRAINT fk_subject_dept FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

CREATE TABLE class (
    class_id INT PRIMARY KEY AUTO_INCREMENT,
    year_of_study INT NOT NULL,
    division CHAR(1) NOT NULL,
    dept_id INT,
    CONSTRAINT fk_class_dept FOREIGN KEY (dept_id) REFERENCES department(dept_id),
    UNIQUE(year_of_study, division, dept_id)
);

CREATE TABLE professor (
    prof_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    dept_id INT,
    CONSTRAINT fk_professor_dept FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

-- 3. Student Table
CREATE TABLE student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    roll_no INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    batch_id VARCHAR(5) NOT NULL,
    class_id INT,
    CONSTRAINT fk_student_class FOREIGN KEY (class_id) REFERENCES class(class_id),
    CONSTRAINT fk_student_batch FOREIGN KEY (batch_id) REFERENCES batch(batch_id),
    UNIQUE(roll_no, class_id)
);

-- 4. Session Table
CREATE TABLE attendance_session (
    session_id INT PRIMARY KEY AUTO_INCREMENT,
    session_type ENUM('Lecture', 'Lab') NOT NULL,
    batch_id VARCHAR(5),
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    prof_id INT,
    sub_code INT,
    class_id INT,
    CONSTRAINT fk_sess_prof FOREIGN KEY (prof_id) REFERENCES professor(prof_id),
    CONSTRAINT fk_sess_sub FOREIGN KEY (sub_code) REFERENCES subject(sub_code),
    CONSTRAINT fk_sess_class FOREIGN KEY (class_id) REFERENCES class(class_id),
    CONSTRAINT fk_sess_batch FOREIGN KEY (batch_id) REFERENCES batch(batch_id),
    CONSTRAINT chk_time CHECK (end_time > start_time)
);

-- 5. Record Table
CREATE TABLE attendance_record (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    status ENUM('Present', 'Absent', 'Late') NOT NULL,
    session_id INT,
    student_id INT,
    CONSTRAINT fk_rec_sess FOREIGN KEY (session_id) REFERENCES attendance_session(session_id),
    CONSTRAINT fk_rec_student FOREIGN KEY (student_id) REFERENCES student(student_id),
    UNIQUE(session_id, student_id)
);

-- 6. Logic Layer: Triggers, Procedures, and Views
DELIMITER //

CREATE TRIGGER validate_attendance_batch
BEFORE INSERT ON attendance_record
FOR EACH ROW
BEGIN
   DECLARE s_batch VARCHAR(5);
   DECLARE sess_batch VARCHAR(5);
   SELECT batch_id INTO s_batch FROM student WHERE student_id = NEW.student_id;
   SELECT batch_id INTO sess_batch FROM attendance_session WHERE session_id = NEW.session_id;
   IF s_batch != sess_batch THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Integrity Violation: Student batch does not match session batch.';
   END IF;
END //

CREATE PROCEDURE mark_batch_present(IN p_session_id INT, IN p_batch_id VARCHAR(5))
BEGIN
    INSERT INTO attendance_record (session_id, student_id, status)
    SELECT p_session_id, student_id, 'Present'
    FROM student WHERE batch_id = p_batch_id
    ON DUPLICATE KEY UPDATE status = 'Present';
END //

DELIMITER ;

CREATE VIEW attendance_report AS
SELECT s.name AS Student_Name, sess.session_type AS Type, sess.start_time AS Date, rec.status AS Attendance_Status
FROM attendance_record rec
JOIN student s ON rec.student_id = s.student_id
JOIN attendance_session sess ON rec.session_id = sess.session_id;