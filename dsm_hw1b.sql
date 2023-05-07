SELECT n as name, 
       MIN(d) AS first_purchase, 
       MAX(d) AS last_purchase, 
       MAX(d)- MIN(d) AS active_time
FROM purchases 
GROUP BY name 
ORDER BY active_time DESC, last_purchase DESC, name DESC;