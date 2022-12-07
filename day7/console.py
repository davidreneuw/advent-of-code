
class Console:
    def __init__(self, path, part1=True, part2=True):
        self.commandLst = self.readInput(path)
        self.fileStruct = Directory("base")
        self.flatStruct = [self.fileStruct]
        self.curDir = self.fileStruct
        self.fileStruct.getSize()
        self.executeInput()
        if part1:
            self.getAnswerP1()
        if part2:
            self.getAnswerP2()

    def __str__(self):
        return str(self.fileStruct)

    def readInput(self, path):
        with open(path) as f:
            input = f.readlines()
        for command in input:
            command.strip()
        return input

    def executeInput(self):
        for command in self.commandLst:
            self.executeCommand(command)

    def getNecessarySpace(self):
        return 30000000-(70000000-self.fileStruct.getSize())

    def getAnswerP1(self):
        dirLst = []
        for dir in self.flatStruct:
            if dir.getSize() <= 100000:
                dirLst.append(dir)
        sum = 0
        for dir in dirLst:
            sum += dir.size
        print("Total size of all folders with size of at most 100000: " + str(sum))

    def getAnswerP2(self):
        nspace = self.getNecessarySpace()
        smallest = self.fileStruct
        for dir in self.flatStruct:
            if (dir.size < smallest.size and dir.size >= nspace):
                smallest = dir
        print("Size of smallest directory that is big enough to free space for update: "+str(smallest.size))

    def createFile(self, s, n):
        self.curDir.createFile(s, n)

    def createDir(self, n):
        dir = self.curDir.createDir(n)
        self.flatStruct.append(dir)
        return dir

    def executeCommand(self, str):
        if '$ cd ' in str:
            dirName = str.split(" ")[2]
            if ".." in dirName:
                self.curDir = self.curDir.parentDir
            else:
                exists = False
                existingDir = None
                for item in self.curDir.contents:
                    if (item.name == dirName and type(item) == Directory):
                        exists = True
                        existingDir = item
                self.curDir = existingDir if exists else self.createDir(
                    dirName)
        elif '$ ls' in str:
            pass
        else:
            if str.split(" ")[0] != 'dir':
                size = int(str.split(" ")[0])
                name = str.split(" ")[1]
                self.createFile(size, name)


class Directory:
    def __init__(self, name, parent=None):
        self.parentDir = parent
        self.name = name
        self.contents = []
        self.size = 0

    def __str__(self):
        return self.stringify()

    def stringify(self, level=1):
        disp = "dir "+self.name
        for item in self.contents:
            if type(item) is File:
                disp += "|   "*level+str(item)
            elif type(item) is Directory:
                disp += "|   "*(level-1)+"|---" + \
                    item.stringify(level=level+1)
        return disp

    def getSize(self):
        totalSize = 0
        for item in self.contents:
            if type(item) == File:
                totalSize += item.size
            elif type(item) == Directory:
                if item.size == 0:
                    dirSize = item.getSize()
                    item.size = dirSize
                    totalSize += dirSize
                else:
                    totalSize += item.size
        self.size = totalSize
        return totalSize

    def createFile(self, size, name):
        newFile = File(size, name, parent=self)
        self.contents.insert(0, newFile)
        return newFile

    def createDir(self, name):
        newDir = Directory(name, parent=self)
        self.contents.append(newDir)
        return newDir


class File:
    def __init__(self, s, n, parent=None):
        self.parentDir = parent
        self.size = s
        self.name = n

    def __str__(self):
        return str(self.size) + " " + str(self.name)


if __name__ == '__main__':
    console = Console('/home/drene/Coding/Advent2022/day7/input7.txt')
