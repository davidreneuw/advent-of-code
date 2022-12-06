import numpy as np

data = []
with open('/home/drene/Coding/Advent2022/day4/input4.txt') as f:
    data = f.readlines()
for (i, d) in enumerate(data):
    data[i] = d.strip()

sum = 0
for line in data:
    half = line.split(',')
    a = int(half[0].split('-')[0])
    b = int(half[0].split('-')[1])
    c = int(half[1].split('-')[0])
    d = int(half[1].split('-')[1])
    if ((a >= c and a <= d) or (b >= c and b <= d) or (c >= a and c <= b) or (d >= a and d <= b)):
        sum += 1
print(sum)

#  (a>=c and a<=d) or (b>=c and b<=d) or (c>=a and c<=b) or (d>=a and d<=b)
