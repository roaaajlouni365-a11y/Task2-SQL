USE TechWorldHRDB;

CREATE TABLE dbo.AccessCards (
    CardID INT PRIMARY KEY,
    CardNumber VARCHAR(50) NOT NULL UNIQUE,
    EmployeeID INT UNIQUE,
    FOREIGN KEY (EmployeeID) REFERENCES dbo.Employees(EmployeeID)
);
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL
);
CREATE TABLE EmployeeProjects (
    EmployeeID INT,
    ProjectID INT,
    AssignedDate DATE,
    PRIMARY KEY (EmployeeID, ProjectID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);
INSERT INTO AccessCards (CardID, CardNumber, EmployeeID)
VALUES
    (101, 'CARD101', 1),
    (102, 'CARD102', 2),
    (103, 'CARD103', 3);
INSERT INTO Projects (ProjectID, ProjectName)
VALUES
    (1, 'AI & Security Training'),
    (2, 'Cloud Migration');
 INSERT INTO EmployeeProjects (EmployeeID, ProjectID, AssignedDate)
VALUES
    (1, 1, '2026-10-01'),
    (1, 2, '2026-10-02'),
    (2, 1, '2026-10-03'),
    (3, 2, '2026-10-04');
SELECT
    Employees.FullName,
    Employees.Salary,
    Departments.DepartmentName
FROM Employees
INNER JOIN Departments
    ON Employees.DepartmentID = Departments.DepartmentID;
SELECT
    Departments.DepartmentName,
    Employees.FullName
FROM Departments
LEFT JOIN Employees
    ON Departments.DepartmentID = Employees.DepartmentID;
SELECT
    Employees.FullName,
    AccessCards.CardNumber
FROM Employees
INNER JOIN AccessCards
    ON Employees.EmployeeID = AccessCards.EmployeeID;
  SELECT
    Employees.FullName,
    Projects.ProjectName,
    EmployeeProjects.AssignedDate
FROM Employees
INNER JOIN EmployeeProjects
    ON Employees.EmployeeID = EmployeeProjects.EmployeeID
INNER JOIN Projects
    ON EmployeeProjects.ProjectID = Projects.ProjectID;
SELECT
    DepartmentID,
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
GO
CREATE VIEW dbo.vw_EmployeeDetails AS
SELECT
    Employees.EmployeeID,
    Employees.FullName,
    Employees.Email,
    Departments.DepartmentName
FROM Employees
INNER JOIN Departments
    ON Employees.DepartmentID = Departments.DepartmentID;
GO
SELECT *
FROM dbo.vw_EmployeeDetails;
CREATE PROCEDURE dbo.sp_GetEmployeesByDepartment
    @DeptID INT
AS
BEGIN
    SELECT *
    FROM dbo.Employees
    WHERE DepartmentID = @DeptID;
END;

CREATE TABLE dbo.EmployeeAudit (
    AuditID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT,
    [Action] VARCHAR(50),
    ActionDate DATETIME
);
SELECT *
FROM dbo.vw_EmployeeDetails;
GO

CREATE PROCEDURE dbo.sp_GetEmployeesByDepartment
    @DeptID INT
AS
BEGIN
    SELECT *
    FROM dbo.Employees
    WHERE DepartmentID = @DeptID;
END;
GO

CREATE TABLE dbo.EmployeeAudit (
    AuditID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT,
    [Action] VARCHAR(50),
    ActionDate DATETIME
);
GO

CREATE TRIGGER dbo.trg_EmployeeDelete
ON dbo.Employees
AFTER DELETE
AS
BEGIN
    INSERT INTO dbo.EmployeeAudit (EmployeeID, [Action], ActionDate)
    SELECT EmployeeID, 'DELETE', GETDATE()
    FROM deleted;
END;
GO