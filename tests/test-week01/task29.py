import asyncio
import time

async def fetch_user():
    """Simulates fetching user data from an API."""
    await asyncio.sleep(1.5)
    return {"user_id": 42, "name": "Alex"}

async def fetch_orders():
    """Simulates fetching order history from an API."""
    await asyncio.sleep(1.2)
    return {"orders": [101, 102]}

async def fetch_inventory():
    """Simulates fetching inventory status from an API."""
    await asyncio.sleep(1.8)
    return {"inventory": "in_stock"}

async def main():
    start_time = time.perf_counter()
    
    results = await asyncio.gather(
        fetch_user(),
        fetch_orders(),
        fetch_inventory()
    )
    
    end_time = time.perf_counter()
    elapsed = end_time - start_time
    
    print(f"Results: {results}")
    print(f"Total elapsed time: {elapsed:.2f} seconds")


asyncio.run(main())

x = 42
first_id = id(x)
print(f"Initial integer ID: {first_id}")

x += 1  
second_id = id(x)
print(f"New integer ID:     {second_id}")
print(f"Changed?            {first_id != second_id} (New memory location allocated)\n")


my_list = [1, 2, 3]
first_list_id = id(my_list)
print(f"Initial list ID:    {first_list_id}")

my_list.append(4)  
second_list_id = id(my_list)
print(f"New list ID:        {second_list_id}")
print(f"Changed?            {first_list_id != second_list_id} (Same memory location modified)")


# commands
# # 1. Create a project named intern_project with UV
# uv init intern_project
# cd intern_project

# # 2. Add numpy, pandas, and matplotlib dependencies
# uv add numpy pandas matplotlib

# # 3. Run the main script
# uv run hello.py
