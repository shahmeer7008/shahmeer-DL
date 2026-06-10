try:
    with open ("read.txt","r") as file:
        for f in file:
            print(f.strip())
except FileNotFoundError as e:
            print(e)