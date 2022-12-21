import os

fn map_char(c int) int {
    if c >= 97 {
        return (c - 97) + 1
    } 
    return (c - 65) + 27
}

fn map_string(s string) []int {
    mut result := []int{}
    for c in s {
        result << map_char(c)
    }
    return result
}

fn part_one(lines []string) {
    mut sum := 0
    for rucksack in lines {
        mut half := [] int {}
        len := rucksack.len
        for i in 0 .. (len / 2) {
            half << map_char(rucksack[i])
        }
        for i in (len / 2) .. len {
            c := map_char(rucksack[i])
            if c in half {
                sum = sum + c
                break
            }
        }
    }
    println(sum)
}

fn part_two(lines []string) {
    mut sum := 0
    mut index := 0
    for {
        mut longest := 0
        mut other := 1
        mut another := 2
        mut rucksacks := [][]int {len:3, init: []int{}}
    
        rucksacks[0] = map_string(lines[index])
        index++
        if index == lines.len {
            break
        }
       
        rucksacks[1] = map_string(lines[index])
        index++
        if index == lines.len {
            break
        } else if rucksacks[1].len > rucksacks[0].len {
            longest = 1
            other = 0
        }
       
        rucksacks[2] = map_string(lines[index])
        if rucksacks[2].len > rucksacks[longest].len {
            longest = 2
            other = 1
            another = 0
        }
       
        for c in rucksacks[longest] {
            if c in rucksacks[other] && c in rucksacks[another] {
                sum = sum + c
                break
            }
        }
        index++
        if index == lines.len {
            break
        }
    }
    println(sum)   
}

fn main() {
    lines := os.read_lines("input.txt") or { panic(err) }
    part_one(lines)
    part_two(lines)
}
