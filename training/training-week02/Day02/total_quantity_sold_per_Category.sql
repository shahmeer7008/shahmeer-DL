SELECT SUM(s.quantity_sold),p.product_category
from sales s
JOIN products p ON
s.product_id=p.product_id
group by (p.product_category)

