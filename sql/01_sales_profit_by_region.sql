SELECT SUM(sales) AS total_sale, SUM(profit) AS total_profit, ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin, region
FROM orders
GROUP BY region
ORDER BY total_profit desc;