import os

[heap]
struct Dir {
    name    string
mut:
    css     i64
    parent  &Dir = unsafe { 0 }
    size    i64
    sub     map[string]&Dir = map[string]&Dir{}
}

fn (d Dir) repr(level int) string {
    mut pad := ''
    for _ in 0 .. level {
        pad += '  '
    }
    mut result := '${pad}${d.name} (${d.size}) (${d.css})\n'
    for _, v in d.sub {
        result += v.repr(level + 1)
    }
    return result
}

fn (mut d Dir) sub_size() i64 {
    if d.css > 0 {
        return d.css
    }

    mut total := d.size
    for _, mut v in d.sub {
        total += v.sub_size()
    }

    d.css = total
    return d.css
}

fn (d Dir) cd(sub string) &Dir {
    return d.sub[sub]
}

fn (d Dir) str() string {
    return d.repr(0)
}


fn part_one(lines []string) {
    mut root := &Dir{name: '/'}
    mut cur_dir := root

    for line in lines {
        if line[0].ascii_str() == '$' {
            // command
            command := line.split(' ')
            if command[1] == 'cd' {
                if command[2] == '/' {
                    cur_dir = root
                } else if command[2] == '..' {
                    cur_dir = cur_dir.parent
                } else {
                    cur_dir = cur_dir.cd(command[2])
                }
            }
        } else if line.starts_with('dir') {
            dirs := line.split(' ')
            cur_dir.sub[dirs[1]] = &Dir{name: dirs[1], parent:cur_dir}
        } else {
            file_line := line.split(' ')
            cur_dir.size += file_line[0].int()
        }
    }

    root.sub_size()

    println(root)

    // part one
    mut total := i64(0)
    if root.css < 100000 {
        total += root.css
    }
    total += effective_size(root)

    println("Part one: ${total}")

    // part two
    space := i64(70000000)
    needed := i64(30000000)
    used := root.css
    free := space - used
    pending := needed - free

    println("avail: ${space} used:${used} free:${free} needed:${needed} pending:${pending}")

    mut mte := min_size(root, pending)

    mte.sort()

    println("Part two: ${mte[0]}")
}

fn effective_size(d &Dir) i64 {
    mut total := i64(0)
    for _, s in d.sub {
        if s.css < 100000 {
            total += s.css
        }
        total += effective_size(s)
    }
    return total
}

fn min_size(d &Dir, pending i64) []i64 {
    mut more_than_enough := []i64{}
    for _, s in d.sub {
        if s.css >= pending {
            more_than_enough << s.css
        }
        more_than_enough << min_size(s, pending)
    }
    return more_than_enough
}

fn main() {
    lines := os.read_lines('input.txt') or { panic(err) }
    part_one(lines)
}
