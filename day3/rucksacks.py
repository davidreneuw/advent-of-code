import string

import numpy as np

shift = ['null']
lalphabet = list(string.ascii_lowercase)
ualphabet = list(string.ascii_uppercase)
priority = np.concatenate((shift, lalphabet, ualphabet))

allGroups = []
data = []
with open('/home/drene/Coding/Advent2022/day3/input3.txt') as f:
    data = f.readlines()
groupmod = int(len(data)/3)
for (i, d) in enumerate(data):
    data[i] = d.strip()
for i in range(groupmod):
    group = []
    for j in range(3):
        group.append(data[i*3+j])
    allGroups.append(group)


def evalRS(group):
    rs1 = [*group[0]]
    rs2 = [*group[1]]
    rs3 = [*group[2]]
    badge = 'null'
    for char in rs1:
        if (char in rs2 and char in rs3):
            badge = char
            break
    return np.where(priority == badge)[0][0]


totalPrio = 0
for group in allGroups:
    totalPrio += evalRS(group)
print(totalPrio)
