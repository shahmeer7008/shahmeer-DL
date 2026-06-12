SELECT 
    sp.region,
    sp.sales_rep_name,
    SUM(s.sales_amount) AS total_sales
FROM sales_reps sp
JOIN sales s 
    ON s.sales_rep_id = sp.sales_rep_id
GROUP BY sp.region, sp.sales_rep_name
HAVING SUM(s.sales_amount) = (
    SELECT MAX(sub.total_sales)
    FROM (
        SELECT 
            sp2.region,
            sp2.sales_rep_name,
            SUM(s2.sales_amount) AS total_sales
        FROM sales_reps sp2
        JOIN sales s2 
            ON s2.sales_rep_id = sp2.sales_rep_id
        WHERE sp2.region = sp.region
        GROUP BY sp2.region, sp2.sales_rep_name
    ) sub
);