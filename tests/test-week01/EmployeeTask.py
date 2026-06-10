class CustomDict(dict):
    def concat(self, d):
        result = []
        for v in d.values():
            if isinstance(v, dict):
                result.extend(self.concat(v))
            else:
                result.append(str(v))
        return result

    def __getitem__(self, key):
        value = super().__getitem__(key)

        if isinstance(value, dict):
            return " ".join(self.concat(value))

        return value

emp = CustomDict({
    "name": {
        "fname": "Ali",
        "lname": "Ahmed"
    },
    "address": {
        "city": "Lahore",
        "zip": 1000,
        "country": "Pakistan"
    },
    "hobbies": {
        "sports": "cricket",
        "music": "guitar",
        "reading": "books"
    }
})

print(emp["name"])
print(emp["address"])
print(emp["hobbies"])