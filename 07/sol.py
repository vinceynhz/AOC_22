class Dir(object):
    def __init__(self, name, parent=None):
        self.name = name
        self.parent = parent
        self.sub = []
        self.size = 0

    def cd(self, name):
        for s in self.sub:
            if s.name == name:
                return s
        raise BaseException(f"FAILURE: {name}")

    def repr(self, depth):
        if depth > 0:
            pad = '  ' * depth
        else:
            pad = ''
        result = f'{pad}{self.name} ({self.size}) ({self.calc_sub_size()})\n'
        for s in self.sub:
            result += s.repr(depth + 1)
        return result

    def calc_sub_size(self):
        total = self.size
        for s in self.sub:
            total += s.calc_sub_size()
        return total

    def __repr__(self):
        return self.repr(0)


def part_one(lines: list):
    root = Dir('/')
    cur = root
    for line in lines:
        line = line[:-1]
        if line[0] == '$':
            command = line.split(' ')
            if command[1] == 'cd':
                if command[2] == '/':
                    cur = root
                elif command[2] == '..':
                    cur = cur.parent
                else:
                    cur = cur.cd(command[2])
        else:
            if line.startswith('dir'):
                dirs = line.split(' ')
                cur.sub.append(Dir(dirs[1], cur))
            else:
                file_line = line.split(' ')
                cur.size += int(file_line[0])

    print(root)

    # part one
    total = 0
    css = root.calc_sub_size()
    if css <= 100000:
        total += css
    total += effective_size(root)
    print(total)

    # part two
    space = 70000000
    needed = 30000000
    used = css
    free = space - used
    pending = needed - free
    print(f"avail: {space} used:{used} free:{free} needed:{needed} pending:{pending}")

    mte = min_size(root, pending)

    print(min(mte))



def min_size(d: Dir, pending):
    more_than_enough = []
    for s in d.sub:
        css = s.calc_sub_size()
        if css >= pending:
            more_than_enough.append(css)
        more_than_enough.extend(min_size(s, pending))
    return more_than_enough

def effective_size(d: Dir):
    total = 0
    for s in d.sub:
        css = s.calc_sub_size()
        if css <= 100000:
            total += css
        total += effective_size(s)
    return total


if __name__ == '__main__':
    with open("input.txt", "r") as infile:
        lines = infile.readlines()
    part_one(lines)
