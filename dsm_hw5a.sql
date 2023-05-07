--using the HW5.sql:
--Create the following roles: db_user, db_manager, db_owner. Grant all privileges to owner, read privileges to user, and insert privileges to manager.

CREATE ROLE db_user;
CREATE ROLE db_manager;
CREATE ROLE db_owner;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO db_owner;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO db_user;
GRANT INSERT ON ALL TABLES IN SCHEMA public TO db_manager;
