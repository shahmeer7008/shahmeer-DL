

name=input("Enter your name: ")
age=int(input("Enter your age: "))
height=float(input("Enter your height in cm: "))

newheight=round(height/100,2)

print(f"Hello {name}, you are {age} years old and your height is {newheight} meters.")

print(type(name))
print(type(age))
print(type(height))


a=24
b=35
sum=a+b
print(f"The sum of {a} and {b} is: {sum}")

if(a>b):
    print(f"{a} is greater than {b}")
else:
    print(f"{b} is greater than {a}")

print(a > b and a > 20)

