SELECT *
FROM sales
WHERE sales_rep_id IN (
    SELECT sales_rep_id
    FROM sales_reps
    WHERE region = 'North'
);