import numpy as np
import pandas as pd

data = []
with open('/home/drene/Coding/Advent2022/day1/input.txt') as f:
    for line in f.readlines():
        try:
            data.append(int(line))
        except ValueError:
            data.append(0)

max = 0
sum = 0
leaderboard = []
for d in data:
    if (d != 0):
        sum += d
    else:
        leaderboard.append(sum)
        sum = 0
sleader = np.sort(leaderboard)
print(sleader)
top3 = sleader[-1]+sleader[-2]+sleader[-3]
print(top3)
