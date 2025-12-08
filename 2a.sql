-- Drop in dependency order
DROP TABLE IF EXISTS WORKS_ON;
DROP TABLE IF EXISTS PROJECT;
DROP TABLE IF EXISTS DEPARTMENT;
DROP TABLE IF EXISTS EMPLOYEE;

-- 1. EMPLOYEE first (no FK to DEPARTMENT, only self‑FK on SuperSSN)
CREATE TABLE EMPLOYEE (
    Fname      VARCHAR(20)  NOT NULL,
    Lname      VARCHAR(20)  NOT NULL,
    SSN        CHAR(9)      PRIMARY KEY,
    Addrs      VARCHAR(50),
    Sex        CHAR(1),
    Salary     DECIMAL(10,2),
    SuperSSN   CHAR(9),
    Dno        INT,
    FOREIGN KEY (SuperSSN) REFERENCES EMPLOYEE(SSN)
    -- NOTE: no FOREIGN KEY (Dno ...) here, to avoid creation error
);

-- 2. DEPARTMENT
CREATE TABLE DEPARTMENT (
    Dname        VARCHAR(20) NOT NULL,
    Dnumber      INT         PRIMARY KEY,
    MgrSSN       CHAR(9),
    MgrStartDate DATE
);

-- 3. PROJECT
CREATE TABLE PROJECT (
    Pno   INT         PRIMARY KEY,
    Pname VARCHAR(30) NOT NULL,
    Dnum  INT,
    FOREIGN KEY (Dnum) REFERENCES DEPARTMENT(Dnumber)
);

-- 4. WORKS_ON
CREATE TABLE WORKS_ON (
    ESSN  CHAR(9),
    Pno   INT,
    Hours DECIMAL(4,1),
    PRIMARY KEY (ESSN, Pno),
    FOREIGN KEY (ESSN) REFERENCES EMPLOYEE(SSN),
    FOREIGN KEY (Pno)  REFERENCES PROJECT(Pno)
);

-- =========================
-- DATA
-- =========================

-- Employees
INSERT INTO EMPLOYEE (Fname, Lname, SSN, Addrs, Sex, Salary, SuperSSN, Dno) VALUES
('Arun',  'Kumar',  '100000001', 'Bangalore', 'M', 60000.00, NULL,        5),
('Sneha', 'Rao',    '100000002', 'Mysore',    'F', 55000.00, '100000001', 5),
('John',  'Doe',    '100000003', 'Delhi',     'M', 45000.00, '100000001', 3),
('Meera', 'Singh',  '100000004', 'Mumbai',    'F', 70000.00, NULL,        2),
('Vijay', 'Patil',  '100000005', 'Pune',      'M', 30000.00, '100000004', 1);

-- Departments
INSERT INTO DEPARTMENT (Dname, Dnumber, MgrSSN, MgrStartDate) VALUES
('HR',        1, '100000005', '2020-01-01'),
('Finance',   2, '100000004', '2020-02-01'),
('IT',        3, '100000003', '2020-03-01'),
('Sales',     4, '100000002', '2020-04-01'),
('Research',  5, '100000001', '2020-05-01');

-- Projects
INSERT INTO PROJECT (Pno, Pname, Dnum) VALUES
(1, 'Payroll System',  2),
(2, 'Website Revamp',  3),
(3, 'Market Survey',   4),
(4, 'AI Research',     5),
(5, 'Recruitment App', 1);

-- WORKS_ON
INSERT INTO WORKS_ON (ESSN, Pno, Hours) VALUES
('100000001', 1, 10.0),
('100000001', 4, 15.5),
('100000002', 3, 20.0),
('100000003', 2, 12.0),
('100000004', 1, 18.0),
('100000004', 2, 10.0),
('100000005', 3, 8.0),
('100000005', 5, 12.5);

-- =========================
-- QUERIES FOR 2(a)
-- =========================

-- i) Employees whose salary is greater than salary of all employees in dept 5
SELECT E.Fname, E.Lname
FROM EMPLOYEE E
WHERE E.Salary > ALL (
    SELECT E2.Salary
    FROM EMPLOYEE E2
    WHERE E2.Dno = 5
);

-- ii) SSNs of employees who work on project numbers 1, 2, or 3
SELECT DISTINCT W.ESSN
FROM WORKS_ON W
WHERE W.Pno IN (1, 2, 3);

-- iii) Total hours put in by all employees on every project
SELECT P.Pno,
       P.Pname,
       SUM(W.Hours) AS TotalHours
FROM PROJECT P
JOIN WORKS_ON W ON P.Pno = W.Pno
GROUP BY P.Pno, P.Pname;
