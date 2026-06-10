import requests

def make_request(url):
    try:
        response = requests.get(url)

        print("Status Code:", response.status_code)

        data = response.json()

        print("\nResponse Data:")
        print(data)

    except Exception as e:
        print("Error:", e)


url = "https://jsonplaceholder.typicode.com/posts"
make_request(url)