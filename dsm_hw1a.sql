SELECT t1.n AS name, 
       t1.i AS item_1, 
       t1.d AS purchase_date_1, 
       t2.i AS item_2, 
       t2.d AS purchase_date_2 
FROM purchases t1 
JOIN purchases t2 
ON t1.n = t2.n 
AND
EXTRACT(DAY FROM t1.d) = EXTRACT(DAY FROM t2.d) AND 
                    (DATE_TRUNC('month', t1.d) = DATE_TRUNC('month', t2.d - INTERVAL '1 month') OR 
                     DATE_TRUNC('month', t2.d) = DATE_TRUNC('month', t1.d - INTERVAL '1 month'))
WHERE t1.d < t2.d 
ORDER BY t1.n;