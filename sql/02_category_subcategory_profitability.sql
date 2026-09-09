SELECT SUM(sales) AS total_sale, SUM(profit) AS total_profit, ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin, category, sub_category
FROM orders
GROUP BY category, sub_category
ORDER BY profit_margin;