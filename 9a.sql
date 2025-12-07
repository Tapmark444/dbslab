-- Drop tables in dependency order
DROP TABLE IF EXISTS SHIPMENT;
DROP TABLE IF EXISTS ORDER_ITEM;
DROP TABLE IF EXISTS ORDER;
DROP TABLE IF EXISTS ITEM;
DROP TABLE IF EXISTS CUSTOMER;

-- CUSTOMER table
CREATE TABLE CUSTOMER (
    cust_num  INT         PRIMARY KEY,
    cname     VARCHAR(40) NOT NULL,
    city      VARCHAR(30)
);

-- ITEM table
CREATE TABLE ITEM (
    item_num   INT          PRIMARY KEY,
    unit_price DECIMAL(10,2) NOT NULL
);

-- ORDER table
CREATE TABLE ORDER_TABLE (
    order_num INT         PRIMARY KEY,
    odate     DATE        NOT NULL,
    cust_num  INT,
    ord_amt   DECIMAL(10,2),
    FOREIGN KEY (cust_num) REFERENCES CUSTOMER(cust_num)
);

-- ORDER_ITEM table (junction table)
CREATE TABLE ORDER_ITEM (
    order_num INT,
    item_num  INT,
    qty       INT,
    PRIMARY KEY (order_num, item_num),
    FOREIGN KEY (order_num) REFERENCES ORDER_TABLE(order_num),
    FOREIGN KEY (item_num)  REFERENCES ITEM(item_num)
);

-- SHIPMENT table
CREATE TABLE SHIPMENT (
    order_num INT,
    ship_date DATE,
    PRIMARY KEY (order_num),
    FOREIGN KEY (order_num) REFERENCES ORDER_TABLE(order_num)
);

-- Insert customers
INSERT INTO CUSTOMER (cust_num, cname, city) VALUES
(1, 'Arun Traders', 'Bangalore'),
(2, 'Sneha Corp',   'Mysore'),
(3, 'John Enterprises', 'Delhi'),
(4, 'Meera Supplies', 'Mumbai'),
(5, 'Vijay Retail', 'Pune');

-- Insert items
INSERT INTO ITEM (item_num, unit_price) VALUES
(101, 150.00),
(102, 250.00),
(103, 75.50),
(104, 320.00),
(105, 89.99);

-- Insert orders (customer 1 has 3 orders >2)
INSERT INTO ORDER_TABLE (order_num, odate, cust_num, ord_amt) VALUES
(1001, '2025-01-10', 1, 4500.00),
(1002, '2025-01-12', 2, 3200.00),
(1003, '2025-01-15', 1, 2800.00),
(1004, '2025-01-18', 3, 5200.00),  -- Largest order
(1005, '2025-01-20', 1, 3800.00);   -- Arun's 3rd order

-- Insert order items
INSERT INTO ORDER_ITEM (order_num, item_num, qty) VALUES
(1001, 101, 20),
(1001, 102, 10),
(1002, 103, 30),
(1003, 104, 8),
(1004, 101, 25),
(1005, 105, 40);

-- Insert shipments
INSERT INTO SHIPMENT (order_num, ship_date) VALUES
(1001, '2025-01-12'),
(1002, '2025-01-14'),
(1003, '2025-01-17'),
(1004, '2025-01-20'),
(1005, '2025-01-22');

SELECT C.cname
FROM CUSTOMER C
JOIN ORDER_TABLE O ON C.cust_num = O.cust_num
GROUP BY C.cust_num, C.cname
HAVING COUNT(O.order_num) > 2;

SELECT odate, SUM(ord_amt) AS TotalOrderAmount
FROM ORDER_TABLE
GROUP BY odate
ORDER BY odate;

SELECT C.*
FROM CUSTOMER C
JOIN ORDER_TABLE O ON C.cust_num = O.cust_num
WHERE O.ord_amt = (
    SELECT MAX(ord_amt) FROM ORDER_TABLE
);
