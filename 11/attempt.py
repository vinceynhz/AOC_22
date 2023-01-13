"""
This was an attempt to come up with a numeric computational system to handle large, large numbers by representing a number by it's prime components.

Multiplying a number in this system is very straightforward as common primes are added, the problem is when adding two numbers as there doesn't seem
to be an easy rule on how the primes of the result can be defined from the primes of the components. 

While the code shown here is interesting for the exercise of it and thinking out of the box things, it did not work for the AoC puzzle :)
"""
import math
import sys

common_factors = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397]

def factorize(number : int, factors : map):
    working = number
    for p in common_factors:
        # print(f'Checking {p}')
        # print(f'{working} % {p} = {working % p}')
        while working % p == 0:
            working = int(working / p)
            if p in factors:
                factors[p] += 1
            else:
                factors[p] = 1
            # print(f'  {working} - {factors}')
        if working == 1:
            break
    return int(working)

class FNumber(object):
    def __init__(self, initial, factors = None):
        if factors is None:
            factors = {}
        self.num = factorize(initial, factors)
        self.factors = factors

    def mul_fac(self, factor):
        if factor in self.factors:
            self.factors[factor] += 1
        else:
            self.factors[factor] = 1
        return self

    def add(self, other: 'FNumber'):
        new_factors = {}
        other_factors = {}
        for k in other.factors:
            # check each factor of the other number
            if k in self.factors:
                # grab if we can to move to the new value
                new_factors[k] = other.factors[k]
                self.factors[k] -= other.factors[k]
                if self.factors[k] < 0:
                    new_factors[k] += self.factors[k]
                    other_factors[k] = other.factors[k] - new_factors[k]
                    del self.factors[k]
            else:
                other_factors[k] = other.factors[k]
        self_num = self.realize()
        other_num = other.num 
        other_expanded = [k**other_factors[k] for k in other_factors]
        for i in other_expanded:
            other_num *= i
        self.num = factorize(other_num + self_num, new_factors)
        self.factors = new_factors
        return self

    def square(self):
        # square existing factors
        self.factors = { k: self.factors[k]*2 for k in self.factors}
        self.num = factorize(self.num**2, self.factors)
        return self

    def realize(self):
        expanded = [k**self.factors[k] for k in self.factors]
        result = self.num
        for i in expanded:
            result *= i
        return result

    def test(self, value):
        return value in self.factors

    def __repr__(self):
        return str(self.realize())

class Monkey(object): 
    def __init__(self, ind, items, op, test, if_true, if_false, wf = False):
        self.ind = ind
        if wf:
            self.items = [FNumber(i) for i in items]
        else:
            self.items = items
        self.op = op
        self.test = test
        self.if_true = if_true
        self.if_false = if_false
        self.inspections = 0
        self.wf = wf
    
    def inspect(self, item):
        # if not self.wf:
            # print(f'{self.ind} - {item % self.test} - {self.test}')
        old = item % self.test
        new = self.op(old)
        if self.wf:
            test = new.test(self.test)
        else:
            # print(f'{self.ind} - {new % self.test} - {self.test}')
            test = new % self.test == 0
        self.inspections += 1
        return new, test


def part_two(wf = False, stop = 0):
    m0 = [79, 98]
    m1 = [54, 65, 75, 74]
    m2 = [79, 60, 97]
    m3 = [74]
    m0 = [79]
    # m1 = []
    # m2 = []
    # m3 = []

    monkeys = []
    defaults = [ FNumber(i) for i in range(1, 10) ]
    if wf:
        monkeys.append(Monkey(len(monkeys), m0, lambda x: x.mul_fac(19),      23, 2, 3, True))
        monkeys.append(Monkey(len(monkeys), m1, lambda x: x.add(defaults[5]), 19, 2, 0, True))
        monkeys.append(Monkey(len(monkeys), m2, lambda x: x.square(),         13, 1, 3, True))
        monkeys.append(Monkey(len(monkeys), m3, lambda x: x.add(defaults[2]), 17, 0, 1, True))
    else:
        monkeys.append(Monkey(len(monkeys), m0, lambda x: x*19,   23, 2, 3, False))
        monkeys.append(Monkey(len(monkeys), m1, lambda x: x+6,    19, 2, 0, False))
        monkeys.append(Monkey(len(monkeys), m2, lambda x: x*x,    13, 1, 3, False))
        monkeys.append(Monkey(len(monkeys), m3, lambda x: x+3,    17, 0, 1, False))
        

    for rnd in range(1, 10000 + 1):
        for monkey in monkeys:
            print(f'm{monkey.ind} = {monkey.items}')
            for item in monkey.items:
                new, test = monkey.inspect(item)
                if test:
                    monkeys[monkey.if_true].items.append(new)
                else:
                    monkeys[monkey.if_false].items.append(new)
            monkey.items = []
        if rnd == 1 or rnd == 15 or rnd == 20 or rnd % 1000 == 0:
            print(f"== After round {rnd} ==")
            for monkey in monkeys:
                print(f'Monkey {monkey.ind} inspected items {monkey.inspections} times')
            print()
        else:
            print(f"== Round {rnd} ==")
        if stop > 0 and rnd == stop:
            break

    for monkey in monkeys:
        print(f'm{monkey.ind} = {monkey.inspections}')
    for monkey in monkeys:
        print(f'm{monkey.ind} = {monkey.items}')

if __name__ == '__main__':
    wf = False
    stop = 0
    if len(sys.argv) == 3:
        stop = int(sys.argv[1])
        wf = sys.argv[2] == '-f'
    part_two(wf, stop)
