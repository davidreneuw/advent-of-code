import numpy as np


class Bridge:
    def __init__(self) -> None:
        self.rope = []
        for i in range(10):
            self.rope.append((0, 0))
        self.hadTail = {(0, 0)}

    def moveHeadOne(self, dir) -> None:
        if dir == "R":
            self.rope[0] = (self.rope[0][0]+1, self.rope[0][1])
        elif dir == "L":
            self.rope[0] = (self.rope[0][0]-1, self.rope[0][1])
        elif dir == "U":
            self.rope[0] = (self.rope[0][0], self.rope[0][1]+1)
        elif dir == "D":
            self.rope[0] = (self.rope[0][0], self.rope[0][1]-1)
        self.moveTail()

    def moveHead(self, dir, nbr) -> None:
        for i in range(nbr):
            self.moveHeadOne(dir)

    def moveOneTail(self, ropnbr) -> None:
        diff = tuple(
            map(lambda i, j: i-j, self.rope[ropnbr-1], self.rope[ropnbr]))
        if diff[0] == 0 and abs(diff[1]) > 1:
            self.rope[ropnbr] = (self.rope[ropnbr][0],
                                 self.rope[ropnbr][1]+int(diff[1]/2))
        elif abs(diff[0]) > 1 and diff[1] == 0:
            self.rope[ropnbr] = (self.rope[ropnbr][0] +
                                 int(diff[0]/2), self.rope[ropnbr][1])
        elif (abs(diff[0]) > 1 or abs(diff[1]) > 1) and (diff[0] != 0 and diff[1] != 0):
            self.rope[ropnbr] = (self.rope[ropnbr][0]+int(diff[0]/abs(diff[0])),
                                 self.rope[ropnbr][1]+int(diff[1]/abs(diff[1])))
        if ropnbr == 9:
            self.hadTail.add(self.rope[ropnbr])

    def moveTail(self):
        for i in range(1, 10):
            self.moveOneTail(i)


if __name__ == '__main__':
    data = []
    b = Bridge()
    with open('/home/drene/Coding/Advent2022/day9/input9.txt') as f:
        data = f.readlines()
    for i, inst in enumerate(data):
        data[i] = inst.strip()
        dir = data[i].split(" ")[0]
        nbr = int(data[i].split(" ")[1])
        b.moveHead(dir, nbr)
    print(len(b.hadTail))
