Select n as name, d as purchase_date   
FROM purchases
WHERE EXTRACT(DAY FROM d) IN (22,23,24,25,26,27,28,29,30,31)
  AND EXTRACT(DOW FROM d) = 5
ORDER BY d ASC;