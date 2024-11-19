from time import perf_counter
from collections import defaultdict
import numpy as np


def main(verbose):
    with open("input.txt", encoding="UTF-8") as f:
        lines = [line.strip("\n") for line in f.readlines()]

    connections = defaultdict(lambda: set())
    connectionSet = set()
    for line in lines:
        name, conns = line.split(": ")
        for c in conns.split(" "):
            connections[name].add(c)
            connections[c].add(name)
            connectionSet.add(tuple(sorted([name, c])))

    indexes = {k: i for i, k in enumerate(connections.keys())}

    arrDim = len(connections)
    degree = np.zeros((arrDim, arrDim))
    adj = np.zeros((arrDim, arrDim))

    for k, i in indexes.items():
        degree[i][i] = len(connections[k])

        for n in connections[k]:
            j = indexes[n]
            adj[i][j] = 1

    laplacian = degree - adj
    v = np.linalg.svd(laplacian)[2]
    fiedler = v[-2]
    gSize = len([g for g in fiedler if g > 0])

    part1 = gSize * (arrDim - gSize)

    if verbose:
        print(f"\nPart 1:\nProduct of disconnected group sizes: {part1}")

    return [part1]


main(True)
