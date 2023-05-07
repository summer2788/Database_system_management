SELECT p1.n as p1_name, 
       MIN(p1.d) AS p1_first_purchase, 
       MAX(p1.d) AS p1_last_purchase, 
       p2.n as p2_name, 
       MIN(p2.d) AS p2_first_purchase, 
       MAX(p2.d) AS p2_last_purchase
FROM purchases p1
JOIN purchases p2
ON p1.n > p2.n
WHERE p1.n IN (SELECT n FROM purchases GROUP BY n HAVING COUNT(*) > 1)
  AND p2.n IN (SELECT n FROM purchases GROUP BY n HAVING COUNT(*) > 1)
--   AND p1.n <> p2.n
GROUP BY p1.n, p2.n
HAVING MAX(p1.d)> MIN(p2.d) AND MAX(p2.d) > MIN(p1.d)
ORDER BY p1_name ASC, p2_name ASC;












