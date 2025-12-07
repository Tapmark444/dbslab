-- Optional: drop in dependency order
DROP TABLE IF EXISTS WORKS_ON;
DROP TABLE IF EXISTS PROJECT;
DROP TABLE IF EXISTS EMPLOYEE;
DROP TABLE IF EXISTS DEPARTMENT;

-- EMPLOYEE table
CREATE TABLE EMPLOYEE (
    Fname      VARCHAR(20)  NOT NULL,
    Lname      VARCHAR(20)  NOT NULL,
    SSN        CHAR(9)      PRIMARY KEY,
    Addrs      VARCHAR(50),
    Sex        CHAR(1),
    Salary     DECIMAL(10,2),
    SuperSSN   CHAR(9),
    Dno        INT,
    FOREIGN KEY (SuperSSN) REFERENCES EMPLOYEE(SSN),
    FOREIGN KEY (Dno)      REFERENCES DEPARTMENT(Dnumber)
);

-- DEPARTMENT table
CREATE TABLE DEPARTMENT (
    Dname        VARCHAR(20) NOT NULL,
    Dnumber      INT         PRIMARY KEY,
    MgrSSN       CHAR(9),
    MgrStartDate DATE,
    FOREIGN KEY (MgrSSN) REFERENCES EMPLOYEE(SSN)
);

-- PROJECT table
CREATE TABLE PROJECT (
    Pno   INT         PRIMARY KEY,
    Pname VARCHAR(30) NOT NULL,
    Dnum  INT,
    FOREIGN KEY (Dnum) REFERENCES DEPARTMENT(Dnumber)
);

-- WORKS_ON table
CREATE TABLE WORKS_ON (
    ESSN  CHAR(9),
    Pno   INT,
    Hours DECIMAL(4,1),
    PRIMARY KEY (ESSN, Pno),
    FOREIGN KEY (ESSN) REFERENCES EMPLOYEE(SSN),
    FOREIGN KEY (Pno)  REFERENCES PROJECT(Pno)
);

-- First insert departments (no FK dependencies yet)
INSERT INTO DEPARTMENT (Dname, Dnumber, MgrSSN, MgrStartDate) VALUES
('HR',        1, NULL,        '2020-01-01'),
('Finance',   2, NULL,        '2020-02-01'),
('IT',        3, NULL,        '2020-03-01'),
('Sales',     4, NULL,        '2020-04-01'),
('Research',  5, NULL,        '2020-05-01');

-- Insert employees (use NULL for SuperSSN initially)
INSERT INTO EMPLOYEE (Fname, Lname, SSN, Addrs, Sex, Salary, SuperSSN, Dno) VALUES
('Arun',  'Kumar',  '100000001', 'Bangalore', 'M', 60000.00, NULL,       5),
('Sneha', 'Rao',    '100000002', 'Mysore',    'F', 55000.00, '100000001', 5),
('John',  'Doe',    '100000003', 'Delhi',     'M', 45000.00, '100000001', 3),
('Meera', 'Singh',  '100000004', 'Mumbai',    'F', 70000.00, NULL,       2),
('Vijay', 'Patil',  '100000005', 'Pune',      'M', 30000.00, '100000004', 1);

-- Optionally update managers in DEPARTMENT
UPDATE DEPARTMENT SET MgrSSN = '100000001' WHERE Dnumber = 5;
UPDATE DEPARTMENT SET MgrSSN = '100000004' WHERE Dnumber = 2;
UPDATE DEPARTMENT SET MgrSSN = '100000003' WHERE Dnumber = 3;
UPDATE DEPARTMENT SET MgrSSN = '100000005' WHERE Dnumber = 1;
UPDATE DEPARTMENT SET MgrSSN = '100000002' WHERE Dnumber = 4;

-- Insert projects
INSERT INTO PROJECT (Pno, Pname, Dnum) VALUES
(1, 'Payroll System',  2),
(2, 'Website Revamp',  3),
(3, 'Market Survey',   4),
(4, 'AI Research',     5),
(5, 'Recruitment App', 1);

-- Insert works_on (ensure projects 1,2,3 are covered)
INSERT INTO WORKS_ON (ESSN, Pno, Hours) VALUES
('100000001', 1, 10.0),
('100000001', 4, 15.5),
('100000002', 3, 20.0),
('100000003', 2, 12.0),
('100000004', 1, 18.0),
('100000004', 2, 10.0),
('100000005', 3, 8.0),
('100000005', 5, 12.5);

SELECT E.Fname, E.Lname
FROM EMPLOYEE E
WHERE E.Salary > ALL (
    SELECT E2.Salary
    FROM EMPLOYEE E2
    WHERE E2.Dno = 5
);

SELECT DISTINCT W.ESSN
FROM WORKS_ON W
WHERE W.Pno IN (1, 2, 3);

SELECT P.Pno,
       P.Pname,
       SUM(W.Hours) AS TotalHours
FROM PROJECT P
JOIN WORKS_ON W ON P.Pno = W.Pno
GROUP BY P.Pno, P.Pname;
