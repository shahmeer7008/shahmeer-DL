CREATE TEMP TABLE discounted_sales AS
SELECT *
FROM sales
WHERE discount > 0.20;

SELECT sr.sales_rep_name,
       SUM(d.sales_amount) AS revenue
FROM discounted_sales d
JOIN sales_reps sr
ON d.sales_rep_id = sr.sales_rep_id
GROUP BY sr.sales_rep_name
ORDER BY revenue DESC;