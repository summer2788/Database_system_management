-- Develop Procedures that support the following integrity constraints using the HW4.sql:
--  Create a procedure that adds 10 % to the freight money.
-- Name the procedure: hw4b_add_freight()

CREATE PROCEDURE hw4b_add_freight()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE orders
    SET freight = round((freight::numeric * 1.1)::numeric,2)::money;
END;
$$;