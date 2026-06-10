
subjects = input("Enter the number of subjects: ")

while subjects.isdigit() == False:
    subjects = input("Please enter a number ")
    if subjects.isdigit() == True:
        break

subjects = int(subjects)

marksList=[]
for i in range(subjects):

    marks=input("Enter the marks for subject " + str(i+1) + ": ")
    while marks.isdigit() == False and marks> 100:
        marks = input("Please enter a number and it should be less than 100 ")
        if marks.isdigit() == True:
            break

    marks = int(marks)
    marksList.append(marks)
ObtMarks = sum(marksList)
totalMarks = subjects * 100
averageMarks = ObtMarks/subjects
percentage = round((ObtMarks/totalMarks)*100, 2)
if percentage >= 90:
    grade = "A+"
elif percentage >= 80:
    grade = "A"
elif percentage >= 70:
    grade = "B"
elif percentage >= 60:
    grade = "C"

else:    grade = "F"

if grade == "F":
    Result= "Fail"
else:
    Result= "Pass"
for subject in marksList:
    print("Subject " + str(marksList.index(subject)+1) + ": " + str(subject))

print("\n")
print("Report Card")
print("------------------------------------------------------")
print("Total Marks: " + str(ObtMarks)+"/" + str(totalMarks))
print("Percentage: " + str(percentage) + "%")
print("Grade: " + grade)
print("Result: " + Result)