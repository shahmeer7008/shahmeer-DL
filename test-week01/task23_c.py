


arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

squared_arr = list(map(lambda x: x**2, arr))
print(squared_arr)

filtered_arr = list(filter(lambda x: x % 2 == 0, arr))
print(filtered_arr)

reduced_value = sum(arr)
print(reduced_value)

