SELECT p.product_category,s.quantity_sold from sales s
LEFT JOIN products p ON
p.product_id=s.product_id