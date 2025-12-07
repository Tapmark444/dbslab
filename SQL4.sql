-- Optional: drop tables if they exist
DROP TABLE IF EXISTS SHIPMENT;
DROP TABLE IF EXISTS PART;
DROP TABLE IF EXISTS SUPPLIER;

-- SUPPLIER table
CREATE TABLE SUPPLIER (
    Sid     INT         PRIMARY KEY,
    Sname   VARCHAR(40) NOT NULL,
    Address VARCHAR(80)
);

-- PART table
CREATE TABLE PART (
    PID    INT         PRIMARY KEY,
    Pname  VARCHAR(40) NOT NULL,
    Color  VARCHAR(20) NOT NULL
);

-- SHIPMENT table
CREATE TABLE SHIPMENT (
    Sid  INT,
    PID  INT,
    Cost DECIMAL(10,2),
    PRIMARY KEY (Sid, PID),
    FOREIGN KEY (Sid) REFERENCES SUPPLIER(Sid),
    FOREIGN KEY (PID) REFERENCES PART(PID)
);


-- Insert suppliers
INSERT INTO SUPPLIER (Sid, Sname, Address) VALUES
(1, 'S1 Supplies', 'Bangalore'),
(2, 'S2 Traders',  'Mysore'),
(3, 'S3 Corp',     'Chennai'),
(4, 'S4 Metals',   'Hyderabad'),
(5, 'S5 Parts',    'Pune');

-- Insert parts
INSERT INTO PART (PID, Pname, Color) VALUES
(101, 'Bolt',      'red'),
(102, 'Nut',       'green'),
(103, 'Washer',    'blue'),
(104, 'Screw',     'green'),
(105, 'Bracket',   'yellow');

-- Insert shipments (cost is per-part cost or shipment cost)
INSERT INTO SHIPMENT (Sid, PID, Cost) VALUES
(1, 101, 10.50),
(1, 102, 12.00),
(2, 103, 5.75),
(3, 102, 11.25),
(3, 104, 9.50),
(4, 105, 15.00),
(5, 101, 10.00),
(5, 104, 9.00);
-- Supplier 3 (Sid = 3) is the one referred as s3 in part (iii)

SELECT DISTINCT S.Sid
FROM SUPPLIER S
JOIN SHIPMENT H ON S.Sid = H.Sid
JOIN PART     P ON H.PID = P.PID
WHERE P.Color = 'green';

SELECT S.Sname,
       COUNT(DISTINCT H.PID) AS TotalPartsSupplied
FROM SUPPLIER S
LEFT JOIN SHIPMENT H ON S.Sid = H.Sid
GROUP BY S.Sid, S.Sname;

UPDATE PART
SET Color = 'yellow'
WHERE PID IN (
    SELECT H.PID
    FROM SHIPMENT H
    WHERE H.Sid = 3
);
