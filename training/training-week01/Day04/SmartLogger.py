
def logcall(func):
    def wrapper(*args, **kwargs):
        print(f"Calling function: {func.__name__}" f" with arguments: {args} and keyword arguments: {kwargs}")
        return func(*args, **kwargs)
    return wrapper

@logcall
def factorial(n):
    if(n<0):
        raise ValueError("Negative numbers are not allowed.")
    elif n==0 or n==1:
        return 1
    else:
        return n*factorial(n-1)

# @logcall
def func(name):
    print(f"Hello, {name}! This is a function that will be logged.")
func=logcall(func)

func("Hamid")
factorial(5)