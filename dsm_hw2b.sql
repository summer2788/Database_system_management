--Please make the table creation AND partition creations, 
-- Partition the Orders table using the freight (cost)and create the following partitions in sql from HW2.sql database:
--   1. Orders where freight cost is between: 0-250 
--   2. Orders where freight cost is between: 250.01-500
--   3. Orders where freight cost is between: 500.01-750
--   4. Orders where freight cost is between: 750.01-1100
-- Name your partitions the following: orders_freight_1, orders_freight_2, orders_freight_3, orders_freight_4
-- Note 29-03-2023: Money type is treated as text. Typecasting money to a number needs to be immutable making it difficult.
-- In addition, the "FOR VALUES FROM/IN" will automatically do some typecasting in the version CodeGrade uses so you cannot manually implement the typecast. 

-- HINT:  Try putting the literal value in single quotes.
-- ERROR:  specified value cannot be cast to type money for column "freight"
-- LINE 3: FOR VALUES FROM (250.01) TO (500);

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
) PARTITION BY RANGE (freight);

CREATE TABLE orders_freight_1
PARTITION OF orders
FOR VALUES FROM ('0') TO ('250');

CREATE TABLE orders_freight_2
PARTITION OF orders
FOR VALUES FROM ('250.01') TO ('500');

CREATE TABLE orders_freight_3
PARTITION OF orders
FOR VALUES FROM ('500.01') TO ('750');

CREATE TABLE orders_freight_4
PARTITION OF orders
FOR VALUES FROM ('750.01') TO ('1100');


