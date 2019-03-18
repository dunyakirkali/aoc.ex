with open('input.txt') as f:
    components = [(int(x), int(y)) for x, y in [line.strip().split('/') for line in f]]

def build(path, components, pins):
    strongest_bridge = path
    longest_bridge = path
    for c in components:
        if pins in c:
            (strong_bridge, long_bridge) = build(path + [c],
                                                 [co for co in components if c != co],
                                                 c[0] if c[1] == pins else c[1])
            if sum(map(sum, strong_bridge)) > sum(map(sum, strongest_bridge)):
                strongest_bridge = strong_bridge
            if len(long_bridge) > len(longest_bridge):
                longest_bridge = long_bridge
            elif len(long_bridge) == len(longest_bridge):
                if sum(map(sum, long_bridge)) > sum(map(sum, longest_bridge)):
                    longest_bridge = long_bridge
    return (strongest_bridge, longest_bridge)

strongest_bridge, longest_bridge = build([], components, 0)
print "The strongest bridge has strength %d" % sum(map(sum, strongest_bridge))
print "The longest bridge has strength %d" % sum(map(sum, longest_bridge))
