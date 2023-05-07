--using the HW5.sql:
--Create a function hw5_get_shipping_info(varchar) that returns a table. The table should have the following columns orderid, shipname, shipaddress, shipcity, shipcountry. The function should return orders where the shipname matches the given string.

CREATE OR REPLACE FUNCTION hw5_get_shipping_info(varchar)
RETURNS TABLE (orderid integer, shipname varchar, shipaddress varchar, shipcity varchar, shipcountry varchar)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT orders.orderid, orders.shipname, orders.shipaddress, orders.shipcity, orders.shipcountry
    FROM orders
    WHERE orders.shipname = $1;
END;
$$;


