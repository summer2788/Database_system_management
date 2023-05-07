--Please make the table creation AND partition creations, 
--Do Partition the Orders table using orderdate with the following constraints in sql from HW2.sql database:
--   1. Orders between: 20060703 00:00:00.000 and 20070205 00:00:00.000
--   2. Orders between: 20070205 00:00:00.000 and 20070819 00:00:00.000
--   3. Orders between: 20070819 00:00:00.000 and 20080123 00:00:00.000
--   4. Orders between: 20080123 00:00:00.000 and 20080507 00:00:00.000
-- Name your partitions the following: orders_1, orders_2, orders_3, orders_4

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
) PARTITION BY RANGE (orderdate);

CREATE TABLE orders_1 
PARTITION OF orders
FOR VALUES FROM ('2006-07-03 00:00:00.000') TO ('2007-02-05 00:00:00.000');

CREATE TABLE orders_2
PARTITION OF orders
FOR VALUES FROM ('2007-02-05 00:00:00.000') TO ('2007-08-19 00:00:00.000');

CREATE TABLE orders_3
PARTITION OF orders
FOR VALUES FROM ('2007-08-19 00:00:00.000') TO ('2008-01-23 00:00:00.000');

CREATE TABLE orders_4
PARTITION OF orders
FOR VALUES FROM ('2008-01-23 00:00:00.000') TO ('2008-05-07 00:00:00.000');





