import os

enum Op {
    noop
    sum
    mul
}

struct Monkey {
    id          int
mut:
    items       []u64  = []u64{}
    operation   Op     = .noop
    val         u64
    test        u64
    if_true     int    = -1
    if_false    int    = -1
    inspections u64
}

fn (mon Monkey) repr() string {
    return 'Monkey ${mon.id} - ${mon.inspections} - ${mon.operation} by ${mon.val} - ${mon.test} t:${mon.if_true} f:${mon.if_false} - ${mon.items}'
}

fn (mon Monkey) inspect(item u64, relief bool, verbose bool) u64 {
    mut new := u64(0)
    mut operand := mon.val

    if verbose {
        println('  inspecting ${item}')
    }

    if operand == 0 {
        operand = item
    }

    if mon.operation == .mul {
        new = item * operand
    } else if mon.operation == .sum {
        new = item + mon.val
    } else {
        panic('Wrong operand')
    }
    if verbose {
        println('  worry level ${mon.operation} by ${operand} to ${new}')
    }
    if relief {
        new /= u64(3)
        if verbose {
            println('  monkey bored, dividing by 3 to ${new}')
        }
    }
    return new
}

fn parse(lines []string) []Monkey {
    mut result := []Monkey{}
    for line in lines {
        if line.len == 0 {
            continue
        } 
        if line[0] == 77 {
            // we add a new Monkey
            result << &Monkey {id: result.len}
        } else if line[2] == 83 {
            // we add items
            result.last().items << line.split(': ')[1].split(', ').map(it.int()).filter(it > 0).map(u64(it))
        } else if line[2] == 79 {
            // we define operation and value
            if line[23] == 42 {
                // mult
                result.last().operation = .mul
            } else if line[23] == 43 {
                // mult
                result.last().operation = .sum
            } else {
                panic("unkown operation")
            }
            result.last().val = u64(line[25..].int())
        } else if line[2] == 84 {
            // we define test
            result.last().test = u64(line[21..].int())
        } else if line[7] == 116 {
            result.last().if_true = line[29..].int()
        } else if line[7] == 102 {
            result.last().if_false = line[30..].int()
        }
    }
    return result
}


fn part_one(lines []string, relief bool, rounds int, verbose bool) {
    mut monkeys := parse(lines)

    mut limit := u64(1)
    for l in monkeys.map(it.test) {
        limit *= l
    }

    println("limit: ${limit}")

    for round in 1 .. rounds + 1 {
        if verbose {
            println("== Round ${round} ==")
        }
        for mut monkey in monkeys {
            // println('m${monkey.id} = ${monkey.items}')
            if verbose {
                println(monkey.repr())
            }
            for item in monkey.items {
                if item < 0 {
                    panic("we doubled ${round}, ${monkey.id}, ${item}")
                }
                new := monkey.inspect(item, relief, verbose) % limit
                if verbose {
                    println('${monkey.id} - ${new}')
                    println('  increasing inspections')
                }
                monkey.inspections++
                if new % monkey.test == 0 {
                    // throw to this monkey
                    if verbose {
                        println('  worry level is divisible by ${monkey.test}')
                        println('  worry level ${new} is thrown to ${monkey.if_true}')
                    }
                    monkeys[monkey.if_true].items << new
                } else {
                    if verbose {
                        println('  worry level not divisible by ${monkey.test}')
                        println('  worry level ${new} is thrown to ${monkey.if_false}')
                    }
                    monkeys[monkey.if_false].items << new
                }
            }
            // monkey has no more items
            monkey.items.clear()
            if verbose {
                println('all items have been cleared: ${monkey.items}\n')
            }
        }
        if round == 1 || round == 20 || round % 1000 == 0 {
            println("== After round ${round} ==")
            for monkey in monkeys {
                println('Monkey ${monkey.id} inspected items ${monkey.inspections} times')
            }
        } 
    }

    println('\n')

    mut act_1 := u64(0)
    mut act_2 := u64(0)
    for monkey in monkeys {
        println(monkey.repr())
        if monkey.inspections > act_1 {
            act_1, act_2 = monkey.inspections, act_1
        } else if monkey.inspections > act_2 {
            act_2 = monkey.inspections
        }
    }

    println('Total: ${act_1 * act_2}')
}

fn main() {
    lines := os.read_lines('input.txt') or { panic(err) }
    // lines := os.read_lines('test.txt') or { panic(err) }
    // lines := os.read_lines('sample.txt') or { panic(err) }
    // part_one(lines, true, 20, false)
    // println('')

    part_one(lines, false, os.args[1].int(), false)
}

