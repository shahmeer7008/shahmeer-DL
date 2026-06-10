def trackyields(func):
    def wrapper(*args,**kwargs):
        print(f"\nGenerator {func.__name__} started.")
        values = list(func(*args, **kwargs))

        for i, value in enumerate(values):
            if i < len(values) - 1:
                print(f"{value}->", end="")
            else:
                print(value, end="")


            yield value
        print(f"\nGenerator {func.__name__} finished.")
    return wrapper



#Count Down Generator
@trackyields
def CountDownGenerator_func(n):
    print("Countdown from : ",n)
    for i in range(n,0,-1):
        yield i

n=5
gen=CountDownGenerator_func(n)
for i in range(n,0,-1):
    next(gen)

#Even Number Generator
@trackyields
def even_filter_func(n):
    print("even numbers up to : ", n)
    for i in range(n+1):
        if i%2==0:
            yield i

even_gen=even_filter_func(10)
for num in even_gen:
     pass


#Fibonacci Generator
@trackyields
def FibonacciGenerator_func(n):
    print("Fibonacci sequence up to : ",n)
    a,b=0,1
    while a<=n:
        yield a
        a,b=b,a+b


fib_gen=FibonacciGenerator_func(20)
for num in fib_gen:
    pass


trackyields(CountDownGenerator_func)
trackyields(even_filter_func)
trackyields(FibonacciGenerator_func)
