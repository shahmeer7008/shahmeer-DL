SELECT 
    sale_id,
    sales_amount,
    (SELECT AVG(sales_amount) FROM sales) AS avg_sales
FROM sales;