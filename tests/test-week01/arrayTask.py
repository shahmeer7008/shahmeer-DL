

arr=[1,3,19,2,89,16,14,21,18,96,31]


max=-1
for  a in arr:
    if a >max:
        max=a

print(max)

def find_repeating(arr):
    repeats = []

    for i in range(len(arr)):
        found = False

        for j in range(i + 1, len(arr)):
            if arr[i] == arr[j]:
                found = True
                break

        if found:
            Added = False

            for k in range(len(repeats)):
                if repeats[k] == arr[i]:
                    Added = True
                    break

            if not Added:
                repeats.append(arr[i])

    return repeats


print(find_repeating(arr))
