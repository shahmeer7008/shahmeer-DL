from abc import ABC, abstractmethod


class Employee(ABC):
    def __init__(self, name: str, department: str):
        self.name = name
        self.department = department

    @abstractmethod
    def calculate_pay(self):
        pass

    def display_info(self):
        print(f"Name: {self.name} | Department: {self.department}")


class FullTimeEmployee(Employee):
    def __init__(self, name: str, department: str, salary: float):
        super().__init__(name, department)
        self.__salary = None
        self.salary = salary

    @property
    def salary(self):
        return self.__salary

    @salary.setter
    def salary(self, value: float):
        if value < 0:
            raise ValueError("Salary cannot be negative")
        self.__salary = value

    def calculate_pay(self):
        return self.salary


class ContractEmployee(Employee):
    def __init__(self, name: str, department: str, hourly_rate: float, hours_worked: float):
        super().__init__(name, department)
        self.hourly_rate = hourly_rate
        self.hours_worked = hours_worked

    def calculate_pay(self):
        return self.hourly_rate * self.hours_worked


employees = [
        FullTimeEmployee("Alice", "Engineering", 85000),
        ContractEmployee("Bob", "Design", 60, 120),
    ]
for employee in employees:
        employee.display_info()
        print(f"Pay: ${employee.calculate_pay():,.2f}\n")
