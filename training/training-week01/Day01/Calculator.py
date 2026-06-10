def Calculator(num1, num2, op):
    match op:
        case "+":
            return num1 + num2
        case "-":
            return num1 - num2
        case "*":
            return num1 * num2
        case "/":
            try:
                return num1 / num2
            except ZeroDivisionError:
                print("Division by zero")
                return float('inf')
        case _:
            return "Wrong operator"


while True:

    
    while True:
        try:
            num1 = int(input("Enter num 1: "))
            break
        except ValueError:
            print("Error: Enter a valid number for num 1")

    while True:
        try:
            num2 = int(input("Enter num 2: "))
            break
        except ValueError:
            print("Error: Enter a valid number for num 2")

    op = input("Enter Operator (+ - * /): ")

    while op not in ["+", "-", "*", "/"]:
        op = input("Enter Correct Operator (+ - * /): ")

    print("Result:", Calculator(num1, num2, op))

    choice = input("Do you want to continue? (y/n): ")

    if choice.lower() != "y":
        print("Exiting calculator...")
        break