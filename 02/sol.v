import os

struct Entry {
    a int
    b int
}

fn winner(entry Entry) (int) {
    mut diff := entry.b + 1 - entry.a
    if diff < 0 {
        diff = 3 + diff
    }
    return (diff % 3) * 3
}

fn complement(entry Entry) (int) {
    mut diff := entry.a - 1
    if diff < 0 {
        diff = 3 + diff
    }
    return (entry.b + diff) % 3
}

fn part_one(entries []Entry) {
    mut score := 0
    for entry in entries {
        c := winner(entry)
        score = score + entry.b + 1 + c
    }
    println(score)
}

fn part_two(entries []Entry) {
    mut score := 0
    for entry in entries {
        c := complement(entry)
        score = score + (entry.b * 3) + c + 1
    }
    println(score)
}

fn main() {
    // println('${winner(Entry{a:0, b:0})}, 3') // 1 (b + 1) | 1 - a
    // println('${winner(Entry{a:0, b:1})}, 6') // 2
    // println('${winner(Entry{a:0, b:2})}, 0') // 0
    // println('')
    // println('${winner(Entry{a:1, b:0})}, 0') // 0 (b + 0) | 1 - a
    // println('${winner(Entry{a:1, b:1})}, 3') // 1
    // println('${winner(Entry{a:1, b:2})}, 6') // 2
    // println('')
    // println('${winner(Entry{a:2, b:0})}, 6') // 2 (b - 1) | 1 - a
    // println('${winner(Entry{a:2, b:1})}, 0') // 0
    // println('${winner(Entry{a:2, b:2})}, 3') // 1

    // println('${complement(Entry{a:0, b:0})}, 2') // (b - 1) | a - 1
    // println('${complement(Entry{a:0, b:1})}, 0') //
    // println('${complement(Entry{a:0, b:2})}, 1') //
    // println('')
    // println('${complement(Entry{a:1, b:0})}, 0') // (b + 0) | a - 1
    // println('${complement(Entry{a:1, b:1})}, 1') //
    // println('${complement(Entry{a:1, b:2})}, 2') //
    // println('')    
    // println('${complement(Entry{a:2, b:0})}, 1') // (b + 1) | a - 1 
    // println('${complement(Entry{a:2, b:1})}, 2') //
    // println('${complement(Entry{a:2, b:2})}, 0') //
    
    mut f := os.open("input.txt") or { panic(err) }
    defer {
        f.close()
    }
    mut entries := []Entry{}
    for {
        mut line := []u8{len: 5}
        read := f.read_bytes_into_newline(mut line)!
        if read == 0 {
           break 
        }
        entries << Entry{a: line[0] - 65, b: line[2] - 88}
    }
    part_one(entries)
    part_two(entries)
}