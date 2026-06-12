CREATE TEMP TABLE recent_sales AS
SELECT *
FROM sales
WHERE sale_date >= '2023-09-01';

SELECT p.product_category,
       SUM(r.sales_amount) AS revenue
FROM recent_sales r
JOIN products p
ON r.product_id = p.product_id
GROUP BY p.product_category;