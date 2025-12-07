-- Drop tables in dependency order
DROP TABLE IF EXISTS PARTICIPATED;
DROP TABLE IF EXISTS ACCIDENT;
DROP TABLE IF EXISTS OWNS;
DROP TABLE IF EXISTS CAR;
DROP TABLE IF EXISTS PERSON;

-- PERSON table
CREATE TABLE PERSON (
    driver_id   INT         PRIMARY KEY,
    name        VARCHAR(40) NOT NULL,
    address     VARCHAR(80)
);

-- CAR table
CREATE TABLE CAR (
    Regno  VARCHAR(10)  PRIMARY KEY,
    model  VARCHAR(30)  NOT NULL,
    year   INT
);

-- ACCIDENT table
CREATE TABLE ACCIDENT (
    report_number INT     PRIMARY KEY,
    acc_date      DATE,
    location      VARCHAR(80)
);

-- OWNS table
CREATE TABLE OWNS (
    driver_id INT,
    Regno     VARCHAR(10),
    PRIMARY KEY (driver_id, Regno),
    FOREIGN KEY (driver_id) REFERENCES PERSON(driver_id),
    FOREIGN KEY (Regno)     REFERENCES CAR(Regno)
);

-- PARTICIPATED table
CREATE TABLE PARTICIPATED (
    driver_id     INT,
    Regno         VARCHAR(10),
    report_number INT,
    damage_amount DECIMAL(10,2),
    PRIMARY KEY (driver_id, Regno, report_number),
    FOREIGN KEY (driver_id)     REFERENCES PERSON(driver_id),
    FOREIGN KEY (Regno)         REFERENCES CAR(Regno),
    FOREIGN KEY (report_number) REFERENCES ACCIDENT(report_number)
);


-- Insert persons (drivers)
INSERT INTO PERSON (driver_id, name, address) VALUES
(1, 'Arun Kumar', 'Bangalore'),
(2, 'Sneha Rao',  'Mysore'),
(3, 'John Doe',   'Delhi'),
(4, 'Meera Singh', 'Mumbai'),
(5, 'Vijay Patil', 'Pune');

-- Insert cars
INSERT INTO CAR (Regno, model, year) VALUES
('KA01AB1234', 'Honda City',  2020),
('KA02CD5678', 'Toyota Innova', 2018),
('DL03EF9012', 'Maruti Swift', 2021),
('MH04GH3456', 'Hyundai Creta', 2019),
('PN05IJ7890', 'Tata Nexon', 2022);

-- Insert accidents
INSERT INTO ACCIDENT (report_number, acc_date, location) VALUES
(1001, '2025-01-15', 'MG Road'),
(1002, '2025-02-20', 'Outer Ring Road'),
(1003, '2025-03-10', 'Jayanagar'),
(1004, '2025-04-05', 'Whitefield'),
(1005, '2025-05-12', 'Electronic City');

-- Insert ownership
INSERT INTO OWNS (driver_id, Regno) VALUES
(1, 'KA01AB1234'),
(1, 'KA02CD5678'),
(2, 'DL03EF9012'),
(3, 'MH04GH3456'),
(4, 'PN05IJ7890');

-- Insert participation in accidents (with damage amounts)
INSERT INTO PARTICIPATED (driver_id, Regno, report_number, damage_amount) VALUES
(1, 'KA01AB1234', 1001, 25000.00),
(1, 'KA02CD5678', 1002, 85000.00),  -- Highest damage
(2, 'DL03EF9012', 1001, 15000.00),
(3, 'MH04GH3456', 1003, 32000.00),
(4, 'PN05IJ7890', 1004, 12000.00);


SELECT DISTINCT Regno
FROM PARTICIPATED;


SELECT P.Regno, C.model
FROM PARTICIPATED P
JOIN CAR C ON P.Regno = C.Regno
WHERE P.damage_amount = (
    SELECT MAX(damage_amount) FROM PARTICIPATED
);

SELECT P.driver_id, P.name, COUNT(O.Regno) AS NumCarsOwned
FROM PERSON P
LEFT JOIN OWNS O ON P.driver_id = O.driver_id
GROUP BY P.driver_id, P.name;
