module shr

pub fn visibility(lines []string, row int, col int) (bool, int) {
    mut lv := true
    mut ls := 0
    mut rv := true
    mut rs := 0
    mut tv := true
    mut ts := 0
    mut bv := true
    mut bs := 0
    target := lines[row][col]

    mut ptr := col - 1
    for ptr >= 0 {
        // checking left side
        ls++
        if lines[row][ptr] >= target {
            // found taller, not visible
            lv = false
            break
        }
        ptr--
    }

    ptr = col + 1
    for ptr < lines[row].len {
        // checking right side
        rs++
        if lines[row][ptr] >= target {
            // found taller, not visible
            rv = false
            break
        }
        ptr++
    }

    ptr = row - 1
    for ptr >= 0 {
         // checking top side
        ts++
        if lines[ptr][col] >= target {
            // found taller, not visible
            tv = false
            break
        }
        ptr--
    }

    ptr = row + 1
    for ptr < lines.len {
         // checking bottom side
        bs++
        if lines[ptr][col] >= target {
            // found taller, not visible
            bv = false
            break
        }
        ptr++
    }

    return lv || rv || tv || bv, rs * ls * ts * bs
}

