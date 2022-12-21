import os

fn parts(line string, window_size int, verbose bool) {
    mut windows := [][]string{len:window_size, init:[]string{len:window_size}}
    mut max_index := 0
    mut found := false
    for index, character in line {
        c := character.ascii_str()
        for i in 0 .. max_index + 1 {
            if ! (c in windows[i]) {
                windows[i] << c
            }
        }

        if verbose {
            mut result := '${index} '
            for i in windows {
                val := i.join('')
                mut pad := ''
                for _ in val.len .. window_size {
                    pad += ' '
                }

                result += '${val}${pad} '
            }
            println(result)
        }

        if index >= window_size - 1 {
            if windows[(index + 1) % window_size].len == window_size {
                println('\nMin characters ${index + 1}')
                found = true
                break
            }
            windows[(index + 1) % window_size].clear()
        }

        if index < window_size - 1 {
            max_index++
        }
    }
    if !found {
        println("Err")
    }   
}

fn main() {
    lines := os.read_lines("input.txt") or { panic(err) }
    parts(lines[0], 4, false)
    parts(lines[0], 14, false)
}
