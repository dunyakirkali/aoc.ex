from collections import defaultdict

f=open("input.txt",'r')
instr = [line.split() for line in f.read().strip().split("\n")]
f.close()

d1 = defaultdict(int) # registers for the programs
d2 = defaultdict(int)
d2['p'] = 1
ds = [d1,d2]

def get(s):
	if s in "qwertyuiopasdfghjklzxcvbnm":
		return d[s]
	return int(s)

tot = 0

ind = [0,0]         # instruction indices for both programs
snd = [[],[]]       # queues of sent data (snd[0] = data that program 0 has sent)
state = ["ok","ok"] # "ok", "r" for receiving, or "done"
pr = 0     # current program
d = ds[pr] # current program's registers
i = ind[0] # current program's instruction index
while True:
	if instr[i][0]=="snd": # send
		if pr==1: # count how many times program 1 sends
			tot+=1
		snd[pr].append(get(instr[i][1]))
	elif instr[i][0]=="set":
		d[instr[i][1]] = get(instr[i][2])
	elif instr[i][0]=="add":
		d[instr[i][1]] += get(instr[i][2])
	elif instr[i][0]=="mul":
		d[instr[i][1]] *= get(instr[i][2])
	elif instr[i][0]=="mod":
		d[instr[i][1]] %= get(instr[i][2])
	elif instr[i][0]=="rcv":
		if snd[1-pr]: # other program has sent data
			state[pr] = "ok"
			d[instr[i][1]] = snd[1-pr].pop(0) # get data
		else: # wait: switch to other prog
			if state[1-pr]=="done":
				break # will never recv: deadlock
			if len(snd[pr])==0 and state[1-pr]=="r":
				break # this one hasn't sent anything, other is recving: deadlock
			ind[pr] = i   # save instruction index
			state[pr]="r" # save state
			pr = 1 - pr   # change program
			i = ind[pr]-1 # (will be incremented back)
			d = ds[pr]    # change registers
	elif instr[i][0]=="jgz":
		if get(instr[i][1]) > 0:
			i+=get(instr[i][2])-1
	i+=1
	if not 0<=i<len(instr):
		if state[1-pr] == "done":
			break # both done
		state[pr] = "done"
		ind[pr] = i  # swap back since other program's not done
		pr = 1-pr
		i = ind[pr]
		d = ds[pr]

print tot
