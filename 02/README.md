# Notes

This one was really fun. I went for a computer math based approach and a bit of test-driven-development.

Rock Paper Scissors is a circular game:

```
        Rock
       /     \
Scissors --- Paper
```

If we replace the words with numbers we get a circular sequence as well
```
         0
       /   \ 
      2 ---  1
```

What creates circular sequences in math? The modulo operation!! It's a closure function that maps an integer Z to a number between [0, N-1] for any value N. In this case, our N is 3 (the number of possible values in the game). So we have:

```
0 % 3 = 0
1 % 3 = 1
2 % 3 = 2
3 % 3 = 0
4 % 3 = 1
5 % 3 = 2
6 % 3 = 0
...
```
Now, why does this matter at all?

The first part is telling us that we'll have the entry values for a game of RPS, and we need to determine if the second entry value was the winner or not and assign a value based on that (0 if lose, 3 if tie and 6 if win).

If we look at our game result values, they're just 0, 1m, and 2 times 3. Oh look, the modulo values!!

Alright, so there are only 9 combinations (3^2) of RPS so we can actually test them all and define what is the expected output:

```
winner(a, b) -> expected
```
Let's rewrite this with numbers. Where rock: 0, paper: 1, scissors: 2 and lose: 0, tie: 1, win: 2 (we'll multiply the result times 3 to get the actual value to take for the final score)

```
       a, b     c
winner(0, 0) -> 1
winner(0, 1) -> 2
winner(0, 2) -> 0

winner(1, 0) -> 0
winner(1, 1) -> 1
winner(1, 2) -> 2

winner(2, 0) -> 2
winner(2, 1) -> 0
winner(2, 2) -> 1
```

We can see a pattern. Let's take a look at the value `b` which is the one that changes for every value of `a`. We can write the output of the game as a modulo function of the value `b`

```
       a, b     c
winner(0, 0) -> 1   (b + 1) % 3 = (0 + 1) % 3 = 1
winner(0, 1) -> 2   (b + 1) % 3 = (1 + 1) % 3 = 2
winner(0, 2) -> 0   (b + 1) % 3 = (2 + 1) % 3 = 0

winner(1, 0) -> 0   (b + 0) % 3 = (0 + 0) % 3 = 0
winner(1, 1) -> 1   (b + 0) % 3 = (1 + 0) % 3 = 1
winner(1, 2) -> 2   (b + 0) % 3 = (2 + 0) % 3 = 2

winner(2, 0) -> 2   (b - 1) % 3 = (0 - 1) % 3 = 2
winner(2, 1) -> 0   (b - 1) % 3 = (1 - 1) % 3 = 0
winner(2, 2) -> 1   (b - 1) % 3 = (2 - 1) % 3 = 1
```

Before we move forward, the last one has a caveat. Depending on the programming language, having `-1 % 3` may yield different results. For example, in python, it maps correctly to 2 but in vlang it remains as `-1` so you may need to account for that.

Alright, back to the game. So far we have a function in the shape:

```
(b + diff) % 3 
```

For which the diff value is  `+1` , `+0` and `-1`.  We can use the value of a for that and calculate that differential as `1 - a`:

```
       a, b     c   diff = 1 - a = 1 - 0 = 1
winner(0, 0) -> 1   (b + diff) % 3 = (0 + 1) % 3 = 1
winner(0, 1) -> 2   (b + diff) % 3 = (1 + 1) % 3 = 2
winner(0, 2) -> 0   (b + diff) % 3 = (2 + 1) % 3 = 0

                    diff = 1 - a = 1 - 1 = 0
winner(1, 0) -> 0   (b + diff) % 3 = (0 + 0) % 3 = 0
winner(1, 1) -> 1   (b + diff) % 3 = (1 + 0) % 3 = 1
winner(1, 2) -> 2   (b + diff) % 3 = (2 + 0) % 3 = 2

                    diff = 1 - a = 1 - 2 = -1
winner(2, 0) -> 2   (b + diff) % 3 = (0 - 1) % 3 = 2
winner(2, 1) -> 0   (b + diff) % 3 = (1 - 1) % 3 = 0
winner(2, 2) -> 1   (b + diff) % 3 = (2 - 1) % 3 = 1
```

Tada! Now we have a function that determines the result of b in a game of RPS which is part one.

How do you get the numbers out of the characters provided (A, B, C, X, Y, Z)? Inherent ASCII.

In strongly typed languages a char can be directly casted to an int and that gives you the decimal numeric ASCII value for it. In other programming languages you have to specifically request that value (in python for example the function is `ord()`).

So A = 65, B = 66, C = 67, and X = 88, Y = 89, Z = 90. We can subtract 65 on the first value, and 88 on the second one to get a nice 0, 1 or 2 which are the inputs we expect in the `winner` function above.

The part two is very similar, with the difference that we'll have the expected result of the game and we need to calculate the complement to be played:

```
           a  b     c 
complement(0, 0) -> 2
complement(0, 1) -> 0
complement(0, 2) -> 1

complement(1, 0) -> 0
complement(1, 1) -> 1
complement(1, 2) -> 2

complement(2, 0) -> 1
complement(2, 1) -> 2
complement(2, 2) -> 0
```
I did exactly the same exercise for this and determined that the modulo function is also `(b + diff) % 3` with the value for the differential being the only difference as `a - 1` (in the first one it was `1 - a`)

Whew! That took a lot longer to elaborate than it took to code. In the solution source you can see the commented out test cases I wrote at the bottom.