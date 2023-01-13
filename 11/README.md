# Notes

Monkeys... The first part of this problem went without a problem. The algorithm was clear and easy to implement.

The problem came on the second part. 

Without the division of the worry level, the number grows big really quick (in the end, some Monkey's square the number).

I think I haven't mentioned that I worked on the challenges every night right when they would become available.

At this point, it was past midnight and I tried different approaches to solve this problem. 

The first, most obvious one was to increase the size of the datatype I was using, from `int` to `u64` (unsigned integer of 64 bits), however that still didn't work, the processing was slowing down as the numbers grew larger and the numbers were cycling (reached the maximum number available in `u64` and continued around)

My second approach was to try to divide and conquer. Instead of processing the queue of each Monkey sequentially, I'd create a task for each one of them and then wait on the processing to be done before adding them to the target Monkeys.

This moved slightly faster but still nowhere close to the target iteration.

While analyzing the problem, my wife noticed that the numbers the Monkeys where testing against where prime numbers, so we started thinking down that path.

Given that numbers were growing large, my new thought was to factorize the number into it's prime components. So I build some data structures that allowed me to hold a map of which prime numbers were part of the number and how many times the prime number needed to be factored into the final large number.

With this new numeric system, we could do multiplications, powers and the divisibility test, but it wouldn't necessarily work for the addition.

I could not fathom a proper rule that would allow me to add two numbers by only knowing their prime factors without having to calculate the large number first, and then add.

By this point I put the problem to sleep, and did the same with myself since it was already 4am. Interestingly, this day was the last one on a winter vacation so we had to be on our way by 10am which was an ordeal with only a couple of hours of sleep.

I spent the rest of the day trying to come up with a better strategy, I felt that there was something simple I was missing, some mathematical property that was eluding me. 

While I was checking the differences on number capacity in python, excel and V, my wife was also checking on more properties of prime numbers. Eventually we got to [Fermat's Little Theorem](https://en.wikipedia.org/wiki/Fermat's_little_theorem):

> Fermat's little theorem states that if `p` is a prime number, then for any integer `a`, the number $a^{p}-a$ is an integer multiple of `p`. In the notation of modular arithmetic, this is expressed as
> $$a^{p}\equiv{a}\pmod{p}$$
> For example, if $a = 2$ and $p = 7$ then $2^7 = 128$, and $128 − 2 = 126 = 7 × 18$ is an integer multiple of 7.
>
> If `a` is not divisible by `p`, that is if `a` is coprime to `p`, Fermat's little theorem is equivalent to the statement that $a^{p − 1}−1$ is an integer multiple of `p`, or in symbols:
> $$a^{p-1}\equiv{1}\pmod{p}$$
> For example, if $a = 2$ and $p = 7$, then $26 = 64$, and $64 − 1 = 63 = 7 × 9$ is thus a multiple of 7.

But even with this I was still not able to apply it to the problem.

So I started checking properties of the modulo, and I had this realization. If I were to write out one of the Monkey's operation it would look more or less like this:

```
Initial value: 79
Monkey operation: n * 19
Test: divsible by 23

79 * 19 = 1501

if 1501 % 23 == 0 then go to X Monkey, else go to Y Monkey

In this case, 1501 % 23 = 6
```

If I were to take the modulo operation and apply it to the input before the Monkey's operation, I would get the same result:

```
Initial value: 79
Monkey operation: n * 19
Test: divsible by 23

79 % 23 = 10
10 * 19 = 190
190 % 23 = 6
```

It may seem too cumbersome to add one more modulo before applying the Monkey's operation but if we look, by doing this extra modulo our input for the operation is significantly smaller than the original case.

And yet I was still not seeing the final part that eventually clicked.

The problem is that I could not apply a modulo only of 23, that is the test value for one Monkey from the test data. What about the rest of the Monkeys? I cannot apply it on this Monkey and expect it to work on the next Monkey. And each Monkey doesn't know what's the next value for all other Monkeys...

But all the divisibility tests are done against prime numbers... All prime numbers are coprime among them (only common divisor is 1)... Limiting the input by modulo seems reasonable, but modulo against what? Against all the divisibility test numbers!!!

EUREKA!! Well, the Eureka did not happen until after I got the right solution.

The catch is to multiply all of the divisibility test numbers to preserve the coprimality among them giving us both, a number that is still within computable limits and a number that preserves the properties of divisibility.

