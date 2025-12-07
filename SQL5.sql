-- Optional: drop tables if they exist
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

-- CERTIFIED table
CREATE TABLE CERTIFIED (
    Emp_ID      INT,
    Aircraft_ID INT,
    PRIMARY KEY (Emp_ID, Aircraft_ID),
    FOREIGN KEY (Emp_ID)      REFERENCES EMPLOYEE(Emp_ID),
    FOREIGN KEY (Aircraft_ID) REFERENCES AIRCRAFT(Aircraft_ID)
);

-- Insert aircraft (Boeing aircraft: 101, 103)
INSERT INTO AIRCRAFT (Aircraft_ID, Aircraft_name, Cruising_range) VALUES
(101, 'Boeing 737',   3000),
(102, 'Airbus A320',  3200),
(103, 'Boeing 777',   6000),
(104, 'Embraer 190',  2500),
(105, 'ATR 72',       1800);

-- Insert employees (pilots)
INSERT INTO EMPLOYEE (Emp_ID, Ename, Salary) VALUES
(1, 'Arun Pilot',   45000.00),
(2, 'Meera Pilot',  52000.00),
(3, 'Raj Pilot',    75000.00),
(4, 'Sneha Pilot',  90000.00),
(5, 'Kiran Pilot',  65000.00);

-- Insert certifications
INSERT INTO CERTIFIED (Emp_ID, Aircraft_ID) VALUES
(1, 101),  -- Arun certified on Boeing 737
(2, 101),  -- Meera certified on Boeing 737  
(2, 102),  -- Meera certified on Airbus
(3, 103),  -- Raj certified on Boeing 777
(4, 102),  -- Sneha certified on Airbus (NOT Boeing)
(5, 102);  -- Kiran certified on Airbus (NOT Boeing)

SELECT DISTINCT E.Ename
FROM EMPLOYEE E
JOIN CERTIFIED C ON E.Emp_ID = C.Emp_ID
JOIN AIRCRAFT A ON C.Aircraft_ID = A.Aircraft_ID
WHERE A.Aircraft_name LIKE 'Boeing%';

SELECT Aircraft_ID, Aircraft_name, Cruising_range
FROM AIRCRAFT
ORDER BY Cruising_range ASC;

SELECT DISTINCT E.Ename
FROM EMPLOYEE E
JOIN CERTIFIED C ON E.Emp_ID = C.Emp_ID
JOIN AIRCRAFT A ON C.Aircraft_ID = A.Aircraft_ID
WHERE A.Cruising_range > 3000
  AND E.Emp_ID NOT IN (
      SELECT C2.Emp_ID
      FROM CERTIFIED C2
      JOIN AIRCRAFT A2 ON C2.Aircraft_ID = A2.Aircraft_ID
      WHERE A2.Aircraft_name LIKE 'Boeing%'
  );
