import os
import shr

fn part_one(lines []string) {
    mut count := 0
    h := lines.len
    w := lines[0].len

    println('H: ${h} W: ${w}')
    println('Initial count: ${count}')

    mut max_score := 0
    for i in 0 .. h {
        for j in 0 .. w {
            visible, score := shr.visibility(lines, i, j)
            if visible {
                count++
            }
            if score > max_score {
                max_score = score
            }
        }
    }
    println("Final count: ${count}")
    println('Max score: ${max_score}')
}

fn main() {
    lines := os.read_lines('input.txt') or { panic(err) }
    // lines := os.read_lines('test.txt') or { panic(err) }
    part_one(lines)
}
