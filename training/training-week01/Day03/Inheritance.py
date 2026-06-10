class person:
    def __init__(self,name,age):
        self.name=name
        self.age=age
    def display_info(self):
        print(f"Name: {self.name}, Age: {self.age}")
class student(person):
    def __init__(self,name,age,id,CGPA):
        super().__init__(name,age) #I am calling parent class constructor
        self.id=id
        self.CGPA=CGPA
    def display_info(self):        
        super().display_info()  #I am calling parent class function
        print(f"student ID: {self.id}, CGPA: {self.CGPA}\n")
student1=student("Hamid", 20, "S123", 3.5)
student1.display_info()
student2=student("Ali", 22, "S124", 3.8)
student2.display_info()