class Assembly:
    def __init__(self) -> None:
        self.x = 1
        self.c = 0
        self.hist = [(self.x, self.c)]
        self.draw = ""

    def noop(self):
        self.c += 1
        self.hist.append((self.x, self.c))

    def addx(self, V):
        self.c += 1
        self.hist.append((self.x, self.c))
        self.c += 1
        self.hist.append((self.x, self.c))
        self.x += V

    def strength(self, c):
        return self.hist[c][0]*self.hist[c][1]

    def render(self):
        for i in range(6):
            for j in range(1, 41):

                if abs((self.hist[i*40+j-1][1] % 40)-self.hist[i*40+j][0]) <= 1:
                    self.draw += "#"
                else:
                    self.draw += "."
            self.draw += "\n"
        print(self.draw)


if __name__ == "__main__":
    a = Assembly()
    data = []
    with open('/home/drene/Coding/Advent2022/day10/input10.txt') as f:
        data = f.readlines()
    for i, d in enumerate(data):
        data[i] = d.strip()
        command = data[i].split(" ")[0]
        if command == "noop":
            a.noop()
        elif command == "addx":
            a.addx(int(d.split(" ")[1]))
    # print(a.strength(20)+a.strength(60) +
    #       a.strength(100)+a.strength(140)+a.strength(180)+a.strength(220))
    a.render()
