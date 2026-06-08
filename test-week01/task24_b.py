


def countdownGenerator(n):
    for i in range(n, 0, -1):
        yield i
    yield "Blast off!"

for number in countdownGenerator(5):
    print(number)

