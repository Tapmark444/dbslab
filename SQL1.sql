-- Drop tables if they already exist (optional, for re-runs)
DROP TABLE IF EXISTS Reserves;
DROP TABLE IF EXISTS Boats;
DROP TABLE IF EXISTS Sailors;

-- Create Sailors table
CREATE TABLE Sailors (
    sid    INT PRIMARY KEY,
    sname  VARCHAR(30) NOT NULL,
    rating INT,
    age    DECIMAL(4,1)
);

-- Create Boats table
CREATE TABLE Boats (
    bid    INT PRIMARY KEY,
    bname  VARCHAR(30) NOT NULL,
    color  VARCHAR(20) NOT NULL
);

-- Create Reserves table
CREATE TABLE Reserves (
    sid INT,
    bid INT,
    day DATE,
    PRIMARY KEY (sid, bid, day),
    FOREIGN KEY (sid) REFERENCES Sailors(sid),
    FOREIGN KEY (bid) REFERENCES Boats(bid)
);

-- Insert Sailors
INSERT INTO Sailors (sid, sname, rating, age) VALUES
(1,  'Ravi',     8, 25.0),
(2,  'Anita',    7, 22.5),
(3,  'Suresh',   5, 30.0),
(4,  'Meena',    9, 28.5),
(5,  'Kiran',    6, 19.0);

-- Insert Boats
INSERT INTO Boats (bid, bname, color) VALUES
(101, 'Sea Queen',   'red'),
(102, 'Blue Wave',   'blue'),
(103, 'Green Pearl', 'green'),
(104, 'Sun Rider',   'yellow'),
(105, 'Red Star',    'red');

-- Insert Reserves (at least one sailor does not reserve any boat: here sid=5)
INSERT INTO Reserves (sid, bid, day) VALUES
(1, 101, '2025-12-01'),
(1, 102, '2025-12-02'),
(2, 103, '2025-12-01'),
(3, 101, '2025-12-03'),
(4, 104, '2025-12-04');

SELECT DISTINCT S.sname
FROM Sailors S
JOIN Reserves R ON S.sid = R.sid;

SELECT DISTINCT S.sid
FROM Sailors S
JOIN Reserves R ON S.sid = R.sid
JOIN Boats    B ON R.bid = B.bid
WHERE B.color = 'red' OR B.color = 'green';

SELECT S.sid
FROM Sailors S
WHERE S.sid NOT IN (
    SELECT R.sid
    FROM Reserves R
);
