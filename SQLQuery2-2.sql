USE CourseHubDB;
GO

CREATE TABLE dbo.Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE dbo.Students (
    StudentID INT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    GPA DECIMAL(3,2),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES dbo.Departments(DepartmentID)
);
GO

CREATE TABLE dbo.StudentProfiles (
    ProfileID INT PRIMARY KEY,
    StudentID INT UNIQUE,
    Address VARCHAR(200),
    EmergencyPhone VARCHAR(20),
    FOREIGN KEY (StudentID) REFERENCES dbo.Students(StudentID)
);
GO

CREATE TABLE dbo.Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    Credits INT,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES dbo.Departments(DepartmentID)
);
GO

CREATE TABLE dbo.StudentCourses (
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE DEFAULT GETDATE(),
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES dbo.Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES dbo.Courses(CourseID)
);
GO

ALTER TABLE dbo.Students
ADD Age INT;
GO

DROP TABLE dbo.TempInstructors;
GO

INSERT INTO dbo.Departments (DepartmentID, DepartmentName)
VALUES (1, 'Computer Science');

INSERT INTO dbo.Departments (DepartmentID, DepartmentName)
VALUES (2, 'Software Engineering');

INSERT INTO dbo.Departments (DepartmentID, DepartmentName)
VALUES (3, 'Business Administration');
GO

INSERT INTO dbo.Students (StudentID, FullName, Email, GPA, DepartmentID, Age)
VALUES (101, 'Ali Smadi', 'ali@coursehub.com', 3.80, 1, 22);

INSERT INTO dbo.Students (StudentID, FullName, Email, GPA, DepartmentID, Age)
VALUES (102, 'Omar Ahmad', 'omar@coursehub.com', 2.90, 1, 21);

INSERT INTO dbo.Students (StudentID, FullName, Email, GPA, DepartmentID, Age)
VALUES (103, 'Laila Hassan', 'laila@coursehub.com', 3.50, 2, 23);

INSERT INTO dbo.Students (StudentID, FullName, Email, GPA, DepartmentID, Age)
VALUES (104, 'Tariq Zaid', 'tariq@coursehub.com', 2.10, 3, 20);
GO

INSERT INTO dbo.StudentProfiles (ProfileID, StudentID, Address, EmergencyPhone)
VALUES (1, 101, 'Amman, Jordan', '0791111111');

INSERT INTO dbo.StudentProfiles (ProfileID, StudentID, Address, EmergencyPhone)
VALUES (2, 102, 'Irbid, Jordan', '0792222222');

INSERT INTO dbo.StudentProfiles (ProfileID, StudentID, Address, EmergencyPhone)
VALUES (3, 103, 'Zarqa, Jordan', '0793333333');
GO

INSERT INTO dbo.Courses (CourseID, CourseName, Credits, DepartmentID)
VALUES (201, 'Database Systems', 3, 1);

INSERT INTO dbo.Courses (CourseID, CourseName, Credits, DepartmentID)
VALUES (202, 'Web Development', 3, 1);

INSERT INTO dbo.Courses (CourseID, CourseName, Credits, DepartmentID)
VALUES (203, 'Software Architecture', 3, 2);
GO

INSERT INTO dbo.StudentCourses (StudentID, CourseID)
VALUES (101, 201);

INSERT INTO dbo.StudentCourses (StudentID, CourseID)
VALUES (101, 202);

INSERT INTO dbo.StudentCourses (StudentID, CourseID)
VALUES (102, 201);

INSERT INTO dbo.StudentCourses (StudentID, CourseID)
VALUES (103, 203);
GO

UPDATE dbo.Students
SET GPA = 2.50
WHERE StudentID = 104;

DELETE FROM dbo.Students
WHERE StudentID = 104;
GO

SELECT
    Students.FullName,
    Students.GPA,
    Departments.DepartmentName
FROM dbo.Students
INNER JOIN dbo.Departments
    ON Students.DepartmentID = Departments.DepartmentID;
GO

SELECT
    Departments.DepartmentName,
    Students.FullName
FROM dbo.Departments
LEFT JOIN dbo.Students
    ON Departments.DepartmentID = Students.DepartmentID;
GO

SELECT
    Students.FullName,
    StudentProfiles.Address,
    StudentProfiles.EmergencyPhone
FROM dbo.Students
INNER JOIN dbo.StudentProfiles
    ON Students.StudentID = StudentProfiles.StudentID;
GO

SELECT
    Students.FullName,
    Courses.CourseName,
    StudentCourses.EnrollmentDate
FROM dbo.Students
INNER JOIN dbo.StudentCourses
    ON Students.StudentID = StudentCourses.StudentID
INNER JOIN dbo.Courses
    ON StudentCourses.CourseID = Courses.CourseID;
GO

SELECT
    COUNT(*) AS TotalStudents,
    AVG(GPA) AS AverageGPA,
    MAX(GPA) AS HighestGPA,
    MIN(GPA) AS LowestGPA
FROM dbo.Students;
GO

SELECT
    Departments.DepartmentID,
    AVG(Students.GPA) AS AverageGPA,
    COUNT(Students.StudentID) AS TotalStudents
FROM dbo.Departments
LEFT JOIN dbo.Students
    ON Departments.DepartmentID = Students.DepartmentID
GROUP BY Departments.DepartmentID;
GO

SELECT
    DepartmentID,
    AVG(GPA) AS AverageGPA
FROM dbo.Students
GROUP BY DepartmentID
HAVING AVG(GPA) > 3.00;
GO

SELECT
    DepartmentID,
    COUNT(*) AS TotalStudents
FROM dbo.Students
WHERE GPA >= 2.50
GROUP BY DepartmentID
HAVING COUNT(*) > 1;
GO

SELECT
    i.name AS ClusteredIndexName,
    c.name AS ClusteredColumn
FROM sys.indexes AS i
INNER JOIN sys.index_columns AS ic
    ON i.object_id = ic.object_id
    AND i.index_id = ic.index_id
INNER JOIN sys.columns AS c
    ON ic.object_id = c.object_id
    AND ic.column_id = c.column_id
WHERE i.object_id = OBJECT_ID('dbo.Students')
    AND i.type_desc = 'CLUSTERED'
    AND ic.key_ordinal = 1;
GO

CREATE NONCLUSTERED INDEX IX_Students_Email
ON dbo.Students(Email);
GO

SELECT *
FROM dbo.Students
WHERE GPA > (
    SELECT AVG(GPA)
    FROM dbo.Students
);
GO

CREATE VIEW dbo.vw_StudentAcademicDetails AS
SELECT
    Students.StudentID,
    Students.FullName,
    Students.GPA,
    Departments.DepartmentName
FROM dbo.Students
INNER JOIN dbo.Departments
    ON Students.DepartmentID = Departments.DepartmentID;
GO

CREATE PROCEDURE dbo.sp_GetStudentsByDepartment
    @DeptID INT
AS
BEGIN
    SELECT *
    FROM dbo.Students
    WHERE DepartmentID = @DeptID;
END;
GO