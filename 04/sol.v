import os

fn part_one(lines []string) {
    mut sum := 0
    for line in lines {
        words := line.split(',')
        first := words[0].split('-')
        second := words[1].split('-')

        fl := first[0].int()
        fh := first[1].int()

        sl := second[0].int()
        sh := second[1].int()        

        if (fl >= sl && fh <= sh) || (sl >= fl && sh <= fh) {
            sum++
        }
    }

    println(sum)
}

fn part_two(lines []string) {
    mut sum := 0
    for line in lines {
        words := line.split(',')
        first := words[0].split('-')
        second := words[1].split('-')

        fl := first[0].int()
        fh := first[1].int()

        sl := second[0].int()
        sh := second[1].int()

        if (sl <= fh && sh >= fh) || (sh >= fl && sh <= fh) {
            sum++
        }
    }

    // [...] 
    //       [...]
    // sl > fh


    // [...]
    //    [...]
    // sl <= fh && sh >= fh


    // [...]
    // [...]
    // sl <= fh && sh >= fh
    // sh >= fl && fh >= sh


    //    [...]
    // [...]
    // sh >= fl && sh <= fh


    //       [...]
    // [...]
    // sh < fl

    println(sum)
}

fn main() {
    lines := os.read_lines("input.txt") or { panic(err) }
    part_one(lines)
    part_two(lines)
}
