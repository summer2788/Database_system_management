--refernce project_db_backup.sql file 
-- Path: project/project_db_backup.sql

-- Create four views to provide for the company superiors and management.
-- The views should contain information that is important for the management of the company
-- Idea of views is to combine data from various tables to provide an easier access to the combined information. 
-- The view does not have to be the final query result (i.e. View is used for easier access and then queried again for more detailed information)
-- Each view should join at least two tables (not including linking tables)

-- View 1:
-- Name: view_employees_salary_benefit
-- Description: This view will provide information about the employees who has a salary benefit skill and order by e_id
-- Columns: e_id, emp_name, email, contract_type, contract_start, contract_end, skill, salary_benefit_value
Create view view_employees_salary_benefit as
select e.e_id, e.emp_name, e.email, e.contract_type, e.contract_start, e.contract_end, s.skill, s.salary_benefit_value
from employee e
join employee_skills es on e.e_id = es.e_id
join skills s on es.s_id = s.s_id
where s.salary_benefit = true
order by e.e_id;

-- View 2:
-- Name: view_employees_has_roject
-- Description: This view will provide information about the employees who has a project and order by e_id
-- Columns: e_id, emp_name, email, contract_type, contract_start, contract_end, project_name, budget, commision_percentage, p_start_date, p_end_date, c_id
Create view view_employees_has_project as
select e.e_id, e.emp_name, e.email, e.contract_type, e.contract_start, e.contract_end, p.project_name, p.budget, p.commission_percentage, p.p_start_date, p.p_end_date, p.c_id
from employee e
join project_role pr on e.e_id = pr.e_id
join project p on pr.p_id = p.p_id
order by e.e_id;


-- View 3:
-- Name: view_employees_department_hid1
-- Description: This view will provide information about the employees who are in headquarter 1's departments(main office) and order by e_id
-- Columns: e_id, emp_name, email, contract_type, contract_start, contract_end, department_name, hq_name
Create view view_employees_department_hid1 as
select e.e_id, e.emp_name, e.email, e.contract_type, e.contract_start, e.contract_end, d.dep_name, h.hq_name
from employee e
join department d on e.d_id = d.d_id
join headquarters h on d.hid = h.h_id
where h.h_id = 1
order by e.e_id;

-- View 4:
-- Name: view_customers_finland
-- Description: This view will provide information about the customers who are from Finland and order by c_id
-- Columns: c_id, c_name, phone, email, street, city, country

Create view view_customers_finland as
select c.c_id, c.c_name, c.phone, c.email, g.street, g.city, g.country
from customer c join geo_location g on c.l_id = g.l_id
where g.country = 'Finland'
order by c.c_id;


-- Create three triggers for the database:
-- One for before inserting a new skill, make sure that the same skill does not already exist
-- One for after inserting a new project,  check the customer country and select three employees from that country to start working with the project (i.e. create new project roles)
-- One for before updating the employee contract type, make sure that the contract start date is also set to the current date and end date is either 2 years after the start date if contract is of Temporary type, NULL otherwise. (Temporary contract in Finnish is "määräaikainen". It's a contract that has an end date specified).

-- Trigger 1:
-- Name: trigger_skill_check
-- Description: This trigger will check if the skill already exists in the database before inserting a new skill

CREATE OR REPLACE FUNCTION trigger_skill_check()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT * FROM skills WHERE skill = NEW.skill) THEN
        RAISE EXCEPTION 'Skill already exists';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_duplicate_skills
BEFORE INSERT ON skills
FOR EACH ROW
EXECUTE FUNCTION trigger_skill_check();

-- Trigger 2:
-- Name: trigger_project_role
-- Description: This trigger will check the customer country and select three employees from that country to start working with the project (i.e. create new project roles)

CREATE OR REPLACE FUNCTION trigger_project_role()
RETURNS TRIGGER AS $$
DECLARE
    c_country varchar(50);
BEGIN
    SELECT l.country INTO c_country FROM customer c JOIN geo_location l ON c.l_id = l.l_id WHERE c.c_id = NEW.c_id;

    INSERT INTO project_role  (e_id, p_id,prole_start_date) 
    SELECT e.e_id, NEW.p_id, NEW.p_start_date FROM employee e JOIN department d ON e.d_id=d.d_id 
    JOIN headquarters h ON d.hid=h.h_id JOIN geo_location gl ON h.l_id=gl.l_id WHERE gl.country = c_country LIMIT 3;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER project_role 
AFTER INSERT ON project
FOR EACH ROW
EXECUTE FUNCTION trigger_project_role();


-- Trigger 3:
-- Name: trigger_contract_type
-- Description: One for before updating the employee contract type, make sure that the contract start date is also set to the current date and end date is either 2 years after the start date if contract is of Temporary type, NULL otherwise.

CREATE OR REPLACE FUNCTION trigger_contract_type()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.contract_type = 'määräaikainen' OR NEW.contract_type = 'Temporary' THEN
        New.contract_type = 'Temporary';
        NEW.contract_start = CURRENT_DATE;
        NEW.contract_end = CURRENT_DATE + INTERVAL '2 years';
    ELSE
        NEW.contract_start = CURRENT_DATE;
        NEW.contract_end = NULL;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER contract_type
BEFORE UPDATE OF contract_type ON employee
FOR EACH ROW
EXECUTE FUNCTION trigger_contract_type();

--Create three procedures for the database:
--1. Procedure that sets all employees salary to the base level based on their job title

-- Procedure 1:
-- Name: procedure_set_salary
-- Description: This procedure will set all employees salary to the base level based on their job title table

CREATE OR REPLACE PROCEDURE procedure_set_salary()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE employee e
    SET salary = jt.base_salary
    FROM job_title jt
    WHERE e.j_id = jt.j_id;
END;
$$;

--2. Procedure that adds 3 months to all temporary contracts (i.e: add 3 months to the contract end date)

-- Procedure 2:
-- Name: procedure_add_months
-- Description: This procedure will add 3 months to all temporary contracts (i.e: add 3 months to the contract end date)

CREATE OR REPLACE PROCEDURE procedure_add_months()
  LANGUAGE plpgsql
   AS $$
   BEGIN
       UPDATE employee e
       SET contract_end = contract_end + INTERVAL '3 months'
       WHERE e.contract_type = 'Temporary';
   END;
   $$;  

--3. Procedure that increases salaries by a percentage based on the given percentage. You can also specify the highest salary to be increased (give limit X and salaries that are below X are increased). 
-- The user can specify the salary limit when calling the procedure. If user doesn't specify one (or gives 0 or null), then the limit is not considered. The percentage can be given in decimals or numbers or what ever you specify, as long as the procedure works.

-- Procedure 3:
-- Name: procedure_increase_salary
-- Description: This procedure will increase salaries by a percentage based on the given percentage. You can also specify the highest salary to be increased (give limit X and salaries that are below X are increased).

CREATE OR REPLACE PROCEDURE procedure_increase_salary(
  IN p_percentage DECIMAL,
  IN p_limit INTEGER DEFAULT NULL
) AS $$
DECLARE
  v_employee_row employee%ROWTYPE;
  v_new_salary DECIMAL;
BEGIN
  FOR v_employee_row IN SELECT * FROM employee WHERE p_limit IS NULL OR salary < p_limit LOOP
    v_new_salary := v_employee_row.salary * (1 + p_percentage/100);
    IF p_limit IS NOT NULL AND v_new_salary > p_limit THEN
      v_new_salary := p_limit;
    END IF;
    UPDATE employee SET salary = v_new_salary WHERE e_id = v_employee_row.e_id;
  END LOOP;
END;
$$ LANGUAGE plpgsql;


--Partition following tables to at least three partitions (excluding default partition):
-- Note! You may have to create partitions based on the primary key unless you come up with another method
-- 1. Employee table by contract type
-- 2. project table by commission_percentage

CREATE TABLE employee_partitions (
    e_id integer NOT NULL,
    emp_name character varying COLLATE pg_catalog."default" DEFAULT 'No Name'::character varying,
    email character varying COLLATE pg_catalog."default",
    contract_type character varying COLLATE pg_catalog."default" NOT NULL,
    contract_start date NOT NULL,
    contract_end date,
    salary integer DEFAULT 0,
    supervisor integer,
    d_id integer,
    j_id integer
) PARTITION BY LIST (contract_type);

CREATE TABLE employee_parttime PARTITION OF employee_partitions FOR VALUES IN ('Part-time');
CREATE TABLE employee_temporary PARTITION OF employee_partitions FOR VALUES IN ('Temporary');
CREATE TABLE employee_fulltime PARTITION OF employee_partitions FOR VALUES IN ('Full-time');

CREATE TABLE project_partitions (
     p_id integer NOT NULL,
    project_name character varying COLLATE pg_catalog."default",
    budget numeric,
    commission_percentage numeric,
    p_start_date date,
    p_end_date date,
    c_id integer
) PARTITION BY RANGE (commission_percentage);

CREATE TABLE project_low PARTITION OF project_partitions FOR VALUES FROM (0) TO (10);
CREATE TABLE project_medium PARTITION OF project_partitions FOR VALUES FROM (10) TO (20);
CREATE TABLE project_high PARTITION OF project_partitions FOR VALUES FROM (20) TO (100);



-- Create access rights:
-- Create three roles - admin, employee, trainee.
-- Give admin all administrative rights (same rights as postgres superuser would have)
-- Give employee rights to read all information but no rights to write
-- Give trainee rights to read ONLY project, customer, geo_location, and project_role tables as well as limited access to employee table (only allow reading employee id, name, email)

CREATE ROLE admin;
CREATE ROLE employee;
CREATE ROLE trainee;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO admin;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO employee;


GRANT SELECT (e_id, emp_name, email) ON TABLE employee TO trainee;
GRANT SELECT ON TABLE project TO trainee;
GRANT SELECT ON TABLE customer TO trainee;
GRANT SELECT ON TABLE geo_location TO trainee;
GRANT SELECT ON TABLE project_role TO trainee;


--Do the following changes to the database:
--Add zip_code column to Geo_location (you don't have to populate it with data)

ALTER TABLE geo_location ADD COLUMN zip_code VARCHAR(5);

--Add a NOT NULL constraint to customer email and project start date

ALTER TABLE customer ALTER COLUMN email SET NOT NULL;
ALTER TABLE project ALTER COLUMN p_start_date SET NOT NULL;

--Add a check constraint to employee salary and make sure it is more than 1000. You may have to update the salary information to be able to add the constraint (unless you have already done so)

ALTER TABLE employee ALTER COLUMN salary SET NOT NULL;
ALTER TABLE employee ADD CONSTRAINT salary_check CHECK (salary > 1000);




