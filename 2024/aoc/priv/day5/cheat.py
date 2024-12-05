import os
from pathlib import Path
from collections import defaultdict
from time import perf_counter
timer_script_start=perf_counter()
SCRIPT_PATH=Path(os.path.realpath(__file__))
INPUT_PATH="input.txt"

timer_parse_start=perf_counter()
############################## PARSER ##############################
with open(INPUT_PATH) as file:
    rule_text,update_text = file.read().split("\n\n")
rules = [tuple(map(int,rule.split("|"))) for rule in rule_text.splitlines()]
updates = [list(map(int,line.split(","))) for line in update_text.splitlines()]

prereqs = defaultdict(set)
for a,b in rules:
    prereqs[b].add(a)

timer_parse_end=timer_part1_start=perf_counter()
############################## PART 1 ##############################
def is_correct_order(pages):
    remaining_pages = set(pages)
    added_pages = set()
    for page in pages:
        remaining_pages.remove(page)
        if remaining_pages & prereqs[page]:
            return False
        added_pages.add(page)
    return True

p1 = sum(pages[len(pages)//2] for pages in updates if is_correct_order(pages))

print("Part 1:",p1)
timer_part1_end=timer_part2_start=perf_counter()
############################## PART 2 ##############################
def sort_pages(pages):
    for i,_ in enumerate(pages):
        remaining_pages = set(pages[i:])
        for j,page in enumerate(pages):
            if j<i:continue
            if not prereqs[page] & remaining_pages:
                pages[i],pages[j]=pages[j],pages[i]
                break
        else:
            raise ValueError("idk how to sort this")
    assert is_correct_order(pages)
    return pages
to_fix = [sort_pages(pages) for pages in updates if not is_correct_order(pages)]
p2 = sum(pages[len(pages)//2] for pages in to_fix)

print("Part 2:",p2)
timer_part2_end=timer_script_end=perf_counter()
print(f"""Execution times (sec)
Parse: {timer_parse_end-timer_parse_start:3.3f}
Part1: {timer_part1_end-timer_part1_start:3.3f}
Part2: {timer_part2_end-timer_part2_start:3.3f}
Total: {timer_script_end-timer_script_start:3.3f}""")
