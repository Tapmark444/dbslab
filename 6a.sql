-- Drop in dependency order
DROP TABLE IF EXISTS DEPENDENT;
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
);

-- 2. DEPARTMENT
CREATE TABLE DEPARTMENT (
    Dname        VARCHAR(20) NOT NULL,
    Dnumber      INT         PRIMARY KEY,
    MgrSSN       CHAR(9),
    MgrStartDate DATE,
    FOREIGN KEY (MgrSSN) REFERENCES EMPLOYEE(SSN)
);

-- 3. DEPENDENT
CREATE TABLE DEPENDENT (
    Dname VARCHAR(20) NOT NULL,
    ESSN  CHAR(9),
    PRIMARY KEY (Dname, ESSN),
    FOREIGN KEY (ESSN) REFERENCES EMPLOYEE(SSN)
);

-- =========================
-- DATA
-- =========================

-- Employees
INSERT INTO EMPLOYEE (Fname, Lname, SSN, Addrs, Sex, Salary, SuperSSN, Dno) VALUES
('Arun',  'Kumar',  '100000001', 'Bangalore', 'M', 60000.00, NULL,        3),
('Sneha', 'Rao',    '100000002', 'Mysore',    'F', 55000.00, '100000001', 3),
('John',  'Doe',    '100000003', 'Delhi',     'M', 70000.00, NULL,        2),
('Meera', 'Singh',  '100000004', 'Mumbai',    'F', 45000.00, '100000003', 2),
('Vijay', 'Patil',  '100000005', 'Pune',      'M', 80000.00, NULL,        1);

-- Departments
INSERT INTO DEPARTMENT (Dname, Dnumber, MgrSSN, MgrStartDate) VALUES
('HR',        1, '100000005', '2020-01-01'),
('Finance',   2, '100000003', '2020-02-01'),
('Tech',      3, '100000001', '2020-03-01'),
('Sales',     4, NULL,        '2020-04-01'),
('Research',  5, NULL,        '2020-05-01');

-- Dependents
INSERT INTO DEPENDENT (Dname, ESSN) VALUES
('ArunJr',   '100000001'),
('SnehaKid', '100000002'),
('JohnWife', '100000003'),
('MeeraMom', '100000004'),
('VijaySon', '100000005');

-- =========================
-- QUERIES FOR 6(a)
-- =========================

-- i) For each department, department name and average salary of all employees in that department
SELECT D.Dname,
       AVG(E.Salary) AS AvgSalary
FROM DEPARTMENT D
JOIN EMPLOYEE E ON D.Dnumber = E.Dno
GROUP BY D.Dnumber, D.Dname;

-- ii) Names of managers who have at least one dependent
SELECT DISTINCT E.Fname, E.Lname
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.SSN = D.MgrSSN
WHERE EXISTS (
    SELECT 1
    FROM DEPENDENT Dep
    WHERE Dep.ESSN = E.SSN
);

-- iii) Details of all departments having 'tech' as substring
SELECT *
FROM DEPARTMENT
WHERE Dname LIKE '%tech%';
