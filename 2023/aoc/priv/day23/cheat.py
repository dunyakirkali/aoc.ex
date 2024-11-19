import os
from pathlib import Path
from time import perf_counter
from collections import deque, defaultdict

timer_script_start = perf_counter()
SCRIPT_PATH = Path(os.path.realpath(__file__))
INPUT_PATH = "input.txt"
timer_parse_start = perf_counter()
############################## PARSER ##############################
N, E, W, S = NEWS = -1j, 1, -1, 1j
slope_map = dict(zip("^><v", NEWS))
with open(INPUT_PATH) as file:
    lines = file.read().splitlines()
empty = {
    complex(x, y)
    for y, line in enumerate(lines)
    for x, c in enumerate(line)
    if c == "."
}
slopes = {
    complex(x, y): c
    for y, line in enumerate(lines)
    for x, c in enumerate(line)
    if c in "^><v"
}
(start,) = (complex(x, 0) for x, c in enumerate(lines[0]) if c == ".")
(end,) = (complex(x, len(lines) - 1) for x, c in enumerate(lines[-1]) if c == ".")
timer_parse_end = timer_part1_start = perf_counter()


############################## PART 1 ##############################
class State:
    def __init__(self, head, visited=(), cost=None):
        self.head = head
        self.visited = set(visited)
        self.visited.add(self.head)
        self.cost = cost if cost is not None else len(visited)

    def step(self, d):
        new_pos = self.head + d
        if new_pos in self.visited:
            return
        visited_slopes = set(self.visited)
        while new_pos in slopes:
            visited_slopes.add(new_pos)
            new_pos += slope_map[slopes[new_pos]]
            if new_pos in visited_slopes:
                return
        if new_pos in empty:
            return State(new_pos, visited_slopes)

    def all_steps(self):
        return [p for p in (self.step(d) for d in NEWS) if p is not None]

    def jump(self, new_pos):
        if new_pos in self.visited:
            return
        return State(new_pos, self.visited, self.cost + fork_map[self.head][new_pos])

    def all_jumps(self):
        return [p for p in (self.jump(n) for n in fork_map[self.head]) if p is not None]

    def __repr__(self) -> str:
        return f"State({self.head!r}, {self.visited!r})"


p1 = 0
q = deque([State(start)])
while q:
    s = q.pop()
    if s.head == end:
        if s.cost > p1:
            p1 = s.cost
            print(p1)
    q.extend(s.all_steps())

print("Part 1:", p1)
timer_part1_end = timer_part2_start = perf_counter()
############################## PART 2 ##############################
empty.update(slopes)
slopes.clear()

# hike_lengths = []
# q = deque([State(start)])
# while q:
#     s = q.popleft()
#     if s.head == end:
#         hike_lengths.append(len(s.visited)-1)
#         print(hike_lengths[-1])
#     q.extend(s.all_steps())

# Less naive: map all the single file lines and jump to the other end of them
forks = [p for p in empty if sum([p + d in empty for d in NEWS]) > 2]
forks.append(start)
forks.append(end)
fork_map = defaultdict(dict)
for fork in forks:
    q = deque(State(fork).all_steps())
    while q:
        s = q.popleft()
        if s.head in forks:
            fork_map[fork][s.head] = len(s.visited) - 1
        else:
            q.extend(s.all_steps())
print("Generated fork map")

p2 = 0
q = deque([State(start)])
while q:
    s = q.pop()
    if s.head == end:
        if s.cost > p2:
            p2 = s.cost
            print(p2)
    q.extend(s.all_jumps())

print("Part 2:", p2)
timer_part2_end = timer_script_end = perf_counter()
print(
    f"""Execution times (sec)
Parse: {timer_parse_end-timer_parse_start:3.3f}
Part1: {timer_part1_end-timer_part1_start:3.3f}
Part2: {timer_part2_end-timer_part2_start:3.3f}
Total: {timer_script_end-timer_script_start:3.3f}"""
)
