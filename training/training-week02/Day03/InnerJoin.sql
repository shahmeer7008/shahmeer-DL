SELECT 
    sr.sales_rep_name,
    SUM(s.sales_amount) AS total_sales
FROM sales s
JOIN sales_reps sr
    ON s.sales_rep_id = sr.sales_rep_id
GROUP BY sr.sales_rep_name
HAVING SUM(s.sales_amount) > 50000;