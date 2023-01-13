/*
Similar to attempt.py this program was an attempt to come up with a numeric computational 
system to handle large, large numbers by representing a number by it's prime components.

It did not work :) 
*/
import os

enum Op {
    noop
    sum
    mul
}

// pow returns base raised to power (a**b) as an integer (i64)
//
// special case:
// pow(a, b) = -1 for a = 0 and b < 0
pub fn pow(a u64, b int) u64 {
    mut b_ := b
    mut p := a
    mut v := u64(1)

    if b_ < 0 { // exponent < 0
        if a == 0 {
            panic("Division by zero")
            // return -1 // division by 0
        }
        return if a * a != 1 {
            u64(0)
        } else {
            if (b_ & 1) > 0 {
                a
            } else {
                u64(1)
            }
        }
    }

    for ; b_ > 0; {
        if b_ & 1 > 0 {
            v *= p
        }
        p *= p
        b_ >>= 1
    }

    return v
}

const common_factors = [u64(2), 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397]

fn factorize(num u64, mut factors map[u64]int) u64 {
    mut working := num
    for p in common_factors {
        for working % p == 0 {
            working = working / p
            if p in factors {
                factors[p] += 1
            } else {
                factors[p] = 1
            }
        }
        if working == 1 {
            break
        }
    }
    return working
}

struct Fac {
mut:
    num         u64
    factors     map[u64]int = map[u64]int{}
}

fn new_fac(num int) Fac {
    mut factors := map[u64]int{}
    mut n := factorize(u64(num), mut factors)
    return Fac {
        num: n
        factors: factors
    }
}

fn (mut self Fac) set(num u64) {
    self.factors.clear()
    self.num = factorize(num, mut self.factors)
}

fn (mut self Fac) mul(factor u64) {
    if factor !in common_factors {
        panic("Unknown factor")
    }
    if factor in self.factors {
        self.factors[factor]++
    } else {
        self.factors[factor] = 1
    }
}

fn (mut self Fac) add(other Fac) {
    // println('\n>>>>Adding ${self.realize()} + ${other.realize()}')
    // println('Self ${self.num} ${self.factors}')
    // println('Other ${other.num} ${other.factors}')
    mut new_factors := map[u64]int{}
    mut other_factors := map[u64]int{}
    for k, v in other.factors {
        // println('\n--- ${k}, ${v}')
        if k in self.factors {
            new_factors[k] = v
            // println('New factors: ${new_factors}')
            self.factors[k] -= v
            // println('Self factors: ${self.factors}')
            if self.factors[k] < 0 {
                new_factors[k] += self.factors[k]
                other_factors[k] = v - new_factors[k]
                self.factors.delete(k)
                // println('  New factors: ${new_factors}')
                // println('  Other factors: ${other_factors}')
                // println('  Self factors: ${self.factors}')
            } 
        } else {
            other_factors[k] = v
            // println('Other factors: ${other_factors}')
        }
    }
    // println('\nOther factors: ${other_factors}')
    // println('New factors: ${new_factors}')
    self_num := self.realize()
    // println('Self num: ${self_num}')
    mut other_num := other.num
    // println('Other num: ${other_num}')
    for k, v in other_factors {
        pow_result := pow(k, v) 
        // println(' factor ${k} ** ${v}')
        other_num *= pow_result
        // println(' other_num ${other_num}')
    }
    // println('Other num: ${other_num}')
    self.num = factorize(other_num + self_num, mut new_factors)
    // println('New num: ${self.num}')
    // println('New factors: ${new_factors}')
    self.factors = new_factors.clone()
    // println('New self factors: ${self.factors}')
    // println('New number: ${self.realize()}')
}

fn(mut self Fac) square() {
    for k, v in self.factors {
        self.factors[k] = v*2
    }
    self.num = factorize(self.num * self.num, mut self.factors)
}

fn(self Fac) realize() u64 {
    mut result := self.num
    for k, v in self.factors {
        result *= pow(k, v)
    }
    return result
}

fn (self Fac) test(factor u64) bool {
    return factor in self.factors
}

fn (self Fac) repr() string {
    return '${self.realize()}'
}

struct Monkey {
    id          int
mut:
    items       []Fac  = []Fac{}
    operation   Op     = .noop
    val_add     Fac    = Fac{}
    val_mul     u64
    test        u64
    if_true     int    = -1
    if_false    int    = -1
    inspections u64
}

fn (mon Monkey) repr() string {
    items := "[${mon.items.map(it.repr()).join(', ')}]"
    mut val := ""
    if mon.operation == .sum {
        val = mon.val_add.repr()
    } else if mon.operation == .mul {
        val = '${mon.val_mul}'
    }
    return 'Monkey ${mon.id} - ${mon.inspections} - ${mon.operation} by ${val} - ${mon.test} t:${mon.if_true} f:${mon.if_false} - ${items}'
}


// fn (mon Monkey) inspect(mut worry i64, relief bool, verbose bool) i64 {
//     mut new := Fac{}
//     mut operand := mon.val

//     if verbose {
//         println('  inspecting ${worry}')
//     }

//     if operand == i64(0) {
//         operand = worry
//     }

//     if mon.operation == .mul {
//         new = worry.mul(operand)
//     } else if mon.operation == .sum {
//         new = worry.add(operand)
//     } else {
//         panic('Wrong operand')
//     }
//     if verbose {
//         println('  worry level ${mon.operation} by ${operand} to ${new}')
//     }
//     if relief {
//         new /= 3
//         if verbose {
//             println('  monkey bored, dividing by 3 to ${new}')
//         }
//     }
//     return new
// }

fn (mon Monkey) inspect(mut item Fac) {
    if mon.operation == .mul {
        if mon.val_mul == u64(0) {
            item.square()
        } else {
            item.mul(mon.val_mul)
        }
    } else if mon.operation == .sum {
        item.add(mon.val_add)
    } else {
        panic('Wrong operand')
    }
}

fn fparse(lines []string) []Monkey {
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
            result.last().items << line.split(': ')[1].split(', ').map( new_fac(it.int()) )
        } else if line[2] == 79 {
            // we define operation and value
            if line[23] == 42 {
                // mult
                result.last().operation = .mul
                result.last().val_mul = u64(line[25..].int())
            } else if line[23] == 43 {
                // sum
                result.last().operation = .sum
                result.last().val_add = new_fac(line[25..].int())
            } else {
                panic("unkown operation")
            }
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

// fn part_one(lines []string, relief bool, rounds int, verbose bool) {
//     mut monkeys := parse(lines)

//     for round in 1 .. rounds + 1 {
//         if verbose {
//             println('Round ${round}')
//         }
//         for mut monkey in monkeys {
//             if verbose {
//                 println(monkey.repr())
//             }
//             for item in monkey.items {
//                 if item < 0 {
//                     panic("we doubled ${round}, ${monkey.id}, ${item}")
//                 }
//                 new := monkey.inspect(item, relief, verbose)
//                 if verbose {
//                     println('  increasing inspections')
//                 }
//                 monkey.inspections++
//                 if new % monkey.test == 0 {
//                     // throw to this monkey
//                     if verbose {
//                         println('  worry level is divisible by ${monkey.test}')
//                         println('  worry level ${new} is thrown to ${monkey.if_true}')
//                     }
//                     monkeys[monkey.if_true].items << new
//                 } else {
//                     if verbose {
//                         println('  worry level not divisible by ${monkey.test}')
//                         println('  worry level ${new} is thrown to ${monkey.if_false}')
//                     }
//                     monkeys[monkey.if_false].items << new
//                 }
//             }
//             // monkey has no more items
//             monkey.items.clear()
//             if verbose {
//                 println('all items have been cleared: ${monkey.items}\n')
//             }
//         }
//         if round == 1 || round == 20 || round % 1000 == 0 {
//             println("== After round ${round} ==")
//             for monkey in monkeys {
//                 println('Monkey ${monkey.id} inspected items ${monkey.inspections} times')
//             }
//         }
//         // if round == 20 {
//         //     break
//         // }
//     }

//     println('\n')

//     mut act_1 := i64(0)
//     mut act_2 := i64(0)
//     for monkey in monkeys {
//         println(monkey.repr())
//         if monkey.inspections > act_1 {
//             act_1, act_2 = monkey.inspections, act_1
//         } else if monkey.inspections > act_2 {
//             act_2 = monkey.inspections
//         }
//     }

//     println('Total: ${act_1 * act_2}')
// }

fn part_two(lines []string, rounds int) {
    mut monkeys := fparse(lines)

    // for monkey in monkeys {
    //     println(monkey.repr())
    // }

    for round in 1 .. rounds + 1 {
        for mut monkey in monkeys {
            println('m${monkey.id} = [${monkey.items.map(it.repr()).join(', ')}]')
            for mut item in monkey.items {
                monkey.inspect(mut item)
                monkey.inspections++
                if item.test(monkey.test) {
                    monkeys[monkey.if_true].items << item
                } else {
                    monkeys[monkey.if_false].items << item
                }
            }
            // monkey has no more items
            monkey.items.clear()
        }
        if round == 1 || round == 15 || round == 20 || round % 1000 == 0 {
            println("== After round ${round} ==")
            for monkey in monkeys {
                println('Monkey ${monkey.id} inspected items ${monkey.inspections} times')
            }
            println('')
        } else {
            println("== Round ${round} ==")
        }
        if round == 20 {
            break
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
    // lines := os.read_lines('input.txt') or { panic(err) }
    lines := os.read_lines('test.txt') or { panic(err) }
    // part_one(lines, true, 20, false) // 55216
    // println('')
    part_two(lines, 10000)

    // mut val := new_fac(3600)
    // println(val.num)
    // println(val.factors)
    // println(val.repr())
    // println('')

    // three := new_fac(3)
    // println(three.num)
    // println(three.factors)
    // println(three.repr())
    // println('')

    // val.add(three)
    // println(val.num)
    // println(val.factors)
    // println(val.repr())

}

