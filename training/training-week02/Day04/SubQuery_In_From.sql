SELECT product_category, total_sales
FROM (
    SELECT 
        p.product_category,
        SUM(s.sales_amount) AS total_sales
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    GROUP BY p.product_category
) t;