import os

import shr

const of_interest = [20, 60, 100, 140, 180, 220]

fn part_one(lines []string, sprite int) {
    mut x := sprite
    mut cycle := 1
    mut sum := 0
    for line in lines {
        if cycle in of_interest {
            println('Cycle ${cycle} - X: ${x}')
            sum += x * cycle
        }
        if line[0].ascii_str() == 'n' {
            cycle++
        } else {
            ins := line.split(' ')[1].int()
            cycle++
            if cycle in of_interest {
                println('Cycle ${cycle} - X: ${x}')
                sum += x * cycle
            }
            cycle++
            x += ins
        }
    }
    println('Total: ${sum}')
}

fn part_two(lines []string, sprite int) {
    mut crt := ''
    mut x := sprite

    mut ip := 0
    mut count := 0
    mut change := 0

    count, change = shr.parse_ins(lines[ip])
    ip++

    for cycle in 1 .. 241 {
        if ip < lines.len && count == 0 {
            x += change
            count, change = shr.parse_ins(lines[ip])
            ip++
        }

        offset := (cycle - 1) % 40
        if offset == x - 1 || offset == x || offset == x + 1 {
            crt += '#'
        } else {
            crt += '.'
        }

        if cycle % 40 == 0 {
            // println("X: ${x} - Cycle: ${cycle} - IP: ${ip}")
            println(crt)
            crt = ''
            // break
        }

        count--
    }
}

fn main() {
    // mut lines := os.read_lines('test.txt') or { panic(err) }
    // mut lines := os.read_lines('input.txt') or { panic(err) }
    mut lines := os.read_lines('visualization.txt') or { panic(err) }
    sprite := lines[0].int()
    lines.delete(0)
    // part_one(lines, sprite)
    // println('')
    part_two(lines, sprite)
}
