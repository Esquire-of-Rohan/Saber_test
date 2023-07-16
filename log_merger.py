import sys
import subprocess
subprocess.check_call([sys.executable, '-m', 'pip', 'install', 
'ujson'])
import ujson as json
import pandas as pd 
import os
import shutil

a = 0
b = 0
json_list_a = []
json_list_b = []


with open(f'{sys.argv[1]}', 'r') as file_a, open(f'{sys.argv[2]}', 'r') as file_b :
    for line in file_a:
        if a < 1000:
            a+=1
            json_list_a.append(json.loads(line))
        else:
            break
    for line in file_b:
        if b < 1000:
            b+=1
        else:
            break
        json_list_b.append(json.loads(line))
json_list = json_list_a + json_list_b
df = pd.DataFrame.from_dict(json_list).sort_values(by = ['timestamp'])
json_merged = df.to_json(orient = 'records', lines = True)


directory = 'Merged'
parent_dir = f'{sys.argv[3]}'
path = os.path.join(parent_dir + '/' + directory)
if os.path.exists(path):
    shutil.rmtree(path)
    os.mkdir(path)   
else:
    os.mkdir(path)
with open(path + '/' 'log.jsonl', 'w') as f:
    f.write(json_merged)