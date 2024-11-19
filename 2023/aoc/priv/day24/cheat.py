import re

data = open("input.txt").read().split("\n")[:-1]
print(data)

left = 200000000000000
right = 400000000000000
total = 0

pts = [[int(y) for y in re.findall(r"-?[0-9]+", x)] for x in data]


def check(one, two):
    # b values or positions, v values are velocities
    b1x, b1y, b1z = one[:3]
    b2x, b2y, b2z = two[:3]
    v1x, v1y, v2y = one[3:]
    v2x, v2y, v2z = two[3:]
    # used to prevent unnecessary calculations
    good = True
    if v1x * v2y - v2x * v1y == 0:
        good = False

    if good:
        # find x and y intersecting
        # turn parametric equations x(t) = vx * t + bx, y(t) = vy* t + by into  y = mx + b by solving for m and b
        # then use these equations to calculate the intersection between two such equations,  noting that:
        # m = vy / vx, b = by - vy/vx * bx
        x = -(v1x * v2x * (b1y - b2y) + v1x * v2y * b2x - v2x * v1y * b1x) / (
            v2x * v1y - v1x * v2y
        )
        y = -(v1y * v2y * (b1x - b2x) + v1y * v2x * b2y - v2y * v1x * b1y) / (
            v2y * v1x - v1y * v2x
        )
        if not (left <= x <= right) or not (left <= y <= right):
            # if the intersection is not in range
            good = False
        if good:
            # x = vx * t + b ->  t = (x - b)
            if (
                (v1x != 0 and (x - b1x) / v1x < 0) or (v2x != 0 and (x - b2x) / v2x < 0)
            ) or (
                (v1y != 0 and ((y - b1y) / v1y < 0))
                or (v2y != 0 and (y - b2y) / v2y < 0)
            ):
                good = False
    if good:
        return True
    else:
        return False


total = 0
for i in range(len(pts) - 1):
    for j in range(i + 1, len(pts)):
        if check(pts[i], pts[j]):
            total += 1
print(total)
