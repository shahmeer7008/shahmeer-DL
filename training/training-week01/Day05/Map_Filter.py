
from functools import reduce
a=[1, 2, 3, 4, 5]

#map function
b=list(map(lambda x: x**2, a))
print("Squares of the list:", b)

#filter function
c=list(filter(lambda x: x%2==0, a))
print("Even numbers in the list:", c)


#reduce function
d=reduce(lambda x,y: x+y, a)
print("Sum of the list:", d)
