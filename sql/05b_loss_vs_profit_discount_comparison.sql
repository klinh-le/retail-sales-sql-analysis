SELECT
    CASE WHEN profit < 0 THEN 'Loss' ELSE 'Profit' END AS order_outcome,
    ROUND(AVG(discount) * 100, 2) AS avg_discount,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_outcome;