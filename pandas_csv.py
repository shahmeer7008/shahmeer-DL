import pandas as pd
import os

def read_csv(file_path):
   

    try:
        df = pd.read_csv(file_path)
    except Exception as e:
        print("Error:", e)
        return None

    print("\nDataset:\n", df)
    print("\nFirst 2 Rows:\n", df.head(2))
    print("\nColumns:\n", df.columns)

    if "CGPA" in df.columns:
        print("\nAverage CGPA:", df["CGPA"].mean())

    return df

print(read_csv("students_500.csv"))