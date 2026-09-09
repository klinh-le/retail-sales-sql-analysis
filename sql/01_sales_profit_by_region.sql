-- Business Question 1: What are total sales and profit by region?
SELECT SUM(sales) AS total_sale, SUM(profit) AS total_profit, region
FROM orders
GROUP BY region
ORDER BY SUM(sales) DESC;