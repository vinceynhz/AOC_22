import os
import datatypes
import math
import shr

fn part_one(lines []string, size int) {
    //        x, y
    mut t := [][]int {len:size, init:[0, 0]}
    // mut h := [0, 0]
    // mut t := [0, 0]
    mut t_pos := datatypes.Set[string]{}

    t_pos.add('${t[t.len - 1]}')

    // println('H: ${h} - T: ${t}')

    mut min_x := math.max_i32
    mut min_y := math.max_i32
    mut max_x := 0
    mut max_y := 0

    for line in lines {
        move := line.split(' ')
        coord := move[0][0]
        change := shr.changes[coord]
        dist := move[1].int()

        for _ in 0 .. dist {
            // update h
            t[0][change[0]] += change[1]

            if t[0][0] > max_x {
                max_x = t[0][0]
            }

            if t[0][1] > max_y {
                max_y = t[0][1]
            }

            if t[0][0] < min_x {
                min_x = t[0][0]
            }

            if t[0][1] < min_y {
                min_y = t[0][1]
            }

            // calculate t
            // t = shr.adj_t(h, t)
            for i in 1 .. t.len {
                t[i] = shr.adj_t(t[i-1], t[i])
                if t[i][0] > max_x {
                    max_x = t[i][0]
                }

                if t[i][1] > max_y {
                    max_y = t[i][1]
                }

                if t[i][0] < min_x {
                    min_x = t[i][0]
                }

                if t[i][1] < min_y {
                    min_y = t[i][1]
                }
            }
            // println('H: ${h} - T: ${t}')
            t_key := '${t[t.len - 1]}'
            if !t_pos.exists(t_key) {
                t_pos.add(t_key)
            }
        }
    }

    println('Total positions of t: ${t_pos.size()}')
    println('Max: ${max_x}, ${max_y} Min: ${min_x}, ${min_y}')
}

fn main() {
    lines := os.read_lines('input.txt') or { panic(err) }
    // lines := os.read_lines('test.txt') or { panic(err) }
    // lines := os.read_lines('sample.txt') or { panic(err) }
    part_one(lines, 2)
    part_one(lines, 10)
}
