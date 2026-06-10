


class NegativeNumberError(Exception):
    def __init__(self,message="Negative numbers are not allowed."):
        self.message=message
        super().__init__(self.message)
    

while True:
    try:
        num1=int(input("Enter number 1: "))
        if num1<0:
            raise NegativeNumberError()
        num2=int(input("Enter number 2:"))
        if num2<0:
            raise NegativeNumberError()
        result=round(num1/num2, 2)
        
    except ZeroDivisionError:
        print("Error: Cannot divide by zero. Please try again.")
    except ValueError:
        print("Error: Invalid input. Please enter a valid number.")
    except NegativeNumberError as e:
        print("Error:", e)
    except Exception as e:
        print("An unexpected error occurred:", e)
    else:
        print("Result:", result)
    finally:
        print("Thank you for using the calculator. Want to perform another calculation? (yes/no)")
    
    choice = input().lower()
    if choice != "yes":
            print("Goodbye!")
            break