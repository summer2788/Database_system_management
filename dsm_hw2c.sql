--Please make the table creation AND partition creations in HW2.sql database: 
-- Partition the Orders table using the empid:
--   1. Orders with an empid of 1, 2 and 3.
--   2. Orders with an empid of 4, 5 and 6
--   3. Orders with an empid of 7, 8 and 9
-- Name your partitions the following: orders_emp_1, orders_emp_2, orders_emp_3

CREATE TABLE Orders
(
  orderid        INT          NOT NULL,
  custid         INT          NULL,
  empid          INT          NOT NULL,
  orderdate      TIMESTAMP     NOT NULL,
  requireddate   TIMESTAMP     NOT NULL,
  shippeddate    TIMESTAMP     NULL,
  shipperid      INT          NOT NULL,
  freight        MONEY        NOT NULL
    CONSTRAINT DFT_Orders_freight DEFAULT(0),
  shipname       VARCHAR(40) NOT NULL,
  shipaddress    VARCHAR(60) NOT NULL,
  shipcity       VARCHAR(15) NOT NULL,
  shipregion     VARCHAR(15) NULL,
  shippostalcode VARCHAR(10) NULL,
  shipcountry    VARCHAR(15) NOT NULL 
) PARTITION BY LIST (empid);

CREATE TABLE orders_emp_1
PARTITION OF orders
FOR VALUES IN (1, 2, 3);

CREATE TABLE orders_emp_2
PARTITION OF orders
FOR VALUES IN (4, 5, 6);

CREATE TABLE orders_emp_3
PARTITION OF orders
FOR VALUES IN (7, 8, 9);

