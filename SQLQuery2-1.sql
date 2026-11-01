USE TechWorldHRDB;
GO

CREATE TABLE AccessCards (
    CardID INT PRIMARY KEY,
    CardNumber VARCHAR(50) NOT NULL UNIQUE,
    EmployeeID INT UNIQUE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL
);

CREATE TABLE EmployeeProjects (
    EmployeeID INT,
    ProjectID INT,
    AssignedDate DATE,

    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),

    PRIMARY KEY (EmployeeID, ProjectID)
);

USE TechWorldHRDB;

INSERT INTO AccessCards (CardID, CardNumber, EmployeeID)
VALUES
(101, '101', 1),
(102, '102', 2),
(103, '103', 3);

INSERT INTO Projects (ProjectID, ProjectName)
VALUES
(1, 'AI & Security Training'),
(2, 'Cloud Migration');

INSERT INTO EmployeeProjects (EmployeeID, ProjectID, AssignedDate)
VALUES
(1, 1, GETDATE()),
(1, 2, GETDATE()),
(2, 1, GETDATE()),
(3, 2, GETDATE());

SELECT Employees.FullName, Employees.Salary, Departments.DepartmentName
FROM Employees
INNER JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID;



SELECT Employees.FullName, Employees.Salary, Departments.DepartmentName
FROM Departments
LEFT JOIN Employees
ON Employees.DepartmentID = Departments.DepartmentID;


SELECT Employees.FullName, AccessCards.CardNumber
FROM Employees
INNER JOIN AccessCards
ON Employees.EmployeeID = AccessCards.EmployeeID;


select Employees.FullName, Projects.ProjectName, EmployeeProjects.AssignedDate
from EmployeeProjects
inner join Projects
on EmployeeProjects.ProjectID = Projects.ProjectID
inner join Employees
on EmployeeProjects.EmployeeID = Employees.EmployeeID



SELECT DepartmentID,
       SUM(Salary) AS TotalSalary,
       COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentID;


SELECT
    DepartmentID,
    AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentID
HAVING AVG(Salary) > 1000.00;


SELECT *
FROM Employees
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employees
);


CREATE VIEW vw_EmployeeDetails AS
SELECT
    Employees.EmployeeID,
    Employees.FullName,
    Employees.Email,
    Departments.DepartmentName
FROM Employees
INNER JOIN Departments
    ON Employees.DepartmentID = Departments.DepartmentID;


EXEC sp_GetEmployeesByDepartment @DeptID = 1;

CREATE TABLE EmployeeAudit (
    AuditID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT,
    Action VARCHAR(50),
    ActionDate DATETIME
);

CREATE TRIGGER trg_EmployeeDelete
ON Employees
AFTER DELETE
AS
BEGIN
    INSERT INTO EmployeeAudit (EmployeeID, Action, ActionDate)
    SELECT EmployeeID, 'DELETE', GETDATE()
    FROM deleted;
END;
