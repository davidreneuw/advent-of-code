class Supply:

    def __init__(self):
        self.stack1 = ['D', 'L', 'V', 'T', 'M', 'H', 'F']
        self.stack2 = ['H', 'Q', 'G', 'J', 'C', 'T', 'N', 'P']
        self.stack3 = ['R', 'S', 'D', 'M', 'P', 'H']
        self.stack4 = ['L', 'B', 'V', 'F']
        self.stack5 = ['N', 'H', 'G', 'L', 'Q']
        self.stack6 = ['W', 'B', 'D', 'G', 'R', 'M', 'P']
        self.stack7 = ['G', 'M', 'N', 'R', 'C', 'H', 'L', 'Q']
        self.stack8 = ['C', 'L', 'W']
        self.stack9 = ['R', 'D', 'L', 'Q', 'J', 'Z', 'M', 'T']
        self.stacks = [self.stack1, self.stack2,
                       self.stack3, self.stack4, self.stack5, self.stack6, self.stack7, self.stack8, self.stack9]

    def __str__(self):
        return str(self.stacks)

    def moveOne(self, source, target, index=-1):
        container = self.stacks[source-1].pop(index)
        self.stacks[target-1].append(container)

    def moveMany(self, nbr, source, target):
        for i in range(nbr):
            self.moveOne(source, target, index=i-nbr)

    def evalInst(self, inst):
        temp = inst.split(" ")
        self.moveMany(int(temp[1]), int(temp[3]), int(temp[5]))

    def getTops(self):
        str = ''
        for stack in self.stacks:
            str += stack[-1]
        return str


if __name__ == '__main__':
    data = []
    with open('/home/drene/Coding/Advent2022/day5/input5.txt') as f:
        data = f.readlines()
    data = data[10:]
    supply = Supply()
    for (i, d) in enumerate(data):
        data[i] = d.strip()
    for inst in data:
        supply.evalInst(inst)
    print(supply.getTops())
