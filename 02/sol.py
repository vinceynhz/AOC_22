def winner(a: int, b: int):
    # rock = 0
    # paper = 1
    # scissors = 2
    diff = 1 - a
    return ((b + diff) % 3) * 3


def complement(a: int, b: int):
    # values for a:
    # rock = 0
    # paper = 1
    # scissors = 2

    # values for b:
    # lose = 0
    # draw = 1
    # win = 2
    diff = a - 1
    return (b + diff) % 3

def part_two(lines: list):
    score = 0
    for line in lines:
        a = ord(line[0]) - 65
        b = ord(line[2]) - 88
        c = complement(a, b)
        score += (b * 3) + c + 1
    print(score)


def part_one(lines: list):
    score = 0
    for line in lines:
        a = ord(line[0]) - 65
        b = ord(line[2]) - 88
        c = winner(a, b)
        score += b + 1 + c
    print(score)


if __name__ == '__main__':
    with open("input.txt", "r") as infile:
        lines = infile.readlines()
    part_one(lines) # 11475
    part_two(lines) # 16862

# print(winner(0, 0), 3) # 1 (b + 1) | 1 - a
# print(winner(0, 1), 6) # 2
# print(winner(0, 2), 0) # 0
# 
# print(winner(1, 0), 0) # 0 (b + 0) | 1 - a
# print(winner(1, 1), 3) # 1
# print(winner(1, 2), 6) # 2
# 
# print(winner(2, 0), 6) # 2 (b - 1) | 1 - a
# print(winner(2, 1), 0) # 0
# print(winner(2, 2), 3) # 1
#
# print(complement(0, 0), 2) (b - 1) | a - 1
# print(complement(0, 1), 0)
# print(complement(0, 2), 1)
# 
# print(complement(1, 0), 0) (b + 0) | a - 1
# print(complement(1, 1), 1)
# print(complement(1, 2), 2)
# 
# print(complement(2, 0), 1) (b + 1) | a - 1 
# print(complement(2, 1), 2)
# print(complement(2, 2), 0)

# test = [
# "A Y",
# "B X",
# "C Z"
# ]
