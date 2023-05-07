-- Develop Procedures that support the following integrity constraints using the HW4.sql:
-- Create a procdeure that rounds the freight costs to nearest 10.
-- Name the procedure: hw4c_round_freight()

CREATE PROCEDURE hw4c_round_freight()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE orders
    SET freight = (round((freight::numeric / 10)::numeric,0) * 10)::money;
END;
$$;

