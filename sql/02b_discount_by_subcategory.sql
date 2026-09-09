SELECT ROUND(AVG(discount) * 100, 2) AS avg_discount, category, sub_category
FROM orders
GROUP BY category, sub_category
ORDER BY avg_discount desc;