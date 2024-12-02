import numpy as np

moveSet = {
    'A': 'Rock',
    'B': 'Paper',
    'C': 'Scissors',
    'X': 'Loss',
    'Y': 'Draw',
    'Z': 'Win'
}

pointSet = {
    'Rock': 1,
    'Paper': 2,
    'Scissors': 3,
    'Win': 6,
    'Draw': 3,
    'Loss': 0
}

scoreList = {
    'Rock-Rock': 4,
    'Rock-Paper': 1,
    'Rock-Scissors': 7,
    'Paper-Rock': 8,
    'Paper-Paper': 5,
    'Paper-Scissors': 2,
    'Scissors-Rock': 3,
    'Scissors-Paper': 9,
    'Scissors-Scissors': 6
}

possibleMoves = {
    'Win-Rock': 'Paper',
    'Win-Paper': 'Scissors',
    'Win-Scissors': 'Rock',
    'Loss-Rock': 'Scissors',
    'Loss-Paper': 'Rock',
    'Loss-Scissors': 'Paper'
}


data = []
with open('/home/drene/Coding/Advent2022/day2/input2.txt') as f:
    data = f.readlines()
for (i, d) in enumerate(data):
    data[i] = d.strip()


def evalMove(move):
    theirMove = moveSet[move.split(' ')[0]]
    inter = moveSet[move.split(' ')[1]]
    if inter == 'Draw':
        myMove = theirMove
    else:
        myMove = possibleMoves[inter+'-'+theirMove]
    return scoreList[myMove+'-'+theirMove]


myScore = 0
for round in data:
    myScore += evalMove(round)

print(myScore)
