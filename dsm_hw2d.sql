--Please make the table creation AND partition creations in dsm_hw2a.sql database: 
-- Further partition the partition all partitions created in dsm_hw2a.sql) by creating the following partitions:
--   1. Orders shipped to countries starting with the letter A to H 
--   2. Orders shipped to countries starting with the letter I to Q 
--   3. Orders shipped to countries starting with the letter R to Z 
-- Name your partitions the following: 
-- orders_1_A_H, orders_1_I_Q, orders_1_R_Z
-- orders_2_A_H, orders_2_I_Q, orders_2_R_Z
-- orders_3_A_H, orders_3_I_Q, orders_3_R_Z
-- orders_4_A_H, orders_4_I_Q, orders_4_R_Z

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
FOR VALUES FROM ('2006-07-03 00:00:00.000') TO ('2007-02-05 00:00:00.000')
PARTITION BY RANGE (shipcountry);


CREATE TABLE orders_2
PARTITION OF orders
FOR VALUES FROM ('2007-02-05 00:00:00.000') TO ('2007-08-19 00:00:00.000')
PARTITION BY RANGE (shipcountry);

CREATE TABLE orders_3
PARTITION OF orders
FOR VALUES FROM ('2007-08-19 00:00:00.000') TO ('2008-01-23 00:00:00.000')
PARTITION BY RANGE (shipcountry);

CREATE TABLE orders_4
PARTITION OF orders
FOR VALUES FROM ('2008-01-23 00:00:00.000') TO ('2008-05-07 00:00:00.000')
PARTITION BY RANGE (shipcountry);

CREATE TABLE orders_1_A_H
PARTITION OF orders_1
FOR VALUES FROM ('A') TO ('H');

CREATE TABLE orders_1_I_Q
PARTITION OF orders_1
FOR VALUES FROM ('I') TO ('Q');

CREATE TABLE orders_1_R_Z
PARTITION OF orders_1
FOR VALUES FROM ('R') TO ('Z');

CREATE TABLE orders_2_A_H
PARTITION OF orders_2
FOR VALUES FROM ('A') TO ('H');

CREATE TABLE orders_2_I_Q
PARTITION OF orders_2
FOR VALUES FROM ('I') TO ('Q');

CREATE TABLE orders_2_R_Z
PARTITION OF orders_2
FOR VALUES FROM ('R') TO ('Z');

CREATE TABLE orders_3_A_H
PARTITION OF orders_3
FOR VALUES FROM ('A') TO ('H');

CREATE TABLE orders_3_I_Q
PARTITION OF orders_3
FOR VALUES FROM ('I') TO ('Q');

CREATE TABLE orders_3_R_Z
PARTITION OF orders_3
FOR VALUES FROM ('R') TO ('Z');

CREATE TABLE orders_4_A_H
PARTITION OF orders_4
FOR VALUES FROM ('A') TO ('H');

CREATE TABLE orders_4_I_Q
PARTITION OF orders_4
FOR VALUES FROM ('I') TO ('Q');

CREATE TABLE orders_4_R_Z
PARTITION OF orders_4
FOR VALUES FROM ('R') TO ('Z');


