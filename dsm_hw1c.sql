SELECT n as name, d as purchase_date
FROM purchases
WHERE EXTRACT(MONTH FROM d) IN (2,3)
  AND EXTRACT(YEAR FROM d)::int % 4 = 0
ORDER BY name, d;