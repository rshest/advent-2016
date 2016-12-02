import sys

STEPS = [[0, -1], [1, 0], [0, 1], [-1, 0]]
DIRS = {"L": -1, "R": 1}

path = ' '.join(sys.stdin.readlines())

x, y = (0, 0)
dir = 0
intersection_dist = None
visited = set()

for step in path.split(','):
    step = step.strip()
    turn = step[0]
    dist = int(step[1:])
    dir = (dir + DIRS[turn])%len(STEPS)
    dx, dy = STEPS[dir]
    for i in range(dist):
        x += dx
        y += dy
        if intersection_dist == None and (x, y) in visited:
            intersection_dist = abs(x) + abs(y)
        visited.add((x, y))
  
print "1. Total distance: %d"%(abs(x) + abs(y))
print "2. First intersection distance: %d"%intersection_dist

