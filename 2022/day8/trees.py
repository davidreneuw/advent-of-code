import numpy as np

data = []
with open('/home/drene/Coding/Advent2022/day8/input8.txt') as f:
    data = f.readlines()
for i, line in enumerate(data):
    data[i] = [*line.strip()]
    for j, n in enumerate(data[i]):
        data[i][j] = {'height': int(n), 'visible': False, 'score': 0}

# Horizontal
for i in range(len(data)):
    minl = 0
    minr = 0
    for j in range(len(data[i])):
        # From left to right
        if data[i][j]['height'] > minl:
            minl = data[i][j]['height']
            data[i][j]['visible'] = True
        # From right to left
        if data[-(i+1)][-(j+1)]['height'] > minr:
            minr = data[-(i+1)][-(j+1)]['height']
            data[-(i+1)][-(j+1)]['visible'] = True

# Vertical
for j in range(len(data[0])):
    minu = 0
    mind = 0
    for i in range(len(data)):
        # From up to down
        if data[i][j]['height'] > minu:
            minu = data[i][j]['height']
            data[i][j]['visible'] = True
        # From down to up
        if data[-(i+1)][-(j+1)]['height'] > mind:
            mind = data[-(i+1)][-(j+1)]['height']
            data[-(i+1)][-(j+1)]['visible'] = True

# Ensure the outer edges are marked as visible
for i in range(len(data)):
    data[i][0]['visible'] = True
    data[i][-1]['visible'] = True

for i in range(len(data[0])):
    data[0][i]['visible'] = True
    data[-1][i]['visible'] = True

# Count total visible
total = 0
for row in data:
    for tree in row:
        if tree['visible']:
            total += 1
print(total)

max = 0
for (j, row) in enumerate(data):
    for (i, tree) in enumerate(data[j]):
        col = [k[i] for k in data]

        # Left score
        l = 0
        for leftindex in range(i):
            l += 1
            if data[j][i-leftindex-1]['height'] >= data[j][i]['height']:
                break

        # Right score
        r = 0
        for rightindex in range(len(row)-i-1):
            r += 1
            if data[j][i+rightindex+1]['height'] >= data[j][i]['height']:
                break

        # Up score
        u = 0
        for upindex in range(j):
            u += 1
            if data[j-upindex-1][i]['height'] >= data[j][i]['height']:
                break

        # Down score
        d = 0
        for downindex in range(len(col)-j-1):
            d += 1
            if data[j+downindex+1][i]['height'] >= data[j][i]['height']:
                break

        tree['score'] = l*r*u*d
        if tree['score'] > max:
            max = tree['score']
print(max)
