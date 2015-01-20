import requests, json



url = "http://localhost:8080/receive/engineering"

info = {"user":"Maidi", "options":{}, "convoID":"1234", "message":"Hey"}
info['options'] = {}
info['options']['something'] = '1234'
#first = json.loads(info)

payload = json.dumps(info)
print(info)
requests.post(url, data=payload)