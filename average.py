import requests
import json
import time

url = 'http://localhost:9091/metrics/job/mem_avg'
PROMETHEUS = 'http://localhost:9090/api/v1/query'
x = 0
avg = 0
myRequest = []
#holds last 10 values from node_memory_MemFree_bytes
results = []
#loop populates the file, can easily be modified to retrieve a range of historical data
while x < 10:
	myRequest = requests.get(PROMETHEUS, params={'query': 'node_memory_MemFree_bytes'})
	results.append(myRequest.json()['data']['result'][0]['value'][1])
	x+=1
	
for y in results:
	avg = avg + float(y)
	
avg = avg/10
requests.post(url, ("# TYPE avg gauge\navg " + str(avg) + "\n"))
while 1:
	time.sleep(30) #push interval
	avg = 0
	results.pop(0)	#remove oldest entry from list
	temp = requests.get(PROMETHEUS, params={'query': 'node_memory_MemFree_bytes'}) #querying prometheus for new data
	results.append(temp.json()['data']['result'][0]['value'][1]) #storing the value for memory free
	
	#computes average
	for y in results:
		avg = avg + float(y)
	avg = avg/10
	#avg denotes the query name
	requests.post(url, ("# TYPE avg gauge\navg " + str(avg) + "\n")) #pushes average to prometheus gateway
