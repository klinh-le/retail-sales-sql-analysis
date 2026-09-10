SELECT COUNT(order_id) AS order_count, SUM(sales) AS total_sales, SUM(profit) AS total_profit, ROUND(SUM(profit)/Sum(sales)*100,2) AS margin, state
FROM orders
GROUP BY state
ORDER BY margin;