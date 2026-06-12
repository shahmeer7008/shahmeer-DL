WITH recent_sales as (SELECT * from sales s where 
					   sale_date> '2023-09-01')

SELECT product_category,Count(*)
from products p
JOIN recent_sales r
ON 
p.product_id=r.product_id
Group by (p.product_category)