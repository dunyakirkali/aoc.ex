import numpy as np
import parse
from datetime import timedelta
import operator

guard_id = '''[{year:d}-{month:d}-{day:d} {hour:d}:{minute:d}] {word1} {id} {rest}\n'''
guard_other = '''[{year:d}-{month:d}-{day:d} {hour:d}:{minute:d}] {word1} {word2}\n'''

input =  open('input.txt')
input = input.readlines()
id
dictGuard = {}
input.sort()
print(input)
dict_min = {}

for i in range(len(input)):
    r = parse.parse(guard_id, input[i])
    if(r is None):
        r = parse.parse(guard_other, input[i])
    #print(r)
    if(r['word1'] == "Guard"):
       id = r['id']
    if(r['word1'] == "falls"):
        t_start = int(r['minute'])
    if(r['word1'] == "wakes"):
        t_duration = int(r['minute']) - t_start
        #print(t_duration)
        if(id in dictGuard.keys()):
            dictGuard[id] += t_duration
        else:
            dictGuard[id] = t_duration

max_id = max(dictGuard, key=dictGuard.get)
print(max_id)

for i in range(len(input)):
    r = parse.parse(guard_id, input[i])
    if(r is None):
        r = parse.parse(guard_other, input[i])
    if(r['word1'] == "Guard"):
        id = r['id']
        if(id == max_id):
            for k in range(i+1, len(input)):
                r = parse.parse(guard_id, input[k])
                if(r is None):
                    r = parse.parse(guard_other, input[k])
                if(r['word1'] == "Guard"):
                    break
                if(r['word1'] == "falls"):
                    t_start = r['minute']
                if(r['word1'] == "wakes"):
                    t_duration = r['minute'] - t_start
                    for k in range (t_start, r['minute']):
                        min = k
                        if(min in dict_min.keys()):
                            dict_min[min] += 1
                        else:
                            dict_min[min] = 1
max_min = max(dict_min, key=dict_min.get)

print(max_min)
