/*
This program is an approach to try to multithread the calculation of the large numbers. 

However the core problem is not processing but computability of large numbers, so this multithreaded approach did not work either.
*/
import os
import math.big
import runtime

enum Op {
    noop
    sum
    mul
}

const relief_factor = big.integer_from_int(3)

struct Monkey {
    id          int
mut:
    items       []big.Integer  = []big.Integer{}
    operation   Op             = .noop
    val         big.Integer    = big.zero_int
    test        big.Integer    = big.zero_int 
    if_true     int    = -1
    if_false    int    = -1
    inspections big.Integer    = big.zero_int
}

fn (mon Monkey) repr() string {
    return     'Monkey ${mon.id} - ${mon.inspections} - ${mon.operation} by ${mon.val} - ${mon.test} t:${mon.if_true} f:${mon.if_false} - ${mon.items}'
}

fn (mon Monkey) inspect(worry big.Integer, relief bool, verbose bool) big.Integer {
    mut new := big.zero_int
    mut operand := mon.val

    if verbose {
        println('  inspecting ${worry}')
    }

    if operand == big.zero_int {
        operand = worry
    }

    if mon.operation == .mul {
        new = worry * operand
    } else if mon.operation == .sum {
        new = worry + operand
    } else {
        panic('Wrong operand')
    }
    if verbose {
        println('  worry level ${mon.operation} by ${operand} to ${new}')
    }
    if relief {
        new /= relief_factor
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
            result.last().items << line.split(': ')[1].split(', ').map(big.integer_from_int(it.int()))
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
            result.last().val = big.integer_from_int(line[25..].int())
        } else if line[2] == 84 {
            // we define test
            result.last().test = big.integer_from_int(line[21..].int())
        } else if line[7] == 116 {
            result.last().if_true = line[29..].int()
        } else if line[7] == 102 {
            result.last().if_false = line[30..].int()
        }
    }
    return result
}

struct Task {
    worry     big.Integer
    val       big.Integer
    test      big.Integer
    operation Op
}

struct Result {
    new       big.Integer
    test      bool
}

fn worker(id int, input chan Task, ready chan Result) {
    for {
        task := <- input or { break }
        // println('Worker ${id} - on the case! ${task.worry}')

        mut new := big.zero_int
        mut operand := task.val

        if operand == big.zero_int {
            operand = task.worry
        }

        if task.operation == .mul {
            new = task.worry * operand
        } else if task.operation == .sum {
            new = task.worry + operand
        } else {
            panic('Wrong operand')
        }

        test := new % task.test == big.zero_int

        ready <- Result {
            new: new
            test: test
        }
    }
}

fn part_monkeys(lines []string, relief bool, rounds int, verbose bool) {
    mut monkeys := parse(lines)
    ntasks := runtime.nr_jobs()

    mut task_channel := chan Task{cap: ntasks}
    mut task_ready_channel := chan Result{cap: ntasks}
    mut threads := []thread{cap: ntasks}

    defer {
        task_channel.close()
        threads.wait()
    }

    // create as manu threads as possible
    for t in 0 .. ntasks {
        threads << spawn worker(t, task_channel, task_ready_channel)
    }

    for round in 1 .. rounds + 1 {
        if verbose {
            println('Round ${round}')
        }
        for mut monkey in monkeys {
            if verbose {
                println(monkey.repr())
            }
            for item in monkey.items {
                task_channel <- Task {
                    worry: item
                    val: monkey.val
                    test: monkey.test
                    operation: monkey.operation
                }
            }
            for _ in 0 .. monkey.items.len {
                result := <-task_ready_channel
                if result.test {
                    monkeys[monkey.if_true].items << result.new
                } else {
                    monkeys[monkey.if_false].items << result.new
                }
                monkey.inspections += big.one_int
            }
            // monkey has no more items
            monkey.items.clear()
        }
        if round == 1 || round == 20 || round % 1000 == 0 {
            println("== After round ${round} ==")
            for monkey in monkeys {
                println('Monkey ${monkey.id} inspected items ${monkey.inspections} times')
            }
        } else {
            println("== Round ${round} ==")
        }
        // if round == 20 {
        //     break
        // }
    }

    println('\n')

    mut act_1 := big.zero_int
    mut act_2 := big.zero_int
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

fn part_two(lines []string) {
}

fn main() {
    lines := os.read_lines('input.txt') or { panic(err) }
    // lines := os.read_lines('test.txt') or { panic(err) }
    part_monkeys(lines, true, 20, false)
}
