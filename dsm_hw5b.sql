--using the HW5.sql:
--Create a new role: trainee. Grant All privileges only to columns orderdate and shippeddate to trainee and set the role valid until 30.5.2023.

CREATE ROLE trainee LOGIN PASSWORD 'trainee_password' VALID UNTIL '2023-05-30';

GRANT ALL (orderdate, shippeddate) ON orders TO trainee;

