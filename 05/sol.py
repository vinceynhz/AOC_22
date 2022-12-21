
def part_two(lines: list):
    crates = [[], [], [], [], [], [], [], [], []]
    for line in lines:
        if '[' in line:
            # we have crate definition
            #             1   1   2
            # 1   5   9   3   7   1
            #[D] [H] [R] [L] [N] [W] [G] [C] [R]
            #    [P]                 [Q]     [T]
            for i in range(9):
              c = line[(4 * i) + 1]
              if c != ' ':
                  crates[i].insert(0, c)
        elif line.startswith('move'):
            words = line.split(' ')
            how_many = int(words[1])
            from_crate = int(words[3])  - 1
            to_crate = int(words[5]) - 1

            grab = crates[from_crate][-1 * how_many:]
            
            crates[from_crate] = crates[from_crate][:-1 * how_many]
            crates[to_crate].extend(grab)


    print(''.join([ c[-1] for c in crates]))


def part_one(lines: list):
    crates = [[], [], [], [], [], [], [], [], []]
    for line in lines:
        if '[' in line:
            # we have crate definition
            #             1   1   2
            # 1   5   9   3   7   1
            #[D] [H] [R] [L] [N] [W] [G] [C] [R]
            #    [P]                 [Q]     [T]
            for i in range(9):
              c = line[(4 * i) + 1]
              if c != ' ':
                  crates[i].insert(0, c)
        elif line.startswith('move'):
            words = line.split(' ')
            how_many = int(words[1])
            from_crate = int(words[3])  - 1
            to_crate = int(words[5]) - 1
            for i in range(how_many):
                crates[to_crate].append(crates[from_crate][-1])
                del crates[from_crate][-1]

    print(''.join([ c[-1] for c in crates]))


if __name__ == '__main__':
    with open("input.txt", "r") as infile:
        lines = infile.readlines()
    part_one(lines) # HNSNMTLHQ
    part_two(lines) # RNLFDJMCT

