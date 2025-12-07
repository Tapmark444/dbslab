-- Drop tables in dependency order
DROP TABLE IF EXISTS BOWLING;
DROP TABLE IF EXISTS BATTING;
DROP TABLE IF EXISTS MATCH;
DROP TABLE IF EXISTS PLAYER;

-- PLAYER table
CREATE TABLE PLAYER (
    PId      INT         PRIMARY KEY,
    Lname    VARCHAR(20) NOT NULL,
    Fname    VARCHAR(20) NOT NULL,
    Country  VARCHAR(20) NOT NULL,
    Yborn    INT,
    Bplace   VARCHAR(30)
);

-- MATCH table
CREATE TABLE MATCH (
    MatchId INT         PRIMARY KEY,
    Team1   VARCHAR(20) NOT NULL,
    Team2   VARCHAR(20) NOT NULL,
    Ground  VARCHAR(40) NOT NULL,
    Date    DATE,
    Winner  VARCHAR(20)
);

-- BATTING table
CREATE TABLE BATTING (
    MatchId INT,
    Pid     INT,
    Nruns   INT,
    Fours   INT,
    Sixes   INT,
    PRIMARY KEY (MatchId, Pid),
    FOREIGN KEY (MatchId) REFERENCES MATCH(MatchId),
    FOREIGN KEY (Pid)     REFERENCES PLAYER(PId)
);

-- BOWLING table
CREATE TABLE BOWLING (
    MatchId  INT,
    Pid      INT,
    Novers   DECIMAL(4,1),
    Maidens  INT,
    Nruns    INT,
    Nwickets INT,
    PRIMARY KEY (MatchId, Pid),
    FOREIGN KEY (MatchId) REFERENCES MATCH(MatchId),
    FOREIGN KEY (Pid)     REFERENCES PLAYER(PId)
);


-- Insert players (including Dhoni)
INSERT INTO PLAYER (PId, Lname, Fname, Country, Yborn, Bplace) VALUES
(1,  'Kohli',   'Virat',    'India',    1988, 'Delhi'),
(2,  'Dhoni',   'MS',       'India',    1981, 'Ranchi'),
(3,  'Smith',   'Steve',    'Australia', 1989, 'Sydney'),
(4,  'Warner',  'David',    'Australia', 1987, 'Sydney'),
(5,  'Rohit',   'Sharma',   'India',    1987, 'Nagpur');

-- Insert matches (Australia as Team1 in some)
INSERT INTO MATCH (MatchId, Team1, Team2, Ground, Date, Winner) VALUES
(2689, 'Australia', 'India',    'MCG',      '2025-01-15', 'Australia'),
(2690, 'India',     'England',  'Wankhede', '2025-02-20', 'India'),
(2691, 'Australia', 'England',  'SCG',      '2025-03-10', 'Australia'),
(2692, 'India',     'Australia','Eden',     '2025-04-05', 'India'),
(2693, 'Australia', 'NZ',       'Adelaide', '2025-05-12', 'Australia');

-- Insert batting (Dhoni bats in matches 2689, 2692)
INSERT INTO BATTING (MatchId, Pid, Nruns, Fours, Sixes) VALUES
(2689, 2, 45, 4, 2),   -- Dhoni
(2689, 1, 82, 8, 3),   -- Kohli
(2690, 1, 67, 6, 1),
(2691, 3, 56, 5, 0),   -- Smith
(2692, 2, 91, 7, 5);   -- Dhoni

-- Insert bowling (sample data)
INSERT INTO BOWLING (MatchId, Pid, Novers, Maidens, Nruns, Nwickets) VALUES
(2689, 1, 8.0, 1, 42, 2),
(2690, 5, 10.0, 2, 55, 3),
(2691, 4, 9.2, 0, 68, 1),
(2692, 3, 7.0, 1, 38, 1),
(2693, 1, 9.0, 0, 50, 2);

SELECT DISTINCT Ground
FROM MATCH
WHERE Team1 = 'Australia'
ORDER BY Ground ASC;

SELECT M.*
FROM MATCH M
WHERE EXISTS (
    SELECT 1 
    FROM BATTING B 
    JOIN PLAYER P ON B.Pid = P.PId 
    WHERE B.MatchId = M.MatchId 
      AND P.Fname = 'MS' AND P.Lname = 'Dhoni'
);

SELECT DISTINCT P.Fname, P.Lname
FROM PLAYER P
JOIN BATTING B ON P.PId = B.Pid
WHERE B.MatchId = 2689;
