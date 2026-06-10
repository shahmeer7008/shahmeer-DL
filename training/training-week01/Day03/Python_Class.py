class Account:
    def __init__(self, name, balance):
        self.name = name
        self.balance = balance

    def deposit(self, amount):
        self.balance += amount
        print(f"{self.name} has deposited {amount}")

    def withdraw(self, amount):
        if self.balance >= amount:
            self.balance -= amount
            print(f"{self.name} has withdrawn {amount}")
        else:
            print(f"{self.name} has insufficient funds")

    def display_balance(self):
        print(f"{self.name} has a balance of {self.balance}")


account1 = Account("Hamid", 1000)
account1.deposit(500)
account1.withdraw(200)
account1.display_balance()
