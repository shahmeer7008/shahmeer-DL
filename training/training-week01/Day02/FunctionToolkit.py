

history = []

def apply_operation(func,*args):
    result=func(*args)
    history.append(result)

def add(a,b):
    return a+b

def multiply(a,b):
    return a*b



def describe(**kwargs):

    description = ""
    for key,value in kwargs.items():

        description+=f"{key}: {value} "
    return description

apply_operation(add, 5, 3)
apply_operation(multiply, 4, 6)
print("History of results:", history)
print(describe(name="Noman", age=30, city="New York"))

