with open("2025/2/input.txt") as file:
    input = file.readlines()
ranges_txt = input[0].split(",")
ranges = [(r.split("-")[0], r.split("-")[1]) for r in ranges_txt]

# Part 1
def check_invalid(num):
    if len(num) % 2 == 1:
        return False
    first = num[:len(num) // 2]
    second = num[len(num) // 2:]
    return first == second

def iterate_range(tuple):
    invalids = []
    for i in range(int(tuple[0]), int(tuple[1])+1):
        if check_invalid(str(i)):
            invalids.append(i)
    return invalids

def validate_input(ranges):
    invalid_ids = []
    for range in ranges:
        invalid_ids.extend(iterate_range(range))
    return invalid_ids

invalid_ids = validate_input(ranges)
print(sum(invalid_ids))

# Part 2
def check_invalid2(num):
    pattern = ""
    for i in range(0, len(num) // 2):
        pattern += num[i]
        remainder = num[i+1:]
        if num.count(pattern) * len(pattern) == len(num):
            return True
    return False

def iterate_range2(tuple):
    invalids = []
    for i in range(int(tuple[0]), int(tuple[1])+1):
        if check_invalid2(str(i)):
            invalids.append(i)
    return invalids

def validate_input2(ranges):
    invalid_ids = []
    for range in ranges:
        invalid_ids.extend(iterate_range2(range))
    return invalid_ids

invalid_ids2 = validate_input2(ranges)
print(sum(invalid_ids2))