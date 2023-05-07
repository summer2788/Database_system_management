--Develop Procedures that support the following integrity constraints using the HW4.sql:
-- Add a new column 'shipped_before_required' to Orders table (using ALTER command) of boolean type. Create a procedure that sets 'shippedBeforeRequired' to true if shippeddate is smaller than requireddate and false if vice-versa (remember NULLs)
-- Name the procedure: hw4d_set_shipped()


ALTER TABLE orders
ADD COLUMN shippedbeforerequired BOOLEAN;


CREATE PROCEDURE hw4d_set_shipped()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE orders
    SET shippedbeforerequired = CASE WHEN shippeddate <= requireddate THEN TRUE ELSE FALSE END;
END;
$$;
