import numpy as np


class Monkey():
    def __init__(self, items, op, test, trueMonkey, falseMonkey, lcm):
        self.items = items
        self.op = op
        self.test = test
        self.trueMonkey = trueMonkey
        self.falseMonkey = falseMonkey
        self.investigate = 0
        self.lcm = lcm
    
    def round(self):
        itemLst = self.items.copy()
        self.investigate += len(itemLst)
        dest = []
        for i, item in enumerate(itemLst):
            newitem = self.op(item) % self.lcm
            if self.test(newitem):
                dest.append((self.trueMonkey, newitem))
            else:
                dest.append((self.falseMonkey, newitem))
        self.items = []
        return dest
                

data = []
with open('/home/drene/Advent2022/day11/input11.txt') as f:
    data=f.readlines()
data = [x.strip() for x in data]

itemLst = []
for i in range(8):
    items = data[i*7+1].split(" ")[2:]
    items = [int(x.strip(",")) for x in items]
    itemLst.append(items)

group = []
lcm = np.lcm.reduce([7,11,13,3,17,2,5,19])
group.append(Monkey(itemLst[0], lambda x: x*11, lambda x: x % 7 ==0, 6, 2, lcm))
group.append(Monkey(itemLst[1], lambda x: x+1, lambda x: x % 11==0, 5, 0, lcm))
group.append(Monkey(itemLst[2], lambda x: x*7, lambda x: x % 13==0, 4, 3, lcm))
group.append(Monkey(itemLst[3], lambda x: x+3, lambda x: x % 3==0, 1, 7, lcm))
group.append(Monkey(itemLst[4], lambda x: x+6, lambda x: x % 17==0, 3, 7, lcm))
group.append(Monkey(itemLst[5], lambda x: x+5, lambda x: x % 2==0, 0, 6, lcm))
group.append(Monkey(itemLst[6], lambda x: x*x, lambda x: x % 5==0, 2, 4, lcm))
group.append(Monkey(itemLst[7], lambda x: x+7, lambda x: x % 19==0, 5, 1, lcm))

for round in range(10000):
    for monkey in group:
        dest = monkey.round()
        for item in dest:
            group[item[0]].items.append(item[1])

score = []
for i, monkey in enumerate(group):
    print("Monkey "+str(i)+" has investigated "+str(monkey.investigate)+" items.")
    score.append(monkey.investigate)
score.sort()
print(score[-1]*score[-2])
