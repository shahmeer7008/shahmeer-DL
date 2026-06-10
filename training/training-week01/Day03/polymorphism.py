class Animal:
    def speak(self):
        raise NotImplementedError("Subclasses must implement this method")
class Dog(Animal):
    def speak(self):  # I have overrided the speak method of parent class   
        return "Woof!"
class Cat(Animal):
    def speak(self):
        return "Meow!"


animal=Cat()
print(animal.speak())
animal=Dog()
print(animal.speak())


