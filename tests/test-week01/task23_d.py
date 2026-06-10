import time

def timer(func):
    def wrapper(*args,**kwargs):
        start_time = time.time()
        result = func(*args, **kwargs)
        end_time = time.time()
        print(f"Execution time: {end_time - start_time:.2f} seconds")
        return result
    return wrapper


@timer
def sum():

    for i in range(1,1000000):
        i+=1
    return i

sum()