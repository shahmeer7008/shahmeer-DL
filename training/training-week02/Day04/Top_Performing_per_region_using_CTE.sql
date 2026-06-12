WITH rep_sales AS (
    SELECT 
        r.region,
        r.sales_rep_name,
        SUM(s.sales_amount) AS total_sales
    FROM sales s
    JOIN sales_reps r ON s.sales_rep_id = r.sales_rep_id
    GROUP BY r.region, r.sales_rep_name
),
ranked AS (
    SELECT *,
           RANK() OVER (
               PARTITION BY region
               ORDER BY total_sales DESC
           ) AS rnk
    FROM rep_sales
)
SELECT *
FROM ranked
WHERE rnk = 1;