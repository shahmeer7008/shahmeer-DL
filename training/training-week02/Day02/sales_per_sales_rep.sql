SELECT SUM(sales_amount) as Total_sales_per_sales_rep
from sales s
JOIN sales_reps sp
ON 
s.sales_rep_id=sp.sales_rep_id
Group by (s.sales_rep_id)