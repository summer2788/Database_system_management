CREATE OR REPLACE FUNCTION hw5_get_shipping_info(varchar, timestamp, money)
RETURNS TABLE (orderid integer, shipname varchar, shipaddress varchar, shipcity varchar, shipcountry varchar)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT orders.orderid, orders.shipname, orders.shipaddress, orders.shipcity, orders.shipcountry
    FROM orders
    WHERE orders.shipname = $1 AND orders.orderdate <= $2 AND orders.freight::numeric BETWEEN ($3::numeric - 10) AND ($3::numeric + 10);
END;
$$;
