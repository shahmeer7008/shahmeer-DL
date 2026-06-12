SELECT *
FROM sales s
WHERE sales_amount > (
    SELECT AVG(s2.sales_amount)
    FROM sales s2
    JOIN sales_reps r2
        ON s2.sales_rep_id = r2.sales_rep_id
    WHERE r2.region = (
        SELECT r.region
        FROM sales_reps r
        WHERE r.sales_rep_id = s.sales_rep_id
    )
);