SELECT region_and_sales_rep,Min(sales_amount) as Min_Sales_Per_Region
from sales s
group by (region_and_sales_rep)