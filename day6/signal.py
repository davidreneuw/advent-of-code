with open('/home/drene/Coding/Advent2022/day6/input6.txt') as f:
    data = f.readlines()
str = data[0].strip()
charlst = [*str]
breakage = 0
for (i, char) in enumerate(charlst):
    section = charlst[i:i+14]
    if len(list(set(section))) == 14:
        breakage = i+14
        break
print(breakage)
