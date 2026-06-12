SELECT * from sales
where region_and_sales_rep IN ('North-Bob','South-Bob')
and customer_type='Returning'
and quantity_sold>18 
and discount>0.2
