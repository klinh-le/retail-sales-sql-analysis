SELECT customer_name, segment, SUM(sales) AS total_sales
FROM orders
GROUP BY customer_name, segment
ORDER BY total_sales desc
LIMIT 10;