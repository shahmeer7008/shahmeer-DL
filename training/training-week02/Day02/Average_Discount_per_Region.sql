SELECT Round(Avg(discount),2) as Average_Discount_per_Region
from sales
group by(region_and_sales_rep)