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

-- ORDER_ITEM table
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

-- Insert customers (some from Bangalore)
INSERT INTO CUSTOMER (cust_num, cname, city) VALUES
(1, 'Arun Traders', 'Bangalore'),
(2, 'Sneha Corp',   'Mysore'),
(3, 'John Enterprises', 'Bangalore'),
(4, 'Meera Supplies', 'Mumbai'),
(5, 'Vijay Retail', 'Bangalore');

-- Insert items (including item 10)
INSERT INTO ITEM (item_num, unit_price) VALUES
(101, 150.00),
(102, 250.00),
(103, 75.50),
(104, 320.00),
(10,  200.00);  -- Item no. 10

-- Insert orders
INSERT INTO ORDER_TABLE (order_num, odate, cust_num, ord_amt) VALUES
(1001, '2025-01-10', 1, 4500.00),  -- Bangalore, 3 items
(1002, '2025-01-12', 2, 3200.00),  -- Mysore, 1 item
(1003, '2025-01-15', 3, 2800.00),  -- Bangalore, 2 items
(1004, '2025-01-18', 4, 5200.00),  -- Mumbai, 4 items
(1005, '2025-01-20', 5, 3800.00);  -- Bangalore, 2 items

-- Insert order items (customer 1 ordered 3+ items, some ordered item 10)
INSERT INTO ORDER_ITEM (order_num, item_num, qty) VALUES
(1001, 101, 20), (1001, 102, 10), (1001, 103, 15),  -- 3 items
(1002, 104, 8),                                      -- 1 item
(1003, 10,  12), (1003, 101, 5),                     -- Item 10
(1004, 102, 15), (1004, 103, 20), (1004, 104, 10), (1004, 10, 8),  -- 4 items, item 10
(1005, 101, 25);                                     -- 1 item, no item 10

-- Insert shipments
INSERT INTO SHIPMENT (order_num, ship_date) VALUES
(1001, '2025-01-12'),
(1002, '2025-01-14'),
(1003, '2025-01-17'),
(1004, '2025-01-20'),
(1005, '2025-01-22');

SELECT C.cname, COUNT(O.order_num) AS NumOrders
FROM CUSTOMER C
JOIN ORDER_TABLE O ON C.cust_num = O.cust_num
WHERE C.city = 'Bangalore'
GROUP BY C.cust_num, C.cname;

SELECT C.cname
FROM CUSTOMER C
JOIN ORDER_TABLE O ON C.cust_num = O.cust_num
JOIN ORDER_ITEM OI ON O.order_num = OI.order_num
GROUP BY C.cust_num, C.cname
HAVING COUNT(DISTINCT OI.item_num) >= 3;

SELECT C.cname
FROM CUSTOMER C
WHERE NOT EXISTS (
    SELECT 1
    FROM ORDER_TABLE O
    JOIN ORDER_ITEM OI ON O.order_num = OI.order_num
    WHERE O.cust_num = C.cust_num AND OI.item_num = 10
);
