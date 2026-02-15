-- 1. Teacher Table (Independent Entity)
CREATE TABLE teacher (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL, -- Increased length
    department VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. Class Table (The "Container" for subjects/divisions)
CREATE TABLE class (
    class_id INT PRIMARY KEY AUTO_INCREMENT,
    teacher_id INT, -- Linking teacher to their class/subject
    department VARCHAR(50) NOT NULL,
    year CHAR(4) NOT NULL, -- Standardized to 4 digits (e.g., 2024)
    division CHAR(1) NOT NULL,
    subject VARCHAR(100) NOT NULL,
    type VARCHAR(20) NOT NULL, -- e.g., Theory, Lab
    batch CHAR(2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id) ON DELETE SET NULL
);

-- 3. Student Table
CREATE TABLE student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    class_id INT NOT NULL, -- Student belongs to a class
    name VARCHAR(100) NOT NULL,
    roll_no INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES class(class_id),
    UNIQUE(class_id, roll_no) -- Prevents duplicate roll numbers in the same class
);

-- 4. Attendance Metadata (One record per lecture/session)
CREATE TABLE attendance_metadata (
    att_meta_id INT PRIMARY KEY AUTO_INCREMENT,
    class_id INT NOT NULL,
    session_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES class(class_id)
);

-- 5. Attendance Record (The list of students present in a session)
CREATE TABLE attendance_record (
    att_record_id INT PRIMARY KEY AUTO_INCREMENT,
    att_meta_id INT NOT NULL, -- Links to the session info
    student_id INT NOT NULL,
    is_present TINYINT(1) DEFAULT 0, -- 0 for Absent, 1 for Present
    FOREIGN KEY (att_meta_id) REFERENCES attendance_metadata(att_meta_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE,
    UNIQUE(att_meta_id, student_id) -- Prevents marking a student twice for the same session
);
