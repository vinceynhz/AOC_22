def part_two(lines: list):
    max_1 = 0
    max_2 = 0
    max_3 = 0
    current_count = 0
    for line in lines:
        l = line[:-1].strip()
        if len(l) == 0:
            if current_count > max_1:
                max_3 = max_2
                max_2 = max_1
                max_1 = current_count
            print("current calories:", current_count)
            print("top max:", max_1, max_2, max_3)
            print()
            current_count = 0
        else:
            l = int(l)
            current_count += l
    print("top 3:", max_1, max_2, max_3)
    print("total:", max_1 + max_2 + max_3)


def part_one(lines: list):
    overall_max = 0
    current_count = 0
    for line in lines:
        l = line[:-1].strip()
        if len(l) == 0:
            if current_count > overall_max:
                overall_max = current_count
            print("current calories:", current_count)
            print("overall max:", overall_max)
            print()
            current_count = 0
        else:
            l = int(l)
            current_count += l
    print("max calories:", overall_max)


if __name__ == '__main__':
    with open("input.txt", "r") as infile:
        lines = infile.readlines()
    part_two(lines)