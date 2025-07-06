-- Create the database
CREATE DATABASE IF NOT EXISTS TeamGammaDB;
USE TeamGammaDB;

-- Students Table
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(100),
    Major VARCHAR(100),
    Year VARCHAR(20) -- 'Year 1', 'Year 2'
);

-- Instructors Table
CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(100),
    Department VARCHAR(100)
);

-- Courses Table
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseCode VARCHAR(50),  -- 'CS101'
    Title VARCHAR(100),
    Credits INT,
    Department VARCHAR(100)
);

-- CourseOfferings Table
CREATE TABLE CourseOfferings (
    OfferingID INT PRIMARY KEY,
    CourseID INT,
    Semester VARCHAR(50),
    InstructorID INT,
    Schedule VARCHAR(100),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID)
);

-- Enrollments Table
CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    OfferingID INT,
    EnrollmentDate DATE,
    Grade VARCHAR(5),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (OfferingID) REFERENCES CourseOfferings(OfferingID)
);

-- Prerequisites Table
CREATE TABLE Prerequisites (
    CourseID INT,
    PrerequisiteID INT,
    PRIMARY KEY (CourseID, PrerequisiteID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (PrerequisiteID) REFERENCES Courses(CourseID)
);

-- Grade table
CREATE TABLE Grade (
    Grade_ID INT PRIMARY KEY,
    Grade VARCHAR(5) UNIQUE,       -- 'A', 'B+'
    Grade_Score DECIMAL(3,2)       --  4.00, 3.30
);

-- drop Grade column from Enrollments tables
ALTER TABLE Enrollments
DROP COLUMN Grade;

-- Add Grade_ID to Enrollments tables -FK to Grade table
ALTER TABLE Enrollments
ADD COLUMN Grade_ID INT;

-- Add fk constraint linked to Grade table
ALTER TABLE Enrollments
ADD CONSTRAINT fk_enrollment_grade
FOREIGN KEY (Grade_ID)
REFERENCES Grade(Grade_ID);

-- Improvements to the database
USE TeamGammaDB;

-- 1. dropping FK to allow the changes
ALTER TABLE CourseOfferings DROP FOREIGN KEY CourseOfferings_ibfk_1;
ALTER TABLE CourseOfferings DROP FOREIGN KEY CourseOfferings_ibfk_2;

ALTER TABLE Enrollments DROP FOREIGN KEY Enrollments_ibfk_1;
ALTER TABLE Enrollments DROP FOREIGN KEY Enrollments_ibfk_2;
ALTER TABLE Enrollments DROP FOREIGN KEY fk_enrollment_grade;

ALTER TABLE Prerequisites DROP FOREIGN KEY Prerequisites_ibfk_1;
ALTER TABLE Prerequisites DROP FOREIGN KEY Prerequisites_ibfk_2;

-- 2. Modify PKs for Auto Increment
ALTER TABLE Students MODIFY StudentID INT AUTO_INCREMENT;
ALTER TABLE Instructors MODIFY InstructorID INT AUTO_INCREMENT;
ALTER TABLE Courses MODIFY CourseID INT AUTO_INCREMENT;
ALTER TABLE CourseOfferings MODIFY OfferingID INT AUTO_INCREMENT;
ALTER TABLE Enrollments MODIFY EnrollmentID INT AUTO_INCREMENT;
ALTER TABLE Grade MODIFY Grade_ID INT AUTO_INCREMENT;

-- 3. Add Not Null constraints on essential fields of the tables

-- Students table
ALTER TABLE Students
MODIFY FirstName VARCHAR(100) NOT NULL,
MODIFY LastName VARCHAR(100) NOT NULL,
MODIFY Email VARCHAR(100) NOT NULL,
MODIFY Phone VARCHAR(100) NOT NULL,
MODIFY Major VARCHAR(100) NOT NULL,
MODIFY Year VARCHAR(20) NOT NULL;

-- Instructors table
ALTER TABLE Instructors
MODIFY FirstName VARCHAR(100) NOT NULL,
MODIFY LastName VARCHAR(100) NOT NULL,
MODIFY Email VARCHAR(100) NOT NULL,
MODIFY Department VARCHAR(100) NOT NULL;

-- Courses table
ALTER TABLE Courses
MODIFY CourseCode VARCHAR(50) NOT NULL,
MODIFY Title VARCHAR(100) NOT NULL,
MODIFY Credits INT NOT NULL,
MODIFY Department VARCHAR(100) NOT NULL;

-- CourseOfferings table
ALTER TABLE CourseOfferings
MODIFY Semester VARCHAR(50) NOT NULL,
MODIFY Schedule VARCHAR(100) NOT NULL;

-- Enrollments table
ALTER TABLE Enrollments
MODIFY EnrollmentDate DATE NOT NULL,
MODIFY Grade_ID INT NOT NULL;

-- Grades table
ALTER TABLE Grade
MODIFY Grade VARCHAR(5) NOT NULL,
MODIFY Grade_Score DECIMAL(3,2) NOT NULL;

-- 4. Unique constraints
ALTER TABLE Students ADD CONSTRAINT unique_student_email UNIQUE (Email);
ALTER TABLE Instructors ADD CONSTRAINT unique_instructor_email UNIQUE (Email);

-- 5. Add check constraints
ALTER TABLE Students
ADD CONSTRAINT chk_student_year CHECK (Year IN ('Year 1', 'Year 2', 'Year 3', 'Year 4'));

ALTER TABLE Courses
ADD CONSTRAINT chk_course_credits CHECK (Credits > 0);

ALTER TABLE Grade
ADD CONSTRAINT chk_grade_score CHECK (Grade_Score >= 0 AND Grade_Score <= 4.00);

-- 6. Rename Grade table
RENAME TABLE Grade TO Grades;

-- 7. Adding FKs again

-- CourseOfferings table
ALTER TABLE CourseOfferings
ADD CONSTRAINT fk_course_offerings_course
FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE CourseOfferings
ADD CONSTRAINT fk_course_offerings_instructor
FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID)
ON DELETE SET NULL ON UPDATE CASCADE;

-- Enrollments table
ALTER TABLE Enrollments
ADD CONSTRAINT fk_enrollments_student
FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Enrollments
ADD CONSTRAINT fk_enrollments_offering
FOREIGN KEY (OfferingID) REFERENCES CourseOfferings(OfferingID)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Enrollments
MODIFY Grade_ID INT NULL;


ALTER TABLE Enrollments
ADD CONSTRAINT fk_enrollments_grade
FOREIGN KEY (Grade_ID) REFERENCES Grades(Grade_ID)
ON DELETE SET NULL ON UPDATE CASCADE;

-- Prerequisites table
ALTER TABLE Prerequisites
ADD CONSTRAINT fk_prereq_course
FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Prerequisites
ADD CONSTRAINT fk_prereq_prerequisite
FOREIGN KEY (PrerequisiteID) REFERENCES Courses(CourseID)
ON DELETE CASCADE ON UPDATE CASCADE;

-- Insert into Students table
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Katherine', 'Little', 'katherine.little1@example.com', '+1-895-314-2074x7043', 'Economics', 'Year 2');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Laura', 'Lee', 'laura.lee2@example.com', '753.546.5144', 'Mathematics', 'Year 1');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Jeremy', 'Lucas', 'jeremy.lucas3@example.com', '390-369-6902x216', 'Economics', 'Year 1');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Tommy', 'Joseph', 'tommy.joseph4@example.com', '(991)709-7605', 'Chemistry', 'Year 2');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Maria', 'Rogers', 'maria.rogers5@example.com', '280-774-5140', 'Chemistry', 'Year 2');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Brittany', 'Coleman', 'brittany.coleman6@example.com', '001-609-448-6469x21439', 'Engineering', 'Year 2');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Sarah', 'Brewer', 'sarah.brewer7@example.com', '+1-959-622-1612x31328', 'Chemistry', 'Year 2');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Jonathan', 'Thompson', 'jonathan.thompson8@example.com', '248-407-4273', 'Engineering', 'Year 3');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Laurie', 'Phillips', 'laurie.phillips9@example.com', '7693061742', 'Physics', 'Year 3');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Brenda', 'Drake', 'brenda.drake10@example.com', '996.250.2400x62290', 'Biology', 'Year 2');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Patrick', 'Richardson', 'patrick.richardson11@example.com', '873-513-4524', 'Economics', 'Year 2');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Stephanie', 'Sanchez', 'stephanie.sanchez12@example.com', '+1-429-536-0869x3743', 'Biology', 'Year 1');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Nathan', 'Hamilton', 'nathan.hamilton13@example.com', '215.526.3917x42148', 'Computer Science', 'Year 2');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Linda', 'Merritt', 'linda.merritt14@example.com', '+1-252-606-4539x52787', 'Engineering', 'Year 4');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Mark', 'Hill', 'mark.hill15@example.com', '773-393-7958x942', 'Computer Science', 'Year 3');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Stacey', 'Carpenter', 'stacey.carpenter16@example.com', '(500)267-3968', 'Physics', 'Year 4');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Chelsea', 'Holmes', 'chelsea.holmes17@example.com', '+1-356-688-9176x933', 'Biology', 'Year 1');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Anthony', 'King', 'anthony.king18@example.com', '266-497-0129x233', 'Chemistry', 'Year 1');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Alexander', 'Pearson', 'alexander.pearson19@example.com', '804-333-2495', 'Chemistry', 'Year 1');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Michelle', 'Wells', 'michelle.wells20@example.com', '6424378092', 'Chemistry', 'Year 2');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Margaret', 'Miller', 'margaret.miller21@example.com', '001-829-459-2391x241', 'Mathematics', 'Year 3');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Stephen', 'Le', 'stephen.le22@example.com', '(598)985-6593', 'Chemistry', 'Year 1');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Edward', 'Brown', 'edward.brown23@example.com', '(791)941-2996x44642', 'Engineering', 'Year 1');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Robert', 'Brown', 'robert.brown24@example.com', '(805)328-8562', 'Economics', 'Year 4');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Michael', 'Gregory', 'michael.gregory25@example.com', '2568340726', 'Biology', 'Year 4');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Heather', 'Bell', 'heather.bell26@example.com', '(747)890-8501', 'Engineering', 'Year 1');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Jennifer', 'Thomas', 'jennifer.thomas27@example.com', '001-682-416-1552x264', 'Computer Science', 'Year 1');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Sarah', 'Hart', 'sarah.hart28@example.com', '(751)319-6381x448', 'Biology', 'Year 3');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Sherry', 'Terrell', 'sherry.terrell29@example.com', '684-975-5516x7591', 'Mathematics', 'Year 4');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Shawn', 'Donovan', 'shawn.donovan30@example.com', '(720)684-6801x703', 'Mathematics', 'Year 2');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Sherri', 'Grant', 'sherri.grant31@example.com', '750.290.9047', 'Biology', 'Year 1');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Thomas', 'Crosby', 'thomas.crosby32@example.com', '(408)822-7089x90032', 'Computer Science', 'Year 4');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Holly', 'Fisher', 'holly.fisher33@example.com', '001-745-727-2241x80336', 'Chemistry', 'Year 1');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Tina', 'Rodriguez', 'tina.rodriguez34@example.com', '001-304-936-0796', 'Physics', 'Year 4');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Andrea', 'Kelly', 'andrea.kelly35@example.com', '(657)675-0655x55169', 'Biology', 'Year 3');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Kelsey', 'Harmon', 'kelsey.harmon36@example.com', '367.622.8384x98145', 'Chemistry', 'Year 3');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Alyssa', 'Swanson', 'alyssa.swanson37@example.com', '(829)780-8652', 'Biology', 'Year 4');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Michael', 'Campbell', 'michael.campbell38@example.com', '(542)508-6781x029', 'Engineering', 'Year 2');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Damon', 'Simon', 'damon.simon39@example.com', '462-245-7120', 'Biology', 'Year 3');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Shannon', 'Davis', 'shannon.davis40@example.com', '+1-568-665-4441', 'Mathematics', 'Year 4');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Steven', 'Harris', 'steven.harris41@example.com', '559-668-1431', 'Biology', 'Year 3');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Douglas', 'Miller', 'douglas.miller42@example.com', '(502)914-8415', 'Biology', 'Year 4');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Cameron', 'Rose', 'cameron.rose43@example.com', '362.320.5495x7627', 'Mathematics', 'Year 4');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Samuel', 'Swanson', 'samuel.swanson44@example.com', '(709)346-1294x63372', 'Computer Science', 'Year 1');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Joshua', 'Thompson', 'joshua.thompson45@example.com', '(204)865-4707x450', 'Computer Science', 'Year 1');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Dwayne', 'Adams', 'dwayne.adams46@example.com', '(546)718-2437', 'Computer Science', 'Year 3');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Nicole', 'Price', 'nicole.price47@example.com', '972.503.0062x139', 'Mathematics', 'Year 3');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Anthony', 'Mack', 'anthony.mack48@example.com', '(535)459-7158x8895', 'Engineering', 'Year 3');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Donald', 'Brown', 'donald.brown49@example.com', '+1-591-522-2707x0145', 'Economics', 'Year 1');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Amanda', 'Potter', 'amanda.potter50@example.com', '686-832-2497x8634', 'Engineering', 'Year 3');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Patricia', 'Hicks', 'patricia.hicks51@example.com', '(424)802-8897', 'Chemistry', 'Year 2');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Amy', 'Gibbs', 'amy.gibbs52@example.com', '714.879.7818x570', 'Computer Science', 'Year 3');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Bryan', 'James', 'bryan.james53@example.com', '001-252-812-2291x762', 'Engineering', 'Year 2');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Andrew', 'Hurst', 'andrew.hurst54@example.com', '(323)283-4714x9162', 'Engineering', 'Year 1');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Molly', 'Small', 'molly.small55@example.com', '(972)242-6805x827', 'Chemistry', 'Year 1');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Hannah', 'Williamson', 'hannah.williamson56@example.com', '347-348-5820x2340', 'Physics', 'Year 1');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Thomas', 'Rodriguez', 'thomas.rodriguez57@example.com', '(603)222-3747x8960', 'Computer Science', 'Year 2');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Matthew', 'Henderson', 'matthew.henderson58@example.com', '001-493-434-2835x0937', 'Mathematics', 'Year 2');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Sarah', 'Johnson', 'sarah.johnson59@example.com', '(232)885-3506', 'Physics', 'Year 1');
INSERT INTO Students (FirstName, LastName, Email, Phone, Major, Year) VALUES ('Todd', 'Clarke', 'todd.clarke60@example.com', '777-845-8406x07380', 'Mathematics', 'Year 2');

-- Insert Instructors
INSERT INTO Instructors (FirstName, LastName, Email, Department) VALUES ('Kevin', 'Armstrong', 'kevin.armstrong1@university.edu', 'Computer Science');
INSERT INTO Instructors (FirstName, LastName, Email, Department) VALUES ('Jeffrey', 'Bird', 'jeffrey.bird2@university.edu', 'Mathematics'); 
INSERT INTO Instructors (FirstName, LastName, Email, Department) VALUES ('Brianna', 'Cordova', 'brianna.cordova3@university.edu', 'Biology');
INSERT INTO Instructors (FirstName, LastName, Email, Department) VALUES ('Taylor', 'Thomas', 'taylor.thomas4@university.edu', 'Engineering');
INSERT INTO Instructors (FirstName, LastName, Email, Department) VALUES ('Blake', 'Cobb', 'blake.cobb5@university.edu', 'Computer Science');
INSERT INTO Instructors (FirstName, LastName, Email, Department) VALUES ('Lindsey', 'Boyd', 'lindsey.boyd6@university.edu', 'Engineering'); 
INSERT INTO Instructors (FirstName, LastName, Email, Department) VALUES ('Thomas', 'Green', 'thomas.green7@university.edu', 'Physics');
INSERT INTO Instructors (FirstName, LastName, Email, Department) VALUES ('Sandra', 'Richardson', 'sandra.richardson8@university.edu', 'Physics');
INSERT INTO Instructors (FirstName, LastName, Email, Department) VALUES ('Dennis', 'Francis', 'dennis.francis9@university.edu', 'Economics');
INSERT INTO Instructors (FirstName, LastName, Email, Department) VALUES ('Steven', 'Schultz', 'steven.schultz10@university.edu', 'Chemistry');
INSERT INTO Instructors (FirstName, LastName, Email, Department) VALUES ('Ashley', 'Thompson', 'ashley.thompson11@university.edu', 'Mathematics');
INSERT INTO Instructors (FirstName, LastName, Email, Department) VALUES ('Deanna', 'Leon', 'deanna.leon12@university.edu', 'Mathematics');  
INSERT INTO Instructors (FirstName, LastName, Email, Department) VALUES ('Robert', 'Hernandez', 'robert.hernandez13@university.edu', 'Physics');
INSERT INTO Instructors (FirstName, LastName, Email, Department) VALUES ('Kyle', 'Davis', 'kyle.davis14@university.edu', 'Physics');        
INSERT INTO Instructors (FirstName, LastName, Email, Department) VALUES ('Mark', 'Schneider', 'mark.schneider15@university.edu', 'Mathematics');

-- Insert Courses
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('CO101', 'Intro to Computer Science 1', 4, 'Computer Science');        
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('CH102', 'Intro to Chemistry 2', 4, 'Chemistry');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('PH103', 'Intro to Physics 3', 3, 'Physics');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('BI104', 'Intro to Biology 4', 4, 'Biology');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('BI105', 'Intro to Biology 5', 3, 'Biology');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('BI106', 'Intro to Biology 6', 3, 'Biology');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('PH107', 'Intro to Physics 7', 4, 'Physics');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('EN108', 'Intro to Engineering 8', 3, 'Engineering');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('PH109', 'Intro to Physics 9', 3, 'Physics');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('CH110', 'Intro to Chemistry 10', 3, 'Chemistry');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('CO111', 'Intro to Computer Science 11', 3, 'Computer Science');       
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('BI112', 'Intro to Biology 12', 4, 'Biology');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('EN113', 'Intro to Engineering 13', 4, 'Engineering');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('BI114', 'Intro to Biology 14', 3, 'Biology');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('MA115', 'Intro to Mathematics 15', 4, 'Mathematics');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('CO116', 'Intro to Computer Science 16', 4, 'Computer Science');       
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('EC117', 'Intro to Economics 17', 4, 'Economics');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('BI118', 'Intro to Biology 18', 3, 'Biology');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('BI119', 'Intro to Biology 19', 3, 'Biology');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('MA120', 'Intro to Mathematics 20', 4, 'Mathematics');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('CO121', 'Intro to Computer Science 21', 4, 'Computer Science');       
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('BI122', 'Intro to Biology 22', 4, 'Biology');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('CO123', 'Intro to Computer Science 23', 3, 'Computer Science');       
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('EC124', 'Intro to Economics 24', 4, 'Economics');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('BI125', 'Intro to Biology 25', 4, 'Biology');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('EC126', 'Intro to Economics 26', 4, 'Economics');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('CH127', 'Intro to Chemistry 27', 4, 'Chemistry');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('CO128', 'Intro to Computer Science 28', 3, 'Computer Science');       
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('EC129', 'Intro to Economics 29', 3, 'Economics');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('CH130', 'Intro to Chemistry 30', 4, 'Chemistry');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('MA131', 'Intro to Mathematics 31', 4, 'Mathematics');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('CH132', 'Intro to Chemistry 32', 3, 'Chemistry');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('CH133', 'Intro to Chemistry 33', 3, 'Chemistry');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('MA134', 'Intro to Mathematics 34', 3, 'Mathematics');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('CO135', 'Intro to Computer Science 35', 3, 'Computer Science');       
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('PH136', 'Intro to Physics 36', 4, 'Physics');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('PH137', 'Intro to Physics 37', 3, 'Physics');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('EC138', 'Intro to Economics 38', 4, 'Economics');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('BI139', 'Intro to Biology 39', 3, 'Biology');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('CO140', 'Intro to Computer Science 40', 4, 'Computer Science');       
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('CO141', 'Intro to Computer Science 41', 3, 'Computer Science');       
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('EN142', 'Intro to Engineering 42', 4, 'Engineering');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('BI143', 'Intro to Biology 43', 3, 'Biology');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('CO144', 'Intro to Computer Science 44', 4, 'Computer Science');       
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('CO145', 'Intro to Computer Science 45', 4, 'Computer Science');       
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('EN146', 'Intro to Engineering 46', 4, 'Engineering');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('MA147', 'Intro to Mathematics 47', 3, 'Mathematics');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('EC148', 'Intro to Economics 48', 3, 'Economics');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('CH149', 'Intro to Chemistry 49', 4, 'Chemistry');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('CH150', 'Intro to Chemistry 50', 4, 'Chemistry');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('EC151', 'Intro to Economics 51', 4, 'Economics');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('CO152', 'Intro to Computer Science 52', 3, 'Computer Science');       
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('EC153', 'Intro to Economics 53', 3, 'Economics');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('EC154', 'Intro to Economics 54', 4, 'Economics');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('PH155', 'Intro to Physics 55', 3, 'Physics');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('EC156', 'Intro to Economics 56', 4, 'Economics');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('PH157', 'Intro to Physics 57', 4, 'Physics');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('CO158', 'Intro to Computer Science 58', 3, 'Computer Science');       
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('EC159', 'Intro to Economics 59', 3, 'Economics');
INSERT INTO Courses (CourseCode, Title, Credits, Department) VALUES ('CH160', 'Intro to Chemistry 60', 3, 'Chemistry');

-- Insert CourseOfferings
INSERT INTO CourseOfferings (CourseID, Semester, InstructorID, Schedule) VALUES (17, 'Fall 2025', 12, 'Mon/Wed 14:00-15:30');
INSERT INTO CourseOfferings (CourseID, Semester, InstructorID, Schedule) VALUES (18, 'Fall 2025', 9, 'Mon/Wed 14:00-15:30');
INSERT INTO CourseOfferings (CourseID, Semester, InstructorID, Schedule) VALUES (40, 'Spring 2026', 4, 'Tue/Thu 13:00-14:30');
INSERT INTO CourseOfferings (CourseID, Semester, InstructorID, Schedule) VALUES (38, 'Summer 2026', 15, 'Mon/Wed/Fri 11:00-12:00');
INSERT INTO CourseOfferings (CourseID, Semester, InstructorID, Schedule) VALUES (41, 'Fall 2025', 15, 'Tue/Thu 13:00-14:30');
INSERT INTO CourseOfferings (CourseID, Semester, InstructorID, Schedule) VALUES (54, 'Summer 2026', 14, 'Tue/Thu 09:00-10:30');
INSERT INTO CourseOfferings (CourseID, Semester, InstructorID, Schedule) VALUES (49, 'Spring 2026', 15, 'Mon/Wed 14:00-15:30');
INSERT INTO CourseOfferings (CourseID, Semester, InstructorID, Schedule) VALUES (8, 'Fall 2025', 3, 'Tue/Thu 13:00-14:30');
INSERT INTO CourseOfferings (CourseID, Semester, InstructorID, Schedule) VALUES (52, 'Summer 2026', 11, 'Mon/Wed/Fri 11:00-12:00');
INSERT INTO CourseOfferings (CourseID, Semester, InstructorID, Schedule) VALUES (53, 'Fall 2025', 9, 'Mon/Wed/Fri 11:00-12:00');
INSERT INTO CourseOfferings (CourseID, Semester, InstructorID, Schedule) VALUES (23, 'Summer 2026', 10, 'Tue/Thu 09:00-10:30');
INSERT INTO CourseOfferings (CourseID, Semester, InstructorID, Schedule) VALUES (26, 'Summer 2026', 6, 'Mon/Wed 14:00-15:30');
INSERT INTO CourseOfferings (CourseID, Semester, InstructorID, Schedule) VALUES (8, 'Fall 2025', 14, 'Mon/Wed 10:00-11:30');
INSERT INTO CourseOfferings (CourseID, Semester, InstructorID, Schedule) VALUES (6, 'Summer 2026', 3, 'Tue/Thu 09:00-10:30');
INSERT INTO CourseOfferings (CourseID, Semester, InstructorID, Schedule) VALUES (26, 'Fall 2025', 6, 'Tue/Thu 13:00-14:30');

-- Insert Grades
INSERT INTO Grades (Grade_ID, Grade, Grade_Score) VALUES (1, 'A', 4.0);
INSERT INTO Grades (Grade_ID, Grade, Grade_Score) VALUES (2, 'A-', 3.7);
INSERT INTO Grades (Grade_ID, Grade, Grade_Score) VALUES (3, 'B+', 3.3);
INSERT INTO Grades (Grade_ID, Grade, Grade_Score) VALUES (4, 'B', 3.0);
INSERT INTO Grades (Grade_ID, Grade, Grade_Score) VALUES (5, 'B-', 2.7);
INSERT INTO Grades (Grade_ID, Grade, Grade_Score) VALUES (6, 'C+', 2.3);
INSERT INTO Grades (Grade_ID, Grade, Grade_Score) VALUES (7, 'C', 2.0);
INSERT INTO Grades (Grade_ID, Grade, Grade_Score) VALUES (8, 'D', 1.0);
INSERT INTO Grades (Grade_ID, Grade, Grade_Score) VALUES (9, 'F', 0.0);

-- Insert Enrollments
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (34, 3, '2025-02-19', 6);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (3, 9, '2024-09-22', 4);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (3, 15, '2025-04-13', 9);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (14, 12, '2024-08-26', NULL);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (11, 2, '2025-01-07', 1);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (11, 8, '2024-11-25', 2);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (37, 9, '2024-08-18', NULL);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (30, 12, '2025-04-14', 1);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (8, 2, '2025-03-30', 9);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (4, 5, '2024-11-12', 8);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (39, 2, '2024-10-28', 5);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (17, 15, '2025-05-12', 3);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (59, 15, '2024-11-20', NULL);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (4, 8, '2024-12-04', NULL);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (45, 15, '2024-08-20', 6);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (17, 5, '2025-05-28', NULL);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (59, 7, '2024-07-30', NULL);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (22, 3, '2024-12-16', 2);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (38, 7, '2025-04-10', 7);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (18, 13, '2025-02-19', 4);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (30, 1, '2025-05-17', NULL);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (16, 14, '2024-09-12', 6);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (40, 6, '2024-09-07', 4);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (8, 8, '2025-01-24', 9);
INSERT INTO Enrollments (StudentID, OfferingID, EnrollmentDate, Grade_ID) VALUES (49, 10, '2024-07-31', 1);

-- Insert Prerequisites
INSERT INTO Prerequisites (CourseID, PrerequisiteID) VALUES (29, 10);
INSERT INTO Prerequisites (CourseID, PrerequisiteID) VALUES (17, 28);
INSERT INTO Prerequisites (CourseID, PrerequisiteID) VALUES (14, 42);
INSERT INTO Prerequisites (CourseID, PrerequisiteID) VALUES (27, 50);
INSERT INTO Prerequisites (CourseID, PrerequisiteID) VALUES (35, 16);

-- Queryng data
--  Retrieve all courses a student is enrolled in for a given semester:
SELECT 
    s.StudentID,
    CONCAT(s.FirstName, ' ', s.LastName) AS StudentName,
    c.CourseCode,
    c.Title,
    co.Semester
FROM Enrollments e
JOIN Students s ON e.StudentID = s.StudentID
JOIN CourseOfferings co ON e.OfferingID = co.OfferingID
JOIN Courses c ON co.CourseID = c.CourseID
WHERE s.StudentID = 30  -- Replace with actual StudentID
  AND co.Semester = 'Fall 2025';
  
  -- 
  SELECT 
    c.Title AS CourseTitle,
    co.Semester,
    g.Grade,
    g.Grade_Score
FROM Enrollments e
JOIN CourseOfferings co ON e.OfferingID = co.OfferingID
JOIN Courses c ON co.CourseID = c.CourseID
LEFT JOIN Grades g ON e.Grade_ID = g.Grade_ID
WHERE e.StudentID = 1234;  -- Replace with actual StudentID

-- Display a student's transcript (course titles, semesters, grades, GPA):
SELECT 
    c.Title AS CourseTitle,
    co.Semester,
    g.Grade,
    g.Grade_Score
FROM Enrollments e
JOIN CourseOfferings co ON e.OfferingID = co.OfferingID
JOIN Courses c ON co.CourseID = c.CourseID
LEFT JOIN Grades g ON e.Grade_ID = g.Grade_ID
WHERE e.StudentID = 34;  -- Replace with actual StudentID

-- Find students who haven't completed prerequisites for a course:
SELECT DISTINCT s.StudentID, CONCAT(s.FirstName, ' ', s.LastName) AS StudentName
FROM Enrollments e
JOIN Students s ON e.StudentID = s.StudentID
JOIN CourseOfferings co ON e.OfferingID = co.OfferingID
JOIN Prerequisites p ON co.CourseID = p.CourseID
LEFT JOIN (
    SELECT e.StudentID, co.CourseID
    FROM Enrollments e
    JOIN CourseOfferings co ON e.OfferingID = co.OfferingID
    JOIN Grades g ON e.Grade_ID = g.Grade_ID
    WHERE g.Grade_Score >= 2.0  -- assume passing grade
) AS Completed ON s.StudentID = Completed.StudentID AND p.PrerequisiteID = Completed.CourseID
WHERE co.CourseID = 3  -- Replace with the target CourseID
  AND Completed.CourseID IS NULL;
  
  -- List all courses offered in a department in a given semester:
  SELECT 
    c.CourseCode,
    c.Title,
    co.Semester,
    i.FirstName AS InstructorFirstName,
    i.LastName AS InstructorLastName
FROM CourseOfferings co
JOIN Courses c ON co.CourseID = c.CourseID
JOIN Instructors i ON co.InstructorID = i.InstructorID
WHERE c.Department = 'Computer Science'
  AND co.Semester = 'Fall 2025';
  
  -- Generate instructor-wise course loads per semester:
  SELECT 
    i.InstructorID,
    CONCAT(i.FirstName, ' ', i.LastName) AS InstructorName,
    co.Semester,
    COUNT(co.OfferingID) AS NumberOfCourses
FROM CourseOfferings co
JOIN Instructors i ON co.InstructorID = i.InstructorID
GROUP BY i.InstructorID, co.Semester
ORDER BY i.InstructorID, co.Semester;

-- Find under-enrolled offerings (less than 5 students):
SELECT 
    co.OfferingID,
    c.CourseCode,
    c.Title,
    co.Semester,
    COUNT(e.EnrollmentID) AS EnrolledStudents
FROM CourseOfferings co
JOIN Courses c ON co.CourseID = c.CourseID
LEFT JOIN Enrollments e ON co.OfferingID = e.OfferingID
GROUP BY co.OfferingID
HAVING COUNT(e.EnrollmentID) < 5;

-- View: Student Enrollments Per Semester
-- Use case: Show which students are enrolled in which courses per semester.
CREATE OR REPLACE VIEW vw_student_courses_per_semester AS
SELECT 
    s.StudentID,
    CONCAT(s.FirstName, ' ', s.LastName) AS StudentName,
    c.CourseCode,
    c.Title AS CourseTitle,
    co.Semester
FROM Enrollments e
JOIN Students s ON e.StudentID = s.StudentID
JOIN CourseOfferings co ON e.OfferingID = co.OfferingID
JOIN Courses c ON co.CourseID = c.CourseID;

-- View: Student Transcript with GPA
-- Use case: Display per-student transcripts and GPA for dashboards.
CREATE OR REPLACE VIEW vw_student_transcripts AS
SELECT 
    e.StudentID,
    CONCAT(s.FirstName, ' ', s.LastName) AS StudentName,
    c.Title AS CourseTitle,
    co.Semester,
    g.Grade,
    g.Grade_Score
FROM Enrollments e
JOIN Students s ON e.StudentID = s.StudentID
JOIN CourseOfferings co ON e.OfferingID = co.OfferingID
JOIN Courses c ON co.CourseID = c.CourseID
LEFT JOIN Grades g ON e.Grade_ID = g.Grade_ID;

CREATE OR REPLACE VIEW vw_student_gpa AS
SELECT 
    e.StudentID,
    CONCAT(s.FirstName, ' ', s.LastName) AS StudentName,
    ROUND(AVG(g.Grade_Score), 2) AS GPA
FROM Enrollments e
JOIN Students s ON e.StudentID = s.StudentID
JOIN Grades g ON e.Grade_ID = g.Grade_ID
GROUP BY e.StudentID;


-- View: Department Courses by Semester
-- Use case: Track course offerings across departments and semesters.
CREATE OR REPLACE VIEW vw_department_courses_semester AS
SELECT 
    c.Department,
    c.CourseCode,
    c.Title,
    co.Semester,
    CONCAT(i.FirstName, ' ', i.LastName) AS Instructor
FROM CourseOfferings co
JOIN Courses c ON co.CourseID = c.CourseID
LEFT JOIN Instructors i ON co.InstructorID = i.InstructorID;

-- View: Instructor Course Load
-- Use case: Show instructor workloads in dashboards, sortable by semester.
CREATE OR REPLACE VIEW vw_instructor_course_load AS
SELECT 
    i.InstructorID,
    CONCAT(i.FirstName, ' ', i.LastName) AS InstructorName,
    co.Semester,
    COUNT(co.OfferingID) AS NumberOfCourses
FROM CourseOfferings co
JOIN Instructors i ON co.InstructorID = i.InstructorID
GROUP BY i.InstructorID, co.Semester;

-- View: Under-Enrolled Courses
-- Use case: Flag low enrollment courses for review.
CREATE OR REPLACE VIEW vw_under_enrolled_offerings AS
SELECT 
    co.OfferingID,
    c.CourseCode,
    c.Title,
    co.Semester,
    COUNT(e.EnrollmentID) AS EnrolledStudents
FROM CourseOfferings co
JOIN Courses c ON co.CourseID = c.CourseID
LEFT JOIN Enrollments e ON co.OfferingID = e.OfferingID
GROUP BY co.OfferingID
HAVING COUNT(e.EnrollmentID) < 5;






