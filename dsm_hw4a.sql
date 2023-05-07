-- Develop Procedures that support the following integrity constraints using the HW4.sql:
-- NOTE: Procedures need to be called explicitly after they are created so to test your procedures, remember to call them.
-- Create a procedure that adds X amount of days (given by the user)  to the "requireddate" value based on custid or orderid. If orderid given is NULL, the procedure runs based on custid. The procedure takes three arguments.
-- Name the procedure: hw4a_add_days()

CREATE PROCEDURE hw4a_add_days
(
    
    p_orderid IN INTEGER,
    p_custid IN INTEGER,
    p_days IN INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
BEGIN
    IF p_orderid IS NULL THEN
        UPDATE orders
        SET requireddate = requireddate + (p_days * INTERVAL '1 DAY')
        WHERE custid = p_custid;
    ELSE
        UPDATE orders
        SET requireddate = requireddate + (p_days * INTERVAL '1 DAY')
        WHERE orderid = p_orderid;
    END IF;
END;
$$;


-- CALL hw4a_add_days(NULL::INTEGER, 25::INTEGER, 6::INTEGER);






