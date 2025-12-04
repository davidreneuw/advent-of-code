with open("2025/3/input.txt") as file:
    input = [f.strip() for f in file.readlines()]

# Part 1
def joltage(bank: str) -> int:
    sorted_batteries = sorted(bank[:len(bank)-1], key=int)
    first = sorted_batteries[-1]
    after_highest = bank[bank.index(first)+1:]
    sorted_after_highest = sorted(after_highest, key=int)
    second = sorted_after_highest[-1]
    return int(""+first+second)

def find_total_joltage(banks: list[str]) -> int:
    joltages = []
    for bank in banks:
        joltages.append(joltage(bank))
    print(sum(joltages))

find_total_joltage(input)

# Part 2
def get_max_digit(num: str) -> str:
    max = sorted(num, key=int)[-1]
    return str(max)

def get_string_remainder(num: str, digit: str):
    i = num.index(digit)
    return num[i+1:]

def make_max_n_digit_number(num: str, n: int, curr: str):
    possible_digits = num[:len(num)-n+1]
    max = get_max_digit(possible_digits)
    remainder = get_string_remainder(num, max)
    n -= 1
    if n == 0:
        return curr+max
    else:
        return make_max_n_digit_number(remainder, n, curr+max)
    
def joltage2(bank: str):
    return make_max_n_digit_number(bank, 12, "")

def find_total_joltage2(banks: list[str]):
    joltages = []
    for bank in banks:
        joltages.append(joltage2(bank))
    print(sum([int(joltage) for joltage in joltages]))

find_total_joltage2(input)


