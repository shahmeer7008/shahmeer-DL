SELECT SUM(sales_amount),region_and_sales_rep
from sales
group by (region_and_sales_rep)

