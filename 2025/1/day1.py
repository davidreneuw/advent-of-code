with open("./2025/1/input.txt") as file:
    txt = file.readlines()
sanitized_txt = [t.strip() for t in txt]
normalized_txt = [t.replace("L", "-").replace("R","") for t in sanitized_txt]
normalized_int = [int(t) for t in normalized_txt]
print(normalized_int)

zeros = 0
dial = 50
for inst in normalized_int:
    for clicks in range(abs(inst)):
        dial = (dial + (inst/abs(inst))) % 100
        if (dial == 0):
            zeros+=1
print(zeros)