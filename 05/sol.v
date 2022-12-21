import os

fn part_one(lines []string) {
    mut crates := [][]u8{len:9, init:[]u8{cap:50}}
    for line in lines {
        if line.index('[') or { -1 } != -1 {
            for i in 0 .. 9 {
                c := line[(4 * i) + 1]
                if c != ` ` {
                    crates[i].prepend(c)
                }
            }
        } else if line.starts_with('move') {
            words := line.split(' ')
            how_many := words[1].int()
            from_crate := words[3].int() - 1
            to_crate := words[5].int() - 1
            for _ in 0 .. how_many {
                crates[to_crate] << crates[from_crate].last()
                crates[from_crate].trim(crates[from_crate].len - 1)
            }
        }
    }
    println(crates.map(it.last().ascii_str()).join(''))
}

fn part_two(lines []string) {
    mut crates := [][]u8{len:9, init:[]u8{cap:50}}
    for line in lines {
        if line.index('[') or { -1 } != -1 {
            for i in 0 .. 9 {
                c := line[(4 * i) + 1]
                if c != ` ` {
                    crates[i].prepend(c)
                }
            }
        } else if line.starts_with('move') {
            words := line.split(' ')
            how_many := words[1].int()
            from_crate := words[3].int() - 1
            to_crate := words[5].int() - 1

            crates[to_crate] << crates[from_crate]#[(how_many * -1)..]
            crates[from_crate].trim(crates[from_crate].len - how_many)
        }
    }
    println(crates.map(it.last().ascii_str()).join(''))
}

fn main() {
    lines := os.read_lines("input.txt") or { panic(err) }
    part_one(lines) // HNSNMTLHQ
    part_two(lines) // RNLFDJMCT
}
