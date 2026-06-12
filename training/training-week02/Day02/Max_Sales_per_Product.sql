SELECT MAX(sales_amount) as Max_Sales_per_Product,product_category
from sales s
JOIN products p ON
p.product_id=s.product_id
group by(product_category)

