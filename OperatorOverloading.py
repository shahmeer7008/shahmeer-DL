#first compile time polymorphism (operator overloading)

import random
class Matrix:
    def __init__(self,rows,cols):
        self.rows=rows
        self.cols=cols
        self.data=[[0 for _ in range(self.cols)] for _ in range(self.rows)]

    def __add__(self,other):
        if(self.rows==other.rows and self.cols==other.cols):
            result=Matrix(self.rows,self.cols)
            for i in range(self.rows):
                for j in range(self.cols):
                    result[i][j]=self[i][j]+other[i][j]
            return result
        else:
            raise ValueError("Matrices must have the same dimensions for addition")

    def __mul__(self,other):
        if(self.cols==other.rows):
            result=Matrix(self.rows,other.cols)
            for i in range(self.rows):
                for j in range(other.cols):
                    result[i][j]=0
                    for k in range(self.cols):
                        result[i][j]+=self[i][k]*other[k][j]
            return result

    def __sub__(self,other):
        if(self.rows==other.rows and self.cols==other.cols):
            result=Matrix(self.rows,self.cols)
            for i in range(self.rows):
                for j in range(self.cols):
                    result[i][j]=self[i][j]-other[i][j]
            return result
        else:
            raise ValueError("Matrices must have the same dimensions for subtraction")

    
    def __getitem__(self, i):
        return self.data[i]

    def __setitem__(self, i, value):
        self.data[i] = value

    
matrix1=Matrix(2,2)
matrix2=Matrix(2,2)

for i in range(2):
    for j in range(2):
        matrix1[i][j]=random.randint(1,10)
        matrix2[i][j]=random.randint(1,10)

print("Matrix 1:")
for i in range(2):
    for j in range(2):
        print(matrix1[i][j],end=" ")
    print()
print("Matrix 2:")
for i in range(2):
    for j in range(2):
        print(matrix2[i][j],end=" ")
    print()

result_add=matrix1+matrix2
print("Result of addition:")

for i in range(2):
    for j in range(2):
        print(result_add[i][j],end=" ")
    print()

result_mul=matrix1*matrix2
print("Result of multiplication:")
for i in range(2):
    for j in range(2):
        print(result_mul[i][j],end=" ")
    print() 

print("Result of subtraction:")
result_sub=matrix1-matrix2
for i in range(2):
    for j in range(2):
        print(result_sub[i][j],end=" ")
    print()

