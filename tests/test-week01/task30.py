import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

np.random.seed(42) 


sales_data = np.random.randint(50, 201, size=(4, 8))

total_per_product = np.sum(sales_data, axis=1)
avg_per_week = np.mean(sales_data, axis=0)
best_product_idx = np.argmax(total_per_product)
products = ['Product A', 'Product B', 'Product C', 'Product D']

print(f"Total sales per product: {total_per_product}")
print(f"Average weekly sales per week: {np.round(avg_per_week, 2)}")
print(f"Product with the highest total sales: {products[best_product_idx]} (Index {best_product_idx})\n")

df = pd.DataFrame(
    sales_data, 
    index=products, 
    columns=[f"Week{i}" for i in range(1, 9)]
)

df['Total'] = df.sum(axis=1)
filtered_df = df[df['Total'] > 900]

print("--- Filtered Pandas DataFrame (Total > 900) ---")
print(filtered_df, "\n")

df.to_csv('sales_report.csv')
print("DataFrame successfully exported to 'sales_report.csv'\n")


fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))

weeks = [f"W{i}" for i in range(1, 9)]
for product in products:
    ax1.plot(weeks, df.loc[product, 'Week1':'Week8'], marker='o', label=product)

ax1.set_title('Weekly Sales per Product')
ax1.set_xlabel('Week')
ax1.set_ylabel('Sales ($)')
ax1.grid(True, linestyle='--', alpha=0.7)
ax1.legend()

ax2.bar(products, df['Total'], color=['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728'])
ax2.set_title('Total Sales by Product')
ax2.set_xlabel('Product')
ax2.set_ylabel('Total Sales ($)')
ax2.grid(axis='y', linestyle='--', alpha=0.7)

plt.tight_layout()
plt.savefig('sales_chart.png', dpi=300)
print("Chart successfully saved as 'sales_chart.png'")

plt.show()
