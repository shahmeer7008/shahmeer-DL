from collections import deque, Counter
import heapq

task_queue = deque()
for i in range(1, 6):
    task_queue.append(f"Task-{i}")  

while task_queue:
    current_task = task_queue.popleft()  
    print(f"Processing: {current_task}")

languages = ["Python", "Java", "Python", "C++", "Python", "Java", "Go"]
counts = Counter(languages)
print(f"Top 2 languages: {counts.most_common(2)}")
scores = [45, 92, 67, 88, 55, 76, 91, 33]
print(f"3 highest scores: {heapq.nlargest(3, scores)}")



file_name = 'students.txt'
try:
    with open(file_name, 'w') as f:
        f.write("Alice, 85\nBob, 90\nCharlie, 78\nDavid, 92\nEve, 88\n")
        
   
    with open(file_name, 'r') as f:
        print("\nStudent Records:")
        for line in f:
            print(line.strip())
            
    with open(file_name, 'a') as f:
        f.write("Frank, 95\n")
        
except FileNotFoundError:
    print(f"Error: The file {file_name} was not found.")




def safe_cast(value, target_type):
    try:
        return target_type(value)
    except (ValueError, TypeError):
        return None
print("\nType Casting Tests:")
tests = [
    ("42", int),
    ("3.14", float),
    ("hello", int),
    (0, bool)
]

for val, t_type in tests:
    result = safe_cast(val, t_type)
    print(f"Cast {repr(val)} to {t_type.__name__}: {repr(result)}")

