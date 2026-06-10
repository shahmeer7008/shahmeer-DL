
def flattenGenerator(nestedList):
    for item in nestedList:
        if isinstance(item, list):
            yield from flattenGenerator(item)
        else:
            yield item


nested_list = [1, [2, 3], [4, [5, 6]], 7]
flat_list = list(flattenGenerator(nested_list))
print(flat_list)
