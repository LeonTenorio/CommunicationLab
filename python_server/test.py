import requests
import time

url = "http://127.0.0.1:5000"

def request_command(command):
    r = requests.put(url+"/command", {"command": command})
    print(r.status_code)


time.sleep(10)

commands = ['up', 'up', 'down', 'up', 'down']
print('running commands')
for command in commands:
    request_command(command)
    time.sleep(1)
