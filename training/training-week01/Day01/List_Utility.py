
def ProcessList(MyList):
    for l in MyList:
        print(l)
    print("\n")
    MyList.sort()
    print(MyList)
    print("\n")
    MyList.append(23)
    print("\n")
    MyList.insert(2,"Apple")
    MyList.remove(24)
    print(MyList)
    print("\n")
    [print(x) for x in MyList]
    print("\n")
    #simple assignment does not make copy.. it changes original list
    mylist=MyList
    mylist.sort(key=str,reverse=True)
    print(mylist)
    print("\n")
    print(MyList)
    #copy function makes a copy of list
    mylist = MyList.copy()
    mylist.sort(key=str,reverse=True)
    print(mylist)
    print("\n")
    print(MyList)
MyList = list(map(int, input("Enter numbers: ").split()))
ProcessList(MyList)

