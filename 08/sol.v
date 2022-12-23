import os

fn part_one(lines []string) {
    mut count := 0
    h := lines.len
    w := lines[0].len

    // left column and right column
    count += h * 2
    // top line and bottom line - corners already accounted for

    count += (w - 2) * 2

    println('H: ${h} W: ${w}')
    println('Initial count: ${count}')

    for i in 1 .. h - 1 {
        for j in 1 .. w - 1 {
            mut lv := true
            mut rv := true
            mut tv := true
            mut bv := true
            target := lines[i][j]

            for ptr in 0 .. j {
                // checking left side
                if lines[i][ptr] >= target {
                    // found taller, not visible
                    lv = false
                }
            }

            for ptr in j + 1 .. w {
                // checking right side
                if lines[i][ptr] >= target {
                    // found taller, not visible
                    rv = false
                }
            }

            for ptr in 0 .. i {
                 // checking top side
                if lines[ptr][j] >= target {
                    // found taller, not visible
                    tv = false
                }   
            }

            for ptr in i + 1 .. h {
                 // checking bottom side
                if lines[ptr][j] >= target {
                    // found taller, not visible
                    bv = false
                }   
            }

            if lv || rv || tv || bv {
                // println('${i},${j} ${target.ascii_str()} - visible ${lv:-5} ${rv:-5} ${tv:-5} ${bv:-5}')
                count++
            } else {
                // println('${i},${j} ${target.ascii_str()} - not vbl ${lv:-5} ${rv:-5} ${tv:-5} ${bv:-5}')
            }
        }
    }
    println("Final count: ${count}")
}

fn part_two(lines []string) {
    h := lines.len
    w := lines[0].len
    mut max_score := 0
    for i in 0 .. h {
        for j in 0 .. w {
            target := lines[i][j]
            mut ls := 0
            mut rs := 0
            mut ts := 0
            mut bs := 0
            
            mut ptr := j + 1
            for ptr < w {
                rs++
                if lines[i][ptr] >= target {
                    break
                }
                ptr++
            }

            ptr = j - 1
            for ptr >= 0 {
                ls++
                if lines[i][ptr] >= target {
                    break
                }
                ptr--
            }

            ptr = i + 1
            for ptr < h {
                bs++
                if lines[ptr][j] >= target {
                    break
                }
                ptr++
            }

            ptr = i - 1
            for ptr >= 0 {
                ts++
                if lines[ptr][j] >= target {
                    break
                }
                ptr--
            }

            score := rs * ls * ts * bs
            // println('${target.ascii_str()} - ${score} - ${rs} ${ls} ${ts} ${bs}')
            if score > max_score {
                max_score = score
            }
        }
    }

    println('Max score: ${max_score}')
}

fn main() {
    lines := os.read_lines('input.txt') or { panic(err) }
    // lines := os.read_lines('test.txt') or { panic(err) }
    part_one(lines)
    println('')
    part_two(lines)
}
