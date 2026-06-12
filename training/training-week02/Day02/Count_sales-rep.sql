SELECT region,COUNT(*) 
from sales_reps
where sales_rep_name LIKE '%i%'
group by (region)