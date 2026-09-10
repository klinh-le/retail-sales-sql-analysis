SELECT order_id, discount, profit, category, sub_category
FROM orders
WHERE profit < 0
ORDER BY discount desc;