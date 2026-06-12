SELECT 
    sale_id,
    sales_amount,
    (SELECT ROUND(AVG(sales_amount),2) FROM sales) AS avg_sales
FROM sales;