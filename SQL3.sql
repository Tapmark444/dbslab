-- Optional: drop in dependency order
DROP TABLE IF EXISTS CERTIFIED;
DROP TABLE IF EXISTS AIRCRAFT;
DROP TABLE IF EXISTS EMPLOYEE;

-- AIRCRAFT table
CREATE TABLE AIRCRAFT (
    Aircraft_ID     INT         PRIMARY KEY,
    Aircraft_name   VARCHAR(40) NOT NULL,
    Cruising_range  INT
);

-- EMPLOYEE table
CREATE TABLE EMPLOYEE (
    Emp_ID  INT         PRIMARY KEY,
    Ename   VARCHAR(40) NOT NULL,
    Salary  DECIMAL(10,2)
);

-- CERTIFIED table (which employee is certified on which aircraft)
CREATE TABLE CERTIFIED (
    Emp_ID      INT,
    Aircraft_ID INT,
    PRIMARY KEY (Emp_ID, Aircraft_ID),
    FOREIGN KEY (Emp_ID)      REFERENCES EMPLOYEE(Emp_ID),
    FOREIGN KEY (Aircraft_ID) REFERENCES AIRCRAFT(Aircraft_ID)
);

-- Insert aircraft
INSERT INTO AIRCRAFT (Aircraft_ID, Aircraft_name, Cruising_range) VALUES
(101, 'Boeing 737',   3000),
(102, 'Airbus A320',  3200),
(103, 'Boeing 777',   6000),
(104, 'Embraer 190',  2500),
(105, 'ATR 72',       1800);

-- Insert employees
INSERT INTO EMPLOYEE (Emp_ID, Ename, Salary) VALUES
(1, 'Arun Pilot',   45000.00),
(2, 'Meera Pilot',  52000.00),
(3, 'Raj Pilot',    75000.00),
(4, 'Sneha Pilot',  90000.00),
(5, 'Kiran Staff',  40000.00);

-- Insert certifications
INSERT INTO CERTIFIED (Emp_ID, Aircraft_ID) VALUES
(1, 101),
(2, 101),
(2, 102),
(3, 103),
(4, 103),
(4, 104);
-- Note: Employee 5 is not certified for any aircraft

SELECT Emp_ID
FROM EMPLOYEE
WHERE Salary = (
    SELECT MAX(Salary)
    FROM EMPLOYEE
);

SELECT DISTINCT A.Aircraft_name
FROM AIRCRAFT A
WHERE NOT EXISTS (
    SELECT 1
    FROM CERTIFIED C
    JOIN EMPLOYEE E ON C.Emp_ID = E.Emp_ID
    WHERE C.Aircraft_ID = A.Aircraft_ID
      AND E.Salary <= 50000
);

SELECT E.Emp_ID, E.Ename
FROM EMPLOYEE E
WHERE NOT EXISTS (
    SELECT 1
    FROM CERTIFIED C
    WHERE C.Emp_ID = E.Emp_ID
);
