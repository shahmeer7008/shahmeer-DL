from collections import Counter
from array import array
from collections import namedtuple

def topThree(l):
    scores = sorted(list(set(l)), reverse=True)
    return scores[:3]

l= [75,65,34,43,34,23]



Student = namedtuple('Student', ['name', 'age', 'grade'])

student1 = Student("Alice", 20, "A")
student2 = Student("Bob", 22, "B")
print(f"Student 1: Name={student1.name}, Age={student1.age}, Grade={student1.grade}")
print(f"Student 2: Name={student2.name}, Age={student2.age}, Grade={student2.grade}")


try:
    student1.age = 21
except AttributeError as e:
    print(f"Immutability Error: {e}")



list1 = ["apple", "banana", "cherry", "date"]
list2 = ["banana", "date", "elderberry", "fig"]

set1 = set(list1)
set2 = set(list2)

both = set1.intersection(set2)
print(f"In both: {both}")


only_first = set1.difference(set2)
print(f"Only in first: {only_first}")

combined = set1.union(set2)
print(f"All unique combined: {combined}")



def word_frequency(text):

    words = text.lower().split()
    counts = Counter(words)
    sorted_by_freq = sorted(counts.items(), key=lambda item: item[1], reverse=True)
    return dict(sorted_by_freq)

text_sample = "apple banana apple cherry banana apple"
print(word_frequency(text_sample))


triples = [(a, b, c) for a in range(1, 21) for b in range(a, 21) 
                     for c in range(b, 21) if a**2 + b**2 == c**2]

print(triples)



numbers = array('i', [10, 20, 30, 40, 50])

numbers.append(60)
print("Array elements:", end=" ")
for num in numbers:
    print(num, end=" ")
