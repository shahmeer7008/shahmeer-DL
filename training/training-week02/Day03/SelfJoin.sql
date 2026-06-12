SELECT sp.sales_rep_name as sr1,sr.sales_rep_name as sr2 from sales_reps sp
JOIN sales_reps sr
ON sp.region=sr.region
where sp.sales_rep_id<>sr.sales_rep_id