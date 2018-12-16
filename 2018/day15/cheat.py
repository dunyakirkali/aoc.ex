from collections import deque

def bfs(start, unocc, goals):
	# traverse the cave in distance/reading order
	visited = [[0]*len(unocc[0]) for _t in range(len(unocc))]
	check = deque([[start]])
	visited[start[0]][start[1]] = 1
	while len(check):
		path = check.popleft()
		c = path[-1] # most recent coord
		y,x = c
		if c in goals:
			return path # next move is the first step in this path
		for dy,dx in [(-1,0),(0,-1),(0,1),(1,0)]: # Reading order!
			if unocc[y+dy][x+dx] and not visited[y+dy][x+dx]:
				visited[y+dy][x+dx]=1
				check.append(path+[[y+dy,x+dx]])
	return [] # no path to any goals

lines = data.strip().split('\n')
orig_units = [[y,x,lines[y][x]=="G",200]
				for y in range(len(lines))
				for x in range(len(lines[0]))
				if lines[y][x] in "EG"]
ELF = 0

ATP = 3 # elf attack power (part 2)
while ATP<300:
	units = [u[:] for u in orig_units]
	unoccupied = [[c=="." for c in line] for line in lines]
	elfDead = 0
	rounds = 0
	while 1: # rounds
		units.sort() # reading order
		combat_continues = 0
		for unit in units[:]: # this unit's turn
			if unit not in units:
				continue # was killed
			y,x,team,hp = unit
			adj = [[y+dy,x+dx,1-team] for dy,dx in [(-1,0),(0,-1),(0,1),(1,0)]]
			attack_list = [u for u in units if u[:3] in adj]
			if attack_list: # adjacent: go to Attack stage
				combat_continues = 1
			else:
				reachable = []
				combat_continues = 0
				for target in units:
					if target[2]!=unit[2]:
						combat_continues = 1
						ty,tx,tteam,thp = target
						target_adj = [[ty+dy,tx+dx]
							for dy,dx in [(-1,0),(1,0),(0,1),(0,-1)]]
						reachable.extend([p for p in target_adj
							if unoccupied[p[0]][p[1]]])
				if combat_continues==0:
					break
				if not reachable: # no open squares in range of target: end turn
					continue
				mv = bfs([y,x], unoccupied, reachable)
				if not mv: # cannot find path (blocked): end turn
					continue
				mv = mv[1] # first step on path
				unoccupied[y][x] = 1 # leave current space
				y,x = unit[:2] = mv
				unoccupied[y][x] = 0 # occupy new space
				adj = [[y+dy,x+dx,1-team] for dy,dx in [(-1,0),(0,-1),(0,1),(1,0)]]
				attack_list = [u for u in units if u[:3] in adj]
			if attack_list: # Attack stage
				hit = min(attack_list, key=lambda u:(u[3],u[0],u[1]))
				if team==ELF:
					hit[3]-=ATP
				else:
					hit[3]-=3
				if hit[3]<=0: # unit died
					if hit[2]==ELF:
						#print "Lost an elf with ATP",ATP
						elfDead = 1
						if ATP!=3:
							break
					units.remove(hit)
					unoccupied[hit[0]][hit[1]] = 1 #passable
		if elfDead and ATP!=3:
			break
		if combat_continues==0:
			break
		rounds+=1
	if ATP==3:
		print "part 1:", rounds * sum(u[3] for u in units)
	if not elfDead:
		break
	ATP+=1

print "part 2:", rounds * sum(u[3] for u in units)