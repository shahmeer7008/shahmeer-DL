

def summarise(*args,**kwargs):

    print(sum(args))
    for key,value in kwargs.items():
        print(f"{key} : {value}")


summarise(1,2,3,4,5,name="Shahmeer",age=20)
