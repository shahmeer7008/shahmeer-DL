SELECT payment_method,SUM(sales_amount) as Total_Revenue_per_method
from sales s
group by (payment_method)